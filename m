From: Matt <matt.w.burnett-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: MS SOFS compatibility issue
Date: Thu, 30 Nov 2017 21:55:06 -0600
Message-ID: <2E12F6EE-3C29-4C03-B3F4-822FBB98AC10@gmail.com>
References: <FB50F504-E400-44E8-904F-528E345C1AEE@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FB50F504-E400-44E8-904F-528E345C1AEE-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry, I forgot to subscribe to this list, if you replied, and did not incl=
ude me directly, if you could resend your message to me, I=E2=80=99d appreciate it=
.


On 11/30/17, 4:31 PM, "Matt" <matt.w.burnett-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

    I=E2=80=99ve been experiencing issues when trying to mount CIFS shares on a M=
icrosoft Scale Out File Server 2016 Cluster from a VMware Photon Linux 1.0 c=
lient. If a vers option is not provided, mount.cifs will give the error moun=
t error(13): Permission denied.  I was able to work around them by specifyin=
g vers=3D3.02 as a mount option, but a kernel update eventually broke that and=
 I was forced to use vers=3D2.0. However since upgrading to Photon 2.0, the mo=
unt.cifs version changed from 6.4 to 6.7, and whenever I specify a vers=3D opt=
ion, it gives the error mount error(22): Invalid argument. If it is relevant=
 the Photon 1.0 client was running kernel 4.4.96-1 and Photon 2.0 is running=
 kernel 4.9.60-1.
    =20
    Does anyone know what I can do to resolve these issues? Can someone poi=
nt me in the direction of where I should submit a bug report? Thanks!
   =20
   =20
   =20
   =20
   =20
