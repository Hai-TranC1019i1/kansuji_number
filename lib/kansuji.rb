# TODO: implement
KANSUJI_DICT = {"那由多": 10 ** 72, "無量大数": 10 ** 68, "不可思議": 10 ** 64, "那由他": 10 ** 60, "阿僧祇": 10 ** 56, '恒河沙': 10**52, '極': 10**48, '載': 10**44, '正': 10**40, '澗': 10**36,'溝': 10**32, '穣': 10**28, '𥝱': 10**24, '垓': 10**20, '京': 10**16,'兆': 10**12, '億': 10**8, '万': 10_000, '千': 1000, '百': 100, '十': 10, '九': 9,'八': 8, '七': 7, '六': 6, '五': 5, '四': 4, '三': 3, '二': 2, '一': 1, '零': 0}.freeze

class Numeric
  def to_kansuji
    return '零' if self == KANSUJI_DICT[:零]
    tens, unit_numbers = {}, {}
    number = self.to_s
    KANSUJI_DICT.each { |k, v| tens[v.to_s.length.to_s] = k.to_s }
    KANSUJI_DICT.each { |k, v| unit_numbers[v.to_s] = k.to_s if v < 10 }
    unit_numbers['0'], tens['1'], result = '', '', ''
    number.split('').each_with_index do |char, i|
      flag = number.length - i
      until tens.key? flag.to_s
        tens.each_key do |k|
          if flag > k.to_i
            flag = flag - k.to_i + 1
            break
          end
        end
      end
      result << unit_numbers[char] if (flag > 4) || char.to_i > 1 || i == number.length - 1
      result << tens[flag.to_s] if char != 0.to_s ||(tens.key(result[-1]) && flag >= tens.key(result[-1]).to_i)
    end
    result
  end
end
# ["", "十", "二", "万", "三", "千", "四", "百", "五十", "六"]
class String
  def to_number result = 0, flag = 0, temp = []
    return 0 if self == '零'
    temp = self.split(',') if KANSUJI_DICT.each { |key, val| self.gsub!(key.to_s,',\&') }
    max = temp.select { |char| char != '' && KANSUJI_DICT[char.to_sym] > 1000 }
    max << KANSUJI_DICT.key(1).to_s
    temp[1] == KANSUJI_DICT.key(1).to_s ? temp.shift : temp[0] = KANSUJI_DICT.key(1).to_s
    temp.each_with_index do |char, i|
      flag += 1 if max[flag] == char
      next if KANSUJI_DICT[char.to_sym] >= 10
      fact = i < temp.length - 1 ? KANSUJI_DICT[temp[i + 1].to_sym] : 1
      result_temp = KANSUJI_DICT[char.to_sym] * fact
      if fact == KANSUJI_DICT[max[flag].to_sym]
        result += result_temp
        next
      else result += result_temp * KANSUJI_DICT[max[flag].to_sym]
      end
    end
    result
  end
end

p '一億二十七万'.to_number
p '十二万三千四百五十六'.to_number
p '一那由多'.to_number
p (10**105).to_kansuji  #千正/ 百澗恒河沙
p 123456001.to_kansuji #一億二千三百四十五万六千一
p 11000.to_kansuji     #一万千
p 10201031.to_kansuji