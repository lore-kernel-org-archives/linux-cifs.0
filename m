From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2
Date: Fri, 18 Jul 2014 18:50:22 +0400
Message-ID: <1405695022-2934-1-git-send-email-pshilovsky@samba.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The existing mapping causes unlink() call to return error after delete
operation. Changing the mapping to -EACCESS makes the client process
the call like CIFS protocol does - reset dos attributes with ATTR_READONLY
flag masked off and retry the operation.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2maperror.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 94bd4fb..e31a9df 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -605,7 +605,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_MAPPED_FILE_SIZE_ZERO, -EIO, "STATUS_MAPPED_FILE_SIZE_ZERO"},
 	{STATUS_TOO_MANY_OPENED_FILES, -EMFILE, "STATUS_TOO_MANY_OPENED_FILES"},
 	{STATUS_CANCELLED, -EIO, "STATUS_CANCELLED"},
-	{STATUS_CANNOT_DELETE, -EIO, "STATUS_CANNOT_DELETE"},
+	{STATUS_CANNOT_DELETE, -EACCES, "STATUS_CANNOT_DELETE"},
 	{STATUS_INVALID_COMPUTER_NAME, -EIO, "STATUS_INVALID_COMPUTER_NAME"},
 	{STATUS_FILE_DELETED, -EIO, "STATUS_FILE_DELETED"},
 	{STATUS_SPECIAL_ACCOUNT, -EIO, "STATUS_SPECIAL_ACCOUNT"},
-- 
1.8.1.2
