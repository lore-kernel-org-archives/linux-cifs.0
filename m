From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 2/9] refactor CIFSSMBQPathInfo()
Date: Fri, 22 Nov 2013 11:26:51 +0100
Message-ID: <1385116018-14068-3-git-send-email-gbeck@sernet.de>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
 <1385116018-14068-1-git-send-email-gbeck@sernet.de>
Cc: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-1-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---
 cifssmb.c |   59 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/cifssmb.c b/cifssmb.c
index a89c4cb..7b055fe 100644
--- a/cifssmb.c
+++ b/cifssmb.c
@@ -3958,13 +3958,13 @@ QFileInfoRetry:
 	return rc;
 }
 
-int
-CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
-		 const char *search_name, FILE_ALL_INFO *data,
-		 int legacy /* old style infolevel */,
-		 const struct nls_table *nls_codepage, int remap)
+static int
+CIFSSMBQPathInfoImpl(const unsigned int xid, struct cifs_tcon *tcon,
+		     const char *search_name,
+		     void *data, int size,
+		     __u16 level, __u16 bcc,
+		     const struct nls_table *nls_codepage, int remap)
 {
-	/* level 263 SMB_QUERY_FILE_ALL_INFO */
 	TRANSACTION2_QPI_REQ *pSMB = NULL;
 	TRANSACTION2_QPI_RSP *pSMBr = NULL;
 	int rc = 0;
@@ -3972,7 +3972,7 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-	/* cifs_dbg(FYI, "In QPathInfo path %s\n", search_name); */
+	cifs_dbg(FYI, "In QPathInfo level %u path %s", level, search_name);
 QPathInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4011,10 +4011,7 @@ QPathInfoRetry:
 	byte_count = params + 1 /* pad */ ;
 	pSMB->TotalParameterCount = cpu_to_le16(params);
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
-	if (legacy)
-		pSMB->InformationLevel = cpu_to_le16(SMB_INFO_STANDARD);
-	else
-		pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_ALL_INFO);
+	pSMB->InformationLevel = level;
 	pSMB->Reserved4 = 0;
 	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
@@ -4028,25 +4025,10 @@ QPathInfoRetry:
 
 		if (rc) /* BB add auto retry on EOPNOTSUPP? */
 			rc = -EIO;
-		else if (!legacy && get_bcc(&pSMBr->hdr) < 40)
+		else if (get_bcc(&pSMBr->hdr) < bcc)
 			rc = -EIO;	/* bad smb */
-		else if (legacy && get_bcc(&pSMBr->hdr) < 24)
-			rc = -EIO;  /* 24 or 26 expected but we do not read
-					last field */
 		else if (data) {
-			int size;
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
-
-			/*
-			 * On legacy responses we do not read the last field,
-			 * EAsize, fortunately since it varies by subdialect and
-			 * also note it differs on Set vs Get, ie two bytes or 4
-			 * bytes depending but we don't care here.
-			 */
-			if (legacy)
-				size = sizeof(FILE_INFO_STANDARD);
-			else
-				size = sizeof(FILE_ALL_INFO);
 			memcpy((char *) data, (char *) &pSMBr->hdr.Protocol +
 			       data_offset, size);
 		} else
@@ -4060,6 +4042,29 @@ QPathInfoRetry:
 }
 
 int
+CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
+		 const char *search_name, FILE_ALL_INFO *data,
+		 int legacy /* old style infolevel */,
+		 const struct nls_table *nls_codepage, int remap)
+{
+	if (legacy) {
+		/* 24 or 26 expected but on legacy responses we do not read the
+		   last field, EAsize, fortunately since it varies by subdialect
+		   and also note it differs on Set vs. Get, ie two bytes or 4
+		   bytes depending but we don't care here */
+		return CIFSSMBQPathInfoImpl(xid, tcon, search_name,
+					    data, sizeof(FILE_INFO_STANDARD),
+					    SMB_INFO_STANDARD, 24,
+					    nls_codepage, remap);
+	} else {
+		return CIFSSMBQPathInfoImpl(xid, tcon, search_name,
+					    data, sizeof(FILE_ALL_INFO),
+					    SMB_QUERY_FILE_ALL_INFO, 40,
+					    nls_codepage, remap);
+	}
+}
+
+int
 CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		 u16 netfid, FILE_UNIX_BASIC_INFO *pFindData)
 {
-- 
1.7.9.5
