Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCAC1F0991;
	Sun, 31 Aug 2025 09:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756633519; cv=none; b=u6BD9CK1C9Obb/tL1wxUSOKgrJRYfpFZAlG19eD6yLRaWvH1qokdnwbddWVaBmijrs27a6jqZBcYiWKeUdsZQQBj0gs92m0BwCmzZZaJnSag+0FlJiIdZKYBUWiIoXq9W5/xPVNj3o28mryodKPGpFfVP2Jph09+bVogPXfgNxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756633519; c=relaxed/simple;
	bh=4VVFmENiYBUivpweg8GOf87JTJTyxcrBvFGfKykbZVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2e7LMp16n2bVxpMjuVTZDwtc26HB5jnb7NKoQAZSTvepTpJcXdJlsmuOHZ0QYSsu9oDx3ZL/NS43NfAvj7cLmfLQqRfoVGaO0dwo5s6rwswuuiAEhuY0t3L63eAy9kh+mR04f41UKYCEjfW8uR6vZgbHOr4YMgivwQOO5hssbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvVi/DfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvVi/DfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D204EC4CEED;
	Sun, 31 Aug 2025 09:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756633519;
	bh=4VVFmENiYBUivpweg8GOf87JTJTyxcrBvFGfKykbZVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XvVi/DfSfs0RIAxyFzRj/lM6Sc1mK8Eob/upPedvt2wJeMUcwd8FXWgiuhOnmTMAP
	 c6D2Wu34G5ttsKGWDu2rZ/xgSPMV4kJB5xEFtSXdpoLoAK642ppNsp5f+MZcIh9cve
	 rudDgO4cYMycjZ4KI2Q+SaLrynxLxmsH6SxW2PjIjPBfZxSHJT0plmrd4u8U0tbLSA
	 b0zG/fizoLk1CgXdyNWwd07A98q1YjSoRz5Rug0pKybgnLrT52WPUbLJlnfGbmTIgg
	 fHp1nXF7IcrqMgnRa6GBs+Ih7cTIQeITEldBd/1Ou3C7uScO1Qyl9A1NbGHPGK9WRK
	 VtRKt+DNd9whg==
Received: by pali.im (Postfix)
	id A4093598; Sun, 31 Aug 2025 11:45:16 +0200 (CEST)
Date: Sun, 31 Aug 2025 11:45:16 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cifs: Add support for parsing WSL symlinks in
 version 1 format
Message-ID: <20250831094516.b57kufonqfgbchc7@pali>
References: <20250712161418.17696-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250712161418.17696-1-pali@kernel.org>
User-Agent: NeoMutt/20180716

Hello, have you looked at this change?

