From: Steve French <smfrench@gmail.com>
Subject: [PATCH 4/4] [SMB3] Fix coverity warning
Date: Fri, 27 Mar 2015 00:28:02 -0500
Message-ID: <1427434082-4299-5-git-send-email-smfrench@gmail.com>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
Cc: smfrench@gmail.com
To: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Coverity reports a warning for referencing the beginning of the
SMB2/SMB3 frame using the ProtocolId field as an array. Although
it works the same either way, this patch should quiet the warning
and might be a little clearer.

Reported by Coverity (CID 741269)

Signed-off-by: Steve French <smfrench@gmail.com>
---
 fs/cifs/smb2misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 689f035..22dfdf1 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -322,7 +322,7 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 
 	/* return pointer to beginning of data area, ie offset from SMB start */
 	if ((*off != 0) && (*len != 0))
-		return hdr->ProtocolId + *off;
+		return (char *)(&hdr->ProtocolId[0]) + *off;
 	else
 		return NULL;
 }
-- 
1.9.1
