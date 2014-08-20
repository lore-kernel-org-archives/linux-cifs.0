From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/7] cifs: fix a possible null pointer deref in
 decode_ascii_ssetup
Date: Wed, 20 Aug 2014 19:39:28 +0900
Message-ID: <003701cfbc63$04fdf490$0ef9ddb0$@samsung.com>
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

When kzalloc fails, we will end up doing NULL pointer derefrence

Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 fs/cifs/sess.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 39b8507..07fe97a 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -243,10 +243,11 @@ static void decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 	kfree(ses->serverOS);
 
 	ses->serverOS = kzalloc(len + 1, GFP_KERNEL);
-	if (ses->serverOS)
+	if (ses->serverOS) {
 		strncpy(ses->serverOS, bcc_ptr, len);
-	if (strncmp(ses->serverOS, "OS/2", 4) == 0)
-		cifs_dbg(FYI, "OS/2 server\n");
+		if (strncmp(ses->serverOS, "OS/2", 4) == 0)
+			cifs_dbg(FYI, "OS/2 server\n");
+	}
 
 	bcc_ptr += len + 1;
 	bleft -= len + 1;
-- 
1.7.7
