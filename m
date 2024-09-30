Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869581922F5;
	Mon, 30 Sep 2024 15:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727709000; cv=pass; b=rlVQ0ocd91JFG2TzuD/JiyxlDwQX9pG6CMbOCQchXBSrbGjCb/NiupupCT+JULGZIKfydbdsmZIUb/+CtUvrsXsDwtrhrKYiOq7WSA3Box7FtbVS+fturb44dMn8vvqbhWe+lHjLo9B0KZBWv5lptQf8TKy2eregluN1HXCCsHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727709000; c=relaxed/simple;
	bh=czuI3rcHCTtULeBUbn9GDnQbQnMGC1CyU8MT21kUJus=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=JVluNfT2SG6AFqZH1kRYTitedYtKlvxwcyRNuSbXtaQO0lP4dS+sc4d9pm6jvP1STpF/4kNa2HiI6/EBNlhKeNRLmTUWaDXbOasVffIsniqEQPF+XYXFguWus2YysGY+W55tE+cC4K117urkRTIdZHkSsnNt+XweWS6QPLrp8xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=ZyHoUu3X; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ZyHoUu3X"
Message-ID: <76a3103261ea1be01a83acec8c0db2d4@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1727708991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmJR9P5BxNmpWt5xKfda4Fa6z6Vae67DaPuvzZ+YV9o=;
	b=ZyHoUu3XwE9UMIed+poYJ22i6jEF/E+xDhOafElbrM17G2FXqPejaq+iXrujzNFe3gTQ7V
	elNeZt+4QXDJVzlu74ORmwNxOX7uzy45H7aMKy2/eXElgWXAkUHBU88qt4WbdTq8WHQdwq
	slkizO7e0TSe0paAxc5vndEzAEL0wzamzZklGNHaru7HbV0ZyupPrtR3xFSxnReJVOvUP3
	nhdHsMiaASBtS59EkjAUKXPjRmnu4XLX13JCvldWLAIxFY78B6/16tLpAYr4pJcXCcQPaB
	iF0Ld09ysZYRa/BNfxB55K3Zwj/lanagyPNX2IEtXnXJoFZ9uU31M7WuXYPUMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1727708991; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmJR9P5BxNmpWt5xKfda4Fa6z6Vae67DaPuvzZ+YV9o=;
	b=dQWKLNTDG7o1Tb55H0D1qHdd5RpeexVag0bHTjQqo5cIqCnwLiGNFkCL4MQG/4YngZrCmR
	BIiZ6MBnJ4Qlni18KIlpE0cf7SCUiA+ij7MgZ2hF3nkExJPxVep44jT6FetNrNI3rnWhav
	JgTsSbZPu/7oMJAGd3aH3y1KdoAVs0W//dYED1T74L/UDpPDo1dTFCQ12BPQ3RiTiH7HAu
	vive94Ni/RvArLiYsIduoQ75PzlxFhdQkapsPen4M+LvbM7ddvg7nspsAUKXcfyRDnniHl
	/JbnjtMzW6VZ7QJeRjexH8OTZoWGakLCBLsc3czUTpJ4isFQMOZwZhJjg219hA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1727708991; a=rsa-sha256;
	cv=none;
	b=V4jFQBJRjhEz8LCh/tLMnrmB9uNQPTzgWM7jQWvUyVl25tyNZNbFe2g+hui/oTVlR4vbys
	GrJQBRg0e/s9e9Z3bc0RwFKftWdjaPmHRlGVZ7K+fUtJtvCVUtensGPb3u05P36EvuoI8B
	5dNZdr5HnAnzYWciO7rINTUGsaDqlJ7PL/7RaxJhq89W5RnHi/WEIvW1kcRJArY+yvSMkG
	4sTocYYmgDNEzVIkuIUwRWgKcgjBz1R3jHLSk/WXFdfLMm84Ivhy5pPKV7XGP1lsZNp+8M
	w8UHf6W/NFWpnC+JHsgUrMroqoPV1GtaWCTWR7I26VvZ46J3kIcsnv2khg3n/A==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Steve French
 <sfrench@samba.org>, Ronnie
 Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] cifs: Improve creating native symlinks pointing to
 directory
