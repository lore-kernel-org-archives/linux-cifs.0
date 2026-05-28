Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAF9314D16;
	Thu, 28 May 2026 23:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780012376; cv=none; b=AL8FolDOpQRRWRrXxKn3eDxKINFayN7NPUewwSptPIWzqFf+EFC+v6dyRv6eIVLJ8Uohgv+ubErW8bs4JiMW5XndqTPjcjcScSo8bT8mDeCB4UIxj0uXPU4PqhdzrimFvjNH6tZ5VlkbebqPuOF6H+ZTAmwf1p1dZkh/UdsryGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780012376; c=relaxed/simple;
	bh=qC5qazG0zM2Hd5AmcJ/v2BDNhMyxZlf2TwrmXvdBwtw=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=WZlWqpLTdxZ0JDduA0Mbc0I6sa2ryZRPwiDTOKqI+2ckFl/2CqCz/zvoCb1AAsBhc0NvyOPObiK4XVdvHY5fG7hJF/qjb1Tz2HExjD4Wa7kRsrLfMIUkOugXyyT4ye6NgZeqX7yETDwWhE7q9Ydumb0DMDZFyBuQKy6t+H33i/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=EGt26DIC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=V+MI91rW; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="EGt26DIC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="V+MI91rW"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 22B01EC0B0C;
	Thu, 28 May 2026 19:52:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 28 May 2026 19:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm3; t=
	1780012374; x=1780098774; bh=o6HRlH41qrJnmA8KMMLP9mQ48o2GvdI92B0
	iGK1Bgzg=; b=EGt26DICfyAgwp6rvPXCDOAphrkVkR1eA9Whz3+HtH5miMlHCEA
	GTkTS+yD0iVBnvVfsQDRhW3QCPR3vDnEbC4zvUbY0MstpOSZKfURFNJ737gLuPHo
	c/e90rxUS1qxifN4UmarllZlMMYDokp8In+/PY/t6ZELwX2hT7Y2ISWHKAlywtXv
	72DQ7DF3I6QDEu/7hitvKkB3sxoPoFrh+0zobx4XgdWAaxHVbbsanwYwS4I6KdPM
	4XZMonHJ2X2TSPt5Qia0nAqWBwiTGPqvAH75LqcA71oJmysGnh4AqgPEqOqqTLZf
	GlfLfWT0Hklo/EY2yxIpJ6pi5Ai4wP7qM2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1780012374; x=
	1780098774; bh=o6HRlH41qrJnmA8KMMLP9mQ48o2GvdI92B0iGK1Bgzg=; b=V
	+MI91rW6HEjhFeWUm5d6h5yxYC/l4oaDMQrzjazmh4j9BKV2XSOas7RWh/ELEP4g
	eyB/Xk2K//LaE63Bq3ehRY+dB3kyvT0T5jzY6mhJXTNSqwRWQ2NY2LzSKb/srcrj
	ipRhxho0Hfk4CAUJj4vJoMJf6d7yh3cp0K/BXPzi+ErhoQPTrHRi0oPiZV0HH0k0
	lHtz5ml4+UOwvSHeHLHxObNApTrd85XRT6NCYe+6twPBVR371bqVM8OC34Q02zWh
	ZfmTobp3XnMwJArO7FaSMOlq+FYc3eHH8q0hl1nkY9zy1+hZdx7mn/4fImpCo2b4
	1iRwXI6B23o0Az/ZGzyyQ==
X-ME-Sender: <xms:VdUYauh3P3zBl4PtMfsHo8nSOz-BCl7s7i5REnKAVyFC3D4sle873A>
    <xme:VdUYamlNMv3MmaT4ksmtUDKkZ_ooBUyzE8WaDWDckVFf5LdPeCjNpJk5is2N7AcGT
    VoW701bTLU2zP36rbkcP8BeUGQ_eca987EQpCs-_U3Ug4J6tg>
