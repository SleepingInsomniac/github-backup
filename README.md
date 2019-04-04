# GithubBackup

Backup all of your github repos by using the Github API to clone and update them.

## Installation

    $ gem install github_backup

## Usage

Edit: `~/.config/github-backup.json`

Example config

```json
{
  "repos_path": "~/Repos",
  "backup_path": "~/Documents/RepoBundles",
  "token": "...github_token..."
}
```

    $ github-backup
