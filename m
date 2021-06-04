Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D5EC4743D
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E75A6613AD
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhFDW1l (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 18:27:41 -0400
Received: from mx.cjr.nz ([51.158.111.142]:9376 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231634AbhFDW1k (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 4 Jun 2021 18:27:40 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 8ED047FC02;
        Fri,  4 Jun 2021 22:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1622845553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qQctAvOTUXC1/QYDZ1ojaZI9VHRRO6ZF/EDn5q9rQFs=;
        b=FczlLRcPHugCmd9DqB3rp5LxSEaQAvY6ssUmkB3XaFakPFO60wGnoPlp0Cnp6AOIsdxgkv
        OixOWJRD0vtqeLQH5tFD0aKreTM0krD0bAkI16AzihfWWlkreQ2uLxGqUvwu3v0LrQR+gG
        E1ObweMead8UPZb5eQ9hhcZqZSKZ3SwNpHJOpjvF6nRMV6jZjw93HN9IatIvYjrxz0b0tA
        qdbdUlhm7kGWBLgbSTuFzmr1v68Xj8gknES4erbf+OnwcbLJ0WK/KB/wnWwwF2evg8HYhO
        D5TyMyLomQ+8WA0MJZA2U0ZljNIn0Kk29lHGLfjoFUdvO07ylfUp16N0uqzp+w==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 0/7] dfs fixes
Date:   Fri,  4 Jun 2021 19:25:26 -0300
Message-Id: <20210604222533.4760-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Follow a series with dfs fixes and improvements.

  - correctly handle different charsets when passing around DFS paths
    by converting them all to a default enconding in cache (utf8).

  - keep SMB sessions alive as long as dfs mounts are actives in order
    to refresh cached entries by using IPC tcons.

  - set a mininum of 2 minutes for refreshing cached entries

  - fix broken hash of case sensitive DFS paths

  - skip unnecessary tree disconnect of IPCs when shutting down SMB
    sessions (it didn't even work before).

  - do not share tcp servers when mounting dfs shares because they may
    failover to completely different targets (use nosharesock).

Paulo Alcantara (7):
  cifs: do not send tree disconnect to ipc shares
  cifs: get rid of @noreq param in __dfs_cache_find()
  cifs: keep referral server sessions alive
  cifs: handle different charsets in dfs cache
  cifs: fix path comparison and hash calc
  cifs: set a minimum of 2 minutes for refreshing dfs cache
  cifs: do not share tcp servers with dfs mounts

 fs/cifs/cifs_fs_sb.h |    7 +-
 fs/cifs/cifsglob.h   |    3 +-
 fs/cifs/connect.c    |  132 +++---
 fs/cifs/dfs_cache.c  | 1004 +++++++++++++++++-------------------------
 fs/cifs/dfs_cache.h  |   45 +-
 5 files changed, 498 insertions(+), 693 deletions(-)

-- 
2.31.1

