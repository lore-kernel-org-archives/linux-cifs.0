Return-Path: <SRS0=SV7R=YL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDAFCA9EA9
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Oct 2019 22:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3709E21D7C
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Oct 2019 22:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571436830;
	bh=uhc6qrmgYf8tNuiZPGZcsbbrTbtSfMBBHflqUUXRHqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=k42Lj7n3fe7tRcRzUHqVbvOhhi3167XxRVLubrf1rHxIhww/GLICBuEFiO7wdx4Lm
	 1LzEtvGQVhndW+jUf2fXp1hGE0QsEt5eIOA0+rI++F+4SyoHIdctUspm56nOcp1PTb
	 9x7PehjgEo2wgJQccvzIZsaYnxc/KNIe6xWxRWto=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbfJRWNk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Oct 2019 18:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389253AbfJRWJr (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 18 Oct 2019 18:09:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E38A022477;
        Fri, 18 Oct 2019 22:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436586;
        bh=uhc6qrmgYf8tNuiZPGZcsbbrTbtSfMBBHflqUUXRHqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjkyIWz/ilKep35HrCmdQsbMF0rAF6h2UZoGuGlVlCxPeVsawLViZyAKu9yXEwpKU
         iq8l6uLXlYE5bVdDcSqQzSZpgIOBznc/n34GX9h1hSQuJ/5cxlcJqKikD8Dh6jMExC
         QZuuhKffBU5ZvQbCo8tTC0XKeEPiGlDJbIxNegP8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/29] fs: cifs: mute -Wunused-const-variable message
Date:   Fri, 18 Oct 2019 18:09:06 -0400
Message-Id: <20191018220920.10545-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220920.10545-1-sashal@kernel.org>
References: <20191018220920.10545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit dd19c106a36690b47bb1acc68372f2b472b495b8 ]

After 'Initial git repository build' commit,
'mapping_table_ERRHRD' variable has not been used.

So 'mapping_table_ERRHRD' const variable could be removed
to mute below warning message:

   fs/cifs/netmisc.c:120:40: warning: unused variable 'mapping_table_ERRHRD' [-Wunused-const-variable]
   static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
                                           ^
Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/netmisc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index cc88f4f0325ef..bed9733302279 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -130,10 +130,6 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{0, 0}
 };
 
-static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
-	{0, 0}
-};
-
 /*
  * Convert a string containing text IPv4 or IPv6 address to binary form.
  *
-- 
2.20.1

