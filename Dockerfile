FROM yastdevel/ruby:sle15
# Install journal for specific tests of this package
RUN zypper --non-interactive in yast2-journal
COPY . /usr/src/app

