From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 17/17] getcifsacl: fix raw SID printing routine
Date: Sat,  3 Nov 2012 08:50:34 -0400
Message-ID: <1351947034-18876-18-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The current routine prints multiple authority values as different
numbers instead of combining them, which is wrong.

Print the SID according to the rules in MS-DTYP.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index 1bcbd58..b832c50 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -188,12 +188,11 @@ static void
 print_sid(struct cifs_sid *sidptr, int raw)
 {
 	int i;
-	int num_auths;
-	int num_auth = MAX_NUM_AUTHS;
 	wbcErr rc;
 	char *domain_name = NULL;
 	char *sidname = NULL;
 	enum wbcSidType sntype;
+	unsigned long long id_auth_val;
 
 	convert_sid_endianness(sidptr);
 
@@ -211,13 +210,25 @@ print_sid(struct cifs_sid *sidptr, int raw)
 	}
 
 print_sid_raw:
-	num_auths = sidptr->num_subauth;
-	printf("S");
-	printf("-%d", sidptr->revision);
-	for (i = 0; i < num_auth; ++i)
-		if (sidptr->authority[i])
-			printf("-%d", sidptr->authority[i]);
-	for (i = 0; i < num_auths; i++)
+	printf("S-%hhu", sidptr->revision);
+
+	id_auth_val = (unsigned long long)sidptr->authority[5];
+	id_auth_val += (unsigned long long)sidptr->authority[4] << 8;
+	id_auth_val += (unsigned long long)sidptr->authority[3] << 16;
+	id_auth_val += (unsigned long long)sidptr->authority[2] << 24;
+	id_auth_val += (unsigned long long)sidptr->authority[1] << 32;
+	id_auth_val += (unsigned long long)sidptr->authority[0] << 48;
+
+	/*
+	 * MS-DTYP states that if the authority is >= 2^32, then it should be
+	 * expressed as a hex value.
+	 */
+	if (id_auth_val <= UINT_MAX)
+		printf("-%llu", id_auth_val);
+	else
+		printf("-0x%llx", id_auth_val);
+
+	for (i = 0; i < sidptr->num_subauth; i++)
 		printf("-%u", sidptr->sub_auth[i]);
 }
 
-- 
1.7.11.7
