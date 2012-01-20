From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: eliminate CONFIG_CIFS_WEAK_PW_HASH
Date: Fri, 20 Jan 2012 14:45:48 -0600
Message-ID: <CAH2r5ms6YbZp+erat9RQw7-vMxem6vLWp72Yaf=Z8d4p=4+BBQ@mail.gmail.com>
References: <1327091153-22391-1-git-send-email-jlayton@redhat.com>
	<CAH2r5msOk=4rz_XUGi+GitzVGyJrSo9B1iGXdjz0Bnymzt0NyQ@mail.gmail.com>
	<20120120153856.6ded308a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120120153856.6ded308a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

My general thinking on this is as follows:

If the kernel is distributed to all the workstations in an organization
with this Kconfig option disabled, it makes it harder for individual us=
ers
to make the mistake of enabling lanman (sec=3Dlanman, or the Kconfig
option) on a public network and thus send weak password hashes
which could be discovered simply.   Most distros make the choice
of enabling broader compatibility with old pre-1997 servers but
it is a very small set of servers who would require lanman support,
and a large number of potential attackers who could benefit if
users enable lanman on a public network.  I suspect that there
are environments where removing code (via Kconfig) is preferred
to trusting all owners of all workstations running that organizations
standard linux to never enable lanman at runtime.

But ... the opinion of security specialists on this would be welcome.

On Fri, Jan 20, 2012 at 2:38 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 20 Jan 2012 14:34:05 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Would like some feedback from security experts on this one.
>> The LANMAN hash is easy to break and enabling it in
>> a hostile environment seems wrong - obviously there
>> are home environments and behind NATs where
>> it is ok and where old LANMAN servers might exist. =A0Although it
>> can be controlled at runtime, allowing it to be
>> not built in gives administrators more control
>> so that users do not change this workstation
>> runtime config values in potentially dangerous ways.
>>
>
> That's fine -- this is intended for 3.4 so you should have plenty of
> time. Can you briefly outline the potential scenario where you see th=
is
> as useful?
>
> I don't see a lot of benefit from this Kconfig option. You have to be
> root to enable this at runtime, and at that point all bets are off as
> far as what someone can do. They can plug in their own kmod at that
> point if you don't compile it in.
>
>
>> On Fri, Jan 20, 2012 at 2:25 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > ...and just make it always turned on. In practice almost everyone
>> > enables this option, and as the Kconfig option says, it needs to b=
e
>> > enabled at runtime anyway. I see no need to make this disableable
>> > via Kconfig option as well, and removing the option simplifies the
>> > testing matrix and reduced ifdef clutter in the code.
>> >
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/Kconfig =A0 =A0 =A0 | =A0 27 --------------------------=
-
>> > =A0fs/cifs/cifs_debug.c =A0| =A0 =A02 --
>> > =A0fs/cifs/cifsencrypt.c | =A0 =A02 --
>> > =A0fs/cifs/cifsglob.h =A0 =A0| =A0 17 +----------------
>> > =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A04 ----
>> > =A0fs/cifs/cifsproto.h =A0 | =A0 =A02 --
>> > =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 24 ------------------------
>> > =A0fs/cifs/connect.c =A0 =A0 | =A0 =A08 ++------
>> > =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 10 ----------
>> > =A09 files changed, 3 insertions(+), 93 deletions(-)
>> >
>> > diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> > index 0554b00..ee7ac6b 100644
>> > --- a/fs/cifs/Kconfig
>> > +++ b/fs/cifs/Kconfig
>> > @@ -49,33 +49,6 @@ config CIFS_STATS2
>> > =A0 =A0 =A0 =A0 =A0Unless you are a developer or are doing network=
 performance analysis
>> > =A0 =A0 =A0 =A0 =A0or tuning, say N.
>> >
>> > -config CIFS_WEAK_PW_HASH
>> > - =A0 =A0 =A0 bool "Support legacy servers which use weaker LANMAN=
 security"
