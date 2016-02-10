module Puppet::Parser::Functions
    newfunction(:java_ng_avail, :type => :rvalue, :doc => "Construct list of java versions.") do |arguments|
        raise(Puppet::ParseError, "java_ng_avail(): Wrong number of arguments") if arguments.size < 3

        if arguments[0].is_a?(Array) then
            versions = arguments[0]
        else
            versions = [arguments[0]]
        end
        if arguments[1].is_a?(Array) then
            repos = arguments[1]
        else
            repos = [arguments[1]]
        end
        prefer_version = arguments[2]
        if arguments.size > 3 then
          ja = arguments[3]
        else
          ja = Hash.new()
          ja['native'] = lookupvar('::java_ng::java_native_versions')
          ja['ppa'] = lookupvar('::java_ng::java_ppa_versions')
        end

        jv = nil
        jrepo = nil
        if prefer_version then
            versions.each do |version|
                repos.each do |repo|
                    #p repo, version, ja[repo]
                    if ja[repo] and ja[repo].include? version then
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

        {
            'repo' => jrepo,
            'version' => jv,
        }
    end
end
