From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: re-add NULL pointer check in cifs_save_resume_key
Date: Tue, 15 Nov 2011 06:24:58 -0500
Message-ID: <1321356298-22132-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
	adamgmetzler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Prior to commit eaf35b1, cifs_save_resume_key had some NULL pointer
checks at the top. It turns out that at least one of those NULL
pointer checks is needed after all.

When the LastNameOffset in a FIND reply appears to be beyond the end of
the buffer, CIFSFindFirst and CIFSFindNext will set srch_inf.last_entry
to NULL. Since eaf35b1, the code will now oops in this situation.

This patch just readds the NULL pointer check for file_info in
cifs_save_resume_key to prevent the code from oopsing.

This should fix:

    https://bugzilla.redhat.com/show_bug.cgi?id=750247

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Reported-by: Adam G. Metzler <adamgmetzler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/readdir.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 5de03ec..4fcb6f5 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -483,6 +483,9 @@ static int cifs_save_resume_key(const char *current_entry,
 	struct cifs_dirent de;
 	int rc;
 
+	if (!file_info)
+		return -EINVAL;
+
 	rc = cifs_fill_dirent(&de, current_entry, file_info->srch_inf.info_level,
 			      file_info->srch_inf.unicode);
 	if (!rc) {
-- 
1.7.6.4
