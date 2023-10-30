Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD231C4167B
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjJ3LAw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbjJ3LAu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:50 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA83DA2
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:47 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1cc394f4cdfso6749755ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663647; x=1699268447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qyP4YNE6Ns7yBrAVyG5IyRivauhL8xPwm1O+XM8Vg3I=;
        b=j0ZrNlKRYZBz7P3OR3RsyUOZx15g6gyCihQ/vMCY1iiSipSRzDPUhzTnnZlvApo6pW
         Vp2CC33u/xap8Aell9boGILZCv4P4GHj1gfLanwDylLUrbuABL/F31wJQTdqqt20aKWE
         V7mJ6jl4q4xMywMlnoJa3JjEyM3OV2UeCEz1mBkMhHvmSSd0dOzqllbtGTI0Lwx2IInk
         U5vB5P9wrt10qKR1QYU2HZyC5g25aAGg6FmmXGNaLGwgAobWWCAYSxcfc5DpDa7o4YaS
         HmVABaPAa46SnHpx1K8e4c+7qPPfmgP0WWiDiu6WNkkCcqN7ksIwic+pC8nTxp1N/PNT
         tTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663647; x=1699268447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qyP4YNE6Ns7yBrAVyG5IyRivauhL8xPwm1O+XM8Vg3I=;
        b=Fu3nre6HW5YgGkOrOtqWaXjqZ9sBqTVuQ7PnXNeMmVSeMT+8HpbRTPlPiRAXO6AUY4
         xhq6uZImAr0MOsuZkEoSeJlh1UtwtSW5j+WH1yM1ts2NXBlKxDF6YuW8cIcn2PuYZtgp
         4EdPpQolLW4Ja7kGeq0oZKaXmTLtzvnRVtqEAkvOQ1ONDXjDYnAm9+S/reENs+OeyRE1
         dhBSwldGS2nouAeO4cogt8Ha7dorW6koM7WGJYDljJxDA1M8spLwrs0lDnt5n/QeegvQ
         4O3VnEuXAiZO6BU+ZJ+UjOCFKmTb4KmTWhTkNBTVHv/U3KXyVTqaxUdTbZjNw+ZEeDtn
         eRdw==
X-Gm-Message-State: AOJu0YyerfdQVYhCpNU9JkIdFpH5jFco7ceJ5U/++GwbprvZogsKnFvC
        nyI3f2L5ovDIYYjH/IRGh1U=
X-Google-Smtp-Source: AGHT+IEybekkA1aC6fawp0wfMdfQL2ho3g0NSMKBtnx7YivgK5T/bbDCDDA6205JMs1Z30PN7iMdvQ==
X-Received: by 2002:a17:903:2387:b0:1cc:54fa:f15a with SMTP id v7-20020a170903238700b001cc54faf15amr935226plh.13.1698663647082;
        Mon, 30 Oct 2023 04:00:47 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:46 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 08/14] cifs: account for primary channel in the interface list
Date:   Mon, 30 Oct 2023 11:00:14 +0000
Message-Id: <20231030110020.45627-8-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

The refcounting of server interfaces should account
for the primary channel too. Although this is not
strictly necessary, doing so will account for the primary
channel in DebugData.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/sess.c    | 23 +++++++++++++++++++++++
 fs/smb/client/smb2ops.c |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index d009994f82cf..6843deed6119 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -332,6 +332,16 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 	/* then look for a new one */
 	list_for_each_entry(iface, &ses->iface_list, iface_head) {
+		if (!chan_index) {
+			/* if we're trying to get the updated iface for primary channel */
+			if (!cifs_match_ipaddr((struct sockaddr *) &server->dstaddr,
+					       (struct sockaddr *) &iface->sockaddr))
+				continue;
+
+			kref_get(&iface->refcount);
+			break;
+		}
+
 		/* do not mix rdma and non-rdma interfaces */
 		if (iface->rdma_capable != server->rdma)
 			continue;
@@ -358,6 +368,13 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 		cifs_dbg(FYI, "unable to find a suitable iface\n");
 	}
 
+	if (!chan_index && !iface) {
+		cifs_dbg(VFS, "unable to get the interface matching: %pIS\n",
+			 &server->dstaddr);
+		spin_unlock(&ses->iface_lock);
+		return 0;
+	}
+
 	/* now drop the ref to the current iface */
 	if (old_iface && iface) {
 		cifs_dbg(FYI, "replacing iface: %pIS with %pIS\n",
@@ -380,6 +397,12 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 			old_iface->weight_fulfilled--;
 
 		kref_put(&old_iface->refcount, release_iface);
+	} else if (!chan_index) {
+		/* special case: update interface for primary channel */
+		cifs_dbg(FYI, "referencing primary channel iface: %pIS\n",
+			 &iface->sockaddr);
+		iface->num_channels++;
+		iface->weight_fulfilled++;
 	} else {
 		WARN_ON(!iface);
 		cifs_dbg(FYI, "adding new iface: %pIS\n", &iface->sockaddr);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9aeecee6b91b..e7e1e0e5bdfe 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -756,6 +756,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	unsigned int ret_data_len = 0;
 	struct network_interface_info_ioctl_rsp *out_buf = NULL;
 	struct cifs_ses *ses = tcon->ses;
+	struct TCP_Server_Info *pserver;
 
 	/* do not query too frequently */
 	if (ses->iface_last_update &&
@@ -780,6 +781,11 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	if (rc)
 		goto out;
 
+	/* check if iface is still active */
+	pserver = ses->chans[0].server;
+	if (pserver && !cifs_chan_is_iface_active(ses, pserver))
+		cifs_chan_update_iface(ses, pserver);
+
 out:
 	kfree(out_buf);
 	return rc;
-- 
2.34.1