>> > - =A0 =A0 =A0 depends on CIFS
>> > - =A0 =A0 =A0 help
>> > - =A0 =A0 =A0 =A0 Modern CIFS servers including Samba and most Win=
dows versions
>> > - =A0 =A0 =A0 =A0 (since 1997) support stronger NTLM (and even NTL=
Mv2 and Kerberos)
>> > - =A0 =A0 =A0 =A0 security mechanisms. These hash the password mor=
e securely
>> > - =A0 =A0 =A0 =A0 than the mechanisms used in the older LANMAN ver=
sion of the
>> > - =A0 =A0 =A0 =A0 SMB protocol but LANMAN based authentication is =
needed to
>> > - =A0 =A0 =A0 =A0 establish sessions with some old SMB servers.
>> > -
>> > - =A0 =A0 =A0 =A0 Enabling this option allows the cifs module to m=
ount to older
>> > - =A0 =A0 =A0 =A0 LANMAN based servers such as OS/2 and Windows 95=
, but such
>> > - =A0 =A0 =A0 =A0 mounts may be less secure than mounts using NTLM=
 or more recent
>> > - =A0 =A0 =A0 =A0 security mechanisms if you are on a public netwo=
rk. =A0Unless you
>> > - =A0 =A0 =A0 =A0 have a need to access old SMB servers (and are o=
n a private
>> > - =A0 =A0 =A0 =A0 network) you probably want to say N. =A0Even if =
this support
>> > - =A0 =A0 =A0 =A0 is enabled in the kernel build, LANMAN authentic=
ation will not be
>> > - =A0 =A0 =A0 =A0 used automatically. At runtime LANMAN mounts are=
 disabled but
