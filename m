Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D098B2F5312;
	Tue, 17 Jun 2025 23:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750204086; cv=none; b=MSvql+HNnN0eK/2TLhwbNs4qCZLQg+rcZPDOv0E2z4lbKURrdAUrvVsgDxBHM1ujb9/5ZybOy7kQ+4wfNa6yMqq0Ho9TiAe3FsZnemLLaBWQJGHaT3fL+it6eQDFGGebauua9+HaMxI7TdWARqCEc+sv/esXK4O8y1azPi0Wxnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750204086; c=relaxed/simple;
	bh=V3wtbkwa+H7bbhACrqRl/YZus4Uf844CMah9IS89yz4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=XeUg6ELWzu/jM7MP6K/SaXUPXHpf+1B8iKXabb58Qrq5ctdsbYNmscfrfzzN/TGoLqcilmo027d4c/i3WxPa3dZhEVXHns3SLmGXzKSpAz8MK/HV6QpflKn1TKdP3JSz+e5NoS1+S6z4Wg8cBGu55fmDlrNutSSwR9zMtzF27Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=vkTiAK9q; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="vkTiAK9q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=AKi7IYx1P8pRUnWr8xIoJwlwNbTl8sJlpq8V1u1bLmI=; b=vkTiAK9qAAUbOtfc//Run9Sg33
	YWwTe8y7uky4wEt8tplPnEOMVaaunNdVkghIX0Iv3+9aueMMX08TsNoeeiQO2r6JxfWWFt93WTjtW
	Vjg1qlRmXcUwLfxM08kzgaWLtSAfdtP+/wFT7UNctVfzNwNlAhUySP3bK6ZN10Hmn7AT+jMSsunnI
	X8zJ6icpw63EaEmmL4TA0CNZ/KxQdBsRAuJbAi5SW9N1obkivb1rPQVNh1Gp61tSbkxlU/sde+QiN
	+VXgFanCPGhpG16NxY/BI/FSgNcsPDz6xI0NIBL1ZpNmES+bSKRIjE90+unw6oOxBvCoohxqC49qW
	7P94MpNg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uRg23-00000000BH2-0yv7;
	Tue, 17 Jun 2025 20:48:02 -0300
Message-ID: <6dd60d4365ed96f472c9b59dc8fca6bf@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cifs: Show reason why autodisabling serverino support
In-Reply-To: <20250617230142.ol3rc76uamwsd4rk@pali>
References: <20250610172221.ihsrjrikbiijyb4n@pali>
 <20250610181502.15839-1-pali@kernel.org>
 <470d6baeb8e569aa1587de19c46f43c2@manguebit.org>
 <20250617230142.ol3rc76uamwsd4rk@pali>
Date: Tue, 17 Jun 2025 20:48:00 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Score: 1.1 (+)

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Tuesday 17 June 2025 19:23:15 Paulo Alcantara wrote:
>> Pali Roh=C3=A1r <pali@kernel.org> writes:
>>=20
>> > Extend cifs_autodisable_serverino() function to print also text messag=
e why
>> > the function was called.
>> >
>> > The text message is printed just once for mount then autodisabling
>> > serverino support. Once the serverino support is disabled for mount it=
 will
