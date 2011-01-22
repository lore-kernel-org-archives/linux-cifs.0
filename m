From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: [PATCH] CIFS: Remove pointless variable assignment in
 cifs_dfs_do_automount()
Date: Sat, 22 Jan 2011 21:07:16 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1101222101070.7746@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In fs/cifs/cifs_dfs_ref.c::cifs_dfs_do_automount() we have this code:

	...
	mnt = ERR_PTR(-EINVAL);
	if (IS_ERR(tlink)) {
		mnt = ERR_CAST(tlink);
		goto free_full_path;
	}
	ses = tlink_tcon(tlink)->ses;

	rc = get_dfs_path(xid, ses, full_path + 1, cifs_sb->local_nls,
		&num_referrals, &referrals,
		cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);

	cifs_put_tlink(tlink);

	mnt = ERR_PTR(-ENOENT);
	...

The assignment of 'mnt = ERR_PTR(-EINVAL);' is completely pointless. If we 
take the 'if (IS_ERR(tlink))' branch we'll set 'mnt' again and we'll also 
do so if we do not take the branch. There is no way we'll ever use 'mnt' 
with the assigned 'ERR_PTR(-EINVAL)' value, so we may as well just remove 
the pointless assignment.

Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
---
 cifs_dfs_ref.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 7ed3653..f1c6862 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -297,7 +297,6 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 
 	cifs_sb = CIFS_SB(mntpt->d_inode->i_sb);
 	tlink = cifs_sb_tlink(cifs_sb);
-	mnt = ERR_PTR(-EINVAL);
 	if (IS_ERR(tlink)) {
 		mnt = ERR_CAST(tlink);
 		goto free_full_path;


-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
