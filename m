From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] cifs: fix revalidation test in cifs_llseek()
Date: Fri, 20 Apr 2012 00:06:19 +0300
Message-ID: <20120419210619.GA19074@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org,
	samba-technical@lists.samba.org, Josef Bacik <josef@redhat.com>
To: Steve French <sfrench@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

This test is always true so it means we revalidate the length every
time, which generates more network traffic.  This was introduced in
06222e491e "fs: handle SEEK_HOLE/SEEK_DATA properly in all fs's that
define their own llseek".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Josef, there were three other places that had this same problem but I
think they've all been fixed now.  Except that I had a question about
nfs_file_llseek().  Isn't that reversed?  It seems like it only
revalidates when it's not supposed to.  I chose to copy what
fuse_file_llseek() does instead.

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d342128..97d26c7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -695,7 +695,7 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
 	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
 	 * the cached file length
 	 */
-	if (origin != SEEK_SET || origin != SEEK_CUR) {
+	if (origin == SEEK_SET || origin == SEEK_CUR) {
 		int rc;
 		struct inode *inode = file->f_path.dentry->d_inode;
 
