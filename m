Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7239C3F6B0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 22:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238465AbiHHWCd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 18:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238347AbiHHWCa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 18:02:30 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232861BE93
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 15:02:28 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id x9so7551529ljj.13
        for <linux-cifs@vger.kernel.org>; Mon, 08 Aug 2022 15:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=392Dmd/PigXAyQNBc3FJhswVSBZOfqlGTZD5FExUpT0=;
        b=hoLtK7dk10dArUk7oqXQ96I/TNZaF6SBdjng8Ruunce4lNMHnKPxot+OUBJC6s00cS
         lwK6ENQ3AhGt4ELJY+EYbTluI9iMhiMPI5G/97aa+We44TYXROy9EnEEN8OWxTFeMlTI
         nmaJ2qqMmnsB/wsfnU/loxkF8tE49n6oHB+Z4ckxYZGGi8NDIKW8ae7O3tovYHD6Criu
         HQ9GQxyCUth29YEy1Jd0Qv7aH6pwrUf7E8IqzlY741JmIl98h/DAWyWqlUinthzDNTdy
         0UzFzc/582P1XmYJD+E0fB5aNx07h2/cwhB3d8DHXw/b0eTYu2B/TxTEEBeGMTiMOkWX
         ExPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=392Dmd/PigXAyQNBc3FJhswVSBZOfqlGTZD5FExUpT0=;
        b=kuPftn0DsQW66Xh2ISNPbFs66bJOBSK/04+JYeX2wvb4dkQX+vVV7quXOVaZho0VAX
         uFSeRAs69UM2YEaEXKCdKyhrShiiUjxnR7MvCLW5hM80JJcJoIYmoKj4UBDJ0d657leh
         yuB7svOxnuBLYCmkVOws5TKKNSYnHqulAfj2xwoDol11oxeY6CTUDHju5NfUYi3xjU6Z
         tM4kJ6M4uI5LqkNJ6YWdXvTbbVcuSEvV3EuLKgMBNLlld7G6E9hBII5uGMox9DoFoNp6
         NmhMjCa/ooIjQVqtNNXeE/hbPymEuvuh/Gde/oZmH0yRZVTFeEj2ch13Z0bKZC+/I7iY
         Gy5A==
X-Gm-Message-State: ACgBeo2URfv89R+fVsj/3yEEVUSzGljeK5jhygsXvbQB1RGAn9mhwSnO
        8jpbg2FzRzrtqnT4dkwDjWNdo33s2Uk=
X-Google-Smtp-Source: AA6agR4YV0/bpLHMNbuOx5b8ssWcX/o0yrX4/qaxylnbYUip6cN852DLN2fMoI0XTOQhuIIrufo/xw==
X-Received: by 2002:a2e:9d59:0:b0:25e:1eda:86f6 with SMTP id y25-20020a2e9d59000000b0025e1eda86f6mr6546902ljj.315.1659996146411;
        Mon, 08 Aug 2022 15:02:26 -0700 (PDT)
Received: from pohjola.lan (mobile-user-c1d2eb-134.dhcp.inet.fi. [193.210.235.134])
        by smtp.gmail.com with ESMTPSA id b15-20020a2eb90f000000b0025e72aae6bdsm1477817ljb.28.2022.08.08.15.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 15:02:26 -0700 (PDT)
From:   atheik <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     atheik <atteh.mailbox@gmail.com>
Subject: [PATCH v2 3/3] ksmbd-tools: inform ksmbd of stale share config
Date:   Tue,  9 Aug 2022 01:02:16 +0300
Message-Id: <20220808220216.17235-3-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220808220216.17235-1-atteh.mailbox@gmail.com>
References: <20220808220216.17235-1-atteh.mailbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When initializing a share from a group, flag the share with
KSMBD_SHARE_FLAG_UPDATE if the group callback mode denotes that the
config file was reloaded. If the share was flagged, then later when
handling a tree connect request, flag the connection with
KSMBD_TREE_CONN_FLAG_UPDATE to inform ksmbd that its cached share
config is stale. If there are no failures when handling the request,
remove the share flag.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 include/linux/ksmbd_server.h | 2 ++
 lib/management/share.c       | 3 +++
 lib/management/tree_conn.c   | 8 +++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/ksmbd_server.h b/include/linux/ksmbd_server.h
index 6705dac..7e86d5d 100644
--- a/include/linux/ksmbd_server.h
+++ b/include/linux/ksmbd_server.h
@@ -235,6 +235,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_SHARE_FLAG_STREAMS		(1 << 11)
 #define KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS	(1 << 12)
 #define KSMBD_SHARE_FLAG_ACL_XATTR		(1 << 13)
+#define KSMBD_SHARE_FLAG_UPDATE 		(1 << 14)
 
 /*
  * Tree connect request flags.
@@ -250,6 +251,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_TREE_CONN_FLAG_READ_ONLY		(1 << 1)
 #define KSMBD_TREE_CONN_FLAG_WRITABLE		(1 << 2)
 #define KSMBD_TREE_CONN_FLAG_ADMIN_ACCOUNT	(1 << 3)
+#define KSMBD_TREE_CONN_FLAG_UPDATE		(1 << 4)
 
 /*
  * RPC over IPC.
diff --git a/lib/management/share.c b/lib/management/share.c
index acd6d3f..e9492b5 100644
--- a/lib/management/share.c
+++ b/lib/management/share.c
@@ -605,6 +605,9 @@ static void init_share_from_group(struct ksmbd_share *share,
 	if (!g_ascii_strcasecmp(share->name, "ipc$"))
 		set_share_flag(share, KSMBD_SHARE_FLAG_PIPE);
 
+	if (group->cb_mode == GROUPS_CALLBACK_REINIT)
+		set_share_flag(share, KSMBD_SHARE_FLAG_UPDATE);
+
 	g_hash_table_foreach(group->kv, process_group_kv, share);
 
 	fixup_missing_fields(share);
diff --git a/lib/management/tree_conn.c b/lib/management/tree_conn.c
index 10304d1..f5c5749 100644
--- a/lib/management/tree_conn.c
+++ b/lib/management/tree_conn.c
@@ -73,6 +73,8 @@ int tcm_handle_tree_connect(struct ksmbd_tree_connect_request *req,
 		set_conn_flag(conn, KSMBD_TREE_CONN_FLAG_WRITABLE);
 	if (test_share_flag(share, KSMBD_SHARE_FLAG_READONLY))
 		set_conn_flag(conn, KSMBD_TREE_CONN_FLAG_READ_ONLY);
+	if (test_share_flag(share, KSMBD_SHARE_FLAG_UPDATE))
+		set_conn_flag(conn, KSMBD_TREE_CONN_FLAG_UPDATE);
 
 	if (shm_open_connection(share)) {
 		resp->status = KSMBD_TREE_CONN_STATUS_TOO_MANY_CONNS;
@@ -207,8 +209,12 @@ bind:
 		tcm_tree_conn_free(conn);
 		put_ksmbd_user(user);
 	}
+
+	g_rw_lock_writer_lock(&share->update_lock);
+	clear_share_flag(share, KSMBD_SHARE_FLAG_UPDATE);
+	g_rw_lock_writer_unlock(&share->update_lock);
+
 	return 0;
-
 out_error:
 	tcm_tree_conn_free(conn);
 	shm_close_connection(share);
-- 
2.37.1

