From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 5/6] getcifsacl: free strings returned by wbcLookupSid
Date: Tue,  4 Dec 2012 10:16:43 -0500
Message-ID: <1354634204-21602-6-git-send-email-jlayton@samba.org>
References: <1354634204-21602-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354634204-21602-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/getcifsacl.c b/getcifsacl.c
index ac3674c..256b2ad 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -211,6 +211,8 @@ print_sid(struct cifs_sid *sidptr, int raw)
 		if (strlen(domain_name))
 			printf("%c", '\\');
 		printf("%s", sidname);
+		wbcFreeMemory(domain_name);
+		wbcFreeMemory(sidname);
 		return;
 	}
 
-- 
1.7.11.7
