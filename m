From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs-utils 4.5-2: mount error(11): Resource temporarily unavailable
Date: Thu, 18 Nov 2010 13:13:29 -0600
Message-ID: <AANLkTi=pp059-Deb-KwOGY2XpbXfeLRd-sP_8461JdGX@mail.gmail.com>
References: <AANLkTikXyAVP8fpCSi_RmzCAnvM95QkR4=dycLEWeOui@mail.gmail.com>
	<AANLkTimABqWV7ofAe_iWYOrEYa1aGoZZus_eyhAT0CWv@mail.gmail.com>
	<AANLkTinLU6XF5HU6CtpuXv5hJe+_OXrX4NzJPyDFhq0y@mail.gmail.com>
	<20101118131549.306e7a12@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?Andr=E9_Sintzoff?= <andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101118131549.306e7a12-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 18, 2010 at 12:15 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Thu, 18 Nov 2010 17:13:26 +0100
> Andr=E9 Sintzoff <andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2010/11/18 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> > On Thu, Nov 18, 2010 at 9:26 AM, Andr=E9 Sintzoff
>> > <andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> Hello,
>> >>
>> >> After upgrading Ubuntu from 10.04 to 10.10, mount.cifs does no mo=
re
>> >> work as expected on my environment.
>> >>
>> >> The command is:
>> >> sudo mount.cifs //servername/somehow/deep/path /mnt/servername -o
>> >> nounix,user=3Djohndoe,domain=3DCORRECT_WORKGROUP,password=3Djdpas=
swd
>> >>
>> >> On Ubuntu 10.04, the mount works well.
>> >> According to dpkg, the exact version for smbfs is 2:3.4.7~dfsg-1u=
buntu3.2
>> >>
>> >> On Ubuntu 10.10, the mount fails with the following error message=
:
>> >> mount error(11): Resource temporarily unavailable
>> >> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>> >
>> > Is there anything related to cifs logged in kernel message log (dm=
esg)?
>>
>> Yes. The following lines should give the failure cause.
>>
>> [28899.254869] CIFS VFS: dns_resolve_server_name_to_ip: unable to
>> resolve: server2.domain.com
>> [28899.254879] CIFS VFS: cifs_compose_mount_options: Failed to resol=
ve
>> server part of \\server2.domain.com\path to IP: -11
>>
>> It seems that the mounting point //servername/somehow/deep/path is n=
ot
>> physically on "servername" machine but already mounted from "server2=
"
>> on "servername" filesystem. Therefore, cifs has to perform a second
>> name resolution which fails.
>> I don't understand why cifs is unable to resolve =A0server2.domain.c=
om.
>> ping server2.domain.com and host server2.domain.com are OK.
>>
>> On Ubuntu 10.04, the name resolution is correctly managed.
>> The corresponding line in dmesg:
>> [ 1396.567721] =A0/build/buildd/linux-2.6.32/fs/cifs/dns_resolve.c:
>> dns_resolve_server_name_to_ip: resolved: server2.domain.com to
>> 10.10.193.26
>>
>> I just change the mount command to use directly the server2 machine
>> and it works.
>>
>> Thanks for giving me enough information to find a workaround.
>>
>
> It sounds like /etc/request-key.conf isn't set up to do DNS resolutio=
n
> on the broken host. See the cifs.upcall manpage for details.

Presumably this is a DFS redirection from some path on servername to
\\server2\some-share - which requires that request-key be setup
properly (to resolve the host name in kernel - when you directly mount
to \\server2 - mount.cifs can use gethostbyname library call - which
is not available for kernel code to call, thus the reason for the
upcall helper Jeff mentions).  If this is misconfigured in current
Ubuntu (note that the kernel moved to using cifs's host name
resolution mechanism recently - ~in the last five months).  Probably
need to log the bug against Ubuntu so they can fix their default
configuration.


--=20
Thanks,

Steve
