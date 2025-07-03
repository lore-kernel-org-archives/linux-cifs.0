Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70DE2DE701;
	Thu,  3 Jul 2025 09:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.188.205.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751534161; cv=none; b=WbTj7EQFE2i2RzNogMIAEbAx463LsAkZsNa/fiF25vvgcN+l1c1fvyhkbQ7/yatGsDJRyLGPxiHHYOJL281ndbUUbs7FylCgMgVFO98C5qQa7ORSC2zsKE32OtXopDE62af5uJphOt9kY0KLBcUYDwGJuEPO8QJL2rKwDJ4vDrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751534161; c=relaxed/simple;
	bh=IXGjNYrCCJ7z//O8GYBQaRJVFFgl9rp2iE2vE4wR4HM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bBo2KSRrzsAyuE8f+uKbEdQtETcUqhMqrvoaMqUfHz42TR9nbJ33nvuDnYYXTTyvIvklbqeiV2eBzzd7GPJVkmZWSo/r6EdYtHnaN1OmHJR5eYuYQTAdwPS1F7N+56t+ZbYsP3FFALKEhgVU8ClkswxlXzG++Zfgl+QHXMgU6ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=apgLy2d+; arc=none smtp.client-ip=93.188.205.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="apgLy2d+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1751534152;
	bh=IXGjNYrCCJ7z//O8GYBQaRJVFFgl9rp2iE2vE4wR4HM=;
	h=From:To:Cc:Subject:Date:From;
	b=apgLy2d+CCDpyBhkSBMPO9MoRvsMvL//U5NfSIqC/B7MuKLu0kPh7SZd318nhY5Tz
	 SkXrt17d2ZWrxzyLJWxEFDHmfJ4+RRPezHoaSXCAZ2OYm3pscQQyQaXw8s+Uuf7i8C
	 mwvsMZDL3N29Rib5j5Kiy7cHBoQR+8U2L0FeyHqg1t2/PNVi0kARCDutT1fPLIt/Rs
	 +qkS6VcFKmSQMC+D793ZOg5IiPbmuZ8jujUTjrFuqgs64895UNKWmULSce2laQPUW0
	 34fS2CnrkbwB9Q2ZQmguYbDB3PErMjINHTdylAyWeecDyo1txWyIZSdeYaPd9ppDC5
	 jW1cIDKkIr2Fg==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id D2AF41F707;
	Thu,  3 Jul 2025 12:15:52 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.177.185.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Thu,  3 Jul 2025 12:15:50 +0300 (MSK)
Received: from localhost.localdomain (unknown [10.190.6.76])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4bXrhy3qHMz16Hnq;
	Thu,  3 Jul 2025 12:15:45 +0300 (MSK)
From: Anastasia Belova <abelova@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anastasia Belova <abelova@astralinux.ru>,
	Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10] cifs: fix small mempool leak in SMB2_negotiate()
Date: Thu,  3 Jul 2025 12:15:28 +0300
Message-ID: <20250703091529.129846-1-abelova@astralinux.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: abelova@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 63 0.3.63 9cc2b4b18bf16653fda093d2c494e542ac094a39, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 194515 [Jul 03 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2025/07/03 05:31:00 #27614197
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Enzo Matsumiya <ematsumiya@suse.de>

commit 27893dfc1285f80f80f46b3b8c95f5d15d2e66d0 upstream.

In some cases of failure (dialect mismatches) in SMB2_negotiate(), after
the request is sent, the checks would return -EIO when they should be
rather setting rc = -EIO and jumping to neg_exit to free the response
buffer from mempool.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Cc: stable@vger.kernel.org
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
---
Backport fix for CVE-2022-49938
 fs/cifs/smb2pdu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 4197096e7fdb..fa75dc0a372d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -883,23 +883,24 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	} else if (rc != 0)
 		goto neg_exit;
 
+	rc = -EIO;
 	if (strcmp(server->vals->version_string,
 		   SMB3ANY_VERSION_STRING) == 0) {
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2.1 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		}
 	} else if (strcmp(server->vals->version_string,
 		   SMBDEFAULT_VERSION_STRING) == 0) {
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			server->ops = &smb21_operations;
@@ -913,7 +914,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		/* if requested single dialect ensure returned dialect matched */
 		cifs_server_dbg(VFS, "Invalid 0x%x dialect returned: not requested\n",
 				le16_to_cpu(rsp->DialectRevision));
-		return -EIO;
+		goto neg_exit;
 	}
 
 	cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
@@ -931,9 +932,10 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	else {
 		cifs_server_dbg(VFS, "Invalid dialect returned by server 0x%x\n",
 				le16_to_cpu(rsp->DialectRevision));
-		rc = -EIO;
 		goto neg_exit;
 	}
+
+	rc = 0;
 	server->dialect = le16_to_cpu(rsp->DialectRevision);
 
 	/*
-- 
2.43.0

