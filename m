From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: eliminate CONFIG_CIFS_WEAK_PW_HASH
Date: Fri, 20 Jan 2012 15:38:56 -0500
Message-ID: <20120120153856.6ded308a@tlielax.poochiereds.net>
References: <1327091153-22391-1-git-send-email-jlayton@redhat.com>
	<CAH2r5msOk=4rz_XUGi+GitzVGyJrSo9B1iGXdjz0Bnymzt0NyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msOk=4rz_XUGi+GitzVGyJrSo9B1iGXdjz0Bnymzt0NyQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Jan 2012 14:34:05 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Would like some feedback from security experts on this one.
> The LANMAN hash is easy to break and enabling it in
> a hostile environment seems wrong - obviously there
> are home environments and behind NATs where
> it is ok and where old LANMAN servers might exist.  Although it
> can be controlled at runtime, allowing it to be
> not built in gives administrators more control
> so that users do not change this workstation
> runtime config values in potentially dangerous ways.
>=20

That's fine -- this is intended for 3.4 so you should have plenty of
time. Can you briefly outline the potential scenario where you see this
as useful?

I don't see a lot of benefit from this Kconfig option. You have to be
root to enable this at runtime, and at that point all bets are off as
far as what someone can do. They can plug in their own kmod at that
point if you don't compile it in.


