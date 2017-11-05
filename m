From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v6 02/22] CIFS: SMBD: Introduce kernel config option CONFIG_CIFS_SMB_DIRECT
Date: Sat,  4 Nov 2017 22:43:44 -0700
Message-ID: <20171105054404.23886-3-longli@exchange.microsoft.com>
References: <20171105054404.23886-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171105054404.23886-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

SMB Direct is a protocol for transferring SMB packets over RDMA. It was
introduced with Windows Serer 2012 and SMB 3.0.

With CONFIG_CIFS_SMB_DIRECT=y, SMB Direct code is built as part of CIFS.

Signed-off-by: Long Li <longli@microsoft.com>
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
