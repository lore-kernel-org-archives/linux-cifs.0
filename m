From: Pavel Shilovsky <pavel.shilovsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] SMB: fix validate negotiate info uninitialised memory use
Date: Wed, 25 Oct 2017 11:04:31 -0700
Message-ID: <CAKywueRfuv9c=edNzA0iUO4s3_T=CWXhFZTvNVvEzd1Fb9PJuw@mail.gmail.com>
References: <20171020102033.22936-1-shuwang@redhat.com> <20171020124938.9913-1-ddiss@suse.de>
 <20171020124938.9913-3-ddiss@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Shu Wang <shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020124938.9913-3-ddiss-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks good.

Acked-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>


Best regards,
Pavel Shilovskiy


2017-10-20 5:49 GMT-07:00 David Disseldorp via samba-technical
<samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>:
> An undersize validate negotiate info server response causes the client
> to use uninitialised memory for struct validate_negotiate_info_rsp
> comparisons of Dialect, SecurityMode and/or Capabilities members.
>
> Link: https://bugzilla.samba.org/show_bug.cgi?id=13092
> Fixes: 7db0a6efdc3e ("SMB3: Work around mount failure when using SMB3 dialect to Macs")
> Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 052ab5dee6b6..c836de2f79b2 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -727,7 +727,8 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>                          rsplen);
>
>                 /* relax check since Mac returns max bufsize allowed on ioctl */
> -               if (rsplen > CIFSMaxBufSize)
> +               if ((rsplen > CIFSMaxBufSize)
> +                    || (rsplen < sizeof(struct validate_negotiate_info_rsp)))
>                         goto err_rsp_free;
>         }
>
> --
> 2.13.6
>
>
