From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/2] setcifsacl: fix some bugs in build_cmdline_aces
Date: Tue,  6 Nov 2012 10:31:19 -0500
Message-ID: <1352215879-11451-2-git-send-email-jlayton@samba.org>
References: <1352215879-11451-1-git-send-email-jlayton@samba.org>
Cc: praiskup-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352215879-11451-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Raiskup found the following defect in setcifsacl with Coverity:

"segfault may occur also in cifs-utils-4.8.1/setcifsacl.c|644| because
of casesptr dereferencing.  When you look e.g. at the line 605, in this
time any part of 'caseptr' may be yet uninitialized and program is going
through 'goto' to freeing -> and there you are freeing the 'caseptr[i]'
address."

The analysis there seems a little off, but is basically correct. The
freeing loop counts down from the current value of i to free the
secondary allocations here.

There is one situation though where this could go badly. If the strtok
parsing near the beginning of the loop fails, then we could end up
trying to free an uninitialized pointer.

Fix this by changing the cacesptr allocation to use calloc(), and stop
trying to be clever with the freeing loop. Just have it walk the
entire array and attempt to free each slot.

Reported-by: Pavel Raiskup <praiskup-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 9dfdad7..38d003e 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -586,8 +586,7 @@ build_cmdline_aces(char **arrptr, int numcaces)
 	char *acesid, *acetype, *aceflag, *acemask;
 	struct cifs_ace **cacesptr;
 
-	cacesptr = (struct cifs_ace **)malloc(numcaces *
-				sizeof(struct cifs_aces *));
+	cacesptr = calloc(numcaces, sizeof(struct cifs_aces *));
 	if (!cacesptr) {
 		printf("%s: Error %d allocating ACE array", __func__, errno);
 		return NULL;
@@ -639,7 +638,7 @@ build_cmdline_aces(char **arrptr, int numcaces)
 	return cacesptr;
 
 build_cmdline_aces_ret:
-	for (; i >= 0; --i)
+	for (i = 0; i < numcaces; ++i)
 		free(cacesptr[i]);
 	free(cacesptr);
 	return NULL;
-- 
1.7.11.7
