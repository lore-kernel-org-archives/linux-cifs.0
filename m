From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 03/44] cifs: fix return value for cifs_listxattr
Date: Tue, 13 Nov 2018 00:49:09 -0500
Message-ID: <20181113054950.77898-3-sashal@kernel.org>
References: <20181113054950.77898-1-sashal@kernel.org>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181113054950.77898-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 0c5d6cb6643f48ad3775322f3ebab6c7eb67484e ]

If the application buffer was too small to fit all the names
we would still count the number of bytes and return this for
listxattr. This would then trigger a BUG in usercopy.c

Fix the computation of the size so that we return -ERANGE
correctly when the buffer is too small.

This fixes the kernel BUG for xfstest generic/377

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 89985a0a6819..812da3e56a22 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -686,6 +686,7 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 	int rc = 0;
 	unsigned int ea_name_len = ea_name ? strlen(ea_name) : 0;
 	char *name, *value;
+	size_t buf_size = dst_size;
 	size_t name_len, value_len, user_name_len;
 
 	while (src_size > 0) {
@@ -721,9 +722,10 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 			/* 'user.' plus a terminating null */
 			user_name_len = 5 + 1 + name_len;
 
-			rc += user_name_len;
-
-			if (dst_size >= user_name_len) {
+			if (buf_size == 0) {
+				/* skip copy - calc size only */
+				rc += user_name_len;
+			} else if (dst_size >= user_name_len) {
 				dst_size -= user_name_len;
 				memcpy(dst, "user.", 5);
 				dst += 5;
@@ -731,8 +733,7 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 				dst += name_len;
 				*dst = 0;
 				++dst;
-			} else if (dst_size == 0) {
-				/* skip copy - calc size only */
+				rc += user_name_len;
 			} else {
 				/* stop before overrun buffer */
 				rc = -ERANGE;
-- 
2.17.1
