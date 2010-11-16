From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mounting share on non-standard ports
Date: Tue, 16 Nov 2010 22:31:07 +0300
Message-ID: <AANLkTikt7HPeoVfYEZNF-KPtO0iEGFMMOwxrGqKfHG_f@mail.gmail.com>
References: <1289321425-7860-1-git-send-email-piastryyy@gmail.com>
	<20101113070012.760cf09d@tlielax.poochiereds.net>
	<AANLkTinb-A4kdumURzhkVb9oNojtfW94LPL99GwOr9MU@mail.gmail.com>
	<AANLkTim+SO4TfTJnXHnvaSjbPaoHt4k63hbVbs0gtbn9@mail.gmail.com>
	<20101114203112.5d901619@corrin.poochiereds.net>
	<AANLkTikJVcpezQ54_XrsNMEBewq15YO3iHymoQ-9xc9w@mail.gmail.com>
	<20101116092646.44bcf91a@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101116092646.44bcf91a-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/16 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Tue, 16 Nov 2010 10:51:23 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2010/11/15 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> > On Sun, 14 Nov 2010 12:38:18 +0300
>> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> 2010/11/13 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> >> > 2010/11/13 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> >> >>
>> >> >> I don't think this patch deals correctly with servers that are
>> >> >> listening on RFC1001_PORT but not CIFS_PORT. With two mounts t=
o the
>> >> >> same server that don't specify a port, you'll end up with two =
sockets,
>> >> >> right?
>> >> >
>> >>
>> >> And from another hand: If user doesn't specify the port we should
>> >> think that it means the 445 port. If user wants to mount 139 port=
, he
>> >> should specify this port manually. So, there is no error with the
>> >> patch in this case.
>> >>
>> >> From this point of view we should remove trying with 139 port if =
we
>> >> failed with 445 port. What do you think about it?
>> >>
>> >
>> > That sounds like a regression. The mount.cifs manpage says:
>> >
>> > =A0 =A0 =A0 port=3Darg
>> > =A0 =A0 =A0 =A0 =A0 sets the port number on the server to attempt =
to contact to
>> > =A0 =A0 =A0 =A0 =A0 negotiate CIFS support. If the CIFS server is =
not listening on this
>> > =A0 =A0 =A0 =A0 =A0 port or if it is not specified, the default po=
rts will be tried
>> > =A0 =A0 =A0 =A0 =A0 i.e. port 445 is tried and if no response then=
 port 139 is tried.
>> >
>> >
>> > I think we ought to preserve that behavior. Perhaps if no port is
>> > specified then match any TCP session that is on port 445 or port 1=
39?
>> >
>>
>> Jeff, according to my patches (try #2) I think we should replace it =
this with:
>>
>> =A0 =A0port=3Darg
>> =A0 =A0 =A0 =A0 =A0 =A0sets the port number on the server to attempt=
 to contact to
>> negotiate CIFS support.
>> =A0 =A0 =A0 =A0 =A0 =A0If the CIFS server is not listening on this p=
ort, we return
>> with error. If it is not specified,
>> =A0 =A0 =A0 =A0 =A0 =A0the default ports will be tried i.e. port 445=
 is tried and
>> if no response then port 139 is tried.
>>
>>
>
> Sounds correct to me. Care to do a manpage patch for mount.cifs?
>

Ok, I will provide a patch with this variant:
"port=3Darg

sets the port number on the server to attempt to contact to negotiate
CIFS support. If this value is specified, looking for an existing
connection with this port and try to connect if no such a connection.
Return an error if it fails.

If this value isn't specified, looking for an existing connection with
445 or 139 port. If no such a connection, try to connect with 445 port
and if it fails - with 139 port. Return an error if both fail."

--=20
Best regards,
Pavel Shilovsky.
