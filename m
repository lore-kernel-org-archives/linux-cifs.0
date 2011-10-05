From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: broken mandatory locking behavior
Date: Wed, 5 Oct 2011 13:24:59 +0400
Message-ID: <CAKywueTeJJ9OKPmOMZ2n3mZYTWW5taLvoRaw_QiDy29cK7NCEw@mail.gmail.com>
References: <CAKywueSgXNhmoA7V82U5Y0=N+DQWysekAwDdsiLMPt6L0OV55Q@mail.gmail.com>
	<20111001083636.247525dc@tlielax.poochiereds.net>
	<CAKywueTN=QTBA+tqT79ObfXYmKmA4Rcx9N-XBDoJCURk0JPu+g@mail.gmail.com>
	<20111004065451.41bc3d2f@tlielax.poochiereds.net>
	<20111004162758.GA11682@fieldses.org>
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
In-Reply-To: <20111004162758.GA11682-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/4 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Tue, Oct 04, 2011 at 06:54:51AM -0400, Jeff Layton wrote:
>> I think this is tantamount to insisting that applications be special=
ly
>> written for cifs.ko if they want to do locking.
>>
>> The larger goal for cifs.ko (as I see it) is to allow applications t=
o
>> mostly run unchanged on top of windows servers. Naturally, this is
>> impossible since windows doesn't follow POSIX semantics, so the best=
 we
>> can do is closely approximate it.
>>
>> There's certainly room for improvement here, but what you're proposi=
ng
>> sounds like a step backward from that goal. It will break a lot of
>> existing applications that run successfully on top of cifs.ko today.
>
> Right. =A0You can tell which kind of locking the application wants by=
 the
> interface it's using. =A0If the application is using fcntl F_GETLK,
> F_SETLK, F_SETLKW, then chances are it was written assuming posix
> semantics, so all we can do is emulate those as best as possible.
>
> If there are applications that need want the Windows semantics, then
> we'd need to provide a new lock interface which promises them exactly
> that.
>
> --b.
>

Ok, I understand your and Jeff's idea - it's better to support POSIX
at least partly than doesn't support it at all.

I don't think that we need VFS changes for the new mode, because it is
cifs feature only. All that we need is to support this for cifs - so,
it can be a new mount option or the existing one - now we have
'forcemand' mount option (that switch on mandatory locking even if the
server support POSIX one) that can includes such a change. What do you
think about it?

--=20
Best regards,
Pavel Shilovsky.
