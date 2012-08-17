package Forum::Controller::admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Forum::Controller::admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    #Get topics forum database
    my $topics_rs = $c->model('ForumDB::Topic')->search(undef);
    @{$c->stash->{'topics'}} = $topics_rs->all();
    $c->stash->{'fr_mode'} = 'topics';
    $c->stash->{template};
}



=head1 AUTHOR

CentOS

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
