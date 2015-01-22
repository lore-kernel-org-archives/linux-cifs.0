From: Niklas Cassel <niklas.cassel@axis.com>
Subject: [PATCH] cifs: fix MUST SecurityFlags filtering
Date: Thu, 22 Jan 2015 14:16:34 +0100
Message-ID: <1421932594-5878-1-git-send-email-niklass@axis.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, Niklas Cassel <niklass@axis.com>
To: <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

If CONFIG_CIFS_WEAK_PW_HASH is not set, CIFSSEC_MUST_LANMAN
and CIFSSEC_MUST_PLNTXT is defined as 0.

When setting new SecurityFlags without any MUST flags,
your flags would be overwritten with CIFSSEC_MUST_LANMAN (0).

Signed-off-by: Niklas Cassel <niklass@axis.com>
---
 fs/cifs/cifs_debug.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 9c56ef7..7febcf2 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -606,9 +606,11 @@ cifs_security_flags_handle_must_flags(unsigned int *flags)
 		*flags = CIFSSEC_MUST_NTLMV2;
 	else if ((*flags & CIFSSEC_MUST_NTLM) == CIFSSEC_MUST_NTLM)
 		*flags = CIFSSEC_MUST_NTLM;
-	else if ((*flags & CIFSSEC_MUST_LANMAN) == CIFSSEC_MUST_LANMAN)
+	else if (CIFSSEC_MUST_LANMAN &&
+		 (*flags & CIFSSEC_MUST_LANMAN) == CIFSSEC_MUST_LANMAN)
 		*flags = CIFSSEC_MUST_LANMAN;
-	else if ((*flags & CIFSSEC_MUST_PLNTXT) == CIFSSEC_MUST_PLNTXT)
+	else if (CIFSSEC_MUST_PLNTXT &&
+		 (*flags & CIFSSEC_MUST_PLNTXT) == CIFSSEC_MUST_PLNTXT)
 		*flags = CIFSSEC_MUST_PLNTXT;
 
 	*flags |= signflags;
-- 
2.1.4
