From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] Add oplock_break to smb_version_operations
Date: Mon, 10 Mar 2014 16:21:10 +0000
Message-ID: <1394468470.2426.21.camel@sachin-laptop>
References: <1394198960-7585-1-git-send-email-sprabhu@redhat.com>
	 <1394198960-7585-2-git-send-email-sprabhu@redhat.com>
	 <20140310110640.4df1710a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140310110640.4df1710a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2014-03-10 at 11:06 -0400, Jeff Layton wrote:
> On Fri,  7 Mar 2014 13:29:19 +0000
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > We need to add protocol specific calls to the oplock break thread.
> > 
> 
> I'm not necessarily doubting this, but why? AFAICT, the oplock_break
> calls look more or less identical...

The oplock values for level 2 oplocks are different. For the 2nd fix to
work, we need to downgrade the oplock only once we are sure that no
writers are operating.

We need to downgrade oplocks. Since the constants used to describe
oplock states varies between cifs and smb2, we need to abstract out the
functions required to downgrade the oplocks. For this we need version
specific functions. This could either be the oplock_break function as a
whole or we could define a new function called downgrade_oplock() in
smb_version_operations. I have chosen to use version specific
oplock_break here. downgrade_oplock() could instead be used here which
would require fewer changes.

Should I implement this using a downgrade_oplock() function instead?

Sachin Prabhu

