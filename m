From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of
 invalidate_remote_inode (try #2)
Date: Mon, 28 Feb 2011 19:50:13 +0300
Message-ID: <AANLkTi=qJCqmekF6LjUY+AGCgW8eOFS0QVG86x2YrDmY@mail.gmail.com>
References: <1298629310-4618-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298629310-4618-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/2/25 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> Use invalidate_inode_pages2 that don't leave pages even if shrink_pag=
e_list()
> has a temp ref on them. It prevents a data coherency problem on exclu=
sive
> oplocks opens.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/inode.c | =A0 16 +++++++++++-----
> =A01 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 589f3e3..0011e95 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1687,12 +1687,18 @@ cifs_invalidate_mapping(struct inode *inode)
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D invalidate_inode_pages2(inode->i=
_mapping);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: could no=
t invalidate inode %p", __func__,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode);
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

What's about this?

--=20
Best regards,
Pavel Shilovsky.