>> > not be re-enabled. So those text messages do not cause flooding logs.
>> >
>> > This change allows to debug issues why cifs.ko decide to turn off serv=
er
>> > inode number support and hence disable support for detection of hardli=
nks.
>> >
>> > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
>> > ---
>> > Paulo and Tom, could you check if this change is better now for you?
>> > It should address problems with logs flooding and also information abo=
ut
>> > harlinks (it is already printed as can be seen also in this diff).
>> > I would like to get your ACK, so I'm trying to improve it.
>> > ---
>> >  fs/smb/client/cifsproto.h | 2 +-
>> >  fs/smb/client/connect.c   | 2 +-
>> >  fs/smb/client/dfs_cache.c | 2 +-
>> >  fs/smb/client/inode.c     | 6 +++---
>> >  fs/smb/client/misc.c      | 6 +++++-
>> >  fs/smb/client/readdir.c   | 4 ++--
>> >  6 files changed, 13 insertions(+), 9 deletions(-)
>> >
>> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
>> > index d550662b4e72..07a67c8c37ce 100644
>> > --- a/fs/smb/client/cifsproto.h
>> > +++ b/fs/smb/client/cifsproto.h
>> > @@ -586,9 +586,9 @@ extern int cifs_do_set_acl(const unsigned int xid,=
 struct cifs_tcon *tcon,
>> >  			   const struct nls_table *nls_codepage, int remap);
>> >  extern int CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *t=
con,
>> >  			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
>> >  #endif /* CIFS_ALLOW_INSECURE_LEGACY */
>> > -extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
>> > +extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb, =
const char *reason, int rc);
>> >  extern bool couldbe_mf_symlink(const struct cifs_fattr *fattr);
>> >  extern int check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>> >  			      struct cifs_sb_info *cifs_sb,
>> >  			      struct cifs_fattr *fattr,
>> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>> > index 6bf04d9a5491..819721dfd5bb 100644
>> > --- a/fs/smb/client/connect.c
>> > +++ b/fs/smb/client/connect.c
>> > @@ -3907,9 +3907,9 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, str=
uct smb3_fs_context *ctx)
>> >  	/*
>> >  	 * After reconnecting to a different server, unique ids won't match =
anymore, so we disable
>> >  	 * serverino. This prevents dentry revalidation to think the dentry =
are stale (ESTALE).
>> >  	 */
>> > -	cifs_autodisable_serverino(cifs_sb);
>> > +	cifs_autodisable_serverino(cifs_sb, "Reconnecting to different serve=
r, inode numbers won't match anymore", 0);
>>=20
>> We are mounting an DFS share, not reconnecting.  The message is
>> misleading.
>
> I mostly copied the comment above the cifs_autodisable_serverino() call.
> Does it mean that the existing comment about reconnecting is wrong too?

The comment is trying to say why it disabled 'serverino'.  DFS failover
may potentially connect to a different server and share, hence the inode
numbers will no longer be valid.  The function is also called
cifs_mount().

>> >  	/*
>> >  	 * Force the use of prefix path to support failover on DFS paths tha=
t resolve to targets
>> >  	 * that have different prefix paths.
>> >  	 */
>> > diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
>> > index 4dada26d56b5..c3fe85c31e2b 100644
>> > --- a/fs/smb/client/dfs_cache.c
>> > +++ b/fs/smb/client/dfs_cache.c
>> > @@ -1288,9 +1288,9 @@ int dfs_cache_remount_fs(struct cifs_sb_info *ci=
fs_sb)
>> >  	/*
>> >  	 * After reconnecting to a different server, unique ids won't match =
anymore, so we disable
>> >  	 * serverino. This prevents dentry revalidation to think the dentry =
are stale (ESTALE).
>> >  	 */
>> > -	cifs_autodisable_serverino(cifs_sb);
>> > +	cifs_autodisable_serverino(cifs_sb, "Reconnecting to different serve=
r, inode numbers won't match anymore", 0);
>>=20
>> Ditto.
>>=20
>> >  	/*
>> >  	 * Force the use of prefix path to support failover on DFS paths tha=
t resolve to targets
>> >  	 * that have different prefix paths.
>> >  	 */
>> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
>> > index cd06598eacbd..b1c6e3986278 100644
>> > --- a/fs/smb/client/inode.c
>> > +++ b/fs/smb/client/inode.c
>> > @@ -1076,9 +1076,9 @@ static void cifs_set_fattr_ino(int xid, struct c=
ifs_tcon *tcon, struct super_blo
>> >  		if (*inode)
>> >  			fattr->cf_uniqueid =3D CIFS_I(*inode)->uniqueid;
>> >  		else {
>> >  			fattr->cf_uniqueid =3D iunique(sb, ROOT_I);
>> > -			cifs_autodisable_serverino(cifs_sb);
>> > +			cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inode number =
via get_srv_inum", rc);
>>=20
>> Looks good.
>>=20
>> >  		}
>> >  		return;
>> >  	}
>> >=20=20
>> > @@ -1529,9 +1529,9 @@ cifs_iget(struct super_block *sb, struct cifs_fa=
ttr *fattr)
>> >  		if (fattr->cf_flags & CIFS_FATTR_INO_COLLISION) {
>> >  			fattr->cf_flags &=3D ~CIFS_FATTR_INO_COLLISION;
>> >=20=20
>> >  			if (inode_has_hashed_dentries(inode)) {
>> > -				cifs_autodisable_serverino(CIFS_SB(sb));
>> > +				cifs_autodisable_serverino(CIFS_SB(sb), "Inode number collision d=
etected", 0);
>>=20
>> Looks good.
>>=20
>> >  				iput(inode);
>> >  				fattr->cf_uniqueid =3D iunique(sb, ROOT_I);
>> >  				goto retry_iget5_locked;
>> >  			}
>> > @@ -1596,9 +1596,9 @@ struct inode *cifs_root_iget(struct super_block =
*sb)
>> >  iget_root:
>> >  	if (!rc) {
>> >  		if (fattr.cf_flags & CIFS_FATTR_JUNCTION) {
>> >  			fattr.cf_flags &=3D ~CIFS_FATTR_JUNCTION;
>> > -			cifs_autodisable_serverino(cifs_sb);
>> > +			cifs_autodisable_serverino(cifs_sb, "Cannot retrieve attributes fo=
r junction point", rc);
>>=20
>> This has nothing to do with not being able to retrieve attributes.  It
>> is simply disabling 'serverino' to prevent inode collisions with
>> surrogate reparse points (automounts).  This should also printed with
>> FYI.
>
> Ok. So then I misunderstood the code around. Do you know when exactly
> can this case happen? And it is really a problem? Because name surrogate
> reparse point already creates a new mount hierarchy for which is
> generated new st_dev major and minor numbers and hence inode collisions
> should not happen (they do not share st_dev anymore).

There was a bug report of someone having inode collisions in a share
that had a reparse mount point, so the server was returning duplicate
inode numbers for files inside that share.  That is why we set those
directories as automounts and then disable 'serverino' only for them, so
the parent mount can still rely on the inode numbers from the server and
having hardlinks working.

Note that disabling 'serverino' means that the client won't trust the
inode numbers from the server and it will generate its own inode
numbers.  I don't understand why st_dev is relevant here.

>
>> >  		}
>> >  		inode =3D cifs_iget(sb, &fattr);
>> >  	}
>> >=20=20
>> > diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
>> > index e77017f47084..409277883e8a 100644
>> > --- a/fs/smb/client/misc.c
>> > +++ b/fs/smb/client/misc.c
>> > @@ -551,9 +551,9 @@ dump_smb(void *buf, int smb_buf_length)
>> >  		       smb_buf_length, true);
>> >  }
>> >=20=20
>> >  void
>> > -cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
>> > +cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb, const char *=
reason, int rc)
>> >  {
>> >  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
>> >  		struct cifs_tcon *tcon =3D NULL;
>> >=20=20
>> > @@ -561,8 +561,12 @@ cifs_autodisable_serverino(struct cifs_sb_info *c=
ifs_sb)
>> >  			tcon =3D cifs_sb_master_tcon(cifs_sb);
>> >=20=20
>> >  		cifs_sb->mnt_cifs_flags &=3D ~CIFS_MOUNT_SERVER_INUM;
>> >  		cifs_sb->mnt_cifs_serverino_autodisabled =3D true;
>> > +		if (rc)
>> > +			cifs_dbg(VFS, "%s: %d\n", reason, rc);
>> > +		else
>> > +			cifs_dbg(VFS, "%s\n", reason);
>> >  		cifs_dbg(VFS, "Autodisabling the use of server inode numbers on %s\=
n",
>> >  			 tcon ? tcon->tree_name : "new server");
>> >  		cifs_dbg(VFS, "The server doesn't seem to support them properly or =
the files might be on different servers (DFS)\n");
>> >  		cifs_dbg(VFS, "Hardlinks will not be recognized on this mount. Cons=
ider mounting with the \"noserverino\" option to silence this message.\n");
>> > diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
>> > index 787d6bcb5d1d..06e90921f751 100644
>> > --- a/fs/smb/client/readdir.c
>> > +++ b/fs/smb/client/readdir.c
>> > @@ -412,9 +412,9 @@ _initiate_cifs_search(const unsigned int xid, stru=
ct file *file,
>> >  	if (rc =3D=3D 0) {
>> >  		cifsFile->invalidHandle =3D false;
>> >  	} else if ((rc =3D=3D -EOPNOTSUPP) &&
>> >  		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
>> > -		cifs_autodisable_serverino(cifs_sb);
>> > +		cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inode number v=
ia query_dir_first", rc);
>>=20
>> Looks good.
>>=20
>> >  		goto ffirst_retry;
>> >  	}
>> >  error_exit:
>> >  	cifs_put_tlink(tlink);
>> > @@ -1006,9 +1006,9 @@ static int cifs_filldir(char *find_entry, struct=
 file *file,
>> >  	if (de.ino && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
>> >  		fattr.cf_uniqueid =3D de.ino;
>> >  	} else {
>> >  		fattr.cf_uniqueid =3D iunique(sb, ROOT_I);
>> > -		cifs_autodisable_serverino(cifs_sb);
>> > +		cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inode number",=
 0);
>>=20
>> Perhaps also mention which function it wasn't able to retrieve inode
>> number from like above?
>
> I quickly look at this code around and I was not able to figure out what
> is that function which was not able to retrieve inode. So I did not
> write it into the message. Do you know, or could you figure out what is
> that function / callback?

"Cannot retrieve inode number from readdir"
