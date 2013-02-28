From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH v3 1/7] fcntl: Introduce new O_DENY* open flags
Date: Thu, 28 Feb 2013 19:25:27 +0400
Message-ID: <1362065133-9490-2-git-send-email-piastry@etersoft.ru>
References: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, wine-devel@winehq.org
To: linux-kernel@vger.kernel.org
Return-path: <wine-devel-bounces@winehq.org>
In-Reply-To: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
List-Unsubscribe: <http://www.winehq.org/mailman/options/wine-devel>,
	<mailto:wine-devel-request@winehq.org?subject=unsubscribe>
List-Archive: <http://www.winehq.org/pipermail/wine-devel>
List-Post: <mailto:wine-devel@winehq.org>
List-Help: <mailto:wine-devel-request@winehq.org?subject=help>
List-Subscribe: <http://www.winehq.org/mailman/listinfo/wine-devel>,
	<mailto:wine-devel-request@winehq.org?subject=subscribe>
Sender: wine-devel-bounces@winehq.org
Errors-To: wine-devel-bounces@winehq.org
List-Id: linux-cifs.vger.kernel.org

This patch adds 4 flags:
1) O_DENYREAD that doesn't permit read access,
2) O_DENYWRITE that doesn't permit write access,
3) O_DENYDELETE that doesn't permit delete or rename,
4) O_DENYMAND that enables O_DENY* flags checks.

Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags -
this change can benefit cifs and nfs modules as well as Samba and
NFS file servers. These flags are only take affect for opens with
O_DENYMAND flags - there is no impact on native Linux opens.

Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
---
 fs/fcntl.c                       |  5 +++--
 include/uapi/asm-generic/fcntl.h | 14 ++++++++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 71a600a..d88a548 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -730,14 +730,15 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(19 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(23 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
-		__FMODE_EXEC	| O_PATH
+		__FMODE_EXEC	| O_PATH	| O_DENYREAD	|
+		O_DENYWRITE	| O_DENYDELETE	| O_DENYMAND
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index a48937d..6e4e979 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -84,6 +84,20 @@
 #define O_PATH		010000000
 #endif
 
+#ifndef O_DENYREAD
+#define O_DENYREAD	020000000	/* Do not permit read access */
+#endif
+#ifndef O_DENYWRITE
+#define O_DENYWRITE	040000000	/* Do not permit write access */
+#endif
+/* FMODE_NONOTIFY	0100000000 */
+#ifndef O_DENYDELETE
+#define O_DENYDELETE	0200000000	/* Do not permit delete or rename */
+#endif
+#ifndef O_DENYMAND
+#define O_DENYMAND	0400000000	/* Enable O_DENY flags checks */
+#endif
+
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
-- 
1.8.1.2