>> > - =A0 =A0 =A0 =A0 can be set to required (or optional) either in
>> > - =A0 =A0 =A0 =A0 /proc/fs/cifs (see fs/cifs/README for more detai=
l) or via an
>> > - =A0 =A0 =A0 =A0 option on the mount command. This support is dis=
abled by
>> > - =A0 =A0 =A0 =A0 default in order to reduce the possibility of a =
downgrade
>> > - =A0 =A0 =A0 =A0 attack.
>> > -
>> > - =A0 =A0 =A0 =A0 If unsure, say N.
>> > -
>> > =A0config CIFS_UPCALL
>> > =A0 =A0 =A0 =A0bool "Kerberos/SPNEGO advanced session setup"
>> > =A0 =A0 =A0 =A0depends on CIFS && KEYS
>> > diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
>> > index 24b3dfc..589774f 100644
>> > --- a/fs/cifs/cifs_debug.c
>> > +++ b/fs/cifs/cifs_debug.c
>> > @@ -126,9 +126,7 @@ static int cifs_debug_data_proc_show(struct se=
q_file *m, void *v)
>> > =A0#ifdef CONFIG_CIFS_FSCACHE
>> > =A0 =A0 =A0 =A0seq_printf(m, " fscache");
>> > =A0#endif
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0 =A0 =A0 =A0seq_printf(m, " lanman");
>> > -#endif
>> > =A0#ifdef CONFIG_CIFS_POSIX
>> > =A0 =A0 =A0 =A0seq_printf(m, " posix");
>> > =A0#endif
>> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> > index 63c460e..96997cc 100644
>> > --- a/fs/cifs/cifsencrypt.c
>> > +++ b/fs/cifs/cifsencrypt.c
>> > @@ -242,7 +242,6 @@ int setup_ntlm_response(struct cifs_ses *ses, =
const struct nls_table *nls_cp)
>> > =A0 =A0 =A0 =A0return rc;
>> > =A0}
>> >
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0int calc_lanman_hash(const char *password, const char *cryptkey=
, bool encrypt,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *lnm_session_k=
ey)
>> > =A0{
>> > @@ -279,7 +278,6 @@ int calc_lanman_hash(const char *password, con=
st char *cryptkey, bool encrypt,
>> >
>> > =A0 =A0 =A0 =A0return rc;
>> > =A0}
>> > -#endif /* CIFS_WEAK_PW_HASH */
>> >
>> > =A0/* Build a proper attribute value/target info pairs blob.
>> > =A0* Fill in netbios and dns domain name and workstation name
>> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> > index 76e7d8b..0e56b1e 100644
>> > --- a/fs/cifs/cifsglob.h
>> > +++ b/fs/cifs/cifsglob.h
>> > @@ -853,13 +853,8 @@ static inline void free_dfs_info_array(struct=
 dfs_info3_param *param,
>> > =A0#define =A0 CIFSSEC_MAY_NTLM =A0 =A0 0x00002
>> > =A0#define =A0 CIFSSEC_MAY_NTLMV2 =A0 0x00004
>> > =A0#define =A0 CIFSSEC_MAY_KRB5 =A0 =A0 0x00008
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0#define =A0 CIFSSEC_MAY_LANMAN =A0 0x00010
>> > =A0#define =A0 CIFSSEC_MAY_PLNTXT =A0 0x00020
>> > -#else
>> > -#define =A0 CIFSSEC_MAY_LANMAN =A0 =A00
>> > -#define =A0 CIFSSEC_MAY_PLNTXT =A0 =A00
>> > -#endif /* weak passwords */
>> > =A0#define =A0 CIFSSEC_MAY_SEAL =A0 =A0 0x00040 /* not supported y=
et */
>> > =A0#define =A0 CIFSSEC_MAY_NTLMSSP =A00x00080 /* raw ntlmssp with =
ntlmv2 */
>> >
>> > @@ -870,23 +865,13 @@ require use of the stronger protocol */
>> > =A0#define =A0 CIFSSEC_MUST_NTLM =A0 =A00x02002
>> > =A0#define =A0 CIFSSEC_MUST_NTLMV2 =A00x04004
>> > =A0#define =A0 CIFSSEC_MUST_KRB5 =A0 =A00x08008
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0#define =A0 CIFSSEC_MUST_LANMAN =A00x10010
>> > =A0#define =A0 CIFSSEC_MUST_PLNTXT =A00x20020
>> > =A0#ifdef CONFIG_CIFS_UPCALL
>> > =A0#define =A0 CIFSSEC_MASK =A0 =A0 =A0 =A0 =A00xBF0BF /* allows w=
eak security but also krb5 */
>> > -#else
>> > +#else /* UPCALL */
>> > =A0#define =A0 CIFSSEC_MASK =A0 =A0 =A0 =A0 =A00xB70B7 /* current =
flags supported if weak */
>> > =A0#endif /* UPCALL */
>> > -#else /* do not allow weak pw hash */
>> > -#define =A0 CIFSSEC_MUST_LANMAN =A00
>> > -#define =A0 CIFSSEC_MUST_PLNTXT =A00
>> > -#ifdef CONFIG_CIFS_UPCALL
>> > -#define =A0 CIFSSEC_MASK =A0 =A0 =A0 =A0 =A00x8F08F /* flags supp=
orted if no weak allowed */
>> > -#else
>> > -#define =A0 =A0 =A0 =A0 =A0CIFSSEC_MASK =A0 =A0 =A0 =A0 =A00x8708=
7 /* flags supported if no weak allowed */
>> > -#endif /* UPCALL */
>> > -#endif /* WEAK_PW_HASH */
>> > =A0#define =A0 CIFSSEC_MUST_SEAL =A0 =A00x40040 /* not supported y=
et */
>> > =A0#define =A0 CIFSSEC_MUST_NTLMSSP 0x80080 /* raw ntlmssp with nt=
lmv2 */
>> >
>> > diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
>> > index 3fb03e2..ef28614 100644
>> > --- a/fs/cifs/cifspdu.h
>> > +++ b/fs/cifs/cifspdu.h
>> > @@ -26,13 +26,9 @@
>> > =A0#include <asm/unaligned.h>
>> > =A0#include "smbfsctl.h"
>> >
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0#define LANMAN_PROT 0
>> > =A0#define LANMAN2_PROT 1
>> > =A0#define CIFS_PROT =A0 2
>> > -#else
>> > -#define CIFS_PROT =A0 0
>> > -#endif
>> > =A0#define POSIX_PROT =A0(CIFS_PROT+1)
>> > =A0#define BAD_PROT 0xFFFF
>> >
>> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> > index 6f4e243..a81549d 100644
>> > --- a/fs/cifs/cifsproto.h
>> > +++ b/fs/cifs/cifsproto.h
>> > @@ -403,10 +403,8 @@ extern int cifs_crypto_shash_allocate(struct =
TCP_Server_Info *);
>> > =A0extern void cifs_crypto_shash_release(struct TCP_Server_Info *)=
;
>> > =A0extern int calc_seckey(struct cifs_ses *);
>> >
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0extern int calc_lanman_hash(const char *password, const char *c=
ryptkey,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0boo=
l encrypt, char *lnm_session_key);
>> > -#endif /* CIFS_WEAK_PW_HASH */
>> > =A0#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily *=
/
>> > =A0extern int CIFSSMBNotify(const int xid, struct cifs_tcon *tcon,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const int notify_su=
bdirs, const __u16 netfid,
>> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> > index 8b7794c..cf12c0c 100644
>> > --- a/fs/cifs/cifssmb.c
>> > +++ b/fs/cifs/cifssmb.c
>> > @@ -49,10 +49,8 @@ static struct {
>> > =A0 =A0 =A0 =A0int index;
>> > =A0 =A0 =A0 =A0char *name;
>> > =A0} protocols[] =3D {
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0 =A0 =A0 =A0{LANMAN_PROT, "\2LM1.2X002"},
>> > =A0 =A0 =A0 =A0{LANMAN2_PROT, "\2LANMAN2.1"},
>> > -#endif /* weak password hashing for legacy clients */
>> > =A0 =A0 =A0 =A0{CIFS_PROT, "\2NT LM 0.12"},
>> > =A0 =A0 =A0 =A0{POSIX_PROT, "\2POSIX 2"},
>> > =A0 =A0 =A0 =A0{BAD_PROT, "\2"}
>> > @@ -62,10 +60,8 @@ static struct {
>> > =A0 =A0 =A0 =A0int index;
>> > =A0 =A0 =A0 =A0char *name;
>> > =A0} protocols[] =3D {
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0 =A0 =A0 =A0{LANMAN_PROT, "\2LM1.2X002"},
>> > =A0 =A0 =A0 =A0{LANMAN2_PROT, "\2LANMAN2.1"},
>> > -#endif /* weak password hashing for legacy clients */
>> > =A0 =A0 =A0 =A0{CIFS_PROT, "\2NT LM 0.12"},
>> > =A0 =A0 =A0 =A0{BAD_PROT, "\2"}
>> > =A0};
>> > @@ -73,17 +69,9 @@ static struct {
>> >
>> > =A0/* define the number of elements in the cifs dialect array */
>> > =A0#ifdef CONFIG_CIFS_POSIX
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0#define CIFS_NUM_PROT 4
>> > -#else
>> > -#define CIFS_NUM_PROT 2
>> > -#endif /* CIFS_WEAK_PW_HASH */
>> > =A0#else /* not posix */
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0#define CIFS_NUM_PROT 3
>> > -#else
>> > -#define CIFS_NUM_PROT 1
>> > -#endif /* CONFIG_CIFS_WEAK_PW_HASH */
>> > =A0#endif /* CIFS_POSIX */
>> >
>> > =A0/* Forward declarations */
>> > @@ -441,7 +429,6 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs=
_ses *ses)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0could not negotiate a common dialec=
t */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EOPNOTSUPP;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto neg_err_exit;
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0 =A0 =A0 =A0} else if ((pSMBr->hdr.WordCount =3D=3D 13)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&& ((server->dialec=
t =3D=3D LANMAN_PROT)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|| =
(server->dialect =3D=3D LANMAN2_PROT))) {
>> > @@ -519,13 +506,6 @@ CIFSSMBNegotiate(unsigned int xid, struct cif=
s_ses *ses)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we will not end up setting signi=
ng flags - as no signing
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0was in LANMAN and server did not re=
turn the flags on */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto signing_check;
>> > -#else /* weak security disabled */
>> > - =A0 =A0 =A0 } else if (pSMBr->hdr.WordCount =3D=3D 13) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "mount failed, cifs module=
 not built "
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "with CIFS_WEAK_=
PW_HASH support");
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOPNOTSUPP;
>> > -#endif /* WEAK_PW_HASH */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto neg_err_exit;
>> > =A0 =A0 =A0 =A0} else if (pSMBr->hdr.WordCount !=3D 17) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* unknown wct */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EOPNOTSUPP;
>> > @@ -537,9 +517,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs=
_ses *ses)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "share mode security");
>> >
>> > =A0 =A0 =A0 =A0if ((server->sec_mode & SECMODE_PW_ENCRYPT) =3D=3D =
0)
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((secFlags & CIFSSEC_MAY_PLNTXT)=
 =3D=3D 0)
