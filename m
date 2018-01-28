From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fs/cifs/cifsacl.c Fixes typo in a comment
Date: Sun, 28 Jan 2018 09:20:42 -0600
Message-ID: <CAH2r5msNfKx-nv0beeooApu6yH-pU5Qwwn=LX0qi=F0Sh0EHUw@mail.gmail.com>
References: <20180128080948.GA16698@fubar>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Achilles Gaikwad <achillesgaikwad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180128080948.GA16698@fubar>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Sun, Jan 28, 2018 at 2:09 AM, Achilles Gaikwad
<achillesgaikwad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Signed-off-by: Achilles Gaikwad <achillesgaikwad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index b98436f5c7c7..13a8a77322c9 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -1125,7 +1125,7 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
>         return rc;
>  }
>
> -/* Translate the CIFS ACL (simlar to NTFS ACL) for a file into mode bits */
> +/* Translate the CIFS ACL (similar to NTFS ACL) for a file into mode bits */
>  int
>  cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>                   struct inode *inode, const char *path,
> --
> 2.14.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
