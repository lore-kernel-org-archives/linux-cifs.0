From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 3/7] CIFS: Move trans2 processing to ops struct
Date: Wed, 30 May 2012 20:42:04 +0400
Message-ID: <CAKywueR775s-eDra0RtBewj0=nax=H_wwPx1aPFUvWOxXgs4dQ@mail.gmail.com>
References: <1338308344-29149-1-git-send-email-pshilovsky@samba.org>
	<1338308344-29149-4-git-send-email-pshilovsky@samba.org>
	<20120530113523.6b76177e@corrin.poochiereds.net>
	<CAKywueQzkZRyyhNpkQn8V8YHf9AuK+dM3t_zZRWs1cJo7vP61A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQzkZRyyhNpkQn8V8YHf9AuK+dM3t_zZRWs1cJo7vP61A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/30 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Thanks for the review!
>
> As for the macro itself. Instead of this:
>
> if (S_OP(server, check_trans2, false, mid, server, buf, malformed))
> =A0 =A0 =A0 =A0return;
>
> we will have:
>
> if (server->ops->check_trans2 && server->ops->check_trans2(mid,
> server, buf, malformed))
> =A0 =A0 =A0 =A0return;
>
> that looks bigger.
>
> And for non-void functions:
>
> rc =3D server->ops->negotiate? server->ops->negotiate(server, xid, se=
s))
> : -ENOSYS;
>
> the macro reduces this place to
>
> rc =3D S_OP(server, negotiate, -ENOSYS, xid, ses);
>
> that also looks more compact.
>
> I am not sure that the name of the macro is ideal - suggestions are w=
elcome!
>
> --
> Best regards,
> Pavel Shilovsky.

Sorry - email web client split the lines.

--=20
Best regards,
Pavel Shilovsky.
