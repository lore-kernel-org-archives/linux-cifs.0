From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/8] cifs: use protocol specific call for
 query_mf_symlink()
Date: Wed, 27 Nov 2013 06:39:08 -0500
Message-ID: <20131127063908.753f9682@tlielax.poochiereds.net>
References: <1385399395-19217-1-git-send-email-sprabhu@redhat.com>
	<1385399395-19217-5-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385399395-19217-5-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 25 Nov 2013 17:09:51 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> We have an existing protocol specific call query_mf_symlink() created
> for check_mf_symlink which can also be used for query_mf_symlink().
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/link.c | 61 +++++++++++++++++++---------------------------------------
>  1 file changed, 20 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 2e7bbab..f8aaf10 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -237,55 +237,36 @@ create_mf_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>  
>  static int
>  query_mf_symlink(const unsigned int xid, struct cifs_tcon *tcon,
> -		   const unsigned char *searchName, char **symlinkinfo,
> -		   const struct nls_table *nls_codepage, int remap)
> +		 struct cifs_sb_info *cifs_sb, const unsigned char *path,
> +		 char **symlinkinfo)
>  {
>  	int rc;
> -	int oplock = 0;
> -	__u16 netfid = 0;
> -	u8 *buf;
> -	char *pbuf;
> -	unsigned int bytes_read = 0;
> -	int buf_type = CIFS_NO_BUFFER;
> +	u8 *buf = NULL;
>  	unsigned int link_len = 0;
> -	struct cifs_io_parms io_parms;
> -	FILE_ALL_INFO file_info;
> -
> -	rc = CIFSSMBOpen(xid, tcon, searchName, FILE_OPEN, GENERIC_READ,
> -			 CREATE_NOT_DIR, &netfid, &oplock, &file_info,
> -			 nls_codepage, remap);
> -	if (rc != 0)
> -		return rc;
> -
> -	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
> -		CIFSSMBClose(xid, tcon, netfid);
> -		/* it's not a symlink */
> -		return -EINVAL;
> -	}
> +	unsigned int bytes_read = 0;
>  
>  	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
> -	pbuf = buf;
> -	io_parms.netfid = netfid;
> -	io_parms.pid = current->tgid;
> -	io_parms.tcon = tcon;
> -	io_parms.offset = 0;
> -	io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
>  
> -	rc = CIFSSMBRead(xid, &io_parms, &bytes_read, &pbuf, &buf_type);
> -	CIFSSMBClose(xid, tcon, netfid);
> -	if (rc != 0) {
> -		kfree(buf);
> -		return rc;
> +	if (tcon->ses->server->ops->query_mf_symlink)
> +		rc = tcon->ses->server->ops->query_mf_symlink(xid, tcon,
> +					      cifs_sb, path, buf, &bytes_read);
> +	else
> +		rc = -ENOSYS;
> +
> +	if (rc)
> +		goto out;
> +
> +	if (bytes_read == 0) { /* not a symlink */
> +		rc = -EINVAL;
> +		goto out;
>  	}
>  
>  	rc = parse_mf_symlink(buf, bytes_read, &link_len, symlinkinfo);
> +out:
>  	kfree(buf);
> -	if (rc != 0)
> -		return rc;
> -
> -	return 0;
> +	return rc;
>  }
>  
>  bool
> @@ -515,10 +496,8 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
>  	 * and fallback to UNIX Extensions Symlinks.
>  	 */
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
> -		rc = query_mf_symlink(xid, tcon, full_path, &target_path,
> -					cifs_sb->local_nls,
> -					cifs_sb->mnt_cifs_flags &
> -						CIFS_MOUNT_MAP_SPECIAL_CHR);
> +		rc = query_mf_symlink(xid, tcon, cifs_sb, full_path,
> +				      &target_path);
>  
>  	if ((rc != 0) && cap_unix(tcon->ses))
>  		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,

Nice cleanup.

Reviwed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
