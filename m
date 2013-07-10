From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/8] CIFS: Fix lease context buffer parsing
Date: Wed, 10 Jul 2013 13:59:53 +0400
Message-ID: <1373450401-4135-2-git-send-email-pshilovsky@samba.org>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373450401-4135-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to prevent missing RqLs context if it's not the first one.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2pdu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2b312e4..19fafeb 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -853,23 +853,24 @@ parse_lease_state(struct smb2_create_rsp *rsp)
 	char *data_offset;
 	struct create_lease *lc;
 	bool found = false;
+	unsigned int next = 0;
+	char *name;
 
-	data_offset = (char *)rsp;
-	data_offset += 4 + le32_to_cpu(rsp->CreateContextsOffset);
+	data_offset = (char *)rsp + 4 + le32_to_cpu(rsp->CreateContextsOffset);
 	lc = (struct create_lease *)data_offset;
 	do {
-		char *name = le16_to_cpu(lc->ccontext.NameOffset) + (char *)lc;
+		lc = (struct create_lease *)((char *)lc + next);
+		name = le16_to_cpu(lc->ccontext.NameOffset) + (char *)lc;
 		if (le16_to_cpu(lc->ccontext.NameLength) != 4 ||
 		    strncmp(name, "RqLs", 4)) {
-			lc = (struct create_lease *)((char *)lc
-					+ le32_to_cpu(lc->ccontext.Next));
+			next = le32_to_cpu(lc->ccontext.Next);
 			continue;
 		}
 		if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS)
 			return SMB2_OPLOCK_LEVEL_NOCHANGE;
 		found = true;
 		break;
-	} while (le32_to_cpu(lc->ccontext.Next) != 0);
+	} while (next != 0);
 
 	if (!found)
 		return 0;
-- 
1.7.10.4
