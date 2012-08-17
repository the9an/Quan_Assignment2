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
    my $query = $c->request->parameters->{query};
    if (!$query){
        $c->stash(search_done => 'no');
        $c->stash(template => 'search.tt');
    }
    else {
        $c->stash(search_done => 'yes');
        my $post_rs = $c->model('ForumDB::Post')->search([{ post_body => {-like => '%'.$query.'%'}}]);
        my $result_rs = $c->model('ForumDB::Thread')->search([{ thread_content => {-like => '%'.$query.'%'}},
                                            { thread_title => {-like => '%'.$query.'%'}}]);
        if ($result_rs->next){
            $c->stash(totalResult => $result_rs->count );
            @{$c->stash->{'results'}} = $result_rs->all();
            
        }
        if ($post_rs->next){
            $c->stash(totalPost => $post_rs->count );
            @{$c->stash->{'posts'}} = $post_rs->all();
            
        }
        $c->stash(template => 'search.tt');
    }
}

sub searching :Local :Args(0) {
    my ($self, $c) = @_;
    my $query = thread_filter_content($c->req->params->{query});
    $c->res->redirect("../search?query=".$query);
}

sub thread_filter_content {
	my $body = $_[0];
	$body =~ s/<(?:[^>'"]*|(['"]).*?\1)*>//gs;	
	return $body;
}

=head1 AUTHOR

CentOS

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
