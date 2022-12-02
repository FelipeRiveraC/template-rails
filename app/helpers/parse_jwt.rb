module ParseJwt

  def parse(token)
    token_split = token.split
    if token_split.length == 2
      return token_split[1]
    else
      return token
    end
  end

end