> 
> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/cifsglob.h  |  3 +--
> >  fs/cifs/cifsproto.h |  2 ++
> >  fs/cifs/file.c      | 53 +++--------------------------------------------------
> >  fs/cifs/smb1ops.c   | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/cifs/smb2ops.c   | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 106 insertions(+), 52 deletions(-)
> > 
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index cf32f03..93a8762 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -402,6 +402,7 @@ struct smb_version_operations {
> >  			const struct cifs_fid *, u32 *);
> >  	int (*set_acl)(struct cifs_ntsd *, __u32, struct inode *, const char *,
> >  			int);
> > +	void (*oplock_break)(struct work_struct *);
> >  };
> >  
> >  struct smb_version_values {
> > @@ -1557,8 +1558,6 @@ GLOBAL_EXTERN spinlock_t uidsidlock;
> >  GLOBAL_EXTERN spinlock_t gidsidlock;
> >  #endif /* CONFIG_CIFS_ACL */
> >  
> > -void cifs_oplock_break(struct work_struct *work);
> > -
> >  extern const struct slow_work_ops cifs_oplock_break_ops;
> >  extern struct workqueue_struct *cifsiod_wq;
> >  
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index acc4ee8..e4d0add 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -130,6 +130,8 @@ extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
> >  extern int cifs_unlock_range(struct cifsFileInfo *cfile,
> >  			     struct file_lock *flock, const unsigned int xid);
> >  extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
> > +extern int cifs_push_locks(struct cifsFileInfo *cfile);
> > +bool cifs_has_mand_locks(struct cifsInodeInfo *cinode);
> >  
> >  extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
> >  					      struct file *file,
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 53c1507..998dec7 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -251,7 +251,7 @@ out:
> >  	return rc;
> >  }
> >  
> > -static bool
> > +bool
> >  cifs_has_mand_locks(struct cifsInodeInfo *cinode)
> >  {
> >  	struct cifs_fid_locks *cur;
> > @@ -304,7 +304,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
> >  	cfile->f_flags = file->f_flags;
> >  	cfile->invalidHandle = false;
> >  	cfile->tlink = cifs_get_tlink(tlink);
> > -	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
> > +	INIT_WORK(&cfile->oplock_break, server->ops->oplock_break);
> >  	mutex_init(&cfile->fh_mutex);
> >  
> >  	cifs_sb_active(inode->i_sb);
> > @@ -1204,7 +1204,7 @@ err_out:
> >  	goto out;
> >  }
> >  
> > -static int
> > +int
> >  cifs_push_locks(struct cifsFileInfo *cfile)
> >  {
> >  	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
> > @@ -3656,53 +3656,6 @@ static int cifs_launder_page(struct page *page)
> >  	return rc;
> >  }
> >  
> > -void cifs_oplock_break(struct work_struct *work)
> > -{
> > -	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
> > -						  oplock_break);
> > -	struct inode *inode = cfile->dentry->d_inode;
> > -	struct cifsInodeInfo *cinode = CIFS_I(inode);
> > -	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
> > -	int rc = 0;
> > -
> > -	if (!CIFS_CACHE_WRITE(cinode) && CIFS_CACHE_READ(cinode) &&
> > -						cifs_has_mand_locks(cinode)) {
> > -		cifs_dbg(FYI, "Reset oplock to None for inode=%p due to mand locks\n",
> > -			 inode);
> > -		cinode->oplock = 0;
> > -	}
> > -
> > -	if (inode && S_ISREG(inode->i_mode)) {
> > -		if (CIFS_CACHE_READ(cinode))
> > -			break_lease(inode, O_RDONLY);
> > -		else
> > -			break_lease(inode, O_WRONLY);
> > -		rc = filemap_fdatawrite(inode->i_mapping);
> > -		if (!CIFS_CACHE_READ(cinode)) {
> > -			rc = filemap_fdatawait(inode->i_mapping);
> > -			mapping_set_error(inode->i_mapping, rc);
> > -			cifs_invalidate_mapping(inode);
> > -		}
> > -		cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc);
> > -	}
> > -
> > -	rc = cifs_push_locks(cfile);
> > -	if (rc)
> > -		cifs_dbg(VFS, "Push locks rc = %d\n", rc);
> > -
> > -	/*
> > -	 * releasing stale oplock after recent reconnect of smb session using
> > -	 * a now incorrect file handle is not a data integrity issue but do
> > -	 * not bother sending an oplock release if session to server still is
> > -	 * disconnected since oplock already released by the server
> > -	 */
> > -	if (!cfile->oplock_break_cancelled) {
> > -		rc = tcon->ses->server->ops->oplock_response(tcon, &cfile->fid,
> > -							     cinode);
> > -		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
> > -	}
> > -}
> > -
> >  /*
> >   * The presence of cifs_direct_io() in the address space ops vector
> >   * allowes open() O_DIRECT flags which would have failed otherwise.
> > diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> > index 526fb89..346ee2a 100644
> > --- a/fs/cifs/smb1ops.c
> > +++ b/fs/cifs/smb1ops.c
> > @@ -23,6 +23,7 @@
> >  #include "cifsproto.h"
> >  #include "cifs_debug.h"
> >  #include "cifspdu.h"
> > +#include "cifsfs.h"
> >  
> >  /*
> >   * An NT cancel request header looks just like the original request except:
> > @@ -999,6 +1000,53 @@ cifs_is_read_op(__u32 oplock)
> >  	return oplock == OPLOCK_READ;
> >  }
> >  
> > +static void cifs_oplock_break(struct work_struct *work)
> > +{
> > +	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
> > +						  oplock_break);
> > +	struct inode *inode = cfile->dentry->d_inode;
> > +	struct cifsInodeInfo *cinode = CIFS_I(inode);
> > +	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
> > +	int rc = 0;
> > +
> > +	if (!CIFS_CACHE_WRITE(cinode) && CIFS_CACHE_READ(cinode) &&
> > +						cifs_has_mand_locks(cinode)) {
> > +		cifs_dbg(FYI, "Reset oplock to None for inode=%p due to mand locks\n",
> > +			 inode);
> > +		cinode->oplock = 0;
> > +	}
> > +
> > +	if (inode && S_ISREG(inode->i_mode)) {
> > +		if (CIFS_CACHE_READ(cinode))
> > +			break_lease(inode, O_RDONLY);
> > +		else
> > +			break_lease(inode, O_WRONLY);
> > +		rc = filemap_fdatawrite(inode->i_mapping);
> > +		if (!CIFS_CACHE_READ(cinode)) {
> > +			rc = filemap_fdatawait(inode->i_mapping);
> > +			mapping_set_error(inode->i_mapping, rc);
> > +			cifs_invalidate_mapping(inode);
> > +		}
> > +		cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc);
> > +	}
> > +
> > +	rc = cifs_push_locks(cfile);
> > +	if (rc)
> > +		cifs_dbg(VFS, "Push locks rc = %d\n", rc);
> > +
> > +	/*
> > +	 * releasing stale oplock after recent reconnect of smb session using
> > +	 * a now incorrect file handle is not a data integrity issue but do
> > +	 * not bother sending an oplock release if session to server still is
> > +	 * disconnected since oplock already released by the server
> > +	 */
> > +	if (!cfile->oplock_break_cancelled) {
> > +		rc = tcon->ses->server->ops->oplock_response(tcon, &cfile->fid,
> > +							     cinode);
> > +		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
> > +	}
> > +}
> > +
> >  struct smb_version_operations smb1_operations = {
> >  	.send_cancel = send_nt_cancel,
> >  	.compare_fids = cifs_compare_fids,
> > @@ -1067,6 +1115,7 @@ struct smb_version_operations smb1_operations = {
> >  	.query_mf_symlink = cifs_query_mf_symlink,
> >  	.create_mf_symlink = cifs_create_mf_symlink,
> >  	.is_read_op = cifs_is_read_op,
> > +	.oplock_break = cifs_oplock_break,
> >  #ifdef CONFIG_CIFS_XATTR
> >  	.query_all_EAs = CIFSSMBQAllEAs,
> >  	.set_EA = CIFSSMBSetEA,
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 192f51a..e7081cd 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -27,6 +27,7 @@
> >  #include "cifs_unicode.h"
> >  #include "smb2status.h"
> >  #include "smb2glob.h"
> > +#include "cifsfs.h"
> >  
> >  static int
> >  change_conf(struct TCP_Server_Info *server)
> > @@ -904,6 +905,53 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
> >  	return rc;
> >  }
> >  
> > +static void smb2_oplock_break(struct work_struct *work)
> > +{
> > +	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
> > +						  oplock_break);
> > +	struct inode *inode = cfile->dentry->d_inode;
> > +	struct cifsInodeInfo *cinode = CIFS_I(inode);
> > +	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
> > +	int rc = 0;
> > +
> > +	if (!CIFS_CACHE_WRITE(cinode) && CIFS_CACHE_READ(cinode) &&
> > +						cifs_has_mand_locks(cinode)) {
> > +		cifs_dbg(FYI, "Reset oplock to None for inode=%p due to mand locks\n",
> > +			 inode);
> > +		cinode->oplock = 0;
> > +	}
> > +
> > +	if (inode && S_ISREG(inode->i_mode)) {
> > +		if (CIFS_CACHE_READ(cinode))
> > +			break_lease(inode, O_RDONLY);
> > +		else
> > +			break_lease(inode, O_WRONLY);
> > +		rc = filemap_fdatawrite(inode->i_mapping);
> > +		if (!CIFS_CACHE_READ(cinode)) {
> > +			rc = filemap_fdatawait(inode->i_mapping);
> > +			mapping_set_error(inode->i_mapping, rc);
> > +			cifs_invalidate_mapping(inode);
> > +		}
> > +		cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc);
> > +	}
> > +
> > +	rc = cifs_push_locks(cfile);
> > +	if (rc)
> > +		cifs_dbg(VFS, "Push locks rc = %d\n", rc);
> > +
> > +	/*
> > +	 * releasing stale oplock after recent reconnect of smb session using
> > +	 * a now incorrect file handle is not a data integrity issue but do
> > +	 * not bother sending an oplock release if session to server still is
> > +	 * disconnected since oplock already released by the server
> > +	 */
> > +	if (!cfile->oplock_break_cancelled) {
> > +		rc = tcon->ses->server->ops->oplock_response(tcon, &cfile->fid,
> > +							     cinode);
> > +		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
> > +	}
> > +}
> > +
> >  static void
> >  smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
> >  		      unsigned int epoch, bool *purge_cache)
> > @@ -1163,6 +1211,7 @@ struct smb_version_operations smb20_operations = {
> >  	.create_lease_buf = smb2_create_lease_buf,
> >  	.parse_lease_buf = smb2_parse_lease_buf,
> >  	.clone_range = smb2_clone_range,
> > +	.oplock_break = smb2_oplock_break,
> >  };
> >  
> >  struct smb_version_operations smb21_operations = {
> > @@ -1237,6 +1286,7 @@ struct smb_version_operations smb21_operations = {
> >  	.create_lease_buf = smb2_create_lease_buf,
> >  	.parse_lease_buf = smb2_parse_lease_buf,
> >  	.clone_range = smb2_clone_range,
> > +	.oplock_break = smb2_oplock_break,
> >  };
> >  
> >  struct smb_version_operations smb30_operations = {
> > @@ -1314,6 +1364,7 @@ struct smb_version_operations smb30_operations = {
> >  	.parse_lease_buf = smb3_parse_lease_buf,
> >  	.clone_range = smb2_clone_range,
> >  	.validate_negotiate = smb3_validate_negotiate,
> > +	.oplock_break = smb2_oplock_break,
> >  };
> >  
> >  struct smb_version_values smb20_values = {
> 
> 
