From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix sparse error
Date: Thu, 9 Jun 2011 09:13:47 -0500
Message-ID: <BANLkTimr6NGQLsNYzU73EmxqX5zYvBbZkw@mail.gmail.com>
References: <1307609933-5632-1-git-send-email-piastryyy@gmail.com>
	<1307609933-5632-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1307609933-5632-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Thu, Jun 9, 2011 at 3:58 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> cifs_sb_master_tlink was declared as inline, but without a definition=
=2E
> Remove the declaration and move the definition up.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 11 ++++-------
> =A01 files changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 23addcb..76a6670 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2203,7 +2203,10 @@ cifs_put_tlink(struct tcon_link *tlink)
> =A0}
>
> =A0static inline struct tcon_link *
> -cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb);
> +cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb)
> +{
> + =A0 =A0 =A0 return cifs_sb->master_tlink;
> +}
>
> =A0static int
> =A0compare_mount_options(struct super_block *sb, struct cifs_mnt_data=
 *mnt_data)
> @@ -3538,12 +3541,6 @@ out:
> =A0 =A0 =A0 =A0return tcon;
> =A0}
>
> -static inline struct tcon_link *
> -cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb)
> -{
> - =A0 =A0 =A0 return cifs_sb->master_tlink;
> -}
> -
> =A0struct cifs_tcon *
> =A0cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb)
> =A0{
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
