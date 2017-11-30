From: Matt <matt.w.burnett-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: MS SOFS compatibility issue
Date: Thu, 30 Nov 2017 16:31:27 -0600
Message-ID: <FB50F504-E400-44E8-904F-528E345C1AEE@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I=E2=80=99ve been experiencing issues when trying to mount CIFS shares on a Micro=
soft Scale Out File Server 2016 Cluster from a VMware Photon Linux 1.0 clien=
t. If a vers option is not provided, mount.cifs will give the error mount er=
ror(13): Permission denied. =C2=A0I was able to work around them by specifying v=
ers=3D3.02 as a mount option, but a kernel update eventually broke that and I =
was forced to use vers=3D2.0. However since upgrading to Photon 2.0, the mount=
.cifs version changed from 6.4 to 6.7, and whenever I specify a vers=3D option=
, it gives the error mount error(22): Invalid argument. If it is relevant th=
e Photon 1.0 client was running kernel 4.4.96-1 and Photon 2.0 is running ke=
rnel 4.9.60-1.
=C2=A0
Does anyone know what I can do to resolve these issues? Can someone point m=
e in the direction of where I should submit a bug report? Thanks!
