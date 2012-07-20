###############################################################################
#
# $Id: sso.rb,v 1.1 2008/03/17 22:31:15 lanusau Exp $
# $Source: /proj/cvs/dba_team/code/poseidon/poseidon/components/sso.rb,v $
#
# Ruby wrapper around United Online SSO API
#
###############################################################################

require 'digest/md5'
require 'openssl'
require 'uri'

module SSO
  
  def SSO.getLoginUrl(applicationName, applicationID, applicationUrl, optionalSSOServerUrl="https://auth.int.untd.com/bin/sso")
    url = optionalSSOServerUrl + "?" +
          "origin_name="+URI.escape(applicationName)+"&" +
          "origin_url="+URI.escape(applicationUrl)+"&" +
          "origin_id="+URI.escape(applicationID)
    return url
  end
  
  def SSO.getLogoutUrl(applicationName, applicationID, applicationUrl, optionalSSOServerUrl="https://auth.int.untd.com/bin/sso")
    url = optionalSSOServerUrl + "?" +
          "action=parms&type=logout&" +
          "origin_name="+URI.escape(applicationName)+"&" +
          "origin_url="+URI.escape(applicationUrl)+"&" +
          "origin_id="+URI.escape(applicationID)
    return url
  end  
  
  def SSO.getAuthenticatedUsername(ssoToken, applicationID, optionalSSOPublicKeyFile = nil)
  
    token_items = ssoToken.split("|")    
    
    # Assume username is nil first
    valid_username = nil
    
    username = token_items[0]
    origin_id = token_items[1]
    timestamp = token_items[2]
    signature   = token_items[3]
    
    # If any of the items are nil - return nil
    return nil if (username.nil? or origin_id.nil? or timestamp.nil? or signature.nil?)    
    
    # Replace empty space in signature with newline
    signature = signature.gsub(/\s/,"\n")
    
    # Get MD5 digest of first 3 elements
    digest = Base64.encode64(Digest::MD5.digest(username+"|"+origin_id+"|"+timestamp))
    
    # If none specified, use public key from config subdirectory
    if optionalSSOPublicKeyFile.nil? 
      public_key_file = "#{File.dirname(__FILE__)}/../config/sso_key.pem"
    else
      public_key_file = optionalSSOPublicKeyFile
    end

    # Create public key
    public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))
    
    # Decode encrypted signature, which will have digest inside
    encrypted_digest = Base64.encode64(public_key.public_decrypt(Base64.decode64(signature)))
    
    valid_username = username if (encrypted_digest == digest) && (origin_id == applicationID)
    
    return valid_username
    
  rescue OpenSSL::PKey::RSAError => e
    # Rescue any errors from OpenSSL and return nil
    return nil
  end
    
end
