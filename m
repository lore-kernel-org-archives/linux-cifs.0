From: Emmanuel Florac <eflorac-PuSHN2nxisHn0MxWRTiXmQ@public.gmane.org>
Subject: Re: [linux-cifs-client] can someone please explain the performance
 difference between mount.cifs and smbclient?
Date: Thu, 27 Jan 2011 23:03:51 +0100
Message-ID: <20110127230351.76e4940c@galadriel2.home>
References: <20110127190719.72653d38@harpe.intellique.com>
	<20110127135410.6046a8cd@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110127135410.6046a8cd-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Le Thu, 27 Jan 2011 13:54:10 -0500 vous =C3=A9criviez:

> cc'ing linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org which is the new mailing list...

Damn, that's why I wasn't receiving messages from the list for a few
months :)

> Most likely you're seeing the result of a lack of parallelism in the
> Linux kernel cifs client. It does not do async writes (yet), which
> really hinders throughput.
>=20
> I'm hoping to get to work on that in the next few months unless
> someone else beats me to it...

Thank you. In the meanwhile I'll probably stick to NFS :)

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac-PuSHN2nxisHn0MxWRTiXmQ@public.gmane.org>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
