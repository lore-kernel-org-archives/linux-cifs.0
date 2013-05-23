From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/19] cifs: factor out check for extended security bit into separate function
Date: Thu, 23 May 2013 11:05:54 -0400
Message-ID: <1369321563-16893-11-git-send-email-jlayton@redhat.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 5b191f7..e7184b9 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -539,6 +539,20 @@ decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr,
 }
 #endif
 
+static bool
+should_set_ext_sec_flag(unsigned int secFlags)
+{
+	if ((secFlags & CIFSSEC_MUST_KRB5) == CIFSSEC_MUST_KRB5)
+		return true;
+	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_KRB5)
+		return true;
+	else if ((secFlags & CIFSSEC_MUST_NTLMSSP) == CIFSSEC_MUST_NTLMSSP)
+		return true;
+	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_NTLMSSP)
+		return true;
+	return false;
+}
+
 int
 CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 {
@@ -572,15 +586,8 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	pSMB->hdr.Mid = get_next_mid(server);
 	pSMB->hdr.Flags2 |= (SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS);
 
-	if ((secFlags & CIFSSEC_MUST_KRB5) == CIFSSEC_MUST_KRB5)
-		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
-	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_KRB5) {
-		cifs_dbg(FYI, "Kerberos only mechanism, enable extended security\n");
-		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
-	} else if ((secFlags & CIFSSEC_MUST_NTLMSSP) == CIFSSEC_MUST_NTLMSSP)
-		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
-	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_NTLMSSP) {
-		cifs_dbg(FYI, "NTLMSSP only mechanism, enable extended security\n");
+	if (should_set_ext_sec_flag(secFlags)) {
+		cifs_dbg(FYI, "Requesting extended security.");
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	}
 
-- 
1.8.1.4
