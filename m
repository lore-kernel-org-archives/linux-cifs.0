From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v6] cifs: obtain file access during backup intent lookup
Date: Fri, 28 Sep 2012 10:32:54 -0400
Message-ID: <20120928103254.74065450@tlielax.poochiereds.net>
References: <1348777282-6385-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348777282-6385-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 27 Sep 2012 15:21:22 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Rebased and resending the reviewed patch.
> Removed Reviewed by Jeff Layton since patch is slightly different
> i.e. there is a change to smb1ops.c to cifs query_dir_first operation. 
> 
> Path based querries can fail for lack of access, especially during lookup
> during open.
> open itself would actually succeed becasue of back up intent bit
> but querries (either path or file handle based) do not have a means to
> specifiy backup intent bit.
> So querry the file info during lookup using
>  trans2 / findfirst / file_id_full_dir_info
> to obtain file info as well as file_id/inode value.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsproto.h |    6 +++-
>  fs/cifs/cifssmb.c   |   43 ++++++++++++++++++++-------------
>  fs/cifs/inode.c     |   64 +++++++++++++++++++++++++++++++++++++-------------
>  fs/cifs/readdir.c   |    2 +-
>  fs/cifs/smb1ops.c   |    6 +---
>  5 files changed, 80 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 09ea632..5144e9f 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -140,6 +140,8 @@ void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr);
>  extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
>  				     FILE_UNIX_BASIC_INFO *info,
>  				     struct cifs_sb_info *cifs_sb);
> +extern void cifs_dir_info_to_fattr(struct cifs_fattr *, FILE_DIRECTORY_INFO *,
> +					struct cifs_sb_info *);
>  extern void cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr);
>  extern struct inode *cifs_iget(struct super_block *sb,
>  			       struct cifs_fattr *fattr);
> @@ -216,10 +218,10 @@ extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
>  		    const struct nls_table *);
>  
>  extern int CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
> -		const char *searchName, const struct nls_table *nls_codepage,
> +		const char *searchName, struct cifs_sb_info *cifs_sb,
>  		__u16 *searchHandle, __u16 search_flags,
>  		struct cifs_search_info *psrch_inf,
> -		int map, const char dirsep);
> +		bool msearch);
>  
>  extern int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
>  		__u16 searchHandle, __u16 search_flags,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 88bbb3e..76d0d29 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4214,10 +4214,9 @@ UnixQPathInfoRetry:
>  /* xid, tcon, searchName and codepage are input parms, rest are returned */
>  int
>  CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
> -	      const char *searchName,
> -	      const struct nls_table *nls_codepage,
> +	      const char *searchName, struct cifs_sb_info *cifs_sb,
>  	      __u16 *pnetfid, __u16 search_flags,
> -	      struct cifs_search_info *psrch_inf, int remap, const char dirsep)
> +	      struct cifs_search_info *psrch_inf, bool msearch)
>  {
>  /* level 257 SMB_ */
>  	TRANSACTION2_FFIRST_REQ *pSMB = NULL;
> @@ -4225,8 +4224,9 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
>  	T2_FFIRST_RSP_PARMS *parms;
>  	int rc = 0;
>  	int bytes_returned = 0;
> -	int name_len;
> +	int name_len, remap;
>  	__u16 params, byte_count;
> +	struct nls_table *nls_codepage;
>  
>  	cFYI(1, "In FindFirst for %s", searchName);
>  
> @@ -4236,6 +4236,9 @@ findFirstRetry:
>  	if (rc)
>  		return rc;
>  
> +	nls_codepage = cifs_sb->local_nls;
> +	remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
> +
>  	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>  		name_len =
>  		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
> @@ -4244,24 +4247,29 @@ findFirstRetry:
>  		it got remapped to 0xF03A as if it were part of the
>  		directory name instead of a wildcard */
>  		name_len *= 2;
> -		pSMB->FileName[name_len] = dirsep;
> -		pSMB->FileName[name_len+1] = 0;
> -		pSMB->FileName[name_len+2] = '*';
> -		pSMB->FileName[name_len+3] = 0;
> -		name_len += 4; /* now the trailing null */
> -		pSMB->FileName[name_len] = 0; /* null terminate just in case */
> -		pSMB->FileName[name_len+1] = 0;
> -		name_len += 2;
> +		if (msearch) {
> +			pSMB->FileName[name_len] = CIFS_DIR_SEP(cifs_sb);
> +			pSMB->FileName[name_len+1] = 0;
> +			pSMB->FileName[name_len+2] = '*';
> +			pSMB->FileName[name_len+3] = 0;
> +			name_len += 4; /* now the trailing null */
> +			/* null terminate just in case */
> +			pSMB->FileName[name_len] = 0;
> +			pSMB->FileName[name_len+1] = 0;
> +			name_len += 2;
> +		}
>  	} else {	/* BB add check for overrun of SMB buf BB */
>  		name_len = strnlen(searchName, PATH_MAX);
>  /* BB fix here and in unicode clause above ie
>  		if (name_len > buffersize-header)
>  			free buffer exit; BB */
>  		strncpy(pSMB->FileName, searchName, name_len);
> -		pSMB->FileName[name_len] = dirsep;
> -		pSMB->FileName[name_len+1] = '*';
> -		pSMB->FileName[name_len+2] = 0;
> -		name_len += 3;
> +		if (msearch) {
> +			pSMB->FileName[name_len] = CIFS_DIR_SEP(cifs_sb);
> +			pSMB->FileName[name_len+1] = '*';
> +			pSMB->FileName[name_len+2] = 0;
> +			name_len += 3;
> +		}
>  	}
>  
>  	params = 12 + name_len /* includes null */ ;
> @@ -4349,7 +4357,8 @@ findFirstRetry:
>  			psrch_inf->last_entry = psrch_inf->srch_entries_start +
>  							lnoff;
>  
> -			*pnetfid = parms->SearchHandle;
> +			if (pnetfid)
> +				*pnetfid = parms->SearchHandle;
>  		} else {
>  			cifs_buf_release(pSMB);
>  		}
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 3d15587..afdff79 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -607,7 +607,9 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  		    FILE_ALL_INFO *data, struct super_block *sb, int xid,
>  		    const __u16 *fid)
>  {
> -	int rc = 0, tmprc;
> +	bool validinum = false;
> +	__u16 srchflgs;
> +	int rc = 0, tmprc = ENOSYS;
>  	struct cifs_tcon *tcon;
>  	struct TCP_Server_Info *server;
>  	struct tcon_link *tlink;
> @@ -615,6 +617,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  	char *buf = NULL;
>  	bool adjust_tz = false;
>  	struct cifs_fattr fattr;
> +	struct cifs_search_info *srchinf = NULL;
>  
>  	tlink = cifs_sb_tlink(cifs_sb);
>  	if (IS_ERR(tlink))
> @@ -653,9 +656,38 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  	} else if (rc == -EREMOTE) {
>  		cifs_create_dfs_fattr(&fattr, sb);
>  		rc = 0;
> -	} else {
> +	} else if (rc == -EACCES && backup_cred(cifs_sb)) {
> +			srchinf = kzalloc(sizeof(struct cifs_search_info),
> +						GFP_KERNEL);
> +			if (srchinf == NULL) {
> +				rc = -ENOMEM;
> +				goto cgii_exit;
> +			}
> +
> +			srchinf->endOfSearch = false;
> +			srchinf->info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
> +
> +			srchflgs = CIFS_SEARCH_CLOSE_ALWAYS |
> +					CIFS_SEARCH_CLOSE_AT_END |
> +					CIFS_SEARCH_BACKUP_SEARCH;
> +
> +			rc = CIFSFindFirst(xid, tcon, full_path,
> +				cifs_sb, NULL, srchflgs, srchinf, false);
> +			if (!rc) {
> +				data =
> +				(FILE_ALL_INFO *)srchinf->srch_entries_start;
> +
> +				cifs_dir_info_to_fattr(&fattr,
> +				(FILE_DIRECTORY_INFO *)data, cifs_sb);
> +				fattr.cf_uniqueid = le64_to_cpu(
> +				((SEARCH_ID_FULL_DIR_INFO *)data)->UniqueId);
> +				validinum = true;
> +
> +				cifs_buf_release(srchinf->ntwrk_buf_start);
> +			}
> +			kfree(srchinf);
> +	} else
>  		goto cgii_exit;
> -	}
>  
>  	/*
>  	 * If an inode wasn't passed in, then get the inode number
> @@ -666,23 +698,21 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  	 */
>  	if (*inode == NULL) {
>  		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
> -			if (server->ops->get_srv_inum)
> -				tmprc = server->ops->get_srv_inum(xid, tcon,
> -					cifs_sb, full_path, &fattr.cf_uniqueid,
> -					data);
> -			else
> -				tmprc = -ENOSYS;
> -			if (tmprc || !fattr.cf_uniqueid) {
> -				cFYI(1, "GetSrvInodeNum rc %d", tmprc);
> -				fattr.cf_uniqueid = iunique(sb, ROOT_I);
> -				cifs_autodisable_serverino(cifs_sb);
> +			if (validinum == false) {
> +				if (server->ops->get_srv_inum)
> +					tmprc = server->ops->get_srv_inum(xid,
> +						tcon, cifs_sb, full_path,
> +						&fattr.cf_uniqueid, data);
> +				if (tmprc) {
> +					cFYI(1, "GetSrvInodeNum rc %d", tmprc);
> +					fattr.cf_uniqueid = iunique(sb, ROOT_I);
> +					cifs_autodisable_serverino(cifs_sb);
> +				}
>  			}
> -		} else {
> +		} else
>  			fattr.cf_uniqueid = iunique(sb, ROOT_I);
> -		}
> -	} else {
> +	} else
>  		fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
> -	}
>  
>  	/* query for SFU type info if supported and needed */
>  	if (fattr.cf_cifsattrs & ATTR_SYSTEM &&
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index b0f4a42..f9b5d3d 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -151,7 +151,7 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
>  	}
>  }
>  
> -static void
> +void
>  cifs_dir_info_to_fattr(struct cifs_fattr *fattr, FILE_DIRECTORY_INFO *info,
>  		       struct cifs_sb_info *cifs_sb)
>  {
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 5fb0fe5..bf61818 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -837,10 +837,8 @@ cifs_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
>  		     struct cifs_fid *fid, __u16 search_flags,
>  		     struct cifs_search_info *srch_inf)
>  {
> -	return CIFSFindFirst(xid, tcon, path, cifs_sb->local_nls,
> -			     &fid->netfid, search_flags, srch_inf,
> -			     cifs_sb->mnt_cifs_flags &
> -			     CIFS_MOUNT_MAP_SPECIAL_CHR, CIFS_DIR_SEP(cifs_sb));
> +	return CIFSFindFirst(xid, tcon, path, cifs_sb,
> +			     &fid->netfid, search_flags, srch_inf, true);
>  }
>  
>  static int

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
