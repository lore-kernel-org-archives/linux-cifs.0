From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/13] cifs: eliminate oflags option from cifs_new_fileinfo
Date: Sun, 17 Oct 2010 19:59:49 -0500
Message-ID: <AANLkTi=nUVjOhYhC3TcLyjBvwqGqbTy-H8CFpGyX343E@mail.gmail.com>
References: <1287171248-464-1-git-send-email-jlayton@redhat.com>
	<1287171248-464-3-git-send-email-jlayton@redhat.com>
	<4CBB1182.5050009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CBB1182.5050009-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Oct 17, 2010 at 10:08 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>=
 wrote:
>
> On 10/16/2010 01:03 AM, Jeff Layton wrote:
> > Eliminate the poor, misunderstood "oflags" option from cifs_new_fil=
einfo.
> > The callers mostly pass in the filp->f_flags here.
> >
> > That's not correct however since we're checking that value for
> > the presence of FMODE_READ. Luckily that only affects how the f_lis=
t is
> > ordered. What it really wants here is the file->f_mode. Just use th=
at
> > field from the filp to determine it.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =A0fs/cifs/cifsproto.h | =A0 =A03 +--
> > =A0fs/cifs/dir.c =A0 =A0 =A0 | =A0 =A09 ++++-----
> > =A0fs/cifs/file.c =A0 =A0 =A0| =A0 =A05 ++---
> > =A03 files changed, 7 insertions(+), 10 deletions(-)
> >
>
> Looks good to me.
>
> Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

Thx - Looks like these last two patches eliminate some of the annoying =
sparse
warnings too.=A0=A0 Down to only a few:

fs/cifs/dir.c:275:21: warning: restricted fmode_t degrades to integer
fs/cifs/dir.c:277:21: warning: restricted fmode_t degrades to integer

--
Thanks,

Steve
