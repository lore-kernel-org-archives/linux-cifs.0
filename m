From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v4 16/22] CIFS: SMBD: Fix the definition for SMB2_CHANNEL_RDMA_V1_INVALIDATE
Date: Wed, 4 Oct 2017 17:07:45 -0500
Message-ID: <CAH2r5msU_H5FS+ZeO6yEJFrqOYctsUktaJ=e2Lu4eT8x_DrQ-g@mail.gmail.com>
References: <20171002023030.3582-1-longli@exchange.microsoft.com> <20171002023030.3582-17-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002023030.3582-17-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Good catch - merged into cifs-2.6.git for-next

On Sun, Oct 1, 2017 at 9:30 PM, Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org> wrote:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> The channel value for requesting server remote invalidating local memory
> registration should be 0x00000002
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index 393ed5f..f783a08 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -832,7 +832,7 @@ struct smb2_flush_rsp {
>  /* Channel field for read and write: exactly one of following flags can be set*/
>  #define SMB2_CHANNEL_NONE              0x00000000
>  #define SMB2_CHANNEL_RDMA_V1           0x00000001 /* SMB3 or later */
> -#define SMB2_CHANNEL_RDMA_V1_INVALIDATE 0x00000001 /* SMB3.02 or later */
> +#define SMB2_CHANNEL_RDMA_V1_INVALIDATE 0x00000002 /* SMB3.02 or later */
>
>  /* SMB2 read request without RFC1001 length at the beginning */
>  struct smb2_read_plain_req {
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
