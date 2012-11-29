From: Joe Perches <joe@perches.com>
Subject: [PATCH 3/3] cifs: Enable Kconfig control of CIFS_DEBUG
Date: Thu, 29 Nov 2012 11:37:20 -0800
Message-ID: <5f5c9196b44908026a27333ef31dd4ebf4314de2.1354217746.git.joe@perches.com>
References: <cover.1354217746.git.joe@perches.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1354217746.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Rather than havign a permanently enabled #define, allow
control over it.

This can reduce the size of the module by ~100KB which
could be useful for embedded systems.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/cifs/Kconfig      |   10 +++++++++-
 fs/cifs/cifs_debug.h |    5 ++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 2075ddf..21ff76c 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -122,9 +122,17 @@ config CIFS_ACL
 	    Allows fetching CIFS/NTFS ACL from the server.  The DACL blob
 	    is handed over to the application/caller.
 
+config CIFS_DEBUG
+	bool "Enable CIFS debugging routines"
+	default y
+	depends on CIFS
+	help
+	   Enabling this option adds helpful debugging messages to
+	   the cifs code which increases the size of the cifs module.
+	   If unsure, say Y.
 config CIFS_DEBUG2
 	bool "Enable additional CIFS debugging routines"
-	depends on CIFS
+	depends on CIFS_DEBUG
 	help
 	   Enabling this option adds a few more debugging routines
 	   to the cifs code which slightly increases the size of
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 4d12fe4..6867a7f 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -18,7 +18,10 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
 */
-#define CIFS_DEBUG		/* BB temporary */
+
+#ifdef CONFIG_CIFS_DEBUG
+#define CIFS_DEBUG
+#endif
 
 #ifndef _H_CIFS_DEBUG
 #define _H_CIFS_DEBUG
-- 
1.7.8.112.g3fd21
