From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/45] CIFS: Add SMB2 support for unlink
Date: Wed, 12 Sep 2012 15:51:40 -0400
Message-ID: <20120912155140.4efff904@corrin.poochiereds.net>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
	<1342626541-29872-10-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-10-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 18 Jul 2012 19:48:25 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/smb2inode.c |    9 +++++++++
>  fs/cifs/smb2ops.c   |    1 +
>  fs/cifs/smb2proto.h |    2 ++
>  3 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 2aa5cb0..02a9bda 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -161,3 +161,12 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
>  				  0, CREATE_NOT_FILE | CREATE_DELETE_ON_CLOSE,
>  				  NULL, SMB2_OP_DELETE);
>  }
> +
> +int
> +smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
> +	    struct cifs_sb_info *cifs_sb)
> +{
> +	return smb2_open_op_close(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
> +				  0, CREATE_DELETE_ON_CLOSE, NULL,
> +				  SMB2_OP_DELETE);
> +}
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 826209b..bf9b318 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -321,6 +321,7 @@ struct smb_version_operations smb21_operations = {
>  	.mkdir = smb2_mkdir,
>  	.mkdir_setinfo = smb2_mkdir_setinfo,
>  	.rmdir = smb2_rmdir,
> +	.unlink = smb2_unlink,
>  };
>  
>  struct smb_version_values smb21_values = {
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index bfaa7b1..f4ac727 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -59,6 +59,8 @@ extern void smb2_mkdir_setinfo(struct inode *inode, const char *full_path,
>  			       struct cifs_tcon *tcon, const unsigned int xid);
>  extern int smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
>  		      const char *name, struct cifs_sb_info *cifs_sb);
> +extern int smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon,
> +		       const char *name, struct cifs_sb_info *cifs_sb);
>  
>  /*
>   * SMB2 Worker functions - most of protocol specific implementation details

So, you're not defining a rename_pending_delete function here. That
means that if the initial unlink attempt happens to get back -ETXTBUSY,
you're now going to return -ENOSYS.

I think maybe it would be best to have cifs_unlink just fall through
and return -ETXTBUSY if there is no rename_pending_delete function.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
