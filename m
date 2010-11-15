From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mounting share on non-standard ports
Date: Sun, 14 Nov 2010 21:17:39 -0600
Message-ID: <AANLkTin-HyDEVKTStoPFRx5a0ycAYAx2uSCoh+4NspfO@mail.gmail.com>
References: <1289321425-7860-1-git-send-email-piastryyy@gmail.com>
	<20101113070012.760cf09d@tlielax.poochiereds.net>
	<AANLkTinb-A4kdumURzhkVb9oNojtfW94LPL99GwOr9MU@mail.gmail.com>
	<AANLkTim+SO4TfTJnXHnvaSjbPaoHt4k63hbVbs0gtbn9@mail.gmail.com>
	<20101114203112.5d901619@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101114203112.5d901619-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Nov 14, 2010 at 7:31 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sun, 14 Nov 2010 12:38:18 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2010/11/13 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> > 2010/11/13 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> >>
>> >> I don't think this patch deals correctly with servers that are
>> >> listening on RFC1001_PORT but not CIFS_PORT. With two mounts to t=
he
>> >> same server that don't specify a port, you'll end up with two soc=
kets,
>> >> right?
>> >
>>
>> And from another hand: If user doesn't specify the port we should
>> think that it means the 445 port. If user wants to mount 139 port, h=
e
>> should specify this port manually. So, there is no error with the
>> patch in this case.
>>
>> From this point of view we should remove trying with 139 port if we
>> failed with 445 port. What do you think about it?
>>
>
> That sounds like a regression. The mount.cifs manpage says:
>
> =A0 =A0 =A0 port=3Darg
> =A0 =A0 =A0 =A0 =A0 sets the port number on the server to attempt to =
contact to
> =A0 =A0 =A0 =A0 =A0 negotiate CIFS support. If the CIFS server is not=
 listening on this
> =A0 =A0 =A0 =A0 =A0 port or if it is not specified, the default ports=
 will be tried
> =A0 =A0 =A0 =A0 =A0 i.e. port 445 is tried and if no response then po=
rt 139 is tried.
>
>
> I think we ought to preserve that behavior. Perhaps if no port is
> specified then match any TCP session that is on port 445 or port 139?

Right - sounds logical that if you don't specify a port, then we try
to match a connection on any existing port.  If there is no existing
port, and none was specified, then 445 first then 139.


--=20
Thanks,

Steve
