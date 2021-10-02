Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C728FC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A69EA61B08
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhJBN1F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN1F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:27:05 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B791C0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=FbToP3cBCVM9Ma6brMXNh+tonQqcwo/eFaZFr4z6ESg=; b=hPAnmClK2iP+r5IFGl6oRC22cs
        IuL4jFr31UnqSakU7q/+ObRldBNkqdvv/kNhykcOLcAYoWdW8I6ih4q6O/FRqxtJMD/lxwSTZF2nd
        aKzcC6uSxPOOEV9k6kWJOzU2c2eliPF3u8aNdiTh8vgJzxfpOcsGV03sz/VrRtvbckcPmOTsiH5mC
        tiuzZgLgdCVuiOAmpimYWFLS9JK3csymShXdLr8y9/yUUIrSgAXkBiMAtKtyu4dCIbTDlMONOtDAX
        dkTDkVziEtf/kn+Zn13FfogLScplDVyQ6XfU9VAX+QH1/Wf5GCt3TH6QrxE5PmJbJ4bGoMLnp1eTy
        vCR3A+nXC8eyV2rZGkdF1uEnbQC1sNXvazvUwKIw2ttN0xo/CHJzLaREKqP9dWtGhCOQUe7XIcCz4
        In831AlXruLHx1EbHRDoiTyJDy79C/R4yLtM1QZppst9gLueJzH2vpNL+IR4p491jSD/6DOMr2Nuv
        k77Esj/7037bX6lp+nK7T9Ea;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoQ-001DcY-1o; Sat, 02 Oct 2021 13:12:22 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>
Subject: [PATCH v6 05/14] ksmbd: use ksmbd_req_buf_next() in ksmbd_verify_smb_message()
Date:   Sat,  2 Oct 2021 15:12:03 +0200
Message-Id: <20211002131212.130629-6-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

No change in behaviour.

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

