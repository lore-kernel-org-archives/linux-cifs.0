Return-Path: <SRS0=bDWC=DO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5A0C4363D
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Oct 2020 12:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B94206D9
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Oct 2020 12:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BRzrpiUj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgJGMVo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Oct 2020 08:21:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:38750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgJGMVo (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 7 Oct 2020 08:21:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602073303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6zxoIqWpwie/Kgg0D/Thz9Sv8wollP1erwCjwjWsQik=;
        b=BRzrpiUjYbzrMriAEkx3cZSBAXwlt8Cvax1gCMklWdom6t9R+Q81/39eC7P8DI72PPAzVH
        eD3z1WQO2/ktuYDom2jVQrpCoixYnMgFeqGdXnlaI/AA4hGzGYQ/xVxC5cZ9657Og8h9U+
        0pJHdbiGNsdv1yeWTpYqExnGlkqFfrI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 66AC0ABBE;
        Wed,  7 Oct 2020 12:21:43 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 3/3] cifs: cache the directory content for shroot
In-Reply-To: <20201005211622.18097-1-lsahlber@redhat.com>
References: <20201005211622.18097-1-lsahlber@redhat.com>
Date:   Wed, 07 Oct 2020 14:21:42 +0200
Message-ID: <878scii5ux.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,

I'm assuming this is the latest V4:

Can you document which functions require a lock to be held when calling?

Would it work properly if in any of the patched functions we have this scen=
ario:

TASK A                              DEMULTIPLEX THREAD
------                              ------------------
open_shroot()=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
...                                    oplock break on shroot
                                       ...close/reopen shroot, fid and ptr =
gets updated...
...=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
do stuff with dirents (with old fid/ptr?)
...
close_shroot()

More comments below:

Ronnie Sahlberg <lsahlber@redhat.com> writes:
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

Should return cfid->dirents.is_failed?

> -
>  int cifs_readdir(struct file *file, struct dir_context *ctx)
>  {
>  	int rc =3D 0;
>  	unsigned int xid;
>  	int i;
> -	struct cifs_tcon *tcon;
> +	struct cifs_tcon *tcon, *mtcon;
>  	struct cifsFileInfo *cifsFile =3D NULL;
>  	char *current_entry;
>  	int num_to_fill =3D 0;
> @@ -920,15 +1021,59 @@ int cifs_readdir(struct file *file, struct dir_con=
text *ctx)
>  	char *end_of_smb;
>  	unsigned int max_len;
>  	char *full_path =3D NULL;
> +	struct cached_fid *cfid =3D NULL;
> +	struct cifs_sb_info *cifs_sb =3D CIFS_FILE_SB(file);
>=20=20
>  	xid =3D get_xid();
> -
>  	full_path =3D build_path_from_dentry(file_dentry(file));
>  	if (full_path =3D=3D NULL) {
>  		rc =3D -ENOMEM;
>  		goto rddir2_exit;
>  	}
>=20=20
> +	mtcon =3D cifs_sb_master_tcon(cifs_sb);

Why using the master tcon? The rest of the code is using the user
tcon.


> +	if (!is_smb1_server(mtcon->ses->server) && !strcmp(full_path, "")) {
> +		rc =3D open_shroot(xid, mtcon, cifs_sb, &cfid);
> +		if (rc)
> +			goto cache_not_found;
> +
> +		mutex_lock(&cfid->dirents.de_mutex);
> +		/*
> +		 * If this was reading from the start of the directory
> +		 * we need to initialize scanning and storing the
> +		 * directory content.
> +		 */
> +		if (ctx->pos =3D=3D 0 && cfid->dirents.ctx =3D=3D NULL) {
> +			cfid->dirents.ctx =3D ctx;
> +			cfid->dirents.pos =3D 2;
> +		}
> +		/*
> +		 * If we already have the entire directory cached then
> +		 * we can just serve the cache.
> +		 */
> +		if (cfid->dirents.is_valid) {
> +			if (!dir_emit_dots(file, ctx)){
> +				mutex_unlock(&cfid->dirents.de_mutex);
> +				goto rddir2_exit;
> +			}
> +			emit_cached_dirents(&cfid->dirents, ctx);
> +			mutex_unlock(&cfid->dirents.de_mutex);
> +			goto rddir2_exit;
> +		}
> +		mutex_unlock(&cfid->dirents.de_mutex);
> +	}
> + cache_not_found:
> +
> +	/* Drop the cache while calling initiate_cifs_search and
> +	 * find_cifs_entry in case there will be reconnects during
> +	 * query_directory.
> +	 */

comment style

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
