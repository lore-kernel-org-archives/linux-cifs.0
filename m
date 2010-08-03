From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: account for new creduid=0x%x parameter in spnego upcall string
Date: Tue,  3 Aug 2010 10:20:41 -0400
Message-ID: <1280845241-12305-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The commit that added the creduid=0x%x parameter failed to increase the
buffer allocation to account for it.

Reported-by: J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_spnego.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 6effccf..8704490 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -84,6 +84,9 @@ struct key_type cifs_spnego_key_type = {
 /* strlen of ";uid=0x" */
 #define UID_KEY_LEN		7
 
+/* strlen of ";creduid=0x" */
+#define CREDUID_KEY_LEN		11
+
 /* strlen of ";user=" */
 #define USER_KEY_LEN		6
 
@@ -107,6 +110,7 @@ cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
 		   IP_KEY_LEN + INET6_ADDRSTRLEN +
 		   MAX_MECH_STR_LEN +
 		   UID_KEY_LEN + (sizeof(uid_t) * 2) +
+		   CREDUID_KEY_LEN + (sizeof(uid_t) * 2) +
 		   USER_KEY_LEN + strlen(sesInfo->userName) +
 		   PID_KEY_LEN + (sizeof(pid_t) * 2) + 1;
 
-- 
1.7.2
