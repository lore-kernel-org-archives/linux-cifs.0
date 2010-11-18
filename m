From: =?ISO-8859-1?Q?Andr=E9_Sintzoff?= <andre.sintzoff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs-utils 4.5-2: mount error(11): Resource temporarily unavailable
Date: Thu, 18 Nov 2010 16:26:51 +0100
Message-ID: <AANLkTikXyAVP8fpCSi_RmzCAnvM95QkR4=dycLEWeOui@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

After upgrading Ubuntu from 10.04 to 10.10, mount.cifs does no more
work as expected on my environment.

The command is:
sudo mount.cifs //servername/somehow/deep/path /mnt/servername -o
nounix,user=3Djohndoe,domain=3DCORRECT_WORKGROUP,password=3Djdpasswd

On Ubuntu 10.04, the mount works well.
According to dpkg, the exact version for smbfs is 2:3.4.7~dfsg-1ubuntu3=
=2E2

On Ubuntu 10.10, the mount fails with the following error message:
mount error(11): Resource temporarily unavailable
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

According to dpkg, the exact version for cifs-utils and smbfs is 2:4.5-=
2

I try to use gvfs-mount on Ubuntu 10.10 and it works with:
gvfs-mount smb://servername

If someone has any idea why mount.cifs fails, I will be glad to read it=
=2E

Thank you

Andr=E9
