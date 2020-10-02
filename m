Return-Path: <SRS0=klGs=DJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C12C4363C
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Oct 2020 15:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98EED206DC
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Oct 2020 15:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RlNx2u17"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388169AbgJBP3p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Oct 2020 11:29:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:59706 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387984AbgJBP3p (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 2 Oct 2020 11:29:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601652583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zd2gf63+FWfeaFpRDh6SBUsDJu6Igw3jjc9dxr+BEK8=;
        b=RlNx2u17DPBsHfytbK/KqruknFe1ARKP4MquLzO0O3TAbrDawVF/FeXGd3ilKzvUoXJnk7
        5HXB6OtvwWC8qPj0h1l+rrX7nomVGRl2sZWD3VoPpM86ssSpWvlmJUIFGiLhzNFDI8y90l
        qG76o0AmkwdLubMk38RQwHxW7h+qakQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F3E1AAD46;
        Fri,  2 Oct 2020 15:29:42 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 3/3] cifs: cache the directory content for shroot
In-Reply-To: <20201001205026.8808-4-lsahlber@redhat.com>
References: <20201001205026.8808-1-lsahlber@redhat.com>
 <20201001205026.8808-4-lsahlber@redhat.com>
Date:   Fri, 02 Oct 2020 17:29:42 +0200
Message-ID: <87sgawir2x.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,

The more we isolate code with clear opaque interfaces, the less we have
to understand about their low-level implementation.

I was thinking we could move all dir cache related code to a new dcache.c
file or something like that.

One question: when does the cache gets cleared? We dont want to have the
same stale content every time we query the root. Should it be time based?

Comments on code below:

Ronnie Sahlberg <lsahlber@redhat.com> writes:
>  fs/cifs/cifsglob.h |  21 +++++++
>  fs/cifs/misc.c     |   2 +
>  fs/cifs/readdir.c  | 173 +++++++++++++++++++++++++++++++++++++++++++++++=
+++---
>  fs/cifs/smb2ops.c  |  14 +++++
>  4 files changed, 203 insertions(+), 7 deletions(-)


>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index b565d83ba89e..e8f2b4a642d4 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1073,6 +1073,26 @@ cap_unix(struct cifs_ses *ses)
>  	return ses->server->vals->cap_unix & ses->capabilities;
>  }
>=20=20
> +struct cached_dirent {
> +	struct list_head entry;
> +	char *name;
> +	int namelen;
> +	loff_t pos;
> +	u64 ino;
> +	unsigned type;
> +};
> +
> +struct cached_dirents {
> +	bool is_valid:1;
> +	bool is_failed:1;
> +	struct dir_context *ctx; /* Only used to make sure we only take entries
> +				  * from a single context. Never dereferenced.
> +				  */

This type of comments are not in the kernel coding style. First comment
line with "/*" shouldnt have text.

> +	struct mutex de_mutex;
> +	int pos;		 /* Expected ctx->pos */
> +	struct list_head entries;
> +};
> +
>  struct cached_fid {
>  	bool is_valid:1;	/* Do we have a useable root fid */
>  	bool file_all_info_is_valid:1;
> @@ -1083,6 +1103,7 @@ struct cached_fid {
>  	struct cifs_tcon *tcon;
>  	struct work_struct lease_break;
>  	struct smb2_file_all_info file_all_info;
> +	struct cached_dirents dirents;
>  };

>  	}
> +	INIT_LIST_HEAD(&ret_buf->crfid.dirents.entries);
> +	mutex_init(&ret_buf->crfid.dirents.de_mutex);
>=20=20
>  	atomic_inc(&tconInfoAllocCount);
>  	ret_buf->tidStatus =3D CifsNew;
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 31a18aae5e64..17861c3d2e08 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -811,9 +811,119 @@ find_cifs_entry(const unsigned int xid, struct cifs=
_tcon *tcon, loff_t pos,
>  	return rc;
>  }
>=20=20
> +static void init_cached_dirents(struct cached_dirents *cde,
> +				struct dir_context *ctx)
> +{
> +	if (ctx->pos =3D=3D 2 && cde->ctx =3D=3D NULL) {
> +		cde->ctx =3D ctx;
> +		cde->pos =3D 2;
> +	}
> +}

2 is for "." and ".."? Can you add more comments to document this?

Can you document which functions are expecting to be called with a lock
held?

