From: Greg Thelen <gthelen@google.com>
Subject: [PATCH 4/5] cifs: smbd: depend on INFINIBAND_ADDR_TRANS
Date: Wed, 25 Apr 2018 15:34:12 -0700
Message-ID: <20180425223412.207127-1-gthelen@google.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        Tarick Bedeir <tarick@google.com>
To: Steve French <sfrench@samba.org>,
        Bart Van Assche <Bart.VanAssche@wdc.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

CIFS_SMB_DIRECT code depends on INFINIBAND_ADDR_TRANS provided symbols.
So declare the kconfig dependency.  This is necessary to allow for
enabling INFINIBAND without INFINIBAND_ADDR_TRANS.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Tarick Bedeir <tarick@google.com>
---
 fs/cifs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 741749a98614..5f132d59dfc2 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -197,7 +197,7 @@ config CIFS_SMB311
 
 config CIFS_SMB_DIRECT
 	bool "SMB Direct support (Experimental)"
-	depends on CIFS=m && INFINIBAND || CIFS=y && INFINIBAND=y
+	depends on CIFS=m && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=y && INFINIBAND=y && INFINIBAND_ADDR_TRANS=y
 	help
 	  Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1.
 	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
-- 
2.17.0.441.gb46fe60e1d-goog
