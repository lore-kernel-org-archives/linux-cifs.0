From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 2/2] cifs: dereferencing first then checking
Date: Tue, 2 Nov 2010 16:22:50 -0400
Message-ID: <20101102162250.3a2aa670@tlielax.poochiereds.net>
References: <20101027212253.GL6062@bicker>
	<20101027195123.0a712a53@tlielax.poochiereds.net>
	<20101028034434.GR6062@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101028034434.GR6062@bicker>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Oct 2010 05:44:34 +0200
Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Oct 27, 2010 at 07:51:23PM -0400, Jeff Layton wrote:
> > 
> > The above delta shouldn't be needed once the patches in Steve's tree
> > are pushed to Linus. I think what we should probably do is wait for
> > Steve to push to Linus and then do a patch to remove the first two
> > checks.
> > 
> > Sound like a plan?
> > 
> 
> Sounds like a plan.
> 
> regards,
> dan carpenter
> 

Here's a respun patch that should fix these problems. I chickened out
on removing the check in find_writable_file.

It still seems like a bogus cargo-cult sort of thing. It should
probably be a BUG() if you call that function with a NULL pointer, but
I don't feel like tackling that just yet.

Dan, does this look ok to you? If so, I'll resend to Steve as an
"official" patch.

---------------------[snip]-----------------------

cifs: dereferencing first then checking (try #2)

This patch is based on Dan's original patch. His original description is
below:

Smatch complained about a couple checking for NULL after dereferencing
bugs.  I'm not super familiar with the code so I did the conservative
thing and move the dereferences after the checks.

The dereferences in cifs_lock() and cifs_fsync() were added in
ba00ba64cf0 "cifs: make various routines use the cifsFileInfo->tcon
pointer".  The dereference in find_writable_file() was added in
6508d904e6f "cifs: have find_readable/writable_file filter by fsuid".
The comments there say it's possible to trigger the NULL dereference
under stress.

Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a566f15..a59b53f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -755,12 +755,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	tcon = tlink_tcon(((struct cifsFileInfo *)file->private_data)->tlink);
-
-	if (file->private_data == NULL) {
-		rc = -EBADF;
-		FreeXid(xid);
-		return rc;
-	}
 	netfid = ((struct cifsFileInfo *)file->private_data)->netfid;
 
 	if ((tcon->ses->capabilities & CAP_UNIX) &&
@@ -1155,7 +1149,7 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 					bool fsuid_only)
 {
 	struct cifsFileInfo *open_file;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
+	struct cifs_sb_info *cifs_sb;
 	bool any_available = false;
 	int rc;
 
@@ -1169,6 +1163,8 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 		return NULL;
 	}
 
+	cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
+
 	/* only filter by fsuid on multiuser mounts */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
-- 
1.7.2.3
