import configparser
import os
import time
import json
from core import GZNB_request, GZNB_report,GZNB_email
#import win32com.client as win32

CURRENT_DIRECTORY = os.getcwd()
FORMAT = '%Y-%m-%d_%H-%M-%S'



def outlook(body):
    cur_dir=os.getcwd()
    CONFIGULE = cur_dir+'\\features\\env.config'
    config = configparser.ConfigParser()
    config.read(CONFIGULE)
    receivers = str(config.get('emailInfo','Mailto')).split(',')
    title =config.get('emailInfo','Title')
    for i in range(len(receivers)):
        outlook = win32.Dispatch('outlook.application')
        mail = outlook.CreateItem(0)
        mail.To = receivers[i]
        mail.Subject =title
        mail.Body = body
        mail.Send()

def before_all(context):

    CONFIGFILE= CURRENT_DIRECTORY + "\\features\\env.config"

    #print(CONFIGFILE)
    config=configparser.ConfigParser()
    config.read(CONFIGFILE,encoding='utf-8')
    curr_env = config.get('test_env','env')
    context.env = curr_env
    context.config = config

    context.parameters = dict()
    
    # print(context.config.get('api_list','cities_json'))

    context.report = GZNB_report.GZNB_report('test start','test start')

def after_all(context):
    context.report.set_end()
    log_folder = CURRENT_DIRECTORY + '\\log'
    time_str = time.strftime(FORMAT, time.localtime(time.time()))
    file_name = log_folder + '\\test_'  + time_str + '.json'
    # print(file_name)
    log_file = open(file_name, 'w', encoding='utf-8')
    # print(context.report.get_report())
    log_file.write(json.dumps(context.report.get_report()).encode('utf-8').decode('unicode_escape'))
    log_file.close()
    cur_dir=os.getcwd()
    CONFIGULE = cur_dir+'\\features\\env.config'
    config = configparser.ConfigParser()
    config.read(CONFIGULE,encoding='utf-8')
    receivers = str(config.get('emailInfo','Mailto')).split(',')
    titlelist =str(config.get('emailInfo','Title')).split(";")
    if simpleDetailHTML(file_name)[2]:
        title =titlelist[0]+"__"+time_str
    else:
        title = str(titlelist[1]).replace('Num',str(simpleDetailHTML(file_name)[1])).replace('Total',str(simpleDetailHTML(file_name)[3]))+"__"+time_str
    GZNB_email.send_email('"autotest" <autotest@gznb.com>', receivers,title, simpleDetailHTML(file_name)[0],'html')


def before_tag(context, tag):
    if tag.lower() == 'api':
        context.request = GZNB_request.GZNB_request()

def after_tag(context, tag):
    if tag.lower() == 'api':
        context.request = None


def before_feature(context, feature):
    context.feature_report = GZNB_report.GZNB_report('feature', feature.name)

def after_feature(context, feature):
    if feature.status == 'failed':
        context.feature_report.set_status('failed')
        context.report.add_sub_failed()
    else:
        context.report.add_sub_passed()
    context.feature_report.set_end()
    context.report.add_sub_report(context.feature_report)
    
    context.feature_report = None

def before_scenario(context, scenario):
    context.scenario_report = GZNB_report.GZNB_report('scenario', scenario.name)

def after_scenario(context, scenario):
    # if scenario.status == 'failed':
    #     print(context.request.get_res().text)
    if scenario.status == 'failed':
        context.scenario_report.set_status('failed')
        context.feature_report.add_sub_failed()
    else:
        context.feature_report.add_sub_passed()
    context.scenario_report.set_end()
    context.feature_report.add_sub_report(context.scenario_report)
    # print('feature_report 的sub report 长度: ' + str(len(context.feature_report.sub_report)))
    context.scenario_report = None


def before_step(context, step):
    context.step_report = GZNB_report.GZNB_report('step', step.name)

def after_step(context, step):
    if step.status == 'failed':
        context.step_report.set_status('failed')
        context.step_report.set_detail(step.error_message.replace('"',"'").replace('\n','<br>'))
        context.scenario_report.add_sub_failed()
    else:
        context.scenario_report.add_sub_passed()
    context.step_report.set_end()
    context.scenario_report.add_sub_report(context.step_report)
    
    # print('scenario_report 的sub report 长度: ' + str(len(context.scenario_report.sub_report)))
    context.step_report = None

    # if scenario.status == 'failed':
    #     print(context.request.get_res().text)
    #     outlook(context.request.get_res().text)

