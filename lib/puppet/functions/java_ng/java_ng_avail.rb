# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----

# ---- original file header ----
#
# @summary
#   Scans available Java versions and return matching version and repository.
#
Puppet::Functions.create_function(:'java_ng::java_ng_avail') do
  # @param arguments
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :arguments
  end


  def default_impl(*arguments)
    
        raise(Puppet::ParseError, "java_ng_avail(): Wrong number of arguments") if arguments.size != 4

        if arguments[0].is_a?(Array) then
            versions = arguments[0]
        else
            versions = [arguments[0]]
        end
        # accept both integers and strings as the version:
        # * numbers goes as strings from manifests (puppet 3)
        # * numbers goes as integers from manifests (puppet 4)
        # * arithmetic expressions goes as integers from manifests
        # * hiera can have string or integer, let's support both
        versions.map! {|v| v.to_s }
        #p versions

        if arguments[1].is_a?(Array) then
            repos = arguments[1]
        else
            repos = [arguments[1]]
        end

        prefer_version = arguments[2]

        ja = arguments[3]
        # convert also the list of available versions:
        # * numbers goes as strings from manifests (puppet 3)
        # * numbers goes as integers from manifests (puppet 4)
        ja.map { |repo,vers|
          [repo, vers.map! { |v| v.to_s }]
        }
        #p ja

        jv = nil
        jrepo = nil
        if prefer_version then
            versions.each do |version|
                repos.each do |repo|
                    #p repo, version, ja[repo]
                    if ja.has_key? repo and ja[repo].include? version then
                        #found! ==> repo, jv
                        jv = version
                        jrepo = repo
                        break
                    end
                end
                break if jv or jrepo
            end
        else
            repos.each do |repo|
                if ja.has_key? repo then
                    hit = (versions & ja[repo])
                    #p repo, hit
                    if !hit.empty? then
                        #found! ==> repo, jv
                        jv = hit[0]
                        jrepo = repo
                        break
                    end
                end
            end
        end

        {
            'repo' => jrepo,
            'version' => jv,
        }
    
  end
end