def replace_keyword(origin_str, keyword, value):
    return origin_str.replace('${' + keyword + '}', value)