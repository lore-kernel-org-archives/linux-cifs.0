From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: cope with negative dentries in cifs_get_root
Date: Tue, 9 Aug 2011 09:41:33 +0400
Message-ID: <CAKywueRT9cGPu5pCiiYONd7DruBaE2TDvHVVyyELYwM_Ft5e+Q@mail.gmail.com>
References: <1312549360-4317-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312549360-4317-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/5 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> The loop around lookup_one_len doesn't handle the case where it might
> return a negative dentry, which can cause an oops on the next pass
> through the loop. Check for that and break out of the loop with an
> error of -ENOENT if there is one.
>
> Fixes the panic reported here:
>
> =A0 =A0https://bugzilla.redhat.com/show_bug.cgi?id=3D727927
>
> Reported-by: TR Bentley <home-XKIT1lZdXBwO+8BAsp4z4w@public.gmane.org>
> Reported-by: Iain Arnell <iarnell-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 =A04 ++++
> =A01 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 212e562..f93eb94 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -563,6 +563,10 @@ cifs_get_root(struct smb_vol *vol, struct super_=
block *sb)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&dir->i_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dput(dentry);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dentry =3D child;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!dentry->d_inode) {

dentry can be NULL here (returned from lookup_one_len) and it can
cause a null pointer dereference.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(dentry);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D ERR_PTR(-ENO=
ENT);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0} while (!IS_ERR(dentry));
> =A0 =A0 =A0 =A0_FreeXid(xid);
> =A0 =A0 =A0 =A0kfree(full_path);
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
Pavel Shilovsky.
