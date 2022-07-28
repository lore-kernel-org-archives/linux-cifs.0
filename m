Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4A7C04A68
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Jul 2022 13:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiG1NdY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Jul 2022 09:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiG1NdY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Jul 2022 09:33:24 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2215140F
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 06:33:23 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id 23so1549101pgc.8
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 06:33:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UJvPsGYKNP5nXy7zeosEoRnXbNszDF7V9LbxOA6BNRw=;
        b=BTRVi/hJmcDsLoGRRWJ9R+SWw5L9QZXWXxKHr3Ff1TbxazJ+9pdYcasQXMEe5CygxP
         6+N8llcltK8MNaSlyJQAb2+RPGSznL4ua++WEMm6lBXO/b0SDUkvvEkDQ4GIEbvE3A3/
         4yHOApYonVuReIZOmJmWKkH3m7U2N08pMqiWRjNKFyQJUN4/ciLmqPFUZsC+EaoiFaAa
         hzWRQ6AvizOU55L1wuawiu+aGOXaoTzcjj64QkXvSZCNNPSGim68p3K2nrFYx91N46vX
         LvrszoCp2g5TxJAjY6k5jpGpN7WCLMQjSCsDnoNHERCofc9F7cwW+90AOXNvpXzlWI7p
         /O4Q==
X-Gm-Message-State: AJIora/qEkzFtEU9sqdPUjUQXxn9Jl5nMP8YmeYzwGJJDV5BCr0QAlzV
        ld10If+6ox+hIpC8n1k0xqNzsnGRDhI=
X-Google-Smtp-Source: AGRyM1u8H9ovOhJ5l7wIiVvaVcLjB0Te7zfoEekpBSIa26bSzFCdCOqDStPn7JPHkQ41WdgFVZegjw==
X-Received: by 2002:a05:6a00:8c8:b0:52c:887d:fa25 with SMTP id s8-20020a056a0008c800b0052c887dfa25mr1525815pfu.86.1659015202873;
        Thu, 28 Jul 2022 06:33:22 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id m14-20020a63710e000000b0041b667a1b69sm960078pgc.36.2022.07.28.06.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:33:22 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        gregkh@linuxfoundation.org, Namjae Jeon <linkinjeon@kernel.org>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 2/5] ksmbd: fix use-after-free bug in smb2_tree_disconect
Date:   Thu, 28 Jul 2022 22:28:19 +0900
Message-Id: <20220728132822.6311-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220728132822.6311-1-linkinjeon@kernel.org>
References: <20220728132822.6311-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

smb2_tree_disconnect() freed the struct ksmbd_tree_connect,
but it left the dangling pointer. It can be accessed
again under compound requests.

This bug can lead an oops looking something link:

[ 1685.468014 ] BUG: KASAN: use-after-free in ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468068 ] Read of size 4 at addr ffff888102172180 by task kworker/1:2/4807
...
[ 1685.468130 ] Call Trace:
[ 1685.468132 ]  <TASK>
[ 1685.468135 ]  dump_stack_lvl+0x49/0x5f
[ 1685.468141 ]  print_report.cold+0x5e/0x5cf
[ 1685.468145 ]  ? ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468157 ]  kasan_report+0xaa/0x120
[ 1685.468194 ]  ? ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468206 ]  __asan_report_load4_noabort+0x14/0x20
[ 1685.468210 ]  ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468222 ]  smb2_tree_disconnect+0x175/0x250 [ksmbd]
[ 1685.468235 ]  handle_ksmbd_work+0x30e/0x1020 [ksmbd]
[ 1685.468247 ]  process_one_work+0x778/0x11c0
[ 1685.468251 ]  ? _raw_spin_lock_irq+0x8e/0xe0
[ 1685.468289 ]  worker_thread+0x544/0x1180
[ 1685.468293 ]  ? __cpuidle_text_end+0x4/0x4
[ 1685.468297 ]  kthread+0x282/0x320
[ 1685.468301 ]  ? process_one_work+0x11c0/0x11c0
[ 1685.468305 ]  ? kthread_complete_and_exit+0x30/0x30
[ 1685.468309 ]  ret_from_fork+0x1f/0x30

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17816
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 41ef076af072..7ecb6d87ae3e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2057,6 +2057,7 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 
 	ksmbd_close_tree_conn_fds(work);
 	ksmbd_tree_conn_disconnect(sess, tcon);
+	work->tcon = NULL;
 	return 0;
 }
 
-- 
2.25.1

