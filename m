Return-Path: <SRS0=SV7R=YL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA60CA9EA0
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Oct 2019 22:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07DF721852
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Oct 2019 22:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571437125;
	bh=IlBkFwGUgAC2Wa9c3vMk16ObPVRv9tfoUaey65R1+pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Qmj/uKE8RyWj5DmQVEnoTq99ipjX3wUspC5s/bg/jknix2LBuPADf7Tj6pfeNk6uy
	 5fA4p0nRA9cCBDYF/EhBSWE3DXZvqryR19wMX8rtUaSAI+dFo8k80k0+o+ILLJuHq+
	 J1hpM0HPaXOBbGoQLN8mV27ivpPZBr/XIzkH5JUk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfJRWSi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Oct 2019 18:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732555AbfJRWHM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 18 Oct 2019 18:07:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84588222D2;
        Fri, 18 Oct 2019 22:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436432;
        bh=IlBkFwGUgAC2Wa9c3vMk16ObPVRv9tfoUaey65R1+pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1YDzOZ0AAuFq7Ztu47evBP4cvm+Xtzu6/jtBYCpboR7WtqbtCCK3bLHpCnGRyVPl
         vrK4l+sbJbkShXmdeieD3eH33bISdAnjVpDe5wSderWcuMIlvTqwAaiHKk/7J0pUSA
         ezSA4nIIJ1G5AO4YTTinWdOrBqimUz33m3l6elgk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 073/100] fs: cifs: mute -Wunused-const-variable message
Date:   Fri, 18 Oct 2019 18:04:58 -0400
Message-Id: <20191018220525.9042-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
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
index fdd908e4a26b3..66c10121a6eae 100644
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

