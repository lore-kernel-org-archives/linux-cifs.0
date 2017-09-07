From: shuwang@redhat.com
Subject: [PATCH] cifs: release cifs root_cred after exit_cifs
Date: Thu,  7 Sep 2017 16:03:27 +0800
Message-ID: <20170907080327.21390-1-shuwang@redhat.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, chuhu@redhat.com, liwang@redhat.com,
        Shu Wang <shuwang@redhat.com>
To: sfrench@samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Shu Wang <shuwang@redhat.com>

memory leak was found by kmemleak. exit_cifs_spnego
should be called before cifs module removed, or
cifs root_cred will not be released.

kmemleak report:
unreferenced object 0xffff880070a3ce40 (size 192):
  backtrace:
     kmemleak_alloc+0x4a/0xa0
     kmem_cache_alloc+0xc7/0x1d0
     prepare_kernel_cred+0x20/0x120
     init_cifs_spnego+0x2d/0x170 [cifs]
     0xffffffffc07801f3
     do_one_initcall+0x51/0x1b0
     do_init_module+0x60/0x1fd
     load_module+0x161e/0x1b60
     SYSC_finit_module+0xa9/0x100
     SyS_finit_module+0xe/0x10

Signed-off-by: Shu Wang <shuwang@redhat.com>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 180b3356ff86..a92bdb89bde3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1447,7 +1447,7 @@ exit_cifs(void)
 	exit_cifs_idmap();
 #endif
 #ifdef CONFIG_CIFS_UPCALL
-	unregister_key_type(&cifs_spnego_key_type);
+	exit_cifs_spnego();
 #endif
 	cifs_destroy_request_bufs();
 	cifs_destroy_mids();
-- 
2.13.5
