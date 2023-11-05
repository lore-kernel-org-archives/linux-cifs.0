Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E15C4332F
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Nov 2023 03:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjKEDvn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Nov 2023 23:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjKEDvm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Nov 2023 23:51:42 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2D2D6
        for <linux-cifs@vger.kernel.org>; Sat,  4 Nov 2023 20:51:40 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-27ff7fe7fbcso3052264a91.1
        for <linux-cifs@vger.kernel.org>; Sat, 04 Nov 2023 20:51:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699156299; x=1699761099;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HT5b1zXzTz355qS8mqtipOcV2J4C+0lgwxop2l/4Gp4=;
        b=O3oAKbabFv3uhd1rGiWtipKc61Qf8UQ53lp7BGqLULq7HSZ6NDeoQrGg8tQLrxBMRU
         khBPErHi9tYGapb0DvK2nTbRf9qDdxPVBgdklZjO67+gjp3CYDR+vQGCPPrTWQ+aWDij
         YAQk21nQbGThX1RMo0qvcvr0MYBARfrHiKAqUXXlJ9xeRAJGQ1etXqpahN6ZVDD4B21G
         Bva3jimRz+gwBlzli0mvQxcODjpzZZeOD4hov/lQjuz6C59GT+BYhEpatpY99KVdyM9H
         G+rNxDcj+8U47mY2TgOJyYkP9Cfy96O58CXLNC4UY8OKJTL90y1e6kW2sKct1RAh2YUI
         X9NA==
X-Gm-Message-State: AOJu0Yy1xUPt1/L1kFOm2gVNuv1FaMnQ1GdzWdNT0/KtTl7dki2M0Isu
        +oQQwhTRT+D2nlgoD1hR/2baYVIMFE4=
X-Google-Smtp-Source: AGHT+IFKUPiflAll+FP7C/Plrcg1wXPp3+nG0DEl4PQeOGyW343zrQqRjjy4KjFDGqJuPmAvndxiWQ==
X-Received: by 2002:a17:902:f213:b0:1bc:6c8:cded with SMTP id m19-20020a170902f21300b001bc06c8cdedmr24212765plc.67.1699156299281;
        Sat, 04 Nov 2023 20:51:39 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b001c9cc44eb60sm3573762plj.201.2023.11.04.20.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Nov 2023 20:51:38 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] ksmbd: fix kernel-doc comment of ksmbd_vfs_kern_path_locked()
Date:   Sun,  5 Nov 2023 12:51:21 +0900
Message-Id: <20231105035121.8649-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix argument list that the kdoc format and script verified in
ksmbd_vfs_kern_path_locked().

fs/smb/server/vfs.c:1207: warning: Function parameter or member 'parent_path'
not described in 'ksmbd_vfs_kern_path_locked'

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 1053127f71ad..c53dea5598fc 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1177,9 +1177,10 @@ static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
 
 /**
  * ksmbd_vfs_kern_path_locked() - lookup a file and get path info
- * @name:	file path that is relative to share
- * @flags:	lookup flags
- * @path:	if lookup succeed, return path info
+ * @name:		file path that is relative to share
+ * @flags:		lookup flags
+ * @parent_path:	if lookup succeed, return parent_path info
+ * @path:		if lookup succeed, return path info
  * @caseless:	caseless filename lookup
  *
  * Return:	0 on success, otherwise error
-- 
2.25.1

