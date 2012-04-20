From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: uninitialized variables in the 5.4 release
Date: Fri, 20 Apr 2012 11:47:29 -0400
Message-ID: <20120420114729.0026102b@corrin.poochiereds.net>
References: <20120419175242.GR12994@hip.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lars =?UTF-8?B?TcO8bGxlcg==?= <lmuelle-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419175242.GR12994-aSaWmTCphX8QgCKCZH8Z8g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 19 Apr 2012 19:52:42 +0200
Lars M=C3=BCller <lmuelle-IBi9RG/b67k@public.gmane.org> wrote:

> Hi,
>=20
> older gcc versions (4.3 in the case of SUSE Linux Enterprise 11 SP 1 =
and
> SP 2) complain about uninitialized variables in the recent 5.4 releas=
e.
>=20
> The attached patch makes the build process a bit quieter.
>=20
> Cheers,
>=20
> Lars

All 3 of Lars' patches are now merged.
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
