From: =?ISO-8859-1?Q?Andr=E9_Sintzoff?= <andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs-utils 4.5-2: mount error(11): Resource temporarily unavailable
Date: Thu, 18 Nov 2010 17:13:26 +0100
Message-ID: <AANLkTinLU6XF5HU6CtpuXv5hJe+_OXrX4NzJPyDFhq0y@mail.gmail.com>
References: <AANLkTikXyAVP8fpCSi_RmzCAnvM95QkR4=dycLEWeOui@mail.gmail.com> <AANLkTimABqWV7ofAe_iWYOrEYa1aGoZZus_eyhAT0CWv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimABqWV7ofAe_iWYOrEYa1aGoZZus_eyhAT0CWv-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/18 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Thu, Nov 18, 2010 at 9:26 AM, Andr=E9 Sintzoff
> <andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hello,
>>
>> After upgrading Ubuntu from 10.04 to 10.10, mount.cifs does no more
>> work as expected on my environment.
>>
>> The command is:
>> sudo mount.cifs //servername/somehow/deep/path /mnt/servername -o
>> nounix,user=3Djohndoe,domain=3DCORRECT_WORKGROUP,password=3Djdpasswd
>>
>> On Ubuntu 10.04, the mount works well.
>> According to dpkg, the exact version for smbfs is 2:3.4.7~dfsg-1ubun=
tu3.2
>>
>> On Ubuntu 10.10, the mount fails with the following error message:
>> mount error(11): Resource temporarily unavailable
>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> Is there anything related to cifs logged in kernel message log (dmesg=
)?

Yes. The following lines should give the failure cause.

[28899.254869] CIFS VFS: dns_resolve_server_name_to_ip: unable to
resolve: server2.domain.com
[28899.254879] CIFS VFS: cifs_compose_mount_options: Failed to resolve
server part of \\server2.domain.com\path to IP: -11

It seems that the mounting point //servername/somehow/deep/path is not
physically on "servername" machine but already mounted from "server2"
on "servername" filesystem. Therefore, cifs has to perform a second
name resolution which fails.
I don't understand why cifs is unable to resolve  server2.domain.com.
ping server2.domain.com and host server2.domain.com are OK.

On Ubuntu 10.04, the name resolution is correctly managed.
The corresponding line in dmesg:
[ 1396.567721]  /build/buildd/linux-2.6.32/fs/cifs/dns_resolve.c:
dns_resolve_server_name_to_ip: resolved: server2.domain.com to
10.10.193.26

I just change the mount command to use directly the server2 machine
and it works.

Thanks for giving me enough information to find a workaround.


Andr=E9
