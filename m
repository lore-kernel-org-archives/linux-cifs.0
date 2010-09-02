From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/6] Revert "cifs: revert needless change in decode_negTokenInit"
Date: Wed,  1 Sep 2010 21:37:31 -0400
Message-ID: <1283391455-6848-3-git-send-email-jlayton@redhat.com>
References: <1283391455-6848-1-git-send-email-jlayton@redhat.com>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283391455-6848-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This reverts commit 49999b7cbf16777a5ec284b5b12bf5888f780c01.
---
 fs/cifs/asn1.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index cfd1ce3..21f0fbd 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -597,13 +597,13 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 				if (compare_oid(oid, oidlen, MSKRB5_OID,
 						MSKRB5_OID_LEN))
 					server->sec_mskerberos = true;
-				else if (compare_oid(oid, oidlen, KRB5U2U_OID,
+				if (compare_oid(oid, oidlen, KRB5U2U_OID,
 						     KRB5U2U_OID_LEN))
 					server->sec_kerberosu2u = true;
-				else if (compare_oid(oid, oidlen, KRB5_OID,
+				if (compare_oid(oid, oidlen, KRB5_OID,
 						     KRB5_OID_LEN))
 					server->sec_kerberos = true;
-				else if (compare_oid(oid, oidlen, NTLMSSP_OID,
+				if (compare_oid(oid, oidlen, NTLMSSP_OID,
 						     NTLMSSP_OID_LEN))
 					server->sec_ntlmssp = true;
 
-- 
1.7.2.2
