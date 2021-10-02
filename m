Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61529C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B85061AF7
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhJBN1R (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN1Q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:27:16 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB77C0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=YnmZ4rBj6/U25JQdxacF0yp+BjlyrxXq7IN5+KtPqds=; b=mZi2Q8x4DDgyyuZ8eaWQxNEqbp
        6ka2v90Gh/Qjhl8vUQpT/OSUs/68wh9dAkp9BoD05l4tZjJlfQxq+WECFuocqFiNgcp/vm1rXTd45
        rP9GhsCii8tyPQSFGvg+2mOFKP3fo2Efk9CiXHHPxoQHbv4Kok4NFCNjrNHf7JUqL4H0iWngqFvJw
        fxZiYo/Wol+PxjsLZjkLk78GGv9to/WAi6WFnHn4aBNOhFnMSup+d9OUh9OBGmMAGHtutBSwPe6Jp
        +l2Ogg7ws92hJTnS9wgf9TgohZ6ueVOba4SUjAY0C6P1LgL1D/g3hwou1N4Ms5xRNETxRfI15M2gC
        GrJ3KJkQAHzUNPXsSz2HbEv70F12r6jQ+tUwr+UfwavcN3DifqPmuJQ2S3SIhZXAyCOhNVJBho4nH
        tWJqPFlyI5qoERt2uixAAHgHFB6dI6Xm/+d9IvQdfzuw9tH906ImQejpzCvAFe7MIdjUOfhswHnmy
        OsinaUKf/B02S58QtKnT+gSY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoR-001DcY-HS; Sat, 02 Oct 2021 13:12:23 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v6 08/14] ksmbd: use ksmbd_smb2_cur_pdu_buflen() in ksmbd_smb2_check_message()
Date:   Sat,  2 Oct 2021 15:12:06 +0200
Message-Id: <20211002131212.130629-9-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

No change in behaviour.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
---
 fs/ksmbd/smb2misc.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 76f53db7db8d..7ed266eb6c5e 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -333,14 +333,7 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 	struct smb2_hdr *hdr = &pdu->hdr;
 	int command;
 	__u32 clc_len;  /* calculated length */
-	__u32 len = get_rfc1002_len(pdu);
-
-	if (le32_to_cpu(hdr->NextCommand) > 0) {
-		len = le32_to_cpu(hdr->NextCommand);
-	} else if (work->next_smb2_rcv_hdr_off) {
-		len -= work->next_smb2_rcv_hdr_off;
-		len = round_up(len, 8);
-	}
+	__u32 len = ksmbd_smb2_cur_pdu_buflen(work);
 
 	if (check_smb2_hdr(hdr))
 		return 1;
@@ -395,7 +388,7 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 		 * Some windows servers (win2016) will pad also the final
 		 * PDU in a compound to 8 bytes.
 		 */
-		if (ALIGN(clc_len, 8) == len)
+		if (ALIGN(clc_len, 8) == ALIGN(len, 8))
 			return 0;
 
 		/*
-- 
2.31.1