In-Reply-To: <20240929185053.10554-3-pali@kernel.org>
References: <20240929185053.10554-1-pali@kernel.org>
 <20240929185053.10554-3-pali@kernel.org>
Date: Mon, 30 Sep 2024 12:09:48 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> SMB protocol for native symlinks distinguish between symlink to directory
> and symlink to file. These two symlink types cannot be exchanged, which
> means that symlink of file type pointing to directory cannot be resolved =
at
> all (and vice-versa).
>
> Windows follows this rule for local filesystems (NTFS) and also for SMB.
>
> Linux SMB client currenly creates all native symlinks of file type. Which
> means that Windows (and some other SMB clients) cannot resolve symlinks
> pointing to directory created by Linux SMB client.
>
> As Linux system does not distinguish between directory and file symlinks,
> its API does not provide enough information for Linux SMB client during
> creating of native symlinks.
>
> Add some heuristic into the Linux SMB client for choosing the correct
> symlink type during symlink creation. Check if the symlink target location
> ends with slash, or last path component is dot or dot dot, and check if t=
he
> target location on SMB share exists and is a directory. If at least one
> condition is truth then create a new SMB symlink of directory type.
> Otherwise create it as file type symlink.
>
> This change improves interoperability with Windows systems. Windows syste=
ms
> would be able to resolve more SMB symlinks created by Linux SMB client
> which points to existing directory.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c   | 131 ++++++++++++++++++++++++++++++++++++--
>  fs/smb/client/smb2inode.c |   3 +-
>  fs/smb/client/smb2proto.h |   1 +
>  3 files changed, 130 insertions(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 507e17244ed3..9390ab801696 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -24,13 +24,16 @@ int smb2_create_reparse_symlink(const unsigned int xi=
d, struct inode *inode,
>  	struct inode *new;
>  	struct kvec iov;
>  	__le16 *path;
> +	bool directory =3D false;
>  	char *sym, sep =3D CIFS_DIR_SEP(cifs_sb);
>  	u16 len, plen;
>  	int rc =3D 0;
>=20=20
> -	sym =3D kstrdup(symname, GFP_KERNEL);
> +	len =3D strlen(symname)+1;
> +	sym =3D kzalloc(len+1, GFP_KERNEL); /* +1 for possible directory slash =
*/
>  	if (!sym)
>  		return -ENOMEM;
> +	memcpy(sym, symname, len);
>=20=20
>  	data =3D (struct cifs_open_info_data) {
>  		.reparse_point =3D true,
> @@ -45,6 +48,125 @@ int smb2_create_reparse_symlink(const unsigned int xi=
d, struct inode *inode,
>  		goto out;
>  	}
>=20=20
> +	/*
> +	 * SMB distinguish between symlink to directory and symlink to file.
> +	 * They cannot be exchanged (symlink of file type which points to
> +	 * directory cannot be resolved and vice-versa). First do some simple
> +	 * check, if the original Linux symlink target ends with slash, or
> +	 * last path component is dot or dot dot then it is for sure symlink
> +	 * to the directory.
> +	 */
> +	if (!directory) {
> +		const char *basename =3D kbasename(symname);
> +		int basename_len =3D strlen(basename);
> +		if (basename_len =3D=3D 0 || /* symname ends with slash */
> +		    (basename_len =3D=3D 1 && basename[0] =3D=3D '.') || /* last compo=
nent is "." */
> +		    (basename_len =3D=3D 2 && basename[0] =3D=3D '.' && basename[1] =
=3D=3D '.')) /* last component is ".." */
> +			directory =3D true;
> +	}
> +
> +	/*
> +	 * If it was not detected as directory yet and the symlink is relative
> +	 * then try to resolve the path on the SMB server, check if the path
> +	 * exists and determinate if it is a directory or not.
> +	 */
> +	if (!directory && symname[0] !=3D '/') {
> +		__u32 oplock;
> +		struct tcon_link *tlink;
> +		struct cifs_tcon *tcon;
> +		struct cifs_fid fid;
> +		struct cifs_open_parms oparms;
> +		char *resolved_path;
> +		char *path_sep;
> +		int open_rc;
> +		int full_path_len =3D strlen(full_path);
> +		int symname_len =3D strlen(symname);
> +
> +		tlink =3D cifs_sb_tlink(cifs_sb);
> +		if (IS_ERR(tlink)) {
> +			rc =3D PTR_ERR(tlink);
> +			goto out;
> +		}
> +
> +		resolved_path =3D kzalloc(full_path_len + symname_len + 1, GFP_KERNEL);
> +		if (!resolved_path) {
> +			rc =3D -ENOMEM;
> +			goto out;
> +		}

If !@resolved_path, then you will end up leaking @tlink.

> +
> +		/*
> +		 * Compose the resolved SMB symlink path from the SMB full path
> +		 * and Linux target symlink path.
> +		 */
> +		memcpy(resolved_path, full_path, full_path_len+1);
> +		path_sep =3D strrchr(resolved_path, sep);
> +		if (path_sep)
> +			path_sep++;
> +		else
> +			path_sep =3D resolved_path;
> +		memcpy(path_sep, symname, symname_len+1);
> +		if (sep =3D=3D '\\')
> +			convert_delimiter(path_sep, sep);
> +
> +		tcon =3D tlink_tcon(tlink);
> +
> +		oparms =3D (struct cifs_open_parms) {
> +			.tcon =3D tcon,
> +			.cifs_sb =3D cifs_sb,
> +			.desired_access =3D FILE_READ_ATTRIBUTES,
> +			.disposition =3D FILE_OPEN,
> +			.path =3D resolved_path,
> +			.fid =3D &fid,
> +		};

Please use CIFS_OPARMS().

> +
> +		/* Try to open as NOT_FILE */
> +		oplock =3D 0;
> +		oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_FILE=
);
> +		open_rc =3D tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
> +		if (open_rc =3D=3D 0) {
> +			/* Successful open means that the target path is definitely a directo=
ry. */
> +			directory =3D true;
> +			tcon->ses->server->ops->close(xid, tcon, &fid);
> +		} else if (open_rc !=3D -ENOTDIR) {
> +			/* Try to open as NOT_DIR */
> +			oplock =3D 0;
> +			oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR=
);
> +			open_rc =3D tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
> +			if (open_rc =3D=3D 0) {
> +				tcon->ses->server->ops->close(xid, tcon, &fid);
> +			} else if (open_rc =3D=3D -EISDIR) {
> +				/* -EISDIR means that the target path is definitely a directory. */
> +				directory =3D true;
> +			} else {
> +				cifs_dbg(FYI,
> +					 "%s: cannot determinate if the symlink target path '%s' "
> +					 "is directory or not, creating '%s' as file symlink\n",
> +					 __func__, symname, full_path);
> +			}
> +		}
> +
> +		kfree(resolved_path);
> +		cifs_put_tlink(tlink);
> +	}
> +
> +	/*
> +	 * For absolute symlinks it is not possible to determinate
> +	 * if it should point to directory or file.
> +	 */
> +	if (!directory && symname[0] =3D=3D '/')
> +		cifs_dbg(FYI,
> +			 "%s: cannot determinate if the symlink target path '%s' "
> +			 "is directory or not, creating '%s' as file symlink\n",
> +			 __func__, symname, full_path);
> +

Create a helper with all of this and then call it in
smb2_create_reparse_symlink() to determine whether symlink target is a
directory or file.
