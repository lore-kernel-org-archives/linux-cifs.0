From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] cifs: Use ULL suffix for 64-bit constant
Date: Thu,  5 Apr 2018 14:57:11 +0200
Message-ID: <1522933031-25574-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 32-bit (e.g. with m68k-linux-gnu-gcc-4.1):

    fs/cifs/inode.c: In function ‘simple_hashstr’:
    fs/cifs/inode.c:713: warning: integer constant is too large for ‘long’ type

Fixes: 7ea884c77e5c97f1 ("smb3: Fix root directory when server returns inode number of zero")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/cifs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index f856df4adae3c8e8..3c371f7f5963e793 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -710,7 +710,7 @@ cifs_get_file_info(struct file *filp)
 /* Simple function to return a 64 bit hash of string.  Rarely called */
 static __u64 simple_hashstr(const char *str)
 {
-	const __u64 hash_mult =  1125899906842597L; /* a big enough prime */
+	const __u64 hash_mult =  1125899906842597ULL; /* a big enough prime */
 	__u64 hash = 0;
 
 	while (*str)
-- 
2.7.4
