From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 50/50] CIFS: Change Makefile to support CONFIG_CIFS_SMB2
Date: Fri, 20 Jan 2012 12:35:11 +0400
Message-ID: <1327048511-2342-50-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 005d524..0f72f14 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -15,3 +15,7 @@ cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
 cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
+
+cifs-$(CONFIG_CIFS_SMB2) += smb2pdu.o smb2misc.o smb2transport.o maperror.o \
+			    smb2inode.o smb2dir.o smb2file.o smb2readdir.o \
+			    smb2link.o
-- 
1.7.1
