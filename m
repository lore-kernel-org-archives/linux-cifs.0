From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: remove "legacy" parm from CIFSSMBQPathInfo
Date: Thu, 28 Oct 2010 12:40:31 +0530
Message-ID: <4CC921E7.9020403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

as all the callers are setting it to 0 anyway.

I stumbled upon this code when I was looking at the strange hardlink
behavior reported in the mailing list. But it seems this patch was
originally posted by Jeff Layton on Feb:
  http://lists.samba.org/archive/linux-cifs-client/2010-February/005557.html

I didn't see any discussions, ACK/NACK on this patch.


Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifsproto.h |    1 -
 fs/cifs/cifssmb.c   |   22 +++-------------------
 fs/cifs/connect.c   |    2 +-
 fs/cifs/inode.c     |    1 -
 4 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index edb6d90..fa7e8d1 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -167,7 +167,6 @@ extern int CIFSSMBQFileInfo(const int xid, struct cifsTconInfo *tcon,
 extern int CIFSSMBQPathInfo(const int xid, struct cifsTconInfo *tcon,
 			const unsigned char *searchName,
 			FILE_ALL_INFO *findData,
-			int legacy /* whether to use old info level */,
 			const struct nls_table *nls_codepage, int remap);
 extern int SMBQueryInformation(const int xid, struct cifsTconInfo *tcon,
 			const unsigned char *searchName,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e98f1f3..392c01b 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3356,7 +3356,6 @@ int
 CIFSSMBQPathInfo(const int xid, struct cifsTconInfo *tcon,
 		 const unsigned char *searchName,
 		 FILE_ALL_INFO *pFindData,
-		 int legacy /* old style infolevel */,
 		 const struct nls_table *nls_codepage, int remap)
 {
 /* level 263 SMB_QUERY_FILE_ALL_INFO */
@@ -3406,10 +3405,7 @@ QPathInfoRetry:
 	byte_count = params + 1 /* pad */ ;
 	pSMB->TotalParameterCount = cpu_to_le16(params);
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
-	if (legacy)
-		pSMB->InformationLevel = cpu_to_le16(SMB_INFO_STANDARD);
-	else
-		pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_ALL_INFO);
+	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_ALL_INFO);
 	pSMB->Reserved4 = 0;
 	pSMB->hdr.smb_buf_length += byte_count;
 	pSMB->ByteCount = cpu_to_le16(byte_count);
@@ -3423,26 +3419,14 @@ QPathInfoRetry:
 
 		if (rc) /* BB add auto retry on EOPNOTSUPP? */
 			rc = -EIO;
-		else if (!legacy && (pSMBr->ByteCount < 40))
+		else if (pSMBr->ByteCount < 40)
 			rc = -EIO;	/* bad smb */
-		else if (legacy && (pSMBr->ByteCount < 24))
-			rc = -EIO;  /* 24 or 26 expected but we do not read
-					last field */
 		else if (pFindData) {
-			int size;
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 
-			/* On legacy responses we do not read the last field,
-			EAsize, fortunately since it varies by subdialect and
-			also note it differs on Set vs. Get, ie two bytes or 4
-			bytes depending but we don't care here */
-			if (legacy)
-				size = sizeof(FILE_INFO_STANDARD);
-			else
-				size = sizeof(FILE_ALL_INFO);
 			memcpy((char *) pFindData,
 			       (char *) &pSMBr->hdr.Protocol +
-			       data_offset, size);
+			       data_offset, sizeof(FILE_ALL_INFO));
 		} else
 		    rc = -ENOMEM;
 	}
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 469c3dd..b44bfd5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2629,7 +2629,7 @@ is_path_accessible(int xid, struct cifsTconInfo *tcon,
 		return -ENOMEM;
 
 	rc = CIFSSMBQPathInfo(xid, tcon, full_path, pfile_info,
-			      0 /* not legacy */, cifs_sb->local_nls,
+			      cifs_sb->local_nls,
 			      cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
 	kfree(pfile_info);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 39869c3..2448ad1 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -615,7 +615,6 @@ int cifs_get_inode_info(struct inode **pinode,
 
 		/* could do find first instead but this returns more info */
 		rc = CIFSSMBQPathInfo(xid, pTcon, full_path, pfindData,
-			      0 /* not legacy */,
 			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
 		/* BB optimize code so we do not make the above call
