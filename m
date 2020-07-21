Return-Path: <SRS0=/QKu=BA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A2CC433E2
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Jul 2020 12:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C7E620717
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Jul 2020 12:37:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="JxdCGuPa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgGUMhe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jul 2020 08:37:34 -0400
Received: from mx.cjr.nz ([51.158.111.142]:36604 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgGUMhd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Jul 2020 08:37:33 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id A4FEA7FE99;
        Tue, 21 Jul 2020 12:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1595335052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+E+KZDff/UStJUrksZwrVoLVOzRSSklMEwrfGJTemWE=;
        b=JxdCGuPawnfAbFjYw0Jd25M0DR6TzHAQBPRXEmFmSlnT22lsVQAatSECRvjb7ozjY+JuuT
        cwraeibLGnq1HcdZPMToVpQmKacL5/Y+wImxKeGz7pULgXC9aZTlocIN56PvWJ98qQ+k7a
        q3+CgkjlrdF3JWQ44+WeG8XxDpbmtOFQMoUnUal7OqFuwquCaXK8Q11beMKSe08s+Lz7L3
        Xub3nmxebDJPphCT+sJctP1AV8fdEZOwzYkMLlNqLJakUSFSj0iMxUxG2oCgUxFXf3fQc0
        pZHr38Aq0dWrdN9w21lIoDnm1CbTd6WQqNNtOs9JJWtCWgSHYiKKYBV4DEA8oQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH v3 0/7] DFS fixes
Date:   Tue, 21 Jul 2020 09:36:37 -0300
Message-Id: <20200721123644.14728-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Follow some fixes, cleanups and documentation for DFS.

All DFS failover tests passed with this series in our local buildbot.

v1 -> v2:
  * fix bad rebase that removed usage of "share_len" in scnprintf()
    (Metze)

v2 -> v3:
  * fix typo and bad comment style in patch 7/7 (Aurelien)

Paulo Alcantara (6):
  cifs: reduce number of referral requests in DFS link lookups
  cifs: rename reconn_inval_dfs_target()
  cifs: handle empty list of targets in cifs_reconnect()
  cifs: handle RESP_GET_DFS_REFERRAL.PathConsumed in reconnect
  cifs: only update prefix path of DFS links in cifs_tree_connect()
  cifs: document and cleanup dfs mount

Stefan Metzmacher (1):
  cifs: merge __{cifs,smb2}_reconnect[_tcon]() into cifs_tree_connect()

 fs/cifs/cifsproto.h |   6 +-
 fs/cifs/cifssmb.c   | 112 +---------
 fs/cifs/connect.c   | 505 ++++++++++++++++++++++++++------------------
 fs/cifs/dfs_cache.c | 136 +++++++++---
 fs/cifs/dfs_cache.h |   7 +-
 fs/cifs/misc.c      |   7 +-
 fs/cifs/smb2pdu.c   | 113 +---------
 7 files changed, 429 insertions(+), 457 deletions(-)

-- 
2.27.0

