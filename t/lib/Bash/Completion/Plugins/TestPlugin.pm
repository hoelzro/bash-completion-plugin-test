package Bash::Completion::Plugins::TestPlugin;

use strict;
use warnings;
use parent 'Bash::Completion::Plugin';

use Bash::Completion::Utils qw(prefix_match);

my @OPTIONS = qw{foo bar baz};

sub should_activate {
    return [ 'test-plugin' ];
}

sub complete {
    my ( $self, $r ) = @_;

    $r->candidates(prefix_match($r->word, @OPTIONS));
}


package Bash::Completion::Plugins::TestPluginNoDups;

use strict;
use warnings;
use parent 'Bash::Completion::Plugin';

use Bash::Completion::Utils qw(prefix_match);

my @OPTIONS = qw{foo bar baz};

sub should_activate {
    return [ 'test-plugin-nodup' ];
}

sub complete {
    my ( $self, $r ) = @_;

    my %remaining = map { $_ => 1 } @OPTIONS;

    foreach my $arg ($r->args) {
        next if $arg eq $r->word;

        delete $remaining{$arg};
    }

    $r->candidates(prefix_match($r->word, keys %remaining));
}

1;
