Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F99CC433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC8C861B08
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhJBN1b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN1a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:27:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970A6C0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=uDE1hT2AYr4GnzXWR53eORG83zzTctwt6f2au/8awBI=; b=QCk31XxwfLkL8P5F15D3gOOYLg
        vWm8icf/0flnF+BWtmMGgLoVH20vHarztqfkLeiljw80yMi0K3H1Wu7xwgTf91jfERdmDZuiad51i
        Fy7iQ9+NN3DfpKt+p4waF0qSFh6foyqaNsAXWDOwc0gd/EtBv6vr1zBETivl6yZXUCnXK1aHiJihC
        +pxVX0F07ucC46iH8xHqSGLPoDwNOPaFA7TfFK7RcSloC7n/QcAWEk/03+MU3db7jIV5Pfsd4AubO
        YUi+ov5ZIDQohU+k8oSi2gQreYItmt7aCnsNiygnPtYBf0KnqQX2HziCTqy/t8wXdUer4wzlGe/1F
        Z9s01CM7IvPKfN+lg860ved2FvrWTzHKxnaG27AR64hrVzwhiyEVsTBK7CO7IZhOE1M1GPS6XLDRk
        Jrfp24e8nTvZiNrN9Ucynt7DiuQqcv1O/oDIZdJwvay8/xHnw2/PGkZ1UfTP3Yy9yWrGnfrXgU80W
        cgqcLC5DG8NjM4gXDgnV3rlK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoV-001DcY-2U; Sat, 02 Oct 2021 13:12:27 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>
Subject: [PATCH v6 14/14] ksmdb: validate credit charge after validating SMB2 PDU body size
Date:   Sat,  2 Oct 2021 15:12:12 +0200
Message-Id: <20211002131212.130629-15-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

smb2_validate_credit_charge() accesses fields in the SMB2 PDU body, but until
smb2_calc_size() is called the PDU has not yet been verified to be large enough
to access the PDU dynamic part length field.

Signed-off-by: Ralph Boehme <slow@samba.org>
---
 fs/ksmbd/smb2misc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 541b39b7a84b..6e6d64b796c9 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -373,12 +373,6 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 		}
 	}
 
-	if ((work->conn->vals->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
-	    smb2_validate_credit_charge(hdr)) {
-		work->conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
-		return 1;
-	}
-
 	if (smb2_calc_size(hdr, &clc_len))
 		return 1;
 
@@ -416,6 +410,12 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 		return 1;
 	}
 
+	if ((work->conn->vals->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
+	    smb2_validate_credit_charge(hdr)) {
+		work->conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
+		return 1;
+	}
+
 	return 0;
 }
 
-- 
2.31.1

