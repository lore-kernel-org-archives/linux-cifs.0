From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: revert needless change in decode_negTokenInit
Date: Mon, 30 Aug 2010 09:05:24 -0400
Message-ID: <1283173524-31920-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

9fbc590860e75785bdaf8b83e48fabfe4d4f7d58 needlessly changed some "else
if" statements in decode_negTokenInit to "if's". Not only was the change
not needed, but it's less efficient than the existing code.

When compare_oid returns true, then it's guaranteed to return false in
the other cases. Therefore, there's no reason to keep comparing it.

Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/asn1.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index 21f0fbd..cfd1ce3 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -597,13 +597,13 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 				if (compare_oid(oid, oidlen, MSKRB5_OID,
 						MSKRB5_OID_LEN))
 					server->sec_mskerberos = true;
-				if (compare_oid(oid, oidlen, KRB5U2U_OID,
+				else if (compare_oid(oid, oidlen, KRB5U2U_OID,
 						     KRB5U2U_OID_LEN))
 					server->sec_kerberosu2u = true;
-				if (compare_oid(oid, oidlen, KRB5_OID,
+				else if (compare_oid(oid, oidlen, KRB5_OID,
 						     KRB5_OID_LEN))
 					server->sec_kerberos = true;
-				if (compare_oid(oid, oidlen, NTLMSSP_OID,
+				else if (compare_oid(oid, oidlen, NTLMSSP_OID,
 						     NTLMSSP_OID_LEN))
 					server->sec_ntlmssp = true;
 
-- 
1.7.2.2
