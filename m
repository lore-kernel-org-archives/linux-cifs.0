From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix incorrect max RFC1002 write size value
Date: Sat, 8 Oct 2011 13:26:32 +0400
Message-ID: <CAKywueT7amLf8jV_Nn_SB_uPb47S5gGHVAYLnWDjys1g4=2D=w@mail.gmail.com>
References: <1318014354-18942-1-git-send-email-piastry@etersoft.ru>
	<CAH2r5mu4EzD16wvH8iUMVDoQwkiRpwvBWy2Qbt4CsN3JHoQu=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu4EzD16wvH8iUMVDoQwkiRpwvBWy2Qbt4CsN3JHoQu=g@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/8 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Is there a recreation scenario for this. =A0Your change makes sense b=
ut
> is it possible to hit?
>

Yes, it is. Assuming that we mounted share into /mnt/share with direct
mount option, the following code reproduces it:

import os
f =3D os.open('/mnt/share/test_file', os.O_RDWR | os.O_CREAT)
_str =3D ''.join('q' for _ in xrange(150000))
os.write(f, _str)

--
Best regards,
Pavel Shilovsky.
