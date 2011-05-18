From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create new binary cifs.idmap for sid to
 uid/gid mapping
Date: Wed, 18 May 2011 08:25:44 -0400
Message-ID: <20110518082544.06f4b873@tlielax.poochiereds.net>
References: <1304667239-29127-1-git-send-email-shirishp@linux.vnet.ibm.com>
	<20110517120946.7890152b@tlielax.poochiereds.net>
	<BANLkTi=xbNCQP9GJpGaPEH-vJ44_zG41pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=xbNCQP9GJpGaPEH-vJ44_zG41pA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 17 May 2011 21:06:53 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, May 17, 2011 at 11:09 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Fri, =C2=A06 May 2011 02:33:59 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Handle cifs.idmap type of key. Extract a SID string from the descr=
iption
> >> and map it to either an uid or gid using winbind APIs.
> >> If that fails (e.g. because winbind is not installed/running or wi=
nbind returns
> >> an error), try to obtain uid of 'nobody' and gid of 'nogroup'.
> >> And if that fails, kernel assigns uid and gid (from mount superblo=
ck).
> >>
> >> Enable including winbind header files and idmapping code condition=
al
> >> to winbind devel rpms (header and library).
> >>
> >> An entry such as this
> >>
> >> create =C2=A0cifs.idmap =C2=A0 * =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/sbin/cifs.idmap %k
> >>
> >> is needed in the file /etc/request-key.conf.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =C2=A0Makefile.am =C2=A0| =C2=A0 =C2=A08 ++
> >> =C2=A0cifs.idmap.c | =C2=A0215 +++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++
> >> =C2=A0configure.ac | =C2=A0 58 +++++++++++++++-
> >> =C2=A03 files changed, 280 insertions(+), 1 deletions(-)
> >> =C2=A0create mode 100644 cifs.idmap.c
> >>
> >> diff --git a/Makefile.am b/Makefile.am
> >> index 67a0190..ad33914 100644
> >> --- a/Makefile.am
> >> +++ b/Makefile.am
> >> @@ -30,3 +30,11 @@ bin_PROGRAMS =3D cifscreds
> >> =C2=A0cifscreds_SOURCES =3D cifscreds.c resolve_host.c util.c
> >> =C2=A0cifscreds_LDADD =3D -lkeyutils
> >> =C2=A0endif
> >> +
> >> +if CONFIG_CIFSIDMAP
> >> +cifs_idmap_sbindir =3D /usr/local/sbin
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^
> > That looks wrong. If I configure with --prefix=3D/usr then this is =
still
> > going to go in /usr/local/sbin, right? I think you instead want to
> > append cifs.idmap to sbin_PROGRAMS.
> >
> >> +cifs_idmap_sbin_PROGRAMS =3D cifs.idmap
> >> +cifs_idmap_SOURCES =3D cifs.idmap.c
> >> +cifs_idmap_LDADD =3D -lkeyutils $(WINB_LDADD)
> >> +endif
> >> +
> >> diff --git a/cifs.idmap.c b/cifs.idmap.c
> >> new file mode 100644
> >> index 0000000..0f76873
> >> --- /dev/null
> >> +++ b/cifs.idmap.c
> >> @@ -0,0 +1,215 @@
> >> +/*
> >> +* CIFS idmap helper.
> >> +* Copyright (C) Shirish Pargaonkar (shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2011
> >> +*
> >> +* Used by /sbin/request-key.conf for handling
> >> +* cifs upcall for SID to uig/gid and uid/gid to SID mapping.
> >> +* You should have keyutils installed and add
> >> +* this lines to /etc/request-key.conf file:
> >> +
> >> + =C2=A0 =C2=A0create cifs.idmap * * /usr/local/sbin/cifs.idmap %k
> >> +
> >> +* This program is free software; you can redistribute it and/or m=
odify
> >> +* it under the terms of the GNU General Public License as publish=
ed by
> >> +* the Free Software Foundation; either version 2 of the License, =
or
> >> +* (at your option) any later version.
> >> +* This program is distributed in the hope that it will be useful,
> >> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> >> +* GNU General Public License for more details.
> >> +* You should have received a copy of the GNU General Public Licen=
se
> >> +* along with this program; if not, write to the Free Software
> >> +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-=
1307 USA
> >> +*/
> >> +
> >> +#ifdef HAVE_CONFIG_H
> >> +#include "config.h"
> >> +#endif /* HAVE_CONFIG_H */
> >> +
> >> +#include <string.h>
> >> +#include <getopt.h>
> >> +#include <syslog.h>
> >> +#include <dirent.h>
> >> +#include <sys/types.h>
> >> +#include <sys/stat.h>
> >> +#include <unistd.h>
> >> +#ifdef HAVE_KEYUTILS_H
> >> +#include <keyutils.h>
> >> +#endif /* HAVE_KEYUTILS_H */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^^
> > This can't be built w/o keyutils, right? So I don't think we need t=
he
> > #ifdefs.
> >
> >> +#include <stdint.h>
> >> +#include <stdbool.h>
> >> +#include <stdio.h>
> >> +#include <stdlib.h>
> >> +#include <errno.h>
> >> +#include <limits.h>
> >> +#ifdef HAVE_WBCLIENT_H
> >> +#include <wbclient.h>
> >> +#endif /* HAVE_WBCLIENT_H */
> >> +
> >> +static const char *prog =3D "cifs.idmap";
> >> +
> >> +static void usage(void)
> >> +{
> >> + =C2=A0 =C2=A0 syslog(LOG_INFO, "Usage: %s [-t] [-v] [-l] key_ser=
ial", prog);
> >> + =C2=A0 =C2=A0 fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_seri=
al\n", prog);
> >> +}
> >> +
> >> +#ifdef HAVE_LIBWBCLIENT
> >> +static int
> >> +cifs_idmap(const key_serial_t key, const char *key_descr)
> >> +{
> >> + =C2=A0 =C2=A0 int i;
> >> + =C2=A0 =C2=A0 uid_t uid =3D 0;
> >> + =C2=A0 =C2=A0 gid_t gid =3D 0;;
> >> + =C2=A0 =C2=A0 wbcErr rc =3D 1;
> >> + =C2=A0 =C2=A0 const char *keyend =3D key_descr;
> >> + =C2=A0 =C2=A0 struct wbcDomainSid sid;
> >> + =C2=A0 =C2=A0 struct passwd *pw;
> >> + =C2=A0 =C2=A0 struct group *gr;
> >> +
> >> + =C2=A0 =C2=A0 /* skip next 4 ';' delimiters to get to descriptio=
n */
> >> + =C2=A0 =C2=A0 for (i =3D 1; i <=3D 4; ++i) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 keyend =3D index(keyen=
d + 1, ';');
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!keyend) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 syslog(LOG_ERR, "invalid key description: %s",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0key_descr);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return 1;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 keyend++;
> >> +
> >
> > No real bounds checking here. It seems unlikely, but a buggy kernel
> > could send a garbled string and you could walk off the end of it he=
re.
> >
> >> + =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0* Use winbind to convert received string to =
a SID and lookup
> >> + =C2=A0 =C2=A0 =C2=A0* name and map that SID to an uid. =C2=A0If =
either of these
> >> + =C2=A0 =C2=A0 =C2=A0* function calls return with an error, =C2=A0=
use system calls to obtain
> >> + =C2=A0 =C2=A0 =C2=A0* uid of user "nobody". If winbind fails to =
map a SID to an UID
> >> + =C2=A0 =C2=A0 =C2=A0* and there is no user named "nobody", retur=
n error to the
> >> + =C2=A0 =C2=A0 =C2=A0* upcall caller. Otherwise instanticate a ke=
y using that uid.
> >> + =C2=A0 =C2=A0 =C2=A0*
> >> + =C2=A0 =C2=A0 =C2=A0* The same applies to SID and gid mapping. =C2=
=A0Instead of a
> >> + =C2=A0 =C2=A0 =C2=A0* user "nobody", user "nogroup" is looked up=
 if winbind
> >> + =C2=A0 =C2=A0 =C2=A0* fails to map a SID to a gid.
> >> + =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 if (strncmp(keyend, "os", 2) =3D=3D 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 keyend =3D index(keyen=
d + 1, ':');
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 keyend++;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ditto on the=
 bounds checks
> >
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D wbcStringToSid(=
keyend, &sid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 syslog(LOG_DEBUG, "O strtosid: %s, rc: %d", keyend, rc);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D wbcSidToUid(&sid, &uid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "SID %s to uid wbc er=
ror: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 keyend, rc);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) { /* either of=
 the two wbcSid functions failed */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 pw =3D getpwnam("nobody");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (!pw)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "SID %s to uid pw err=
or: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 keyend, rc)=
;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uid =3D pw->pw_uid;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 0;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc) { /* SID has =
been mapped to a uid */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D keyctl_instantiate(key, &uid, sizeof(uid_t), 0);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "%s: key inst: %s",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__, s=
trerror(errno));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 } else if (strncmp(keyend, "gs", 2) =3D=3D 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 keyend =3D index(keyen=
d + 1, ':');
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 keyend++;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D wbcStringToSid(=
keyend, &sid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 syslog(LOG_DEBUG, "O strtosid: %s, rc: %d", keyend, rc);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D wbcSidToGid(&sid, &gid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "SID %s to gid wbc er=
ror: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 keyend, rc);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) { /* either of=
 the two wbcSid functions failed */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 gr =3D getgrnam("nogroup");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (!gr)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "SID %s to gid pw err=
or: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 keyend, rc);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 gid =3D gr->gr_gid;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 0;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc) { /* SID has =
been mapped to a gid */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D keyctl_instantiate(key, &gid, sizeof(gid_t), 0);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "%s: key inst: %s",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 __func__, strerror(errno));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 } else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "Inv=
alid SID: %s", keyend);
> >> +
> >> + =C2=A0 =C2=A0 return rc;
> >> +}
> >> +#endif /* HAVE_LIBWBCLIENT */
> >> +
> >> +int main(const int argc, char *const argv[])
> >> +{
> >> + =C2=A0 =C2=A0 int c;
> >> + =C2=A0 =C2=A0 long rc =3D 1;
> >> + =C2=A0 =C2=A0 key_serial_t key =3D 0;
> >> + =C2=A0 =C2=A0 char *buf;
> >> +
> >> + =C2=A0 =C2=A0 openlog(prog, 0, LOG_DAEMON);
> >> +
> >> + =C2=A0 =C2=A0 while ((c =3D getopt_long(argc, argv, "v", NULL, N=
ULL)) !=3D -1) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (c) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'v':
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 printf("version: %s\n", VERSION);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto out;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 default:
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 syslog(LOG_ERR, "unknown option: %c", c);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto out;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 /* is there a key? */
> >> + =C2=A0 =C2=A0 if (argc <=3D optind) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 usage();
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 /* get key and keyring values */
> >> + =C2=A0 =C2=A0 errno =3D 0;
> >> + =C2=A0 =C2=A0 key =3D strtol(argv[optind], NULL, 10);
> >> + =C2=A0 =C2=A0 if (errno !=3D 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key =3D 0;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "Inval=
id key format: %s", strerror(errno));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 rc =3D keyctl_describe_alloc(key, &buf);
> >> + =C2=A0 =C2=A0 if (rc =3D=3D -1) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "keyct=
l_describe_alloc failed: %s",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0strerror(errno));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 1;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 syslog(LOG_DEBUG, "key description: %s", buf);
> >> +
> >> +#ifdef HAVE_LIBWBCLIENT
> >> + =C2=A0 =C2=A0 if ((strncmp(buf, "cifs.idmap", sizeof("cifs.idmap=
") - 1) =3D=3D 0))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_idmap(key,=
 buf);
> >> +#endif /* HAVE_LIBWBCLIENT */
> >> +
> >
> > Doesn't this program require libwbclient? If so, then why the #ifde=
f's?
> >
> >> +out:
> >> + =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0* on error, negatively instantiate the key o=
urselves so that we can
> >> + =C2=A0 =C2=A0 =C2=A0* make sure the kernel doesn't hang it off o=
f a searchable keyring
> >> + =C2=A0 =C2=A0 =C2=A0* and interfere with the next attempt to ins=
tantiate the key.
> >> + =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 if (rc !=3D 0 && key =3D=3D 0)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 keyctl_negate(key, 1, =
KEY_REQKEY_DEFL_DEFAULT);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^
> > Is a 1s timeout appropriate here?
>=20
> Not sure about the value?  Would 30s or 60s timeout be appropriate?
> Once a key request was fulfilled successfully, cifs module is not lik=
ely
> to re-request that at key since it caches for an hour or so.
> And if key request was unsuccessful, cifs module will not re-request
> that key for another five minutes.
>=20
> Perhaps we can negatively instantiate it for 60 seconds and be ready
> to handle any requests after that?
> I think any value such as 1, 30, 60 seconds would work?
>=20

If that's the case, then there's probably no reason to negatively
instantiate it at all. The kernel will do that on its own with a 60s
timeout (I think).

> >
> >> + =C2=A0 =C2=A0 return rc;
> >> +}
> >> diff --git a/configure.ac b/configure.ac
> >> index e0e2a60..d9eaead 100644
> >> --- a/configure.ac
> >> +++ b/configure.ac
> >> @@ -22,13 +22,19 @@ AC_ARG_ENABLE(cifscreds,
> >> =C2=A0 =C2=A0 =C2=A0 enable_cifscreds=3D$enableval,
> >> =C2=A0 =C2=A0 =C2=A0 enable_cifscreds=3D"no")
> >>
> >> +AC_ARG_ENABLE(cifsidmap,
> >> + =C2=A0 =C2=A0 [AC_HELP_STRING([--enable-cifsidmap],
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [Create cifs.idmap binary @<:@default=3Dyes@:>@])],
> >> + =C2=A0 =C2=A0 enable_cifsidmap=3D$enableval,
> >> + =C2=A0 =C2=A0 enable_cifsidmap=3D"maybe")
> >> +
> >> =C2=A0# Checks for programs.
> >> =C2=A0AC_PROG_CC
> >> =C2=A0AC_PROG_SED
> >> =C2=A0AC_GNU_SOURCE
> >>
> >> =C2=A0# Checks for header files.
> >> -AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h=
 mntent.h netdb.h stddef.h stdint.h stdlib.h string.h strings.h sys/mou=
nt.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_=
ERROR([necessary header(s) not found])])
> >> +AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h=
 mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h =
string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h sysl=
og.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
> >>
> >> =C2=A0if test $enable_cifsupcall !=3D "no"; then
> >> =C2=A0 =C2=A0 =C2=A0 AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
> >> @@ -89,6 +95,55 @@ if test $enable_cifsupcall !=3D "no"; then
> >> =C2=A0 =C2=A0 =C2=A0 AC_SUBST(KRB5_LDADD)
> >> =C2=A0fi
> >>
> >> +if test $enable_cifsidmap !=3D "no"; then
> >> + =C2=A0 =C2=A0 AC_CHECK_HEADERS([keyutils.h], , [
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if test "$enable_cifsidmap" =3D "yes"; =
then
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_MSG_ERRO=
R([keyutils.h not found, consider installing keyutils-libs-devel.])
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_MSG_WARN=
([keyutils.h not found, consider installing keyutils-libs-devel. Disabl=
ing cifs.idmap.])
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enable_cifs=
idmap=3D"no"
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fi
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ])
> >> +fi
> >> +
> >
> > We're already doing a AC_CHECK_HEADERS for keyutils.h -- I don't th=
ink
> > we want to do it again. Just use the same check for both cifs.upcal=
l
> > and cifs.idmap.
> >
> >> +if test $enable_cifsidmap !=3D "no"; then
> >> + =C2=A0 =C2=A0 AC_CHECK_HEADERS([wbclient.h], , [
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if test "$enable_cifsidmap" =3D "yes"; =
then
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_MSG_ERRO=
R([wbclient.h not found, consider installing libwbclient-devel..])
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_MSG_WARN=
([keyutils.h not found, consider installing libwbclient-devel. Disablin=
g cifs.idmap.])
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enable_cifs=
idmap=3D"no"
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fi
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ],
> >> +[#ifdef HAVE_STDINT_H
> >> +#include <stdint.h>
> >> +#endif
> >> +]
> >> +[#ifdef HAVE_STDBOOL_H
> >> +#include <stdbool.h>
> >> +#endif
> >> +]
> >> +[#ifdef HAVE_STDIO_H
> >> +#include <stdio.h>
> >> +#endif
> >> +]
> >> +[#ifdef HAVE_STDLIB_H
> >> +#include <stdlib.h>
> >> +#endif
> >> +]
> >> +[#ifdef HAVE_ERRNO_H
> >> +#include <errno.h>
> >> +#endif
> >> +]
> >> +)
> >> +fi
> >> +
> >> +if test $enable_cifsidmap !=3D "no"; then
> >> + =C2=A0 =C2=A0 AC_CHECK_LIB([wbclient], [wbcStringToSid],
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [ WINB_LDADD=3D'-lwbcl=
ient' ] [ AC_DEFINE(HAVE_LIBWBCLIENT, 1, ["define var have_libwbclient"=
]) ], [AC_MSG_ERROR([no functioning wbclient library found!])])
> >> + =C2=A0 =C2=A0 AC_SUBST(WINB_LDADD)
> >> +fi
> >> +
> >
> >
> > Bleh, that's pretty messy. Maybe this should go into a separate
> > file/function in aclocal/ ?
> >
> >
> >> =C2=A0if test $enable_cifscreds =3D "yes"; then
> >> =C2=A0 =C2=A0 =C2=A0 AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERRO=
R([keyutils.h not found, consider installing keyutils-libs-devel.])])
> >> =C2=A0fi
> >> @@ -140,6 +195,7 @@ LIBS=3D$cu_saved_libs
> >>
> >> =C2=A0AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall"=
 !=3D "no"])
> >> =C2=A0AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" =3D=
 "yes"])
> >> +AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" !=3D "=
no"])
> >>
> >> =C2=A0LIBCAP_NG_PATH
> >>
> >
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
