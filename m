From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 20/31] fs/cifs: use kmemdup rather than duplicating its implementation
Date: Thu, 17 Sep 2015 00:00:18 -0500
Message-ID: <CAH2r5mua5sqEuD38y+q_3eM_EDBMjWNpWyCzBcWu5OofELXfQw@mail.gmail.com>
References: <1438934377-4922-1-git-send-email-a.hajda@samsung.com> <1438934377-4922-21-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438934377-4922-21-git-send-email-a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

loooks reasonable to me - isn't this part of a larger patch series
though? Did you want it merged distinctly into cifs-2.6.git?

On Fri, Aug 7, 2015 at 2:59 AM, Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> The patch was generated using fixed coccinelle semantic patch
> scripts/coccinelle/api/memdup.cocci [1].
>
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2014320
>
> Signed-off-by: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 070fb2a..2d6b72f 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1394,14 +1394,13 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>                 goto ioctl_exit;
>         }
>
> -       *out_data = kmalloc(*plen, GFP_KERNEL);
> +       *out_data = kmemdup(rsp->hdr.ProtocolId + le32_to_cpu(rsp->OutputOffset),
> +                           *plen, GFP_KERNEL);
>         if (*out_data == NULL) {
>                 rc = -ENOMEM;
>                 goto ioctl_exit;
>         }
>
> -       memcpy(*out_data, rsp->hdr.ProtocolId + le32_to_cpu(rsp->OutputOffset),
> -              *plen);
>  ioctl_exit:
>         free_rsp_buf(resp_buftype, rsp);
>         return rc;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
