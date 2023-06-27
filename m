Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9316CEB64D9
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 12:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjF0MKW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 08:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbjF0MKO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 08:10:14 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0AB2976
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 05:09:52 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-517bdc9e81dso1524847a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 05:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687867791; x=1690459791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qZUCqgR69njopp+9FFA0BTmwbtbH9XZoF4se0bEvIBQ=;
        b=LujkmDJW0xBQcc/MRcCBcCm8JvtRR8n9Akwm55VKkyfOkAidukQ5eOcpu0GafiSuel
         tChohBokKYn8O0hTK9p7bEx9GM6pOPqY+Su6gL2axG3d3THE326VGQTvihGcNfXaX7dP
         KTRIVm+zCIQBkxK+5qrHgxMhZbiLEeupJ5dJKbRx7tsfBLuVwZ8144W00d3teLU53xZK
         DVCtICjn263EYFKaI5SfkrmvD65ki4Ptm07r8KwErwiViXBDyajgmts9oha9QL+EuMA7
         vWQAFaOtwHoLMFwYm6kkwuqxk9l7pkBY72YqbjaMAaOt8SGnb7VHMs+ODTw2qn5mfEWr
         XLtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687867791; x=1690459791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qZUCqgR69njopp+9FFA0BTmwbtbH9XZoF4se0bEvIBQ=;
        b=PG0qKR+yP4MBIlExEsV2mxDKoReCXc0hzHVr7p7M4jI6ViAt6wEI5DJweBZUky73oN
         DXm8RUaqMQ9fc5+1xwmn1F7lsNXD51QyApkI9ZCOcSB6ghGrydty3xu6T2y2uWSN1Vuu
         6VMsU6QOWdNjgvMV6eKJgcyUd6bZn04Qck1LEqrWtR4lmJfXtE76yB3W85gmu0ATRjEI
         NjQzmr6mJl3OsDQwRF5SzXmOQJU7cfFX5MmmkfjT22z3Zg3LWhMHjXhOr2cNcVaf8kCn
         OPlagrmDtKXK/XWyRD4rvkqMcDwBsW3PNtBD4uIFwEAZgEzucM7tL+bX/+ySuqXOerj9
         DnYw==
X-Gm-Message-State: AC+VfDznxYJvjSwPO4w4D1Yw7GmKioGVHeJigMOB6YB99xev42AqMu8l
        oY6FJdBsdXKCVyDGb/TPHtov/fJdMkySNtMP
X-Google-Smtp-Source: ACHHUZ7Z4aYysY95bxduGdvbXaW0Q9UazRmRpkKSWHtyoAH91S5y9WXld2IaABjx+1++3pskVX6ZfQ==
X-Received: by 2002:a17:902:9f8e:b0:1b8:21f:bcc2 with SMTP id g14-20020a1709029f8e00b001b8021fbcc2mr5293292plq.34.1687867790966;
        Tue, 27 Jun 2023 05:09:50 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id jj11-20020a170903048b00b001b80e07989csm2885755plb.200.2023.06.27.05.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 05:09:50 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        pc@cjr.nz, ematsumiya@suse.de, bharathsm.hsk@gmail.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH] cifs: print client_guid in DebugData
Date:   Tue, 27 Jun 2023 12:09:43 +0000
Message-Id: <20230627120943.16688-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Having the ClientGUID info makes it easier to debug
issues related to a client on a server that serves a
number of clients.

This change prints the ClientGUID in DebugData.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 079c1df09172..f5af080ac100 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -347,6 +347,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		spin_lock(&server->srv_lock);
 		if (server->hostname)
 			seq_printf(m, "Hostname: %s ", server->hostname);
+		seq_printf(m, "\nClientGUID: %pUL", server->client_guid);
 		spin_unlock(&server->srv_lock);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 		if (!server->rdma)
-- 
2.34.1

