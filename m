Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD853C64EC4
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjCJPpZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjCJPpC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:45:02 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A525CED8
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:37 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id y11so5991293plg.1
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+6vTuiCZpQhEVKc5XBHRnV2OTCH3JI7IcoWG9ZhjUWk=;
        b=YauIzQiB9w9BWFpMYjZrmcTwBhWBxYEir7qi7Fl82ZA6NlyPq6g/t9MtWCdbsLDGSu
         3M+Hn5ikFVTh7UK/uiRdq7XLpiWHKKo53Fytk4JeKBhRosiye0y669HEkDty6rutWMx7
         Eqr6AFbm1Czom0YnWbKMU3LYpChegPuOkrtGurWvrLWBpP+1ty4ZIKi9XyYBcNYMVIeP
         wkWi1zvPMtPlXnfaj7QSq53Qa0Z0HZd4DFxe+AJK3eVN+DRwrvCksugSkX56qlFWM/I2
         H0O8pZzeeHxyO36Y86beM2M9lOvc2YHFKbfLisRgXDdq3K6ESuNU5zkduliJiwzSm3HF
         bsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+6vTuiCZpQhEVKc5XBHRnV2OTCH3JI7IcoWG9ZhjUWk=;
        b=cKzmwxQ9nH9RJciEIfX4BYNek74i8QkmHL2Zd+dmyqSIPfw4Bj46DOCNCvXJ5UxPTL
         He7TrUGxR03lJQajtiD6F8jEWDRl9sz7oHH6PT3YyALOruoCowXLgbroYJS4j1G2KAp+
         PwXLyYbivAJ+ozP6URW1CDAfktrkP6awQpiEPzitwQCdp25W8CtH/5uRFI/69itk406t
         nLn3P26X8S2BCQPs4ueAmvGqfF0BIik9cIg+8NneYO0KfntPkW9xcAuFo2tZ0gI44We3
         ZZSJdfYyL5nK2Vq+Be+TRBAI993kN3zWBnZtocU+gVvIq+rhuEm0x6BTAaBIYa2Kh8+K
         OZAQ==
X-Gm-Message-State: AO0yUKUVqfkoVTW2VwrOJSlbeBloasQi6lyxKV48Mpj6A1SVsu0gVn8/
        2kEG8sV/UaWHY3Ic2dZkXpE=
X-Google-Smtp-Source: AK7set8ocGNtxevuwIaEb7sWALbptS179xQc0QAfWreVRe6Dcyeij/PoTAyRw+DS/Scy7aWanOwmkw==
X-Received: by 2002:a17:90b:1c05:b0:23a:ccb4:64de with SMTP id oc5-20020a17090b1c0500b0023accb464demr2361716pjb.6.1678462417058;
        Fri, 10 Mar 2023 07:33:37 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:33:36 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 07/11] cifs: do not poll server interfaces too regularly
Date:   Fri, 10 Mar 2023 15:32:06 +0000
Message-Id: <20230310153211.10982-7-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We have the server interface list hanging off the tcon
structure today for reasons unknown. So each tcon which is
connected to a file server can query them separately,
which is really unnecessary. To avoid this, in the query
function, we will check the time of last update of the
interface list, and avoid querying the server if it is
within a certain range.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/smb2ops.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0627d5e38236..c342a1db33ed 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -567,6 +567,14 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
+	/* do not query too frequently, this time with lock held */
+	if (ses->iface_last_update &&
+	    time_before(jiffies, ses->iface_last_update +
+			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
+		spin_unlock(&ses->iface_lock);
+		return 0;
+	}
+
 	/*
 	 * Go through iface_list and do kref_put to remove
 	 * any unused ifaces. ifaces in use will be removed
@@ -733,6 +741,12 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	struct network_interface_info_ioctl_rsp *out_buf = NULL;
 	struct cifs_ses *ses = tcon->ses;
 
+	/* do not query too frequently */
+	if (ses->iface_last_update &&
+	    time_before(jiffies, ses->iface_last_update +
+			(SMB_INTERFACE_POLL_INTERVAL * HZ)))
+		return 0;
+
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
 			NULL /* no data input */, 0 /* no data input */,
-- 
2.34.1

