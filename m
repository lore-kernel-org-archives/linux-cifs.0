From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: bugfix for unreclaimed writeback pages in
 cifs_writev_requeue()
Date: Mon, 4 Mar 2013 14:19:03 -0500
Message-ID: <20130304141903.6a75d68d@tlielax.poochiereds.net>
References: <20130302195530.6EACF6605DF@gitolite.kernel.org>
	<F7FD7D54-C7FE-47E4-8741-FF56A3CC035A@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F7FD7D54-C7FE-47E4-8741-FF56A3CC035A-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 4 Mar 2013 15:04:49 +0000
Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org> wrote:

> Hi,
>=20
> The below commit that is present in 3.9-rc1 is buggy.  It releases th=
e page at which point it may no longer exist and then it unlocks it aft=
erwards.  Even if you are somehow getting away with it I think it is an=
 explosion/memory corruption waiting to happen...
>=20
> Best regards,
>=20
> 	Anton
>=20
> On 2 Mar 2013, at 19:55, Linux Kernel Mailing List <linux-kernel@vger=
=2Ekernel.org> wrote:
>=20
> > Gitweb:     http://git.kernel.org/linus/;a=3Dcommit;h=3Dc51bb0ea40c=
a038da26b1fa7d450f4078124af03
> > Commit:     c51bb0ea40ca038da26b1fa7d450f4078124af03
> > Parent:     0b7bc84000d71f3647ca33ab1bf5bd928535c846
> > Author:     Ouyang Maochun <ouyang.maochun-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> > AuthorDate: Mon Feb 18 09:54:52 2013 -0600
> > Committer:  Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > CommitDate: Thu Feb 28 09:01:47 2013 -0600
> >=20
> >    cifs: bugfix for unreclaimed writeback pages in cifs_writev_requ=
eue()
> >=20
> >    Pages get the PG_writeback flag set before cifs sends its
> >    request to SMB server in cifs_writepages(), if the SMB service
> >    goes down, cifs may try to recommit the writing requests in
> >    cifs_writev_requeue(). However, it does not clean its PG_writeba=
ck
> >    flag and relaimed the pages even if it fails again in
> >    cifs_writev_requeue(), which may lead to the hanging of the
> >    processes accessing the cifs directory. This patch just cleans
> >    the PG_writeback flags and reclaims the pages under that circums=
tances.
> >=20
> >        Steps to reproduce the bug(trying serveral times may trigger=
 the issue):
> >        1.Write from cifs client continuously.(e.g dd if=3D/dev/zero=
 of=3D<cifs file>)
> >        2.Stop SMB service from server.(e.g service smb stop)
> >        3.Wait for two minutes=EF=BC=8C and then start SMB service f=
rom
> >    server.(e.g service smb start)
> >        4.The processes which are accessing cifs directory may hang =
up.
> >=20
> >    Signed-off-by: Ouyang Maochun <ouyang.maochun-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> >    Signed-off-by: Jiang Yong <jian.yong5-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> >    Tested-by: Zhang Xianwei <zhang.xianwei8-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> >    Reviewed-by: Wang Liang <wang.liang82-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> >    Reviewed-by: Cai Qu <cai.qu-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> >    Reviewed-by: Jiang Biao <jiang.biao2-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> >    Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >    Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >    Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > ---
> > fs/cifs/cifssmb.c |    5 ++++-
> > 1 files changed, 4 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 00e12f2..7353bc5 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -1909,8 +1909,11 @@ cifs_writev_requeue(struct cifs_writedata *w=
data)
> > 	} while (rc =3D=3D -EAGAIN);
> >=20
> > 	for (i =3D 0; i < wdata->nr_pages; i++) {
> > -		if (rc !=3D 0)
> > +		if (rc !=3D 0) {
> > 			SetPageError(wdata->pages[i]);
> > +			end_page_writeback(wdata->pages[i]);
> > +			page_cache_release(wdata->pages[i]);
> > +		}
> > 		unlock_page(wdata->pages[i]);
> > 	}
> >=20
>=20

Well spotted...

We definitely should be unlocking the page before releasing it. I
think it's sufficient to simply move the unlock call before the
check of "rc". I'll send out a patch to do just that once I've
smoke-tested it.

Thanks,
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
