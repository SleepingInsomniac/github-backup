module GithubBackup
  class Git
    def remotes(_remotes = nil)
      unless _remotes
        _remotes = `git remote`.split(/\s+/)
      end
      _remotes
    end

    def current_branch
      `git rev-parse --abbrev-ref HEAD`.chomp
    end

    def tracked_branches(remote)
      info = `git remote show #{remote}`
        .lines
        .select { |l| l =~ /merges with remote/i }
        .map{ |l| l.strip.split(/\s+merges with remote\s+/i) }
    end

    def commits_behind(remote, lbranch, rbranch)
      `git rev-list --count refs/heads/#{lbranch}..refs/remotes/#{remote}/#{rbranch}`.chomp.to_i
    end

    def commits_ahead(remote, lbranch, rbranch)
      `git rev-list --count refs/remotes/#{remote}/#{rbranch}..refs/heads/#{lbranch}`.chomp.to_i
    end

    # ===========
    # = updater =
    # ===========
    def update
      remotes.each do |remote|
        puts `git remote update #{remote}`
        tracked_branches(remote).each do |branches|
          lbranch, rbranch = branches
          behind = commits_behind(remote, lbranch, rbranch)
          ahead = commits_ahead(remote, lbranch, rbranch)
          if behind > 0
            if ahead > 0
              puts "branch #{lbranch} is #{behind} commit(s) behind and " \
                   "#{ahead} commit(s) ahead of #{remote}/#{rbranch}. " \
                   "could not be fast-forwarded"
            elsif lbranch == current_branch
              puts "branch #{lbranch} was #{behind} commit(s) behind of " \
                   "#{remote}/#{rbranch}. fast-forward merge"
              puts "git merge -q refs/remotes/#{remote}/#{rbranch}"
            else
              puts "branch #{lbranch} was #{behind} commit(s) behind of " \
                   "#{remote}/#{rbranch}. resetting local branch to remote"
              puts "git branch -f #{lbranch} -t refs/remotes/#{remote}/#{rbranch} >/dev/null"
            end
          end
        end
      end
    end

  end
end
