# Bin folder from git
class basic {
 
 define github ($path = "${::user_homedir}dev/", $repo_name = $name, $github_user = jennifersmith){
    notice("we shall be using git@github.com:${github_user}/${repo_name}.git")
    vcsrepo { "${path}${name}/":
      ensure => present,
      provider => git,
      source => "git@github.com:${github_user}/${repo_name}.git"
    } 
  }  
  
  github {"bin": path => $::user_homedir , repo_name=>misc}
 
  #dev ones use the defaults apart from rapidftr 
  github {["wire_tap"]:}
  
  github {"rapidftr/dev": repo_name => RapidFTR}
  github {"rapidftr/merge": repo_name => RapidFTR, github_user => jorgej}
 

  define dotfile(){
   file { "${::user_homedir}.${name}":
       ensure => link,
           target => "${::user_homedir}bin/dotfiles/${name}",
    }
  }

  define dotdir(){
     file { "${::user_homedir}/.${name}":
       ensure => link,
           target => "${::user_homedir}bin/dotfiles/${name}/",
    }
  }

  class weirdassvim {
   file { "${::user_homedir}/.vim":
       ensure => link,
           target => "${::user_homedir}bin/dotfiles/vim/vim",
    }
  }

  dotfile {["bash_profile", "bashrc" , "gemrc", "gitconfig", "gvimrc", "util", "vimrc"]:}
  dotdir{"bash":}
  class {'weirdassvim':}
  class {'rvm::system': homedir=>$::user_homedir }  
 
  # treating homebrew as an exec... who package manages the package managers?
  exec {
        '/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"':
        creates => '/usr/local/bin/brew'}
 	
  package {'emacs': 
                    provider=>homebrew,
										ensure=>HEAD,
                    install_options=> { flags => "--cocoa --use-git-head --HEAD"} 
          }

}
