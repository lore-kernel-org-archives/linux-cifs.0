From: Jeff Layton <jlayton@samba.org>
Subject: Re: CIFS  kernel module bug
Date: Fri, 30 Sep 2011 14:04:09 -0400
Message-ID: <20110930140409.51c1a94c@tlielax.poochiereds.net>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	LKML <linux-kernel@vger.kernel.org>,
	PWF Linux <pwf-linux@ucs.cam.ac.uk>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 30 Sep 2011 14:58:58 +0100
Anton Altaparmakov <aia21@cam.ac.uk> wrote:

> Hi,
>=20
> Looking at the current kernel (in Linus' repository on github) there =
is a silly logic bug in the cifs module in fs/cifs/cifsfs.c::cifs_llsee=
k() there is this bit of code:
>=20
> 	/*
> 	 * origin =3D=3D SEEK_END || SEEK_DATA || SEEK_HOLE =3D> we must rev=
alidate
> 	 * the cached file length
> 	 */
> 	if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR) {
>=20
> The logical or should be a logical and, i.e. this should be:
>=20
> 	if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR) {
>=20
> As the code is at present that line is ALWAYS true because origin is =
ALWAYS either !=3D SEEK_SET or !=3D SEEK_CUR as if it equals one it can=
not equal the other and vice versa=E2=80=A6
>=20
> So at the moment it always does the revalidation instead of only for =
SEEK_END, SEEK_DATA, and SEEK_HOLE.
>=20
> Best regards,
>=20
> 	Anton


Haha, good catch. Care to roll up a patch to fix that?

--=20
Jeff Layton <jlayton@samba.org>
