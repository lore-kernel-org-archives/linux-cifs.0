From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 1/2] cifs: call strtobool instead of custom implementation
Date: Mon,  4 Mar 2013 11:41:05 +0200
Message-ID: <1362390066-4548-1-git-send-email-andriy.shevchenko@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/cifs/cifs_debug.c | 51 +++++++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index d9ea6ed..b2ddb4f 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -255,6 +255,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
+	bool bv;
 	int rc;
 	struct list_head *tmp1, *tmp2, *tmp3;
 	struct TCP_Server_Info *server;
@@ -265,7 +266,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 	if (rc)
 		return rc;
 
-	if (c == '1' || c == 'y' || c == 'Y' || c == '0') {
+	if (strtobool(&c, &bv) == 0) {
 #ifdef CONFIG_CIFS_STATS2
 		atomic_set(&totBufAllocCount, 0);
 		atomic_set(&totSmBufAllocCount, 0);
@@ -432,15 +433,14 @@ static ssize_t cifsFYI_proc_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
 	char c;
+	bool bv;
 	int rc;
 
 	rc = get_user(c, buffer);
 	if (rc)
 		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		cifsFYI = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		cifsFYI = 1;
+	if (strtobool(&c, &bv) == 0)
+		cifsFYI = bv;
 	else if ((c > '1') && (c <= '9'))
 		cifsFYI = (int) (c - '0'); /* see cifs_debug.h for meanings */
 
@@ -471,15 +471,18 @@ static ssize_t cifs_linux_ext_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
+	bool bv;
 	int rc;
 
 	rc = get_user(c, buffer);
 	if (rc)
 		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		linuxExtEnabled = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		linuxExtEnabled = 1;
+
+	rc = strtobool(&c, &bv);
+	if (rc)
+		return rc;
+
+	linuxExtEnabled = bv;
 
 	return count;
 }
@@ -508,15 +511,18 @@ static ssize_t cifs_lookup_cache_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
+	bool bv;
 	int rc;
 
 	rc = get_user(c, buffer);
 	if (rc)
 		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		lookupCacheEnabled = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		lookupCacheEnabled = 1;
+
+	rc = strtobool(&c, &bv);
+	if (rc)
+		return rc;
+
+	lookupCacheEnabled = bv;
 
 	return count;
 }
@@ -545,15 +551,18 @@ static ssize_t traceSMB_proc_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
 	char c;
+	bool bv;
 	int rc;
 
 	rc = get_user(c, buffer);
 	if (rc)
 		return rc;
-	if (c == '0' || c == 'n' || c == 'N')
-		traceSMB = 0;
-	else if (c == '1' || c == 'y' || c == 'Y')
-		traceSMB = 1;
+
+	rc = strtobool(&c, &bv);
+	if (rc)
+		return rc;
+
+	traceSMB = bv;
 
 	return count;
 }
@@ -584,6 +593,7 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	unsigned int flags;
 	char flags_string[12];
 	char c;
+	bool bv;
 
 	if ((count < 1) || (count > 11))
 		return -EINVAL;
@@ -596,11 +606,8 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	if (count < 3) {
 		/* single char or single char followed by null */
 		c = flags_string[0];
-		if (c == '0' || c == 'n' || c == 'N') {
-			global_secflags = CIFSSEC_DEF; /* default */
-			return count;
-		} else if (c == '1' || c == 'y' || c == 'Y') {
-			global_secflags = CIFSSEC_MAX;
+		if (strtobool(&c, &bv) == 0) {
+			global_secflags = bv ? CIFSSEC_MAX : CIFSSEC_DEF;
 			return count;
 		} else if (!isdigit(c)) {
 			cERROR(1, "invalid flag %c", c);
-- 
1.8.2.rc0.22.gb3600c3
