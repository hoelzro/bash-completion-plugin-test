## no critic (RequireUseStrict)
package Bash::Completion::Plugin::Test;

## use critic (RequireUseStrict)
use strict;
use warnings;

use Carp qw(croak);
use Bash::Completion::Request;
use Test::More;

sub new {
    my ( $class, %params ) = @_;

    my $plugin = delete $params{'plugin'};

    croak 'plugin parameter required' unless defined $plugin;

    if(my @bad_keys = keys %params) {
        croak "invalid parameters: " . join(' ', @bad_keys);
    }

    $class->_load_plugin($plugin);

    return bless {
        plugin_class => $plugin,
    }, $class;
}

sub check_completions {
    my ( $self, $command_line, $expected_completions, $name ) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $req    = $self->_create_request($command_line);
    my $plugin = $self->_create_plugin;

    $plugin->complete($req);

    my @got_completions = $req->candidates;

    is_deeply \@got_completions, $expected_completions, $name;
}

sub _cursor_character {
    return '^';
}

sub _extract_cursor {
    my ( $self, $command_line ) = @_;
    
    my $cursor_char = $self->_cursor_character;

    my $index = index $command_line, $cursor_char;

    if($index == -1) {
        croak "Failed to find cursor character in command line";
    }
    my $replacements = $command_line =~ s/\Q$cursor_char\E//g;

    if($replacements > 1) {
        croak "More than one cursor character in command line";
    }

    return ( $command_line, $index );
}

sub _create_request {
    my ( $self, $command_line ) = @_;

    my $cursor_index;
    ( $command_line, $cursor_index ) = $self->_extract_cursor($command_line);

    local $ENV{'COMP_LINE'}  = $command_line;
    local $ENV{'COMP_POINT'} = $cursor_index;

    return Bash::Completion::Request->new;
}

sub _create_plugin {
    my ( $self ) = @_;

    my $plugin_class = $self->{'plugin_class'};

    return $plugin_class->new;
}

sub _load_plugin {
    my ( $self, $plugin_class ) = @_;

    $plugin_class =~ s{::}{/}g;
    $plugin_class .= '.pm';\

    require $plugin_class;
}

1;

__END__

# ABSTRACT:  Module for testing Bash::Completion plugins

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 FUNCTIONS

=head1 SEE ALSO

L<Bash::Completion>

=cut
