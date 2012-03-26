From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 01/16] CIFS: Introduce SMB2 Kconfig option
Date: Mon, 26 Mar 2012 13:21:28 +0400
Message-ID: <1332753703-4315-2-git-send-email-piastry@etersoft.ru>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
Cc: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332753703-4315-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

SMB2 is the followon to the CIFS (and SMB) protocols
and the default for Windows since Windows Vista, and also
now implemented by various non-Windows servers. SMB2
is more secure, has various performance advantages, including
larger i/o sizes, flow control, better caching model and more.
SMB2 also resolves some scalability limits in the CIFS
protocol and adds many new features while being much
simpler (only a few dozen commands instead of hundreds)
and since the protocol is clearer it is also more consistently
implemented across servers and thus easier to optimize.

After much discussion with Jeff Layton, Jeremy Allison
and others at Connectathon, we decided to move the SMB2
code from a distinct .ko and fstype into distinct
C files that optionally build in cifs.ko. As a result
the Kconfig gets simpler.

To avoid destabilizing CIFS, the SMB2 code is going
to be moved into its own experimental CONFIG_CIFS_SMB2 ifdef
as it is merged and rereviewed. The changes to stable
CIFS (builds with the SMB2 ifdef off) are expected to be
fairly small.

Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/Kconfig |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 2b243af..a08306a 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -158,3 +158,23 @@ config CIFS_NFSD_EXPORT
 	  depends on CIFS && EXPERIMENTAL && BROKEN
 	  help
 	   Allows NFS server to export a CIFS mounted share (nfsd over cifs)
+
+config CIFS_SMB2
+	bool "SMB2 network file system support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && INET && BROKEN
+	select NLS
+	select KEYS
+	select FSCACHE
+	select DNS_RESOLVER
+
+	help
+	  This enables experimental support for the SMB2 (Server Message Block
+	  version 2) protocol. The SMB2 protocol is the successor to the
+	  popular CIFS and SMB network file sharing protocols. SMB2 is the
+	  native file sharing mechanism for recent versions of Windows
+	  operating systems (since Vista).  SMB2 enablement will eventually
+	  allow users better performance, security and features, than would be
+	  possible with cifs. Note that smb2 mount options also are simpler
+	  (compared to cifs) due to protocol improvements.
+
+	  Unless you are a developer or tester, say N.
-- 
1.7.1
