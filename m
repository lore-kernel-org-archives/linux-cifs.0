From: Rodrigo Freire <rfreire@redhat.com>
Subject: [PATCH v3 1/2] CIFS: Adds information-level logging function
Date: Sun,  7 Oct 2018 12:21:25 -0300
Message-ID: <3e9246011e68c3ebeea111c8bb743d1a189ce6ac.1538873915.git.rfreire@redhat.com>
References: <cover.1538873915.git.rfreire@redhat.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, piastryyy@gmail.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538873915.git.rfreire@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Currently, CIFS lacks a internal logging function that prints out data
when CIFS_DEBUG=n. When CIFS_DEBUG=y, the only message level for CIFS
events are KERN_ERR or KERN_DEBUG.

This patch creates cifs_info(), which is useful for printing
non-critical event messges, at either CIFS_DEBUG state.

Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
---
 fs/cifs/cifs_debug.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index f4f3f08..72db298 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -47,6 +47,17 @@
  */
 #ifdef CONFIG_CIFS_DEBUG
 
+/* Information level messages, minor events */
+#define cifs_info_func(ratefunc, fmt, ...)			\
+do {								\
+	pr_info_ ## ratefunc("CIFS: " fmt, ##__VA_ARGS__); 	\
+} while (0)
+
+#define cifs_info(fmt, ...)					\
+do { 								\
+	cifs_info_func(ratelimited, fmt, ##__VA_ARGS__); 	\
+} while (0)
+
 /* information message: e.g., configuration, major event */
 #define cifs_dbg_func(ratefunc, type, fmt, ...)			\
 do {								\
@@ -81,6 +92,11 @@
 	if (0)								\
 		pr_debug(fmt, ##__VA_ARGS__);				\
 } while (0)
+
+#define cifs_info(fmt, ...)						\
+do {									\
+	pr_info("CIFS: "fmt, ##__VA_ARGS__);				\
+} while (0)
 #endif
 
 #endif				/* _H_CIFS_DEBUG */
-- 
1.8.3.1
