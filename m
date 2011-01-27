From: Emmanuel Florac <eflorac-PuSHN2nxisHn0MxWRTiXmQ@public.gmane.org>
Subject: Re: [linux-cifs-client] can someone please explain the performance
 difference between mount.cifs and smbclient?
Date: Thu, 27 Jan 2011 23:11:13 +0100
Message-ID: <20110127231113.4f292256@galadriel2.home>
References: <20110127190719.72653d38@harpe.intellique.com>
	<E1PiWm1-005Ll7-Ta@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1PiWm1-005Ll7-Ta-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Le Thu, 27 Jan 2011 19:39:35 +0100 vous =C3=A9criviez:

> > Why this huge difference? BTW, why such a discrepancy between read
> > and write speed?  =20
>=20
> Good question. There has been a subtle bug in smbclient in
> that it did not send out requests as fast as it could (the
> events system did not prefer writes over reads). You could
> be hitting this bug. But I'd need to analyze this much
> closer with an strace -ttT of smbclient and smbd, and a
> wireshark trace.

Thank you, I'll post the strace output tomorrow. Note that I'm running
debian stable, so we're talking about rotten^w mature  versions :)

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac-PuSHN2nxisHn0MxWRTiXmQ@public.gmane.org>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
