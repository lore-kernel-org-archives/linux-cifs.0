From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Mon, 20 Nov 2017 17:37:52 -0600
Message-ID: <CAH2r5muoR_8eFK+ZNUqdrzWTw3h6T9uHBYD4PbCUKYK6xCn1=A@mail.gmail.com>
References: <20171121101916.4970d5f9@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121101916.4970d5f9-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

fix for this warning merged into cifs-2.6.git for-next

On Mon, Nov 20, 2017 at 5:19 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>
> fs/cifs/smb2pdu.c: In function 'SMB2_read':
> fs/cifs/smb2pdu.c:2677:18: warning: unused variable 'rqst' [-Wunused-variable]
>   struct smb_rqst rqst = { .rq_iov = iov,
>                   ^
>
> Introduced by commit
>
>   889143494e16 ("cifs: remove rfc1002 header from smb2 read/write requests")
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
