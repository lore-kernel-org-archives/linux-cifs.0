From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix memory leaks in SMB2_open
Date: Mon, 26 May 2014 22:54:32 -0500
Message-ID: <CADT32eJUyb=e5Bk78StKXb==hkM02xbgSjS6e3u_Ko1zd-wcsg@mail.gmail.com>
References: <1400935322-5157-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400935322-5157-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct.

Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Sat, May 24, 2014 at 7:42 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.12+
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index b0037b6..b0b260d 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1097,6 +1097,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>         int rc = 0;
>         unsigned int num_iovecs = 2;
>         __u32 file_attributes = 0;
> +       char *dhc_buf = NULL, *lc_buf = NULL;
>
>         cifs_dbg(FYI, "create/open\n");
>
> @@ -1163,6 +1164,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>                         kfree(copy_path);
>                         return rc;
>                 }
> +               lc_buf = iov[num_iovecs-1].iov_base;
>         }
>
>         if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
> @@ -1177,9 +1179,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>                 if (rc) {
>                         cifs_small_buf_release(req);
>                         kfree(copy_path);
> -                       kfree(iov[num_iovecs-1].iov_base);
> +                       kfree(lc_buf);
>                         return rc;
>                 }
> +               dhc_buf = iov[num_iovecs-1].iov_base;
>         }
>
>         rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
> @@ -1211,6 +1214,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>                 *oplock = rsp->OplockLevel;
>  creat_exit:
>         kfree(copy_path);
> +       kfree(lc_buf);
> +       kfree(dhc_buf);
>         free_rsp_buf(resp_buftype, rsp);
>         return rc;
>  }
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
