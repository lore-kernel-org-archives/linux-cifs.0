From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix a possible memory corruption during reconnect
Date: Mon, 28 Nov 2016 11:53:03 -0800
Message-ID: <CAKywueSKN2g=-abFdVWd5_3C1fJmNmnR0iZDtsrs2DEfDsUa+A@mail.gmail.com>
References: <1478820683-2954-1-git-send-email-pshilov@microsoft.com>
 <CAKywueR-0h7i2-8OVaC8+KKh1Yjq_otdpuFu582bW=0xQ=+E9Q@mail.gmail.com> <mps8ts8u8u1.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mps8ts8u8u1.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-11-24 8:43 GMT-08:00 Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> Hi Pavel,
>
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>> 2016-11-10 15:31 GMT-08:00 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> We can not unlock/lock cifs_tcp_ses_lock while walking through ses
>>> and tcon lists because it can corrupt list iterator pointers and
>>> a tcon structure can be released if we don't hold an extra reference.
>>> Fix it by moving a reconnect process to a separate delayed work
>>> and acquiring a reference to every tcon that needs to be reconnected.
>>> Also do not send an echo request on newly established connections.
>
> I don't fully understand what's going on here but I've successfully
> tested your patch.
>
> I've applied your patch and triggered a reconnexion on a smb2 mount by
> virtually unplugging/waiting/replugging the network cable (via qemu
> set_link <name> on/off). I did not notice any issues.
>
> Let us know if you have a better scenario to test this or a way to
> reproduce the previous issue.
>
> Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)

Thank you for testing this!

I don't have a scripted reproducer but sending something wrong to the
server during mounting was triggering this issue. For example, if we
send a wrong SMB2 header on Create request the kernel crashes after
several mount attempts.

--=20
Best regards,
Pavel Shilovsky
