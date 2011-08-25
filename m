From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Add uid/gid to SID mapping functions (try
 #4)
Date: Thu, 25 Aug 2011 13:54:06 -0400
Message-ID: <20110825135406.18e9ac00@barsoom.rdu.redhat.com>
References: <1312918260-23780-1-git-send-email-shirishpargonkar@gmail.com>
	<CADT32eLLx1dkjiaUpnPxzcTaBqtoo-0p_hPXLHjQtT9KLw2utw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLLx1dkjiaUpnPxzcTaBqtoo-0p_hPXLHjQtT9KLw2utw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 25 Aug 2011 06:44:29 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Aug 9, 2011 at 2:31 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> >
> > Add functions to map a uid and gid to a SID. =C2=A0These functions =
are
> > similar to SID to uid and gid mapping functions.
> > A SID is what is returned to the cifs module.
> >
> >
> > Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> > =C2=A0cifs.idmap.c | =C2=A0 37 ++++++++++++++++++++++++++++++++++++=
+
> > =C2=A01 files changed, 37 insertions(+), 0 deletions(-)
> >
> > diff --git a/cifs.idmap.c b/cifs.idmap.c
> > index 56edb58..80802d7 100644
> > --- a/cifs.idmap.c
> > +++ b/cifs.idmap.c
> > @@ -134,6 +134,43 @@ cifs_idmap(const key_serial_t key, const char =
*key_descr)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto cifs_id=
map_ret;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > + =C2=A0 =C2=A0 =C2=A0 sidstr =3D strget(key_descr, "oi:");
> > + =C2=A0 =C2=A0 =C2=A0 if (sidstr) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uid =3D atoi(sid=
str);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG=
, "SID: %s, uid: %d", sidstr, uid);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D wbcUidToS=
id(uid, &sid);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 syslog(LOG_DEBUG, "uid %d to SID =C2=A0error: %d", uid, rc);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc) { /* SI=
D has been mapped to a uid */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D keyctl_instantiate(key, &sid,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size=
of(struct wbcDomainSid), 0);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "%s: key inst: %=
s",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __fu=
nc__, strerror(errno));
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto cifs_idmap_=
ret;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 sidstr =3D strget(key_descr, "gi:");
> > + =C2=A0 =C2=A0 =C2=A0 if (sidstr) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 gid =3D atoi(sid=
str);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG=
, "SID: %s, gid: %d", sidstr, gid);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D wbcGidToS=
id(gid, &sid);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 syslog(LOG_DEBUG, "gid %d to SID error: %d", gid, rc);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc) { /* SI=
D has been mapped to a gid */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D keyctl_instantiate(key, &sid,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size=
of(struct wbcDomainSid), 0);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "%s: key inst: %=
s",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __fu=
nc__, strerror(errno));
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto cifs_idmap_=
ret;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0syslog(LOG_DEBUG, "Invalid key: %s", key=
_descr);
> >
> > =C2=A0cifs_idmap_ret:
> > --
> > 1.6.0.2
> >
> >
>=20
> Jeff, any comments on this? I think this patch and kernel parts
> of this patchset, should be doing similar to what is done currently
> for server that support unix extensions.
> A care is taken so that only the server ids can be assigned as
> an id to change to, if an id can't be resolved, then chown/chgrp fail
> and if an id can be resolved, the server is the one which whether
> to apply the changed security descriptor or not.
>=20
> Regards,
>=20
> Shirish

The userspace part of this looks fine. I don't have the time to review
the kernel pieces however. If Steve plans to review and commit those,
then I'll plan to pull the userspace patch into the next cifs-utils
release.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
