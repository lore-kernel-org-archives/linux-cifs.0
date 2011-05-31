From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Tue, 31 May 2011 14:36:31 -0500
Message-ID: <BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>
References: <4DE5385C.1030808@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE5385C.1030808-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is on setting up a session, so could be something like:
- mount
- do write
- server crash
- attempt to reconnect
- socket returns ENOSOCK
- attempt to reconnect ...
- repeat

Is this repeatable enough that we could modify the client to stop on
the reconnect to see what is causing the socket to go bad and which
operation we are repeating the reconnect on.



On Tue, May 31, 2011 at 1:50 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> w=
rote:
> Kernel is somewhat hacked, but no changes to CIFS.
>
>
> While doing failover testing, we managed to get the cifs client
> spewing endless serial console spammage. =A0We can ping the system, b=
ut
> otherwise cannot seem to interact with it. =A0I tried serial-console =
sysrq
> commands (blind, spewage makes it impossible to see any real results)=
 to
> turn logging to 0, but that didn't help (yet..going to let it run in =
case
> there is just a huge backlog of messages).
>
> The file-server cluster is in a bad state, but still not excuse
> for the clients machine to become useless.
>
> The spewage is at least primarily:
>
> CIFS VFS: Send error in SessSetup =3D -88
> CIFS VFS: Send error in SessSetup =3D -88
> CIFS VFS: Send error in SessSetup =3D -88
> CIFS VFS: Send error in SessSetup =3D -88
> CIFS VFS: Send error in SessSetup =3D -88
> CIFS VFS: Send error in SessSetup =3D -88
> CIFS VFS: Send error in SessSetup =3D -88
> CIFS VFS: Send error in SessSetup =3D -88
> CIFS VFS: Send error in SessSetup =3D -88
>
> Seems -88 probably means -ENOTSOCK.
>
> At the least, perhaps the cERROR() messages
> should be rate limitted?
>
> This one is hard and slow to reproduce, but we'll
> keep testing..and will try pertinent patches if someone
> has some suggestions.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> Candela Technologies Inc =A0http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
