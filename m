Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3BE1F5F6;
	Mon,  9 Dec 2024 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767268; cv=none; b=G+v0kDLz3i/T5pr0b87T4HKRBaqTvduh0gWA+0DZ41QWuG1pq1GEQTBsXzqV0xIqTwpVU61SZZ+o6oQvqWn2UO8khUypGymFodOjhqo+VlEYNzZoXA37c9YaYtZ/Cw1l/zv/vT1UQhLSO0CoXGlsP6it+MpzTEpLYJnXs0LyYnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767268; c=relaxed/simple;
	bh=/oT6/Vn+/Z7XCxZA/yvDsc479uxCr0mcH2ho2Iu89sM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRHQeLIzqSoEEOxAkXDK9bbF7azPK9o5zFnO5lff662pUiUhaFohM5EI8z7iR48uob/K7+GkqF6Qaqzx/34TMtX75AZZeQTf71Jj9Ox/VO/DC2WcO3aSslrscjVRU2kmUxBDr1PwxHGyygEJlw4L0OGQ61IRXPtRct+u84WfMk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=geZJqpH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="geZJqpH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82276C4CED1;
	Mon,  9 Dec 2024 18:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733767267;
	bh=/oT6/Vn+/Z7XCxZA/yvDsc479uxCr0mcH2ho2Iu89sM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=geZJqpH2gMI6E95MzdhulA2ZTfmDm504BCs/+wo4mbABnFXJOal2Ovu5Wb5SNVv2Z
	 Mq4XbxiGrGHt6/yvxdF8b2Rs4CYDGSeGvwr/lB3/16LaABxn+wR86nkSO2nSqPXa2L
	 0GDyMVwPqhz55m4PV3yajFooJgaNpszAAkEhb4jIc+rBotXYAXrYOEnXCwFeiFbx5y
	 MtK+Cq+ZBYI9DJH3X4aXjaYNTEOByBXHPlMtnY6EvakxEIpkOcpjhDYRBQ84KhSXkj
	 NBNopyWBgr5HPUMMHjh9GI7blfuZNxOfjAQIOEgCpYYRAmE4WtpSOSbxCiYKepjwnb
	 U1AiXzNwpyLpA==
Received: by pali.im (Postfix)
	id 505D48A0; Mon,  9 Dec 2024 19:00:58 +0100 (CET)
Date: Mon, 9 Dec 2024 19:00:58 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] cifs: Add support for creating NFS-style symlinks
Message-ID: <20241209180058.7w2ytnmgg34xnsci@pali>
References: <20241012085252.560-1-pali@kernel.org>
 <20241012085601.694-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241012085601.694-1-pali@kernel.org>
User-Agent: NeoMutt/20180716