> On Fri, Jan 20, 2012 at 2:25 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > ...and just make it always turned on. In practice almost everyone
> > enables this option, and as the Kconfig option says, it needs to be
> > enabled at runtime anyway. I see no need to make this disableable
> > via Kconfig option as well, and removing the option simplifies the
> > testing matrix and reduced ifdef clutter in the code.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/Kconfig =C2=A0 =C2=A0 =C2=A0 | =C2=A0 27 ------------=
---------------
> > =C2=A0fs/cifs/cifs_debug.c =C2=A0| =C2=A0 =C2=A02 --
> > =C2=A0fs/cifs/cifsencrypt.c | =C2=A0 =C2=A02 --
> > =C2=A0fs/cifs/cifsglob.h =C2=A0 =C2=A0| =C2=A0 17 +----------------
> > =C2=A0fs/cifs/cifspdu.h =C2=A0 =C2=A0 | =C2=A0 =C2=A04 ----
> > =C2=A0fs/cifs/cifsproto.h =C2=A0 | =C2=A0 =C2=A02 --
> > =C2=A0fs/cifs/cifssmb.c =C2=A0 =C2=A0 | =C2=A0 24 -----------------=
-------
> > =C2=A0fs/cifs/connect.c =C2=A0 =C2=A0 | =C2=A0 =C2=A08 ++------
> > =C2=A0fs/cifs/sess.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 10 -------=
---
> > =C2=A09 files changed, 3 insertions(+), 93 deletions(-)
> >
> > diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> > index 0554b00..ee7ac6b 100644
> > --- a/fs/cifs/Kconfig
> > +++ b/fs/cifs/Kconfig
> > @@ -49,33 +49,6 @@ config CIFS_STATS2
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Unless you are a developer or are=
 doing network performance analysis
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0or tuning, say N.
> >
> > -config CIFS_WEAK_PW_HASH
> > - =C2=A0 =C2=A0 =C2=A0 bool "Support legacy servers which use weake=
r LANMAN security"
> > - =C2=A0 =C2=A0 =C2=A0 depends on CIFS
> > - =C2=A0 =C2=A0 =C2=A0 help
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 Modern CIFS servers including Samba a=
nd most Windows versions
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 (since 1997) support stronger NTLM (a=
nd even NTLMv2 and Kerberos)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 security mechanisms. These hash the p=
assword more securely
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 than the mechanisms used in the older=
 LANMAN version of the
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 SMB protocol but LANMAN based authent=
ication is needed to
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 establish sessions with some old SMB =
servers.
> > -
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 Enabling this option allows the cifs =
module to mount to older
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 LANMAN based servers such as OS/2 and=
 Windows 95, but such
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 mounts may be less secure than mounts=
 using NTLM or more recent
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 security mechanisms if you are on a p=
ublic network. =C2=A0Unless you
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 have a need to access old SMB servers=
 (and are on a private
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 network) you probably want to say N. =
=C2=A0Even if this support
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 is enabled in the kernel build, LANMA=
N authentication will not be
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 used automatically. At runtime LANMAN=
 mounts are disabled but
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 can be set to required (or optional) =
either in
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 /proc/fs/cifs (see fs/cifs/README for=
 more detail) or via an
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 option on the mount command. This sup=
port is disabled by
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 default in order to reduce the possib=
ility of a downgrade
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 attack.
> > -
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 If unsure, say N.
> > -
> > =C2=A0config CIFS_UPCALL
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0bool "Kerberos/SPNEGO advanced session s=
etup"
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0depends on CIFS && KEYS
> > diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> > index 24b3dfc..589774f 100644
> > --- a/fs/cifs/cifs_debug.c
> > +++ b/fs/cifs/cifs_debug.c
> > @@ -126,9 +126,7 @@ static int cifs_debug_data_proc_show(struct seq=
_file *m, void *v)
> > =C2=A0#ifdef CONFIG_CIFS_FSCACHE
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0seq_printf(m, " fscache");
> > =C2=A0#endif
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0seq_printf(m, " lanman");
> > -#endif
> > =C2=A0#ifdef CONFIG_CIFS_POSIX
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0seq_printf(m, " posix");
> > =C2=A0#endif
> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> > index 63c460e..96997cc 100644
> > --- a/fs/cifs/cifsencrypt.c
> > +++ b/fs/cifs/cifsencrypt.c
> > @@ -242,7 +242,6 @@ int setup_ntlm_response(struct cifs_ses *ses, c=
onst struct nls_table *nls_cp)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > =C2=A0}
> >
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0int calc_lanman_hash(const char *password, const char *cryptk=
ey, bool encrypt,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0char *lnm_session_key)
> > =C2=A0{
> > @@ -279,7 +278,6 @@ int calc_lanman_hash(const char *password, cons=
t char *cryptkey, bool encrypt,
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > =C2=A0}
> > -#endif /* CIFS_WEAK_PW_HASH */
> >
> > =C2=A0/* Build a proper attribute value/target info pairs blob.
> > =C2=A0* Fill in netbios and dns domain name and workstation name
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 76e7d8b..0e56b1e 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -853,13 +853,8 @@ static inline void free_dfs_info_array(struct =
dfs_info3_param *param,
> > =C2=A0#define =C2=A0 CIFSSEC_MAY_NTLM =C2=A0 =C2=A0 0x00002
> > =C2=A0#define =C2=A0 CIFSSEC_MAY_NTLMV2 =C2=A0 0x00004
> > =C2=A0#define =C2=A0 CIFSSEC_MAY_KRB5 =C2=A0 =C2=A0 0x00008
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0#define =C2=A0 CIFSSEC_MAY_LANMAN =C2=A0 0x00010
> > =C2=A0#define =C2=A0 CIFSSEC_MAY_PLNTXT =C2=A0 0x00020
> > -#else
> > -#define =C2=A0 CIFSSEC_MAY_LANMAN =C2=A0 =C2=A00
> > -#define =C2=A0 CIFSSEC_MAY_PLNTXT =C2=A0 =C2=A00
> > -#endif /* weak passwords */
> > =C2=A0#define =C2=A0 CIFSSEC_MAY_SEAL =C2=A0 =C2=A0 0x00040 /* not =
supported yet */
> > =C2=A0#define =C2=A0 CIFSSEC_MAY_NTLMSSP =C2=A00x00080 /* raw ntlms=
sp with ntlmv2 */
> >
> > @@ -870,23 +865,13 @@ require use of the stronger protocol */
> > =C2=A0#define =C2=A0 CIFSSEC_MUST_NTLM =C2=A0 =C2=A00x02002
> > =C2=A0#define =C2=A0 CIFSSEC_MUST_NTLMV2 =C2=A00x04004
> > =C2=A0#define =C2=A0 CIFSSEC_MUST_KRB5 =C2=A0 =C2=A00x08008
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0#define =C2=A0 CIFSSEC_MUST_LANMAN =C2=A00x10010
> > =C2=A0#define =C2=A0 CIFSSEC_MUST_PLNTXT =C2=A00x20020
> > =C2=A0#ifdef CONFIG_CIFS_UPCALL
> > =C2=A0#define =C2=A0 CIFSSEC_MASK =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0xBF0BF /* allows weak security but also krb5 */
> > -#else
> > +#else /* UPCALL */
> > =C2=A0#define =C2=A0 CIFSSEC_MASK =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0xB70B7 /* current flags supported if weak */
> > =C2=A0#endif /* UPCALL */
> > -#else /* do not allow weak pw hash */
> > -#define =C2=A0 CIFSSEC_MUST_LANMAN =C2=A00
> > -#define =C2=A0 CIFSSEC_MUST_PLNTXT =C2=A00
> > -#ifdef CONFIG_CIFS_UPCALL
> > -#define =C2=A0 CIFSSEC_MASK =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x8F=
08F /* flags supported if no weak allowed */
> > -#else
> > -#define =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CIFSSEC_MASK =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00x87087 /* flags supported if no weak allowed */
> > -#endif /* UPCALL */
> > -#endif /* WEAK_PW_HASH */
> > =C2=A0#define =C2=A0 CIFSSEC_MUST_SEAL =C2=A0 =C2=A00x40040 /* not =
supported yet */
> > =C2=A0#define =C2=A0 CIFSSEC_MUST_NTLMSSP 0x80080 /* raw ntlmssp wi=
th ntlmv2 */
> >
> > diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> > index 3fb03e2..ef28614 100644
> > --- a/fs/cifs/cifspdu.h
> > +++ b/fs/cifs/cifspdu.h
> > @@ -26,13 +26,9 @@
> > =C2=A0#include <asm/unaligned.h>
> > =C2=A0#include "smbfsctl.h"
> >
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0#define LANMAN_PROT 0
> > =C2=A0#define LANMAN2_PROT 1
> > =C2=A0#define CIFS_PROT =C2=A0 2
> > -#else
> > -#define CIFS_PROT =C2=A0 0
> > -#endif
> > =C2=A0#define POSIX_PROT =C2=A0(CIFS_PROT+1)
> > =C2=A0#define BAD_PROT 0xFFFF
> >
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index 6f4e243..a81549d 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -403,10 +403,8 @@ extern int cifs_crypto_shash_allocate(struct T=
CP_Server_Info *);
> > =C2=A0extern void cifs_crypto_shash_release(struct TCP_Server_Info =
*);
> > =C2=A0extern int calc_seckey(struct cifs_ses *);
> >
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0extern int calc_lanman_hash(const char *password, const char =
*cryptkey,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool encrypt, char *lnm_sessi=
on_key);
> > -#endif /* CIFS_WEAK_PW_HASH */
> > =C2=A0#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily=
 */
> > =C2=A0extern int CIFSSMBNotify(const int xid, struct cifs_tcon *tco=
n,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0const int notify_subdirs, const __u16 netfid,
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 8b7794c..cf12c0c 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -49,10 +49,8 @@ static struct {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int index;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *name;
> > =C2=A0} protocols[] =3D {
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{LANMAN_PROT, "\2LM1.2X002"},
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{LANMAN2_PROT, "\2LANMAN2.1"},
> > -#endif /* weak password hashing for legacy clients */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{CIFS_PROT, "\2NT LM 0.12"},
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{POSIX_PROT, "\2POSIX 2"},
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{BAD_PROT, "\2"}
> > @@ -62,10 +60,8 @@ static struct {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int index;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *name;
> > =C2=A0} protocols[] =3D {
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{LANMAN_PROT, "\2LM1.2X002"},
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{LANMAN2_PROT, "\2LANMAN2.1"},
> > -#endif /* weak password hashing for legacy clients */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{CIFS_PROT, "\2NT LM 0.12"},
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{BAD_PROT, "\2"}
> > =C2=A0};
> > @@ -73,17 +69,9 @@ static struct {
> >
> > =C2=A0/* define the number of elements in the cifs dialect array */
> > =C2=A0#ifdef CONFIG_CIFS_POSIX
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0#define CIFS_NUM_PROT 4
> > -#else
> > -#define CIFS_NUM_PROT 2
> > -#endif /* CIFS_WEAK_PW_HASH */
> > =C2=A0#else /* not posix */
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0#define CIFS_NUM_PROT 3
> > -#else
> > -#define CIFS_NUM_PROT 1
> > -#endif /* CONFIG_CIFS_WEAK_PW_HASH */
> > =C2=A0#endif /* CIFS_POSIX */
> >
> > =C2=A0/* Forward declarations */
> > @@ -441,7 +429,6 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_=
ses *ses)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0could not ne=
gotiate a common dialect */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -EOPN=
OTSUPP;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto neg_err=
_exit;
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if ((pSMBr->hdr.WordCount =3D=3D =
13)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0&& ((server->dialect =3D=3D LANMAN_PROT)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|| (server->dialect =3D=3D LA=
NMAN2_PROT))) {
> > @@ -519,13 +506,6 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs=
_ses *ses)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* we will n=
ot end up setting signing flags - as no signing
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0was in LANMA=
N and server did not return the flags on */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto signing=
_check;
> > -#else /* weak security disabled */
> > - =C2=A0 =C2=A0 =C2=A0 } else if (pSMBr->hdr.WordCount =3D=3D 13) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "mount=
 failed, cifs module not built "
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 "with CIFS_WEAK_PW_HASH support");
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EOPNOTSU=
PP;
> > -#endif /* WEAK_PW_HASH */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto neg_err_exi=
t;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (pSMBr->hdr.WordCount !=3D 17)=
 {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* unknown w=
ct */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -EOPN=
OTSUPP;
> > @@ -537,9 +517,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_=
ses *ses)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "sha=
re mode security");
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((server->sec_mode & SECMODE_PW_ENCRY=
PT) =3D=3D 0)
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((secFlag=
s & CIFSSEC_MAY_PLNTXT) =3D=3D 0)
> > -#endif /* CIFS_WEAK_PW_HASH */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cERROR(1, "Server requests plain text password"
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" but client support d=
isabled");
> >
> > @@ -627,9 +605,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_=
ses *ses)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0server->capa=
bilities &=3D ~CAP_EXTENDED_SECURITY;
> >
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0signing_check:
> > -#endif
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((secFlags & CIFSSEC_MAY_SIGN) =3D=3D=
 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* MUST_SIGN=
 already includes the MAY_SIGN FLAG
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 so i=
f this is zero it means that signing is disabled */
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index aa687c8..5aeca5e 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -1153,10 +1153,8 @@ cifs_parse_mount_options(const char *mountda=
ta, const char *devname,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0} else if (strnicmp(value, "nontlm", 6) =3D=3D 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* BB is there a better way t=
o do this? */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vol->secFlg |=3D CIFSSEC_MAY_=
NTLMV2;
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0} else if (strnicmp(value, "lanman", 6) =3D=3D 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vol->secFlg |=3D CIFSSEC_MAY_=
LANMAN;
> > -#endif
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0} else if (strnicmp(value, "none", 4) =3D=3D 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vol->nullauth =3D 1;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0} else {
> > @@ -3611,7 +3609,6 @@ CIFSTCon(unsigned int xid, struct cifs_ses *s=
es,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 weak=
er LANMAN (which we do not send by default) is accepted
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 by S=
amba (not sure whether other servers allow
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 NTLM=
v2 password here) */
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((global_=
secflags & CIFSSEC_MAY_LANMAN) &&
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
(ses->server->secType =3D=3D LANMAN))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0calc_lanman_hash(tcon->password, ses->server->cryptkey,
> > @@ -3619,9 +3616,8 @@ CIFSTCon(unsigned int xid, struct cifs_ses *s=
es,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0SECMODE_PW_ENCRYPT ? true : false,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
bcc_ptr);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> > -#endif /* CIFS_WEAK_PW_HASH */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D SMBNTencr=
ypt(tcon->password, ses->server->cryptkey,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bcc_=
ptr, nls_codepage);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D SMBNTencrypt(tcon->password, ses->server->cryptkey,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 bcc_ptr, nls_codepage);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bcc_ptr +=3D=
 CIFS_AUTH_RESP_SIZE;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ses->cap=
abilities & CAP_UNICODE) {
> > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > index d85efad..1cce63b 100644
> > --- a/fs/cifs/sess.c
> > +++ b/fs/cifs/sess.c
> > @@ -592,14 +592,6 @@ ssetup_ntlmssp_authenticate:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phase =3D Nt=
LmAuthenticate; /* if ntlmssp, now final phase */
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (type =3D=3D LANMAN) {
> > -#ifndef CONFIG_CIFS_WEAK_PW_HASH
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* LANMAN and pl=
aintext are less secure and off by default.
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 So we make this =
explicitly be turned on in kconfig (in the
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 build) and turne=
d on at runtime (changed from the default)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in proc/fs/cifs =
or via mount parm. =C2=A0Unfortunately this is
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 needed for old W=
in (e.g. Win95), some obscure NAS and OS/2 */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EOPNOTSU=
PP;
> > -#endif
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wct =3D 10; =
/* lanman 2 style sessionsetup */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if ((type =3D=3D NTLM) || (type =3D=
=3D NTLMv2)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* For NTLMv=
2 failures eventually may need to retry NTLM */
> > @@ -643,7 +635,6 @@ ssetup_ntlmssp_authenticate:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0iov[1].iov_len =3D 0;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (type =3D=3D LANMAN) {
> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0char lnm_ses=
sion_key[CIFS_AUTH_RESP_SIZE];
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pSMB->req.hd=
r.Flags2 &=3D ~SMBFLG2_UNICODE;
> > @@ -674,7 +665,6 @@ ssetup_ntlmssp_authenticate:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "Neg=
otiating LANMAN setting up strings");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Unicode n=
ot allowed for LANMAN dialects */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ascii_ssetup=
_strings(&bcc_ptr, ses, nls_cp);
> > -#endif
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (type =3D=3D NTLM) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pSMB->req_no=
_secext.Capabilities =3D cpu_to_le32(capabilities);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pSMB->req_no=
_secext.CaseInsensitivePasswordLength =3D
> > --
> > 1.7.7.5
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
