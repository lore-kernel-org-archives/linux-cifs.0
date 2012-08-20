From: Jim Meyering <jim-Oxw1nKZkIVjk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH] cifs: remove misleading strncpy: each name has length < 16
Date: Mon, 20 Aug 2012 18:55:24 +0200
Message-ID: <1345481724-30108-6-git-send-email-jim@meyering.net>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
Cc: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345481724-30108-1-git-send-email-jim-Oxw1nKZkIVjk1uMJSBkQmQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Each of the protocols[i].name strings (statically declared above)
has length less than 16, so this use of strncpy is misleading:
  strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
Besides, if a new name were added with length N >= 16, the existing
strncpy-using code would be buggy, creating a ->DialectsArray buffer
containing N-16+1 unset bytes where the NUL terminator should have
been.  Instead, traverse the name only once go get its length,
use a BUG_ON assertion to enforce the length restriction
and use memcpy to perform the copy.

Signed-off-by: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 074923c..16a9018 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -441,8 +441,10 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)

 	count = 0;
 	for (i = 0; i < CIFS_NUM_PROT; i++) {
-		strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
-		count += strlen(protocols[i].name) + 1;
+		size_t len = strlen(protocols[i].name);
+		BUG_ON(len >= 16);
+		memcpy(pSMB->DialectsArray+count, protocols[i].name, len + 1);
+		count += len + 1;
 		/* null at end of source and target buffers anyway */
 	}
 	inc_rfc1001_len(pSMB, count);
-- 
1.7.12
