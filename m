Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1105DC432BE
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 00:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDA3560525
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 00:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241501AbhIAAqr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:46:47 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:36739 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238552AbhIAAqq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Aug 2021 20:46:46 -0400
Received: by mail-pf1-f182.google.com with SMTP id m26so727996pff.3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 17:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JV0WCEhB/Kc3myQjMq8D4oG0RP5CmI2Y28yZb9soXjk=;
        b=NxbKFvn2jCeEP5xNL3tJh5ii8PVqrIcOctftspyZyErVd707EPOeiTS5+Y7pGAWerV
         1K0vEG4LN/K5GTXZFVqV1VqkFd3Aps1+xRdD7gZ+NPnVVtCDv0iz3Um2JW15cWaFsrJz
         dAkX/HpiF4UUEjn8h/COqD3KZbIcr8QRkHbQWLDhjOEPj5GvsCx8T6NLVu27n9tDbRSU
         X5+KBgXV6dY4+l/2jBjAEWyaMTuALxkeHWGCQIjbl+MdujRPy7wiAR1xcFVmQz/RNi0u
         bs2XuUl/Td6yVXNIPWgY7M6/wtWsRt5x8tw+DmWnkSdVPNqfU+I2edgnxFdX5Zt5wp6C
         apUA==
X-Gm-Message-State: AOAM530Co6jr9j50f9Scrw7R+vCf79Q+Nry2IYem9ukcGfntwZ2nk2wm
        2O68KYlIKHs6hfexmMAigQJOzxGGgmjQ0w==
X-Google-Smtp-Source: ABdhPJz/wvenMYfBF9u0um7YGmNSiwsd0ufB31zQcg6jWBB3EyjyFE3TRWA08NHXes4dVNr55YOxpg==
X-Received: by 2002:a63:d40a:: with SMTP id a10mr27547796pgh.7.1630457150589;
        Tue, 31 Aug 2021 17:45:50 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id gg22sm3849024pjb.19.2021.08.31.17.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 17:45:50 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Per Forlin <perfn@axis.com>, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/4] ksmbd: Reduce error log 'speed is unknown' to debug
Date:   Wed,  1 Sep 2021 09:45:34 +0900
Message-Id: <20210901004537.45511-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Per Forlin <perfn@axis.com>

This log happens on servers with a network bridge since
the bridge does not have a specified link speed.
This is not a real error so change the error log to debug instead.

Signed-off-by: Per Forlin <perfn@axis.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e2224b91d4a5..a350e1cef7f4 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7111,8 +7111,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			netdev->ethtool_ops->get_link_ksettings(netdev, &cmd);
 			speed = cmd.base.speed;
 		} else {
-			pr_err("%s %s\n", netdev->name,
-			       "speed is unknown, defaulting to 1Gb/sec");
+			ksmbd_debug(SMB, "%s %s\n", netdev->name,
+				    "speed is unknown, defaulting to 1Gb/sec");
 			speed = SPEED_1000;
 		}
 
-- 
2.25.1

