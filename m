Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6373DC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 31 Dec 2021 00:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242372AbhLaAeJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Dec 2021 19:34:09 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:45653 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhLaAeI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Dec 2021 19:34:08 -0500
Received: by mail-pf1-f172.google.com with SMTP id u20so22498156pfi.12
        for <linux-cifs@vger.kernel.org>; Thu, 30 Dec 2021 16:34:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I7wBfRtR2igO7FalKW7btBdpY1Qw7g8ce+CEqX3yXf0=;
        b=JRb9npikpIXMwBjpmuIj2h4cjY7k29bMmyELaPCiR3SL2meQbi/JAHj5YKFbW8AfiD
         tuyyxleab6/vgxVi3Bmjlkqe+sd32K5ALI/dwu35p91+GEyFVT+Q5lhlhjuJWynSIgs4
         Zjhf18iaEZcdI9g1CHG/A9vhV0JiqdrpzDf0PQI8MD7wAFCy4Wx3tF9Imn/foiGfwnuM
         MK7AbZ2cbU/YA126L6VeD01CH8SsHZJgnXMmY56tYY2ML6zpKLE/ynb2S8tCQVDzs+/9
         g/p5/fexzblSIjy/O93UscwWb/YVkZK0dhd4+h/g3zxhBhVn3QeVGuhcE2x1f2isv33Q
         lgJg==
X-Gm-Message-State: AOAM532tACHeVSixal2ES3MdZtIi8obnD4+li05oDzOGD2a2zfQq5T49
        XOBut2x/xEsBObNMI2jOVCwHvHfesZQ=
X-Google-Smtp-Source: ABdhPJyr85CNkZl9qkpiQ+RAgop0PdCe0Jq9d9Y58kYESjdgZ5fc8QL/D5X+HIBz3K46hiS3XrjLgQ==
X-Received: by 2002:a63:6d0a:: with SMTP id i10mr29181810pgc.141.1640910848124;
        Thu, 30 Dec 2021 16:34:08 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id j23sm23097112pga.59.2021.12.30.16.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 16:34:07 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: limits exceeding the maximum allowable outstanding requests
Date:   Fri, 31 Dec 2021 09:33:55 +0900
Message-Id: <20211231003355.5578-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If the client ignores the CreditResponse received from the server and
continues to send the request, ksmbd limits the requests if it exceeds
smb2 max credits.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/connection.c | 1 +
 fs/ksmbd/connection.h | 3 ++-
 fs/ksmbd/smb2misc.c   | 9 +++++++++
 fs/ksmbd/smb2pdu.c    | 1 +
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 83a94d0bb480..d1d0105be5b1 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -62,6 +62,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	conn->total_credits = 1;
+	conn->outstanding_credits = 1;
 
 	init_waitqueue_head(&conn->req_running_q);
 	INIT_LIST_HEAD(&conn->conns_list);
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 42ffb6d9c5d8..7e0730a262da 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -61,7 +61,8 @@ struct ksmbd_conn {
 	atomic_t			req_running;
 	/* References which are made for this Server object*/
 	atomic_t			r_count;
-	unsigned short			total_credits;
+	unsigned int			total_credits;
+	unsigned int			outstanding_credits;
 	spinlock_t			credits_lock;
 	wait_queue_head_t		req_running_q;
 	/* Lock to protect requests list*/
diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index fedcb753c7af..4a9460153b59 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -337,7 +337,16 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 			    credit_charge, conn->total_credits);
 		ret = 1;
 	}
+
+	if ((u64)conn->outstanding_credits + credit_charge > conn->vals->max_credits) {
+		ksmbd_debug(SMB, "Limits exceeding the maximum allowable outstanding requests, given : %u, pending : %u\n",
+			    credit_charge, conn->outstanding_credits);
+		ret = 1;
+	} else
+		conn->outstanding_credits += credit_charge;
+
 	spin_unlock(&conn->credits_lock);
+
 	return ret;
 }
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b6b418e77a1f..ced8f949a4d6 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -322,6 +322,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	}
 
 	conn->total_credits -= credit_charge;
+	conn->outstanding_credits -= credit_charge;
 	credits_requested = max_t(unsigned short,
 				  le16_to_cpu(req_hdr->CreditRequest), 1);
 
-- 
2.25.1

