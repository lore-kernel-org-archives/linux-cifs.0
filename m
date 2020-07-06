Return-Path: <SRS0=VVBU=AR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8188DC433E2
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57CBB20708
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="DY8jhhfj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgGFPcF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:32:05 -0400
Received: from mx.cjr.nz ([51.158.111.142]:53956 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729338AbgGFPcE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Jul 2020 11:32:04 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id E7F257FD17;
        Mon,  6 Jul 2020 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1594049117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eYQUqfplavCO+pt7bDbBchbTrXNTFqMKgthQFMAyF5Q=;
        b=DY8jhhfjzY4zpF7izWsTV8Dy/05wXUIBJQZrvhWugUgyyFz9/TnDWZHB5LBJ6Cyn0Bbdex
        AEFOclpt9GWKr5yBo062VLrd7ylnI/frZvdOXjLsn4ATjEIF7c5V5Cj4yh+AsNC3mzFXUj
        wGYLXH27TD7CpDPSzWj4r90dFsJWri1Lb4kEF9vhT+g5bd4kzfmGD6VK4YOadHRrD9qEX2
        V5PfyvB5L2yuY9A7aHjuSmhz0SKoGLzVk27WEkFSoRGU3NxweIkX/hV4RNetIfzH8Qzosc
        +iteDO3+oe5vAqK/gaqtAJzlP2wz5kVe4YFvPO7YGZJ5nc8L7TznshnJKG9YBA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 0/7] DFS fixes
Date:   Mon,  6 Jul 2020 12:23:55 -0300
Message-Id: <20200706152402.5721-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Follow some fixes, cleanups and documentation for DFS.

All DFS failover tests passed with this series in our local buildbot.

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
 fs/cifs/connect.c   | 504 ++++++++++++++++++++++++++------------------
 fs/cifs/dfs_cache.c | 136 +++++++++---
 fs/cifs/dfs_cache.h |   7 +-
 fs/cifs/misc.c      |   7 +-
 fs/cifs/smb2pdu.c   | 113 +---------
 7 files changed, 428 insertions(+), 457 deletions(-)

-- 
2.27.0

