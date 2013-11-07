From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: change ERRnomem error mapping from ENOMEM to EREMOTEIO
Date: Thu,  7 Nov 2013 15:02:35 -0500
Message-ID: <1383854555-12043-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sometimes, the server will report an error that basically indicates
that it's running out of resources. These include these under SMB1:

NT_STATUS_NO_MEMORY
NT_STATUS_SECTION_TOO_BIG
NT_STATUS_TOO_MANY_PAGING_FILES

...and this one under SMB2:

STATUS_NO_MEMORY

Currently, this gets mapped to ENOMEM by the client, but that's
confusing as an ENOMEM error is typically an indicator that the
client is out of memory.

Change these errors to instead map to EREMOTEIO to indicate that
the problem is actually server-side and not on the client.

Reported-by: "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/netmisc.c      | 2 +-
 fs/cifs/smb2maperror.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 651a527..0498845 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -51,7 +51,7 @@ static const struct smb_to_posix_error mapping_table_ERRDOS[] = {
 	{ERRnoaccess, -EACCES},
 	{ERRbadfid, -EBADF},
 	{ERRbadmcb, -EIO},
-	{ERRnomem, -ENOMEM},
+	{ERRnomem, -EREMOTEIO},
 	{ERRbadmem, -EFAULT},
 	{ERRbadenv, -EFAULT},
 	{ERRbadformat, -EINVAL},
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 7c2f45c..94bd4fb 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -306,7 +306,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_NONEXISTENT_SECTOR, -EIO, "STATUS_NONEXISTENT_SECTOR"},
 	{STATUS_MORE_PROCESSING_REQUIRED, -EIO,
 	"STATUS_MORE_PROCESSING_REQUIRED"},
-	{STATUS_NO_MEMORY, -ENOMEM, "STATUS_NO_MEMORY"},
+	{STATUS_NO_MEMORY, -EREMOTEIO, "STATUS_NO_MEMORY"},
 	{STATUS_CONFLICTING_ADDRESSES, -EADDRINUSE,
 	"STATUS_CONFLICTING_ADDRESSES"},
 	{STATUS_NOT_MAPPED_VIEW, -EIO, "STATUS_NOT_MAPPED_VIEW"},
-- 
1.8.3.1
