From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs-utils 4.5-2: mount error(11): Resource temporarily unavailable
Date: Thu, 18 Nov 2010 09:37:27 -0600
Message-ID: <AANLkTimABqWV7ofAe_iWYOrEYa1aGoZZus_eyhAT0CWv@mail.gmail.com>
References: <AANLkTikXyAVP8fpCSi_RmzCAnvM95QkR4=dycLEWeOui@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?Andr=E9_Sintzoff?= <andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikXyAVP8fpCSi_RmzCAnvM95QkR4=dycLEWeOui-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 18, 2010 at 9:26 AM, Andr=E9 Sintzoff
<andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello,
>
> After upgrading Ubuntu from 10.04 to 10.10, mount.cifs does no more
> work as expected on my environment.
>
> The command is:
> sudo mount.cifs //servername/somehow/deep/path /mnt/servername -o
> nounix,user=3Djohndoe,domain=3DCORRECT_WORKGROUP,password=3Djdpasswd
>
> On Ubuntu 10.04, the mount works well.
> According to dpkg, the exact version for smbfs is 2:3.4.7~dfsg-1ubunt=
u3.2
>
> On Ubuntu 10.10, the mount fails with the following error message:
> mount error(11): Resource temporarily unavailable
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

Is there anything related to cifs logged in kernel message log (dmesg)?

If not, it may be helpful to enable cifs debugging ("echo 7 >
/proc/fs/cifs/cifsFYI")
and retry the mount (which will now list where in the mount it
failed).  The mount
system call is very limited in what information it can return to the
user on failure
so sometimes it is necessary to look in dmesg to find additional
failure information.

--=20
Thanks,

Steve
