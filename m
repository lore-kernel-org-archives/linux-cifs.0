From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: Add idmap key and related data structures and
 functions (try #17)
Date: Tue, 26 Apr 2011 20:44:42 -0500
Message-ID: <BANLkTi=mcnXZ-+g8AAsjFKYCCKivzZ_iKg@mail.gmail.com>
References: <1303395340-26664-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303395340-26664-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

close - but not quite right.

cifsacl.c depends on CONFIG_CIFS_ACL, but you refer to functions in
cifsacl.c within a different ifdef in cifsfs.c

On Thu, Apr 21, 2011 at 9:15 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Define (global) data structures to store ids, uids and gids, to which=
 a
> SID maps. =A0There are two separate trees, one for SID/uid and anothe=
r one
> for SID/gid.
>
> A new type of key, cifs_idmap_key_type, is used.
>
> Keys are instantiated and searched using credential of the root by
> overriding and restoring the credentials of the caller requesting the=
 key.
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsacl.c =A0 | =A0138 +++++++++++++++++++++++++++++++++++=
++++++++++++++++
> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 =A07 +++
> =A0fs/cifs/cifsglob.h =A0| =A0 =A05 ++
> =A0fs/cifs/cifsproto.h | =A0 =A03 +
> =A04 files changed, 153 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index a0d11ea..061fc3a 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -23,6 +23,10 @@
>
> =A0#include <linux/fs.h>
> =A0#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/keyctl.h>
> +#include <linux/key-type.h>
> +#include <keys/user-type.h>
> =A0#include "cifspdu.h"
> =A0#include "cifsglob.h"
> =A0#include "cifsacl.h"
> @@ -50,6 +54,140 @@ static const struct cifs_sid sid_authusers =3D {
> =A0/* group users */
> =A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, 0, 0, =
5}, {} };
>
> +static const struct cred *root_cred;
> +
> +/*
> + * Run idmap cache shrinker.
> + */
> +static int
> +cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t g=
fp_mask)
> +{
> + =A0 =A0 =A0 /* Use a pruning scheme in a subsequent patch instead *=
/
> + =A0 =A0 =A0 cifs_destroy_idmaptrees();
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static struct shrinker cifs_shrinker =3D {
> + =A0 =A0 =A0 .shrink =3D cifs_idmap_shrinker,
> + =A0 =A0 =A0 .seeks =3D DEFAULT_SEEKS,
> +};
> +
> +static int
> +cifs_idmap_key_instantiate(struct key *key, const void *data, size_t=
 datalen)
> +{
> + =A0 =A0 =A0 char *payload;
> +
> + =A0 =A0 =A0 payload =3D kmalloc(datalen, GFP_KERNEL);
> + =A0 =A0 =A0 if (!payload)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 memcpy(payload, data, datalen);
> + =A0 =A0 =A0 key->payload.data =3D payload;
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static inline void
> +cifs_idmap_key_destroy(struct key *key)
> +{
> + =A0 =A0 =A0 kfree(key->payload.data);
> +}
> +
> +static
> +struct key_type cifs_idmap_key_type =3D {
> + =A0 =A0 =A0 .name =A0 =A0 =A0 =A0=3D "cifs.cifs_idmap",
> + =A0 =A0 =A0 .instantiate =3D cifs_idmap_key_instantiate,
> + =A0 =A0 =A0 .destroy =A0 =A0 =3D cifs_idmap_key_destroy,
> + =A0 =A0 =A0 .describe =A0 =A0=3D user_describe,
> + =A0 =A0 =A0 .match =A0 =A0 =A0 =3D user_match,
> +};
> +
> +int
> +init_cifs_idmap(void)
> +{
> + =A0 =A0 =A0 struct cred *cred;
> + =A0 =A0 =A0 struct key *keyring;
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 cFYI(1, "Registering the %s key type\n", cifs_idmap_key=
_type.name);
> +
> + =A0 =A0 =A0 /* create an override credential set with a special thr=
ead keyring in
> + =A0 =A0 =A0 =A0* which requests are cached
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* this is used to prevent malicious redirections fro=
m being installed
> + =A0 =A0 =A0 =A0* with add_key().
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 cred =3D prepare_kernel_cred(NULL);
> + =A0 =A0 =A0 if (!cred)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 keyring =3D key_alloc(&key_type_keyring, ".cifs_idmap",=
 0, 0, cred,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (KEY_POS_ALL & =
~KEY_POS_SETATTR) |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 KEY_USR_VIEW | =
KEY_USR_READ,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 KEY_ALLOC_NOT_I=
N_QUOTA);
> + =A0 =A0 =A0 if (IS_ERR(keyring)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PTR_ERR(keyring);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto failed_put_cred;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ret =3D key_instantiate_and_link(keyring, NULL, 0, NULL=
, NULL);
> + =A0 =A0 =A0 if (ret < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto failed_put_key;
> +
> + =A0 =A0 =A0 ret =3D register_key_type(&cifs_idmap_key_type);
> + =A0 =A0 =A0 if (ret < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto failed_put_key;
> +
> + =A0 =A0 =A0 /* instruct request_key() to use this special keyring a=
s a cache for
> + =A0 =A0 =A0 =A0* the results it looks up */
> + =A0 =A0 =A0 cred->thread_keyring =3D keyring;
> + =A0 =A0 =A0 cred->jit_keyring =3D KEY_REQKEY_DEFL_THREAD_KEYRING;
> + =A0 =A0 =A0 root_cred =3D cred;
> +
> + =A0 =A0 =A0 spin_lock_init(&siduidlock);
> + =A0 =A0 =A0 uidtree =3D RB_ROOT;
> + =A0 =A0 =A0 spin_lock_init(&sidgidlock);
> + =A0 =A0 =A0 gidtree =3D RB_ROOT;
> +
> + =A0 =A0 =A0 register_shrinker(&cifs_shrinker);
> +
> + =A0 =A0 =A0 cFYI(1, "cifs idmap keyring: %d\n", key_serial(keyring)=
);
> + =A0 =A0 =A0 return 0;
> +
> +failed_put_key:
> + =A0 =A0 =A0 key_put(keyring);
> +failed_put_cred:
> + =A0 =A0 =A0 put_cred(cred);
> + =A0 =A0 =A0 return ret;
> +}
> +
> +void
> +exit_cifs_idmap(void)
> +{
> + =A0 =A0 =A0 key_revoke(root_cred->thread_keyring);
> + =A0 =A0 =A0 unregister_key_type(&cifs_idmap_key_type);
> + =A0 =A0 =A0 put_cred(root_cred);
> + =A0 =A0 =A0 unregister_shrinker(&cifs_shrinker);
> + =A0 =A0 =A0 cFYI(1, "Unregistered %s key type\n", cifs_idmap_key_ty=
pe.name);
> +}
> +
> +void
> +cifs_destroy_idmaptrees(void)
> +{
> + =A0 =A0 =A0 struct rb_root *root;
> + =A0 =A0 =A0 struct rb_node *node;
> +
> + =A0 =A0 =A0 root =3D &uidtree;
> + =A0 =A0 =A0 spin_lock(&siduidlock);
> + =A0 =A0 =A0 while ((node =3D rb_first(root)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(node, root);
> + =A0 =A0 =A0 spin_unlock(&siduidlock);
> +
> + =A0 =A0 =A0 root =3D &gidtree;
> + =A0 =A0 =A0 spin_lock(&sidgidlock);
> + =A0 =A0 =A0 while ((node =3D rb_first(root)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(node, root);
> + =A0 =A0 =A0 spin_unlock(&sidgidlock);
> +}
>
> =A0int match_sid(struct cifs_sid *ctsid)
> =A0{
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 30fc505..665bf1d 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1040,11 +1040,16 @@ init_cifs(void)
> =A0 =A0 =A0 =A0rc =3D register_key_type(&cifs_spnego_key_type);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_unregister_filesystem;
> + =A0 =A0 =A0 rc =3D init_cifs_idmap();
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_unregister_keytype;
> =A0#endif
>
> =A0 =A0 =A0 =A0return 0;
>
> =A0#ifdef CONFIG_CIFS_UPCALL
> +out_unregister_keytype:
> + =A0 =A0 =A0 unregister_key_type(&cifs_spnego_key_type);
> =A0out_unregister_filesystem:
> =A0 =A0 =A0 =A0unregister_filesystem(&cifs_fs_type);
> =A0#endif
> @@ -1071,6 +1076,8 @@ exit_cifs(void)
> =A0 =A0 =A0 =A0cifs_dfs_release_automount_timer();
> =A0#endif
> =A0#ifdef CONFIG_CIFS_UPCALL
> + =A0 =A0 =A0 cifs_destroy_idmaptrees();
> + =A0 =A0 =A0 exit_cifs_idmap();
> =A0 =A0 =A0 =A0unregister_key_type(&cifs_spnego_key_type);
> =A0#endif
> =A0 =A0 =A0 =A0unregister_filesystem(&cifs_fs_type);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 108a1e9..76b4517 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -833,6 +833,11 @@ GLOBAL_EXTERN unsigned int cifs_max_pending; /* =
MAX requests at once to server*/
> =A0/* reconnect after this many failed echo attempts */
> =A0GLOBAL_EXTERN unsigned short echo_retries;
>
> +GLOBAL_EXTERN struct rb_root uidtree;
> +GLOBAL_EXTERN struct rb_root gidtree;
> +GLOBAL_EXTERN spinlock_t siduidlock;
> +GLOBAL_EXTERN spinlock_t sidgidlock;
> +
> =A0void cifs_oplock_break(struct work_struct *work);
> =A0void cifs_oplock_break_get(struct cifsFileInfo *cfile);
> =A0void cifs_oplock_break_put(struct cifsFileInfo *cfile);
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 0e4e057..7c1ed01 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -53,6 +53,9 @@ do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0cFYI(1, "CIFS VFS: leaving %s (xid =3D %d) rc =3D %d",=
 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0 =A0 =A0 __func__, curr_xid, (int)rc); =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0} while (0)
> +extern int init_cifs_idmap(void);
> +extern void exit_cifs_idmap(void);
> +extern void cifs_destroy_idmaptrees(void);
> =A0extern char *build_path_from_dentry(struct dentry *);
> =A0extern char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0struct cifsTconInfo *tcon);
> --
> 1.6.0.2
>
>



--=20
Thanks,

Steve
