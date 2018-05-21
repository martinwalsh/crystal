struct Int
  def armstrong?
    chars = self.to_s.chars
    chars.map { |c| c.to_i ** chars.size }.sum == self
  end
end
