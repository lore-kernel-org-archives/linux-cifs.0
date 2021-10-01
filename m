Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF576C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE1616136A
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353430AbhJAM1T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353431AbhJAM1T (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:19 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BF6C061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=YnmZ4rBj6/U25JQdxacF0yp+BjlyrxXq7IN5+KtPqds=; b=lraTKNdJ+oAkjoOYoTjUIBncel
        YFHm+95QnxJiMKoq6I41zOClYDFGtnKFwx+iKq0nuLvXjhlkXaYKpXIew+1qwmbgA3xA6oulsqj5R
        nC9QE+R+8vzxQK6eZwMUltWZvp2cByWg1T9BTG6DsBD0afEdoq1Cwr08l8od+hpSyb7n46176hJzD
        T4qzZFuY9Ku1v9hko8X6urk46tOdVl6HtX8x9McIvnwwWJYuTV7MqYZc5lAyV0rDV26hVzZKnHMl8
        V2CMPDo69h8zN2S2tod1AkTM4Pxoi0JNo0+5mdxtgWOUEnUZxMlH8GQzOWLetbZBSbP925pl2yBO+
        2Ow0b+UECkmbEaLSHDQ/CmrwWzkz7q7TfR68K2eZQLz+06gJNWI/Jy/DOj+uOj5GVWtEy9S65xDGl
        ZBQrb7g6mLywT9UEj26otwOcfhh3SbPfjabkHDC2ofauOC/9XbmIBVIpc1LSoNW5P9n5TIHM7QnKE
        KJdWGzwXjTI0+Ut7JWkLn3wX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIT-0013Z3-Hf; Fri, 01 Oct 2021 12:05:49 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 15/20] ksmbd: use ksmbd_smb2_cur_pdu_buflen() in ksmbd_smb2_check_message()
Date:   Fri,  1 Oct 2021 14:04:16 +0200
Message-Id: <20211001120421.327245-16-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
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

