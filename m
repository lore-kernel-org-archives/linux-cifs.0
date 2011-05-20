From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Simplify invalidate part (try #5)
Date: Fri, 20 May 2011 07:30:53 -0400
Message-ID: <20110520073053.6b113a4a@corrin.poochiereds.net>
References: <1303565417-3653-1-git-send-email-piastry@etersoft.ru>
	<20110519140132.32850e2c@barsoom.rdu.redhat.com>
	<BANLkTinsqwMoFzP+9+qX+W+Gr+LGae0Rdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinsqwMoFzP+9+qX+W+Gr+LGae0Rdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 May 2011 13:00:53 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/5/19 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Sat, 23 Apr 2011 17:30:17 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Simplify many places when we call cifs_revalidate/invalidate to ma=
ke
> >> it do what it exactly needs.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsfs.c | =C2=A0 33 +++++++++++-----
> >> =C2=A0fs/cifs/cifsfs.h | =C2=A0 =C2=A04 +-
> >> =C2=A0fs/cifs/file.c =C2=A0 | =C2=A0 16 ++++++--
> >> =C2=A0fs/cifs/inode.c =C2=A0| =C2=A0117 ++++++++++++++++++++++++++=
++++++++-------------------
> >> =C2=A04 files changed, 113 insertions(+), 57 deletions(-)
> >>
> >
> > This patch is causing a regression in tests5:
> >
> > ./test5: read and write
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0./test5: (/mnt/salusa/rawhide.test) 'big=
file' has size -2130066000, should be 1048576
> > basic tests failed
> >
> > Pavel, can you track this down?
> >
> > Steve, in the meantime I suggest that this patch not be pushed when
> > the merge window opens.
> >
>=20
> I figured it out.
>=20
> Steve, I attach two diffs: 1) diff for this version of the patch and
> 2) new fixed version of the whole patch - you can use either one that
> is more comfortable to you.
>=20

Confirmed -- the patch seems to fix the issue. With that, all the
connectathon tests seem to now pass.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
