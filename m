From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH -next] cifs: fix build errors for SMB_DIRECT
Date: Tue, 2 Jan 2018 09:43:10 -0800
Message-ID: <23f1bd9a-8c16-5893-e23e-ca1c04c80bad@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Prevent build errors when CIFS=y and INFINIBAND=m.

fs/cifs/smbdirect.o: In function `smbd_qp_async_error_upcall':
smbdirect.c:(.text+0x28c): undefined reference to `ib_event_msg'
fs/cifs/smbdirect.o: In function `smbd_destroy_rdma_work':
smbdirect.c:(.text+0xfde): undefined reference to `ib_drain_qp'
smbdirect.c:(.text+0xfea): undefined reference to `rdma_destroy_qp'
smbdirect.c:(.text+0x12a0): undefined reference to `ib_free_cq'
smbdirect.c:(.text+0x12ac): undefined reference to `ib_free_cq'
smbdirect.c:(.text+0x12b8): undefined reference to `ib_dealloc_pd'
smbdirect.c:(.text+0x12c4): undefined reference to `rdma_destroy_id'
fs/cifs/smbdirect.o: In function `_smbd_get_connection':
smbdirect.c:(.text+0x168c): undefined reference to `rdma_create_id'
smbdirect.c:(.text+0x1713): undefined reference to `rdma_resolve_addr'
smbdirect.c:(.text+0x1780): undefined reference to `rdma_resolve_route'
smbdirect.c:(.text+0x17e3): undefined reference to `rdma_destroy_id'
smbdirect.c:(.text+0x183d): undefined reference to `rdma_destroy_id'
smbdirect.c:(.text+0x199d): undefined reference to `ib_alloc_cq'
smbdirect.c:(.text+0x19d9): undefined reference to `ib_alloc_cq'
smbdirect.c:(.text+0x1a89): undefined reference to `rdma_create_qp'
smbdirect.c:(.text+0x1b3c): undefined reference to `rdma_connect'
smbdirect.c:(.text+0x2538): undefined reference to `rdma_destroy_qp'
smbdirect.c:(.text+0x2549): undefined reference to `ib_free_cq'
smbdirect.c:(.text+0x255a): undefined reference to `ib_free_cq'
smbdirect.c:(.text+0x2563): undefined reference to `ib_dealloc_pd'
smbdirect.c:(.text+0x256c): undefined reference to `rdma_destroy_id'
smbdirect.c:(.text+0x25f0): undefined reference to `__ib_alloc_pd'
smbdirect.c:(.text+0x26bb): undefined reference to `rdma_disconnect'
fs/cifs/smbdirect.o: In function `smbd_disconnect_rdma_work':
smbdirect.c:(.text+0x62): undefined reference to `rdma_disconnect'

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc:	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc:	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc:	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org (moderated for non-subscribers)
---
 fs/cifs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20180102.orig/fs/cifs/Kconfig
+++ linux-next-20180102/fs/cifs/Kconfig
@@ -197,7 +197,7 @@ config CIFS_SMB311
 
 config CIFS_SMB_DIRECT
 	bool "SMB Direct support (Experimental)"
-	depends on CIFS && INFINIBAND
+	depends on CIFS=m && INFINIBAND || CIFS=y && INFINIBAND=y
 	help
 	  Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1.
 	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
