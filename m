Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE889C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEDD261373
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhJEF1H (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 01:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhJEF1G (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 01:27:06 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501FCC061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 22:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=acdj2rVLpy5Dy5k7x+SeWtBBddAAA6m51QOfa2uKNQs=; b=aBA0QqfsHcVn3bOdzeaap/ZBlG
        CcLiATrrRwodoucZeAfYh6e1s6+UTAWAptys93V8k0YD9xOXU4jmCC1api9nvxXQk+2yf9TfEvOqd
        ks54lbKb9ZY5xPHjKBti2lfS7R2grQwhWMCrzZ/X2h9UmXhjJrIk67NJFDEZi02Gzd0zw6Q1+hEyh
        dv79pqpF0yDlhCyTiJfSrDGw+UgorxKSMK5QbGuHTXhUuWzaL5aJI2XLNC7kmmB4nHSrKsIhlMRai
        3kJeXDP7BevT6Udv1Q3k+SB0DUqZTE1d+EelOHq7cI4q3+0dXph2JwvTiQET9QKtvr5yEE0/OmmJG
        iDN2rOsGlOFI7jV26HrEvNZradfpIj8Hg/+WOdthc90/oexqplYdEIR2HqjDmKlefA5uMcmFDdg3p
        2QTrXsM5sYQyN3RApEUPEsLZra9I8gwhdRHUfsxLjfeNjHWqMRhNQTy7KOPmlHr+pM+wHlCaQhYZ/
        mMinOflFBHEO+sQ2cqKSbWNr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXccb-001Yyq-NH; Tue, 05 Oct 2021 05:04:09 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>
Subject: [PATCH v7 5/9] ksmdb: validate credit charge after validating SMB2 PDU body size
Date:   Tue,  5 Oct 2021 07:03:39 +0200
Message-Id: <20211005050343.268514-6-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005050343.268514-1-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org>
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
index 50521b5a50b5..1f14120a0e48 100644
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

