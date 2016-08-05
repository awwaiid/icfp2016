
sudo apt-get install libperl-dev libimager-perl

# if [[ $(perl -V | grep shrplib) ]] ; then
#   echo 'Perl with -Duseshrplib found!'
# else
#   echo 'Installing via perlbrew'
#   perlbrew install perl-stable -Duseshrplib
#   cpanm Imager
# fi

# Install rakudobrew if needed
if [[ -e ~/.rakudobrew ]] ; then
  echo "Rakudobrew found!"
else
  echo "Rakudobrew not found, installing"
  git clone https://github.com/tadzik/rakudobrew ~/.rakudobrew
  export PATH=~/.rakudobrew/bin:$PATH
  # rakudobrew init
  echo 'eval "$(~/.rakudobrew/bin/rakudobrew init -)"' >> ~/.profile
  rakudobrew build moar 2016.07.1
  rakudobrew build panda
  panda install Task::Star
  panda install LREP
  panda install Inline::Perl5
fi


