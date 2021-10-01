Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D7AC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D5786136A
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354245AbhJAM1H (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353397AbhJAM1H (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:07 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2AFC061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=KPOvTBMqIWQXb+ncVEi2iT+wEwy5e5gkeoEpe3EpiD0=; b=e5svH502atsydS70tDAU/kUbD/
        yTK23CF4QXQ3ZpYkQH2Uxj5aSl6KQgQS8k29Vw7bsCZRObzNT56ktFhcr59TpxoejLd9x5F3UGdkh
        aog9ZbLpeCA2oqPAaO75WeAagU/3BD2X+2rkDMGVAfVIgldBCx2YPsMex7ZxMJkai1qWq/BF+w67W
        DDbDDoGNDNC7uEjx6hTT9bYle3W7Lxzan8FPnGv+m90VPu5Un9naV2V69SCB/Dy+xYTOtYrKO9ToD
        AUuT5CHAd+lgnWItNityI5fsMxijPZ5uo/QSuaR1RAWD7dkKNWBZe8ZvMSuOlePN87Na+C3OBVMQQ
        y73/Wa6xQqcdbfuKqFViDiVNRh4XC02IYYBKVWp4ZU1fQF5IiTu4BHCgsw9BdnSltdvodbVeUe2To
        BBy9kMcEZa9mi/6DclAMyEzEHLaos+SnSEtsu0sWSjZ7Ukvh0+YFH5vugB19sEpCz1E8wSH44Pxjj
        3+ohG25XjX9Q1iutOwSrxf7y;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIR-0013Z3-LQ; Fri, 01 Oct 2021 12:05:47 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 12/20] ksmbd: use ksmbd_req_buf_next() in ksmbd_verify_smb_message()
Date:   Fri,  1 Oct 2021 14:04:13 +0200
Message-Id: <20211001120421.327245-13-slow@samba.org>
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
 fs/ksmbd/smb_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 707490ab1f4c..e1e5a071678e 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -132,7 +132,7 @@ int ksmbd_lookup_protocol_idx(char *str)
  */
 int ksmbd_verify_smb_message(struct ksmbd_work *work)
 {
-	struct smb2_hdr *smb2_hdr = work->request_buf + work->next_smb2_rcv_hdr_off;
+	struct smb2_hdr *smb2_hdr = ksmbd_req_buf_next(work);
 	struct smb_hdr *hdr;
 
 	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
-- 
2.31.1

