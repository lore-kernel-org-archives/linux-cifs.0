From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 3/4] cifs: use cifs_dirent to replace
 cifs_get_name_from_search_buf
Date: Sat, 23 Jul 2011 06:48:14 -0400
Message-ID: <20110723064814.301f3127@tlielax.poochiereds.net>
References: <20110716192334.GA26847@infradead.org>
	<20110716192422.GC26925@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110716192422.GC26925-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 16 Jul 2011 15:24:22 -0400
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> This allows us to parse the on the wire structures only once in
> cifs_filldir.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> 
> Index: linux-2.6/fs/cifs/readdir.c
> ===================================================================
> --- linux-2.6.orig/fs/cifs/readdir.c	2011-05-22 13:32:40.456945333 +0200
> +++ linux-2.6/fs/cifs/readdir.c	2011-05-22 13:33:38.060010807 +0200
> @@ -656,82 +656,6 @@ static int find_cifs_entry(const int xid
>  	return rc;
>  }
>  
> -/* inode num, inode type and filename returned */
> -static int cifs_get_name_from_search_buf(struct qstr *pqst,
> -	char *current_entry, __u16 level, unsigned int unicode,
> -	struct cifs_sb_info *cifs_sb, unsigned int max_len, __u64 *pinum)
> -{
> -	int rc = 0;
> -	unsigned int len = 0;
> -	char *filename;
> -	struct nls_table *nlt = cifs_sb->local_nls;
> -
> -	*pinum = 0;
> -
> -	if (level == SMB_FIND_FILE_UNIX) {
> -		FILE_UNIX_INFO *pFindData = (FILE_UNIX_INFO *)current_entry;
> -
> -		filename = &pFindData->FileName[0];
> -		if (unicode) {
> -			len = cifs_unicode_bytelen(filename);
> -		} else {
> -			/* BB should we make this strnlen of PATH_MAX? */
> -			len = strnlen(filename, PATH_MAX);
> -		}
> -
> -		*pinum = le64_to_cpu(pFindData->basic.UniqueId);
> -	} else if (level == SMB_FIND_FILE_DIRECTORY_INFO) {
> -		FILE_DIRECTORY_INFO *pFindData =
> -			(FILE_DIRECTORY_INFO *)current_entry;
> -		filename = &pFindData->FileName[0];
> -		len = le32_to_cpu(pFindData->FileNameLength);
> -	} else if (level == SMB_FIND_FILE_FULL_DIRECTORY_INFO) {
> -		FILE_FULL_DIRECTORY_INFO *pFindData =
> -			(FILE_FULL_DIRECTORY_INFO *)current_entry;
> -		filename = &pFindData->FileName[0];
> -		len = le32_to_cpu(pFindData->FileNameLength);
> -	} else if (level == SMB_FIND_FILE_ID_FULL_DIR_INFO) {
> -		SEARCH_ID_FULL_DIR_INFO *pFindData =
> -			(SEARCH_ID_FULL_DIR_INFO *)current_entry;
> -		filename = &pFindData->FileName[0];
> -		len = le32_to_cpu(pFindData->FileNameLength);
> -		*pinum = le64_to_cpu(pFindData->UniqueId);
> -	} else if (level == SMB_FIND_FILE_BOTH_DIRECTORY_INFO) {
> -		FILE_BOTH_DIRECTORY_INFO *pFindData =
> -			(FILE_BOTH_DIRECTORY_INFO *)current_entry;
> -		filename = &pFindData->FileName[0];
> -		len = le32_to_cpu(pFindData->FileNameLength);
> -	} else if (level == SMB_FIND_FILE_INFO_STANDARD) {
> -		FIND_FILE_STANDARD_INFO *pFindData =
> -			(FIND_FILE_STANDARD_INFO *)current_entry;
> -		filename = &pFindData->FileName[0];
> -		/* one byte length, no name conversion */
> -		len = (unsigned int)pFindData->FileNameLength;
> -	} else {
> -		cFYI(1, "Unknown findfirst level %d", level);
> -		return -EINVAL;
> -	}
> -
> -	if (len > max_len) {
> -		cERROR(1, "bad search response length %d past smb end", len);
> -		return -EINVAL;
> -	}
> -
> -	if (unicode) {
> -		pqst->len = cifs_from_ucs2((char *) pqst->name,
> -					   (__le16 *) filename,
> -					   UNICODE_NAME_MAX,
> -					   min(len, max_len), nlt,
> -					   cifs_sb->mnt_cifs_flags &
> -						CIFS_MOUNT_MAP_SPECIAL_CHR);
> -		pqst->len -= nls_nullsize(nlt);
> -	} else {
> -		pqst->name = filename;
> -		pqst->len = len;
> -	}
> -	return rc;
> -}
> -
>  static int cifs_filldir(char *find_entry, struct file *file, filldir_t filldir,
>  		void *dirent, char *scratch_buf, unsigned int max_len)
>  {
> @@ -743,7 +667,6 @@ static int cifs_filldir(char *find_entry
>  	struct dentry *dentry;
>  	struct qstr name;
>  	int rc = 0;
> -	u64 inum;
>  	ino_t ino;
>  
>  	rc = cifs_fill_dirent(&de, find_entry, file_info->srch_inf.info_level,
> @@ -751,17 +674,31 @@ static int cifs_filldir(char *find_entry
>  	if (rc)
>  		return rc;
>  
> +	if (de.namelen > max_len) {
> +		cERROR(1, "bad search response length %zd past smb end",
> +			  de.namelen);
> +		return -EINVAL;
> +	}
> +
>  	/* skip . and .. since we added them first */
>  	if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode))
>  		return 0;
>  
> -	name.name = scratch_buf;
> -	rc = cifs_get_name_from_search_buf(&name, find_entry,
> -					   file_info->srch_inf.info_level,
> -					   file_info->srch_inf.unicode,
> -					   cifs_sb, max_len, &inum);
> -	if (rc)
> -		return rc;
> +	if (file_info->srch_inf.unicode) {
> +		struct nls_table *nlt = cifs_sb->local_nls;
> +
> +		name.name = scratch_buf;
> +		name.len =
> +			cifs_from_ucs2((char *)name.name, (__le16 *)de.name,
> +				       UNICODE_NAME_MAX,
> +				       min(de.namelen, (size_t)max_len), nlt,
> +				       cifs_sb->mnt_cifs_flags &
> +					       	CIFS_MOUNT_MAP_SPECIAL_CHR);

	FWIW, the above line has some minor whitespace problems (spaces
	before tab). 

> +		name.len -= nls_nullsize(nlt);
> +	} else {
> +		name.name = de.name;
> +		name.len = de.namelen;
> +	}
>  
>  	switch (file_info->srch_inf.info_level) {
>  	case SMB_FIND_FILE_UNIX:
> @@ -781,8 +718,8 @@ static int cifs_filldir(char *find_entry
>  		break;
>  	}
>  
> -	if (inum && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
> -		fattr.cf_uniqueid = inum;
> +	if (de.ino && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
> +		fattr.cf_uniqueid = de.ino;
>  	} else {
>  		fattr.cf_uniqueid = iunique(sb, ROOT_I);
>  		cifs_autodisable_serverino(cifs_sb);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
