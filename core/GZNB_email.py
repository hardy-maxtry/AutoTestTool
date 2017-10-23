from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr, formataddr
import smtplib

SMTP_SERVER = 'smtp.gznb.com'
SMTP_SERVER_PORT = 25


def _format_addr(s):
    name, addr = parseaddr(s)
    # print("name:" + name + " addr:" + addr)
    # print(Header(name, 'utf-8').encode() if name != '' else Header(addr))
    if name == '':
        name = addr
    return formataddr(( \
        Header(name, 'utf-8').encode(), \
        # addr.encode('utf-8') if isinstance(addr, unicode) else addr)
        addr)
        )

def send_email(email_from, email_to, email_subject, email_body, email_body_type):
    """
    封装了发送邮件功能
        :param email_from: 邮箱地址，或者， '"名字" <邮箱地址>'
        :param email_to: 邮箱地址，或者， '"名字" <邮箱地址>'，或者可以传入符合这个格式的list
        :param email_subject: 邮件标题
        :param email_body: 邮件正文，可以是字符串或者html
        :param email_body_type: plain: 字符串， html: 页面
    """
    msg = MIMEText(email_body, email_body_type, 'utf-8')
    from_name, from_addr = parseaddr(email_from)
    msg['From'] = _format_addr(email_from)
    to_addr_list = []
    if type(email_to) == list:
        for tmp_email_to in email_to:
            to_name, to_addr = parseaddr(tmp_email_to)
            to_addr_list.append(to_addr)
            
    else:
        to_name, to_addr = parseaddr(email_to)
        to_addr_list.append(to_addr)
        
    msg['Subject'] = Header(email_subject, 'utf-8').encode()
    msg['To'] = ','.join(to_addr_list)
    server = smtplib.SMTP(SMTP_SERVER, SMTP_SERVER_PORT)
    # 需要调试的话设置成1
    server.set_debuglevel(0)
    server.sendmail(from_addr, to_addr_list, msg.as_string())
    server.quit()

if __name__ == "__main__":
    body = """
    <html>

    <body>

    <h4>Feature：</h4>  
    <table border="1">
    <tr>
    <td>First</td>
    <td>Row</td>
    </tr>   
    <tr>
    <td>Second</td>
    <td>Row</td>
    </tr>
    </table>

    </body>
    </html>
    """
    # send_email('"autotest" <autotest@gznb.com>', ['linfang@gznb.com','sujunxuan@gznb.com'],'测试标题', '测试正文','plain')
    send_email('"autotest" <autotest@gznb.com>', ['linfang@gznb.com','sujunxuan@gznb.com'],'测试标题', body,'html')
    pass