From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next build break
Date: Tue, 25 Oct 2011 10:13:37 -0500
Message-ID: <CADT32eLA2Ojex7orzikdhHx1Td+cnh6Qa2a8NqyESSJFQoHBAA@mail.gmail.com>
References: <CAH2r5mt=P9EpvEEN+ehJd61_QKpUxCcKKFz16RGNpboF3HpZCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt=P9EpvEEN+ehJd61_QKpUxCcKKFz16RGNpboF3HpZCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 25, 2011 at 10:02 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> Had a typo in my earlier proposed patch
>
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index a155561..5989883 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -203,6 +203,9 @@ static inline void set_freezable_with_signal(void=
) {}
> =A0#define wait_event_freezable_timeout(wq, condition, timeout) =A0 =A0=
 =A0 =A0 =A0 \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wait_event_interruptible_timeout(wq, c=
ondition, timeout)
>
> +#define wait_event_freezekillable(wq, condition) =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event_killable(wq, condition)
> +
> =A0#endif /* !CONFIG_FREEZER */
>
> =A0#endif /* FREEZER_H_INCLUDED */
>
> --
> Thanks,
>
> Steve
>

Looks correct.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
