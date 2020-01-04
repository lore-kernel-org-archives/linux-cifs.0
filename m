Return-Path: <SRS0=i2Ti=2Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEAFC00523
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Jan 2020 03:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05E4321D7D
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Jan 2020 03:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578109068;
	bh=Iqlz+iKxY3zlUcIPQj4U95OV05qdZTm+7hovQRC5Z/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PCbRkAxeyjM9Sn+wxoH3orY8sPWXcL4h1A8oiKqzmzSPr57SA1CH3yLthlzYKZ2FZ
	 Nboc5rwmbkMDoEgR0RIcsX61G7CsbW5RxUJdW/dgY6AubCu1S5o39BC2MNMFns7017
	 Jp8x/nxU8JqvSYsTQ6+GoubvnJAqz8R/B3PBF+Z4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgADDga (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Jan 2020 22:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbgADDga (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 3 Jan 2020 22:36:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B45E221D7D;
        Sat,  4 Jan 2020 03:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578108989;
        bh=Iqlz+iKxY3zlUcIPQj4U95OV05qdZTm+7hovQRC5Z/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bftARHLSRgkNOleN01R+iVEizRwLEWEMwdrXG8mBPijBb+9Rj2Z3Su7t0ZDlJqwS0
         vwqoSzDXgTd/W+rEbHTq1TdiWMI6E+5Y3rZlxRLDXkWuyDdiJ+R0+TEiR0ZZYRN2Mp
         XJR6jYfqWWn0aqTgJEN51rdifhZ6dW/4yWDXKY4g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 07/10] cifs: Adjust indentation in smb2_open_file
Date:   Fri,  3 Jan 2020 22:36:16 -0500
Message-Id: <20200104033620.10977-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200104033620.10977-1-sashal@kernel.org>
References: <20200104033620.10977-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 7935799e041ae10d380d04ea23868240f082bd11 ]

Clang warns:

../fs/cifs/smb2file.c:70:3: warning: misleading indentation; statement
is not part of the previous 'if' [-Wmisleading-indentation]
         if (oparms->tcon->use_resilient) {
         ^
../fs/cifs/smb2file.c:66:2: note: previous statement is here
        if (rc)
        ^
1 warning generated.

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Fixes: 592fafe644bf ("Add resilienthandles mount parm")
Link: https://github.com/ClangBuiltLinux/linux/issues/826
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 8b0b512c5792..afe1f03aabe3 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -67,7 +67,7 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		goto out;
 
 
-	 if (oparms->tcon->use_resilient) {
+	if (oparms->tcon->use_resilient) {
 		/* default timeout is 0, servers pick default (120 seconds) */
 		nr_ioctl_req.Timeout =
 			cpu_to_le32(oparms->tcon->handle_timeout);
-- 
2.20.1