On Saturday 12 July 2025 18:14:17 Pali Rohár wrote:
> MS-FSCC 2.1.2.7 for IO_REPARSE_TAG_LX_SYMLINK reparse points currently
> documents only layout version 2 format.
> 
> IO_REPARSE_TAG_LX_SYMLINK reparse point buffer of layout version 1 format
> is documented in the newly released Microsoft WSL source code at github:
> https://github.com/microsoft/WSL/blob/2.5.8/test/windows/DrvFsTests.cpp#L775-L815
> 
> Difference between version 1 and version 2 is that version 1 stores the
> symlink target location into data section of the file, but version 2 stores
> it directly into the reparse point buffer.
> 
> This change implements support for parsing WSL symlinks in this layout
> version 1 format by Linux SMB client and so allow to recognize these type
> of symlinks like Windows WSL.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/cifsproto.h |  5 ++-
>  fs/smb/client/inode.c     |  1 +
>  fs/smb/client/reparse.c   | 94 ++++++++++++++++++++++++++++++++++-----
>  fs/smb/common/smb2pdu.h   |  5 ++-
>  4 files changed, 92 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index e449b33d9bdc..ec70f52ff002 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -669,7 +669,10 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix);
>  char *extract_hostname(const char *unc);
>  char *extract_sharename(const char *unc);
>  int parse_reparse_point(struct reparse_data_buffer *buf,
> -			u32 plen, struct cifs_sb_info *cifs_sb,
> +			u32 plen,
> +			unsigned int xid,
> +			struct cifs_tcon *tcon,
> +			struct cifs_sb_info *cifs_sb,
>  			const char *full_path,
>  			struct cifs_open_info_data *data);
>  int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 762cd194946a..d32fc0dd6d1c 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1170,6 +1170,7 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
>  
>  			reparse_buf = server->ops->get_reparse_point_buffer(iov, &reparse_len);
>  			rc = parse_reparse_point(reparse_buf, reparse_len,
> +						 xid, tcon,
>  						 cifs_sb, full_path, data);
>  			/*
>  			 * If the reparse point was not handled but it is the
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 74a36957e8cb..51e476cd4bc9 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -1067,36 +1067,104 @@ static int parse_reparse_native_symlink(struct reparse_symlink_data_buffer *sym,
>  }
>  
>  static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf,
> +				     unsigned int xid,
> +				     struct cifs_tcon *tcon,
>  				     struct cifs_sb_info *cifs_sb,
> +				     const char *full_path,
>  				     struct cifs_open_info_data *data)
>  {
>  	int len = le16_to_cpu(buf->ReparseDataLength);
>  	int data_offset = offsetof(typeof(*buf), Target) - offsetof(typeof(*buf), Version);
> -	int symname_utf8_len;
> +	bool free_symname_utf8 = false;
> +	struct cifs_open_parms oparms;
> +	struct cifs_io_parms io_parms;
> +	unsigned int symname_utf8_len;
> +	char *symname_utf8 = NULL;
>  	__le16 *symname_utf16;
>  	int symname_utf16_len;
> +	struct cifs_fid fid;
> +	__u32 oplock;
> +	int buf_type;
>  	int rc = 0;
>  
> -	if (len <= data_offset) {
> +	if (len < data_offset) {
>  		cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\n");
>  		rc = -EIO;
>  		goto out;
>  	}
>  
> -	/* MS-FSCC 2.1.2.7 defines layout of the Target field only for Version 2. */
> -	if (le32_to_cpu(buf->Version) != 2) {
> +	switch (le32_to_cpu(buf->Version)) {
> +	case 1:
> +		/*
> +		 * Layout version 1 stores the symlink target in the data section of
> +		 * the file encoded in UTF-8 without trailing null-term byte.
> +		 */
> +
> +		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_DATA,
> +				     FILE_OPEN, CREATE_NOT_DIR | OPEN_REPARSE_POINT,
> +				     ACL_NO_MODE);
> +		oparms.fid = &fid;
> +		oplock = tcon->ses->server->oplocks ? REQ_OPLOCK : 0;
> +		rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
> +		if (rc)
> +			goto out;
> +
> +		free_symname_utf8 = true;
> +		symname_utf8_len = le64_to_cpu(data->fi.EndOfFile);
> +		symname_utf8 = kmalloc(symname_utf8_len, GFP_KERNEL);
> +		if (!symname_utf8) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +
> +		buf_type = CIFS_NO_BUFFER;
> +		io_parms = (struct cifs_io_parms) {
> +			.netfid = fid.netfid,
> +			.pid = current->tgid,
> +			.tcon = tcon,
> +			.offset = 0,
> +			.length = symname_utf8_len,
> +		};
> +		rc = tcon->ses->server->ops->sync_read(xid, &fid, &io_parms,
> +						       &symname_utf8_len,
> +						       &symname_utf8,
> +						       &buf_type);
> +		if (!rc && symname_utf8_len != le64_to_cpu(data->fi.EndOfFile))
> +			rc = -EIO;
> +
> +		tcon->ses->server->ops->close(xid, tcon, &fid);
> +
> +		if (rc) {
> +			cifs_dbg(VFS, "cannot read wsl symlink target location: %d\n", rc);
> +			goto out;
> +		}
> +
> +		break;
> +	case 2:
> +		/*
> +		 * Layout version 2 stores the symlink target in the reparse buffer
> +		 * field Target encoded in UTF-8 without trailing null-term byte.
> +		 */
> +		symname_utf8_len = len - data_offset;
> +		symname_utf8 = buf->Target;
> +		break;
> +	default:
>  		cifs_dbg(VFS, "srv returned unsupported wsl symlink version %u\n", le32_to_cpu(buf->Version));
>  		rc = -EIO;
>  		goto out;
>  	}
>  
> -	/* Target for Version 2 is in UTF-8 but without trailing null-term byte */
> -	symname_utf8_len = len - data_offset;
> +	if (symname_utf8_len == 0) {
> +		cifs_dbg(VFS, "srv returned empty wsl symlink target location\n");
> +		rc = -EIO;
> +		goto out;
> +	}
> +
>  	/*
>  	 * Check that buffer does not contain null byte
>  	 * because Linux cannot process symlink with null byte.
>  	 */
> -	if (strnlen(buf->Target, symname_utf8_len) != symname_utf8_len) {
> +	if (strnlen(symname_utf8, symname_utf8_len) != symname_utf8_len) {
>  		cifs_dbg(VFS, "srv returned null byte in wsl symlink target location\n");
>  		rc = -EIO;
>  		goto out;
> @@ -1106,7 +1174,7 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
>  		rc = -ENOMEM;
>  		goto out;
>  	}
> -	symname_utf16_len = utf8s_to_utf16s(buf->Target, symname_utf8_len,
> +	symname_utf16_len = utf8s_to_utf16s(symname_utf8, symname_utf8_len,
>  					    UTF16_LITTLE_ENDIAN,
>  					    (wchar_t *) symname_utf16, symname_utf8_len * 2);
>  	if (symname_utf16_len < 0) {
> @@ -1126,6 +1194,9 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
>  	}
>  
>  out:
> +	if (free_symname_utf8)
> +		kfree(symname_utf8);
> +
>  	/*
>  	* Convert -EIO to 0. This let lstat() success and
>  	* empty data->symlink_target triggers readlink() to fail with -EIO.
> @@ -1137,7 +1208,10 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
>  }
>  
>  int parse_reparse_point(struct reparse_data_buffer *buf,
> -			u32 plen, struct cifs_sb_info *cifs_sb,
> +			u32 plen,
> +			unsigned int xid,
> +			struct cifs_tcon *tcon,
> +			struct cifs_sb_info *cifs_sb,
>  			const char *full_path,
>  			struct cifs_open_info_data *data)
>  {
> @@ -1155,7 +1229,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
>  	case IO_REPARSE_TAG_LX_SYMLINK:
>  		return parse_reparse_wsl_symlink(
>  			(struct reparse_wsl_symlink_data_buffer *)buf,
> -			cifs_sb, data);
> +			xid, tcon, cifs_sb, full_path, data);
>  	case IO_REPARSE_TAG_AF_UNIX:
>  	case IO_REPARSE_TAG_LX_FIFO:
>  	case IO_REPARSE_TAG_LX_CHR:
> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> index f79a5165a7cc..32438f4904b3 100644
> --- a/fs/smb/common/smb2pdu.h
> +++ b/fs/smb/common/smb2pdu.h
> @@ -1567,12 +1567,13 @@ struct reparse_nfs_data_buffer {
>  	__u8	DataBuffer[];
>  } __packed;
>  
> -/* For IO_REPARSE_TAG_LX_SYMLINK - see MS-FSCC 2.1.2.7 */
> +/* For IO_REPARSE_TAG_LX_SYMLINK - see MS-FSCC 2.1.2.7 and
> + * https://github.com/microsoft/WSL/blob/2.5.8/test/windows/DrvFsTests.cpp#L775-L815 */
>  struct reparse_wsl_symlink_data_buffer {
>  	__le32	ReparseTag;
>  	__le16	ReparseDataLength;
>  	__u16	Reserved;
> -	__le32	Version; /* Always 2 */
> +	__le32	Version; /* 1 - stores symlink path in file data section; 2 - stores symlink path in Target[] field */
>  	__u8	Target[]; /* Variable Length UTF-8 string without nul-term */
>  } __packed;
>  
> -- 
> 2.20.1
> 
