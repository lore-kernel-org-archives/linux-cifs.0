Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EEE13B58A;
	Mon,  9 Dec 2024 18:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767373; cv=none; b=tMPgH7yt70Kn5ENIJbfNnstEq9OQyDp77kTl2r5QX7CVGL1GSgZ+FajGncFTAx+OImVbgz+TG0Str8Y/16++WvaWkCScwTwA7AAuPimm3oEDtOlJd6wnIYJCjGhhAMlIyA6VYdv4U0NOIyEDjZQI1W9W8ViGaaKuLXgsPXFcLRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767373; c=relaxed/simple;
	bh=9yg4o2Q8KuxzIuB3VoI8UqVNh3QgrddreIS17KNUelo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYpqdKKWifTUbyT/9g09uttARwVKZ9TbD1Z67yKivj0UlBGk9ARRwRjojPQsFzD9Fi6kBeZBAF6jz4gIJqG4fm0/lLG0RpmJA7vUW3r5PsB435RECIyCEoQJIdblv+eFaLDWJ4K8HJcTfmUAV8Yw6Elc9OtC39Xahu8e/3gRzNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tbcHVMaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tbcHVMaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12066C4CED1;
	Mon,  9 Dec 2024 18:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733767372;
	bh=9yg4o2Q8KuxzIuB3VoI8UqVNh3QgrddreIS17KNUelo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tbcHVMaw1xNMHpOcN86GOHR500mdemsse/s8Dvr/K8g7PoW3MD4KqcMu70uaoLTt3
	 dEsH1oPBqd0syxxohGjH1XTkYCGz4MKfr+hr4mhNyC66NZSyOEQM9muQ95bdVZKa4T
	 kEYPtdWnvSpp8kMfBSelL7MSpvopedJAagwChnlJ/BrErThXMB0HSs9D+bKHM792jn
	 i3fNw+j1JKMe/3AvJsypS/T05/wxoDuSP2laSLQVelsEczmd7eiMWLzgmHmIkZigJI
	 y2NKIuZLXaDxi/j8ogDUj7CmG+n5Y+i2PNsJw+4gay4hBIoWXZfDMthDw93jQf4uRr
	 asq02a8McBzYQ==
Received: by pali.im (Postfix)
	id F20B28A0; Mon,  9 Dec 2024 19:02:42 +0100 (CET)
Date: Mon, 9 Dec 2024 19:02:42 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cifs: Fix parsing native symlinks directory/file type
Message-ID: <20241209180242.udutn667vjjyfi4f@pali>
References: <20241005140300.19416-5-pali@kernel.org>
 <20241015143041.23721-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241015143041.23721-1-pali@kernel.org>
User-Agent: NeoMutt/20180716

On Tuesday 15 October 2024 16:30:41 Pali Rohár wrote:
> As SMB protocol distinguish between symlink to directory and symlink to
> file, add some mechanism to disallow resolving incompatible types.
> 
> When SMB symlink is of the directory type, ensure that its target path ends
> with slash. This forces Linux to not allow resolving such symlink to file.
> 
> And when SMB symlink is of the file type and its target path ends with
> slash then returns an error as such symlink is unresolvable. Such symlink
> always points to invalid location as file cannot end with slash.
> 
> As POSIX server does not distinguish between symlinks to file and symlink
> directory, do not apply this change for symlinks from POSIX SMB server. For
> POSIX SMB servers, this change does nothing.
> 
> This mimics Windows behavior of native SMB symlinks.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
> Changes in v3:
> * Relax non-directory case condition in smb2_fix_symlink_target_type()
>   for compatibility with older Linux clients.
> * Use krealloc() instead of kzalloc()+memcpy()
> ---
>  fs/smb/client/inode.c     |  5 ++++
>  fs/smb/client/smb2file.c  | 48 +++++++++++++++++++++++++++++++++++++++
>  fs/smb/client/smb2inode.c |  4 ++++
>  fs/smb/client/smb2proto.h |  1 +
>  4 files changed, 58 insertions(+)
> 
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 2ac9cc8d327d..3fd625b356bd 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1140,6 +1140,11 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
>  							      full_path,
>  							      iov, data);
>  		}
> +
> +		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
> +			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
> +			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
> +		}
>  		break;
>  	}
>  
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index e836bc2193dd..4b07274e824a 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -63,6 +63,49 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
>  	return sym;
>  }
>  
> +int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_info *cifs_sb)
> +{
> +	char *buf;
> +	int len;
> +
> +	/*
> +	 * POSIX server does not distinguish between symlinks to file and
> +	 * symlink directory. So nothing is needed to fix on the client side.
> +	 */
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
> +		return 0;
> +
> +	len = strlen(*target);
> +	if (!len)
> +		return -EIO;
> +
> +	/*
> +	 * If this is directory symlink and it does not have trailing slash then
> +	 * append it. Trailing slash simulates Windows/SMB behavior which do not
> +	 * allow resolving directory symlink to file.
> +	 */
> +	if (directory && (*target)[len-1] != '/') {
> +		buf = krealloc(*target, len+2, GFP_KERNEL);
> +		if (!buf)
> +			return -ENOMEM;
> +		buf[len] = '/';
> +		buf[len+1] = '\0';
> +		*target = buf;
> +		len++;
> +	}
> +
> +	/*
> +	 * If this is a file (non-directory) symlink and it points to path name
> +	 * with trailing slash then this is an invalid symlink because file name
> +	 * cannot contain slash character. File name with slash is invalid on
> +	 * both Windows and Linux systems. So return an error for such symlink.
> +	 */
> +	if (!directory && (*target)[len-1] == '/')
> +		return -EIO;
> +
> +	return 0;
> +}
> +
>  int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec *iov,
>  				const char *full_path, char **path)
>  {
> @@ -133,6 +176,11 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
>  					       NULL, NULL, NULL);
>  				oparms->create_options &= ~OPEN_REPARSE_POINT;
>  			}
> +			if (!rc) {
> +				bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
> +				rc = smb2_fix_symlink_target_type(&data->symlink_target,
> +								  directory, oparms->cifs_sb);
> +			}
>  		}
>  	}
>  
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index a188908914fe..b8ccc8fd88f2 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -960,6 +960,10 @@ int smb2_query_path_info(const unsigned int xid,
>  		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
>  				      &oparms, in_iov, cmds, num_cmds,
>  				      cfile, NULL, NULL, NULL);
> +		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
> +			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
> +			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
> +		}
>  		break;
>  	case -EREMOTE:
>  		break;
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index db93447f0f5a..5390d5a61039 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -113,6 +113,7 @@ extern int smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>  			  struct cifs_sb_info *cifs_sb,
>  			  const unsigned char *path, char *pbuf,
>  			  unsigned int *pbytes_read);
> +int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_info *cifs_sb);
>  int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
>  			      bool unicode, bool relative,
>  			      const char *full_path,
> -- 
> 2.20.1
> 

I was informed that function smb2_fix_symlink_target_type() may
dereference NULL pointer by strlen() call. So I'm proposing this fixup:

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index b0037058e8d9..47ba0b50f514 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -75,6 +75,9 @@ int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_i
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
 		return 0;
 
+	if (!*target)
+		return -EIO;
+
 	len = strlen(*target);
 	if (!len)
 		return -EIO;
