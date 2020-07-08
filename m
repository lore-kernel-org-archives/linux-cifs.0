Return-Path: <SRS0=aqf3=AT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32AD7C433E1
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jul 2020 15:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0797D20720
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jul 2020 15:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594223004;
	bh=FAokqGgeK6mWcP265Yn4T2/8YECIOHBdNrkvb9y7XbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PmgNZHxicaME9KQog9CilTx/o5ij7bccd1IzvjV1cS9L9nEQXeB+6wvFxzVcq/RyR
	 deXalq3d62bnGSHXETJ8HaxblFduKkYLisKK36u8jmfYhtYwcbyNCWvT6l7EqYTGPr
	 Oaj4hHkeNHfWEDlFeedyaPLWMuGxfYcqFm9oqnRQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbgGHPnT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Jul 2020 11:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbgGHPlv (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 8 Jul 2020 11:41:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E12520874;
        Wed,  8 Jul 2020 15:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594222911;
        bh=FAokqGgeK6mWcP265Yn4T2/8YECIOHBdNrkvb9y7XbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piPR9dCT9k/aJcPm8g6m86qTkfNozLx6I6geAai9H4iT7fUat3RoXdr9SkQUfhIQw
         VZAqvWRADPrzdRdIa+5zDMuBUe9CaCUerS4SYL4XnP/j07RZFVfn+gQWyQZ3VqvfRu
         OodjrXsX+ZKNqQ+s57GBg2pOB2tipM3AOEOrl99U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Marshall Midden <marshallmidden@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 12/16] cifs: prevent truncation from long to int in wait_for_free_credits
Date:   Wed,  8 Jul 2020 11:41:31 -0400
Message-Id: <20200708154135.3199907-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708154135.3199907-1-sashal@kernel.org>
References: <20200708154135.3199907-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 19e888678bac8c82206eb915eaf72741b2a2615c ]

The wait_event_... defines evaluate to long so we should not assign it an int as this may truncate
the value.

Reported-by: Marshall Midden <marshallmidden@gmail.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index fe1552cc8a0a7..eafc49de4d7f7 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -528,7 +528,7 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 		      const int timeout, const int flags,
 		      unsigned int *instance)
 {
-	int rc;
+	long rc;
 	int *credits;
 	int optype;
 	long int t;
-- 
2.25.1

