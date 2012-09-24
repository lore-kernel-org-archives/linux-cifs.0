From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: change DOS/NT/POSIX mapping of ERRnoresource
Date: Mon, 24 Sep 2012 09:33:40 -0400
Message-ID: <1348493620-1887-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

ERRnoresource is an ERRSRV level (aka server-side) error and means "No
resources currently available for request". Currently that maps to POSIX
-ENOBUFS. No NT errors map to it currently.

NT_STATUS_INSUFFICIENT_RESOURCES and NT_STATUS_INSUFF_SERVER_RESOURCES
are also similar in meaning. Currently the client maps those to
ERRnomem, which maps to -ENOMEM in POSIX.

All of these mappings seem to be quite wrong to me and are confusing for
users. All of the above errors indicate problems on the server, not the
client. Reporting -ENOMEM or -ENOBUFS implies that the client is running
out of resources.

This patch changes those mappings. The NT_* errors are changed to map to
the SRV level ERRnoresource. That error is in turn changed to return
-EREMOTEIO which is the only POSIX error I could find that conveys that
something went wrong on the server. While we're at it, change the SMB2
equivalent error to return the same.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/netmisc.c      | 6 +++---
 fs/cifs/smb2maperror.c | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index e7bab3b..d5ce9e2 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -110,7 +110,7 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{ERRnoroom, -ENOSPC},
 	{ERRrmuns, -EUSERS},
 	{ERRtimeout, -ETIME},
-	{ERRnoresource, -ENOBUFS},
+	{ERRnoresource, -EREMOTEIO},
 	{ERRtoomanyuids, -EUSERS},
 	{ERRbaduid, -EACCES},
 	{ERRusempx, -EIO},
@@ -412,7 +412,7 @@ static const struct {
 	 from NT_STATUS_INSUFFICIENT_RESOURCES to
 	 NT_STATUS_INSUFF_SERVER_RESOURCES during the session setup } */
 	{
-	ERRDOS, ERRnomem, NT_STATUS_INSUFFICIENT_RESOURCES}, {
+	ERRDOS, ERRnoresource, NT_STATUS_INSUFFICIENT_RESOURCES}, {
 	ERRDOS, ERRbadpath, NT_STATUS_DFS_EXIT_PATH_FOUND}, {
 	ERRDOS, 23, NT_STATUS_DEVICE_DATA_ERROR}, {
 	ERRHRD, ERRgeneral, NT_STATUS_DEVICE_NOT_CONNECTED}, {
@@ -682,7 +682,7 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_NO_USER_SESSION_KEY}, {
 	ERRDOS, 59, NT_STATUS_USER_SESSION_DELETED}, {
 	ERRHRD, ERRgeneral, NT_STATUS_RESOURCE_LANG_NOT_FOUND}, {
-	ERRDOS, ERRnomem, NT_STATUS_INSUFF_SERVER_RESOURCES}, {
+	ERRDOS, ERRnoresource, NT_STATUS_INSUFF_SERVER_RESOURCES}, {
 	ERRHRD, ERRgeneral, NT_STATUS_INVALID_BUFFER_SIZE}, {
 	ERRHRD, ERRgeneral, NT_STATUS_INVALID_ADDRESS_COMPONENT}, {
 	ERRHRD, ERRgeneral, NT_STATUS_INVALID_ADDRESS_WILDCARD}, {
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index eaf5466..494c912 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -453,7 +453,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_FILE_INVALID, -EIO, "STATUS_FILE_INVALID"},
 	{STATUS_ALLOTTED_SPACE_EXCEEDED, -EIO,
 	"STATUS_ALLOTTED_SPACE_EXCEEDED"},
-	{STATUS_INSUFFICIENT_RESOURCES, -EIO, "STATUS_INSUFFICIENT_RESOURCES"},
+	{STATUS_INSUFFICIENT_RESOURCES, -EREMOTEIO,
+				"STATUS_INSUFFICIENT_RESOURCES"},
 	{STATUS_DFS_EXIT_PATH_FOUND, -EIO, "STATUS_DFS_EXIT_PATH_FOUND"},
 	{STATUS_DEVICE_DATA_ERROR, -EIO, "STATUS_DEVICE_DATA_ERROR"},
 	{STATUS_DEVICE_NOT_CONNECTED, -EIO, "STATUS_DEVICE_NOT_CONNECTED"},
-- 
1.7.11.4