> +
> +static bool emit_cached_dirents(struct cached_dirents *cde,
> +				struct dir_context *ctx)
> +{
> +	struct list_head *tmp;
> +	struct cached_dirent *dirent;
> +	int rc;
> +
> +	list_for_each(tmp, &cde->entries) {
> +		dirent =3D list_entry(tmp, struct cached_dirent, entry);
> +		if (ctx->pos >=3D dirent->pos)
> +			continue;
> +		ctx->pos =3D dirent->pos;
> +		rc =3D dir_emit(ctx, dirent->name, dirent->namelen,
> +			      dirent->ino, dirent->type);
> +		if (!rc)
> +			return rc;
> +	}
> +	return true;
> +}
> +
> +static void update_cached_dirents_count(struct cached_dirents *cde,
> +					struct dir_context *ctx)
> +{
> +	if (cde->ctx !=3D ctx)
> +		return;
> +	if (cde->is_valid || cde->is_failed)
> +		return;
> +
> +	cde->pos++;
> +}
> +
> +static void finished_cached_dirents_count(struct cached_dirents *cde,
> +					struct dir_context *ctx)
> +{
> +	if (cde->ctx !=3D ctx)
> +		return;
> +	if (cde->is_valid || cde->is_failed)
> +		return;
> +	if (ctx->pos !=3D cde->pos)
> +		return;
> +
> +	cde->is_valid =3D 1;
> +}
> +
> +static void add_cached_dirent(struct cached_dirents *cde,
> +			      struct dir_context *ctx,
> +			      const char *name, int namelen,
> +			      u64 ino, unsigned type)
> +{
> +	struct cached_dirent *de;
> +
> +	if (cde->ctx !=3D ctx)
> +		return;
> +	if (cde->is_valid || cde->is_failed)
> +		return;
> +	if (ctx->pos !=3D cde->pos) {
> +		cde->is_failed =3D 1;
> +		return;
> +	}
> +	de =3D kzalloc(sizeof(*de), GFP_ATOMIC);
> +	if (de =3D=3D NULL) {
> +		cde->is_failed =3D 1;
> +		return;
> +	}
> +	de->name =3D kzalloc(namelen, GFP_ATOMIC);
> +	if (de->name =3D=3D NULL) {
> +		kfree(de);
> +		cde->is_failed =3D 1;
> +		return;
> +	}
> +	memcpy(de->name, name, namelen);
> +	de->namelen =3D namelen;
> +	de->pos =3D ctx->pos;
> +	de->ino =3D ino;
> +	de->type =3D type;
> +
> +	list_add_tail(&de->entry, &cde->entries);
> +}
> +
> +static bool cifs_dir_emit(struct dir_context *ctx,
> +			  const char *name, int namelen,
> +			  u64 ino, unsigned type,
> +			  struct cached_fid *cfid)
> +{
> +	bool rc;
> +
> +	rc =3D dir_emit(ctx, name, namelen, ino, type);
> +	if (!rc)
> +		return rc;
> +
> +	if (cfid) {
> +		mutex_lock(&cfid->dirents.de_mutex);
> +		add_cached_dirent(&cfid->dirents, ctx, name, namelen, ino,
> +				  type);
> +		mutex_unlock(&cfid->dirents.de_mutex);
> +	}
> +
> +	return rc;
> +}
> +
>  static int cifs_filldir(char *find_entry, struct file *file,
> -		struct dir_context *ctx,
> -		char *scratch_buf, unsigned int max_len)
> +			struct dir_context *ctx,
> +			char *scratch_buf, unsigned int max_len,
> +			struct cached_fid *cfid)
>  {
>  	struct cifsFileInfo *file_info =3D file->private_data;
>  	struct super_block *sb =3D file_inode(file)->i_sb;
> @@ -903,10 +1013,10 @@ static int cifs_filldir(char *find_entry, struct f=
ile *file,
>  	cifs_prime_dcache(file_dentry(file), &name, &fattr);
>=20=20
>  	ino =3D cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
> -	return !dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype);
> +	return !cifs_dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype,
> +			      cfid);
>  }
>=20=20
> -
>  int cifs_readdir(struct file *file, struct dir_context *ctx)
>  {
>  	int rc =3D 0;
> @@ -920,6 +1030,8 @@ int cifs_readdir(struct file *file, struct dir_conte=
xt *ctx)
>  	char *end_of_smb;
>  	unsigned int max_len;
>  	char *full_path =3D NULL;
> +	struct cached_fid *cfid =3D NULL;
> +	struct cifs_sb_info *cifs_sb =3D CIFS_FILE_SB(file);
>=20=20
>  	xid =3D get_xid();
>=20=20
> @@ -928,7 +1040,6 @@ int cifs_readdir(struct file *file, struct dir_conte=
xt *ctx)
>  		rc =3D -ENOMEM;
>  		goto rddir2_exit;
>  	}
> -
>  	/*
>  	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
>  	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
> @@ -949,6 +1060,31 @@ int cifs_readdir(struct file *file, struct dir_cont=
ext *ctx)
>  		if after then keep searching till find it */
>=20=20
>  	cifsFile =3D file->private_data;
> +	tcon =3D tlink_tcon(cifsFile->tlink);
> +	if (tcon->ses->server->vals->header_preamble_size =3D=3D 0 &&

header_preamble_size =3D=3D 0 is a test for smb1? we have is_smb1_server()

> +		!strcmp(full_path, "")) {
> +		rc =3D open_shroot(xid, tcon, cifs_sb, &cfid);
> +		if (rc)
> +			goto cache_not_found;
> +
> +		mutex_lock(&cfid->dirents.de_mutex);
> +		/* if this was reading from the start of the directory
> +		 * we might need to initialize scanning and storing the
> +		 * directory content.
> +		 */
> +		init_cached_dirents(&cfid->dirents, ctx);
> +		/* If we already have the entire directory cached then
> +		 * we cna just serve the cache.
> +		 */

comment style

> +		if (cfid->dirents.is_valid) {
> +			emit_cached_dirents(&cfid->dirents, ctx);
> +			mutex_unlock(&cfid->dirents.de_mutex);
> +			goto rddir2_exit;
> +		}
> +		mutex_unlock(&cfid->dirents.de_mutex);
> +	}
> + cache_not_found:
> +
>  	if (cifsFile->srch_inf.endOfSearch) {
>  		if (cifsFile->srch_inf.emptyDir) {
>  			cifs_dbg(FYI, "End of search, empty dir\n");
> @@ -960,15 +1096,30 @@ int cifs_readdir(struct file *file, struct dir_con=
text *ctx)
>  		tcon->ses->server->close(xid, tcon, &cifsFile->fid);
>  	} */
>=20=20
> -	tcon =3D tlink_tcon(cifsFile->tlink);
> +	/* Drop the cache while calling find_cifs_entry in case there will
> +	 * be reconnects during query_directory.
> +	 */

comment style

> +	if (cfid) {
> +		close_shroot(cfid);
> +		cfid =3D NULL;
> +	}
>  	rc =3D find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
>  			     &current_entry, &num_to_fill);
> +	if (tcon->ses->server->vals->header_preamble_size =3D=3D 0 &&
> +		!strcmp(full_path, "")) {
> +		open_shroot(xid, tcon, cifs_sb, &cfid);
> +	}
>  	if (rc) {
>  		cifs_dbg(FYI, "fce error %d\n", rc);
>  		goto rddir2_exit;
>  	} else if (current_entry !=3D NULL) {
>  		cifs_dbg(FYI, "entry %lld found\n", ctx->pos);
>  	} else {
> +		if (cfid) {
> +			mutex_lock(&cfid->dirents.de_mutex);
> +			finished_cached_dirents_count(&cfid->dirents, ctx);
> +			mutex_unlock(&cfid->dirents.de_mutex);
> +		}
>  		cifs_dbg(FYI, "Could not find entry\n");
>  		goto rddir2_exit;
>  	}
> @@ -998,7 +1149,7 @@ int cifs_readdir(struct file *file, struct dir_conte=
xt *ctx)
>  		 */
>  		*tmp_buf =3D 0;
>  		rc =3D cifs_filldir(current_entry, file, ctx,
> -				  tmp_buf, max_len);
> +				  tmp_buf, max_len, cfid);
>  		if (rc) {
>  			if (rc > 0)
>  				rc =3D 0;
> @@ -1006,6 +1157,12 @@ int cifs_readdir(struct file *file, struct dir_con=
text *ctx)
>  		}
>=20=20
>  		ctx->pos++;
> +		if (cfid) {
> +			mutex_lock(&cfid->dirents.de_mutex);
> +			update_cached_dirents_count(&cfid->dirents, ctx);
> +			mutex_unlock(&cfid->dirents.de_mutex);
> +		}
> +
>  		if (ctx->pos =3D=3D
>  			cifsFile->srch_inf.index_of_last_entry) {
>  			cifs_dbg(FYI, "last entry in buf at pos %lld %s\n",
> @@ -1020,6 +1177,8 @@ int cifs_readdir(struct file *file, struct dir_cont=
ext *ctx)
>  	kfree(tmp_buf);
>=20=20
>  rddir2_exit:
> +	if (cfid)
> +		close_shroot(cfid);
>  	kfree(full_path);
>  	free_xid(xid);
>  	return rc;
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index fd6c136066df..280464e21a5f 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -605,6 +605,8 @@ smb2_close_cached_fid(struct kref *ref)
>  {
>  	struct cached_fid *cfid =3D container_of(ref, struct cached_fid,
>  					       refcount);
> +	struct list_head *pos, *q;
> +	struct cached_dirent *dirent;
>=20=20
>  	if (cfid->is_valid) {
>  		cifs_dbg(FYI, "clear cached root file handle\n");
> @@ -613,6 +615,18 @@ smb2_close_cached_fid(struct kref *ref)
>  		cfid->is_valid =3D false;
>  		cfid->file_all_info_is_valid =3D false;
>  		cfid->has_lease =3D false;
> +		mutex_lock(&cfid->dirents.de_mutex);
> +		list_for_each_safe(pos, q, &cfid->dirents.entries) {
> +			dirent =3D list_entry(pos, struct cached_dirent, entry);
> +			list_del(pos);
> +			kfree(dirent->name);
> +			kfree(dirent);
> +		}
> +		cfid->dirents.is_valid =3D 0;
> +		cfid->dirents.is_failed =3D 0;
> +		cfid->dirents.ctx =3D NULL;
> +		cfid->dirents.pos =3D 0;
> +		mutex_unlock(&cfid->dirents.de_mutex);
>  	}
>  }


Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
