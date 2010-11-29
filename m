From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] CIFS: Make read call work with strict cache mode (try #2)
Date: Mon, 29 Nov 2010 13:41:13 +0300
Message-ID: <AANLkTimcVhP10LSn5+F+AY+ppnrhKmp_VCsjkKf04cQr@mail.gmail.com>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
	<1290931972-2770-3-git-send-email-piastryyy@gmail.com>
	<20101129073555.GA4573@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101129073555.GA4573-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/29 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>:
>
> Your patch arbitrarily shortens the read to the first vector. =A0Whil=
e
> short reads for regular files are fine with Posix, it will break a lo=
t
> of userspace applications.
>

cifs_user_read returns the number of bytes we read from the server and
it, of course, can be different with requested number. Could you
explain carefully what do you mean, please? Where is a problem here?


--=20
Best regards,
Pavel Shilovsky.
