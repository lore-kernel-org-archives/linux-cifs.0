From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2][CIFS] Workaround MacOS server problem with SMB2.1 write response
Date: Wed, 15 Oct 2014 21:10:43 -0500
Message-ID: <CADT32eLqpNQsmjo_KbGk0JO-13mw_hRnGex47HJnrcE+epR9CA@mail.gmail.com>
References: <CAH2r5ms1kt=Rb7LAGt8zGiWUjCk-6e0fFqqNwFJztf++Q9kVog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms1kt=Rb7LAGt8zGiWUjCk-6e0fFqqNwFJztf++Q9kVog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Aug 15, 2014 at 11:54 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Writes fail to Mac servers with SMB2.1 mounts (works with cifs though) due
> to them sending an incorrect RFC1001 length for the SMB2.1 Write response.
> Workaround this problem. MacOS server sends a write response with 3 bytes
> of pad beyond the end of the SMB itself.  The RFC1001 length is 3 bytes
> more than the sum of the SMB2.1 header length + the write reponse.
>
> Incorporate feedback from Jeff and JRA to allow servers to send
> a tcp frame that is even more than three bytes too long
> (ie much longer than the SMB2/SMB3 request that it contains) but
> we do log it once now. In the earlier version of the patch I had
> limited how far off the length field could be before we fail the request.
>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/smb2misc.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index f2e6ac2..4aa7a0f 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -178,9 +178,24 @@ smb2_check_message(char *buf, unsigned int length)
>          /* Windows 7 server returns 24 bytes more */
>          if (clc_len + 20 == len && command == SMB2_OPLOCK_BREAK_HE)
>              return 0;
> -        /* server can return one byte more */
> +        /* server can return one byte more due to implied bcc[0] */
>          if (clc_len == 4 + len + 1)
>              return 0;
> +
> +        /*
> +         * MacOS server pads after SMB2.1 write response with 3 bytes
> +         * of junk. Other servers match RFC1001 len to actual
> +         * SMB2/SMB3 frame length (header + smb2 response specific data)
> +         * Log the server error (once), but allow it and continue
> +         * since the frame is parseable.
> +         */
> +        if (clc_len < 4 /* RFC1001 header size */ + len) {
> +            printk_once(KERN_WARNING
> +                "SMB2 server sent bad RFC1001 len %d not %d\n",
> +                len, clc_len - 4);
> +            return 0;
> +        }
> +
>          return 1;
>      }
>      return 0;
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
