From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/2] setcifsacl: fix some build warnings
Date: Wed,  7 Nov 2012 09:52:56 -0500
Message-ID: <1352299977-32701-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 8891844..30d5905 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -641,7 +641,7 @@ build_cmdline_aces_ret:
 static char **
 parse_cmdline_aces(char *acelist, int numcaces)
 {
-	int i = 0, len;
+	int i = 0;
 	char *acestr, *vacestr, **arrptr = NULL;
 
 	arrptr = (char **)malloc(numcaces * sizeof(char *));
@@ -677,7 +677,6 @@ parse_cmdline_aces_err:
 static unsigned int
 get_numcaces(const char *aces)
 {
-	int i, len;
 	unsigned int num = 1;
 	const char *current;
 
-- 
1.7.12.1
