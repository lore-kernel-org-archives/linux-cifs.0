Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B52C77B7F
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 10:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjEQKAT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 06:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjEQKAP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 06:00:15 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5232959E0
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 03:00:09 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ae4d1d35e6so5360735ad.0
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 03:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684317609; x=1686909609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hqr2StWEczNKgP4YoRPS24y81WK/KelCzFsq0lK4DHk=;
        b=mpnMpsRf1ZIpUj3ARG0fql988CijaGM+9remSB6SVaktEyb3psRj2NfbMeEqZiG6OV
         8EuLF0rk1Br4kXCLfAw2R3o/NoXmaqrBr20IqNRkzDWBwSV91651ZPqs6uFrB1+tylXJ
         gOrpFYPiMxLJMTf7llQxFE2CfL+ngb84NMoocvLnowmmFOGyxIGQpdBHKyGmpIDNUBo/
         Y9Yqp/25N3tVcg67UzSeLjzmjJZGZ6ZSVO1WGLE43AL4zFJPAkvT9B0JhOFZGa08wCJ2
         Fg58YuHcHodSBPJFe8fP7dKS9dMZqKSDV3H5s+Ig/ihP1FodBNAmrESNUOvHOxY5M+L3
         +KdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684317609; x=1686909609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hqr2StWEczNKgP4YoRPS24y81WK/KelCzFsq0lK4DHk=;
        b=LDqdrhtfJpyx8WRr8fOAkHpSitHvCMo2pPVHCWoe6xqSz8oXXXX+7qv5Y0ItXQZtp9
         AsT1Wl56txf+nRPfPUGazfPfCCEqmzHzxXeynM15TWM1GzpyN4FqEf26nsx3v8KCNKZJ
         6vfjfN3WSU55barMuLUkfx6rPDlS3WqLtRDMK9bAT3GOJDNLIliy6i6NSv+ZWfUGHN/7
         4hziZZdhj8qEKfSWsK9T8C7V9k0xlet/njTEtsYUX5rBs1SVOy3KCe+p1xiPfP++w8ZV
         91XaLX3y+kWxGpJhFFjnjV6HasLOYjQR9g29jLVen0NTNIgoSu4bNGOiIzPQU8SDcl/o
         wyIA==
X-Gm-Message-State: AC+VfDzEdTi0ANdgyXDFgpMKP/EtZvR0DapZV7BmsKX19HUhAPnmlTYy
        4fQ19Nn7N2+k4QqfyGK7Hc4=
X-Google-Smtp-Source: ACHHUZ5vHa42vdqznhNY4F+OcUL6z/UVTPYiDWSLXk4wxW2B81zBbijaRuYF0DkYx4+kpBdRVSECuQ==
X-Received: by 2002:a17:903:41d0:b0:1ad:55e6:16fe with SMTP id u16-20020a17090341d000b001ad55e616femr30128903ple.15.1684317608530;
        Wed, 17 May 2023 03:00:08 -0700 (PDT)
Received: from localhost.localdomain (netlab-9.cs.nctu.edu.tw. [140.113.203.211])
        by smtp.gmail.com with ESMTPSA id jl1-20020a170903134100b001a4edbabad3sm6617912plb.230.2023.05.17.03.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 03:00:08 -0700 (PDT)
From:   HexRabbit <h3xrabbit@gmail.com>
To:     linkinjeon@kernel.org
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org, HexRabbit <h3xrabbit@gmail.com>
Subject: [PATCH] ksmbd: fix slab-out-of-bounds read in smb2_handle_negotiate
Date:   Wed, 17 May 2023 09:59:51 +0000
Message-Id: <20230517095951.3476020-1-h3xrabbit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Check request_buf length first to avoid out-of-bounds read by
req->DialectCount.

[ 3350.990282] BUG: KASAN: slab-out-of-bounds in smb2_handle_negotiate+0x35d7/0x3e60
[ 3350.990282] Read of size 2 at addr ffff88810ad61346 by task kworker/5:0/276
[ 3351.000406] Workqueue: ksmbd-io handle_ksmbd_work
[ 3351.003499] Call Trace:
[ 3351.006473]  <TASK>
[ 3351.006473]  dump_stack_lvl+0x8d/0xe0
[ 3351.006473]  print_report+0xcc/0x620
[ 3351.006473]  kasan_report+0x92/0xc0
[ 3351.006473]  smb2_handle_negotiate+0x35d7/0x3e60
[ 3351.014760]  ksmbd_smb_negotiate_common+0x7a7/0xf00
[ 3351.014760]  handle_ksmbd_work+0x3f7/0x12d0
[ 3351.014760]  process_one_work+0xa85/0x1780

Signed-off-by: HexRabbit <h3xrabbit@gmail.com>
---
 fs/ksmbd/smb2pdu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index cb93fd231..972176bff 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1057,16 +1057,16 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 		return rc;
 	}
 
-	if (req->DialectCount == 0) {
-		pr_err("malformed packet\n");
+	smb2_buf_len = get_rfc1002_len(work->request_buf);
+	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
+	if (smb2_neg_size > smb2_buf_len) {
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 		rc = -EINVAL;
 		goto err_out;
 	}
 
-	smb2_buf_len = get_rfc1002_len(work->request_buf);
-	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
-	if (smb2_neg_size > smb2_buf_len) {
+	if (req->DialectCount == 0) {
+		pr_err("malformed packet\n");
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 		rc = -EINVAL;
 		goto err_out;
-- 
2.25.1

