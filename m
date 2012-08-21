From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v4] cifs: obtain file access during backup intent lookup
Date: Tue, 21 Aug 2012 06:56:09 -0400
Message-ID: <20120821065609.0015362d@corrin.poochiereds.net>
References: <1345488751-5080-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345488751-5080-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 20 Aug 2012 13:52:31 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
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
> Reported-by: Tushar Gosavi <tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifspdu.h   |    1 +
>  fs/cifs/cifsproto.h |    6 +++-
>  fs/cifs/cifssmb.c   |   43 ++++++++++++++++++++++++----------------
>  fs/cifs/inode.c     |   54 +++++++++++++++++++++++++++++++++++++++++---------
>  fs/cifs/readdir.c   |    8 ++----
>  5 files changed, 78 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index 3fb03e2..b539ee7 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -275,6 +275,7 @@
>   * Invalid readdir handle
>   */
>  #define CIFS_NO_HANDLE        0xFFFF
> +#define INVALINUM		0xFFFFFFFFFFFFFFFFULL
>  

Do we know for a fact that no server will ever send this value for the
uniqueid? Looks like a potentially legitimate value to me...

>  #define NO_CHANGE_64          0xFFFFFFFFFFFFFFFFULL
>  #define NO_CHANGE_32          0xFFFFFFFFUL
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index f1bbf83..c747f82 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -132,6 +132,8 @@ void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr);
>  extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
>  				     FILE_UNIX_BASIC_INFO *info,
>  				     struct cifs_sb_info *cifs_sb);
> +extern void cifs_dir_info_to_fattr(struct cifs_fattr *, FILE_DIRECTORY_INFO *,
> +					struct cifs_sb_info *);
>  extern void cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr);
>  extern struct inode *cifs_iget(struct super_block *sb,
>  			       struct cifs_fattr *fattr);
> @@ -190,10 +192,10 @@ extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
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
> index 074923c..32cc44c 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4249,10 +4249,9 @@ UnixQPathInfoRetry:
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
> @@ -4260,8 +4259,9 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
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
> @@ -4271,6 +4271,9 @@ findFirstRetry:
>  	if (rc)
>  		return rc;
>  
> +	nls_codepage = cifs_sb->local_nls;
> +	remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
> +
>  	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>  		name_len =
>  		    cifsConvertToUTF16((__le16 *) pSMB->FileName, searchName,
> @@ -4279,24 +4282,29 @@ findFirstRetry:
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
> @@ -4384,7 +4392,8 @@ findFirstRetry:
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
> index 7354877..80ce010 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -605,6 +605,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  		    FILE_ALL_INFO *data, struct super_block *sb, int xid,
>  		    const __u16 *fid)
>  {
> +	__u16 srchflgs;
>  	int rc = 0, tmprc;
>  	struct cifs_tcon *tcon;
>  	struct TCP_Server_Info *server;
> @@ -613,12 +614,14 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  	char *buf = NULL;
>  	bool adjust_tz = false;
>  	struct cifs_fattr fattr;
> +	struct cifs_search_info *srchinf = NULL;
>  
>  	tlink = cifs_sb_tlink(cifs_sb);
>  	if (IS_ERR(tlink))
>  		return PTR_ERR(tlink);
>  	tcon = tlink_tcon(tlink);
>  	server = tcon->ses->server;
> +	fattr.cf_uniqueid = INVALINUM;
>  
>  	cFYI(1, "Getting info on %s", full_path);
>  
> @@ -651,6 +654,35 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  	} else if (rc == -EREMOTE) {
>  		cifs_create_dfs_fattr(&fattr, sb);
>  		rc = 0;
> +	} else if (rc == -EACCES && backup_cred(cifs_sb)) {
> +			srchinf = kzalloc(sizeof(struct cifs_search_info),
> +							GFP_KERNEL);
		^^^^^
		nit: Why the extra tab indentation here?

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
> +				cifs_sb, NULL, srchflgs, srchinf, 0);

nit: when passing bool args, you should use the values "true" and "false"

> +			if (!rc) {
> +				data =
> +				(FILE_ALL_INFO *)srchinf->srch_entries_start;
> +
> +				cifs_dir_info_to_fattr(&fattr,
> +				(FILE_DIRECTORY_INFO *)data, cifs_sb);
> +				fattr.cf_uniqueid = le64_to_cpu(
> +				((SEARCH_ID_FULL_DIR_INFO *)data)->UniqueId);
> +
> +				cifs_buf_release(srchinf->ntwrk_buf_start);
> +				kfree(srchinf);
> +			}
>  	} else {
>  		goto cgii_exit;
>  	}
> @@ -664,16 +696,18 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
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
> +			if (fattr.cf_uniqueid == INVALINUM) {
> +				if (server->ops->get_srv_inum)
> +					tmprc = server->ops->get_srv_inum(xid,
> +						tcon, cifs_sb, full_path,
> +						&fattr.cf_uniqueid, data);
> +				else
> +					tmprc = -ENOSYS;
> +				if (tmprc || !fattr.cf_uniqueid) {
					
			...and here, you're also treating cf_uniqueid == 0 as equivalent
			to INVALINUM, right? It might be best to ensure that get_srv_inum
			always returns an error if the uniqueid can't be determined.

			I think this needs a bit more of a cautious approach that
			doesn't rely on the server never sending certain values. Perhaps
			you can track whether you got a valid inode number in a separate
			bool on the stack or something? Getting the inode number right
			is pretty crucial.

> +					cFYI(1, "GetSrvInodeNum rc %d", tmprc);
> +					fattr.cf_uniqueid = iunique(sb, ROOT_I);
> +					cifs_autodisable_serverino(cifs_sb);
> +				}
>  			}
>  		} else {
>  			fattr.cf_uniqueid = iunique(sb, ROOT_I);
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index d87f826..6ce1a5d 100644
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
> @@ -278,10 +278,8 @@ ffirst_retry:
>  	if (backup_cred(cifs_sb))
>  		search_flags |= CIFS_SEARCH_BACKUP_SEARCH;
>  
> -	rc = CIFSFindFirst(xid, tcon, full_path, cifs_sb->local_nls,
> -		&cifsFile->netfid, search_flags, &cifsFile->srch_inf,
> -		cifs_sb->mnt_cifs_flags &
> -			CIFS_MOUNT_MAP_SPECIAL_CHR, CIFS_DIR_SEP(cifs_sb));
> +	rc = CIFSFindFirst(xid, tcon, full_path, cifs_sb,
> +		&cifsFile->netfid, search_flags, &cifsFile->srch_inf, 1);
>  	if (rc == 0)
>  		cifsFile->invalidHandle = false;
>  	/* BB add following call to handle readdir on new NTFS symlink errors


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
