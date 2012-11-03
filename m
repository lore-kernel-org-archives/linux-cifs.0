From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 12/17] setcifsacl: clean up parse_cmdline_aces
Date: Sat,  3 Nov 2012 08:50:29 -0400
Message-ID: <1351947034-18876-13-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

One of the reasons to use "goto" in an error condition is to eliminate
unnecessary indentation. Fix that here by revering some error checks
end getting rid of some unneeded "else" cases.

After using strstr() to find "ACL:", there's no need to then use
strchr() to find ':'. We know where it is -- it's 3 bytes past the
current position.

Finally, there's no need to copy these strings into new buffers,
just set the pointers in the array to their original values.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 50 ++++++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index faf5405..54d8cbc 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -655,48 +655,36 @@ build_cmdline_aces_ret:
 }
 
 static char **
-parse_cmdline_aces(char *optarg, int numcaces)
+parse_cmdline_aces(char *acelist, int numcaces)
 {
 	int i = 0, len;
 	char *acestr, *vacestr, **arrptr = NULL;
 
-	errno = EINVAL;
 	arrptr = (char **)malloc(numcaces * sizeof(char *));
 	if (!arrptr) {
-		printf("%s: Error %d allocating char array\n", __func__, errno);
+		printf("%s: Unable to allocate char array\n", __func__);
 		return NULL;
 	}
 
 	while (i < numcaces) {
-		acestr = strtok(optarg, ","); /* everything before , */
-		if (acestr) {
-			vacestr = strstr(acestr, "ACL:"); /* ace as ACL:*" */
-			if (vacestr) {
-				vacestr = strchr(vacestr, ':');
-				if (vacestr)
-					++vacestr; /* go past : */
-				if (vacestr) {
-					len = strlen(vacestr);
-					arrptr[i] = malloc(len + 1);
-					if (!arrptr[i])
-						goto parse_cmdline_aces_ret;
-					strcpy(arrptr[i], vacestr);
-					++i;
-				} else
-					goto parse_cmdline_aces_ret;
-			} else
-				goto parse_cmdline_aces_ret;
-		} else
-			goto parse_cmdline_aces_ret;
-		optarg = NULL;
-	}
-	errno = 0;
+		acestr = strtok(acelist, ","); /* everything before , */
+		if (!acestr)
+			goto parse_cmdline_aces_err;
+
+		vacestr = strstr(acestr, "ACL:"); /* ace as ACL:*" */
+		if (!vacestr)
+			goto parse_cmdline_aces_err;
+		vacestr += 4; /* skip past "ACL:" */
+		if (vacestr) {
+			arrptr[i] = vacestr;
+			++i;
+		}
+		acelist = NULL;
+	}
 	return arrptr;
 
-parse_cmdline_aces_ret:
-	printf("%s: Error %d parsing ACEs\n", __func__, errno);
-	for (;  i >= 0; --i)
-		free(arrptr[i]);
+parse_cmdline_aces_err:
+	printf("%s: Error parsing ACEs\n", __func__);
 	free(arrptr);
 	return NULL;
 }
@@ -908,8 +896,6 @@ setcifsacl_cmdlineverify_ret:
 	free(cacesptr);
 
 setcifsacl_cmdlineparse_ret:
-	for (i = 0; i < numcaces; ++i)
-		free(arrptr[i]);
 	free(arrptr);
 
 setcifsacl_numcaces_ret:
-- 
1.7.11.7
