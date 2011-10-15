From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Pavel's Lock cleanup
Date: Sat, 15 Oct 2011 19:27:27 +0400
Message-ID: <CAKywueSEdX7VKZ3LAM2xvVgqrE0Pu9PMbV+jMVDUt-99CbhFPQ@mail.gmail.com>
References: <CAH2r5mtNGd-+YUXJwU2USPN_7XnQYdSaYh_HJrzyaM3g6o9szw@mail.gmail.com>
	<20111014211214.GA15319@fieldses.org>
	<CAH2r5msGZjEZP=BVWQedO80+W2yPJPvtd0+i5dAS9X0nq6=9kw@mail.gmail.com>
	<20111014232939.GA15881@fieldses.org>
	<CAH2r5mvd+N_F897=jAjc7x=186YAHwe=jwQDD=JnOu8YFmu3qw@mail.gmail.com>
	<CAH2r5mubN4RGznpLQbgLGSytaK-xM2Mz0dBNm-koKgBuUExPcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mubN4RGznpLQbgLGSytaK-xM2Mz0dBNm-koKgBuUExPcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/15 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Fri, Oct 14, 2011 at 7:02 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>> On oplock vs. leases (in MS usage, oplock is the older term). =A0An =
oplock was -
>> 1) requested on open (presumably what the "op" part of the name mean=
t)
>> 2) had only a few types: =A0"batch" (could cache data, and cache ope=
n/close)
>> and "read write" (could cache read or writes of data) and later a
>> "read only" type was
>> added (allowing you to cache writes)
>
> oops - I meant "allowing you to cache reads" (obviously)
>

Also, note that batch and read write oplocks allow to cache byte-range
locks on the client.

--=20
Best regards,
Pavel Shilovsky.