X-ME-Received: <xmr:VdUYaltWboX6NncEnOTADvBqccIxU2tWuVXn1ePCu9ZXcV20r0KcVWI2x4bxxS-sV8c_-hitf3kHymWRw3OhQwBBNsKy_xE>
X-ME-Proxy-Cause: dmFkZTFeU2/JeiVPNszIG1vltKHnJyy4KXsrb/o+h8eYjKPHnkJ8RW3j/X78p4nkHBwLJJ
    2NPHKju6Xx/wWU06Wk8bgnIF6GO0TxnWLg3Wht6jF/pEr8cSJvLR5v+RltmrtMYruzS3ZW
    giPjyCX7Mp3SiQ20Qw2HHHL3uNIBLSIFfEAl4iwnypvMvrs7kASRVFgjoz8kW8vcnce/6+
    msx90aagrypvbAcWfLFl25ZIXo1TqKS/hscBt/mEn/EasQQdKTw7lLQ1Yb567R/lH1CWyf
    FPLx09KIe6BK7X265to+PghGSS5uS5aRQ/mvu13oIHmPT6ZwDXYGxAgXNT2IonUpxBcRlg
    RMv402MLiB//R192/YYwDc3Hr2zWlJyODw3ljZcRcmunWy1N8tCf4eErsE+Fg7kw9ohTe3
    j254RLQmd/XEeJCbGyOUpRP3zsyQI/vlUeRZ9k8bhUVCfVjEutS3mcEGXIfD7WOy0VQqT2
    PhZYjQ783BS6mBMJVBeFnSEXGrw26X3Z/ESYLTILHgP2bx6C3FWfUtdYyDtl1Nfdiqacrz
    4UfjxnIeyjcHKAjrk6Syxgrmb3am84Riuv7nfkknBQ3UT7oBbsRpAK5CY3/BOnQLUGbbzc
    P97GVuW8y3YBjViVoZWMUfbyNLks7KMvYKyKKspv/FvCwDZUeKpsr9Uc+Cbw
X-ME-Proxy: <xmx:VdUYakDmJysZ5D3UPExSKQf2q3eMvpUK5Lgb2jSG4LOfCny96C02Dw>
    <xmx:VdUYaiURLBA49xFX45uMOfi1iJWhzX30GIdlg7XCLeBwf-yLwZgENA>
    <xmx:VdUYatHIzD0Kcl8ypH-tXuHq3WaCMN3C-DPsB_NWxggMwxo4O_ufIw>
    <xmx:VdUYatNiRSG2073CaPhafa46SBvX4ha2ThjnfST8u9ToQwjAGsdvoQ>
    <xmx:VtUYajBKtPx-zonFj_BkATRYPIQVsIIGT_O5fqJccK3hvvCmqdrsJKE8>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 May 2026 19:52:49 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Jori Koolstra" <jkoolstra@xs4all.nl>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Steve French" <smfrench@gmail.com>,
 "Sergey Senozhatsky" <senozhatsky@chromium.org>,
 "Tom Talpey" <tom@talpey.com>, "Jori Koolstra" <jkoolstra@xs4all.nl>,
 "Jeff Layton" <jlayton@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>,
 "Chuck Lever" <chuck.lever@oracle.com>, "Mateusz Guzik" <mjguzik@gmail.com>,
 "open list:FILESYSTEMS VFS and infrastructure"
 <linux-fsdevel@vger.kernel.org>, "open list" <linux-kernel@vger.kernel.org>,
 "open list:KERNEL SMB3 SERVER KSMBD" <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 1/2] vfs: make LAST_XXX private to fs/namei.c
In-reply-to: <20260528175854.57626-1-jkoolstra@xs4all.nl>
References: <20260528175854.57626-1-jkoolstra@xs4all.nl>
Date: Fri, 29 May 2026 09:52:47 +1000
Message-id: <178001236747.3379282.13063881105469290031@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Fri, 29 May 2026, Jori Koolstra wrote:
> The only user of LAST_XXX outside of fs/namei.c is fs/smb/server/vfs.c;
> ksmbd_vfs_path_lookup() calls vfs_path_parent_lookup() and expects a
> LAST_NORM last type (or it will be ENOENT). ksmbd_vfs_rename() also calls
> vfs_path_parent_lookup() but forgets the LAST_NORM check.

Are you certain that it "forgets" the LAST_NORM check?
I suspect you are - rename needs a name to change.  But it
often helps to explain an assertion like this.

I would be good to enhance the kernel-doc for vfs_path_parent_lookup()
to make it clear that the path must end with a name component (not /, .,
or ..).

But even without that it is a good cleanup.=20

Reviewed-by: NeilBrown <neil@brown.name>

Thanks,
NeilBrown


