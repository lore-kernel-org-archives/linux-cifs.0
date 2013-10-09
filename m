From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH][cifs-utils] getcifsacl: remove some dead code
Date: Wed,  9 Oct 2013 09:14:33 -0400
Message-ID: <1381324473-32474-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Coverity says:

Error: DEADCODE (CWE-561): [#def5]
cifs-utils-6.2/getcifsacl.c:101: assignment: Assigning: "mflags" = "false".
cifs-utils-6.2/getcifsacl.c:109: const: At condition "mflags", the value of "mflags" must be equal to 0.
cifs-utils-6.2/getcifsacl.c:109: dead_error_condition: The condition "mflags" cannot be true.
cifs-utils-6.2/getcifsacl.c:110: dead_error_line: Execution cannot reach this statement "printf("|");".

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index b8998ef..8a7f8ba 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -106,10 +106,7 @@ print_ace_flags(uint8_t flags, int raw)
 	}
 
 	if (flags & OBJECT_INHERIT_FLAG) {
-		if (mflags)
-			printf("|");
-		else
-			mflags = true;
+		mflags = true;
 		printf("OI");
 	}
 	if (flags & CONTAINER_INHERIT_FLAG) {
-- 
1.8.3.1
