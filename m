Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C05EC04A95
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 18:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiI1SnS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 14:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbiI1SnR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 14:43:17 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70205E21E3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 11:43:15 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id a10so15372131ljq.0
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 11:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=EYP8vL7OJMTSRvbsRgrt8V/nunoBmz8bZDfD6JnYu0I=;
        b=Ql0rjh8nR2TskEwraUcN9qxg7wj0uzQ7GCfuDk/bpWEaJDhLLterFmURn9Iyx/GlOU
         iR+SgJWCPXsX0q7lYZ8S/+JSjJSL0676I6/WzHG03Qq6nr08dh/endyfNZ4Gll32KCNf
         hJ1Xcpb4N6+NIS/tsb7IpdD21tZGf3Iw/hB1rU1/OELrhQ/kCVEk+9p+4vkhpoifgHYv
         BB4yOd35ueH4tRQ4RoMnZT3dMBeh9xtcsiN+q6TLlVZCn8fZnbbCji8QVLnuUv6LVn3L
         s6wlvEcehbSGYE/luoQE7Dkf9cEG7Yfhk3GCQWspyDdlflDHg2aTWmWKZGx3MXm7l8kp
         nMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=EYP8vL7OJMTSRvbsRgrt8V/nunoBmz8bZDfD6JnYu0I=;
        b=ugbb5BBvSeeSx+IaM7nBWzWWJLcwUCjxBNwUKBy0eR+3UkI+11E/i2c0SbwT3PGC6d
         qeqh0tHlaZrd0Y60jkTqowC0rHch7xi428HI8EHPz8X7uzEXRVS6oqoAT2of/Anakzba
         YSh4zJNAwUluzCB6i0TMabyRnKQfGEST9N/WKElQHYHGjnLyLi+WRgVqSA+hHnCS3xBY
         Y5lemkleHFJwhd03vfb9cE7+rJ4ZuEFGmPCrTy18K5qVlgOwdvLqqsF1Eh9/PDyTntYQ
         lKcTN10Ou/SCl0MTCCFbbCEnYxkjhR3v7n7SpryvxFoYy+CHONlhQgci87C1jWesP3rn
         bj6w==
X-Gm-Message-State: ACrzQf3w6zaWEpNGzKSzCAF4omZdbp5VCV+lW//inieJ486UreB5q8F4
        gqQZVzUrXf1AwpGkpqHEh/+5znAff9U=
X-Google-Smtp-Source: AMsMyM4hiSsLOrtYYpqWrNcrhX1oMwiA3e1ip4q7Ob5p704P8OtFvwjvCj+Es+0Y994SP/2RK2ok+Q==
X-Received: by 2002:a2e:a0d1:0:b0:26c:668a:6b36 with SMTP id f17-20020a2ea0d1000000b0026c668a6b36mr12099196ljm.200.1664390593143;
        Wed, 28 Sep 2022 11:43:13 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84bd-219.dhcp.inet.fi. [46.132.189.219])
        by smtp.gmail.com with ESMTPSA id e30-20020a2e501e000000b00261b175f9c4sm508405ljb.37.2022.09.28.11.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 11:43:12 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org,
        =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Subject: [PATCH v2 2/2] ksmbd-tools: preserve share name case by casefolding at lookup-time
Date:   Wed, 28 Sep 2022 21:42:59 +0300
Message-Id: <20220928184259.75500-2-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220928184259.75500-1-atteh.mailbox@gmail.com>
References: <20220928184259.75500-1-atteh.mailbox@gmail.com>
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

Also, in shm_casefold_share_name(), note that g_utf8_casefold() aborts
on fail, and if g_utf8_normalize() fails, g_ascii_strdown() aborts on
fail. `share_name' was leaked in srvsvc_share_get_info_invoke() as the
string returned by shm_casefold_share_name() should be freed. Before
that, `share_name' was the string returned by g_ascii_strdown() and
leaked then as well.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 v2:
   - changed commit message to correctly state that g_utf8_casefold()
     aborts on fail rather than `cannot fail'.

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

