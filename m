From: scott.lovenberg@gmail.com
Subject: [PATCH 1/2] cifs: Move and expand MAX_SERVER_SIZE
Date: Thu, 25 Jul 2013 14:34:44 -0400
Message-ID: <1374777285-25639-1-git-send-email-scott.lovenberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, gang.chen@asianux.com,
	samba-technical@lists.samba.org, jlayton@redhat.com
To: sfrench@samba.org
Return-path: <samba-technical-bounces@lists.samba.org>
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

From: Scott Lovenberg <scott.lovenberg@gmail.com>

MAX_SERVER_SIZE has been moved to cifs_mount.h and renamed
CIFS_NI_MAXHOST for clarity.  It has been expanded to 1024 as the
previous value of 16 was very short.

Signed-off-by: Scott Lovenberg <scott.lovenberg@gmail.com>
---
 fs/cifs/cifsglob.h                   | 3 +--
 include/uapi/linux/cifs/cifs_mount.h | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b07b122..2227699 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -42,8 +42,7 @@
 #define MAX_SES_INFO 2
 #define MAX_TCON_INFO 4
 
-#define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + CIFS_MAX_SHARE_LEN + 1)
-#define MAX_SERVER_SIZE 15
+#define MAX_TREE_SIZE (2 + CIFS_NI_MAXHOST + 1 + CIFS_MAX_SHARE_LEN + 1)
 
 #define CIFS_MIN_RCV_POOL 4
 
diff --git a/include/uapi/linux/cifs/cifs_mount.h b/include/uapi/linux/cifs/cifs_mount.h
index f7e4aee..a58fc6e 100644
--- a/include/uapi/linux/cifs/cifs_mount.h
+++ b/include/uapi/linux/cifs/cifs_mount.h
@@ -21,5 +21,6 @@
 #define CIFS_MAX_USERNAME_LEN   256 /* reasonable max for current servers */
 #define CIFS_MAX_PASSWORD_LEN   512 /* Windows max seems to be 256 wide chars */
 #define CIFS_MAX_SHARE_LEN      256 /* reasonable max share name length */
+#define CIFS_NI_MAXHOST        1024 /* max host name length */
 
 #endif /* _CIFS_MOUNT_H */
-- 
1.8.1.4
