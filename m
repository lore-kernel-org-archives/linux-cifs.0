Return-Path: <SRS0=6r7N=3F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD76C33CB6
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 18:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A03C720730
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 18:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579198740;
	bh=RHts6TZLuIo0/HW1Ip3FqLUieOiVD/q8uDmfYAJqYhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eHcxXSwVa0sPWl8Di7LCdMrFV6yuVEaMMyZ1A/neOSiTpilfatBG33SpY9H0SDBDI
	 mF0yG8CJuub7OZobUXUf/gHIkVsYC6ijf+lrK9WSUYsyavE/vzAwT3xr1sRWw0xkji
	 lNrBmI2AVKOe5NkrpXwvkx6g0j+5rr6OF5DLcbSg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgAPSS7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 13:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732838AbgAPR2j (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA94246FC;
        Thu, 16 Jan 2020 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195719;
        bh=RHts6TZLuIo0/HW1Ip3FqLUieOiVD/q8uDmfYAJqYhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2Bb0rKhVfAQjNe3+9KYOVmbW9YrFLloh1rYtJrZtQWvvnyn74xH27prvoO4L9xOQ
         rhgSOrvkM0JtP7qNosvVUlSOKjIbYttqPqBfJ6IptY92QrjpLzZJj0FUWTtMB/5M48
         ZMhxZqVi89m6G5KB6YjxVymbFhJL07PQsXlykAT0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 262/371] cifs: fix rmmod regression in cifs.ko caused by force_sig changes
Date:   Thu, 16 Jan 2020 12:22:14 -0500
Message-Id: <20200116172403.18149-205-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 247bc9470b1eeefc7b58cdf2c39f2866ba651509 ]

Fixes: 72abe3bcf091 ("signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig")

The global change from force_sig caused module unloading of cifs.ko
to fail (since the cifsd process could not be killed, "rmmod cifs"
now would always fail)

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 51bbb1c0b71a..ed4a0352ea90 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -921,6 +921,7 @@ cifs_demultiplex_thread(void *p)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
 
 	set_freezable();
+	allow_signal(SIGKILL);
 	while (server->tcpStatus != CifsExiting) {
 		if (try_to_freeze())
 			continue;
-- 
2.20.1

