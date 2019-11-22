Return-Path: <SRS0=i0zP=ZO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C84CC43215
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 15:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D602071C
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 15:31:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="pTDP4LU7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKVPbf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Nov 2019 10:31:35 -0500
Received: from mx.cjr.nz ([51.158.111.142]:28366 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbfKVPbe (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 Nov 2019 10:31:34 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id BEB4D80A51;
        Fri, 22 Nov 2019 15:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574436693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TL+iDtf94Un9S16xHcxwwTQLovW35LDjQhOGiKvA7yc=;
        b=pTDP4LU7nnHANRYtcZ5YjW7UmcnNsZJcZycBHZQpef+OTUg80swusWBhoqzuIIjZvTlI6C
        rrC7Tj3WVtQyfYSvQTxwZM7e+cRHYwO3Fe3wufshmxt/EUZyQZf9oN1s+MPOLaBdp1E4Xf
        Dd79KlDgwIv+HskrZjCHXRLAnQf/6rQn+8rxaA2zgOmNo/FVc0/VuInggfg/DqMJXvqFk1
        h1ESGbP59140cEglkAhEl3pLykACHf0trAc69vAlRtLAt9q2qW7y+GYJ/D6qlq0GiEqApM
        cYOLlpQjgg6wL7aTkA9g+Qig/OTKpNyYpD7y/5gVXidCEoJPwWR6lJrI2Ya6NA==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH 2/7] cifs: Fix lookup of root ses in DFS referral cache
Date:   Fri, 22 Nov 2019 12:30:52 -0300
Message-Id: <20191122153057.6608-3-pc@cjr.nz>
In-Reply-To: <20191122153057.6608-1-pc@cjr.nz>
References: <20191122153057.6608-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We don't care about module aliasing validation in
cifs_compose_mount_options(..., is_smb3) when finding the root SMB
session of an DFS namespace in order to refresh DFS referral cache.

The following issue has been observed when mounting with '-t smb3' and
then specifying 'vers=2.0':

...
Nov 08 15:27:08 tw kernel: address conversion returned 0 for FS0.WIN.LOCAL
Nov 08 15:27:08 tw kernel: [kworke] ==> dns_query((null),FS0.WIN.LOCAL,13,(null))
Nov 08 15:27:08 tw kernel: [kworke] call request_key(,FS0.WIN.LOCAL,)
Nov 08 15:27:08 tw kernel: [kworke] ==> dns_resolver_cmp(FS0.WIN.LOCAL,FS0.WIN.LOCAL)
Nov 08 15:27:08 tw kernel: [kworke] <== dns_resolver_cmp() = 1
Nov 08 15:27:08 tw kernel: [kworke] <== dns_query() = 13
Nov 08 15:27:08 tw kernel: fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: FS0.WIN.LOCAL to 192.168.30.26
===> Nov 08 15:27:08 tw kernel: CIFS VFS: vers=2.0 not permitted when mounting with smb3
Nov 08 15:27:08 tw kernel: fs/cifs/dfs_cache.c: CIFS VFS: leaving refresh_tcon (xid = 26) rc = -22
...

Fixes: 5072010ccf05 ("cifs: Fix DFS cache refresher for DFS links")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 1692c0c6c23a..2faa05860a48 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1317,7 +1317,6 @@ static struct cifs_ses *find_root_ses(struct dfs_cache_vol_info *vi,
 	int rc;
 	struct dfs_info3_param ref = {0};
 	char *mdata = NULL, *devname = NULL;
-	bool is_smb3 = tcon->ses->server->vals->header_preamble_size == 0;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct smb_vol vol;
@@ -1344,7 +1343,7 @@ static struct cifs_ses *find_root_ses(struct dfs_cache_vol_info *vi,
 		goto out;
 	}
 
-	rc = cifs_setup_volume_info(&vol, mdata, devname, is_smb3);
+	rc = cifs_setup_volume_info(&vol, mdata, devname, false);
 	kfree(devname);
 
 	if (rc) {
-- 
2.24.0

