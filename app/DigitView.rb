class DigitView < UIView
  # View to show a single digit that looks like a flip clock digit
  def initWithFrame(frame)
    super

    backgroundImage = UIImage.imageNamed('digit_background')
    @backgroundView = UIImageView.alloc.initWithImage(backgroundImage)
    self.addSubview(@backgroundView)

    @valueLabel = UILabel.new
    @valueLabel.font = UIFont.fontWithName('HelveticaNeue-CondensedBold', size:42)
    @valueLabel.textColor = UIColor.whiteColor
    @valueLabel.backgroundColor = UIColor.clearColor
    @valueLabel.textAlignment = UITextAlignmentCenter
    self.addSubview(@valueLabel)

    # a small image to cover the digit and make it look like a flip digit
    barImage = UIImage.imageNamed('counter_overlay_bar')
    @barView = UIImageView.alloc.initWithImage(barImage)
    self.addSubview(@barView)
  end

  def layoutSubviews
    super
    @valueLabel.frame = [[0, 3], [39, 41]]
    @barView.frame = [[0, 20], @barView.bounds.size]
  end


  def setValue(value)
    @valueLabel.text = value
  end

end