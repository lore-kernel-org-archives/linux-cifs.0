Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6522D274B46;
	Tue, 13 Oct 2026 08:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791881251; cv=none; b=BeAP5ruF2vFs3GCZz5PpT7fF7ilC+J+GMgtBu+k0et75uNbLOncrFlLnIbII6Sf4cf9i3ZU4U0AW6SxC/C1xkqLmfaT4UeYxu6yD+MEfwrLd+0uwxAlohUlgBHNlYvrupUZj3jTunGB9IM9oN+5ON+84dBFrxI+l4YHMuourxsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791881251; c=relaxed/simple;
	bh=L6OWFspRKJLxpUf6i7t4p7fTPApz6UBhiCJkvkj09bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WK0cCvhQ5WTY0vlotb2PdWEplH4D93YRivbIx4KUtsOtx7U9G88numYYUwsL/OhP5orInhXJHdZDJqI5jssp0Q/s3A32Ip04VY+DoqxjQhqpL6mTERgzVyxcmSXgrasD5JjzFn4MtlLIz6tEaIEoUI5pKvZNBO9Qw12vXpJbfRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTbq4RtK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTbq4RtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF6C1F000FF;
	Tue, 13 Oct 2026 08:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791881250;
	bh=5J+TDdB61jyzAhsIsbEgjO7KGpnGc9F+JSCzxz101VE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QTbq4RtKj3yoBjkCBAjrPSgAUdYfPEHeRgXVcqEPA6KEWCGEXgHPY30v7NurdI3sL
	 e3I4tlBR999grxq+ky2Pvs/pIZEXKX/zjtaF5GyYt6cfCcrUaHXQ4Bp8+y2X5ip52k
	 KyTn5W2epJuHaW8L/tGmP7mYh3/mn8Yb6AbAifkQQunppXim+sd76LrJPidx1ljBIj
	 tIAdg2H/nXKS0DZgzxxAeeBrEiyyTHomx1RbY6hhD4OFrbfQeLPLsK7KF9DuD8xT3p
	 swmhM6Wo2Xgo7QP0g/rkEaF5OE8bo1+57+WP9mXdVYmzBAOOKPnThyQIhd5VfNUqFf
	 0JB071+gQEFjw==
Received: by pali.im (Postfix)
	id 07376365; Tue, 13 Oct 2026 10:47:32 +0200 (CEST)
Date: Tue, 13 Oct 2026 10:47:32 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] cifs: Add support for parsing WSL symlinks in
 version 1 format
Message-ID: <20261013084732.po2kddv7vshutuz3@pali>
References: <20260821214722.q7rkflclyyugdxll@pali>
 <20260825230622.24617-1-pali@kernel.org>
 <20260825230622.24617-9-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260825230622.24617-9-pali@kernel.org>
User-Agent: NeoMutt/20180716

