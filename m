From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 01/19] cifs: remove protocolEnum definition
Date: Tue, 28 May 2013 08:11:42 -0400
Message-ID: <1369743120-18941-2-git-send-email-jlayton@redhat.com>
References: <1369743120-18941-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369743120-18941-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The field that held this was removed quite some time ago.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index db9f985..29dd111 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -109,12 +109,6 @@ enum securityEnum {
 	Kerberos,		/* Kerberos via SPNEGO */
 };
 
-enum protocolEnum {
-	TCP = 0,
-	SCTP
-	/* Netbios frames protocol not supported at this time */
-};
-
 struct session_key {
 	unsigned int len;
 	char *response;
-- 
1.8.1.4
