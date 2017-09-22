From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [SMB3] Handle O_SYNC/DSYNC and O_DIRECT flags on SMB3 opens
Date: Fri, 22 Sep 2017 16:50:35 -0700
Message-ID: <CAKywueSWZoDNhqOwEmZh3uEtNyO5PBi4OKCHc3D7krwzw39Yrg@mail.gmail.com>
References: <CAH2r5msgp0GsR8zj9ku7CKHB2amUavj1Bd42YELYUqTcVtJ0EA@mail.gmail.com>
 <CAH2r5mv4ZN9dtpmhDk8_enVPwJqPBoewrVBtV6Hv64QE+saj5Q@mail.gmail.com> <2120555110.8699523.1506063009492.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2120555110.8699523.1506063009492.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-09-21 23:50 GMT-07:00 Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Looks sane to me.
>
> Rewieved-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
>
> ----- Original Message -----
> From: "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Friday, 22 September, 2017 4:47:46 PM
> Subject: Fwd: [SMB3] Handle O_SYNC/DSYNC and O_DIRECT flags on SMB3 opens
>
> ---------- Forwarded message ----------
> From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Fri, Sep 22, 2017 at 1:43 AM
> Subject: [SMB3] Handle O_SYNC/DSYNC and O_DIRECT flags on SMB3 opens
> To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>
>
> We were only handling them on CIFS POSIX/Unix mounts.
>
> Fix them for SMB3 (and non-POSIX CIFS) mounts
>
>
>
> --
> Thanks,
>
> Steve
>
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
