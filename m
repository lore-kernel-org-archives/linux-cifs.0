From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] update mount.cifs manpage with info about
 echo_interval option.
Date: Tue, 30 Jan 2018 17:43:19 +0530
Message-ID: <CAMcOejVQYB9xC7fQGFQ86=ZcwvL+0HyaiaygdBs1zHpHFGDk0Q@mail.gmail.com>
References: <CAA_-hQKtvKwC1aKYYhe=gieVj9MXgEms2QDfCMgbeHhFPhiBbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "French, Steve" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Kenneth Dsouza <kdsouza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAA_-hQKtvKwC1aKYYhe=gieVj9MXgEms2QDfCMgbeHhFPhiBbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Acked-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Jan 29, 2018 at 10:16 PM, Kenneth Dsouza <kdsouza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Adds information regarding reconnection time.
>
> Signed-off-by: Kenneth D'souza <kdsouza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mount.cifs.rst | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index 023ff34..3bf30cd 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -385,6 +385,15 @@ mfsymlinks
>    option. Minshall+French symlinks are used even if the server supports
>    the CIFS Unix Extensions.
>
> +echo_interval=n
> +  sets the interval at which echo requests are sent to the server on an
> +  idling connection. This setting also affects the time required for a
> +  connection to an unresponsive server to timeout. Here n is the echo
> +  interval in seconds. The reconnection happens at twice the value of the
> +  echo_interval set for an unresponsive server.
> +  If this option is not given then the default value of 60 seconds is used.
> +  The minimum tunable value is 1 second and maximum can go up to 600 seconds.
> +
>  serverino
>    Use inode numbers (unique persistent file identifiers) returned by the
>    server instead of automatically generating temporary inode numbers on
> --
> 2.14.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
