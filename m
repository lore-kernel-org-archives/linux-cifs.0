From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: mount.cifs.c toggle_dac_capability() stores return code
Date: Thu, 19 Apr 2012 15:10:13 -0400
Message-ID: <20120419151013.24ad0b53@tlielax.poochiereds.net>
References: <20120419185612.GT12994@hip.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lars =?UTF-8?B?TcO8bGxlcg==?= <lmuelle-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419185612.GT12994-aSaWmTCphX8QgCKCZH8Z8g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 19 Apr 2012 20:56:13 +0200
Lars M=C3=BCller <lmuelle-IBi9RG/b67k@public.gmane.org> wrote:

> Hello again,
>=20
> the build process of the cifs-utils for Mandriva 2011 made me notice =
of
> the unused variable rc in toggle_dac_capability() of mount.cifs.c.
>=20
> A bit up in the code we store the return value and do not make use of=
 it
> while calling return.
>=20
> The attached patch intends to fix this.
>=20
> The failing build result is still visible at
> https://build.opensuse.org/package/live_build_log?arch=3Dx86_64&packa=
ge=3Dcifs-utils&project=3Dnetwork%3Asamba%3ASTABLE&repository=3DMandriv=
a_2011
>=20
> Cheers,
>=20
> Lars

ACK. Good catch.
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
