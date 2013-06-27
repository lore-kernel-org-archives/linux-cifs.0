From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix SMB2 signing enablement in cifs_enable_signing
Date: Thu, 27 Jun 2013 12:45:00 -0400
Message-ID: <1372351500-28197-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit 9ddec56131 (cifs: move handling of signed connections into
separate function) broke signing on SMB2/3 connections. While the code
to enable signing on the connections was very similar between the two,
the bits that get set in the sec_mode are different.

Declare a couple of new smb_version_values fields and set them
appropriately for SMB1 and SMB2/3. Then change cifs_enable_signing to
use those instead.

Reported-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h | 2 ++
 fs/cifs/cifssmb.c  | 4 ++--
 fs/cifs/smb1ops.c  | 2 ++
 fs/cifs/smb2ops.c  | 8 ++++++++
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b0f077e..e66b088 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -387,6 +387,8 @@ struct smb_version_values {
 	unsigned int	cap_nt_find;
 	unsigned int	cap_large_files;
 	unsigned int	oplock_read;
+	__u16		signing_enabled;
+	__u16		signing_required;
 };
 
 #define HEADER_SIZE(server) (server->vals->header_size)
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a35aad2..bc7dfa8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -407,8 +407,8 @@ decode_ext_sec_blob(struct cifs_ses *ses, NEGOTIATE_RSP *pSMBr)
 int
 cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
 {
-	bool srv_sign_required = server->sec_mode & SECMODE_SIGN_REQUIRED;
-	bool srv_sign_enabled = server->sec_mode & SECMODE_SIGN_ENABLED;
+	bool srv_sign_required = server->sec_mode & server->vals->signing_required;
+	bool srv_sign_enabled = server->sec_mode & server->vals->signing_enabled;
 	bool mnt_sign_enabled = global_secflags & CIFSSEC_MAY_SIGN;
 
 	/*
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index b28aabd..e813f04 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -957,4 +957,6 @@ struct smb_version_values smb1_values = {
 	.cap_nt_find = CAP_NT_SMBS | CAP_NT_FIND,
 	.cap_large_files = CAP_LARGE_FILES,
 	.oplock_read = OPLOCK_READ,
+	.signing_enabled = SECMODE_SIGN_ENABLED,
+	.signing_required = SECMODE_SIGN_REQUIRED,
 };
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 48fe7c4..6d15cab 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -729,6 +729,8 @@ struct smb_version_values smb20_values = {
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
 	.oplock_read = SMB2_OPLOCK_LEVEL_II,
+	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
 
 struct smb_version_values smb21_values = {
@@ -747,6 +749,8 @@ struct smb_version_values smb21_values = {
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
 	.oplock_read = SMB2_OPLOCK_LEVEL_II,
+	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
 
 struct smb_version_values smb30_values = {
@@ -765,6 +769,8 @@ struct smb_version_values smb30_values = {
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
 	.oplock_read = SMB2_OPLOCK_LEVEL_II,
+	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
 
 struct smb_version_values smb302_values = {
@@ -783,4 +789,6 @@ struct smb_version_values smb302_values = {
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
 	.oplock_read = SMB2_OPLOCK_LEVEL_II,
+	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
-- 
1.8.1.4
