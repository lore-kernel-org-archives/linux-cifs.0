From: Totemo Support <support-4BUtOHJXg7LQT0dZR+AlfA@public.gmane.org>
Subject: PROBLEM: CIFS SMB2/SMB3 does not work for domain based DFS
Date: Tue, 18 Jul 2017 11:47:02 +0200
Message-ID: <F303188D30C85B49969BE73949AA0F8C6F171F0DF0@EXCHANGE.totemo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I am having problems mounting a domain based DFS share using mount.cifs wit=
h the parameter vers=3D2.0 or vers=3D3.0, even though it works with the dep=
recated version vers=3D1.0.

My test setup includes two separated Windows 2016 servers (180days eval iso=
), with the following roles:

* on the first I'm running the domain controller (DC)
* on the second VM I installed the DFS Namespace Root role (DFSN) and this =
VM also serves the actual shares

Now, when trying to mount, the following error occurs:

mount //domain.dev.com/files/sales /smb -o user=3DAdministrator,password=3D=
xxxxxx,vers=3D3.0

CIFS VFS: BAD_NETWORK_NAME: \\domain.dev.com\files
CIFS VFS: session ffff88003bd0c000 has no tcon available for a dfs referral=
 request
CIFS VFS: cifs_mount failed w/return code =3D -2

It's working fine, with SMB1. It does also work, when I specify the DFSN se=
rver directly:

mount //dfsn/files/sales /smb -o user=3DAdministrator,password=3Dxxxxxx,ver=
s=3D3.0

>From my point of view it looks like there is no resolution attempt of resol=
ving the domain based UNC (//domain.dev.com/files) into the actual dfsroot =
representation.

Since my domain controller doesn't host the dfsroot structure, any attempts=
 resolving on it directly will fail.

I tried initially with Kernel 4.11 but also build a recent 4.13 with the sa=
me issues.
Latest keyutils (/sbin/key.dns_resolver) are in place and configured on the=
 system.

Do you need any further scripts/explanations how I set up the test servers?=
 It's nothing special, everything sticks to the defaults.

Best,
Robert

Totemo Support=20

phone: +41 44 914 99 00
fax: +41 44 914 99 99

email: support-4BUtOHJXg7LQT0dZR+AlfA@public.gmane.org
web: www.totemo.com
