class basic {               
 
 define github ($path = "${::user_homedir}dev/", $repo_name = $name, $github_user = jennifersmith, $ensure = present){
    vcsrepo { "${path}${name}/":
      ensure => $ensure,
      provider => git,
      source => "git@github.com:${github_user}/${repo_name}.git"
    } 
  }

  github {"bin": path => $::user_homedir , repo_name=>misc, ensure=>latest}

  github {"private-settings": path =>"${::user_homedir}/bin/", require=>Github["bin"], ensure=>latest}
  
  #dev ones use the defaults apart from rapidftr 
  github {["wire_tap", "4clojure_answers", "myblog", "plasma", "photo-management","flickr-clojure", "flickr-facebook-clj"]:}
  
  github {"rapidftr/dev": repo_name => RapidFTR}
  github {"rapidftr/merge": repo_name => RapidFTR, github_user => jorgej}

  github {"mingle-stats" :}

  # bbatsov emacs prelude
  github {"emacs.d": github_user => bbatsov, repo_name => prelude, path => "${::user_homedir}/bin/dotfiles/", require=>Github["bin"], ensure=>latest}
  # personal files symlinked in
  file {"${::user_homedir}/bin/dotfiles/emacs.d/personal":
    ensure => link,
    target => "${::user_homedir}bin/dotfiles/prelude-personal",
    require => Github["emacs.d"],
    force => true
  }
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
  dotdir {["lein", "bash", "emacs.d"]:}
  class {'weirdassvim':}
  class {'rvm::system': homedir=>$::user_homedir }  

 
  # treating homebrew as an exec... who package manages the package managers?
  exec {
        '/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"':
        creates => '/usr/local/bin/brew'}
 	
  package {'emacs':
    provider=>homebrew,
    ensure=>HEAD,
    install_options=> { flags => "--cocoa --use-git-head --HEAD"} }

  class{"leiningen": require => Dotdir["lein"]}


  package{ 'aspell' : provider=>homebrew, install_options =>{lang=>'eng'}}
  package {'wget': provider=>homebrew}
  package {'ack': provider=>homebrew}
  package {'llvm' : provider=>homebrew, install_options=>{flags=>'--universal'}}

package { 'gist' : provider=>homebrew}

}

