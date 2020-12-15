Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69FE4C2BBCF
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 16:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4527322571
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 16:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731217AbgLOQsK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Dec 2020 11:48:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:54696 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbgLOQsC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 15 Dec 2020 11:48:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 67A3DAD11;
        Tue, 15 Dec 2020 16:47:21 +0000 (UTC)
From:   Samuel Cabrero <scabrero@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     Samuel Cabrero <scabrero@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] cifs: Fix some error pointers handling detected by static checker
Date:   Tue, 15 Dec 2020 17:46:56 +0100
Message-Id: <20201215164656.28788-1-scabrero@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

* extract_hostname() and extract_sharename() never return NULL, so
  use IS_ERR() instead of IS_ERR_OR_NULL() in cifs_find_swn_reg(). If
  any of these functions return an error, then return an error pointer
  instead of NULL.
* Change cifs_find_swn_reg() function to always return a valid pointer
  or an error pointer, instead of returning NULL if the registration
  is not found.
* Finally update cifs_find_swn_reg() callers to check for -EEXIST
  instead of NULL.
* In cifs_get_swn_reg() the swnreg idr mutex was not unlocked in the
  error path of cifs_find_swn_reg() call.

Reported-By: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Samuel Cabrero <scabrero@suse.de>
---
 fs/cifs/cifs_swn.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index a172769c239f..69b7571010a6 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -259,24 +259,24 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 	const char *net_name;
 
 	net_name = extract_hostname(tcon->treeName);
-	if (IS_ERR_OR_NULL(net_name)) {
+	if (IS_ERR(net_name)) {
 		int ret;
 
 		ret = PTR_ERR(net_name);
 		cifs_dbg(VFS, "%s: failed to extract host name from target '%s': %d\n",
 				__func__, tcon->treeName, ret);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	share_name = extract_sharename(tcon->treeName);
-	if (IS_ERR_OR_NULL(share_name)) {
+	if (IS_ERR(share_name)) {
 		int ret;
 
 		ret = PTR_ERR(net_name);
 		cifs_dbg(VFS, "%s: failed to extract share name from target '%s': %d\n",
 				__func__, tcon->treeName, ret);
 		kfree(net_name);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
@@ -299,7 +299,7 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 	kfree(net_name);
 	kfree(share_name);
 
-	return NULL;
+	return ERR_PTR(-EEXIST);
 }
 
 /*
@@ -315,12 +315,13 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 
 	/* Check if we are already registered for this network and share names */
 	reg = cifs_find_swn_reg(tcon);
-	if (IS_ERR(reg)) {
-		return reg;
-	} else if (reg != NULL) {
+	if (!IS_ERR(reg)) {
 		kref_get(&reg->ref_count);
 		mutex_unlock(&cifs_swnreg_idr_mutex);
 		return reg;
+	} else if (PTR_ERR(reg) != -EEXIST) {
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		return reg;
 	}
 
 	reg = kmalloc(sizeof(struct cifs_swn_reg), GFP_ATOMIC);
@@ -630,9 +631,9 @@ int cifs_swn_unregister(struct cifs_tcon *tcon)
 	mutex_lock(&cifs_swnreg_idr_mutex);
 
 	swnreg = cifs_find_swn_reg(tcon);
-	if (swnreg == NULL) {
+	if (IS_ERR(swnreg)) {
 		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return -EEXIST;
+		return PTR_ERR(swnreg);
 	}
 
 	mutex_unlock(&cifs_swnreg_idr_mutex);
-- 
2.29.2

