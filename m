From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: check for NULL last_entry before calling cifs_save_resume_key
Date: Tue, 15 Nov 2011 07:59:26 -0500
Message-ID: <1321361966-24961-1-git-send-email-jlayton@redhat.com>
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

Fix this by having the callers check for a NULL last entry pointer
before calling cifs_save_resume_key. No change is needed for the
call site in cifs_readdir as it's not reachable with a NULL
current_entry pointer.

This should fix:

    https://bugzilla.redhat.com/show_bug.cgi?id=750247

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Reported-by: Adam G. Metzler <adamgmetzler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/readdir.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 5de03ec..a090bbe 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -554,7 +554,10 @@ static int find_cifs_entry(const int xid, struct cifs_tcon *pTcon,
 				 rc);
 			return rc;
 		}
-		cifs_save_resume_key(cifsFile->srch_inf.last_entry, cifsFile);
+		/* FindFirst/Next set last_entry to NULL on malformed reply */
+		if (cifsFile->srch_inf.last_entry)
+			cifs_save_resume_key(cifsFile->srch_inf.last_entry,
+						cifsFile);
 	}
 
 	while ((index_to_find >= cifsFile->srch_inf.index_of_last_entry) &&
@@ -562,7 +565,10 @@ static int find_cifs_entry(const int xid, struct cifs_tcon *pTcon,
 		cFYI(1, "calling findnext2");
 		rc = CIFSFindNext(xid, pTcon, cifsFile->netfid,
 				  &cifsFile->srch_inf);
-		cifs_save_resume_key(cifsFile->srch_inf.last_entry, cifsFile);
+		/* FindFirst/Next set last_entry to NULL on malformed reply */
+		if (cifsFile->srch_inf.last_entry)
+			cifs_save_resume_key(cifsFile->srch_inf.last_entry,
+						cifsFile);
 		if (rc)
 			return -ENOENT;
 	}
-- 
1.7.6.4
