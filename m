From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-next workflow question for cifs
Date: Wed, 9 May 2012 12:29:27 -0400
Message-ID: <20120509122927.00b79592@corrin.poochiereds.net>
References: <CAH2r5mtBK-C0Uc6gVY0Dk+YfbaFE+OfCbM+A_2BmiTVzZMchmQ@mail.gmail.com>
	<20120509094511.29ca89ea@corrin.poochiereds.net>
	<1336572241.2116.3.camel@localhost>
	<CAH2r5mupvedQif+7XRxJozbwQxshqs2SJBgkP3t_9xJQdBWPwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mupvedQif+7XRxJozbwQxshqs2SJBgkP3t_9xJQdBWPwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 9 May 2012 09:38:07 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, May 9, 2012 at 9:04 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Wed, 2012-05-09 at 09:45 -0400, Jeff Layton wrote:
> >> On Wed, 9 May 2012 08:19:05 -0500
> >> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >> > Trying to figure out the easiest way for the workflow for the ne=
w
> >> > cifs-2.6.git linux-next branch for this scenario:
> >> >
> >> > - push a series of patches to cifs-2.6.git linux-next
> >> > - someone adds an ack to a patch in the middle, or even a coding
> >> > change to a patch in the middle
> >> > - how do I easiest make this change and repush (without constant=
ly
> >> > doing git push --force)
> >> >
> >> > Do I rename the branch on my local workstation, do a git push (w=
hat is
> >> > the option to delete a branch remotely...?), then switch on the =
local
> >> > box to the newly renamed branch, amend the patch (will gitk or o=
ther
> >> > gui tool make this easier than what I use today which is git com=
mand
> >> > line option which launches a vi-like interface =C2=A0which is a =
little bit
> >> > of a pain), rename the branch back and then push the new linux-n=
ext
> >> > branch (and create it on the remote server) ....
> >> >
> >>
> >> The upstream linux-next tree is recreated from scratch every time.=
 So,
> >> there's no harm in rebasing that branch, or rewriting its history.=
 Only
> >> the end product matters.
> >>
> >> I use stgit heavily, so editing a patch description in the middle =
of a
> >> stack is trivial. Not sure what you can do with regular git tools =
or
> >> something like gitk.
> >>
> >> I guess you could create a new branch and cherry-pick all of the
> >> patches from the old, while doing something like "git commit --ame=
nd"
> >> to add Reviewed-by lines and such. It's a bit cumbersome, but the =
basic
> >> git tools are sort of primitive for this sort of thing...
> >>
> >
> > I've used git rebase -i <commit list>
> > to amend the commit messages, reorder the patches and also to squas=
h
> > multiple patches into a single patch. However I am not sure you can=
 push
> > a branch modified in this manner to a remote server. If you are usi=
ng a
> > fresh remote branch each time, this is a non issue.
>=20
> since you can't manipulate the sparse trees directly on git.samba.org=
 as easily,
> then the problem is how do you best do "git remote-branch-delete" and=
 2nd
> what is best gui for editing a patch description in middle (git rebas=
e
> -i or commit --amend
> works but is harder to use)
>=20
>=20

This will delete a remote branch:

    $ git push <remotename> :<remote branch name>

=2E..then just re-push the branch.

    $ git push <remotename> <local branch>:<remote branch>

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
