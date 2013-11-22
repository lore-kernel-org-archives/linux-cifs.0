From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 4/9] add function CIFSSMBQPathInfoStandard()
Date: Fri, 22 Nov 2013 11:26:53 +0100
Message-ID: <1385116018-14068-5-git-send-email-gbeck@sernet.de>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
 <1385116018-14068-1-git-send-email-gbeck@sernet.de>
Cc: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-1-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

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