>=20
> It does not really make sense to have vfs_path_parent_lookup() expose
> the last_type because it is only needed to ensure it is LAST_NORM. So
> let's do this check in vfs_path_parent_lookup() instead and keep the
> LAST_XXX internal to fs/namei.c. This changes the ENOENT errno in
> ksmbd_vfs_path_lookup() to EINVAL, which matches better with how this is
> handled by callers of filename_parentat().
>=20
> Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
> ---
>  fs/namei.c            | 20 ++++++++++++++++----
>  fs/smb/server/vfs.c   | 15 +++------------
>  include/linux/namei.h |  7 +------
>  3 files changed, 20 insertions(+), 22 deletions(-)
>=20
> diff --git a/fs/namei.c b/fs/namei.c
> index c7fac83c9a85..889792761bc2 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -129,6 +129,11 @@
>  static struct kmem_cache *__names_cache __ro_after_init;
>  #define names_cache	runtime_const_ptr(__names_cache)
> =20
> +/*
> + * Type of the last component on LOOKUP_PARENT
> + */
> +enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
> +
>  void __init filename_init(void)
>  {
>  	__names_cache =3D kmem_cache_create_usercopy("names_cache", sizeof(struct=
 filename), 0,
> @@ -3051,15 +3056,22 @@ EXPORT_SYMBOL(kern_path);
>   * @flags: lookup flags
>   * @parent: pointer to struct path to fill
>   * @last: last component
> - * @type: type of the last component
>   * @root: pointer to struct path of the base directory
>   */
>  int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
> -			   struct path *parent, struct qstr *last, int *type,
> +			   struct path *parent, struct qstr *last,
>  			   const struct path *root)
>  {
> -	return  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
> -				    type, root);
> +	int type;
> +	int err =3D  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
> +				       &type, root);
> +	if (err)
> +		return err;
> +	if (unlikely(type !=3D LAST_NORM)) {
> +		path_put(parent);
> +		return -EINVAL;
> +	}
> +	return 0;
>  }
>  EXPORT_SYMBOL(vfs_path_parent_lookup);
> =20
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index d08973b288e5..cd1dbca0cffb 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -19,7 +19,6 @@
>  #include <linux/vmalloc.h>
>  #include <linux/sched/xacct.h>
>  #include <linux/crc32c.h>
> -#include <linux/namei.h>
>  #include <linux/splice.h>
> =20
>  #include "glob.h"
> @@ -56,7 +55,7 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_confi=
g *share_conf,
>  {
>  	struct qstr last;
>  	const struct path *root_share_path =3D &share_conf->vfs_path;
> -	int err, type;
> +	int err;
>  	struct dentry *d;
> =20
>  	if (pathname[0] =3D=3D '\0') {
> @@ -67,17 +66,11 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_con=
fig *share_conf,
>  	}
> =20
>  	CLASS(filename_kernel, filename)(pathname);
> -	err =3D vfs_path_parent_lookup(filename, flags,
> -				     path, &last, &type,
> +	err =3D vfs_path_parent_lookup(filename, flags, path, &last,
>  				     root_share_path);
>  	if (err)
>  		return err;
> =20
> -	if (unlikely(type !=3D LAST_NORM)) {
> -		path_put(path);
> -		return -ENOENT;
> -	}
> -
>  	if (for_remove) {
>  		err =3D mnt_want_write(path->mnt);
>  		if (err) {
> @@ -668,7 +661,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const str=
uct path *old_path,
>  	struct renamedata rd;
>  	struct ksmbd_share_config *share_conf =3D work->tcon->share_conf;
>  	struct ksmbd_file *parent_fp;
> -	int new_type;
>  	int err, lookup_flags =3D LOOKUP_NO_SYMLINKS;
> =20
>  	if (ksmbd_override_fsids(work))
> @@ -678,8 +670,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const str=
uct path *old_path,
> =20
>  retry:
>  	err =3D vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
> -				     &new_path, &new_last, &new_type,
> -				     &share_conf->vfs_path);
> +				     &new_path, &new_last, &share_conf->vfs_path);
>  	if (err)
>  		goto out1;
> =20
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index 2ad6dd9987b9..3941b9f1dec7 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -13,11 +13,6 @@ enum { MAX_NESTED_LINKS =3D 8 };
> =20
>  #define MAXSYMLINKS 40
> =20
> -/*
> - * Type of the last component on LOOKUP_PARENT
> - */
> -enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
> -
>  /* pathwalk mode */
>  #define LOOKUP_FOLLOW		BIT(0)	/* follow links at the end */
>  #define LOOKUP_DIRECTORY	BIT(1)	/* require a directory */
> @@ -67,7 +62,7 @@ static inline void end_removing_path(const struct path *p=
ath , struct dentry *de
>  	end_creating_path(path, dentry);
>  }
>  int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
> -			   struct path *parent, struct qstr *last, int *type,
> +			   struct path *parent, struct qstr *last,
>  			   const struct path *root);
>  int vfs_path_lookup(struct dentry *, struct vfsmount *, const char *,
>  		    unsigned int, struct path *);
> --=20
> 2.54.0
>=20
>=20

