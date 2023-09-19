Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F7ACD5BCE
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Sep 2023 14:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbjISOtV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Sep 2023 10:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjISOtU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Sep 2023 10:49:20 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A86BF
        for <linux-cifs@vger.kernel.org>; Tue, 19 Sep 2023 07:49:15 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-27496d4e13bso2819021a91.1
        for <linux-cifs@vger.kernel.org>; Tue, 19 Sep 2023 07:49:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695134954; x=1695739754;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YOH0tvCbmK3/zGqL3H/7oCLCW8dF+DgMW8AqitG0OiA=;
        b=YUGu5gvRIyh47AdaOnMJ/dv4bbxwE4e23Td38vXIZVAme0zqkOgmDntCQjjYeHEfI9
         s6IQlmfhxGOZf9aoSrkSjy98TKOgHRGBG52MHbSaVn4A74dVxj4b9E5xRIik+6FNFViI
         ZYLSbhMOJjbo8fWp39aQuz5ocHe4nena4vc3u2NAICYE8Iyg04kV2xojOCn1rG8wVqa3
         go/fEqtjwMgaILwdb6TRAtbczbh5B6vUOEf+PbO1qClnvlI7oOfT1t0Jx7pBCxE5DFR6
         GLNZYQKGHtdI8dAabUzTzNUtJ/mfLkV4vVr3g2go1XPHzzwIKuTtA9O61Lw0BTJHR99S
         zSOg==
X-Gm-Message-State: AOJu0YxiNucvr5bgy5thYBHfqS40PzwGLXDdZbwWVGZsevkjRYlSz+bC
        yVL2FnXmTkGbUEUQ3XKSBt6jvVs86Gs=
X-Google-Smtp-Source: AGHT+IF+w33U69m78ywKPXpiwGo0/PP1kWZTwROLwFwLI8eEDXsqSco6IaPS8VuRmU1u9D1COXDYeQ==
X-Received: by 2002:a17:90b:3103:b0:25d:eca9:1621 with SMTP id gc3-20020a17090b310300b0025deca91621mr9585776pjb.6.1695134954346;
        Tue, 19 Sep 2023 07:49:14 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id cu2-20020a17090afa8200b0026b6d0a68c5sm8866843pjb.18.2023.09.19.07.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 07:49:13 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: return invalid parameter error response if smb2 request is invalid
Date:   Tue, 19 Sep 2023 23:47:39 +0900
Message-Id: <20230919144740.52610-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If smb2 request from client is invalid, The following kernel oops could
happen. The patch e2b76ab8b5c9: "ksmbd: add support for read compound"
leads this issue. When request is invalid, It doesn't set anything in
the response buffer. This patch add missing set invalid parameter error
response.

[  673.085542] ksmbd: cli req too short, len 184 not 142. cmd:5 mid:109
[  673.085580] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  673.085591] #PF: supervisor read access in kernel mode
[  673.085600] #PF: error_code(0x0000) - not-present page
[  673.085608] PGD 0 P4D 0
[  673.085620] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  673.085631] CPU: 3 PID: 1039 Comm: kworker/3:0 Not tainted 6.6.0-rc2-tmt #16
[  673.085643] Hardware name: AZW U59/U59, BIOS JTKT001 05/05/2022
[  673.085651] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[  673.085719] RIP: 0010:ksmbd_conn_write+0x68/0xc0 [ksmbd]
[  673.085808] RAX: 0000000000000000 RBX: ffff88811ade4f00 RCX: 0000000000000000
[  673.085817] RDX: 0000000000000000 RSI: ffff88810c2a9780 RDI: ffff88810c2a9ac0
[  673.085826] RBP: ffffc900005e3e00 R08: 0000000000000000 R09: 0000000000000000
[  673.085834] R10: ffffffffa3168160 R11: 63203a64626d736b R12: ffff8881057c8800
[  673.085842] R13: ffff8881057c8820 R14: ffff8882781b2380 R15: ffff8881057c8800
[  673.085852] FS:  0000000000000000(0000) GS:ffff888278180000(0000) knlGS:0000000000000000
[  673.085864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  673.085872] CR2: 0000000000000000 CR3: 000000015b63c000 CR4: 0000000000350ee0
[  673.085883] Call Trace:
[  673.085890]  <TASK>
[  673.085900]  ? show_regs+0x6a/0x80
[  673.085916]  ? __die+0x25/0x70
[  673.085926]  ? page_fault_oops+0x154/0x4b0
[  673.085938]  ? tick_nohz_tick_stopped+0x18/0x50
[  673.085954]  ? __irq_work_queue_local+0xba/0x140
[  673.085967]  ? do_user_addr_fault+0x30f/0x6c0
[  673.085979]  ? exc_page_fault+0x79/0x180
[  673.085992]  ? asm_exc_page_fault+0x27/0x30
[  673.086009]  ? ksmbd_conn_write+0x68/0xc0 [ksmbd]
[  673.086067]  ? ksmbd_conn_write+0x46/0xc0 [ksmbd]
[  673.086123]  handle_ksmbd_work+0x28d/0x4b0 [ksmbd]
[  673.086177]  process_one_work+0x178/0x350
[  673.086193]  ? __pfx_worker_thread+0x10/0x10
[  673.086202]  worker_thread+0x2f3/0x420
[  673.086210]  ? _raw_spin_unlock_irqrestore+0x27/0x50
[  673.086222]  ? __pfx_worker_thread+0x10/0x10
[  673.086230]  kthread+0x103/0x140
[  673.086242]  ? __pfx_kthread+0x10/0x10
[  673.086253]  ret_from_fork+0x39/0x60
[  673.086263]  ? __pfx_kthread+0x10/0x10
[  673.086274]  ret_from_fork_asm+0x1b/0x30

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/server.c   | 4 +++-
 fs/smb/server/smb2misc.c | 4 +---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 5ab2f52f9b35..32347fec33c4 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -115,8 +115,10 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 	if (check_conn_state(work))
 		return SERVER_HANDLER_CONTINUE;
 
-	if (ksmbd_verify_smb_message(work))
+	if (ksmbd_verify_smb_message(work)) {
+		conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
 		return SERVER_HANDLER_ABORT;
+	}
 
 	command = conn->ops->get_cmd_val(work);
 	*cmd = command;
diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index e881df1d10cb..23bd3d1209df 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -440,10 +440,8 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 
 validate_credit:
 	if ((work->conn->vals->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
-	    smb2_validate_credit_charge(work->conn, hdr)) {
-		work->conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
+	    smb2_validate_credit_charge(work->conn, hdr))
 		return 1;
-	}
 
 	return 0;
 }
-- 
2.25.1

