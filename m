From: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
Subject: [PATCH 1/1] cifs: add krb5m option for MAY_SIGN
Date: Tue, 23 Oct 2012 17:11:40 +0200
Message-ID: <1351005100-21172-1-git-send-email-martijn.de.gouw@prodrive.nl>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
To: <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This option allows usage of dfs where some servers require signing
and others don't.

Signed-off-by: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
---
:100644 100644 b39bb4a... c5a4183... M	fs/cifs/connect.c
 fs/cifs/connect.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b39bb4a..c5a4183 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -236,7 +236,7 @@ static const match_table_t cifs_mount_option_tokens = {
 };
 
 enum {
-	Opt_sec_krb5, Opt_sec_krb5i, Opt_sec_krb5p,
+	Opt_sec_krb5, Opt_sec_krb5i, Opt_sec_krb5m, Opt_sec_krb5p,
 	Opt_sec_ntlmsspi, Opt_sec_ntlmssp,
 	Opt_ntlm, Opt_sec_ntlmi, Opt_sec_ntlmv2,
 	Opt_sec_ntlmv2i, Opt_sec_lanman,
@@ -248,6 +248,7 @@ enum {
 static const match_table_t cifs_secflavor_tokens = {
 	{ Opt_sec_krb5, "krb5" },
 	{ Opt_sec_krb5i, "krb5i" },
+	{ Opt_sec_krb5m, "krb5m" },
 	{ Opt_sec_krb5p, "krb5p" },
 	{ Opt_sec_ntlmsspi, "ntlmsspi" },
 	{ Opt_sec_ntlmssp, "ntlmssp" },
@@ -999,6 +1000,9 @@ static int cifs_parse_security_flavors(char *value,
 	case Opt_sec_krb5i:
 		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MUST_SIGN;
 		break;
+	case Opt_sec_krb5m:
+		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_SIGN;
+		break;
 	case Opt_sec_krb5p:
 		/* vol->secFlg |= CIFSSEC_MUST_SEAL | CIFSSEC_MAY_KRB5; */
 		cERROR(1, "Krb5 cifs privacy not supported");
-- 
1.7.2.5
