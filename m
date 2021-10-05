Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FD7C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5342D61373
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhJEF1C (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 01:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhJEF1C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 01:27:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0927AC061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 22:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=FbToP3cBCVM9Ma6brMXNh+tonQqcwo/eFaZFr4z6ESg=; b=wyHUIsyvNpRcIpO9BmJc4A4OaE
        xxUztab4d0eUxx+y4wL01/W3qbiTM4bZwDXZTAPgP88TAVDgGpjwQimoDnCq7j4KvMxfopvfYMutd
        gGVkMkP68gAM15pqcjVYeCOuTOYn7S6tkJvbFVpbKSVNU1e2D9QlAHYGbKf+6iX9O3b3tX3rcGOAC
        0MxZTo+PFEzguoTV+nBr/l4G/541abNt7ikaPYjKOOI1SmS/o5ID3pLMo9waC6vB9oiYn4J/VgVuP
        nGQP7liinhblRq6NdiEHHmHafniw79+99BhDj/auP0qXTxNnQzU0C5Xd3q95x+FSkQRIGV5KVA+I+
        jCpWX6aql7HZftNSU6Vqe84i53MM/RN6mtxtXxY7tzq3xOH4l8Ik5W0gEl9m/b9uNHIRkzDD+pzBQ
        0+xlfi69KWVYrtSsnAMuaDIEZbojKrI3kzPFLiacMoVUgBwujV1/G++dJCLgGp++LcfvCz3RIuDQU
        wfmaDjKWQKbgd+Fxm4N7vTLN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXccZ-001Yyq-8k; Tue, 05 Oct 2021 05:04:07 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>
Subject: [PATCH v7 1/9] ksmbd: use ksmbd_req_buf_next() in ksmbd_verify_smb_message()
Date:   Tue,  5 Oct 2021 07:03:35 +0200
Message-Id: <20211005050343.268514-2-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005050343.268514-1-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org>
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

