Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396FFC4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20FB061371
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhHWPQF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231175AbhHWPQE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:16:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F06361037;
        Mon, 23 Aug 2021 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731722;
        bh=TvWemmwMTjGJ38MCmJVh9h2M8DRO0liI0wRcwOnj2dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QW3AET+MjeN5oBhEhU1vc2voLKvs+WsSjgR4IxYrGbP8g9xFMElO58Fjhzpz861CG
         LHO86gMpaKibrYroSRywwNrTVlbXK+2OcjZu3/VC+6A4zalNlKOU/KYbAXl/fAEcSg
         KlPSK4JEeLcqyYUSgGSKpmXkvxr00hJVABYpRdQbYElyRD6x0vhqvHpSgY3J+0tXVT
         qZw2X7J4jYAALHmQuHvjTEMoKkwkQS5sJsVWNjJY5erFyB1ia81pat3Qgyv0nl0h0P
         C398fbGYaejqi9FSj1qGHcYhn/U/LtWYTjPzS1IjSP2UtQRsIPSr/iIDUplY6b9CvB
         o790CrZBOzuOA==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 06/11] ksmbd: fix subauth 0 handling in sid_to_id()
Date:   Mon, 23 Aug 2021 17:13:52 +0200
Message-Id: <20210823151357.471691-7-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823151357.471691-1-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1349; h=from:subject; bh=piKd0Z4V9Q/Zq2Vjv6OACDHfdXIfdZowokU8XrpxuMw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zbUdIm6dsnOce/ktXnPJp1937RLwYjxD2Ote6zoryUP 9BPZOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayqpvhn92O5b5q6d+mHl7n+l5n0e f/H/ne/lKpaH3sMq20X+bAr1OMDN+TXfxOtO074hD37yEz+ye/d1r/apLi6xj4ZycKm7g38gEA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

It's not obvious why subauth 0 would be excluded from translation. This
would lead to wrong results whenever a non-identity idmapping is used.

Cc: Steve French <stfrench@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ksmbd/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 3307ca776eb1..0d269b28f163 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -274,7 +274,7 @@ static int sid_to_id(struct user_namespace *user_ns,
 		uid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		if (id > 0) {
+		if (id >= 0) {
 			uid = make_kuid(user_ns, id);
 			if (uid_valid(uid) && kuid_has_mapping(user_ns, uid)) {
 				fattr->cf_uid = uid;
@@ -286,9 +286,9 @@ static int sid_to_id(struct user_namespace *user_ns,
 		gid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		if (id > 0) {
 			gid = make_kgid(user_ns, id);
 			if (gid_valid(gid) && kgid_has_mapping(user_ns, gid)) {
+		if (id >= 0) {
 				fattr->cf_gid = gid;
 				rc = 0;
 			}
-- 
2.30.2

