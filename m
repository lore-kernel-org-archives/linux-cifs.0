From: Tobias Regnery <tobias.regnery@gmail.com>
Subject: [PATCH] CIFS: Fix build failure with smb2
Date: Thu, 30 Mar 2017 12:34:14 +0200
Message-ID: <20170330103414.19972-1-tobias.regnery@gmail.com>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
To: sfrench@samba.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

I saw the following build error during a randconfig build:

fs/cifs/smb2ops.c: In function 'smb2_new_lease_key':
fs/cifs/smb2ops.c:1104:2: error: implicit declaration of function 'generate_random_uuid' [-Werror=implicit-function-declaration]

Explicit include the right header to fix this issue.

Signed-off-by: Tobias Regnery <tobias.regnery@gmail.com>
---
This is against next-20170330

 fs/cifs/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c6d14cc44510..c1b70559496c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -21,6 +21,7 @@
 #include <linux/vfs.h>
 #include <linux/falloc.h>
 #include <linux/scatterlist.h>
+#include <linux/uuid.h>
 #include <crypto/aead.h>
 #include "cifsglob.h"
 #include "smb2pdu.h"
-- 
2.11.0
