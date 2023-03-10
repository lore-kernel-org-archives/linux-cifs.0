Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41956C64EC4
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjCJPpe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbjCJPpN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:45:13 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E78DD366
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:48 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p6so6020758plf.0
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QN0KP2zyMGxDCWsrNdRZt2+TYPTgrOVoV6GG9EHRPOA=;
        b=Ek6w2SlPTnXAz+vr7dOjxPvdfME/eQE7vOjIL8rw9mUEguduBvVna2Wi9RitUMuJ8o
         4FiMwLrZD4ZWBUIsZuyCgVSzFrfB3Fo9TIzJ8x9inmbzJHXyZgsQJYA02L5oONNvmOjU
         GZPujdS1VE4BmRVRml000NQ1A4Q7BGa87ITt7GYOmeXsxLQdZIxJKYVa1dVtqit8vULA
         IgQjPQ8OYGiuXuYMjDoCSBVw8DDtkOo4cLJMeVDR9QRBxyOvGbq0mz7HnqU28JDOKfiC
         XXJSlcyCyk9Fy8QvsFYTNzfRdmkNDLUDljvGUTuBx2CopLD8O8U4HAHQ6YFECuYQUCtH
         asCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QN0KP2zyMGxDCWsrNdRZt2+TYPTgrOVoV6GG9EHRPOA=;
        b=hpQQ9gtczwAfJeRPnngARVbW6+Lq5Vx7p9LAxFJkeRulyZtcPTqs1wxybGl+cL1nSz
         HWX7h1XkdEeHRBGqgUI7LDvtBnzPwQ0uj+ILYou1Mzg/bnudpfQlWBhT8SeHOYdMO0Co
         fflKICOJThabHiVTowxbyQDjCw5JNBZQnrFuwU35apdcX2bBSVGNmCXv7Nnl7aeimfj7
         FEmQMsmDYd3Ik9bNUaqzgczuo6wuaxuz8AXHm+EJYJ6HrsOZ3twwk4T0plebn/uMUsFF
         Rro4Sv5afwCOI8FHOMkc5TjU1A708MoObpKRn5aEG63ItA8TEYDq/uqdOsrBqbMZa9Sv
         xBhQ==
X-Gm-Message-State: AO0yUKXSYyVLqnqMD8MSYIRRVwLRPrtk47AiaXhZ0EwRgc1b+By2FWvF
        cYFn8jcYohDVkr/8aVDmtKw=
X-Google-Smtp-Source: AK7set/A6JPZUWACvdLNibROURBMOOgYwOhTAktb7wwypeTsoaKSnACALp4oZlTHf/ejPIe/IvFLVQ==
X-Received: by 2002:a17:90b:1e0f:b0:237:c209:5b14 with SMTP id pg15-20020a17090b1e0f00b00237c2095b14mr5677989pjb.22.1678462427695;
        Fri, 10 Mar 2023 07:33:47 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:33:47 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 09/11] cifs: account for primary channel in the interface list
Date:   Fri, 10 Mar 2023 15:32:08 +0000
Message-Id: <20230310153211.10982-9-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The refcounting of server interfaces should account
for the primary channel too. Although this is not
strictly necessary, doing so will account for the primary
channel in DebugData.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/sess.c    | 40 +++++++++++++++++++++++++++++++++++-----
 fs/cifs/smb2ops.c |  6 ++++++
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 78a7cfa75e91..9b51b2309e9c 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -291,11 +291,6 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
-	if (!chan_index) {
-		spin_unlock(&ses->chan_lock);
-		return 0;
-	}
-
 	if (ses->chans[chan_index].iface) {
 		old_iface = ses->chans[chan_index].iface;
 		if (old_iface->is_active) {
@@ -318,6 +313,16 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
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
@@ -344,16 +349,41 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
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
 			 &old_iface->sockaddr,
 			 &iface->sockaddr);
+
+		old_iface->num_channels--;
+		if (--old_iface->weight_fulfilled < 0)
+			old_iface->weight_fulfilled = 0;
+		iface->num_channels++;
+		iface->weight_fulfilled++;
+
 		kref_put(&old_iface->refcount, release_iface);
 	} else if (old_iface) {
 		cifs_dbg(FYI, "releasing ref to iface: %pIS\n",
 			 &old_iface->sockaddr);
+
+		old_iface->num_channels--;
+		if (--old_iface->weight_fulfilled < 0)
+			old_iface->weight_fulfilled = 0;
+
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
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c342a1db33ed..a5e53cb1ac49 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -740,6 +740,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	unsigned int ret_data_len = 0;
 	struct network_interface_info_ioctl_rsp *out_buf = NULL;
 	struct cifs_ses *ses = tcon->ses;
+	struct TCP_Server_Info *pserver;
 
 	/* do not query too frequently */
 	if (ses->iface_last_update &&
@@ -764,6 +765,11 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
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

