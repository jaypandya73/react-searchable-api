class JsonWebToken

  attr_reader :algorithm, :secret

  def initialize(algorithm = 'HS256', secret = "this_is_testing_key_will_update")
    @algorithm = algorithm
    @secret = secret
  end

  def encode(payload)
    JWT.encode(payload, secret, algorithm)
  end

  def encode_user(user)
    encode({
      user_email: user.email,
      exp: 1.weeks.from_now.to_i
    })
  end

  def decode(token)
    return HashWithIndifferentAccess.new(JWT.decode(token, secret, true, {algorithm: algorithm})[0])
  end

  def valid_payload(payload)
    if expired(payload)
      return false
    else
      return true
    end
  end

  def meta
    {
      exp: 7.days.from_now.to_i,
      iss: 'issuer_name',
      aud: 'client',
    }
  end

  def expired(payload)
    Time.at(payload['exp']) < Time.now
  end

end
