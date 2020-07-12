#!/bin/bash
set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMMANDS="list init clone"

# リモートホスト、ユーザ名を指定する場合は user@host
REMOTE_HOST=user@diskstation

# リモートのパス
# Diskstationの場合は/var/services/homes/[ユーザ名]/ がホームフォルダとなる
REMOTE_PATH=/var/services/homes/username/git-repos

do_list() {
	ssh $REMOTE_HOST perl - $REMOTE_PATH<< 'EOS'
#!/usr/bin/env perl
use strict;
use feature 'say';
use File::Find;
use File::Spec;

my @pathes;
find(sub {
	push @pathes, $File::Find::name;
},$ARGV[0]);

my @repolist;
foreach(sort @pathes) {
	s#^\Q$ARGV[0]/\E##;
	my @sp=File::Spec->splitpath($_);
	if($sp[2] eq 'HEAD') {
		my $dir=$sp[1];
		$dir=~s#/$##;
		push @repolist,$dir;
	}
}
foreach(@repolist) {
	say $_;
}
EOS
}

do_init() {
	ssh $REMOTE_HOST git init --bare $REMOTE_PATH/$1
}

do_clone() {
	git clone $REMOTE_HOST:$REMOTE_PATH/$1
}

run() {
    for i in $COMMANDS; do
    if [ "$i" == "${1:-}" ]; then
        shift
        do_$i $@
        exit 0
    fi
    done
    echo "USAGE: $( basename $0 ) COMMAND"
    echo "COMMANDS:"
    for i in $COMMANDS; do
    echo "   $i"
    done
    exit 1
}

run $@

