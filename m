From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 07/32] CIFS: Rename 7 error codes to NT_ style
Date: Fri, 13 Jul 2012 11:53:20 +0400
Message-ID: <1342166025-29377-8-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and consider such codes as CIFS errors.

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/nterr.c |    6 +++---
 fs/cifs/nterr.h |   26 ++++++++++++++------------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/nterr.c b/fs/cifs/nterr.c
index 819fd99..b6023c6 100644
--- a/fs/cifs/nterr.c
+++ b/fs/cifs/nterr.c
@@ -31,7 +31,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_INVALID_INFO_CLASS", NT_STATUS_INVALID_INFO_CLASS},
 	{"NT_STATUS_INFO_LENGTH_MISMATCH", NT_STATUS_INFO_LENGTH_MISMATCH},
 	{"NT_STATUS_ACCESS_VIOLATION", NT_STATUS_ACCESS_VIOLATION},
-	{"STATUS_BUFFER_OVERFLOW", STATUS_BUFFER_OVERFLOW},
+	{"NT_STATUS_BUFFER_OVERFLOW", NT_STATUS_BUFFER_OVERFLOW},
 	{"NT_STATUS_IN_PAGE_ERROR", NT_STATUS_IN_PAGE_ERROR},
 	{"NT_STATUS_PAGEFILE_QUOTA", NT_STATUS_PAGEFILE_QUOTA},
 	{"NT_STATUS_INVALID_HANDLE", NT_STATUS_INVALID_HANDLE},
@@ -681,7 +681,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	 NT_STATUS_QUOTA_LIST_INCONSISTENT},
 	{"NT_STATUS_FILE_IS_OFFLINE", NT_STATUS_FILE_IS_OFFLINE},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
-	{"STATUS_MORE_ENTRIES", STATUS_MORE_ENTRIES},
-	{"STATUS_SOME_UNMAPPED", STATUS_SOME_UNMAPPED},
+	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
+	{"NT_STATUS_SOME_UNMAPPED", NT_STATUS_SOME_UNMAPPED},
 	{NULL, 0}
 };
diff --git a/fs/cifs/nterr.h b/fs/cifs/nterr.h
index 2572673..7a0eae5 100644
--- a/fs/cifs/nterr.h
+++ b/fs/cifs/nterr.h
@@ -35,18 +35,20 @@ struct nt_err_code_struct {
 extern const struct nt_err_code_struct nt_errs[];
 
 /* Win32 Status codes. */
-#define STATUS_MORE_ENTRIES               0x0105
-#define ERROR_INVALID_PARAMETER		  0x0057
-#define ERROR_INSUFFICIENT_BUFFER	  0x007a
-#define STATUS_1804	                  0x070c
-#define STATUS_NOTIFY_ENUM_DIR            0x010c
+#define NT_STATUS_MORE_ENTRIES         0x0105
+#define NT_ERROR_INVALID_PARAMETER     0x0057
+#define NT_ERROR_INSUFFICIENT_BUFFER   0x007a
+#define NT_STATUS_1804                 0x070c
+#define NT_STATUS_NOTIFY_ENUM_DIR      0x010c
 
-/* Win32 Error codes extracted using a loop in smbclient then printing a
-   netmon sniff to a file. */
+/*
+ * Win32 Error codes extracted using a loop in smbclient then printing a netmon
+ * sniff to a file.
+ */
 
-#define NT_STATUS_OK 0x0000
-#define STATUS_SOME_UNMAPPED       0x0107
-#define STATUS_BUFFER_OVERFLOW     0x80000005
+#define NT_STATUS_OK                   0x0000
+#define NT_STATUS_SOME_UNMAPPED        0x0107
+#define NT_STATUS_BUFFER_OVERFLOW  0x80000005
 #define NT_STATUS_NO_MORE_ENTRIES  0x8000001a
 #define NT_STATUS_MEDIA_CHANGED    0x8000001c
 #define NT_STATUS_END_OF_MEDIA     0x8000001e
-- 
1.7.1
