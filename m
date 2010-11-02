From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] CIFS: Invalidate inode pages on the last close
Date: Tue, 2 Nov 2010 22:42:36 +0300
Message-ID: <AANLkTinC5vZFH4JefFyULrqjSbcZwc-_QxwX4ZLhuMtY@mail.gmail.com>
References: <AANLkTikE-QfKh8AYe=NZtQOKPhJ_LGQ+K5xcGb6wBfbw@mail.gmail.com>
	<20101102111932.7377e2bb@tlielax.poochiereds.net>
	<AANLkTika0teNKgPBqWi23X-iAXvfjuxdOz=p0HJ6Fo-3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTika0teNKgPBqWi23X-iAXvfjuxdOz=p0HJ6Fo-3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/2 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Jeff's point looks correct. =A0Also note when you fix this up - the
> local variable for cifs_sb from the previous patch (which caused a
> build warning for unused variable) needs to be readded back to this
> patch.
>
Yes, I agree - it's my bug. I will post right variant further.

--=20
Best regards,
Pavel Shilovsky.
