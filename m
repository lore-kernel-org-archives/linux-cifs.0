From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH] Fix samba bug #8914
Date: Thu, 21 Nov 2013 12:51:43 +0100
Message-ID: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3150290.nz6r4QH1pr"
Content-Transfer-Encoding: 7Bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart3150290.nz6r4QH1pr
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi,=20

NetApp sends brocken packages in response to trans2_query_path_info wit=
h info=20
level smb_file_all_info as reported at:=20
https://bugzilla.samba.org/show_bug.cgi?id=3D8914

The attached patch for cifs 2.01 works around the problem by retrying t=
he=20
operation with info levels basic and standard which yield the same=20
information.=20

Thanks
Gregor

--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org

--nextPart3150290.nz6r4QH1pr
Content-Disposition: attachment; filename="2.01.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="2.01.patch"

>From 7b44faa24e0fc447bd76c5b97389538189f17667 Mon Sep 17 00:00:00 2001
From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Thu, 17 Oct 2013 13:47:15 +0200
Subject: [PATCH 1/9] add struct FILE_STANDARD_INFO

---
 cifspdu.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/cifspdu.h b/cifspdu.h
index 11ca24a..89aa1f2 100644
--- a/cifspdu.h
+++ b/cifspdu.h
@@ -2233,6 +2233,16 @@ typedef struct { /* data block encoding of response to level 263 QPathInfo */
 	char FileName[1];
 } __attribute__((packed)) FILE_ALL_INFO;	/* level 0x107 QPathInfo */
 
+typedef struct {
+	__le64 AllocationSize;
+	__le64 EndOfFile;	/* size ie offset to first free byte in file */
+	__le32 NumberOfLinks;	/* hard links */
+	__u8 DeletePending;
+	__u8 Directory;
+	__u16 Pad;
+} __attribute__((packed)) FILE_STANDARD_INFO;	/* level 0x102 QPathInfo */
+
+
 /* defines for enumerating possible values of the Unix type field below */
 #define UNIX_FILE      0
 #define UNIX_DIR       1
-- 
1.7.9.5


>From f82cb72e295b3bdc9c08444124681695d6b7ca07 Mon Sep 17 00:00:00 2001
From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Mon, 21 Oct 2013 16:24:01 +0200
Subject: [PATCH 2/9] refactor CIFSSMBQPathInfo()

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


>From e7479e89fdea3e61ef6607762e8400ed2377d68d Mon Sep 17 00:00:00 2001
From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Mon, 21 Oct 2013 16:28:49 +0200
Subject: [PATCH 3/9] add function CIFSSMBQPathInfoBasic()

---
 cifsproto.h |    3 +++
 cifssmb.c   |   11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/cifsproto.h b/cifsproto.h
index b29a012..ea25d0d 100644
--- a/cifsproto.h
+++ b/cifsproto.h
@@ -240,6 +240,9 @@ extern int CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			    const char *search_Name, FILE_ALL_INFO *data,
 			    int legacy /* whether to use old info level */,
 			    const struct nls_table *nls_codepage, int remap);
+extern int CIFSSMBQPathInfoBasic(const unsigned int xid, struct cifs_tcon *tcon,
+				 const char *search_name, FILE_BASIC_INFO *data,
+				 const struct nls_table *nls_codepage, int remap);
 extern int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
 			       const char *search_name, FILE_ALL_INFO *data,
 			       const struct nls_table *nls_codepage, int remap);
diff --git a/cifssmb.c b/cifssmb.c
index 7b055fe..d8189b5 100644
--- a/cifssmb.c
+++ b/cifssmb.c
@@ -4065,6 +4065,17 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
+CIFSSMBQPathInfoBasic(const unsigned int xid, struct cifs_tcon *tcon,
+		      const char *search_name, FILE_BASIC_INFO *data,
+		      const struct nls_table *nls_codepage, int remap)
+{
+	return CIFSSMBQPathInfoImpl(xid, tcon, search_name,
+				    data, sizeof(FILE_BASIC_INFO),
+				    SMB_QUERY_FILE_BASIC_INFO, 40 /*???*/,
+				    nls_codepage, remap);
+}
+
+int
 CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		 u16 netfid, FILE_UNIX_BASIC_INFO *pFindData)
 {
-- 
1.7.9.5


>From 3ccd459f7d365b22510b4461f6a671f850722791 Mon Sep 17 00:00:00 2001
From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Mon, 21 Oct 2013 16:33:31 +0200
Subject: [PATCH 4/9] add function CIFSSMBQPathInfoStandard()

---
 cifsproto.h |    3 +++
 cifssmb.c   |   11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/cifsproto.h b/cifsproto.h
index ea25d0d..d015336 100644
--- a/cifsproto.h
+++ b/cifsproto.h
@@ -243,6 +243,9 @@ extern int CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 extern int CIFSSMBQPathInfoBasic(const unsigned int xid, struct cifs_tcon *tcon,
 				 const char *search_name, FILE_BASIC_INFO *data,
 				 const struct nls_table *nls_codepage, int remap);
+extern int CIFSSMBQPathInfoStandard(const unsigned int xid, struct cifs_tcon *tcon,
+				    const char *search_name, FILE_STANDARD_INFO *data,
+				    const struct nls_table *nls_codepage, int remap);
 extern int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
 			       const char *search_name, FILE_ALL_INFO *data,
 			       const struct nls_table *nls_codepage, int remap);
