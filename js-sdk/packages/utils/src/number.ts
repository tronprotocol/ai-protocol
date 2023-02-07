export const toThousands = (num: any) => {
  let NUM = (num || 0).toString();
  let arr = NUM.split('.');
  let number = (arr[0] || 0).toString(),
    result = '';
  while (number.length > 3) {
    result = ',' + number.slice(-3) + result;
    number = number.slice(0, number.length - 3);
  }
  if (number) {
    if (arr[1]) {
      result = number + result + '.' + arr[1];
    } else {
      result = number + result;
    }
  }
  return result;
}

export const cutMiddle = (text = '', left = 4, right = 4) => {
    if (text.length <= left + right) return text;
    return `${text.substr(0, left).trim()}...${text.substr(-right)}`;
};

export const numberParser = (str: string, decimal: undefined) => {
    str = String(str);
    if (!str) return { valid: true, str: '' };

    let reg = new RegExp(`^(\\d+)(\\.\\d*)?$`);
    if (decimal !== undefined) {
        reg = new RegExp(`^(\\d+)(\\.\\d{0,${decimal}})?$`);
    }

    if (!reg.test(str)) {
        return { valid: false, str: '' };
    } else {
        return { valid: true, str: str.replace(/^0+(\d)/g, '$1') };
    }
};
