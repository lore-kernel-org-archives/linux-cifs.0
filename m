From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Implement follow_link for nounix CIFS mounts
Date: Mon, 12 Aug 2013 09:59:02 -0400
Message-ID: <20130812095902.326489e9@tlielax.poochiereds.net>
References: <1376053042-8608-1-git-send-email-pshilovsky@samba.org>
	<1376053042-8608-2-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376053042-8608-2-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  9 Aug 2013 16:57:22 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> by using a query reparse ioctl request.
> 
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifspdu.h   |   11 +++---
>  fs/cifs/cifsproto.h |   10 ++---
>  fs/cifs/cifssmb.c   |  110 ++++++++++++++++++++++++---------------------------
>  fs/cifs/smb1ops.c   |   32 +++++++++++++++
>  4 files changed, 92 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index 7e8523c..9d40a14 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -1490,11 +1490,12 @@ struct reparse_data {
>  	__u32	ReparseTag;
>  	__u16	ReparseDataLength;
>  	__u16	Reserved;
> -	__u16	AltNameOffset;
> -	__u16	AltNameLen;
> -	__u16	TargetNameOffset;
> -	__u16	TargetNameLen;
> -	char	LinkNamesBuf[1];
> +	__u16	SubstituteNameOffset;
> +	__u16	SubstituteNameLength;
> +	__u16	PrintNameOffset;
> +	__u16	PrintNameLength;
> +	__u32	Flags;
> +	char	PathBuffer[0];
>  } __attribute__((packed));
>  
>  struct cifs_quota_data {
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index a82b3c0..63c19ed 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -357,13 +357,9 @@ extern int CIFSSMBUnixQuerySymLink(const unsigned int xid,
>  			struct cifs_tcon *tcon,
>  			const unsigned char *searchName, char **syminfo,
>  			const struct nls_table *nls_codepage);
> -#ifdef CONFIG_CIFS_SYMLINK_EXPERIMENTAL
> -extern int CIFSSMBQueryReparseLinkInfo(const unsigned int xid,
> -			struct cifs_tcon *tcon,
> -			const unsigned char *searchName,
> -			char *symlinkinfo, const int buflen, __u16 fid,
> -			const struct nls_table *nls_codepage);
> -#endif /* temporarily unused until cifs_symlink fixed */
> +extern int CIFSSMBQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
> +			       __u16 fid, char **symlinkinfo,
> +			       const struct nls_table *nls_codepage);
>  extern int CIFSSMBOpen(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *fileName, const int disposition,
>  			const int access_flags, const int omode,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index a89c4cb..a3d74fe 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3067,7 +3067,6 @@ querySymLinkRetry:
>  	return rc;
>  }
>  
> -#ifdef CONFIG_CIFS_SYMLINK_EXPERIMENTAL
>  /*
>   *	Recent Windows versions now create symlinks more frequently
>   *	and they use the "reparse point" mechanism below.  We can of course
> @@ -3079,18 +3078,22 @@ querySymLinkRetry:
>   *	it is not compiled in by default until callers fixed up and more tested.
>   */
>  int
> -CIFSSMBQueryReparseLinkInfo(const unsigned int xid, struct cifs_tcon *tcon,
> -			const unsigned char *searchName,
> -			char *symlinkinfo, const int buflen, __u16 fid,
> -			const struct nls_table *nls_codepage)
> +CIFSSMBQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
> +		    __u16 fid, char **symlinkinfo,
> +		    const struct nls_table *nls_codepage)
>  {
>  	int rc = 0;
>  	int bytes_returned;
>  	struct smb_com_transaction_ioctl_req *pSMB;
>  	struct smb_com_transaction_ioctl_rsp *pSMBr;
> +	bool is_unicode;
> +	unsigned int sub_len;
> +	char *sub_start;
> +	struct reparse_data *reparse_buf;
> +	__u32 data_offset, data_count;
> +	char *end_of_smb;
>  
> -	cifs_dbg(FYI, "In Windows reparse style QueryLink for path %s\n",
> -		 searchName);
> +	cifs_dbg(FYI, "In Windows reparse style QueryLink for fid %u\n", fid);
>  	rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
>  		      (void **) &pSMBr);
>  	if (rc)
> @@ -3119,66 +3122,55 @@ CIFSSMBQueryReparseLinkInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>  	if (rc) {
>  		cifs_dbg(FYI, "Send error in QueryReparseLinkInfo = %d\n", rc);
> -	} else {		/* decode response */
> -		__u32 data_offset = le32_to_cpu(pSMBr->DataOffset);
> -		__u32 data_count = le32_to_cpu(pSMBr->DataCount);
> -		if (get_bcc(&pSMBr->hdr) < 2 || data_offset > 512) {
> -			/* BB also check enough total bytes returned */
> -			rc = -EIO;	/* bad smb */
> -			goto qreparse_out;
> -		}
> -		if (data_count && (data_count < 2048)) {
> -			char *end_of_smb = 2 /* sizeof byte count */ +
> -			       get_bcc(&pSMBr->hdr) + (char *)&pSMBr->ByteCount;
> -
> -			struct reparse_data *reparse_buf =
> -						(struct reparse_data *)
> -						((char *)&pSMBr->hdr.Protocol
> -								 + data_offset);
> -			if ((char *)reparse_buf >= end_of_smb) {
> -				rc = -EIO;
> -				goto qreparse_out;
> -			}
> -			if ((reparse_buf->LinkNamesBuf +
> -				reparse_buf->TargetNameOffset +
> -				reparse_buf->TargetNameLen) > end_of_smb) {
> -				cifs_dbg(FYI, "reparse buf beyond SMB\n");
> -				rc = -EIO;
> -				goto qreparse_out;
> -			}
> +		goto qreparse_out;
> +	}
>  
> -			if (pSMBr->hdr.Flags2 & SMBFLG2_UNICODE) {
> -				cifs_from_ucs2(symlinkinfo, (__le16 *)
> -						(reparse_buf->LinkNamesBuf +
> -						reparse_buf->TargetNameOffset),
> -						buflen,
> -						reparse_buf->TargetNameLen,
> -						nls_codepage, 0);
> -			} else { /* ASCII names */
> -				strncpy(symlinkinfo,
> -					reparse_buf->LinkNamesBuf +
> -					reparse_buf->TargetNameOffset,
> -					min_t(const int, buflen,
> -					   reparse_buf->TargetNameLen));
> -			}
> -		} else {
> -			rc = -EIO;
> -			cifs_dbg(FYI, "Invalid return data count on get reparse info ioctl\n");
> -		}
> -		symlinkinfo[buflen] = 0; /* just in case so the caller
> -					does not go off the end of the buffer */
> -		cifs_dbg(FYI, "readlink result - %s\n", symlinkinfo);
> +	data_offset = le32_to_cpu(pSMBr->DataOffset);
> +	data_count = le32_to_cpu(pSMBr->DataCount);
> +	if (get_bcc(&pSMBr->hdr) < 2 || data_offset > 512) {
> +		/* BB also check enough total bytes returned */
> +		rc = -EIO;	/* bad smb */
> +		goto qreparse_out;
> +	}
> +	if (!data_count || (data_count > 2048)) {
> +		rc = -EIO;
> +		cifs_dbg(FYI, "Invalid return data count on get reparse info ioctl\n");
> +		goto qreparse_out;
> +	}
> +	end_of_smb = 2 + get_bcc(&pSMBr->hdr) + (char *)&pSMBr->ByteCount;
> +	reparse_buf = (struct reparse_data *)
> +				((char *)&pSMBr->hdr.Protocol + data_offset);
> +	if ((char *)reparse_buf >= end_of_smb) {
> +		rc = -EIO;
> +		goto qreparse_out;
>  	}
> +	if ((reparse_buf->PathBuffer + reparse_buf->PrintNameOffset +
> +				reparse_buf->PrintNameLength) > end_of_smb) {
> +		cifs_dbg(FYI, "reparse buf beyond SMB\n");
> +		rc = -EIO;
> +		goto qreparse_out;
> +	}
> +	sub_start = reparse_buf->SubstituteNameOffset + reparse_buf->PathBuffer;
> +	sub_len = reparse_buf->SubstituteNameLength;
> +	if (pSMBr->hdr.Flags2 & SMBFLG2_UNICODE)
> +		is_unicode = true;
> +	else
> +		is_unicode = false;
>  
> +	/* BB FIXME investigate remapping reserved chars here */
> +	*symlinkinfo = cifs_strndup_from_utf16(sub_start, sub_len, is_unicode,
> +					       nls_codepage);
> +	if (!*symlinkinfo)
> +		rc = -ENOMEM;
>  qreparse_out:
>  	cifs_buf_release(pSMB);
>  
> -	/* Note: On -EAGAIN error only caller can retry on handle based calls
> -		since file handle passed in no longer valid */
> -
> +	/*
> +	 * Note: On -EAGAIN error only caller can retry on handle based calls
> +	 * since file handle passed in no longer valid.
> +	 */
>  	return rc;
>  }

