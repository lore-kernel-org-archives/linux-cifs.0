From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of invalidate_remote_inode
Date: Tue, 22 Feb 2011 19:33:33 +0300
Message-ID: <AANLkTi=+fwiK2PYkxuSsPqDtUda4mz=mPQBK5w4cSV9K@mail.gmail.com>
References: <1298387346-9228-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298387346-9228-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/2/22 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> We should invalidate a page even if it is locked now by someone, beca=
use
> we can leave an invalid data there and then think it's uptodate accor=
ding
> to an oplock level (exclusive or II).
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/inode.c | =A0 13 ++++++++-----
> =A01 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 8852470..1da1f26 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1691,12 +1691,15 @@ cifs_invalidate_mapping(struct inode *inode)
>
> =A0 =A0 =A0 =A0cifs_i->invalid_mapping =3D false;
>
> - =A0 =A0 =A0 /* write back any cached data */
> - =A0 =A0 =A0 if (inode->i_mapping && inode->i_mapping->nrpages !=3D =
0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->i_=
mapping);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, rc)=
;
> + =A0 =A0 =A0 if (inode->i_mapping) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* write back any cached data */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (inode->i_mapping->nrpages !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_an=
d_wait(inode->i_mapping);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode=
->i_mapping, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalidate_inode_pages2(inode->i_mappin=
g);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 invalidate_remote_inode(inode);
> +
> =A0 =A0 =A0 =A0cifs_fscache_reset_inode_cookie(inode);
> =A0}
>
> --
> 1.7.1
>
>

After investigating some more time, I found out that at least the
description of this patch isn't valid. Let's drop this one.

The problem is that we use invalidate_remote_inode that don't think
about return value from invalidate_mapping_pages and return void. The
problem is that invalidate_mapping_pages return 0 instead of positive
value. I will continue investigation of this problem.

--=20
Best regards,
Pavel Shilovsky.
