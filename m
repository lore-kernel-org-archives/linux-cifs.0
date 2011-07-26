From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix name parsing in CIFSSMBQAllEAs
Date: Tue, 26 Jul 2011 15:03:20 -0400
Message-ID: <1311707000-4071-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The code that matches EA names in CIFSSMBQAllEAs is incorrect. It
uses strncmp to do the comparison with the length limited to the
name_len sent in the response.

Problem: Suppose we're looking for an attribute named "foobar" and
have an attribute before it in the EA list named "foo". The
comparison will succeed since we're only looking at the first 3
characters. Fix this by also comparing the length of the provided
ea_name with the name_len in the response. If they're not equal then
it shouldn't match.

Reported-by: Jian Li <jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c101775..ec796fc 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5720,6 +5720,7 @@ CIFSSMBQAllEAs(const int xid, struct cifs_tcon *tcon,
 	char *temp_ptr;
 	char *end_of_smb;
 	__u16 params, byte_count, data_offset;
+	unsigned int ea_name_len;
 
 	cFYI(1, "In Query All EAs path %s", searchName);
 QAllEAsRetry:
@@ -5814,6 +5815,10 @@ QAllEAsRetry:
 	list_len -= 4;
 	temp_fea = ea_response_data->list;
 	temp_ptr = (char *)temp_fea;
+
+	if (ea_name)
+		ea_name_len = strlen(ea_name);
+
 	while (list_len > 0) {
 		unsigned int name_len;
 		__u16 value_len;
@@ -5837,7 +5842,8 @@ QAllEAsRetry:
 		}
 
 		if (ea_name) {
-			if (strncmp(ea_name, temp_ptr, name_len) == 0) {
+			if (ea_name_len == name_len &&
+			    strncmp(ea_name, temp_ptr, name_len) == 0) {
 				temp_ptr += name_len + 1;
 				rc = value_len;
 				if (buf_size == 0)
-- 
1.7.6
