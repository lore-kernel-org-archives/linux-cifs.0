From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Add match_port check during looking for an
 existing connection (try #2)
Date: Tue, 16 Nov 2010 13:02:10 -0600
Message-ID: <AANLkTimUVphDeWti-mid5jS2g-sF1jDVU7rMuyaPExUg@mail.gmail.com>
References: <1289893710-7352-1-git-send-email-piastryyy@gmail.com>
	<1289893710-7352-2-git-send-email-piastryyy@gmail.com>
	<AANLkTinX6o59YD2EAL4ahJoD1PBLNUCF-MXUss9yhZnd@mail.gmail.com>
	<20101116135714.358d6b10@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101116135714.358d6b10-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 16, 2010 at 12:57 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Tue, 16 Nov 2010 12:47:07 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Nov 16, 2010 at 1:48 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>> > If we have a share mounted by non-standard port and try to mount a=
nother share
>> > on the same host with standard port, we connect to the first share=
 again -
>> > that's wrong. This patch fixes this bug.
>>
>> The description seems a little strange - can you clarify?
>>
>> If we have an existing session with a server (using whatever port), =
by
>> default we want to use it (unless the user forces a different port
>> than the existing connection was made with). =A0If we have a firewal=
l
>> issue and therefore go through a non-standard port (port=3Dsomething=
 on
>> mount), we usually wouldn't want to fork a new connection on a secon=
d
>> connection to the same server.
>>
>> So if we specify port=3D5000 on a mount and we already have a mount =
on
>> port 139, it makes sense that we would want to create a new session.
>> But if you already have a mount on port 5000, and did a mount with n=
o
>> port specified - why wouldn't you use the existing port? =A0It saves
>> server, client and network resources.
>>
>
> That doesn't match what the manpage says. It says:
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
> ...which to me says that if you want the new mount to share the socke=
t
> already on port 5000, you need to specify port=3D5000 in the mount
> options. The code doesn't do this today, but I think it probably ough=
t
> to conform to the above description, or more accurately, with the
> manpage update that Pavel proposed.
>
> Now, to be pedantic...the code that Pavel proposed still isn't 100%
> compliant with the description.

But I think that the more important question is what the use case is -
ie which is easier and more natural for the user.   The man page needs
update either way.

Seems like we want to always use the existing connection if possible.
The man page comment about using the user specified port (if any) then
port 445 then port 139 is only for "negotiate" - ie when we haven't
already negotiated a session with the server.


--=20
Thanks,

Steve
