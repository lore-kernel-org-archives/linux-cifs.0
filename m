From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 2.6.36 merge plans
Date: Mon, 2 Aug 2010 13:46:54 -0400
Message-ID: <20100802134654.3ac129e7@tlielax.poochiereds.net>
References: <AANLkTim2UcxAXuR0K8JexGAIq3UoEj1KMH4JMGLnJ72D@mail.gmail.com>
	<20100630141755.4ac97143@tlielax.poochiereds.net>
	<4C2CDD02.2090403@suse.de>
	<AANLkTilEg0zG1DD9fF9T890nFhaqNNeLta1-RAo9iKpM@mail.gmail.com>
	<AANLkTimTjDJeR7ktNcJpPSc-zioHrndPwPxb98HAYgpY@mail.gmail.com>
	<20100701195247.71c3f572@tlielax.poochiereds.net>
	<AANLkTi=X5PyZLdaJj_ikSv7HUNtfmQYhPc50mecx_mMj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=X5PyZLdaJj_ikSv7HUNtfmQYhPc50mecx_mMj-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 23 Jul 2010 17:19:29 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Jul 1, 2010 at 6:52 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Thu, 1 Jul 2010 16:55:58 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> For =A0 cifs: use CreationTime like an i_generation field
> >> Seems like a good idea, but what happens if server is unix one wit=
hout
> >> birth time, eg samba with no xattr support and changes creation ti=
me
> >> (ie uses last mtime or some such) frequently - e.g. on every write=
?
> >> Would that break your aprroach?
> >>
> >
> > Aye, there's the rub. This makes a ton of sense for windows where w=
e
> > can count on a valid create time. Samba servers may be problematic =
here,
> > but with most of them we'll be using unix extensions and you don't =
get
> > create times there anyway. The problem may be samba or other
> > non-windows servers without unix extensions that fake up create tim=
es.
> >
> > We could consider a mount option or something to ignore create time=
s,
> > but how to document when it should be used? IMO, fake create times =
are
> > really a server bug. Do we hobble servers where this is done correc=
tly?
>=20
> Jeff,
> I merged the other patches from your tree, but wanted to think more a=
bout
> http://git.kernel.org/?p=3Dlinux/kernel/git/jlayton/linux.git;a=3Dcom=
mit;h=3De5b7e004ed0ccdcf5fd3b1b0aff2a1a45023912b
> ie the CreationTime i_generation patch and what happens to servers
> which don't have creation time - presumably e.g. most Samba servers
> on Linux can't get to creation time.  Any additional thoughts on this=
?
>=20

Hi Steve,

Looks like Linus released 2.6.35 yesterday. There's still a patch in my
tree that's unmerged as of yet and that I'd like to see go into 2.6.36:

cifs: reduce false positives with inode aliasing serverino autodisable

=2E..any reason that you haven't merged it yet?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
