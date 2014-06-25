From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] fs: cifs: cifsencrypt.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Wed, 25 Jun 2014 12:42:34 +0200
Message-ID: <1403692954-18881-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Because the string is zeroed before, it's better to just copy one character less, instead of using strlcpy in this case.

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/cifs/cifsencrypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 4934347..dcca8b3 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -307,7 +307,7 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 
 	memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
 	if (password)
-		strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
+		strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE - 1);
 
 	if (!encrypt && global_secflags & CIFSSEC_MAY_PLNTXT) {
 		memcpy(lnm_session_key, password_with_pad,
-- 
1.7.10.4
