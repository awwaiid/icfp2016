
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
fi

if [[ $(perl -V | grep shrplib) ]] ; then
  echo 'Perl with -Duseshrplib found!'
else
  echo 'Installing via perlbrew'
  perlbrew install perl-stable -Duseshrplib
fi

panda --force install Task::Star
panda --force install LREP
panda --force install Inline::Perl5
cpanm Imager

