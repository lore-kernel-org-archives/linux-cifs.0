From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v7 02/22] CIFS: SMBD: Introduce kernel config option CONFIG_CIFS_SMB_DIRECT
Date: Tue,  7 Nov 2017 01:54:54 -0700
Message-ID: <20171107085514.12693-3-longli@exchange.microsoft.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107085514.12693-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Build SMB Direct code when this option is set.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/Kconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index f724361..8d05fff 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -191,6 +191,14 @@ config CIFS_SMB311
 	  This dialect includes improved security negotiation features.
 	  If unsure, say N
 
+config CIFS_SMB_DIRECT
+	bool "SMB Direct support (Experimental)"
+	depends on CIFS && INFINIBAND
+	help
+	  Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1.
+	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
+	  say N.
+
 config CIFS_FSCACHE
 	  bool "Provide CIFS client caching support"
 	  depends on CIFS=m && FSCACHE || CIFS=y && FSCACHE=y
-- 
2.7.4
