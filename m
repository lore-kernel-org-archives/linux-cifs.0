From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-next workflow question for cifs
Date: Wed, 9 May 2012 14:08:47 -0400
Message-ID: <20120509140847.277d5c0b@corrin.poochiereds.net>
References: <CAH2r5mtBK-C0Uc6gVY0Dk+YfbaFE+OfCbM+A_2BmiTVzZMchmQ@mail.gmail.com>
	<20120509175219.GA26477@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120509175219.GA26477-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 9 May 2012 13:52:19 -0400
"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:

> On Wed, May 09, 2012 at 08:19:05AM -0500, Steve French wrote:
> > Trying to figure out the easiest way for the workflow for the new
> > cifs-2.6.git linux-next branch for this scenario:
> > 
> > - push a series of patches to cifs-2.6.git linux-next
> > - someone adds an ack to a patch in the middle, or even a coding
> > change to a patch in the middle
> > - how do I easiest make this change and repush (without constantly
> > doing git push --force)
> 
> The other way to deal with it is:
> 	- if there's a coding change, add another patch on top.
> 	- if an ack or attribution got lost, apologize and try to
> 	  do better next time.
> 
> There are advantages to clean bisectable history, and there are also
> advantages to real append-only history:
> 	- if someone's doing extra work on top of your branch, then
> 	  rebasing their stuff becomes easier.
> 	- if someone finds a bug in your branch and fixes it, then you
> 	  have a record of how that actually happened.
> 
> My personal balance is to have one append-only branch that's what gets
> pulled into next, and then a different tree with any works in progress
> that I can point someone to if necessary.
> 
> And I try not to push to the append-only branch until I'm pretty sure
> there's been a chance for review, etc.
> 
> Not saying that's perfect--there are times when I would've liked to get
> a patch some more testing in -next before really committing to it, and
> at least one case when someone was annoyed not to be able to improve the
> change log on something they submitted.
> 
> --b.

For "normal" branches that you expect people to pull, I agree. For
linux-next though, it really doesn't matter too much since it gets
re-created from scratch every day.

Rewriting history is explicitly ok there, but you do of course want
that branch to be bisectable if at all possible in order to make it
easier to track down regressions.

OTOH, if someone says "I got a panic on linux-next from on last
Thursday", it might be tough to know what was in that pull if you're
changing the history regularly. It is a bit of a balancing act, I guess.

In any case, for some background...the problem we're trying to solve
here is that patches sit on linux-cifs mailing list with no activity
for months when they should be soaking in linux-next. So we're trying
to come up with a workflow that allows us to get them into linux-next
in a more timely fashion. If that requires not using an append-only
branch, I'm ok with that...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
