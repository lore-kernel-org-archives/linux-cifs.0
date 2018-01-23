From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: manpage: update mount.cifs manpage with info about echo_interval option.
Date: Tue, 23 Jan 2018 17:05:01 -0600
Message-ID: <CAH2r5mtYrwGNZxrUaN_pWi-hzxGLyae19JY2ijDcjYTCERcpRg@mail.gmail.com>
References: <CAA_-hQJ=DsbeVWU7mr-W0sTRiPXnCC3vznmznQwBedQLtE0s_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Kenneth Dsouza <kdsouza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAA_-hQJ=DsbeVWU7mr-W0sTRiPXnCC3vznmznQwBedQLtE0s_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

looks reasonable

On Tue, Jan 23, 2018 at 11:37 AM, Kenneth Dsouza <kdsouza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Signed-off-by:  Kenneth D'souza <kdsouza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index 023ff34..efd7055 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -385,6 +385,14 @@ mfsymlinks
>    option. Minshall+French symlinks are used even if the server supports
>    the CIFS Unix Extensions.
>
> +echo_interval=n
> +  sets the interval at which echo requests are sent to the server on an
> +  idling connection. This setting also affects the time required
> +  for a connection to an unresponsive server to timeout.
> +  Here n is the echo interval in seconds. If this option is not given then
> +  the default value of 60 seconds is used.
> +  The minimum tunable value is 1 second and maximum can go up to 600 seconds.
> +
>  serverino
>    Use inode numbers (unique persistent file identifiers) returned by the
>    server instead of automatically generating temporary inode numbers on
>
>
>
>
> Kind Regards,
> Kenneth D'souza
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
