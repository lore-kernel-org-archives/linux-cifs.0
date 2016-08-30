From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs_upcall dns_resolver
Date: Tue, 30 Aug 2016 10:41:36 -0500
Message-ID: <CAH2r5mtmx9oeXY6BT8FKZfXdiFLNQO-JB+b65Soy4k3YMRJ=_Q@mail.gmail.com>
References: <71805461419A1B47A24D8A19706E34983767A7D4@EXDAG0-A1.intra.cea.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: LEROY Christine 208562 <Christine.LEROY2-KCE40YydGKI@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <71805461419A1B47A24D8A19706E34983767A7D4-+31bnjmoVjc8KqdCPk9DGyghONGMnRii@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is probably a Linux distribution configuration choice, better to
ask your distro maintainers.   DNS_RESOLVER is automatically selected
if CIFS_UPCALL (since 2010, so it has been there a long time) is
selected (and if KEYS is not available then CIFS_UPCALL won't be
selected).

>From fs/cifs/Kconfig
 86 config CIFS_UPCALL
 87     bool "Kerberos/SPNEGO advanced session setup"
 88     depends on CIFS && KEYS
 89     select DNS_RESOLVER

On Tue, Aug 30, 2016 at 3:08 AM, LEROY Christine 208562
<Christine.LEROY2-KCE40YydGKI@public.gmane.org> wrote:
> Hello,
>
> I was wondering why the cifs_upcall is not configured by default with the dns_resolver on linux kernel 2.6.32 (at least)  ?
> We had windelinks on our CIFS server and it took many times for us to understand the problem not accesing these widelinks.
> Is there some security issue or ??
> Thanks in advance,
> Cheers
> Christine
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
