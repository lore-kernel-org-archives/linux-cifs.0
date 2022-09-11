Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF343C6FA86
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Sep 2022 21:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiIKV4B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 11 Sep 2022 17:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIKV4A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 11 Sep 2022 17:56:00 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94451FCF9
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 14:55:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z25so11938867lfr.2
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 14:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=u3ULhUZQNj/3EvXCA6Ax4jhCcnMt8WPOe6AavfYb3rI=;
        b=oCc8I679JoJDDMoFEywqhxNiVkwoyccZi6dijw9ZJIxR72RWAJCPMeA956Zkn1tYvv
         7IFTQEpKoqATK8BLcK4jEJ77ENIoxP+9cdeW1qQQRaHJRuxS31yOAKZSRbO/30oy4zeg
         lPukq9HKlVqxWrxCc/4y8q499sXpvgQ2gKzmPTDef5xH8HWhjYFJiqOpsKn8FLHP/0Vq
         lJTpzbn2f8gsI5dKe8kTbusFnywTNMCKd7fQ4KDfe1/6Wsety2+HXxl8nBjV/CajeLEM
         h/PYpRLqPTfvYtT/vGw/yyNsqIemKIMUrB1ocDJHZ2ghZddlwWcU4vVBNFYZoU6yJN/X
         UgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=u3ULhUZQNj/3EvXCA6Ax4jhCcnMt8WPOe6AavfYb3rI=;
        b=Eun3a3j4e8S7cqp6aYJs5BJPKTZHvQPT7FPwwMbU6oSNy6xhUS2sV4PASkoLvnvYyP
         wFOeDdjPvVwSyHklbBzAv7Y9544l+CWvjWGbua7REAnE3/+0HAlAyr8opF2e+uSksvOe
         zCwBKYco1yLN0i4GApGmCRVTllSwlZhw9lKNL2LPCA5iSmda1vPCA6QD0UyWFDnxATt0
         Gk5d6Z4atYMPTGp5GmUiCd3ZEnYzT9wSxre1D1UUxAIHS7+xxPAuOkqI3WAhGLY2TSHD
         ROg1oRoG8DOzqhiGqswljry3AxOOW0ONP/9R+v/sDxDnMPASAygjI/ICbcQAsZiQiXSy
         lKhw==
X-Gm-Message-State: ACgBeo2c4+2cMiRC5UrgwDLcTmlipmu7iaz0D2LM50br7bVbsFhCArMy
        iqoAXT1ntoasCsJjhHlPi/Vigd/H8ew=
X-Google-Smtp-Source: AA6agR6kvof6pKiB9qJ7ycK65ocE9fE5JlUtJCn6hb/NRCmXOVuxnDUd70U6LN7f5OBR7enLMHj4Mw==
X-Received: by 2002:ac2:4f03:0:b0:495:ec98:bcac with SMTP id k3-20020ac24f03000000b00495ec98bcacmr7637562lfr.339.1662933357007;
        Sun, 11 Sep 2022 14:55:57 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84bc-66.dhcp.inet.fi. [46.132.188.66])
        by smtp.gmail.com with ESMTPSA id b14-20020a05651c032e00b0026ac7cd51afsm789904ljp.57.2022.09.11.14.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 14:55:56 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Subject: [PATCH v2 2/2] ksmbd-tools: casefold utf-8 share names
Date:   Mon, 12 Sep 2022 00:55:42 +0300
Message-Id: <20220911215542.104935-2-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220911215542.104935-1-atteh.mailbox@gmail.com>
References: <20220911215542.104935-1-atteh.mailbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Match kernel space behavior regarding case-insensitivity of UTF-8 share
names by first NFD(I) normalizing and then casefolding them. Fallback
to ASCII lowercase conversion on failure.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 addshare/addshare.c        |  6 +++---
 include/management/share.h |  1 +
 lib/config_parser.c        |  2 +-
 lib/management/share.c     | 19 +++++++++++++++++++
 mountd/rpc_srvsvc.c        |  2 +-
 5 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/addshare/addshare.c b/addshare/addshare.c
