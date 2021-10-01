Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C11C4332F
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38AB96136A
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhJAM06 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354351AbhJAM0z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:26:55 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6091CC061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=gcOkDaciJ1NsJos0u7ZxZoxHkGE3C4YqugB+34yYavo=; b=vKCGu/28skQbnfh99qwUM8S51Z
        XNw74VOAx+7SovGYfWueL9CbaMtZOLuUjiGeO/zkCERKfY5hW5NSGxZ09gXFuVQjFVngAhpLFv3qT
        g+BmND9Fez/kNMAD0SSf0AK4I87PMvFm87thPVhadC/7hToXgzvIL0My2GxjgsmHqo6fbwRKyO25t
        40D/xR2kscqV9jkY56vxOmJQJtCl9Yjef9XCuikJ6ALLJnyBaTI1mUBr8HjIabwJX1w7h9BxDk/Yw
        C2enCAbAMj8kixNJXAs6oLDKhcRGcJ5gn7Iyp6fjzSxdZ16cUTtZ9ph9v43mzLgZ22WdQr20qhwmT
        u4s60TGeUeOUd5I6yZk53T6EV6Vuc8lhHozoTEhIW2Lm/Zs26t+ubL2tu2kaTcs/NSGCER5ZNR5EB
        h3YUQlaEKLvN1FdhNhlW+4eaXImSpQtYkmo6zMZHz5KgwuhZLXRSUx56XtLEWJm+zqcvcEwvIM1TY
        ET2cXf/M9X3VVC5AnRc4AgAA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIU-0013Z3-2N; Fri, 01 Oct 2021 12:05:50 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 16/20] ksmbd: check PDU len is at least header plus body size in ksmbd_smb2_check_message()
Date:   Fri,  1 Oct 2021 14:04:17 +0200
Message-Id: <20211001120421.327245-17-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Note: we already have the same check in is_chained_smb2_message(), but there it
only applies to compound requests, so we have to repeat the check here to cover
both cases.

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
index 7ed266eb6c5e..541b39b7a84b 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -338,6 +338,9 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 	if (check_smb2_hdr(hdr))
 		return 1;
 
+	if (len < sizeof(struct smb2_pdu) - 4)
+		return 1;
+
 	if (hdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
 		ksmbd_debug(SMB, "Illegal structure size %u\n",
 			    le16_to_cpu(hdr->StructureSize));
-- 
2.31.1

