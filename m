From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs-utils 4.5-2: mount error(11): Resource temporarily
 unavailable
Date: Thu, 18 Nov 2010 13:15:49 -0500
Message-ID: <20101118131549.306e7a12@barsoom.rdu.redhat.com>
References: <AANLkTikXyAVP8fpCSi_RmzCAnvM95QkR4=dycLEWeOui@mail.gmail.com>
	<AANLkTimABqWV7ofAe_iWYOrEYa1aGoZZus_eyhAT0CWv@mail.gmail.com>
	<AANLkTinLU6XF5HU6CtpuXv5hJe+_OXrX4NzJPyDFhq0y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?B?QW5kcuk=?= Sintzoff <andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinLU6XF5HU6CtpuXv5hJe+_OXrX4NzJPyDFhq0y-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 18 Nov 2010 17:13:26 +0100
Andr=E9 Sintzoff <andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/11/18 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > On Thu, Nov 18, 2010 at 9:26 AM, Andr=E9 Sintzoff
> > <andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> Hello,
> >>
> >> After upgrading Ubuntu from 10.04 to 10.10, mount.cifs does no mor=
e
> >> work as expected on my environment.
> >>
> >> The command is:
> >> sudo mount.cifs //servername/somehow/deep/path /mnt/servername -o
> >> nounix,user=3Djohndoe,domain=3DCORRECT_WORKGROUP,password=3Djdpass=
wd
> >>
> >> On Ubuntu 10.04, the mount works well.
> >> According to dpkg, the exact version for smbfs is 2:3.4.7~dfsg-1ub=
untu3.2
> >>
> >> On Ubuntu 10.10, the mount fails with the following error message:
> >> mount error(11): Resource temporarily unavailable
> >> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> >
> > Is there anything related to cifs logged in kernel message log (dme=
sg)?
>=20
> Yes. The following lines should give the failure cause.
>=20
> [28899.254869] CIFS VFS: dns_resolve_server_name_to_ip: unable to
> resolve: server2.domain.com
> [28899.254879] CIFS VFS: cifs_compose_mount_options: Failed to resolv=
e
> server part of \\server2.domain.com\path to IP: -11
>=20
> It seems that the mounting point //servername/somehow/deep/path is no=
t
> physically on "servername" machine but already mounted from "server2"
> on "servername" filesystem. Therefore, cifs has to perform a second
> name resolution which fails.
> I don't understand why cifs is unable to resolve  server2.domain.com.
> ping server2.domain.com and host server2.domain.com are OK.
>=20
> On Ubuntu 10.04, the name resolution is correctly managed.
> The corresponding line in dmesg:
> [ 1396.567721]  /build/buildd/linux-2.6.32/fs/cifs/dns_resolve.c:
> dns_resolve_server_name_to_ip: resolved: server2.domain.com to
> 10.10.193.26
>=20
> I just change the mount command to use directly the server2 machine
> and it works.
>=20
> Thanks for giving me enough information to find a workaround.
>=20

It sounds like /etc/request-key.conf isn't set up to do DNS resolution
on the broken host. See the cifs.upcall manpage for details.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
