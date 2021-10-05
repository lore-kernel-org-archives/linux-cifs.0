Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C4FC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FBD561354
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhJEFGB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 01:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhJEFGB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 01:06:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC71C061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 22:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=hTRbEAqucp4EFXp/e8btO1P5REZqGdjAp7JF89IXpXM=; b=L1MLcAgaTNyeqPB6fRJHkcRvZ8
        /KxAaCdVJQAyGKN5bnitGP7pluD5Y6IndOHiPc1BW2pwTeQnp2XBmulz6QoVCRCJ5XkH9dmrKzTqW
        LE0b5sWxq3uTphrRnHYbVwC/wmX0kVmBHCPEtiv3JyNDfyDgLpW7+2Sj+4PNDW2OFnZZe4fEVbeO1
        6Dk+lCTTph0rLZsGpfpB9YS895l6MaWq75YFEQB5uf0I+jnWjbGHkXx+K/FWHgqvyHa8mvdxf1qHZ
        JOQdSMnidU1J0lwFKOWULljfNPcXgp9s8w7Dzk1fzdQplkQhpNdqsc2FqBTcK6A97cDh5JMwjg4Er
        KqJ4NsFrNwD+cHkB6u6dXahf9zosqDaP5mpxEGrQ8nXeUuBpRXKSSaDF4Y4RjUFvUPfRu4m11aok8
        kQgqDASUD0B4Vh1vNZTNOHkLHp0pGhuL9BwvokzEEVSc98WUTz/zruoU8S5GuauCikDGthuq66AMw
        uDZx2xGV8WwkYDSy1V9YKsqg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXccb-001Yyq-3a; Tue, 05 Oct 2021 05:04:09 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v7 4/9] ksmbd: check buffer is big enough to access the SMB2 PUD body size field
Date:   Tue,  5 Oct 2021 07:03:38 +0200
Message-Id: <20211005050343.268514-5-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005050343.268514-1-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
---
 fs/ksmbd/smb2misc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 7ed266eb6c5e..50521b5a50b5 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -350,6 +350,9 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 		return 1;
 	}
 
+	if (len < sizeof(struct smb2_pdu) - 4)
+		return 1;
+
 	if (smb2_req_struct_sizes[command] != pdu->StructureSize2) {
 		if (command != SMB2_OPLOCK_BREAK_HE &&
 		    (hdr->Status == 0 || pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE)) {
-- 
2.31.1

