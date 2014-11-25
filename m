From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] cifs: remove unneeded condition check
Date: Tue, 25 Nov 2014 16:52:48 +0900
Message-ID: <001201d00884$ce584120$6b08c360$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-language: ko
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

file->private_data can never be null after calling initiate_cifs_search.
So private null check condition is not needed.

Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 fs/cifs/readdir.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index d116ca8..8eaf20a 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -794,10 +794,6 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		if it before then restart search
 		if after then keep searching till find it */
 
-	if (file->private_data == NULL) {
-		rc = -EINVAL;
-		goto rddir2_exit;
-	}
 	cifsFile = file->private_data;
 	if (cifsFile->srch_inf.endOfSearch) {
 		if (cifsFile->srch_inf.emptyDir) {
-- 
1.7.11-rc0