On Wednesday 26 August 2026 01:06:21 Pali Rohár wrote:
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
>  fs/smb/client/cifsproto.h |   1 +
>  fs/smb/client/inode.c     |   1 +
>  fs/smb/client/reparse.c   | 123 ++++++++++++++++++++++++++++++++------
>  fs/smb/common/fscc.h      |   5 +-
>  4 files changed, 110 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 00168839c123..1202934d7b94 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -390,6 +390,7 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix);
>  char *extract_hostname(const char *unc);
>  char *extract_sharename(const char *unc);
>  int parse_reparse_point(struct reparse_data_buffer *buf, u32 plen,
> +			unsigned int xid, struct cifs_tcon *tcon,
>  			struct cifs_sb_info *cifs_sb, const char *full_path,
>  			struct cifs_open_info_data *data);
>  int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 4ccfc83f7d3b..8d0282599876 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1175,6 +1175,7 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
>  
>  			reparse_buf = server->ops->get_reparse_point_buffer(iov, &reparse_len);
>  			rc = parse_reparse_point(reparse_buf, reparse_len,
> +						 xid, tcon,
>  						 cifs_sb, full_path, data);
>  			/*
>  			 * If the reparse point was not handled but it is the
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 4dd81e40e947..bed6f764c0bc 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -1060,51 +1060,129 @@ static int parse_reparse_native_symlink(struct reparse_symlink_data_buffer *sym,
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
> +	u64 file_size;
> +	__u32 oplock;
> +	int buf_type;
> +	int rc = 0;
>  
> -	if (len <= data_offset) {
> +	if (len < data_offset) {
>  		cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\n");
> -		return smb_EIO2(smb_eio_trace_reparse_wsl_symbuf,
> +		rc = smb_EIO2(smb_eio_trace_reparse_wsl_symbuf,
>  				len, data_offset);
> +		goto out;
>  	}
>  
> -	/* MS-FSCC 2.1.2.7 defines layout of the Target field only for Version 2. */
>  	u32 version = le32_to_cpu(buf->Version);
> +	switch (version) {
> +	case 1:
> +		/*
> +		 * Layout version 1 stores the symlink target in the data section of
> +		 * the file encoded in UTF-8 without trailing null-term byte.
> +		 */
> +
> +		file_size = data->contains_posix_file_info ?
> +			le64_to_cpu(data->posix_fi.EndOfFile) :
> +			le64_to_cpu(data->fi.EndOfFile);
> +
> +		free_symname_utf8 = true;
> +		symname_utf8_len = file_size;
> +		symname_utf8 = kmalloc(symname_utf8_len, GFP_KERNEL);
> +		if (!symname_utf8) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
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
> +		if (!rc && symname_utf8_len != file_size)
> +			rc = -EIO;
>  
> -	if (version != 2) {
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
>  		cifs_dbg(VFS, "srv returned unsupported wsl symlink version %u\n", version);
>  		return smb_EIO1(smb_eio_trace_reparse_wsl_ver, version);
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
> -	size_t ulen = strnlen(buf->Target, symname_utf8_len);
> +	size_t ulen = strnlen(symname_utf8, symname_utf8_len);
>  
>  	if (ulen != symname_utf8_len) {
>  		cifs_dbg(VFS, "srv returned null byte in wsl symlink target location\n");
> -		return smb_EIO2(smb_eio_trace_reparse_wsl_ver,
> +		rc = smb_EIO2(smb_eio_trace_reparse_wsl_ver,
>  				ulen, symname_utf8_len);
> +		goto out;
>  	}
>  	symname_utf16 = kzalloc(symname_utf8_len * 2, GFP_KERNEL);
> -	if (!symname_utf16)
> -		return -ENOMEM;
> -	symname_utf16_len = utf8s_to_utf16s(buf->Target, symname_utf8_len,
> +	if (!symname_utf16) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +	symname_utf16_len = utf8s_to_utf16s(symname_utf8, symname_utf8_len,
>  					    UTF16_LITTLE_ENDIAN,
>  					    (wchar_t *) symname_utf16, symname_utf8_len * 2);
>  	if (symname_utf16_len < 0) {
>  		kfree(symname_utf16);
> -		return symname_utf16_len;
> +		rc = symname_utf16_len;
> +		goto out;
>  	}
>  	symname_utf16_len *= 2; /* utf8s_to_utf16s() returns number of u16 items, not byte length */
>  
> @@ -1112,14 +1190,23 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
>  						       symname_utf16_len, true,
>  						       cifs_sb->local_nls);
>  	kfree(symname_utf16);
> -	if (!data->symlink_target)
> -		return -ENOMEM;
> +	if (!data->symlink_target) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
>  
> -	return 0;
> +out:
> +	if (free_symname_utf8)
> +		kfree(symname_utf8);
> +
> +	return rc;
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
> @@ -1137,7 +1224,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
>  	case IO_REPARSE_TAG_LX_SYMLINK:
>  		return parse_reparse_wsl_symlink(
>  			(struct reparse_wsl_symlink_data_buffer *)buf,
> -			cifs_sb, data);
> +			xid, tcon, cifs_sb, full_path, data);
>  	case IO_REPARSE_TAG_AF_UNIX:
>  	case IO_REPARSE_TAG_LX_FIFO:
>  	case IO_REPARSE_TAG_LX_CHR:
> diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
> index e46d3379b779..dee4fb6af16a 100644
> --- a/fs/smb/common/fscc.h
> +++ b/fs/smb/common/fscc.h
> @@ -69,12 +69,13 @@ struct reparse_nfs_data_buffer {
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

For visibility, this is oneliner fixup for sashiko review:

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 8db3e4917788..c3e125669e9b 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1173,7 +1173,6 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf

 		buf_type = CIFS_NO_BUFFER;
 		io_parms = (struct cifs_io_parms) {
-			.netfid = fid.netfid,
 			.pid = current->tgid,
 			.tcon = tcon,
 			.offset = 0,