On Saturday 12 October 2024 10:56:01 Pali Rohár wrote:
> CIFS client is currently able to parse NFS-style symlinks, but is not able
> to create them. This functionality is useful when the mounted SMB share is
> used also by Windows NFS server (on Windows Server 2012 or new). It allows
> interop of symlinks between SMB share mounted by Linux CIFS client and same
> export from Windows NFS server mounted by some NFS client.
> 
> New symlinks would be created in NFS-style only in case the mount option
> -o reparse=nfs is specified, which is not by default. So default CIFS
> mounts are not affected by this change.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c | 47 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 39 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 57320a4c4d79..cd12704cae0c 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -406,6 +406,8 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
>  
>  static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
>  			       mode_t mode, dev_t dev,
> +			       __le16 *symname_utf16,
> +			       int symname_utf16_len,
>  			       struct kvec *iov)
>  {
>  	u64 type;
> @@ -416,13 +418,18 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
>  	switch ((type = reparse_mode_nfs_type(mode))) {
>  	case NFS_SPECFILE_BLK:
>  	case NFS_SPECFILE_CHR:
> -		dlen = sizeof(__le64);
> +		dlen = 2 * sizeof(__le32);
> +		((__le32 *)buf->DataBuffer)[0] = MAJOR(dev);
> +		((__le32 *)buf->DataBuffer)[1] = MINOR(dev);
> +		break;
> +	case NFS_SPECFILE_LNK:
> +		dlen = symname_utf16_len;
> +		memcpy(buf->DataBuffer, symname_utf16, symname_utf16_len);
>  		break;
>  	case NFS_SPECFILE_FIFO:
>  	case NFS_SPECFILE_SOCK:
>  		dlen = 0;
>  		break;
> -	case NFS_SPECFILE_LNK: /* TODO: add support for NFS symlinks */
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -432,8 +439,6 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
>  	buf->InodeType = cpu_to_le64(type);
>  	buf->ReparseDataLength = cpu_to_le16(len + dlen -
>  					     sizeof(struct reparse_data_buffer));
> -	*(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MINOR(dev) << 32) |
> -						 MAJOR(dev));
>  	iov->iov_base = buf;
>  	iov->iov_len = len + dlen;
>  	return 0;
> @@ -444,21 +449,42 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
>  		     const char *full_path, umode_t mode, dev_t dev,
>  		     const char *symname)
>  {
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  	struct cifs_open_info_data data;
> -	struct reparse_posix_data *p;
> +	struct reparse_posix_data *p = NULL;
> +	__le16 *symname_utf16 = NULL;
> +	int symname_utf16_len = 0;
>  	struct inode *new;
>  	struct kvec iov;
>  	__u8 buf[sizeof(*p) + sizeof(__le64)];
>  	int rc;
>  
> -	p = (struct reparse_posix_data *)buf;
> -	rc = nfs_set_reparse_buf(p, mode, dev, &iov);
> +	if (S_ISLNK(mode)) {
> +		symname_utf16 = cifs_strndup_to_utf16(symname, strlen(symname),
> +						      &symname_utf16_len,
> +						      cifs_sb->local_nls,
> +						      NO_MAP_UNI_RSVD);
> +		if (!symname_utf16) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +		symname_utf16_len -= 2; /* symlink is without trailing wide-nul */
> +		p = kzalloc(sizeof(*p) + symname_utf16_len, GFP_KERNEL);
> +		if (!p) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +	} else {
> +		p = (struct reparse_posix_data *)buf;
> +	}
> +	rc = nfs_set_reparse_buf(p, mode, dev, symname_utf16, symname_utf16_len, &iov);
>  	if (rc)
> -		return rc;
> +		goto out;
>  
>  	data = (struct cifs_open_info_data) {
>  		.reparse_point = true,
>  		.reparse = { .tag = IO_REPARSE_TAG_NFS, .posix = p, },
> +		.symlink_target = kstrdup(symname, GFP_KERNEL),
>  	};
>  
>  	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
> @@ -468,6 +494,11 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
>  	else
>  		rc = PTR_ERR(new);
>  	cifs_free_open_info(&data);
> +out:
> +	if (S_ISLNK(mode)) {
> +		kfree(symname_utf16);
> +		kfree(p);
> +	}
>  	return rc;
>  }
>  
> -- 
> 2.20.1
> 

This change also needs fixup for big endian systems:

    fixup! cifs: Add support for creating NFS-style symlinks

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index af08e5918adb..c2569347d746 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -419,8 +419,8 @@ static int nfs_set_reparse_buf(struct reparse_nfs_data_buffer *buf,
 	case NFS_SPECFILE_BLK:
 	case NFS_SPECFILE_CHR:
 		dlen = 2 * sizeof(__le32);
-		((__le32 *)buf->DataBuffer)[0] = MAJOR(dev);
-		((__le32 *)buf->DataBuffer)[1] = MINOR(dev);
+		((__le32 *)buf->DataBuffer)[0] = cpu_to_le32(MAJOR(dev));
+		((__le32 *)buf->DataBuffer)[1] = cpu_to_le32(MINOR(dev));
 		break;
 	case NFS_SPECFILE_LNK:
 		dlen = symname_utf16_len;
