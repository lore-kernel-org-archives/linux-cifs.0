From: Greg Thelen <gthelen@google.com>
Subject: [PATCH 5/6] ib_srp: depend on INFINIBAND_ADDR_TRANS
Date: Thu, 26 Apr 2018 11:19:34 -0700
Message-ID: <20180426181935.32977-6-gthelen@google.com>
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

INFINIBAND_SRP code depends on INFINIBAND_ADDR_TRANS provided symbols.
So declare the kconfig dependency.  This is necessary to allow for
enabling INFINIBAND without INFINIBAND_ADDR_TRANS.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Tarick Bedeir <tarick@google.com>
---
 drivers/infiniband/ulp/srp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/Kconfig b/drivers/infiniband/ulp/srp/Kconfig
index c74ee9633041..99db8fe5173a 100644
--- a/drivers/infiniband/ulp/srp/Kconfig
+++ b/drivers/infiniband/ulp/srp/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_SRP
 	tristate "InfiniBand SCSI RDMA Protocol"
-	depends on SCSI
+	depends on SCSI && INFINIBAND_ADDR_TRANS
 	select SCSI_SRP_ATTRS
 	---help---
 	  Support for the SCSI RDMA Protocol over InfiniBand.  This
-- 
2.17.0.484.g0c8726318c-goog