diff --git a/cifssmb.c b/cifssmb.c
index d8189b5..38be854 100644
--- a/cifssmb.c
+++ b/cifssmb.c
@@ -4076,6 +4076,17 @@ CIFSSMBQPathInfoBasic(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
+CIFSSMBQPathInfoStandard(const unsigned int xid, struct cifs_tcon *tcon,
+			 const char *search_name, FILE_STANDARD_INFO *data,
+			 const struct nls_table *nls_codepage, int remap)
+{
+	return CIFSSMBQPathInfoImpl(xid, tcon, search_name,
+				    data, sizeof(FILE_STANDARD_INFO),
+				    SMB_QUERY_FILE_STANDARD_INFO, 24 /*???*/,
+				    nls_codepage, remap);
+}
+
+int
 CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		 u16 netfid, FILE_UNIX_BASIC_INFO *pFindData)
 {
-- 
1.7.9.5


>From 69fca242cbd396f2446e74413ff8906a04ad56d7 Mon Sep 17 00:00:00 2001
From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Mon, 21 Oct 2013 17:02:52 +0200
Subject: [PATCH 5/9] fallback to CIFSSMBQPathInfoBasic() in
 cifs_is_path_accessible()

---
 smb1ops.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/smb1ops.c b/smb1ops.c
index 6094397..635b1e5 100644
--- a/smb1ops.c
+++ b/smb1ops.c
@@ -513,20 +513,23 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	int rc;
 	FILE_ALL_INFO *file_info;
+	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	file_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 	if (file_info == NULL)
 		return -ENOMEM;
 
 	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
-			      0 /* not legacy */, cifs_sb->local_nls,
-			      cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+			      0 /* not legacy */, cifs_sb->local_nls, remap);
+	if (rc == -EIO) {
+		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
+					   (FILE_BASIC_INFO*)file_info,
+					   cifs_sb->local_nls, remap);
+	}
 
 	if (rc == -EOPNOTSUPP || rc == -EINVAL)
 		rc = SMBQueryInformation(xid, tcon, full_path, file_info,
-				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				  CIFS_MOUNT_MAP_SPECIAL_CHR);
+					 cifs_sb->local_nls, remap);
 	kfree(file_info);
 	return rc;
 }
-- 
1.7.9.5


>From c36dda3c9901daa0f7ff4fa920a4ee19246a0e55 Mon Sep 17 00:00:00 2001
From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Tue, 22 Oct 2013 09:52:59 +0200
Subject: [PATCH 6/9] fallback to CIFSSMBQPathInfoBasic()/Standard() in
 cifs_is_path_accessible()

---
 smb1ops.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/smb1ops.c b/smb1ops.c
index 635b1e5..a12e370 100644
--- a/smb1ops.c
+++ b/smb1ops.c
@@ -540,11 +540,23 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		     FILE_ALL_INFO *data, bool *adjustTZ)
 {
 	int rc;
+	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	/* could do find first instead but this returns more info */
 	rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0 /* not legacy */,
-			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+			      cifs_sb->local_nls, remap);
+
+	if (rc == -EIO) {
+		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
+					   (FILE_BASIC_INFO*)data,
+					   cifs_sb->local_nls, remap);
+		if (!rc) {
+			rc = CIFSSMBQPathInfoStandard(xid, tcon, full_path,
+						      (void*)data + sizeof(FILE_BASIC_INFO),
+						      cifs_sb->local_nls, remap);
+		}
+	}
+
 	/*
 	 * BB optimize code so we do not make the above call when server claims
 	 * no NT SMB support and the above call failed at least once - set flag
@@ -552,9 +564,7 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	 */
 	if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
 		rc = SMBQueryInformation(xid, tcon, full_path, data,
-					 cifs_sb->local_nls,
-					 cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					 cifs_sb->local_nls, remap);
 		*adjustTZ = true;
 	}
 	return rc;
-- 
1.7.9.5


>From f53227ee3349f91412de23f9db49da251679e043 Mon Sep 17 00:00:00 2001
From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Tue, 22 Oct 2013 10:01:40 +0200
Subject: [PATCH 7/9] fix some cFYI in cifssmb.c

---
 cifssmb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cifssmb.c b/cifssmb.c
