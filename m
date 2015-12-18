From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cifs: Check uniqueid for SMB2+ and return -ESTALE
 if necessary
Date: Fri, 18 Dec 2015 12:18:33 -0600
Message-ID: <CAH2r5msRPnTz+bSE436EXudoEF+SW_zyO=fm4zYoDfRaAfVeiQ@mail.gmail.com>
References: <1449067568-23038-1-git-send-email-ross.lagerwall@citrix.com> <1449067568-23038-2-git-send-email-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449067568-23038-2-git-send-email-ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

If any strong preferences about whether it should go to stable let me know

On Wed, Dec 2, 2015 at 8:46 AM, Ross Lagerwall
<ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> Commit 7196ac113a4f ("Fix to check Unique id and FileType when client
> refer file directly.") checks whether the uniqueid of an inode has
> changed when getting the inode info, but only when using the UNIX
> extensions. Add a similar check for SMB2+, since this can be done
> without an extra network roundtrip.
>
> Signed-off-by: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> ---
> v2:
> Changed to not do an extra network roundtrip to get the uniqueid.
>
>  fs/cifs/inode.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 6b66dd5..d14c05b 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -814,8 +814,21 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>                         }
>                 } else
>                         fattr.cf_uniqueid = iunique(sb, ROOT_I);
> -       } else
> -               fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
> +       } else {
> +               if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
> +                   validinum == false && server->ops->get_srv_inum) {
> +                       /*
> +                        * Pass a NULL tcon to ensure we don't make a round
> +                        * trip to the server. This only works for SMB2+.
> +                        */
> +                       tmprc = server->ops->get_srv_inum(xid,
> +                               NULL, cifs_sb, full_path,
> +                               &fattr.cf_uniqueid, data);
> +                       if (tmprc)
> +                               fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
> +               } else
> +                       fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
> +       }
>
>         /* query for SFU type info if supported and needed */
>         if (fattr.cf_cifsattrs & ATTR_SYSTEM &&
> @@ -856,6 +869,13 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>         } else {
>                 /* we already have inode, update it */
>
> +               /* if uniqueid is different, return error */
> +               if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
> +                   CIFS_I(*inode)->uniqueid != fattr.cf_uniqueid)) {
> +                       rc = -ESTALE;
> +                       goto cgii_exit;
> +               }
> +
>                 /* if filetype is different, return error */
>                 if (unlikely(((*inode)->i_mode & S_IFMT) !=
>                     (fattr.cf_mode & S_IFMT))) {
> --
> 2.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
