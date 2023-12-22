Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB90528E1B
	for <linux-cifs@vger.kernel.org>; Fri, 22 Dec 2023 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Z527a1PD"
Message-ID: <bff6b825419a977d32cd82f03ab6521e@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1703267936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UhBQfDp1cNeGoYxScQ8XSaeeRAAHZUPp9FUpJ2n1StE=;
	b=Z527a1PDExOclg+E4gXoGgiVxlQaSGJiWAWvKajcIdYen1a7U+gf4Z/gOTd5ahpGe113P1
	Aw1sFB7WIF3pqzpVuaARADFiNKovCfPz77KirR9mIpwNenwt3HA1+GxcIiR8y2CNf8fwEU
	ti7KkF6bweHNaiZCA5qZSET9NlFL3fNEQ8sCeyPQGeAwykzZv1LFqppNk3BkfrJSqKhKtq
	7UHA5mjrZ2i5ua165THr06dtUay3hBiXKlrC0ZettsTkhQyCQQT8QB5z2QJ+yAwihQAIdb
	aEkjaPwwkarX6xCklcUcwA1YuL9YRchyUOiy6xB9fDE+MsF0vsF93/Ah6FreUw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1703267936; a=rsa-sha256;
	cv=none;
	b=VLh6LWDeODN/BE6/vuCIyAetfLp6X8mAEnqc6gaejcrG7+BnIh/gJrxMBJ5plC7Qz4PyiJ
	3eAih2DGZZSgbzubuREpWV6cPoe4ITeN3pcbKeNLKzX2tmiXsHJ1b9f79zNT+Wk1onzxLV
	7Jj4zWAWABcoZtg62VbUp2FNF6Av0f6o+YbR79lDgHZEykpmEcnCsVUDP6AqxqMqhv6r/a
	CfrSktIz7vJkZ+7Fc8BKE5IKk+Mxeh4zGgyuOFKZ9SZH05v5hWHAsw/x4PPIfEEJTSosVp
	r/3PqNhbB5Ik/Cd3A7oaL19fXzjNllaQklA8xpToMh0gSS5h/L8UlSJKxSh3Aw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1703267936; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UhBQfDp1cNeGoYxScQ8XSaeeRAAHZUPp9FUpJ2n1StE=;
	b=FA92GN8RhDo7+qhLQ8BtFMQ75bbQqFwkm/RlpEPdfTgtXE/8Ym+xWQmTbcvWP8LC7GQ0Do
	LFe4t/VYLFK9JGZY6vu5oqIk+MYbhhuidRNw6CHLHbdPbjpjQZjVex+gkQXNaNlxVTBMRQ
	cOmcMym9E9Rgxd6M0zw1gKRQOmAtmYYI/k/tViyhNR3abf+/hUto6AxYE6IaP16TIMa5XF
	cdCAw6gxX3v0IeE1f6BPNKKiqpz+h02NzulOsI9pSGhlToSGlxHHKotIdR40gV0I9BTQeZ
	Sf+KCTVHyy8pFdtmwS9p8bcr71hs+/OB/o/bMD3SuvXrkzU2YnslXsCyrRxlZg==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>, Xiaoli Feng
 <xifeng@redhat.com>
Subject: Re: [PATCHv2] smb3: allow files to be created with backslash in name
In-Reply-To: <CAH2r5mu+LPjja0TqNaDq6yA3GSy0=uBryMXAd4RTZOWinHOkOA@mail.gmail.com>
References: <CAH2r5mu+LPjja0TqNaDq6yA3GSy0=uBryMXAd4RTZOWinHOkOA@mail.gmail.com>
Date: Fri, 22 Dec 2023 14:58:53 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> Updated patch (rebased to current for-next-next)
>
> Backslash is reserved in Windows (and SMB2/SMB3 by default) but
> allowed in POSIX so must be remapped when POSIX extensions are
> not enabled.
>
> The default mapping for SMB3 mounts ("SFM") allows mapping backslash
> (ie 0x5C in UTF8) to 0xF026 in UCS-2 (using the Unicode remapping
> range reserved for these characters), but this was not mapped by
> cifs.ko (unlike asterisk, greater than, question mark etc).  This patch
> fixes that to allow creating files and directories with backslash
> in the file or directory name.
>
> Before this patch:
>    touch "/mnt2/filewith\slash"
> would return
>    touch: setting times of '/mnt2/filewith\slash': Invalid argument
>
> With the patch touch and mkdir with the backslash in the name works.
>
> This problem was found while debugging xfstest generic/453
>     https://bugzilla.kernel.org/show_bug.cgi?id=210961
>
> Reported-by: Xiaoli Feng <xifeng@redhat.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=210961
> Signed-off-by: Steve French <stfrench@microsoft.com>
>
>
> @Paulo Alcantara  any thoughts if additional changes needed for DFS or
> prefixpaths?

Yes - these changes break DFS mounts with iocharsets different than
utf8.  Consider dfs_cache_canonical_path() where the backslashes will
get remapped in cifs_strndup_to_utf16() and then broken DFS referral
paths will be sent over the wire.

You can simply reproduce this with

        mount.cifs //srv/dfs /mnt -o ...,iocharset=ascii

> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 55b3ce944022..e6f4a28275a8 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1568,10 +1568,7 @@ CIFS_FILE_SB(struct file *file)
>  
>  static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
>  {
> -	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
> -		return '/';
> -	else
> -		return '\\';
> +	return '/';
>  }

This change breakes readdir(2) under SMB1 mounts (no UNIX extensions)
because CIFSFindFirst() ends up appending "/*" rather than "\\*" to
filename and then fails with STATUS_OBJECT_NAME_INVALID.

You'd need to check all other places where we could also append an UTF16
string with CIFS_DIR_SEP() after getting the path with
cifs_convert_path_to_utf16().

> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index 580a27a3a7e6..6c446b1210ba 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -160,12 +160,18 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
>  		     le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength)))
>  		return -ENAMETOOLONG;
>  
> -	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
> -		for (i = 0; i < direntry->d_name.len; i++) {
> -			if (direntry->d_name.name[i] == '\\') {
> -				cifs_dbg(FYI, "Invalid file name\n");
> -				return -EINVAL;
> -			}
> +	/*
> +	 * SMB3.1.1 POSIX Extensions, CIFS Unix Extensions and SFM mappings
> +	 * allow \ in paths (or in latter case remaps \ to 0xF026)
> +	 */
> +	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) ||
> +	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR))

What about

        if (cifs_sb->mnt_cifs_flags & (CIFS_MOUNT_POSIX_PATHS | CIFS_MOUNT_MAP_SFM_CHR))

> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index e20b4354e703..0edc888ec3f8 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -469,13 +469,17 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
>  	if (from[0] == '\\')
>  		start_of_path = from + 1;
>  
> -	/* SMB311 POSIX extensions paths do not include leading slash */
> -	else if (cifs_sb_master_tlink(cifs_sb) &&
> -		 cifs_sb_master_tcon(cifs_sb)->posix_extensions &&
> -		 (from[0] == '/')) {
> -		start_of_path = from + 1;
> -	} else
> -		start_of_path = from;
> +	start_of_path = from;
> +	/*
> +	 * Only old CIFS Unix extensions paths include leading slash
> +	 * Need to skip if for SMB3.1.1 POSIX Extensions and SMB1/2/3
> +	 */
> +	if (from[0] == '/') {
> +		if (((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) == false) ||

I guess you meant "== 0".  Also, no need for extra parentheses.
