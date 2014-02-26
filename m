From: "Lorenz Bucher" <Lorenz.Bucher@gmx.de>
Subject: [PATCH] cifs: connect: added option krb5mi which may allow package
 signing
Date: Wed, 26 Feb 2014 14:46:47 +0100
Message-ID: <trinity-7e911dab-5097-463a-ba4a-09935acbdc69-1393422407694@3capp-gmx-bs33>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, lorenz.bucher@gmx.de
To: sfrench@samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Solves an issue with dfs where servers using package signing are
mixed with servers which don't use package signing.

Signed-off-by: Lorenz Bucher <lorenz.bucher@gmx.de>
---
 fs/cifs/connect.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 56c152d..9d06dd8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1104,6 +1104,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
                        if (!value || !*value) {
                                cERROR(1, "no security value specified");
                                continue;
+                       } else if (strnicmp(value, "krb5mi", 6) == 0) {
+                               vol->secFlg |= CIFSSEC_MAY_KRB5 | 
+                                       CIFSSEC_MAY_SIGN;
                        } else if (strnicmp(value, "krb5i", 5) == 0) {
                                vol->secFlg |= CIFSSEC_MAY_KRB5 |
                                        CIFSSEC_MUST_SIGN;
-- 
1.7.9.5