>> > -#endif /* CIFS_WEAK_PW_HASH */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Server r=
equests plain text password"
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
" but client support disabled");
>> >
>> > @@ -627,9 +605,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs=
_ses *ses)
>> > =A0 =A0 =A0 =A0} else
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->capabilities &=3D ~CAP_EXTE=
NDED_SECURITY;
>> >
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0signing_check:
>> > -#endif
>> > =A0 =A0 =A0 =A0if ((secFlags & CIFSSEC_MAY_SIGN) =3D=3D 0) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* MUST_SIGN already includes the M=
AY_SIGN FLAG
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 so if this is zero it means th=
at signing is disabled */
>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > index aa687c8..5aeca5e 100644
>> > --- a/fs/cifs/connect.c
>> > +++ b/fs/cifs/connect.c
>> > @@ -1153,10 +1153,8 @@ cifs_parse_mount_options(const char *mountd=
ata, const char *devname,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp=
(value, "nontlm", 6) =3D=3D 0) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* =
BB is there a better way to do this? */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol=
->secFlg |=3D CIFSSEC_MAY_NTLMV2;
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp=
(value, "lanman", 6) =3D=3D 0) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol=
->secFlg |=3D CIFSSEC_MAY_LANMAN;
>> > -#endif
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp=
(value, "none", 4) =3D=3D 0) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol=
->nullauth =3D 1;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
>> > @@ -3611,7 +3609,6 @@ CIFSTCon(unsigned int xid, struct cifs_ses *=
ses,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 weaker LANMAN (which we do not=
 send by default) is accepted
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 by Samba (not sure whether oth=
er servers allow
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMv2 password here) */
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((global_secflags & CIFSSEC_MAY_=
LANMAN) &&
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(ses->server->secType =3D=3D=
 LANMAN))
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0calc_lanman_hash(tc=
on->password, ses->server->cryptkey,
>> > @@ -3619,9 +3616,8 @@ CIFSTCon(unsigned int xid, struct cifs_ses *=
ses,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0SECMODE_PW_ENCRYPT ? true : false,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 bcc_ptr);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
>> > -#endif /* CIFS_WEAK_PW_HASH */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SMBNTencrypt(tcon->password, =
ses->server->cryptkey,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 bcc_ptr, nls_codepage);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SMBNTencrypt(=
tcon->password, ses->server->cryptkey,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr, nls_codepage);
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ses->capabilities & CAP_UNICODE=
) {
>> > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> > index d85efad..1cce63b 100644
>> > --- a/fs/cifs/sess.c
>> > +++ b/fs/cifs/sess.c
>> > @@ -592,14 +592,6 @@ ssetup_ntlmssp_authenticate:
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phase =3D NtLmAuthenticate; /* if n=
tlmssp, now final phase */
>> >
>> > =A0 =A0 =A0 =A0if (type =3D=3D LANMAN) {
>> > -#ifndef CONFIG_CIFS_WEAK_PW_HASH
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* LANMAN and plaintext are less sec=
ure and off by default.
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 So we make this explicitly be turned=
 on in kconfig (in the
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 build) and turned on at runtime (cha=
nged from the default)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 in proc/fs/cifs or via mount parm. =A0=
Unfortunately this is
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 needed for old Win (e.g. Win95), som=
e obscure NAS and OS/2 */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
>> > -#endif
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wct =3D 10; /* lanman 2 style sessi=
onsetup */
>> > =A0 =A0 =A0 =A0} else if ((type =3D=3D NTLM) || (type =3D=3D NTLMv=
2)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* For NTLMv2 failures eventually m=
ay need to retry NTLM */
>> > @@ -643,7 +635,6 @@ ssetup_ntlmssp_authenticate:
>> > =A0 =A0 =A0 =A0iov[1].iov_len =3D 0;
>> >
>> > =A0 =A0 =A0 =A0if (type =3D=3D LANMAN) {
>> > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char lnm_session_key[CIFS_AUTH_RESP=
_SIZE];
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req.hdr.Flags2 &=3D ~SMBFLG2_=
UNICODE;
>> > @@ -674,7 +665,6 @@ ssetup_ntlmssp_authenticate:
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Negotiating LANMAN setting=
 up strings");
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Unicode not allowed for LANMAN d=
ialects */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ascii_ssetup_strings(&bcc_ptr, ses,=
 nls_cp);
>> > -#endif
>> > =A0 =A0 =A0 =A0} else if (type =3D=3D NTLM) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req_no_secext.Capabilities =3D=
 cpu_to_le32(capabilities);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req_no_secext.CaseInsensitive=
PasswordLength =3D
>> > --
>> > 1.7.7.5
>> >
>>
>>
>>
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Thanks,

Steve
