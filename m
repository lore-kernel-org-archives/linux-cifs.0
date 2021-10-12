Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5BAC433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 01:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 532D360F22
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 01:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhJLBWU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Oct 2021 21:22:20 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:41904 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbhJLBWR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Oct 2021 21:22:17 -0400
Received: by mail-pj1-f43.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so1308532pjb.0
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 18:20:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Qmz7CAqntgaBuO+5CzL0xSKnaLfH20nJDCDrdvHu6Y=;
        b=iTodBSosHpk2Ki7jeKbe/ploGRg8nn8SFvYWq4k+3Q0YAgE8sfkme1hBJM6n1cU1PG
         SeO4yTmcI9xqTSVQ/0RcdNzZnytwgnIeW3SzvlPQ94zIEBn/sNpCJzcI/8eFPq09urXq
         sNreuR1wqG90BBiR3nN/8/R3SALAb+rqmanbsCqj3a/mQgAD/Abe9ImwsRZBlVgUSJgp
         0r4B8hQHJbXDjgQQEyPEPZw5BO/h9UhPW11GnZ+YHYpXtwFJq6MDEe5i1uEiwOuAUXHg
         jXcOcQhmTIE4K5ckd1sDNz3A5GUk0kROQIupOPINyIjjz7eGhZwGYvOfU6vv1oz0xEOV
         aJRA==
X-Gm-Message-State: AOAM533CEyAZRTVeYnhcaud3V8ILXJici24E5S72hCPQkkn4SJNlIGKi
        TNhCoxnMQxyHoza5EIwEWceyVH2ZvGTzig==
X-Google-Smtp-Source: ABdhPJy4yzvDZOnh6eWoRlq1b5+5ZMgumpXxITn0kEsg56RljbGh4bk5LCcMOWlkhigJOI2LKXjaBA==
X-Received: by 2002:a17:90a:b702:: with SMTP id l2mr2728743pjr.232.1634001616376;
        Mon, 11 Oct 2021 18:20:16 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id c24sm10145386pgj.63.2021.10.11.18.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 18:20:16 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: validate compound response buffer
Date:   Tue, 12 Oct 2021 10:20:05 +0900
Message-Id: <20211012012006.5037-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012012006.5037-1-linkinjeon@kernel.org>
References: <20211012012006.5037-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add the check to validate compound response buffer.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7b4689f2df49..89c187aa8db2 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -449,6 +449,12 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
 			return false;
 		}
 
+		if ((u64)get_rfc1002_len(work->response_buf) + MAX_CIFS_SMALL_BUFFER_SIZE >
+		    work->response_sz) {
+			pr_err("next response offset exceeds response buffer size\n");
+			return false;
+		}
+
 		ksmbd_debug(SMB, "got SMB2 chained command\n");
 		init_chained_smb2_rsp(work);
 		return true;
-- 
2.25.1

