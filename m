From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: bugfix for unreclaimed writeback pages in
 cifs_writev_requeue()
Date: Thu, 7 Feb 2013 06:39:57 -0500
Message-ID: <20130207063957.520a40c2@tlielax.poochiereds.net>
References: <OF08391DB5.0DFF1FA3-ON48257B0A.002333BE-48257B0A.002372B2@zte.com.cn>
	<CAH2r5muZL8voikW6NO_KojjV=N9zVymsqcR_KMf=XgZ4v8oGgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiang Biao <jiang.biao2-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muZL8voikW6NO_KojjV=N9zVymsqcR_KMf=XgZ4v8oGgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 6 Feb 2013 12:00:08 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Forwarding to the current cifs development mailing list
>=20
>=20
> ---------- Forwarded message ----------
> From:  <jiang.biao2-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> Date: Wed, Feb 6, 2013 at 12:26 AM
> Subject: [PATCH] cifs: bugfix for unreclaimed writeback pages in
> cifs_writev_requeue()
> To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-client-w/Ol4Ecudplf7j03Gpi2xA@public.gmane.org=
rg
>=20
>=20
>=20
>     This patch applies to the kernel version of linux-3.8-rc6.
>=20
>     Pages get the PG_writeback flag set before cifs sends its request
> to SMB server
>     in cifs_writepages(), if the SMB service goes down, cifs may try
> to recommit the
>     writing requests in cifs_writev_requeue(). However, it does not
> clean its PG_writeback
>     flag and relaimed the pages even if it fails again in
> cifs_writev_requeue(), which
>     may lead to the hanging of the processes accessing the cifs
> directory. This patch
>     just cleans the PG_writeback flags and reclaims the pages under
> that circumstances.
>=20
>     Steps to reproduce the bug(trying serveral times may trigger the =
issue):
>     1.Write from cifs client continuously.(e.g dd if=3D/dev/zero of=3D=
<cifs file>)
>     2.Stop SMB service from server.(e.g service smb stop)
>     3.Wait for two minutes=A3=AC and then start SMB service from
> server.(e.g service smb start)
>     4.The processes which are accessing cifs directory may hang up.
>=20
>     Signed-off-by: Ouyang Maochun <ouyang.maochun-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>     Signed-off-by: Jiang Yong <jian.yong5-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>     Tested-by: Zhang Xianwei <zhang.xianwei8-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>     Reviewed-by: Wang Liang <wang.liang82-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>     Reviewed-by: Cai Qu <cai.qu-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>     Reviewed-by: Jiang Biao <jiang.biao2-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>=20
> diff -uprN linux-3.8-rc6/fs/cifs/cifssmb.c linux-3.8-rc6_new/fs/cifs/=
cifssmb.c
> --- linux-3.8-rc6/fs/cifs/cifssmb.c        2013-02-01 09:08:14.000000=
000 +0800
> +++ linux-3.8-rc6_new/fs/cifs/cifssmb.c        2013-02-04
> 15:44:09.869254397 +0800
> @@ -1909,8 +1909,11 @@ cifs_writev_requeue(struct cifs_writedat
>          } while (rc =3D=3D -EAGAIN);
>=20
>          for (i =3D 0; i < wdata->nr_pages; i++) {
> -                if (rc !=3D 0)
> +                if (rc !=3D 0){
>                          SetPageError(wdata->pages[i]);
> +                         end_page_writeback(wdata->pages[i]);
> +                         page_cache_release(wdata->pages[i]);
> +                 }
>                  unlock_page(wdata->pages[i]);
>          }
>=20
>=20

Patch looks correct to me. Nice catch.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
