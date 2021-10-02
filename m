Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1BFC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFD2661B08
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhJBN1M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN1M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:27:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B3DC0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=gcOkDaciJ1NsJos0u7ZxZoxHkGE3C4YqugB+34yYavo=; b=FwMviH4ZgqK+hrX6jBGJHYDrHz
        WRWC7u9oP0cWvYjkr4D/Q5trMY0hkBfCDH00EinbSvjhsGZLrYjDP/vlaptj0HSGqDmm/g3qdMav2
        YkVK6VdsWOvouXDACUx8UjQqeXhOM/uhH058LmhPpb5c7m3be+VMFyh8fEzUatjVplepAO0Z2T/j+
        dAeBbiPcdbt8XKT+RvYMNLA/hUlRpkkxyQm2cUXYnbQnx02p0urJHBJT/WDopPmk7ijgOvY33outK
        bNpHaE2GHTL2C4UoJBwue/aY0w+CPS3iwOFWvgApdUJdU8TnNpouc32Beo/EA6YWo5GURkecv7+o4
        6RQcTfS5fGSvH2cCqRGDILST3TSne1wTgHBD1a/SAuoKNXKBWb/9iV1Kw99UogD3TU/QyxlfXS+Uc
        kI7XB3+24z1ImGJCLxuN0kbwDr6p/HDUttjzL/d7mFVu64/p9DjHpTHDzqEYM7RRP865TR3OTgCSQ
        Jc5FdRJOs8EF4DY+hEZTEmE+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoS-001DcY-3q; Sat, 02 Oct 2021 13:12:24 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v6 09/14] ksmbd: check PDU len is at least header plus body size in ksmbd_smb2_check_message()
Date:   Sat,  2 Oct 2021 15:12:07 +0200
Message-Id: <20211002131212.130629-10-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
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

