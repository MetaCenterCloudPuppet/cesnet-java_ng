module Puppet::Parser::Functions
    newfunction(:java_ng_avail, :type => :rvalue, :doc => "Scans available Java versions and return matching version and repository.") do |arguments|
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
