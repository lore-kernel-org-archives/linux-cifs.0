From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v5 19/21] CIFS: SMBD: Read correct returned data length
 for RDMA write (SMB read) I/O
Date: Wed, 1 Nov 2017 09:50:06 -0700
Message-ID: <CAKywueSUUgxdxcdJbpo0YJTcxauVebzO45UPLD46zzrKVurc5A@mail.gmail.com>
References: <20171018230920.21042-1-longli@exchange.microsoft.com> <20171018230920.21042-20-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171018230920.21042-20-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

2017-10-18 16:09 GMT-07:00 Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> This patch is for preparing upper layer doing SMB read via RDMA write.
>
> When RDMA write is used for SMB read, the returned data length is in
> DataRemaining in the response packet. Reading it properly by adding a
> parameter to specifiy where the returned data length is.
>
> Add the defition for memory registration to wdata and return the correct
> length based on if RDMA write is used.
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h | 13 +++++++++++--
>  fs/cifs/cifssmb.c  |  7 ++++++-
>  fs/cifs/smb1ops.c  |  6 +++++-
>  fs/cifs/smb2ops.c  | 12 ++++++++++--
>  4 files changed, 32 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 2ae7d02..ddf83d8 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -228,8 +228,14 @@ struct smb_version_operations {
>         __u64 (*get_next_mid)(struct TCP_Server_Info *);
>         /* data offset from read response message */
>         unsigned int (*read_data_offset)(char *);
> -       /* data length from read response message */
> -       unsigned int (*read_data_length)(char *);
> +       /*
> +        * Data length from read response message
> +        * When in_remaining is true, the returned data length is in
> +        * message field DataRemaining for out-of-band data read (e.g through
> +        * Memory Registration RDMA write in SMBD).
> +        * Otherwise, the returned data length is in message field DataLength.
> +        */
> +       unsigned int (*read_data_length)(char *, bool in_remaining);
>         /* map smb to linux error */
>         int (*map_error)(char *, bool);
>         /* find mid corresponding to the response message */
> @@ -1148,6 +1154,9 @@ struct cifs_readdata {
>                                 struct cifs_readdata *rdata,
>                                 struct iov_iter *iter);
>         struct kvec                     iov[2];
> +#ifdef CONFIG_CIFS_SMB_DIRECT
> +       struct smbd_mr                  *mr;
> +#endif
>         unsigned int                    pagesz;
>         unsigned int                    tailsz;
>         unsigned int                    credits;
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 08ff56a..a343db4 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1533,8 +1533,13 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>                  rdata->iov[0].iov_base, server->total_read);
>
>         /* how much data is in the response? */
> -       data_len = server->ops->read_data_length(buf);
> +#ifdef CONFIG_CIFS_SMB_DIRECT
> +       data_len = server->ops->read_data_length(buf, rdata->mr);
> +       if (!rdata->mr && (data_offset + data_len > buflen)) {
> +#else
> +       data_len = server->ops->read_data_length(buf, false);
>         if (data_offset + data_len > buflen) {
> +#endif
>                 /* data_len is corrupt -- discard frame */
>                 rdata->result = -EIO;
>                 return cifs_readv_discard(server, mid);
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index a723df3..b718bb8 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -87,9 +87,13 @@ cifs_read_data_offset(char *buf)
>  }
>
>  static unsigned int
> -cifs_read_data_length(char *buf)
> +cifs_read_data_length(char *buf, bool in_remaining)
>  {
>         READ_RSP *rsp = (READ_RSP *)buf;
> +       if (in_remaining) {
> +               cifs_dbg(VFS, "Invalid SMB1 calling path, check code\n");

I would suggest to do WARN_ON(1) instead.

> +               return 0;
> +       }
>         return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
>                le16_to_cpu(rsp->DataLength);
>  }


--
Best regards,
Pavel Shilovsky
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
