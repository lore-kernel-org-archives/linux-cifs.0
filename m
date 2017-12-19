From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
Date: Tue, 19 Dec 2017 11:12:57 +0100
Message-ID: <20171219101327.2165797-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Jean Delvare <jdelvare@suse.de>,
        Long Li <longli@microsoft.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

A built-in SMB file system cannot link against a modular
infiniband core module:

fs/cifs/smbdirect.o: In function `smbd_destroy_rdma_work':
smbdirect.c:(.text+0x28e3): undefined reference to `ib_drain_qp'
smbdirect.c:(.text+0x2915): undefined reference to `rdma_destroy_qp'
smbdirect.c:(.text+0x2d08): undefined reference to `ib_free_cq'
smbdirect.c:(.text+0x2d3d): undefined reference to `ib_free_cq'
smbdirect.c:(.text+0x2d6f): undefined reference to `ib_dealloc_pd'
smbdirect.c:(.text+0x2d9a): undefined reference to `rdma_destroy_id'
fs/cifs/smbdirect.o: In function `smbd_disconnect_rdma_work':
smbdirect.c:(.text+0x3d3e): undefined reference to `rdma_disconnect'
fs/cifs/smbdirect.o: In function `_smbd_get_connection':
smbdirect.c:(.text+0x5bc2): undefined reference to `rdma_create_id'
smbdirect.c:(.text+0x5cc5): undefined reference to `rdma_resolve_addr'
smbdirect.c:(.text+0x5cda): undefined reference to `rdma_destroy_id'
smbdirect.c:(.text+0x5da7): undefined reference to `rdma_destroy_id'
smbdirect.c:(.text+0x5e89): undefined reference to `rdma_resolve_route'
smbdirect.c:(.text+0x5f07): undefined reference to `rdma_destroy_id'

This changes the Kconfig dependency to enforce selecting one of the
valid configurations.

Fixes: bbc50d2ad317 ("CIFS: SMBD: Introduce kernel config option CONFIG_CIFS_SMB_DIRECT")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cifs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 500fd69fb58b..3bfc55c08bef 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -199,6 +199,7 @@ config CIFS_SMB311
 config CIFS_SMB_DIRECT
 	bool "SMB Direct support (Experimental)"
 	depends on CIFS && INFINIBAND
+	depends on CIFS=m || INFINIBAND=y
 	help
 	  Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1.
 	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
-- 
2.9.0
