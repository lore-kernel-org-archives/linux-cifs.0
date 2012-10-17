From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/7] cifs: fix the format specifiers in sid_to_str
Date: Wed, 17 Oct 2012 14:08:59 -0400
Message-ID: <1350497343-7155-4-git-send-email-jlayton@redhat.com>
References: <1350497343-7155-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350497343-7155-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The format specifiers are for signed values, but these are unsigned.
Given that '-' is a delimiter between fields, I don't think you'd get
what you'd expect if you got a value here that would overflow the sign
bit.

The version and authority fields are 8 bit values so use a "hh" length
modifier there. The subauths are 32 bit values, so there's no need to
use a "l" length modifier there.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index dd8d3df..9adcdb5 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -199,27 +199,24 @@ static void
 sid_to_str(struct cifs_sid *sidptr, char *sidstr)
 {
 	int i;
-	unsigned long saval;
+	unsigned int saval;
 	char *strptr;
 
 	strptr = sidstr;
 
-	sprintf(strptr, "%s", "S");
-	strptr = sidstr + strlen(sidstr);
-
-	sprintf(strptr, "-%d", sidptr->revision);
+	sprintf(strptr, "S-%hhu", sidptr->revision);
 	strptr = sidstr + strlen(sidstr);
 
 	for (i = 0; i < NUM_AUTHS; ++i) {
 		if (sidptr->authority[i]) {
-			sprintf(strptr, "-%d", sidptr->authority[i]);
+			sprintf(strptr, "-%hhu", sidptr->authority[i]);
 			strptr = sidstr + strlen(sidstr);
 		}
 	}
 
 	for (i = 0; i < sidptr->num_subauth; ++i) {
 		saval = le32_to_cpu(sidptr->sub_auth[i]);
-		sprintf(strptr, "-%ld", saval);
+		sprintf(strptr, "-%u", saval);
 		strptr = sidstr + strlen(sidstr);
 	}
 }
-- 
1.7.11.7
