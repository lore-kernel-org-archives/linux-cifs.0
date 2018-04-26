From: Greg Thelen <gthelen@google.com>
Subject: [PATCH 1/6] nvme: depend on INFINIBAND_ADDR_TRANS
Date: Thu, 26 Apr 2018 11:19:30 -0700
Message-ID: <20180426181935.32977-2-gthelen@google.com>
References: <20180426181935.32977-1-gthelen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Tarick Bedeir <tarick@google.com>
To: Bart.VanAssche@wdc.com, hch@lst.de, dledford@redhat.com,
        jgg@ziepe.ca, axboe@fb.com, keith.busch@intel.com,
        sagi@grimberg.me, sfrench@samba.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, gthelen@google.com, tarick@google.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426181935.32977-1-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

NVME_RDMA code depends on INFINIBAND_ADDR_TRANS provided symbols.  So
declare the kconfig dependency.  This is necessary to allow for enabling
INFINIBAND without INFINIBAND_ADDR_TRANS.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Tarick Bedeir <tarick@google.com>
---
 drivers/nvme/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index b979cf3bce65..88a8b5916624 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -27,7 +27,7 @@ config NVME_FABRICS
 
 config NVME_RDMA
 	tristate "NVM Express over Fabrics RDMA host driver"
-	depends on INFINIBAND && BLOCK
+	depends on INFINIBAND && INFINIBAND_ADDR_TRANS && BLOCK
 	select NVME_CORE
 	select NVME_FABRICS
 	select SG_POOL
-- 
2.17.0.484.g0c8726318c-goog
