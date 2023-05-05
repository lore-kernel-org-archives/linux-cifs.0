Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E742C77B7F
	for <linux-cifs@archiver.kernel.org>; Fri,  5 May 2023 15:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjEEPLn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 11:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjEEPLl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 11:11:41 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6D81BCA
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 08:11:40 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-64115eef620so20304506b3a.1
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 08:11:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683299500; x=1685891500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8DXrSaE6zOPFKBmuperzy90vB6D7jP30vHLQQ+YPNwU=;
        b=eX8VHuugCeXWwJ7Pjsdc0BFefTOehaRWKwsxZQJ94sxTgwqq6x+PzSR4P7av2X9h04
         Xf1Vp1+MBVB9tDEiXYRbUglXjJX1ZbypEpNLbHgpTrP8cFqwnZW66jnYjtGmNLPyOUMi
         /vd8k4D3tpHrIghs/0gz5x0nJ8IT9aVbUY+Eob/BOmW/IvD9p92rgeOvDDnZOMMQ+9Ti
         XY33cPaAC5OsehMZjfTCqeNUgzYpE4TAKUoil9NAKWNgWqczlETjVFjQd41PDDIBj7IX
         5N5BmVD073HfI1dFam5zmUwe6dyDnNNvTADmGFssixaV8Kj/dnp+V+IKRB9DIE2A9y+f
         9Prg==
X-Gm-Message-State: AC+VfDx0yrk9H1o/RhLYqQF3maMBR/q9ORwcVs0C5ZGFKlZvJGCwYCqS
        xpjMkW4EMKRDNp9yuFFfkn6mHY9qs3A=
X-Google-Smtp-Source: ACHHUZ6/MkjJBr1Id9+72OG97xdU+HBISKXqy2TCjor3TjdyD8iI2569/fCyHafL7j+BWryFpw5+Ag==
X-Received: by 2002:a17:90b:1e51:b0:24e:d06:6912 with SMTP id pi17-20020a17090b1e5100b0024e0d066912mr2397630pjb.18.1683299499879;
        Fri, 05 May 2023 08:11:39 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902d4c400b001a2135e7eabsm1950898plg.16.2023.05.05.08.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 08:11:39 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5/6] ksmbd: remove unused ksmbd_tree_conn_share function
Date:   Sat,  6 May 2023 00:11:07 +0900
Message-Id: <20230505151108.5911-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230505151108.5911-1-linkinjeon@kernel.org>
References: <20230505151108.5911-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove unused ksmbd_tree_conn_share function.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/mgmt/tree_connect.c | 11 -----------
 fs/ksmbd/mgmt/tree_connect.h |  3 ---
 2 files changed, 14 deletions(-)

diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
index f07a05f37651..408cddf2f094 100644
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -120,17 +120,6 @@ struct ksmbd_tree_connect *ksmbd_tree_conn_lookup(struct ksmbd_session *sess,
 	return tcon;
 }
 
-struct ksmbd_share_config *ksmbd_tree_conn_share(struct ksmbd_session *sess,
-						 unsigned int id)
-{
-	struct ksmbd_tree_connect *tc;
-
-	tc = ksmbd_tree_conn_lookup(sess, id);
-	if (tc)
-		return tc->share_conf;
-	return NULL;
-}
-
 int ksmbd_tree_conn_session_logoff(struct ksmbd_session *sess)
 {
 	int ret = 0;
diff --git a/fs/ksmbd/mgmt/tree_connect.h b/fs/ksmbd/mgmt/tree_connect.h
index 700df36cf3e3..562d647ad9fa 100644
--- a/fs/ksmbd/mgmt/tree_connect.h
+++ b/fs/ksmbd/mgmt/tree_connect.h
@@ -53,9 +53,6 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 struct ksmbd_tree_connect *ksmbd_tree_conn_lookup(struct ksmbd_session *sess,
 						  unsigned int id);
 
-struct ksmbd_share_config *ksmbd_tree_conn_share(struct ksmbd_session *sess,
-						 unsigned int id);
-
 int ksmbd_tree_conn_session_logoff(struct ksmbd_session *sess);
 
 #endif /* __TREE_CONNECT_MANAGEMENT_H__ */
-- 
2.25.1

