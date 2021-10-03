Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F7BC433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 04:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3E761222
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 04:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhJCEdK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Oct 2021 00:33:10 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:41739 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhJCEdK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Oct 2021 00:33:10 -0400
Received: by mail-pj1-f41.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so6037352pjb.0
        for <linux-cifs@vger.kernel.org>; Sat, 02 Oct 2021 21:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PtZutAXRGIMTfkqIUlW3Wat8+E4VPcoyA+Ain2jDqR8=;
        b=56rt3pif0bNIslofvPRcEb20GWHk1KafmjJW6st2dIcgNRuip3I0WHqZWWdWbD0Xdf
         oM7rSa4M2pMIR56jt1aIEVSNbpqEi0PW1K1193zr1q/AFeBN3/qpsXNNdRkyeqWq2Mmn
         GDhktjwdulFTs2TGS3+5WVii9C3eFT/lze5W3wyAJFzUyt7vjCS7KrcZNuF9U9hVnTtx
         aA/tv40ftOuL1Nzx68iPDcRsWofnk5eyOybkBEzjJadCFcrhu+3aIHlLjox60iEi210Z
         DBr6Y5q5EMv8/8DohvCcyjkurX2DtajwdrQWNimNC+pNFF1lJtiFuAC0lP2EOerNIgs8
         KI9A==
X-Gm-Message-State: AOAM531rWVE/VRNQZx8EG691ie0xom4EFGi6zvg17V28uWlY5J6x7PW3
        oQQGN6Tlj/xqEhbue1Z70dC/45j1U0Wf3w==
X-Google-Smtp-Source: ABdhPJy056NHxlFhM4tWJasB9pYt/IAAjtPoE2RZMb0Oi2p99d5MgrCDvJSd7pEPZC8E7AKbFNsMXg==
X-Received: by 2002:a17:90a:46c1:: with SMTP id x1mr29938402pjg.174.1633235483142;
        Sat, 02 Oct 2021 21:31:23 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id w136sm3845782pfc.50.2021.10.02.21.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 21:31:22 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH 3/3] ksmbd: fix oops from fuse driver
Date:   Sun,  3 Oct 2021 13:31:05 +0900
Message-Id: <20211003043105.10453-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003043105.10453-1-linkinjeon@kernel.org>
References: <20211003043105.10453-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Marios reported kernel oops from fuse driver when ksmbd call
mark_inode_dirty(). This patch directly update ->i_ctime after removing
mark_inode_ditry() and notify_change will put inode to dirty list.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Reported-by: Marios Makassikis <mmakassikis@freebox.fr>
Tested-by: Marios Makassikis <mmakassikis@freebox.fr>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 4d1be224dd8e..ed8324f9c2bd 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5483,7 +5483,6 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 			       struct ksmbd_share_config *share)
 {
 	struct iattr attrs;
-	struct timespec64 ctime;
 	struct file *filp;
 	struct inode *inode;
 	struct user_namespace *user_ns;
@@ -5505,13 +5504,11 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 		attrs.ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
 	}
 
-	if (file_info->ChangeTime) {
+	attrs.ia_valid |= ATTR_CTIME;
+	if (file_info->ChangeTime)
 		attrs.ia_ctime = ksmbd_NTtimeToUnix(file_info->ChangeTime);
-		ctime = attrs.ia_ctime;
-		attrs.ia_valid |= ATTR_CTIME;
-	} else {
-		ctime = inode->i_ctime;
-	}
+	else
+		attrs.ia_ctime = inode->i_ctime;
 
 	if (file_info->LastWriteTime) {
 		attrs.ia_mtime = ksmbd_NTtimeToUnix(file_info->LastWriteTime);
@@ -5557,11 +5554,9 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 			return -EACCES;
 
 		inode_lock(inode);
+		inode->i_ctime = attrs.ia_ctime;
+		attrs.ia_valid &= ~ATTR_CTIME;
 		rc = notify_change(user_ns, dentry, &attrs, NULL);
-		if (!rc) {
-			inode->i_ctime = ctime;
-			mark_inode_dirty(inode);
-		}
 		inode_unlock(inode);
 	}
 	return rc;
-- 
2.25.1

