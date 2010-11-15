From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mounting share on non-standard ports
Date: Mon, 15 Nov 2010 09:11:27 +0300
Message-ID: <AANLkTinjUfER_O1mQxi38PxPM-qEx5o1aM29YeV-V0Un@mail.gmail.com>
References: <1289321425-7860-1-git-send-email-piastryyy@gmail.com>
	<20101113070012.760cf09d@tlielax.poochiereds.net>
	<AANLkTinb-A4kdumURzhkVb9oNojtfW94LPL99GwOr9MU@mail.gmail.com>
	<AANLkTim+SO4TfTJnXHnvaSjbPaoHt4k63hbVbs0gtbn9@mail.gmail.com>
	<20101114203112.5d901619@corrin.poochiereds.net>
	<AANLkTin-HyDEVKTStoPFRx5a0ycAYAx2uSCoh+4NspfO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin-HyDEVKTStoPFRx5a0ycAYAx2uSCoh+4NspfO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/15 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Sun, Nov 14, 2010 at 7:31 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
>> That sounds like a regression. The mount.cifs manpage says:
>>
>> =A0 =A0 =A0 port=3Darg
>> =A0 =A0 =A0 =A0 =A0 sets the port number on the server to attempt to=
 contact to
>> =A0 =A0 =A0 =A0 =A0 negotiate CIFS support. If the CIFS server is no=
t listening on this
>> =A0 =A0 =A0 =A0 =A0 port or if it is not specified, the default port=
s will be tried
>> =A0 =A0 =A0 =A0 =A0 i.e. port 445 is tried and if no response then p=
ort 139 is tried.
>>
>>
>> I think we ought to preserve that behavior. Perhaps if no port is
>> specified then match any TCP session that is on port 445 or port 139=
?
>
> Right - sounds logical that if you don't specify a port, then we try
> to match a connection on any existing port. =A0If there is no existin=
g
> port, and none was specified, then 445 first then 139.
>

Let's predict the following situation:

we have server with two smbd's: 1th on 445 port, and 2nd on 5000 port.
At first user mounts 2nd smbd with specifying 5000 port. Then it tries
to mount 1th without specifying any ports. If we consider your logic,
our client looks for an any existing connection, finds connection to
5000 port (2nd smbd) and mounts it. So, as the result, user thinks
that it successfully mounted the 1th share, but it is the 2nd - it is
not right.

If we should follow mount.cifs spec, I think we need to do:
1) if user doesn't specify a port we at first try to match a
connection with 445 port, then if we are not successful - with 139
port. If there are no connections with these ports, we return an
error.
2) if user specifies a port, we should try to match a connection only
with this port. If no connections with this port, we should return an
error.

I think that it is real problem. I faced with a real application
freenx server that uses CIFS for mounting many shares on different
ports (freenx clients want mount to mount its own share through ssh
port forwarding - many smbds with non-standard ports and local smbd
with standard port) on localhost.

You can try the following to reproduce the bug:
run smbd's on localhost and smbserver_host (another).

On the first console:
ssh -L5000:smbserver_host:445 smbserver_host
On the second:
mount -t cifs //localhost/share ~/test -oport=3D5000
mount -t cifs //localhost/share ~/test2

As the result, we can see that the second call connects to
smbserve_host rather than to localhost and return without any error -
so, user doesn't know that it has mounted smbserver_host instead of
localhost.

Even more, if we unmounted and mount them vice versa:
mount -t cifs //localhost/share ~/test2
mount -t cifs //localhost/share ~/test -oport=3D5000

it will be ok - two different connection to two different share, but
(!) if we losing the connection to port 5000, today's code reconnects
with share to localhost - wrong again! My patch number 1 fixes this
situation too.

I am ready to provide changes to the patches I posted later according
to mount.cifs spec as soon as we find an agreement in all the things
above.

--=20
Best regards,
Pavel Shilovsky.
