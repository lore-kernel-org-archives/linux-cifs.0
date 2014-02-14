From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix too big maxBuf size for SMB3 mounts
Date: Fri, 14 Feb 2014 16:51:45 -0600
Message-ID: <CAH2r5mvs_rUd7nnrXQJzBO9abFrN7Hy7Ceu9HjnBd5sK-g3ToA@mail.gmail.com>
References: <1392370263-10364-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392370263-10364-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git for-next

On Fri, Feb 14, 2014 at 3:31 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> SMB3 servers can respond with MaxTransactSize of more than 4M
> that can cause a memory allocation error returned from kmalloc
> in a lock codepath. Also the client doesn't support multicredit
> requests now and allows buffer sizes of 65536 bytes only. Set
> MaxTransactSize to this maximum supported value.
>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.7+
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/smb2glob.h |    3 +++
>  fs/cifs/smb2ops.c  |   14 ++++----------
>  fs/cifs/smb2pdu.c  |    4 +++-
>  3 files changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
> index c383508..bc0bb9c 100644
> --- a/fs/cifs/smb2glob.h
> +++ b/fs/cifs/smb2glob.h
> @@ -57,4 +57,7 @@
>  #define SMB2_CMACAES_SIZE (16)
>  #define SMB3_SIGNKEY_SIZE (16)
>
> +/* Maximum buffer size value we can send with 1 credit */
> +#define SMB2_MAX_BUFFER_SIZE 65536
> +
>  #endif /* _SMB2_GLOB_H */
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 757da3e..192f51a 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -182,11 +182,8 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
>         /* start with specified wsize, or default */
>         wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
>         wsize = min_t(unsigned int, wsize, server->max_write);
> -       /*
> -        * limit write size to 2 ** 16, because we don't support multicredit
> -        * requests now.
> -        */
> -       wsize = min_t(unsigned int, wsize, 2 << 15);
> +       /* set it to the maximum buffer size value we can send with 1 credit */
> +       wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
>
>         return wsize;
>  }
> @@ -200,11 +197,8 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
>         /* start with specified rsize, or default */
>         rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
>         rsize = min_t(unsigned int, rsize, server->max_read);
> -       /*
> -        * limit write size to 2 ** 16, because we don't support multicredit
> -        * requests now.
> -        */
> -       rsize = min_t(unsigned int, rsize, 2 << 15);
> +       /* set it to the maximum buffer size value we can send with 1 credit */
> +       rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
>
>         return rsize;
>  }
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 2013234..787e171 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -413,7 +413,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>
>         /* SMB2 only has an extended negflavor */
>         server->negflavor = CIFS_NEGFLAVOR_EXTENDED;
> -       server->maxBuf = le32_to_cpu(rsp->MaxTransactSize);
> +       /* set it to the maximum buffer size value we can send with 1 credit */
> +       server->maxBuf = min_t(unsigned int, le32_to_cpu(rsp->MaxTransactSize),
> +                              SMB2_MAX_BUFFER_SIZE);
>         server->max_read = le32_to_cpu(rsp->MaxReadSize);
>         server->max_write = le32_to_cpu(rsp->MaxWriteSize);
>         /* BB Do we need to validate the SecurityMode? */
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
