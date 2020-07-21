Return-Path: <SRS0=/QKu=BA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34814C433E8
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Jul 2020 12:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 165AA2077D
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Jul 2020 12:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="tXgSEVXU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgGUMhr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jul 2020 08:37:47 -0400
Received: from mx.cjr.nz ([51.158.111.142]:37016 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgGUMhr (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Jul 2020 08:37:47 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 99EDD7FEAD;
        Tue, 21 Jul 2020 12:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1595335066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iW9xnn99/V73gNVIYLzhHSmVHQECit90ZLe5SFmjiKk=;
        b=tXgSEVXUkDsU++EMKxeAwAGxHyKXJDo7u23TnALYpMerUkKd1eWjYoL3gaHzkfJbeifMjM
        1NHtqhRJDJzz6EQSFJQO6eDR1Yj5GsMeLeV7CJ1qjd4PzJADYoRNkg0SnoM35HCBpqMyh2
        HPqjwEo5M37zUJVEDTKMjonZrWyGMd/l1DFoUfuDhYaFPE7cbaN9O03mSPqqcB+JmfgGFo
        6ouOTk32+G7SCzkm+6QGcq/3MUUou6JYXtxRBIFoM0pZi+94BYE0Pgt0aYaRjsSGJpM0BJ
        V7VElAaMRiiTRl2Bm8coNBn34AF1g+DGFr/RJ5UteZ65JOKNoCWI5uT63b0ylw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH v3 6/7] cifs: only update prefix path of DFS links in cifs_tree_connect()
Date:   Tue, 21 Jul 2020 09:36:43 -0300
Message-Id: <20200721123644.14728-7-pc@cjr.nz>
In-Reply-To: <20200721123644.14728-1-pc@cjr.nz>
References: <20200721123644.14728-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

For DFS root mounts that contain a prefix path, do not change them
after failover.

E.g., if the user mounts

	//srvA/root/dir1

and then lost connection to srvA, it will reconnect to

	//srvB/root/dir1

In case of DFS links, which may resolve to different prefix paths
depending on their list of targets, the following must be supported:

	- mount //srvA/root/link/bar
	- connect to //srvA/share
	- set prefix path to "bar"
	- lost connection to srvA
	- reconnect to next target: //srvB/share/foo
	- set new prefix path to "foo/bar"

In cifs_tree_connect(), check the server_type field of the cached DFS
referral to determine whether or not prefix path should be updated.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2abef1c8feb3..af0c19495626 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5549,6 +5549,8 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	const char *dfs_host;
 	size_t dfs_host_len;
 	char *share = NULL, *prefix = NULL;
+	struct dfs_info3_param ref = {0};
+	bool isroot;
 
 	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
 	if (!tree)
@@ -5564,9 +5566,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		goto out;
 	}
 
-	rc = dfs_cache_noreq_find(tcon->dfs_path + 1, NULL, &tl);
+	rc = dfs_cache_noreq_find(tcon->dfs_path + 1, &ref, &tl);
 	if (rc)
 		goto out;
+	isroot = ref.server_type == DFS_TYPE_ROOT;
+	free_dfs_info_param(&ref);
 
 	extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
 
@@ -5608,7 +5612,8 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		} else {
 			scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
 			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
-			if (!rc) {
+			/* Only handle prefix paths of DFS link targets */
+			if (!rc && !isroot) {
 				rc = update_super_prepath(tcon, prefix);
 				break;
 			}
-- 
2.27.0

