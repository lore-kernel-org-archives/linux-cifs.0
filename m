From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 3/9] add function CIFSSMBQPathInfoBasic()
Date: Fri, 22 Nov 2013 11:26:52 +0100
Message-ID: <1385116018-14068-4-git-send-email-gbeck@sernet.de>
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
