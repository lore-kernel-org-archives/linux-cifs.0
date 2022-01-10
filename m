Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C221EC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jan 2022 08:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbiAJICc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jan 2022 03:02:32 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:42824 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242103AbiAJIBA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jan 2022 03:01:00 -0500
Received: by mail-pj1-f48.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso14976219pjb.1
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jan 2022 00:00:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nOcJN/H7vatO+ZP8BZrVVA+4NzcovEiOHsUE059+wsE=;
        b=e7hW94QQUrSh6A6AKBBdpkw9XdUba14N7uT4+3WB1QKp9LQtlbzfSp2b+8VxCrJpaJ
         xYqqFqkPWh+5oJwcrhUXjrpJAF7jvlpaUh+DlBPE6jeM8HsOdmIEMeOzhm5wQOK1vcWS
         TShohBY1G6iG/OrQCjY6dMSgIY2M9fnSdKFYuscM09fQnzsWE/frxO3ng7skwonggW8D
         MzK9j0nw5NNDQ1OtotSAhrytRvEjmmdCi17yS5cPcU3tZUQqKgDw78yh3BLH8kawhyF5
         5tT8w0vVD2vsOFljzpUc2E62JUpLtTm1eAd3qHE0AT9AnX6WBdEejQGc/YV7DKPGUtRq
         hhtw==
X-Gm-Message-State: AOAM531KS6OEy1h7I1QaUKota0PcV/AJga/Rm+KsWERL67FUO3M7HylI
        vlt3Ea/uwrkbZiAmSigeD98Rm0me74Y=
X-Google-Smtp-Source: ABdhPJxwm9WVv/ICk0Elxkk7htT5avoVtwKaMSOo9UJRho/CcIcjzmmglrwcmcKEjoA1/10wNZMtSQ==
X-Received: by 2002:a17:90b:3891:: with SMTP id mu17mr29213173pjb.242.1641801658372;
        Mon, 10 Jan 2022 00:00:58 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id q22sm6227387pfk.27.2022.01.10.00.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 00:00:58 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Yufan Chen <wiz.chen@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH] ksmbd: add smb-direct shutdown
Date:   Mon, 10 Jan 2022 17:00:45 +0900
Message-Id: <20220110080045.4715-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Yufan Chen <wiz.chen@gmail.com>

When killing ksmbd server after connecting rdma, ksmbd threads does not
terminate properly because the rdma connection is still alive.
This patch add shutdown operation to disconnect rdma connection while
ksmbd threads terminate.

Signed-off-by: Yufan Chen <wiz.chen@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/ksmbd/connection.c     |  9 ++++++++-
 fs/ksmbd/connection.h     |  1 +
 fs/ksmbd/transport_rdma.c | 10 ++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index d1d0105be5b1..208d2cff7bd3 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -387,17 +387,24 @@ int ksmbd_conn_transport_init(void)
 static void stop_sessions(void)
 {
 	struct ksmbd_conn *conn;
+	struct ksmbd_transport *t;
 
 again:
 	read_lock(&conn_list_lock);
 	list_for_each_entry(conn, &conn_list, conns_list) {
 		struct task_struct *task;
 
-		task = conn->transport->handler;
+		t = conn->transport;
+		task = t->handler;
 		if (task)
 			ksmbd_debug(CONN, "Stop session handler %s/%d\n",
 				    task->comm, task_pid_nr(task));
 		conn->status = KSMBD_SESS_EXITING;
+		if (t->ops->shutdown) {
+			read_unlock(&conn_list_lock);
+			t->ops->shutdown(t);
+			read_lock(&conn_list_lock);
+		}
 	}
 	read_unlock(&conn_list_lock);
 
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 7e0730a262da..7a59aacb5daa 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -117,6 +117,7 @@ struct ksmbd_conn_ops {
 struct ksmbd_transport_ops {
 	int (*prepare)(struct ksmbd_transport *t);
 	void (*disconnect)(struct ksmbd_transport *t);
+	void (*shutdown)(struct ksmbd_transport *t);
 	int (*read)(struct ksmbd_transport *t, char *buf, unsigned int size);
 	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
 		      int size, bool need_invalidate_rkey,
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 86fd64511512..3c1ec1ac0b27 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1453,6 +1453,15 @@ static void smb_direct_disconnect(struct ksmbd_transport *t)
 	free_transport(st);
 }
 
+static void smb_direct_shutdown(struct ksmbd_transport *t)
+{
+	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
+
+	ksmbd_debug(RDMA, "smb-direct shutdown cm_id=%p\n", st->cm_id);
+
+	smb_direct_disconnect_rdma_work(&st->disconnect_work);
+}
+
 static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 				 struct rdma_cm_event *event)
 {
@@ -2201,6 +2210,7 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 static struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
 	.prepare	= smb_direct_prepare,
 	.disconnect	= smb_direct_disconnect,
+	.shutdown	= smb_direct_shutdown,
 	.writev		= smb_direct_writev,
 	.read		= smb_direct_read,
 	.rdma_read	= smb_direct_rdma_read,
-- 
2.25.1

