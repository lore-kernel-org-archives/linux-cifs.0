From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: cleanup: Rename and remove config flags
Date: Fri, 25 Feb 2011 12:29:09 -0600
Message-ID: <AANLkTi=KHWVp1Y90JSt-JvFauuRSJaGuaB5h4=4e06Zb@mail.gmail.com>
References: <1298652535-14628-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298652535-14628-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

looks fine to me

On Fri, Feb 25, 2011 at 10:48 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Remove config flag CIFS_EXPERIMENTAL.
> Do export operations under new config flag CIFS_NFSD_EXPORT
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/Kconfig =A0 | =A0 14 +++-----------
> =A0fs/cifs/cifsfs.c =A0| =A0 =A04 ++--
> =A0fs/cifs/cifsfs.h =A0| =A0 =A04 ++--
> =A0fs/cifs/cifssmb.c | =A0 =A04 ----
> =A0fs/cifs/export.c =A0| =A0 =A04 ++--
> =A05 files changed, 9 insertions(+), 21 deletions(-)
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 2a492aa..7c584be 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -172,16 +172,8 @@ config CIFS_SMB2
>
> =A0 =A0 =A0 =A0 =A0Unless you are a developer or tester, say N.
>
> -config CIFS_EXPERIMENTAL
> - =A0 =A0 =A0 =A0 bool "CIFS Experimental Features (EXPERIMENTAL)"
> +config CIFS_NFSD_EXPORT
> + =A0 =A0 =A0 =A0 bool "Allow nfsd to export CIFS file system (EXPERI=
MENTAL)"
> =A0 =A0 =A0 =A0 =A0depends on CIFS && EXPERIMENTAL
> =A0 =A0 =A0 =A0 =A0help
> - =A0 =A0 =A0 =A0 =A0 Enables cifs features under testing. These feat=
ures are
> - =A0 =A0 =A0 =A0 =A0 experimental and currently include DFS support =
and directory
> - =A0 =A0 =A0 =A0 =A0 change notification ie fcntl(F_DNOTIFY), as wel=
l as the upcall
> - =A0 =A0 =A0 =A0 =A0 mechanism which will be used for Kerberos sessi=
on negotiation
> - =A0 =A0 =A0 =A0 =A0 and uid remapping. =A0Some of these features al=
so may depend on
> - =A0 =A0 =A0 =A0 =A0 setting a value of 1 to the pseudo-file /proc/f=
s/cifs/Experimental
> - =A0 =A0 =A0 =A0 =A0 (which is disabled by default). See the file fs=
/cifs/README
> - =A0 =A0 =A0 =A0 =A0 for more details. =A0If unsure, say N.
> -
> + =A0 =A0 =A0 =A0 =A0Allows NFS server to export a CIFS mounted share=
 (nfsd over cifs)
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 191ef2f..f593036 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -187,12 +187,12 @@ cifs_read_super(struct super_block *sb, void *d=
ata,
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_d_op =3D &cifs_dentry_ops;
>
> -#ifdef CONFIG_CIFS_EXPERIMENTAL
> +#ifdef CIFS_NFSD_EXPORT
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "export ops supported");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_export_op =3D &cifs_export_ops;
> =A0 =A0 =A0 =A0}
> -#endif /* EXPERIMENTAL */
> +#endif /* CIFS_NFSD_EXPORT */
>
> =A0 =A0 =A0 =A0return 0;
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index f191244..371d021 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -123,9 +123,9 @@ extern ssize_t =A0 =A0 =A0cifs_getxattr(struct de=
ntry *, const char *, void *, size_t);
> =A0extern ssize_t cifs_listxattr(struct dentry *, char *, size_t);
> =A0extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsig=
ned long arg);
>
> -#ifdef CONFIG_CIFS_EXPERIMENTAL
> +#ifdef CIFS_NFSD_EXPORT
> =A0extern const struct export_operations cifs_export_ops;
> -#endif /* EXPERIMENTAL */
> +#endif /* CIFS_NFSD_EXPORT */
>
> =A0#define CIFS_VERSION =A0 "1.71"
> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* _CIFSFS_=
H */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 4b0ac27..7a454fb 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -541,10 +541,6 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSe=
sInfo *ses)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->secType =3D RawNTLMSSP;
> =A0 =A0 =A0 =A0else if (secFlags & CIFSSEC_MAY_LANMAN)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->secType =3D LANMAN;
> -/* #ifdef CONFIG_CIFS_EXPERIMENTAL
> - =A0 =A0 =A0 else if (secFlags & CIFSSEC_MAY_PLNTXT)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->secType =3D ??
> -#endif */
> =A0 =A0 =A0 =A0else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EOPNOTSUPP;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Invalid security type");
> diff --git a/fs/cifs/export.c b/fs/cifs/export.c
> index 993f820..55d87ac 100644
> --- a/fs/cifs/export.c
> +++ b/fs/cifs/export.c
> @@ -45,7 +45,7 @@
> =A0#include "cifs_debug.h"
> =A0#include "cifsfs.h"
>
> -#ifdef CONFIG_CIFS_EXPERIMENTAL
> +#ifdef CIFS_NFSD_EXPORT
> =A0static struct dentry *cifs_get_parent(struct dentry *dentry)
> =A0{
> =A0 =A0 =A0 =A0/* BB need to add code here eventually to enable expor=
t via NFSD */
> @@ -63,5 +63,5 @@ const struct export_operations cifs_export_ops =3D =
{
> =A0 =A0 =A0 =A0.encode_fs =3D =A0*/
> =A0};
>
> -#endif /* EXPERIMENTAL */
> +#endif /* CIFS_NFSD_EXPORT */
>
> --
> 1.6.0.2
>
>



--=20
Thanks,

Steve
