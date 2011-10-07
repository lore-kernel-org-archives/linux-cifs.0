From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: broken mandatory locking behavior
Date: Fri, 7 Oct 2011 12:57:18 +0400
Message-ID: <CAKywueSXdyoq_wCUGy9xcwAMdpoU0VP0oV05rMtH8X5kddMNbA@mail.gmail.com>
References: <CAKywueSgXNhmoA7V82U5Y0=N+DQWysekAwDdsiLMPt6L0OV55Q@mail.gmail.com>
	<20111001083636.247525dc@tlielax.poochiereds.net>
	<CAKywueTN=QTBA+tqT79ObfXYmKmA4Rcx9N-XBDoJCURk0JPu+g@mail.gmail.com>
	<20111004065451.41bc3d2f@tlielax.poochiereds.net>
	<20111004162758.GA11682@fieldses.org>
	<CAKywueTeJJ9OKPmOMZ2n3mZYTWW5taLvoRaw_QiDy29cK7NCEw@mail.gmail.com>
	<20111005060936.2b9ee7f5@tlielax.poochiereds.net>
	<20111005104034.GA12809@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111005104034.GA12809-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/5 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Wed, Oct 05, 2011 at 06:09:36AM -0400, Jeff Layton wrote:
>> I'm not a fan of adding more mount-option enabled hacks to cifs to
>> support wine. If wine or other applications need windows semantics,
>> then I would prefer to see you add proper vfs-level interfaces to
>> provide them.
>
> Agreed. =A0A mount option that changes semantics in subtle ways will =
cause
> applications to fail in sutble and unpredictable ways when it's set
> wrong. =A0And doesn't have any hope of handling the case of a mixture=
 of
> POSIX and Windows applications on the same filesystem.
>
> Whereas a new interface, when it's unavailable, will cause a clean
> predictable failure right at the start, allowing the application to g=
ive
> a helpful error message, or fall back on different behavior if it
> chooses to.
>
> Also, before building anything more on top of Linux mandatory locking=
,
> somebody should really fix the existing bugs--the current implementat=
ion
> has races.
>
> --b.
>

Ok, I will think about how to do this kind of things better.

So, I will send my locking patchset without unlock behavior change.

--=20
Best regards,
Pavel Shilovsky.
