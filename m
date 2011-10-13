From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: async read patchset test results
Date: Thu, 13 Oct 2011 21:55:15 +0400
Message-ID: <CAKywueSsCbTQdMPQqPd+hexaodcjgQKA9QTq0MNkL9-k-C+LTg@mail.gmail.com>
References: <CAKywueS=dRdBzumxHc+QH1A3QhfTm7b8a2pM4w0pb6VXoi7aOQ@mail.gmail.com>
	<20111013083151.55aa1cdf@barsoom.rdu.redhat.com>
	<CAKywueQg90k2FwRB+fJbmwq230p-DP-Zxtrc0+HP_gfieHxM6g@mail.gmail.com>
	<20111013133414.77f54658@barsoom.rdu.redhat.com>
	<CAKywueTjAwgmSpYeqX-iu6FhZbCiG5HTztDhNLWYFMkq3cmoBg@mail.gmail.com>
	<CAH2r5msUKNYFMMyixLdnZ=BndxOp-ySrViYRhjkBpBDsQh_-aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msUKNYFMMyixLdnZ=BndxOp-ySrViYRhjkBpBDsQh_-aQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/13 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Any sign of reconnects in the failure case?=A0 (/proc/fs/cifs/Stats f=
or
> example)
>
> Can you add (or flip a debug message from cFYI to cERROR) a debug mes=
sage
> for any write errors
> in SMB write ...?

It isn't a write error, because when I load vanilla module reads it
ok. Unfortunately, I rebooted my system - so, can't get any error
message now - I will continue trying to catch the bug and report the
info once got it.

--=20
Best regards,
Pavel Shilovsky.