Took me a few minutes to understand that you were just refactoring the
code in the above function, without really changing much. Might be nice
to do that in a separate patch instead.

> -#endif /* CIFS_SYMLINK_EXPERIMENTAL */ /* BB temporarily unused */
>  
>  #ifdef CONFIG_CIFS_POSIX
>  
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 6457690..0d525c3 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -881,6 +881,37 @@ cifs_mand_lock(const unsigned int xid, struct cifsFileInfo *cfile, __u64 offset,
>  			   (__u8)type, wait, 0);
>  }
>  
> +static int
> +cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
> +		   const char *full_path, char **target_path,
> +		   struct cifs_sb_info *cifs_sb)
> +{
> +	int rc;
> +	int oplock = 0;
> +	__u16 netfid;
> +
> +	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
> +
> +	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN,
> +			 FILE_READ_ATTRIBUTES, OPEN_REPARSE_POINT, &netfid,
> +			 &oplock, NULL, cifs_sb->local_nls,
> +			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> +	if (rc)
> +		return rc;
> +
> +	rc = CIFSSMBQuerySymLink(xid, tcon, netfid, target_path,
> +				 cifs_sb->local_nls);
> +	if (rc) {
> +		CIFSSMBClose(xid, tcon, netfid);
> +		return rc;
> +	}
> +
> +	convert_delimiter(*target_path, '/');
> +	CIFSSMBClose(xid, tcon, netfid);
> +	cifs_dbg(FYI, "%s: target path: %s\n", __func__, *target_path);
> +	return rc;
> +}
> +
>  struct smb_version_operations smb1_operations = {
>  	.send_cancel = send_nt_cancel,
>  	.compare_fids = cifs_compare_fids,
> @@ -927,6 +958,7 @@ struct smb_version_operations smb1_operations = {
>  	.rename_pending_delete = cifs_rename_pending_delete,
>  	.rename = CIFSSMBRename,
>  	.create_hardlink = CIFSCreateHardLink,
> +	.query_symlink = cifs_query_symlink,
>  	.open = cifs_open_file,
>  	.set_fid = cifs_set_fid,
>  	.close = cifs_close_file,

Other than the nit above...

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
