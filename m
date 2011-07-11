From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] cifs: drop spinlock before calling cifs_put_tlink
Date: Mon, 11 Jul 2011 12:49:10 -0400
Message-ID: <20110711124910.66470fad@tlielax.poochiereds.net>
References: <1310393794-12407-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mug1iYZSGybKjg3H+kUVK6PA3XXt05-6kf+dLYH0yETBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mug1iYZSGybKjg3H+kUVK6PA3XXt05-6kf+dLYH0yETBQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 11 Jul 2011 11:40:12 -0500
Steve French <smfrench@gmail.com> wrote:

> ok - merged.
>=20
> Am testing now.  If anyone else has test data on current cifs-2.6.git
> I could send pull request faster.
>=20
> On Mon, Jul 11, 2011 at 9:16 AM, Jeff Layton <jlayton@redhat.com> wro=
te:
> > ...as that function can sleep.
> >
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> > =C2=A0fs/cifs/connect.c | =C2=A0 =C2=A02 +-
> > =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index ceab134..dd695c5 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -2241,8 +2241,8 @@ cifs_match_super(struct super_block *sb, void=
 *data)
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D compare_mount_options(sb, mnt_dat=
a);
> > =C2=A0out:
> > - =C2=A0 =C2=A0 =C2=A0 cifs_put_tlink(tlink);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&cifs_tcp_ses_lock);
> > + =C2=A0 =C2=A0 =C2=A0 cifs_put_tlink(tlink);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > =C2=A0}
> >
> > --
> > 1.7.6
> >
> >
>=20
>=20
>=20

Testing with all of the patches in my cifs-3.0 and cifs-3.1 branches wo=
rked fine.

--=20
Jeff Layton <jlayton@redhat.com>
