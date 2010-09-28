From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] CIFS: New read cache mechanism
Date: Tue, 28 Sep 2010 22:13:41 +0400
Message-ID: <AANLkTikVTzX4bN3T_2Ky8AoSda-J0LT7oq8=mCr2cch9@mail.gmail.com>
References: <AANLkTi=U-4Go7jzMJWQ61j+2v1GXJoMFn5MLUNA4MZ-U@mail.gmail.com>
	<20100928135548.3c9b1f50@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100928135548.3c9b1f50-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/9/28 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Ok, so suppose you make this change and don't change
> cifs_file_aio_write at all, and at some point in the future, we make
> cifs do async writes...
>
> I go and do a buffered write to a file, cifs_file_aio_write then call=
s
> filemap_fdatawrite to flush out the data, but doesn't necessarily wai=
t
> for it to complete before returning.
>
> Now, I do I read from that file descriptor, which ends up being
> satisfied before the write I just did got flushed out. I see old
> data in the read.
>
> According to the write(2) manpage:
>
> POSIX =C2=A0requires =C2=A0that =C2=A0a =C2=A0read(2) =C2=A0which can=
 be proved to occur after a
> write() has returned returns the new data. =C2=A0Note that not all fi=
le sys=E2=80=90
> tems are POSIX conforming.
>
> It's arguable that CIFS isn't POSIX conforming, but we do our best wi=
th
> it. I think we ought to conform to POSIX in this regard. If you want
> to do this, you probably also need to ensure that the dirty data gets
> flushed to the server prior to returning from a write call.

It's only read part and I am going to post write part as well. Of
course, it will wait for complete. So, let's look at this only from
the read side - at least, it doesn't break write related things in
comparison with existing code.

--=20
Best regards,
Pavel Shilovsky.
