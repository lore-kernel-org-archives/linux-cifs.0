From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 1/3] CIFS: set SERVER_NAME_LENGTH to serverName actual size
Date: Wed, 17 Jan 2018 18:21:58 +0100
Message-ID: <20180117172200.3221-2-aaptel@suse.com>
References: <20180117172200.3221-1-aaptel@suse.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117172200.3221-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The maximum length of an ipv6 string representation is defined in
INET6_ADDRSTRLEN as 45+1 for null but lets keep what we know works.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifsglob.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b16583594d1a..eca386d8dcfb 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -64,8 +64,8 @@
 #define RFC1001_NAME_LEN 15
 #define RFC1001_NAME_LEN_WITH_NULL (RFC1001_NAME_LEN + 1)
 
-/* currently length of NIP6_FMT */
-#define SERVER_NAME_LENGTH 40
+/* maximum length of ip addr as a string (including ipv6 and sctp) */
+#define SERVER_NAME_LENGTH 80
 #define SERVER_NAME_LEN_WITH_NULL     (SERVER_NAME_LENGTH + 1)
 
 /* echo interval in seconds */
@@ -835,8 +835,7 @@ struct cifs_ses {
 	kuid_t linux_uid;	/* overriding owner of files on the mount */
 	kuid_t cred_uid;	/* owner of credentials */
 	unsigned int capabilities;
-	char serverName[SERVER_NAME_LEN_WITH_NULL * 2];	/* BB make bigger for
-				TCP names - will ipv6 and sctp addresses fit? */
+	char serverName[SERVER_NAME_LEN_WITH_NULL];
 	char *user_name;	/* must not be null except during init of sess
 				   and after mount option parsing we fill it */
 	char *domainName;
-- 
2.12.3
