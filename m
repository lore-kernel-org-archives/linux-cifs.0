From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mapchars option is completely broken in 2.6.38
Date: Fri, 13 May 2011 09:55:00 -0500
Message-ID: <BANLkTikc1Am-1TfdUePKPi58kmJV7fSiTQ@mail.gmail.com>
References: <1305257555-20656-1-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305257555-20656-1-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

thx - looks like an obvious candidate for stable as well.

On Thu, May 12, 2011 at 10:32 PM, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> w=
rote:
> Hi,
>
> here is a fix that lets the mapchars option work again for me
> in 2.6.38. Without this patch the string contains only zero bytes.
>
> metze
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
