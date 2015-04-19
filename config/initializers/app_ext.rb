
#中英文字符 长度验证 英文按照半个中文处理
class String

  #中文字符串长度 > 指定长度
  def is_chinese_longer(sum, omission_bytesize=0)
    bsize = sum * 2
    tsize = bsize - omission_bytesize
    l = i = 0
    out = nil
    is_longer = false
    self.each_char do |word|
      w = word.bytesize>1 ? 2 : 1
      xsize = l + w
      if xsize > tsize
        out ||= i
        if xsize > bsize
          is_longer = true
          break
        end
      end

      i += 1
      l += w
    end

    is_longer && out
  end

  #中文字符串长度 <= 指定长度
  def is_chinese_shorter(sum)
    !is_chinese_longer(sum)
  end

  def chinese_bytesize
    sum = 0
    self.each_char do |word|
      w = word.bytesize>1 ? 2 : 1
      sum += w
    end
    sum
  end

  def chinese_size
    sum,remain = self.chinese_bytesize.divmod(2)
    sum += 1 if remain > 0
    sum
  end

  def chinese_truncate(truncate_at, options = {})
    if (omission = options[:omission])
      ol = omission.chinese_bytesize
    elsif omission==false
      omission = ''
      ol = 0
    else
      omission = '...'
      ol = 3
    end
    if i = self.is_chinese_longer(truncate_at,ol)
      head = self[0, i]
      head + omission
    else
      self
    end
  end
end

# 40.percent_of_the_time do
class Fixnum
  def percent_of_the_time(&block)
    yield if (Kernel.rand(100)+1) <= self
  end
end

# (3..6).times do
class Range
  def times(&block)
    Random.rand(self).times(&block)
  end
end

class Object
  def confirm
    self if self
  end
end

class TrueClass
  def to_i
    1
  end
end

class FalseClass
  def to_i
    0
  end
end
