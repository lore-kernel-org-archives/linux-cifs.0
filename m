From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Pavel's Lock cleanup
Date: Fri, 14 Oct 2011 19:04:02 -0500
Message-ID: <CAH2r5mubN4RGznpLQbgLGSytaK-xM2Mz0dBNm-koKgBuUExPcQ@mail.gmail.com>
References: <CAH2r5mtNGd-+YUXJwU2USPN_7XnQYdSaYh_HJrzyaM3g6o9szw@mail.gmail.com>
	<20111014211214.GA15319@fieldses.org>
	<CAH2r5msGZjEZP=BVWQedO80+W2yPJPvtd0+i5dAS9X0nq6=9kw@mail.gmail.com>
	<20111014232939.GA15881@fieldses.org>
	<CAH2r5mvd+N_F897=jAjc7x=186YAHwe=jwQDD=JnOu8YFmu3qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvd+N_F897=jAjc7x=186YAHwe=jwQDD=JnOu8YFmu3qw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 14, 2011 at 7:02 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> On oplock vs. leases (in MS usage, oplock is the older term). =A0An o=
plock was -
> 1) requested on open (presumably what the "op" part of the name meant=
)
> 2) had only a few types: =A0"batch" (could cache data, and cache open=
/close)
> and "read write" (could cache read or writes of data) and later a
> "read only" type was
> added (allowing you to cache writes)

oops - I meant "allowing you to cache reads" (obviously)


--=20
Thanks,

Steve
