Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB3EC25B0C
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 02:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbiHHCrL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Aug 2022 22:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244177AbiHHCqx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Aug 2022 22:46:53 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3553813E14
        for <linux-cifs@vger.kernel.org>; Sun,  7 Aug 2022 19:44:08 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id r17so10723840lfm.11
        for <linux-cifs@vger.kernel.org>; Sun, 07 Aug 2022 19:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=392Dmd/PigXAyQNBc3FJhswVSBZOfqlGTZD5FExUpT0=;
        b=Y6vvswH7nK5J35BM7oHLkI+N3mObnwDPIyxsc0n5QczMNvtBngHhIUnD9bwztxsAhH
         4G4yfHz5joZ56JWG7OAIbwPIX+AxmxlJyMlZKAyzXfYvcYG8WBBZV3dfj3lk80DTpNnF
         b9QkwDZTQonUpUHxZAncAiFxtg0g7gp3sZ0KeMzvql0L9FmUMn9LqiWcUT704tiCQoka
         LhI836OfNKfUF7EqRPN43q0WV7FJUna6BNNXN0MT2Gu4Zca+zscEKpgm3qDSYhWc+UtS
         hzXj+Gka/95ZLn5LoARjPe0S85gyGaFmAeTv2KCmNEqfNb/fqbYsaKkeaA64xKeaHd3i
         wFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=392Dmd/PigXAyQNBc3FJhswVSBZOfqlGTZD5FExUpT0=;
        b=cLYT1Xa55bni88e7zB8ElMCA4KNIGiF9COmwbvLbQDqEHEvYuxZOXDmUj1mwI2yZB1
         /FhvL97rCq385Y4GTG8aadY7OvmQiM1v713kWdTwae0aHei2/CNspufSW1cFw4nsUxWu
         U8k+FKGBYBc5VTVHxnSY9Ud8iJyn85rfP47PrEIs1U7C9aFKyqVMBIhHsvjWmb1OCgmC
         ajstB9ieOdjUbWH2aG1V2AaiQ10YzSEyYOSAIbMAHYEdTacQjdScNCqJWZzW1Cg9ZHxD
         xDIwsUvZpOq/PFmjsAJpgZNM0zFXwlWF4daXCoz1nTsdq8omvAKxEmUb3EEq/qXFCjt8
         si5w==
X-Gm-Message-State: ACgBeo2+MOH/jT3j0a87CzqSMQP0O6NC3GGeUphISJyJkh7L1+3CRpIM
        PcA1pw6yYnLcRK+4AUZUrEq3Xiv0gYQ=
X-Google-Smtp-Source: AA6agR6nFVkGpNHeGYt8khyIOoiNr9U0nlQP8dG0ovpxS8GZcORTEUeahSodWTow/eEVppTIbAco1w==
X-Received: by 2002:a05:6512:138e:b0:47f:77cc:327a with SMTP id p14-20020a056512138e00b0047f77cc327amr5797722lfa.277.1659926641744;
        Sun, 07 Aug 2022 19:44:01 -0700 (PDT)
Received: from pohjola.lan (mobile-user-c1d2e4-79.dhcp.inet.fi. [193.210.228.79])
        by smtp.gmail.com with ESMTPSA id v22-20020ac25596000000b0048a77a2c4b2sm1255125lfg.158.2022.08.07.19.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 19:44:01 -0700 (PDT)
From:   atheik <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     atheik <atteh.mailbox@gmail.com>
Subject: [PATCH 3/3] ksmbd-tools: inform ksmbd of stale share config
Date:   Mon,  8 Aug 2022 05:43:41 +0300
Message-Id: <20220808024341.63913-3-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220808024341.63913-1-atteh.mailbox@gmail.com>
References: <20220808024341.63913-1-atteh.mailbox@gmail.com>
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

