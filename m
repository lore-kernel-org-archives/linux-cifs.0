Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BABEC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32E0C61381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhJEF1O (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 01:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhJEF1N (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 01:27:13 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC96C061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 22:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=RUdFWXqKL86Vn/W/JmGHXQDoh/kv/WS0AT06GqsQiCc=; b=is9IiUNxg+y10i3jgmWx0EmVdl
        P17V1Yi+EtdPLpZh5AkkU1b5hRMkff4nr1YkbtHyM84MeTcx3d4Z8rfI/SoZ+4fLVE97utbSdzHyl
        srTkFRxEwpiR/bAq+3EmK9MuRtIF7aS4SHiaO2h2tC3JsVrrhHKZutE2/ATxZWTIXlyzZYb7S92hJ
        pzzfDoh0n3BtvWqWaCLhO8XYZCJ9EE9mnUiq9ygop5pKx3nhH9MDUISpidFJe2qvMzNWw8yomYv4C
        rZO9BQiv87GMP8TPWlMPGNaHCd2YBc5BZoVHC1RYDbvyw8LrjN0Sbm4/OLsuv7gY6f4iNsxlPq13u
        hMxbWh8j5E//HkRs6QoYJPou5D2qFZNQlChisUWfgthaBolY97uMPAkAJyL58aqEdQpGkyqWwOAoI
        Gsm0QuX2z9q4GTvah8ydw49jPOTliUgo7oQTRsT8s2oeD7uw4h56rg2avt9SMX4IKIiC43PRHe9a0
        NfOdiQ1Dfga190I65dnJFRsP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXcca-001Yyq-GI; Tue, 05 Oct 2021 05:04:08 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v7 3/9] ksmbd: add and use ksmbd_smb2_cur_pdu_buflen() in ksmbd_smb2_check_message()
Date:   Tue,  5 Oct 2021 07:03:37 +0200
Message-Id: <20211005050343.268514-4-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005050343.268514-1-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org>
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
 fs/ksmbd/smb2misc.c | 36 +++++++++++++++++++++++++++---------
 fs/ksmbd/smb2pdu.h  |  1 +
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 2cc031c39514..7ed266eb6c5e 100644
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
@@ -427,3 +420,28 @@ int smb2_negotiate_request(struct ksmbd_work *work)
 {
 	return ksmbd_smb_negotiate_common(work, SMB2_NEGOTIATE_HE);
 }
+
+/**
+ * ksmbd_smb2_cur_pdu_buflen() - Get len of current SMB2 PDU buffer
+ * This returns the lenght including any possible padding.
+ * @work: smb work containing request buffer
+ */
+unsigned int ksmbd_smb2_cur_pdu_buflen(struct ksmbd_work *work)
+{
+	struct smb2_hdr *hdr = ksmbd_req_buf_next(work);
+	unsigned int buf_len;
+	unsigned int pdu_len;
+
+	if (hdr->NextCommand != 0) {
+		/*
+		 * hdr->NextCommand has already been validated by
+		 * init_chained_smb2_rsp().
+		 */
+		return __le32_to_cpu(hdr->NextCommand);
+	}
+
+	buf_len = get_rfc1002_len(work->request_buf);
+	pdu_len = buf_len - work->next_smb2_rcv_hdr_off;
+	return pdu_len;
+}
+
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index a6dec5ec6a54..c5fa8256b0bb 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -1680,6 +1680,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work);
 
 /* smb2 misc functions */
 int ksmbd_smb2_check_message(struct ksmbd_work *work);
+unsigned int ksmbd_smb2_cur_pdu_buflen(struct ksmbd_work *work);
 
 /* smb2 command handlers */
 int smb2_handle_negotiate(struct ksmbd_work *work);
-- 
2.31.1

