From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/3] cifs: Remove unused cEVENT macro
Date: Thu, 29 Nov 2012 11:37:18 -0800
Message-ID: <7176cb20d420849d72aa004e40a404049362da7f.1354217746.git.joe@perches.com>
References: <cover.1354217746.git.joe@perches.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1354217746.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

It uses an undefined KERN_EVENT and is itself unused.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/cifs/cifs_debug.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index c0c68bb..b0fc344 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -63,12 +63,6 @@ do {						\
 /* debug event message: */
 extern int cifsERROR;
 
-#define cEVENT(fmt, arg...)						\
-do {									\
-	if (cifsERROR)							\
-		printk(KERN_EVENT "%s: " fmt "\n", __FILE__, ##arg);	\
-} while (0)
-
 /* error event message: e.g., i/o error */
 #define cifserror(fmt, arg...)					\
 do {								\
@@ -88,7 +82,6 @@ do {						\
  */
 #else		/* _CIFS_DEBUG */
 #define cERROR(set, fmt, arg...)
-#define cEVENT(fmt, arg...)
 #define cFYI(set, fmt, arg...)
 #define cifserror(fmt, arg...)
 #endif		/* _CIFS_DEBUG */
-- 
1.7.8.112.g3fd21
