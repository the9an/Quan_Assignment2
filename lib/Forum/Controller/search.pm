package Forum::Controller::search;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Forum::Controller::search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args() {
    my ($self, $c) = @_;
    #$c->response->body('Matched Forum::Controller::search in search.');
    
    $c->stash(template => 'search.tt');
}

sub searching :Local :Args(0) {
    my ($self, $c) = @_;
    my $query = $c->req->params->{query};
    my $result_rs = $c->model('ForumDB::Thread')->search([{ thread_content => {-like => '%'.$query.'%'}},
                                            { thread_title => {-like => '%'.$query.'%'}}]);
    #$c->stash(totalResult => $result_rs->count );
    $c->stash(results => $result_rs->all(), template => 'resultsearch.tt');
}

=head1 AUTHOR

CentOS

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
