From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/7] cifs: fix memory leak when password is supplied multiple
 times
Date: Wed, 20 Aug 2014 19:39:34 +0900
Message-ID: <003801cfbc63$08767980$19636c80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Shirish Pargaonkar' <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	'Pavel Shilovsky' <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: 'Steve French' <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-language: ko
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Unlikely but possible. When password is supplied multiple times, we have
to free the previous allocation.

Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 fs/cifs/connect.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b4b6d10..91512fd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1583,6 +1583,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 * Check if this is a case where the  password
 			 * starts with a delimiter
 			 */
+			kfree(vol->password);
 			tmp_end = strchr(data, '=');
 			tmp_end++;
 			if (!(tmp_end < end && tmp_end[1] == delim)) {
@@ -1624,6 +1625,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 					options = end;
 			}
 
+			kfree(vol->password);
 			/* Now build new password string */
 			temp_len = strlen(value);
 			vol->password = kzalloc(temp_len+1, GFP_KERNEL);
-- 
1.7.7