index f5894c9..be4c67d 100644
--- a/addshare/addshare.c
+++ b/addshare/addshare.c
@@ -123,17 +123,17 @@ int main(int argc, char *argv[])
 		switch (c) {
 		case 'a':
 			g_free(share);
-			share = g_ascii_strdown(optarg, strlen(optarg));
+			share = shm_casefold_share_name(optarg, strlen(optarg));
 			command = command_add_share;
 			break;
 		case 'd':
 			g_free(share);
-			share = g_ascii_strdown(optarg, strlen(optarg));
+			share = shm_casefold_share_name(optarg, strlen(optarg));
 			command = command_del_share;
 			break;
 		case 'u':
 			g_free(share);
-			share = g_ascii_strdown(optarg, strlen(optarg));
+			share = shm_casefold_share_name(optarg, strlen(optarg));
 			command = command_update_share;
 			break;
 		case 'o':
diff --git a/include/management/share.h b/include/management/share.h
index 306cca5..bb3952c 100644
--- a/include/management/share.h
+++ b/include/management/share.h
@@ -141,6 +141,7 @@ static inline int test_share_flag(struct ksmbd_share *share, int flag)
 
 struct ksmbd_share *get_ksmbd_share(struct ksmbd_share *share);
 void put_ksmbd_share(struct ksmbd_share *share);
+char *shm_casefold_share_name(char *name, size_t len);
 struct ksmbd_share *shm_lookup_share(char *name);
 
 struct smbconf_group;
diff --git a/lib/config_parser.c b/lib/config_parser.c
index 2dbc0c7..a1dc85c 100644
--- a/lib/config_parser.c
+++ b/lib/config_parser.c
@@ -93,7 +93,7 @@ static int add_new_group(char *line)
 	while (*end && *end != ']')
 		end = g_utf8_find_next_char(end, NULL);
 
-	name = g_ascii_strdown(begin + 1, end - begin - 1);
+	name = shm_casefold_share_name(begin + 1, end - begin - 1);
 	if (!name)
 		goto out_free;
 
diff --git a/lib/management/share.c b/lib/management/share.c
index 22e6a83..fc09ea8 100644
--- a/lib/management/share.c
+++ b/lib/management/share.c
@@ -236,6 +236,25 @@ int shm_init(void)
 	return 0;
 }
 
+char *shm_casefold_share_name(char *name, size_t len)
+{
+	char *nfdi_name, *nfdicf_name;
+
+	nfdi_name = g_utf8_normalize(name, len, G_NORMALIZE_NFD);
+	if (!nfdi_name)
+		goto out_ascii;
+
+	nfdicf_name = g_utf8_casefold(nfdi_name, strlen(nfdi_name));
+	if (!nfdicf_name)
+		goto out_ascii;
+
+	g_free(nfdi_name);
+	return nfdicf_name;
+out_ascii:
+	g_free(nfdi_name);
+	return g_ascii_strdown(name, len);
+}
+
 static struct ksmbd_share *__shm_lookup_share(char *name)
 {
 	return g_hash_table_lookup(shares_table, name);
diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
index 38b984b..8716c34 100644
--- a/mountd/rpc_srvsvc.c
+++ b/mountd/rpc_srvsvc.c
@@ -171,7 +171,7 @@ static int srvsvc_share_get_info_invoke(struct ksmbd_rpc_pipe *pipe,
 	int ret;
 	gchar *share_name;
 
-	share_name = g_ascii_strdown(STR_VAL(hdr->share_name),
+	share_name = shm_casefold_share_name(STR_VAL(hdr->share_name),
 			strlen(STR_VAL(hdr->share_name)));
 	share = shm_lookup_share(share_name);
 	if (!share)
-- 
2.37.3

