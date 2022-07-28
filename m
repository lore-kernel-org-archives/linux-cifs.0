Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB53CC04A68
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Jul 2022 13:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiG1Nde (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Jul 2022 09:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiG1Ndd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Jul 2022 09:33:33 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5249152FCE
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 06:33:32 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id f11-20020a17090a4a8b00b001f2f7e32d03so5211169pjh.0
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 06:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kHvji/KLZrIHvszWGy83gCJDUP4K0oOAZJcQi4Q4rqY=;
        b=p8gq07BWksek3zt5LWfGhqOXYDYrz9/gbwHOPe1oKyF0UThw6JcAM1WA2FOOI00arO
         gTHoklbrv01hJ/5Dq7fCb8/KVlaLcqUgWmEf9tbBV9KsBKiW5/M+Y8MGj7mY/Mf/7KLX
         yGsys9GChz+NorooqhBgacvJoWTThVw1I1ElfWeAziUx6ZsfYdLTUwh1+YHNv6MDRUiO
         sKctR0Tz7R/C8fQMQG07XrIESYA0PBjKSYIUoJ3v87C3ZgZFScBQQztpn4yZoqktK2DP
         V9UaTKxgDhxEh64wfDnwi3GaZJscQshE5NHQTGD1go3JwB33xrkTYiEHSey1PpS9ccPk
         7x0g==
X-Gm-Message-State: AJIora9JuMIy0edBcWJ5rnhpxM4uSzBBssE8UUjvILZ0/Ky4nm/lC4BC
        NfLRHFnBnNej2W1cGfXhHadXk9JwGqo=
X-Google-Smtp-Source: AGRyM1uiXeYqkvVFA9xk1xIuhw8IXP0BsJYVXPUzDSYCzb+sLLmr2KTXuLXIq6GOKjGVEF70LqjPMg==
X-Received: by 2002:a17:90b:3ec3:b0:1f1:ff45:1d3b with SMTP id rm3-20020a17090b3ec300b001f1ff451d3bmr10139604pjb.101.1659015211731;
        Thu, 28 Jul 2022 06:33:31 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id m14-20020a63710e000000b0041b667a1b69sm960078pgc.36.2022.07.28.06.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:33:31 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        gregkh@linuxfoundation.org, Namjae Jeon <linkinjeon@kernel.org>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 4/5] ksmbd: prevent out of bound read for SMB2_TREE_CONNNECT
Date:   Thu, 28 Jul 2022 22:28:21 +0900
Message-Id: <20220728132822.6311-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220728132822.6311-1-linkinjeon@kernel.org>
References: <20220728132822.6311-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

if Status is not 0 and PathLength is long,
smb_strndup_from_utf16 could make out of bound
read in smb2_tree_connnect.

This bug can lead an oops looking something like:

[ 1553.882047] BUG: KASAN: slab-out-of-bounds in smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882064] Read of size 2 at addr ffff88802c4eda04 by task kworker/0:2/42805
...
[ 1553.882095] Call Trace:
[ 1553.882098]  <TASK>
[ 1553.882101]  dump_stack_lvl+0x49/0x5f
[ 1553.882107]  print_report.cold+0x5e/0x5cf
[ 1553.882112]  ? smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882122]  kasan_report+0xaa/0x120
[ 1553.882128]  ? smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882139]  __asan_report_load_n_noabort+0xf/0x20
[ 1553.882143]  smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882155]  ? smb_strtoUTF16+0x3b0/0x3b0 [ksmbd]
[ 1553.882166]  ? __kmalloc_node+0x185/0x430
[ 1553.882171]  smb2_tree_connect+0x140/0xab0 [ksmbd]
[ 1553.882185]  handle_ksmbd_work+0x30e/0x1020 [ksmbd]
[ 1553.882197]  process_one_work+0x778/0x11c0
[ 1553.882201]  ? _raw_spin_lock_irq+0x8e/0xe0
[ 1553.882206]  worker_thread+0x544/0x1180
[ 1553.882209]  ? __cpuidle_text_end+0x4/0x4
[ 1553.882214]  kthread+0x282/0x320
[ 1553.882218]  ? process_one_work+0x11c0/0x11c0
[ 1553.882221]  ? kthread_complete_and_exit+0x30/0x30
[ 1553.882225]  ret_from_fork+0x1f/0x30
[ 1553.882231]  </TASK>

There is no need to check error request validation in server.
This check allow invalid requests not to validate message.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17818
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2misc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index aa1e663d9deb..6e25ace36568 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -90,11 +90,6 @@ static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
 	*off = 0;
 	*len = 0;
 
-	/* error reqeusts do not have data area */
-	if (hdr->Status && hdr->Status != STATUS_MORE_PROCESSING_REQUIRED &&
-	    (((struct smb2_err_rsp *)hdr)->StructureSize) == SMB2_ERROR_STRUCTURE_SIZE2_LE)
-		return ret;
-
 	/*
 	 * Following commands have data areas so we have to get the location
 	 * of the data buffer offset and data buffer length for the particular
-- 
2.25.1

