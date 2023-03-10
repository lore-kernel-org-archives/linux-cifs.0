Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74945C64EC4
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjCJPpo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjCJPpZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:45:25 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5CEDFB65
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:34:01 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id x20-20020a17090a8a9400b00233ba727724so8091047pjn.1
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGeMs3KRVZUBuvHwNydHiKcPsFayYbJTGch1ZqheZKE=;
        b=j0CyXpx0E34kgfQO/Idd9R2jTNqzbR0DH7ooO77voiMIqXZDlmV9zKP8oAaFeOXS5a
         yTE1NL4C8n7uXES53+WWXwtqJiZtbbDl9eG9jgbyPAGyf7gFYLk3KEADhostRyGtTpBM
         QAVLsB/b5Kgd1X4214pQQ0ve1qBqnPbnX1hm51kEPF9ClOxH0EDcnXO0USbvgNqX7uMD
         Ej1hyXSj5osE4xDcNLpg4SnGDGMpoaSd8KxqXrEw+l3eIWtbvuSY/FoFJbMlTKO4/QIP
         8IIvMzkvjn8Z6C7uJ3STuwf7036y0IsGjLRuNaiMxhh/pxYd3AyLusmLqRgc3zF/5xZZ
         Xjxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wGeMs3KRVZUBuvHwNydHiKcPsFayYbJTGch1ZqheZKE=;
        b=5m9tr4vEynRKckFQHso1TpZpsPJM+ojuGUs4MpsH4iFOCo82brB2pcPfRcjN8WtSHc
         dSloBt9BCd0x/+/olXS/ZmP0jxpnD+TzHmhZQzT4WYtAqUUiWsbnUrJ5YQZj173Wc8h4
         GrgJZdLAzjZYPn3AaSAxPUMeBAkvDy/qtD+wt3R34NWU3tQomG8XHLq/vFiOAMcPpr9H
         fRksBsv4o7jbkdvhDisfGQnuFOy7DUJ/Wwn67pJI5FIg/sCVbWK1/lxAnieUAwX2Dt6F
         TiS60NB6CvMYz65GL90qCDl6eAu2+xhat8wHJ1Ln50TK0Nq9Qj4ncvNxV7GQFjrvynfM
         NF1w==
X-Gm-Message-State: AO0yUKXOFbSVGOxQ53xOH3n6u6maSNHBF8tgagOIG2kgpY9eLbETER9f
        VlUpj8A8zC1uCfIgSBfbf9E=
X-Google-Smtp-Source: AK7set8EIdIUmBGyF8n15fimd8ktaX6RXFAFhddVlH0R2Y7b55bjBXECxfNnQY0fNp+n2v3GrIM2TQ==
X-Received: by 2002:a17:90b:1b0f:b0:237:c18d:c459 with SMTP id nu15-20020a17090b1b0f00b00237c18dc459mr26357717pjb.31.1678462440621;
        Fri, 10 Mar 2023 07:34:00 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:34:00 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 11/11] cifs: empty interface list when server doesn't support query interfaces
Date:   Fri, 10 Mar 2023 15:32:10 +0000
Message-Id: <20230310153211.10982-11-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When querying server interfaces returns -EOPNOTSUPP,
clear the list of interfaces. Assumption is that multichannel
would be disabled too.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c7a8a6049291..9ca55038b3db 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -763,7 +763,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	if (rc == -EOPNOTSUPP) {
 		cifs_dbg(FYI,
 			 "server does not support query network interfaces\n");
-		goto out;
+		ret_data_len = 0;
 	} else if (rc != 0) {
 		cifs_tcon_dbg(VFS, "error %d on ioctl to get interface list\n", rc);
 		goto out;
-- 
2.34.1

