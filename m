Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262D9C54EE9
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 01:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiI1BcL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Sep 2022 21:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiI1BcK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Sep 2022 21:32:10 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648A110E5D2
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 18:32:09 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id b24so12762789ljk.6
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 18:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=5kaPaylQYRzVP5CI09J4UyNzMugYdGRZh9baeETHbUY=;
        b=PuS3extU7Gne0eRDF+CiT+lelu7PBAb64p2zTXOVolsWAVl8w4cndUNvnVBdgZxdvs
         9Vn4pc/y1Weeesmdcx5syZWqZPcott8W4ks9l4lT0n0VF19IdH8zx9hcbxuStBZ47WgK
         inOGe4dj1dva+17nss2qUT5+uSgEfbETBqHcDB4h8Q/LUgxQw+D20B+HsVL99FvZGL0N
         x2yJmkkuk80/t05XdJ9lEfgdyPSsQ/YFTEkvglst21J0YOIwS699wDpCwzu4DHbjWt/W
         /jCfk/sTONRLGoVKE4ERfyFZOh+d88KhOROMpVoLiPxmSFxU2hk5geXVGkCOvCdZH+Oj
         k6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5kaPaylQYRzVP5CI09J4UyNzMugYdGRZh9baeETHbUY=;
        b=n4HFYcPCC2Sg3NWiCPSu7tZ4fXARUsWHnMBThvYH59yKByBnQxxlQnAn//MssnunNm
         ykxTsYl3XbYNjpoINX4JyHhAq2ySFAwmIYVFNoz0hvTx7oBpXCBzXrBOuY8R+c/4ZtQ/
         Jvjqrgeke75VPmd/G8S2wKDAcOv4TTVRnW1rO0LvcqqYKUs7ZD1pgTOI5CWEGe+qsQEL
         qkzGpkz+iSAQC48FX1h3xieRjXnS/ocnW0Z3WNEs5N2LOocAdWaQh8dX7TbVNffcD+mS
         0eLvMxR4/5mWI8JcsnBvuEkQpCo1bOycc7M7QVYGQO1OJxkZhRYsHGMLGEnSnlSU5XKw
         +XCg==
X-Gm-Message-State: ACrzQf0qyIW2ti/i1r3rMUEMiJ2hw2hyW+I1hUJI2ev/9IoHZes1ezqv
        6OtjoTr/nIlCd8Orn5IcOGE8sHh0460=
X-Google-Smtp-Source: AMsMyM7c9/mAg5CaGwGx/f5sO+YZ57i2enpBHvUyHZbfu5IKz285GGo9kSF0rZ4Z/axvr5+Xw1Z5NQ==
X-Received: by 2002:a2e:9447:0:b0:261:e71e:e3d with SMTP id o7-20020a2e9447000000b00261e71e0e3dmr10603825ljh.227.1664328727677;
        Tue, 27 Sep 2022 18:32:07 -0700 (PDT)
Received: from pohjola.lan (mobile-user-c1d2e2-144.dhcp.inet.fi. [193.210.226.144])
        by smtp.gmail.com with ESMTPSA id x1-20020a056512078100b00492cfecf1c0sm315576lfr.245.2022.09.27.18.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 18:32:07 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org,
        =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Subject: [PATCH 2/2] ksmbd-tools: preserve share name case by casefolding at lookup-time
Date:   Wed, 28 Sep 2022 04:31:51 +0300
Message-Id: <20220928013151.633112-2-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220928013151.633112-1-atteh.mailbox@gmail.com>
References: <20220928013151.633112-1-atteh.mailbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Preserve the case of share names by doing casefolding at hash table
lookup-time. This is preferrable for a few reasons.

First, ksmbd can be built such that it is not capable of casefolding
UTF-8 share names. Such share names are then case-sensitive if they
have non-ASCII characters, and connections to them should succeed only
when matching the name in ksmbd.conf, ignoring ASCII case. As such, the
case-preserved share name will be sent to ksmbd in the share config
response so that ksmbd can casefold it and validate against the share
name it knows. This is necessitated by the way share config caching is
done.

Second, addshare should ideally preserve formatting when modifying
ksmbd.conf. Then, preserving the case for user readability reasons is
desirable. Also, since ksmbd.conf is just as often edited with a text
editor, it is important that share names can be searched using it,
which is often not possible when they are written casefolded.

Third, case-preserved share names are now used in SRVSVC GET_SHARE_INFO
response, with __share_entry_data_ctr0() and __share_entry_data_ctr1(),
and so they are seen as written in ksmbd.conf.

