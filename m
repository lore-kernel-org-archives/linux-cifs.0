Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDD1C4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE01C613D0
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhHWPQI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231256AbhHWPQI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:16:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48D9D61371;
        Mon, 23 Aug 2021 15:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731725;
        bh=h/jWLCaITa9eoGq1gm+kWk1DhvEg7ICI8swntx/1Q00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qap8iJxaKEuzj1VltqH68am4/O4AxJBJapOPm913bfMJG9ZIyfryQ74GSpH6NmEiQ
         JPKusrZ98YE7GY6uuYT0naJ2kxjLJgSRRjuavY3bcxW86SPqv/4WNA1jNZCsgsnPrq
         NsaoNdESKOv9MkePaxTCZjsSozLdDOYUPEp4jaZU5dxIaU/p/MbDQ1W/aqNzenGuGW
         r2gAj7gZjG/fOcdfnOomDaFpQ/hnRQ24d7FDw8mCYjPQAEhqAhSjD4sgUk373L0w/J
         foZX+Q37vRz/LayuI8W84ExVGrFriyTtrebrypcXJSyoCoIhDax5ROHmGFfezjoPfX
         CzD8WCJsNeYUQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 07/11] ksmbd: fix translation in sid_to_id()
Date:   Mon, 23 Aug 2021 17:13:53 +0200
Message-Id: <20210823151357.471691-8-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823151357.471691-1-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2141; h=from:subject; bh=rMF3itLrpYTdQu1ZdM92PWJowTgFXeRipkbM6IbiijA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zbamfB6b92moxr9u/pEpJU3XNhefCFbI9/b8tL6NSe3 fblu1lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARh+WMDL0zkt0tNv+7MSkr+FrDa3 9ulp4FS/k4avUirlRXLJ0kdoORYb0Ob3DLnwlus02Xnyp8t4D375UjhofmsFiXrg8LPM69jwMA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

The sid_to_id() functions is relevant when changing ownership of
filesystem objects based on acl information. In this case we need to
first translate the relevant s*ids into k*ids in ksmbd's user namespace
and account for any idmapped mounts. Requesting a change in ownership
requires the inverse translation to be applied when we would report
ownership to userspace. So k*id_from_mnt() must be used here.

Cc: Steve French <stfrench@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ksmbd/smbacl.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 0d269b28f163..ef5896297607 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -275,8 +275,15 @@ static int sid_to_id(struct user_namespace *user_ns,
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
 		if (id >= 0) {
-			uid = make_kuid(user_ns, id);
-			if (uid_valid(uid) && kuid_has_mapping(user_ns, uid)) {
+			/*
+			 * Translate raw sid into kuid in the server's user
+			 * namespace.
+			 */
+			uid = make_kuid(&init_user_ns, id);
+
+			/* If this is an idmapped mount, apply the idmapping. */
+			uid = kuid_from_mnt(user_ns, uid);
+			if (uid_valid(uid)) {
 				fattr->cf_uid = uid;
 				rc = 0;
 			}
@@ -286,9 +293,16 @@ static int sid_to_id(struct user_namespace *user_ns,
 		gid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-			gid = make_kgid(user_ns, id);
-			if (gid_valid(gid) && kgid_has_mapping(user_ns, gid)) {
 		if (id >= 0) {
+			/*
+			 * Translate raw sid into kgid in the server's user
+			 * namespace.
+			 */
+			gid = make_kgid(&init_user_ns, id);
+
+			/* If this is an idmapped mount, apply the idmapping. */
+			gid = kgid_from_mnt(user_ns, gid);
+			if (gid_valid(gid)) {
 				fattr->cf_gid = gid;
 				rc = 0;
 			}
-- 
2.30.2

