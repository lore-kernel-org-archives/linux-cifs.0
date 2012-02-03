From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: request oplock when doing open on lookup
Date: Fri, 3 Feb 2012 15:25:15 +0300
Message-ID: <CAKywueRDrmK6-rxjj7JEL9OWrjzhw6xno7onL5G2Vz_8Ru8W_Q@mail.gmail.com>
References: <1328271252-19146-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328271252-19146-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Currently, it's always set to 0 (no oplock requested).
>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/dir.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index df8fecb..63a196b 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -492,7 +492,7 @@ cifs_lookup(struct inode *parent_dir_inode, struc=
t dentry *direntry,
> =A0{
> =A0 =A0 =A0 =A0int xid;
> =A0 =A0 =A0 =A0int rc =3D 0; /* to get around spurious gcc warning, s=
et to zero here */
> - =A0 =A0 =A0 __u32 oplock =3D 0;
> + =A0 =A0 =A0 __u32 oplock =3D enable_oplocks ? REQ_OPLOCK : 0;
> =A0 =A0 =A0 =A0__u16 fileHandle =3D 0;
> =A0 =A0 =A0 =A0bool posix_open =3D false;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Looks right.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
