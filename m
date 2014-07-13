From: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: Re: Patch series reviews
Date: Sun, 13 Jul 2014 17:39:57 +0400
Message-ID: <D805D0FB-B31D-48C5-96C8-18811BDD2176@gmail.com>
References: <CAH2r5muVJjqdnPnw--LsOim5ximr=uTS_7avBP2i8kLdx4agAQ@mail.gmail.com> <CAH2r5mtOGn02nU9FVgGB0eUt+o7+=XuR1VjMPiHEi0m7P-cyhQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtOGn02nU9FVgGB0eUt+o7+=XuR1VjMPiHEi0m7P-cyhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

13.07.2014, =D7 5:18, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =CE=C1=D0=C9=D3=
=C1=CC(=C1):

> I have temporarily merged most (all but the last two) of your smb3

Good. Thanks!

The last two patches are not prepared yet. I was gong to merge both or =
only the first to the patch 6/7 of the last series. What is more prefer=
red now: to merge them to this patch and repost or keep them as a separ=
ate patch?


> multicredit series into cifs-2.6.git for-next, but I don't see signed
> off/reviewed-by/acked-by for your series for any patches beyond these
> in the series (which were acked by Jeff).  Are there others with
> reviewed-by feedback that you would like me to include.


No, I don't have any other reviewed-by feedback.

>=20
> commit 8f57fd1cea32316b3ae41ee520b938089bee761b
> Author: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Date:   Thu Jun 19 15:28:37 2014 +0400
>=20
>    CIFS: Separate page sending from writepages
>=20
>    Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>    Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> commit fecd99690172bfec337c489687842e29906b2575
> Author: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Date:   Thu Jun 19 15:01:03 2014 +0400
>=20
>    CIFS: Separate page processing from writepages
>=20
>    Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>    Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
>=20
>=20
>=20
> --=20
> Thanks,
>=20
> Steve
