From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v3 4/7] CIFS: let ses->ipc_tid hold smb2 TreeIds
Date: Tue, 28 Feb 2017 19:40:31 +0100
Message-ID: <20170228184034.18771-5-aaptel@suse.com>
References: <20170228184034.18771-1-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228184034.18771-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

the TreeId field went from 2 bytes in CIFS to 4 bytes in SMB2+. this
commit updates the size of the ipc_tid field of a cifs_ses, which was
still using 2 bytes.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifsglob.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1a90bb3..af224cd 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -822,7 +822,7 @@ struct cifs_ses {
 	int ses_count;		/* reference counter */
 	enum statusEnum status;
 	unsigned overrideSecFlg;  /* if non-zero override global sec flags */
-	__u16 ipc_tid;		/* special tid for connection to IPC share */
+	__u32 ipc_tid;		/* special tid for connection to IPC share */
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
 	char *serverDomain;	/* security realm of server */
-- 
2.10.2