def simpleDetail(location):
    Detail = open(location,'r',encoding='utf-8')
    SimpleDetail =dict(eval(Detail.read()))['sub_report'][0]['sub_report']
    i = 0
    j = 0
    SimpleDetailInfo =''
    for i in range(len(SimpleDetail)):
        SimpleDetailInfo = SimpleDetailInfo+'Scenario : '+SimpleDetail[i]['log_name']+'\r\n'+'Status : '+SimpleDetail[i]['log_status']+'\r\n'
        for j in range(len(SimpleDetail[i]['sub_report'])):
            if str(SimpleDetail[i]['sub_report'][j]['log_status']) =='failed':
                SimpleDetailInfo = SimpleDetailInfo + 'Step : '+SimpleDetail[i]['sub_report'][j]['log_name']+'\r\n'+'Detail : '+str(SimpleDetail[i]['sub_report'][j]['log_detail']).replace('<br>','')+'\r\n'
        SimpleDetailInfo =SimpleDetailInfo+'\r\n'
    return SimpleDetailInfo

def simpleDetailHTML(location):
    message = """<html><head></head><body><h1>Testing Report</h1>"""
    Seneriomodel = """<tr><td>Scenario</td><td></td><td>ScenarioInfoInstead</td><td>StatusInfoIstead</td><td></td></tr>"""
    Stepmodel ="""<tr><td></td><td>Step</td><td>StepInfoInstead</td><td>StatusInfoIstead</td><td>NoteInfoIstead</td></tr>"""
    Featuremodel="""<h4>Feature ：FeatureInfoInstead</h4><table border="1">"""
    Detail = open(location,'r',encoding='utf-8')
    a =Detail.read()
    SimpleDetail = dict(eval(a))['sub_report']
    message = message+"""<h4>Start : StartInstead</h4><h4>End : EndInstead</h4>""".replace('StartInstead',str(dict(eval(a))['start'])).replace('EndInstead',str(dict(eval(a))['end']))
    i = 0
    j =0
    k =0
    num = 0
    Total =0
    for k in range(len(SimpleDetail)):
        message =message+'\r\n'+Featuremodel.replace('FeatureInfoInstead',SimpleDetail[k]['log_name'])
        for i in range(len(SimpleDetail[k]['sub_report'])):
            Total = Total+1
            if str(SimpleDetail[k]['sub_report'][i]['log_status']).upper() =='PASSED':
                message = message +'\r\n'+Seneriomodel.replace('ScenarioInfoInstead',SimpleDetail[k]['sub_report'][i]['log_name']).replace('StatusInfoIstead','<font color="#008000">Passed</font>')
            else:
                message = message +'\r\n'+Seneriomodel.replace('ScenarioInfoInstead',SimpleDetail[k]['sub_report'][i]['log_name']).replace('StatusInfoIstead','<font color="#FF0000">Failed</font>')
                num = num+1
            for j in range(len(SimpleDetail[k]['sub_report'][i]['sub_report'])):
                if str(SimpleDetail[k]['sub_report'][i]['sub_report'][j]['log_status']).upper() =='PASSED':
                    message =message+'\r\n'+Stepmodel.replace('StepInfoInstead',SimpleDetail[k]['sub_report'][i]['sub_report'][j]['log_name']).replace('StatusInfoIstead','<font color="#008000">Passed</font>').replace('NoteInfoIstead','')
                else:
                    message =message+'\r\n'+Stepmodel.replace('StepInfoInstead',SimpleDetail[k]['sub_report'][i]['sub_report'][j]['log_name']).replace('StatusInfoIstead','<font color="#FF0000">Failed</font>').replace('NoteInfoIstead',str(SimpleDetail[k]['sub_report'][i]['sub_report'][j]['log_detail']))
        message =message+'\r\n'+"""</table></body></html>"""
    if num != 0:
        Status = False
    else:
        Status = True

    return (message,num,Status,Total)
if __name__ == "__main__":
    simpleDetail(r'C:\git\gznb_autotest\log\test_2017-10-15_09-42-00.json')

