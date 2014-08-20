From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 7/7] cifs: remove unneeded check of null checking in if
 condition
Date: Wed, 20 Aug 2014 19:39:59 +0900
Message-ID: <003a01cfbc63$178d63c0$46a82b40$@samsung.com>
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

Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 fs/cifs/smb2pdu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ab366e5..844c651 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1404,8 +1404,7 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	rsp = (struct smb2_close_rsp *)iov[0].iov_base;
 
 	if (rc != 0) {
-		if (tcon)
-			cifs_stats_fail_inc(tcon, SMB2_CLOSE_HE);
+		cifs_stats_fail_inc(tcon, SMB2_CLOSE_HE);
 		goto close_exit;
 	}
 
-- 
1.7.7
