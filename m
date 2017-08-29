From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v3 04/19] CIFS: SMBD: Add SMBDirect transport to SMB
 connection and Makefile
Date: Tue, 29 Aug 2017 16:11:55 -0700
Message-ID: <CAKywueRaTqR1yw_PbdcOYQTY9msweboej_6ZPcbsuyJfmiVgng@mail.gmail.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com> <20170829192915.26251-5-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829192915.26251-5-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-08-29 12:29 GMT-07:00 Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> Add SMBDirect as an optional connection to the SMB session structure in CIFS.
> When SMB session is connected through SMBDirect, upper layer uses this
> connection to carry payloads.
>
> With the transport code hooked up to upper layer, add SMBDirect code to
> Makefile.
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/Makefile   | 2 +-
>  fs/cifs/cifsglob.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
> index eed7eb0..6bb9863 100644
> --- a/fs/cifs/Makefile
> +++ b/fs/cifs/Makefile
> @@ -18,4 +18,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
>  cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
>
>  cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o \
> -                           smb2misc.o smb2pdu.o smb2inode.o smb2file.o
> +                           smb2misc.o smb2pdu.o smb2inode.o smb2file.o smbdirect.o
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 703c2fb..dc5404d 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -652,6 +652,8 @@ struct TCP_Server_Info {
>         bool    large_buf;              /* is current buffer large? */
>         /* use SMBD connection instead of socket */
>         bool    rdma;
> +       /* point to the SMBD connection if RDMA is used instead of socket */
> +       struct smbd_connection *smbd_conn;
>         struct delayed_work     echo; /* echo ping workqueue job */
>         char    *smallbuf;      /* pointer to current "small" buffer */
>         char    *bigbuf;        /* pointer to current "big" buffer */
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

It is better to split the current patch into 2 and merge the Makefile
part to #3 and cifsglob.h part to #5.

--
Best regards,
Pavel Shilovsky
