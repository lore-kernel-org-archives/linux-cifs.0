From: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
Subject: [PATCH 1/1] cifs: set MAY_SIGN when sec=krb5
Date: Wed, 24 Oct 2012 11:45:46 +0200
Message-ID: <1351071946-21458-1-git-send-email-martijn.de.gouw@prodrive.nl>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
To: <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Setting this secFlg allows usage of dfs where some servers require
signing and others don't.

Signed-off-by: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
---
:100644 100644 b39bb4a... 4da9dd3... M	fs/cifs/connect.c
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b39bb4a..4da9dd3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -994,7 +994,7 @@ static int cifs_parse_security_flavors(char *value,
 
 	switch (match_token(value, cifs_secflavor_tokens, args)) {
 	case Opt_sec_krb5:
-		vol->secFlg |= CIFSSEC_MAY_KRB5;
+		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_SIGN;
 		break;
 	case Opt_sec_krb5i:
 		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MUST_SIGN;
-- 
1.7.2.5
