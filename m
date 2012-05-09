From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: linux-next workflow question for cifs
Date: Wed, 9 May 2012 15:02:20 -0400
Message-ID: <20120509190220.GA27077@fieldses.org>
References: <CAH2r5mtBK-C0Uc6gVY0Dk+YfbaFE+OfCbM+A_2BmiTVzZMchmQ@mail.gmail.com>
 <20120509175219.GA26477@fieldses.org>
 <20120509140847.277d5c0b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120509140847.277d5c0b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, May 09, 2012 at 02:08:47PM -0400, Jeff Layton wrote:
> For "normal" branches that you expect people to pull, I agree. For
> linux-next though, it really doesn't matter too much since it gets
> re-created from scratch every day.
> 
> Rewriting history is explicitly ok there, but you do of course want
> that branch to be bisectable if at all possible in order to make it
> easier to track down regressions.
> 
> OTOH, if someone says "I got a panic on linux-next from on last
> Thursday", it might be tough to know what was in that pull if you're
> changing the history regularly. It is a bit of a balancing act, I guess.

Yeah.  So the way I currently do it, in case it's of any use:

I have a for-next branch in my public repo, and a for-next-incoming in my
local repo.  The latter gets rebased, the former doesn't.

I apply stuff to for-next-incoming when I start considering it, but I
rearrange and rewrite it on top of for-next all the time.

Every now and then I do a

	gitk for-next..for-next-incoming

and look for the longest initial set of commits that:

	- are based on patches that have been posted at least 24 hours.
	  (Exceptions for something urgent or trivial.)
	- have passed any required review.

I run about a half hour of simple automated regression tests on the
commit at the top of that initial piece and push it to for-3.5.

I try to do that as I go along, rather than waiting a month and then
pushing a bunch out at once.

There are some things that -next testing routinely catches that I still
miss (cross-compiles or various config options).  I should probably add
more of those to my tests.

But so far that's been close enough to bisectable that I haven't felt
a strong need to break my self-imposed rule and rebase.

> In any case, for some background...the problem we're trying to solve
> here is that patches sit on linux-cifs mailing list with no activity
> for months when they should be soaking in linux-next. So we're trying
> to come up with a workflow that allows us to get them into linux-next
> in a more timely fashion. If that requires not using an append-only
> branch, I'm ok with that...

Makes sense.

--b.
