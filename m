Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24555C432C0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 16:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B97FE20740
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 16:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="RR7uHmB/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfKYQ62 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 11:58:28 -0500
Received: from mx.cjr.nz ([51.158.111.142]:22474 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbfKYQ61 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 25 Nov 2019 11:58:27 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id A620880A4E;
        Mon, 25 Nov 2019 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574701106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6Skm8dMLpWsGh8DBIVL66s82RsI1FhaLxGCaayrTnLY=;
        b=RR7uHmB/LEDpSV7cJErLP/7gDpPgg4a2qIcecpum2YhYS7OUEHm3qNN/eJKz3Mk34C8/7X
        jVnA2PwcHaYscFTfm32CKK2hGyiH8CMSngwkSXEEs2AE96EJyD8hR81aktxflOaiSFDAJ2
        O8LOYareIsd2IuHV4DCfvB0krLN/w5oIBfpwSABnv65gxI5/RDBnXKkAAfrgP4LH5KqTHE
        7FjqmGYqqF4x8p+NCHmUxAU6RMJs+hw9QnjZ437w36Wgbicq2yUTW4rOSbzgUagcNYrITP
        wSgt/7HK6sRciz5iCaxQLgtA+wHGBmcViQU8n99P8WAnhYDVOUd878QQOTU5SA==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com, aaptel@suse.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH v2 0/7] DFS fixes
Date:   Mon, 25 Nov 2019 13:57:51 -0300
Message-Id: <20191125165758.3793-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Follow v2 of DFS fixes and cleanups, and one fix related to
multichannel support.

It's basically addressing Aurelien's comments on v1.

Paulo Alcantara (SUSE) (7):
  cifs: Fix use-after-free bug in cifs_reconnect()
  cifs: Fix lookup of root ses in DFS referral cache
  cifs: Fix potential softlockups while refreshing DFS cache
  cifs: Clean up DFS referral cache
  cifs: Fix potential deadlock when updating vol in cifs_reconnect()
  cifs: Fix retrieval of DFS referrals in cifs_mount()
  cifs: Always update signing key of first channel

 fs/cifs/connect.c       |   78 ++-
 fs/cifs/dfs_cache.c     | 1030 ++++++++++++++++++++-------------------
 fs/cifs/smb2pdu.c       |   41 +-
 fs/cifs/smb2transport.c |    4 +
 4 files changed, 623 insertions(+), 530 deletions(-)

-- 
2.24.0

