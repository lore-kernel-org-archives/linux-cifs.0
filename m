Return-Path: <SRS0=VVBU=AR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296D9C433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 18:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B280206E2
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 18:16:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="azeY0y6V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgGFSQw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jul 2020 14:16:52 -0400
Received: from mx.cjr.nz ([51.158.111.142]:20774 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729736AbgGFSQw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Jul 2020 14:16:52 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 937007FD17;
        Mon,  6 Jul 2020 18:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1594059411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iW9xnn99/V73gNVIYLzhHSmVHQECit90ZLe5SFmjiKk=;
        b=azeY0y6VkH7eduPEjhOYLNI0CUQVf1Hj/rO0yJvuIjJaF63vY+RCqkkibq+EUl2z/BkAdz
        Req35jqYQ6lkEBWEycYMt9GBkZsFY2Dlqb01W1bmhftDeDRVdRYXExZYznQkP4XppX/ihx
        PFPlKFx0ETV2/H/1exntiDAvvQ3IkmIG5gzvHT6VRTCUOCL4nIDUI4Bo9ldyyBRTAxsn2l
        +wBsl8acqQI2i80RZ2o4enT+nfFEPM1vIBTORQ8ZbtGy0nYKpjEEDh0STqlosekjEfxwdC
        T9iiZoPw0aSRAL/pqF0leiX0WoRTff/UTqLTQVEv0lFAZ7YoLExNEvr7rY3Rqg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH v2 6/7] cifs: only update prefix path of DFS links in cifs_tree_connect()
Date:   Mon,  6 Jul 2020 15:16:08 -0300
Message-Id: <20200706181609.19480-7-pc@cjr.nz>
In-Reply-To: <20200706181609.19480-1-pc@cjr.nz>
References: <20200706181609.19480-1-pc@cjr.nz>
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

