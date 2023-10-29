Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79323C4167B
	for <linux-cifs@archiver.kernel.org>; Sun, 29 Oct 2023 05:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjJ2FDm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Oct 2023 01:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ2FDl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 Oct 2023 01:03:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BD3C5;
        Sat, 28 Oct 2023 22:03:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F197EC433C7;
        Sun, 29 Oct 2023 05:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698555819;
        bh=MxEvELIX1VCJ8n2KTB9rpSMvJBA5jHAN9kCXwNIb6UE=;
        h=From:To:Cc:Subject:Date:From;
        b=GKf1L/Mkh7QgCKPYk8j72HNU8A63TXE0E88aURkYZ/gq3pbVliWkfbPXrT6NXOb3F
         EMyR8ofKTJsXmiHz0mLej1+LQX0KVhN8m+5QC4XMCF1H+cMojCGMx5VtYCdKwHJd2+
         c8bTl5I2IrlshKdwWbV7xo9+HghSqDDPxi28WwdJWLBrFb+Og5KOv5LDjEGYKoT/D7
         Q0OnWwIg66g4ZRepb3cvkx9TEtTKEW+IIM+juAh6L/E0rwpO5+sIJVBWluWq383oNx
         yzS8uj204tHdyrRSXSxh4HjGSORvQlrhKOnAD/o0cKj3Knen+TDBZPXw90CSRbP6jJ
         o1zfSSGZQIX2w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] smb: use crypto_shash_digest() in symlink_hash()
Date:   Sat, 28 Oct 2023 22:03:00 -0700
Message-ID: <20231029050300.154832-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Simplify symlink_hash() by using crypto_shash_digest() instead of an
init+update+final sequence.  This should also improve performance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/smb/client/link.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index c66be4904e1f..a1da50e66fbb 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -35,37 +35,25 @@
 #define CIFS_MF_SYMLINK_MD5_ARGS(md5_hash) md5_hash
 
 static int
 symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 {
 	int rc;
 	struct shash_desc *md5 = NULL;
 
 	rc = cifs_alloc_hash("md5", &md5);
 	if (rc)
-		goto symlink_hash_err;
+		return rc;
 
-	rc = crypto_shash_init(md5);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init md5 shash\n", __func__);
-		goto symlink_hash_err;
-	}
-	rc = crypto_shash_update(md5, link_str, link_len);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with link_str\n", __func__);
-		goto symlink_hash_err;
-	}
-	rc = crypto_shash_final(md5, md5_hash);
+	rc = crypto_shash_digest(md5, link_str, link_len, md5_hash);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
-
-symlink_hash_err:
 	cifs_free_hash(&md5);
 	return rc;
 }
 
 static int
 parse_mf_symlink(const u8 *buf, unsigned int buf_len, unsigned int *_link_len,
 		 char **_link_str)
 {
 	int rc;
 	unsigned int link_len;

base-commit: 2af9b20dbb39f6ebf9b9b6c090271594627d818e
-- 
2.42.0

