From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: smbclient =?ISO-8859-1?B?ZGlkbrR0?= get entire file size
Date: Thu, 10 Apr 2014 06:32:09 -0400
Message-ID: <20140410063209.07643368@tlielax.poochiereds.net>
References: <8C619082F585F744AB0B30BD339F9701018BCF30@s070mx01.leopoldshoehe.de>
	<20140408133923.3d26433e@tlielax.poochiereds.net>
	<8C619082F585F744AB0B30BD339F9701018BCF36@s070mx01.leopoldshoehe.de>
	<20140409055312.203c92e8@tlielax.poochiereds.net>
	<8C619082F585F744AB0B30BD339F9701018BCF38@s070mx01.leopoldshoehe.de>
	<20140409074707.2ee16f46@ipyr.poochiereds.net>
	<8C619082F585F744AB0B30BD339F9701018BCF42@s070mx01.leopoldshoehe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Klassen Torben (Gem. =?ISO-8859-1?B?TGVvcG9sZHNo9mhl?=)"
	<T.Klassen-SCthCst9zBGhAOIk49qHig@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8C619082F585F744AB0B30BD339F9701018BCF42-KyxPP83GVknawj9xX7XCX6kw+sHXTWaOs0AfqQuZ5sE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 10 Apr 2014 11:34:30 +0200
Klassen Torben (Gem. Leopoldsh=F6he) <T.Klassen-SCthCst9zBGhAOIk49qHig@public.gmane.org> wrote=
:

> Hi Jeff,
> yeah i did so but unfortunately the patch won=B4t work in the Debian =
kernel.
>=20
>=20
> <make[2]:Leaving directory `/usr/local/src/linux-3.13.7/linux-3.2.54'
> make[1]: Leaving directory `/usr/local/src/linux-3.13.7/linux-3.2.54'
> Importiere Patch=20
> /tmp/0001-cifs-stop-trying-to-use-virtual-circuits.patch (abgelegt al=
s=20
> test/0001-cifs-stop-trying-to-use-virtual-circuits.patch)
> Wende Patch test/0001-cifs-stop-trying-to-use-virtual-circuits.patch =
an
> patching file fs/cifs/cifsglob.h
> Hunk #1 FAILED at 715.
> 1 out of 1 hunk FAILED -- rejects in file fs/cifs/cifsglob.h
> patching file fs/cifs/sess.c
> Patch test/0001-cifs-stop-trying-to-use-virtual-circuits.patch l=E4ss=
t=20
> sich nicht anwenden (erzwingen mit -f)
>=20
> Im not capable of fixing this by myself and i would have to deal with=
=20
> that problem every time again with a new kernel.
>=20
> That=B4s not very practicable don=B4t you think?
>=20
> You don=B4t see any chance to fix this issue in samba itself??
>=20
>=20

(cc'ing samba-technical and linux-cifs)

It shouldn't be too hard to backport, but you do need to know what
you're doing. You could also ask the Debian maintainers to include the
patch. If they need help with backporting it, I'd be willing to do so.


As far as fixing the server...if the server in your case is samba, you
can set "reset on zero vc" to "no" and that should prevent this
behavior. Otherwise, you're out of luck and you'll need to fix the
clients.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
