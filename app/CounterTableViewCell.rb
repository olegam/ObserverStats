class CounterTableViewCell < UITableViewCell

  NumDigits = 7
  DigitSpacing = 3

  def initWithStyle(style, reuseIdentifier:identifier)
    super

    @backgroundImage = UIImage.imageNamed('counter_frame')
    self.backgroundView = UIImageView.alloc.initWithImage(@backgroundImage)

    @nameLabel = UILabel.new
    @nameLabel.font = UIFont.fontWithName('HelveticaNeue-CondensedBold', size:28)
    @nameLabel.textColor = UIColor.whiteColor
    @nameLabel.backgroundColor = UIColor.clearColor
    @nameLabel.textAlignment = UITextAlignmentCenter
    self.addSubview(@nameLabel)

    @digitViews = []
    (0..NumDigits-1).each do |idx|
      digitFrame = [[266-(idx*(39+DigitSpacing)), 14.5], [39, 47]]
      digitView = DigitView.alloc.initWithFrame(digitFrame)
      self.addSubview(digitView)
      @digitViews << digitView
    end
    self
  end

  def layoutSubviews
    super
    @nameLabel.frame = [[35, 64], [260, 36]]
    self.backgroundView.frame = [[5, 5], @backgroundImage.size]
  end

  def setIntegerValue(value)
    formatStr = '%%0%dd' % NumDigits
    str = formatStr % value
    @digitViews.each_index do |idx|
      digitView = @digitViews[idx]
      subStr = str[NumDigits-idx-1...NumDigits-idx]
      digitView.value = subStr
    end
  end

  def setName(name)
    @nameLabel.text = name
  end

end