From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [SMB3][PATCH] Address the remaining sparse warning in new
 smbdirect code
Date: Sun, 4 Feb 2018 12:57:48 +1000
Message-ID: <CAN05THSCfhRa50tYhJdkKbS7732Bwv=_xc12-ukVZzr0vXCqYw@mail.gmail.com>
References: <CAH2r5muxQSY7j2vTPttd6R89QBwjMfnynE=19TjnCb5JV+20fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muxQSY7j2vTPttd6R89QBwjMfnynE=19TjnCb5JV+20fQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sun, Feb 4, 2018 at 11:52 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Even if one of these was a sparse bug (or being overly strict),
> it is worth fixing to quiet the builds (when smbdirect is enabled):
>
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=0e0b7d209c8ff56610629bd0bf0edc5c4e1e41a2
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