Also, in shm_casefold_share_name(), note that g_utf8_casefold() cannot
fail and if g_utf8_normalize() fails, g_ascii_strdown() will abort on
fail. `share_name' was leaked in srvsvc_share_get_info_invoke() as the
string returned by shm_casefold_share_name() should be freed. Before
that, `share_name' was the string returned by g_ascii_strdown() and
leaked then as well.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 addshare/addshare.c          |  6 ++---
 addshare/share_admin.c       |  8 +++---
 include/linux/ksmbd_server.h |  3 ++-
 include/management/share.h   |  3 ++-
 lib/config_parser.c          |  5 ++--
 lib/management/share.c       | 50 ++++++++++++++++++++++++++----------
 mountd/rpc_srvsvc.c          |  5 +---
 7 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/addshare/addshare.c b/addshare/addshare.c
index e91fe5c..80aef55 100644
--- a/addshare/addshare.c
+++ b/addshare/addshare.c
@@ -124,17 +124,17 @@ int main(int argc, char *argv[])
 		switch (c) {
 		case 'a':
 			g_free(share);
-			share = shm_casefold_share_name(optarg, strlen(optarg));
+			share = g_strdup(optarg);
 			command = command_add_share;
 			break;
 		case 'd':
 			g_free(share);
-			share = shm_casefold_share_name(optarg, strlen(optarg));
+			share = g_strdup(optarg);
 			command = command_del_share;
 			break;
 		case 'u':
 			g_free(share);
-			share = shm_casefold_share_name(optarg, strlen(optarg));
+			share = g_strdup(optarg);
 			command = command_update_share;
 			break;
 		case 'o':
diff --git a/addshare/share_admin.c b/addshare/share_admin.c
index c637c61..11b0f14 100644
--- a/addshare/share_admin.c
+++ b/addshare/share_admin.c
@@ -113,8 +113,8 @@ static void write_remove_share_cb(gpointer key,
 {
 	struct smbconf_group *g = (struct smbconf_group *)value;
 
-	if (!g_ascii_strcasecmp(g->name, name)) {
-		pr_info("Share `%s' removed\n", g->name);
+	if (shm_share_name_equal(g->name, name)) {
+		pr_info("Share `%s' removed\n", name);
 		return;
 	}
 
@@ -187,6 +187,9 @@ int command_update_share(char *smbconf, char *name, char *opts)
 		goto error;
 	}
 
+	g_free(existing_group->name);
+	existing_group->name = g_strdup(name);
+
 	g_hash_table_foreach(update_group->kv,
 			     update_share_cb,
 			     existing_group->kv);
@@ -199,7 +202,6 @@ int command_update_share(char *smbconf, char *name, char *opts)
 	close(conf_fd);
 	g_free(aux_name);
 	return 0;
-
 error:
 	g_free(aux_name);
 	return -EINVAL;
diff --git a/include/linux/ksmbd_server.h b/include/linux/ksmbd_server.h
index 713193d..643e2cd 100644
--- a/include/linux/ksmbd_server.h
+++ b/include/linux/ksmbd_server.h
@@ -91,7 +91,8 @@ struct ksmbd_share_config_response {
 	__u16	force_directory_mode;
 	__u16	force_uid;
 	__u16	force_gid;
-	__u32   reserved[128];		/* Reserved room */
+	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME];
+	__u32   reserved[112];		/* Reserved room */
 	__u32	veto_list_sz;
 	__s8	____payload[];
 };
diff --git a/include/management/share.h b/include/management/share.h
index bb3952c..d6ed0a6 100644
--- a/include/management/share.h
+++ b/include/management/share.h
@@ -141,7 +141,6 @@ static inline int test_share_flag(struct ksmbd_share *share, int flag)
 
 struct ksmbd_share *get_ksmbd_share(struct ksmbd_share *share);
 void put_ksmbd_share(struct ksmbd_share *share);
-char *shm_casefold_share_name(char *name, size_t len);
 struct ksmbd_share *shm_lookup_share(char *name);
 
 struct smbconf_group;
@@ -150,6 +149,8 @@ int shm_add_new_share(struct smbconf_group *group);
 void shm_remove_all_shares(void);
 
 void shm_destroy(void);
+guint shm_share_name_hash(gconstpointer name);
+gboolean shm_share_name_equal(gconstpointer lname, gconstpointer rname);
 int shm_init(void);
 
 int shm_lookup_users_map(struct ksmbd_share *share,
diff --git a/lib/config_parser.c b/lib/config_parser.c
index a1dc85c..53b2e03 100644
--- a/lib/config_parser.c
+++ b/lib/config_parser.c
@@ -93,7 +93,7 @@ static int add_new_group(char *line)
 	while (*end && *end != ']')
 		end = g_utf8_find_next_char(end, NULL);
 
-	name = shm_casefold_share_name(begin + 1, end - begin - 1);
+	name = g_strndup(begin + 1, end - begin - 1);
 	if (!name)
 		goto out_free;
 
@@ -261,7 +261,8 @@ static int init_smbconf_parser(void)
 	if (parser.groups)
 		return 0;
 
-	parser.groups = g_hash_table_new(g_str_hash, g_str_equal);
+	parser.groups = g_hash_table_new(shm_share_name_hash,
+					 shm_share_name_equal);
 	if (!parser.groups)
 		return -ENOMEM;
 	return 0;
diff --git a/lib/management/share.c b/lib/management/share.c
index 02e45df..d3d5009 100644
--- a/lib/management/share.c
+++ b/lib/management/share.c
@@ -227,16 +227,7 @@ void shm_destroy(void)
 	g_rw_lock_clear(&shares_table_lock);
 }
 
-int shm_init(void)
-{
-	shares_table = g_hash_table_new(g_str_hash, g_str_equal);
-	if (!shares_table)
-		return -ENOMEM;
-	g_rw_lock_init(&shares_table_lock);
-	return 0;
-}
-
-char *shm_casefold_share_name(char *name, size_t len)
+static char *shm_casefold_share_name(const char *name, size_t len)
 {
 	char *nfdi_name, *nfdicf_name;
 
@@ -245,9 +236,6 @@ char *shm_casefold_share_name(char *name, size_t len)
 		goto out_ascii;
 
 	nfdicf_name = g_utf8_casefold(nfdi_name, strlen(nfdi_name));
-	if (!nfdicf_name)
-		goto out_ascii;
-
 	g_free(nfdi_name);
 	return nfdicf_name;
 out_ascii:
@@ -255,6 +243,40 @@ out_ascii:
 	return g_ascii_strdown(name, len);
 }
 
+guint shm_share_name_hash(gconstpointer name)
+{
+	char *cf_name;
+	guint hash;
+
+	cf_name = shm_casefold_share_name(name, strlen(name));
+	hash = g_str_hash(cf_name);
+	g_free(cf_name);
+	return hash;
+}
+
+gboolean shm_share_name_equal(gconstpointer lname, gconstpointer rname)
+{
+	char *cf_lname, *cf_rname;
+	gboolean equal;
+
+	cf_lname = shm_casefold_share_name(lname, strlen(lname));
+	cf_rname = shm_casefold_share_name(rname, strlen(rname));
+	equal = g_str_equal(cf_lname, cf_rname);
+	g_free(cf_lname);
+	g_free(cf_rname);
+	return equal;
+}
+
+int shm_init(void)
+{
+	shares_table = g_hash_table_new(shm_share_name_hash,
+					shm_share_name_equal);
+	if (!shares_table)
+		return -ENOMEM;
+	g_rw_lock_init(&shares_table_lock);
+	return 0;
+}
+
 static struct ksmbd_share *__shm_lookup_share(char *name)
 {
 	return g_hash_table_lookup(shares_table, name);
@@ -818,6 +840,8 @@ int shm_handle_share_config_request(struct ksmbd_share *share,
 	resp->force_directory_mode = share->force_directory_mode;
 	resp->force_uid = share->force_uid;
 	resp->force_gid = share->force_gid;
+	*resp->share_name = 0x00;
+	strncat(resp->share_name, share->name, KSMBD_REQ_MAX_SHARE_NAME - 1);
 	resp->veto_list_sz = share->veto_list_sz;
 
 	if (test_share_flag(share, KSMBD_SHARE_FLAG_PIPE))
diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
index 8716c34..46c01d9 100644
--- a/mountd/rpc_srvsvc.c
+++ b/mountd/rpc_srvsvc.c
@@ -169,11 +169,8 @@ static int srvsvc_share_get_info_invoke(struct ksmbd_rpc_pipe *pipe,
 {
 	struct ksmbd_share *share;
 	int ret;
-	gchar *share_name;
 
-	share_name = shm_casefold_share_name(STR_VAL(hdr->share_name),
-			strlen(STR_VAL(hdr->share_name)));
-	share = shm_lookup_share(share_name);
+	share = shm_lookup_share(STR_VAL(hdr->share_name));
 	if (!share)
 		return 0;
 
-- 
2.37.3