index 38be854..5d10afc 100644
--- a/cifssmb.c
+++ b/cifssmb.c
@@ -3935,7 +3935,7 @@ QFileInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
+		cifs_dbg(FYI, "Send error in QFileInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4131,7 +4131,7 @@ UnixQFileInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
+		cifs_dbg(FYI, "Send error in UnixQFileInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4215,7 +4215,7 @@ UnixQPathInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
+		cifs_dbg(FYI, "Send error in UnixQPathInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-- 
1.7.9.5


>From f13f9d5ca298da2d6f40059a6169fb8504427e0b Mon Sep 17 00:00:00 2001
From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Tue, 22 Oct 2013 11:02:57 +0200
Subject: [PATCH 8/9] cFYI

---
 smb1ops.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/smb1ops.c b/smb1ops.c
index a12e370..11daa28 100644
--- a/smb1ops.c
+++ b/smb1ops.c
@@ -522,6 +522,7 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
 			      0 /* not legacy */, cifs_sb->local_nls, remap);
 	if (rc == -EIO) {
+		cifs_dbg(FYI, "is_path_accessible: FALLBACK");
 		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
 					   (FILE_BASIC_INFO*)file_info,
 					   cifs_sb->local_nls, remap);
@@ -547,6 +548,7 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 			      cifs_sb->local_nls, remap);
 
 	if (rc == -EIO) {
+		cifs_dbg(FYI, "cifs_query_path_info: FALLBACK");
 		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
 					   (FILE_BASIC_INFO*)data,
 					   cifs_sb->local_nls, remap);
-- 
1.7.9.5


>From 95a15de52fff01fc0875dfa246842b06698525c5 Mon Sep 17 00:00:00 2001
From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Wed, 30 Oct 2013 14:14:52 +0100
Subject: [PATCH 9/9] cache we have broken_qpath_info per tcon

---
 cifsglob.h |    1 +
 smb1ops.c  |   26 ++++++++++++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/cifsglob.h b/cifsglob.h
index 52ca861..d3adde7 100644
--- a/cifsglob.h
+++ b/cifsglob.h
@@ -818,6 +818,7 @@ struct cifs_tcon {
 	bool local_lease:1; /* check leases (only) on local system not remote */
 	bool broken_posix_open; /* e.g. Samba server versions < 3.3.2, 3.2.9 */
 	bool need_reconnect:1; /* connection reset, tid now invalid */
+	bool broken_qpath_info:1;
 #ifdef CONFIG_CIFS_SMB2
 	bool print:1;		/* set if connection to printer share */
 	bool bad_network_name:1; /* set if ret status STATUS_BAD_NETWORK_NAME */
diff --git a/smb1ops.c b/smb1ops.c
index 11daa28..e3798a4 100644
--- a/smb1ops.c
+++ b/smb1ops.c
@@ -511,7 +511,7 @@ static int
 cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const char *full_path)
 {
-	int rc;
+	int rc= -EIO;
 	FILE_ALL_INFO *file_info;
 	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
@@ -519,13 +519,18 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	if (file_info == NULL)
 		return -ENOMEM;
 
-	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
-			      0 /* not legacy */, cifs_sb->local_nls, remap);
+	if (!tcon->broken_qpath_info) {
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
+				      0, cifs_sb->local_nls, remap);
+	}
 	if (rc == -EIO) {
-		cifs_dbg(FYI, "is_path_accessible: FALLBACK");
 		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
 					   (FILE_BASIC_INFO*)file_info,
 					   cifs_sb->local_nls, remap);
+		cifs_dbg(FYI, "is_path_accessible: FALLBACK returns %d", rc);
+		if (!rc) {
+			tcon->broken_qpath_info = true;
+		}
 	}
 
 	if (rc == -EOPNOTSUPP || rc == -EINVAL)
@@ -540,15 +545,16 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		     struct cifs_sb_info *cifs_sb, const char *full_path,
 		     FILE_ALL_INFO *data, bool *adjustTZ)
 {
-	int rc;
+	int rc = -EIO;
 	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	/* could do find first instead but this returns more info */
-	rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0 /* not legacy */,
-			      cifs_sb->local_nls, remap);
+	if (!tcon->broken_qpath_info) {
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0,
+				      cifs_sb->local_nls, remap);
+	}
 
 	if (rc == -EIO) {
-		cifs_dbg(FYI, "cifs_query_path_info: FALLBACK");
 		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
 					   (FILE_BASIC_INFO*)data,
 					   cifs_sb->local_nls, remap);
@@ -557,6 +563,10 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 						      (void*)data + sizeof(FILE_BASIC_INFO),
 						      cifs_sb->local_nls, remap);
 		}
+		cifs_dbg(FYI, "cifs_query_path_info: FALLBACK returns %d", rc);
+		if (!rc) {
+			tcon->broken_qpath_info = true;
+		}
 	}
 
 	/*
-- 
1.7.9.5


--nextPart3150290.nz6r4QH1pr--
