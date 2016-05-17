From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Create dedicated keyring for spnego operations
Date: Tue, 17 May 2016 16:35:34 +0100
Message-ID: <1463499334.3084.30.camel@redhat.com>
References: <1461355113-30510-1-git-send-email-sprabhu@redhat.com>
	 <CADT32e+Z71K=mjB_Ff2NQ-jQLPAZ3cVz0xuQ_kFouDDC_5tRUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Scott Mayhew <smayhew-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+Z71K=mjB_Ff2NQ-jQLPAZ3cVz0xuQ_kFouDDC_5tRUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2016-04-23 at 17:58 -0500, Shirish Pargaonkar wrote:
> Looks correct. May be init functions for idmap and spnego could be
> merged..

Thanks Sirish,

They have #ifdef..#endif set for different config options so I thought
it is better that they are initialised separately.

Sachin Prabhu

>=20
> Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> On Fri, Apr 22, 2016 at 2:58 PM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> >=20
> > The session key is the default keyring set for request_key
> > operations.
> > This session key is revoked when the user owning the session logs
> > out.
> > Any long running daemon processes started by this session ends up
> > with
> > revoked session keyring which prevents these processes from using
> > the
> > request_key mechanism from obtaining the krb5 keys.
> >=20
> > The problem has been reported by a large number of autofs users.
> > The
> > problem is also seen with multiuser mounts where the share may be
> > used
> > by processes run by a user who has since logged out. A reproducer
> > using
> > automount is available on the Red Hat bz.
> >=20
> > The patch creates a new keyring which is used to cache cifs spnego
> > upcalls.
> >=20
> > Red Hat bz: 1267754
> >=20
> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Reported-by: Scott Mayhew <smayhew-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifs_spnego.c | 67
> > +++++++++++++++++++++++++++++++++++++++++++++++++++
> > =C2=A0fs/cifs/cifsfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=
=A04 +--
> > =C2=A0fs/cifs/cifsproto.h=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 ++
> > =C2=A03 files changed, 71 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
> > index 6908080..248ab43 100644
> > --- a/fs/cifs/cifs_spnego.c
> > +++ b/fs/cifs/cifs_spnego.c
> > @@ -24,11 +24,14 @@
> > =C2=A0#include <linux/string.h>
> > =C2=A0#include <keys/user-type.h>
> > =C2=A0#include <linux/key-type.h>
> > +#include <linux/keyctl.h>
> > =C2=A0#include <linux/inet.h>
> > =C2=A0#include "cifsglob.h"
> > =C2=A0#include "cifs_spnego.h"
> > =C2=A0#include "cifs_debug.h"
> >=20
> > +static const struct cred *spnego_cred;
> > +
> > =C2=A0/* create a new cifs key */
> > =C2=A0static int
> > =C2=A0cifs_spnego_key_instantiate(struct key *key, struct
> > key_preparsed_payload *prep)
> > @@ -102,6 +105,7 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0size_t desc_len;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct key *spnego_=
key;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const char *hostnam=
e =3D server->hostname;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const struct cred *saved=
_cred;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* length of fields=
 (with semicolons): ver=3D0xyz
> > ip4=3Dipaddress
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0h=
ost=3Dhostname sec=3Dmechanism uid=3D0xFF user=3Dusername */
> > @@ -163,7 +167,9 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sprintf(dp, ";pid=3D=
0x%x", current->pid);
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_dbg(FYI, "key =
description =3D %s\n", description);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0saved_cred =3D override_=
creds(spnego_cred);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spnego_key =3D requ=
est_key(&cifs_spnego_key_type,
> > description, "");
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0revert_creds(saved_cred)=
;
> >=20
> > =C2=A0#ifdef CONFIG_CIFS_DEBUG2
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (cifsFYI && !IS_=
ERR(spnego_key)) {
> > @@ -177,3 +183,64 @@ out:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(description);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return spnego_key;
> > =C2=A0}
> > +
> > +int
> > +init_cifs_spnego(void)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct cred *cred;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct key *keyring;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_dbg(FYI, "Registeri=
ng the %s key type\n",
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_spnego_key_type.name);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* Create an overri=
de credential set with special thread
> > keyring for
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* spnego upcalls.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cred =3D prepare_kernel_=
cred(NULL);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!cred)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -ENOMEM;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0keyring =3D keyring_allo=
c(".cifs_spnego",
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0GLOBAL_ROOT_UID, GLOBAL=
_ROOT_GID,
> > cred,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(KEY_POS_ALL & ~KEY_POS=
_SETATTR) |
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0KEY_USR_VIEW | KEY_USR_=
READ,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0KEY_ALLOC_NOT_IN_QUOTA,=
 NULL);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (IS_ERR(keyring)) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ret =3D PTR_ERR(keyring);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto failed_put_cred;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D register_key_typ=
e(&cifs_spnego_key_type);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret < 0)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto failed_put_key;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* instruct request=
_key() to use this special keyring as a
> > cache for
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* the results it l=
ooks up
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0set_bit(KEY_FLAG_ROOT_CA=
N_CLEAR, &keyring->flags);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cred->thread_keyring =3D=
 keyring;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cred->jit_keyring =3D KE=
Y_REQKEY_DEFL_THREAD_KEYRING;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spnego_cred =3D cred;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_dbg(FYI, "cifs spne=
go keyring: %d\n",
> > key_serial(keyring));
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > +
> > +failed_put_key:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0key_put(keyring);
> > +failed_put_cred:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0put_cred(cred);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ret;
> > +}
> > +
> > +void
> > +exit_cifs_spnego(void)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0key_revoke(spnego_cred->=
thread_keyring);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unregister_key_type(&cif=
s_spnego_key_type);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0put_cred(spnego_cred);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_dbg(FYI, "Unregiste=
red %s key type\n",
> > cifs_spnego_key_type.name);
> > +}
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 8920156..9852044 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -1307,7 +1307,7 @@ init_cifs(void)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0goto out_destroy_mids;
> >=20
> > =C2=A0#ifdef CONFIG_CIFS_UPCALL
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rc =3D register_key_type=
(&cifs_spnego_key_type);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rc =3D init_cifs_spnego(=
);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (rc)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0goto out_destroy_request_bufs;
> > =C2=A0#endif /* CONFIG_CIFS_UPCALL */
> > @@ -1330,7 +1330,7 @@ out_init_cifs_idmap:
> > =C2=A0out_register_key_type:
> > =C2=A0#endif
> > =C2=A0#ifdef CONFIG_CIFS_UPCALL
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unregister_key_type(&cif=
s_spnego_key_type);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0exit_cifs_spnego();
> > =C2=A0out_destroy_request_bufs:
> > =C2=A0#endif
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_destroy_reques=
t_bufs();
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index eed7ff5..ca618b0 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -60,6 +60,8 @@ do
> > {=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0\
> > =C2=A0} while (0)
> > =C2=A0extern int init_cifs_idmap(void);
> > =C2=A0extern void exit_cifs_idmap(void);
> > +extern int init_cifs_spnego(void);
> > +extern int exit_cifs_spnego(void);
> > =C2=A0extern char *build_path_from_dentry(struct dentry *);
> > =C2=A0extern char *cifs_build_path_to_root(struct smb_vol *vol,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0struct cifs_sb_info *cifs_sb,
> > --
> > 2.5.5
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-=
info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
=20
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-in=
fo.html
