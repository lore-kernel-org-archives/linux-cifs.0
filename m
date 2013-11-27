From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/8] cifs: Rename MF symlink function names
Date: Wed, 27 Nov 2013 06:36:40 -0500
Message-ID: <20131127063640.136e50f6@tlielax.poochiereds.net>
References: <1385399395-19217-1-git-send-email-sprabhu@redhat.com>
	<1385399395-19217-4-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385399395-19217-4-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 25 Nov 2013 17:09:50 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Clean up camel case in functionnames.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsproto.h |  4 ++--
>  fs/cifs/inode.c     | 12 ++++++------
>  fs/cifs/link.c      | 32 +++++++++++++++-----------------
>  fs/cifs/readdir.c   |  2 +-
>  4 files changed, 24 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 10b9ab1..78bb6d6 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -476,8 +476,8 @@ extern int CIFSSMBSetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
>  extern int CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
>  			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
>  extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
> -extern bool CIFSCouldBeMFSymlink(const struct cifs_fattr *fattr);
> -extern int CIFSCheckMFSymlink(unsigned int xid, struct cifs_tcon *tcon,
> +extern bool couldbe_mf_symlink(const struct cifs_fattr *fattr);
> +extern int check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>  			      struct cifs_sb_info *cifs_sb,
>  			      struct cifs_fattr *fattr,
>  			      const unsigned char *path);
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 49719b8..6f7f57a 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -383,10 +383,10 @@ int cifs_get_inode_info_unix(struct inode **pinode,
>  
>  	/* check for Minshall+French symlinks */
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
> -		int tmprc = CIFSCheckMFSymlink(xid, tcon, cifs_sb, &fattr,
> -					       full_path);
> +		int tmprc = check_mf_symlink(xid, tcon, cifs_sb, &fattr,
> +					     full_path);
>  		if (tmprc)
> -			cifs_dbg(FYI, "CIFSCheckMFSymlink: %d\n", tmprc);
> +			cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
>  	}
>  
>  	if (*pinode == NULL) {
> @@ -800,10 +800,10 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  
>  	/* check for Minshall+French symlinks */
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
> -		tmprc = CIFSCheckMFSymlink(xid, tcon, cifs_sb, &fattr,
> -					   full_path);
> +		tmprc = check_mf_symlink(xid, tcon, cifs_sb, &fattr,
> +					 full_path);
>  		if (tmprc)
> -			cifs_dbg(FYI, "CIFSCheckMFSymlink: %d\n", tmprc);
> +			cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
>  	}
>  
>  	if (!*inode) {
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 2a5837a..2e7bbab 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -91,10 +91,8 @@ symlink_hash_err:
>  }
>  
>  static int
> -CIFSParseMFSymlink(const u8 *buf,
> -		   unsigned int buf_len,
> -		   unsigned int *_link_len,
> -		   char **_link_str)
> +parse_mf_symlink(const u8 *buf, unsigned int buf_len, unsigned int *_link_len,
> +		 char **_link_str)
>  {
>  	int rc;
>  	unsigned int link_len;
> @@ -137,7 +135,7 @@ CIFSParseMFSymlink(const u8 *buf,
>  }
>  
>  static int
> -CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
> +format_mf_symlink(u8 *buf, unsigned int buf_len, const char *link_str)
>  {
>  	int rc;
>  	unsigned int link_len;
> @@ -181,7 +179,7 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
>  }
>  
>  static int
> -CIFSCreateMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
> +create_mf_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>  		    const char *fromName, const char *toName,
>  		    struct cifs_sb_info *cifs_sb)
>  {
> @@ -202,7 +200,7 @@ CIFSCreateMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>  	if (!buf)
>  		return -ENOMEM;
>  
> -	rc = CIFSFormatMFSymlink(buf, CIFS_MF_SYMLINK_FILE_SIZE, toName);
> +	rc = format_mf_symlink(buf, CIFS_MF_SYMLINK_FILE_SIZE, toName);
>  	if (rc != 0) {
>  		kfree(buf);
>  		return rc;
> @@ -238,7 +236,7 @@ CIFSCreateMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>  }
>  
>  static int
> -CIFSQueryMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
> +query_mf_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>  		   const unsigned char *searchName, char **symlinkinfo,
>  		   const struct nls_table *nls_codepage, int remap)
>  {
> @@ -282,7 +280,7 @@ CIFSQueryMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>  		return rc;
>  	}
>  
> -	rc = CIFSParseMFSymlink(buf, bytes_read, &link_len, symlinkinfo);
> +	rc = parse_mf_symlink(buf, bytes_read, &link_len, symlinkinfo);
>  	kfree(buf);
>  	if (rc != 0)
>  		return rc;
> @@ -291,7 +289,7 @@ CIFSQueryMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>  }
>  
>  bool
> -CIFSCouldBeMFSymlink(const struct cifs_fattr *fattr)
> +couldbe_mf_symlink(const struct cifs_fattr *fattr)
>  {
>  	if (!(fattr->cf_mode & S_IFREG))
>  		/* it's not a symlink */
> @@ -341,16 +339,16 @@ out:
>  }
>  
>  int
> -CIFSCheckMFSymlink(unsigned int xid, struct cifs_tcon *tcon,
> -		   struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
> -		   const unsigned char *path)
> +check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> +		 struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
> +		 const unsigned char *path)
>  {
>  	int rc;
>  	u8 *buf = NULL;
>  	unsigned int link_len = 0;
>  	unsigned int bytes_read = 0;
>  
> -	if (!CIFSCouldBeMFSymlink(fattr))
> +	if (!couldbe_mf_symlink(fattr))
>  		/* it's not a symlink */
>  		return 0;
>  
> @@ -370,7 +368,7 @@ CIFSCheckMFSymlink(unsigned int xid, struct cifs_tcon *tcon,
>  	if (bytes_read == 0) /* not a symlink */
>  		goto out;
>  
> -	rc = CIFSParseMFSymlink(buf, bytes_read, &link_len, NULL);
> +	rc = parse_mf_symlink(buf, bytes_read, &link_len, NULL);
>  	if (rc == -EINVAL) {
>  		/* it's not a symlink */
>  		rc = 0;
> @@ -517,7 +515,7 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
>  	 * and fallback to UNIX Extensions Symlinks.
>  	 */
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
> -		rc = CIFSQueryMFSymLink(xid, tcon, full_path, &target_path,
> +		rc = query_mf_symlink(xid, tcon, full_path, &target_path,
>  					cifs_sb->local_nls,
>  					cifs_sb->mnt_cifs_flags &
>  						CIFS_MOUNT_MAP_SPECIAL_CHR);
> @@ -574,7 +572,7 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
>  
>  	/* BB what if DFS and this volume is on different share? BB */
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
> -		rc = CIFSCreateMFSymLink(xid, pTcon, full_path, symname,
> +		rc = create_mf_symlink(xid, pTcon, full_path, symname,
>  					cifs_sb);
>  	else if (pTcon->unix_ext)
>  		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 5940eca..b15862e 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -749,7 +749,7 @@ static int cifs_filldir(char *find_entry, struct file *file,
>  	}
>  
>  	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) &&
> -	    CIFSCouldBeMFSymlink(&fattr))
> +	    couldbe_mf_symlink(&fattr))
>  		/*
>  		 * trying to get the type and mode can be slow,
>  		 * so just call those regular files for now, and mark

Meh...ok...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
