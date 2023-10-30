Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF24DC4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjJ3LAf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjJ3LAe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:34 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F5E8E
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:32 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-5a1d89ff4b9so2250427a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663631; x=1699268431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9XWfUK1gR7L2c5oJtv73DgD0wDa60KgbGGhbOtXmB8=;
        b=c6hYP+iQxyE+FDHVHeef7k/Ld/8AgqrMmIoSCP52FBwGXSNfUJYv+y/7ovrFPHmzKN
         ZGPG6/ZVr2khKns71AD2xv/PMHr+xrrWBvfYeE9cibiNuU/OsvxIGHU/eKSEaXrdQ7SG
         S99WpE4Kgh8BHf/fITzYxoYdhZIo0LMsSsgvoU7Gfcu2I0XFECPKzYOsjm5LNK6xJETY
         TiCg1LcVDOaPN1C6EoQ6cFRYwWbsY4ow8g2tBrEe7kIOSisE1y1TUWhP7LPgc4CZeZoG
         lt8DHhWcuCMC914zG2pFKM6/H4NSgl56E5OLhuYI3+M4bsyFHg0Dy58ckn+uWyophCUi
         hWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663631; x=1699268431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9XWfUK1gR7L2c5oJtv73DgD0wDa60KgbGGhbOtXmB8=;
        b=XcCfs7ucR4Zpuy5mB767MpTQvLupoOEBlpsAQl5Z/eBpBMRAoxqabvLO/+rWyIimQW
         fT8/zuu2K2Ju0CtSy6N7eRKtodPAY6chDoSa3IDk68BBXdN7C8Qwktq24aqxbBCQ6fDO
         qqbz1VKVgHWdTGsZp2PorIQi0KiFMJU8NyW1tW3DdjB5J232VLpwZ/C3ziktMO8Bk/wn
         UJviksz7sPcvkogid0TmiKhv9KwDUYgB7VshD7UCpYmN0cmMXNRPMDjN83RKjRJQcGx4
         bcrGf4yWXnsY/1cLFvjReuQujVx2PbpXPiYbMcaWQxa1MUyqLRbPXtG17UWvLUGwUlnH
         bAsQ==
X-Gm-Message-State: AOJu0YwJ36tKooa/tX5SGlC3BLU+481YuciXv5NYMaQqO9YPEuA7kYMm
        uP5S2E2Hd+dzzXGATTTUI2I=
X-Google-Smtp-Source: AGHT+IE8Q1W1QsdH3AnX9GJ/AmE62fuEgrZ24AWwizPGZHAp/DF/6/ORrQHx6yQ22opMzZHKls3cPg==
X-Received: by 2002:a05:6a21:780a:b0:17b:4c98:840d with SMTP id be10-20020a056a21780a00b0017b4c98840dmr6805811pzc.51.1698663631222;
        Mon, 30 Oct 2023 04:00:31 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:30 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 02/14] cifs: add xid to query server interface call
Date:   Mon, 30 Oct 2023 11:00:08 +0000
Message-Id: <20231030110020.45627-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

We were passing 0 as the xid for the call to query
server interfaces. This is not great for debugging.
This change adds a real xid.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 7b923e36501b..15a1c86482ed 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -119,6 +119,7 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 static void smb2_query_server_interfaces(struct work_struct *work)
 {
 	int rc;
+	int xid;
 	struct cifs_tcon *tcon = container_of(work,
 					struct cifs_tcon,
 					query_interfaces.work);
@@ -126,7 +127,10 @@ static void smb2_query_server_interfaces(struct work_struct *work)
 	/*
 	 * query server network interfaces, in case they change
 	 */
-	rc = SMB3_request_interfaces(0, tcon, false);
+	xid = get_xid();
+	rc = SMB3_request_interfaces(xid, tcon, false);
+	free_xid(xid);
+
 	if (rc) {
 		cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
 				__func__, rc);
-- 
2.34.1

