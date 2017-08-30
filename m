From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v3 11/19] CIFS: SMBD: Define memory registration for I/O data
Date: Tue, 29 Aug 2017 17:48:56 -0700
Message-ID: <CAKywueSMXWN1tsHbFDGK9d9STL1qcC9G_VMfV2hz9YZhxhhH+w@mail.gmail.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com> <20170829192915.26251-12-longli@exchange.microsoft.com>
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
In-Reply-To: <20170829192915.26251-12-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-08-29 12:29 GMT-07:00 Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> To prepare for RDMA read/write using memory registration, add memory
> registartion pointers to upper layer data I/O context.
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index dc5404d..dcd2b63 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1166,6 +1166,7 @@ struct cifs_readdata {
>                                 struct cifs_readdata *rdata,
>                                 struct iov_iter *iter);
>         struct kvec                     iov[2];
> +       struct smbd_mr                  *mr;
>         unsigned int                    pagesz;
>         unsigned int                    tailsz;
>         unsigned int                    credits;
> @@ -1188,6 +1189,7 @@ struct cifs_writedata {
>         pid_t                           pid;
>         unsigned int                    bytes;
>         int                             result;
> +       struct smbd_mr                  *mr;
>         unsigned int                    pagesz;
>         unsigned int                    tailsz;
>         unsigned int                    credits;
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The same thing: let's not add structure fields that the code doesn't
do anything with.

--
Best regards,
Pavel Shilovsky
