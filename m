From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix incorrect max RFC1002 write size value
Date: Fri, 7 Oct 2011 18:37:47 -0500
Message-ID: <CAH2r5mu4EzD16wvH8iUMVDoQwkiRpwvBWy2Qbt4CsN3JHoQu=g@mail.gmail.com>
References: <1318014354-18942-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318014354-18942-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Is there a recreation scenario for this.  Your change makes sense but
is it possible to hit?

On Fri, Oct 7, 2011 at 2:05 PM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> w=
rote:
> ..the length field has only 17 bits.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 633c246..5779002 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2807,10 +2807,10 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolu=
me_info,
>
> =A0/*
> =A0* When the server doesn't allow large posix writes, only allow a w=
size of
> - * 128k minus the size of the WRITE_AND_X header. That allows for a =
write up
> + * 2^17-1 minus the size of the WRITE_AND_X header. That allows for =
a write up
> =A0* to the maximum size described by RFC1002.
> =A0*/
> -#define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
> +#define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - 1 - sizeof(WRITE_REQ) +=
 4)
>
> =A0/*
> =A0* The default wsize is 1M. find_get_pages seems to return a maximu=
m of 256
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
