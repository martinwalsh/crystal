module AllYourBase
  extend self

  def rebase(from_base, digits, to_base)
    raise ArgumentError.new "Invalid base" if [from_base, to_base].any? { |b| b <= 1 }
    raise ArgumentError.new "Invalid digits" if digits.any? { |n| n >= from_base || n < 0 }

    exponents = (digits.size - 1).downto(0).to_a
    number = digits.zip(exponents).map { |d, e| d * from_base ** e }.sum

    rebased = [] of Int32
    while number > 0
      number, remainder = number.divmod(to_base)
      rebased.unshift(remainder)
    end
    rebased.empty? ? [0] : rebased
  end
end
