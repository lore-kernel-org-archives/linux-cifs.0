Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B904DC6FA99
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbjCJPpE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbjCJPor (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:44:47 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E649A10402
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:00 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id fr5-20020a17090ae2c500b0023af8a036d2so9410610pjb.5
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/C3AmKiDkvvGubOr3K4XsqgrnjzuSUzEVK44KJ9VBKY=;
        b=o/azjl7Aslqk2a5zOKiG5jF/XrNcKQossZiQPa2EkAkfFUYvmssTQD5FAWLMxh12yB
         zxNWwdq3CMcSK3YnWCYzLflax6ZusoP/yV5CmEFDqpifGyP0y9riXxDeHoSMMdjji7BS
         IhTfOPyGMVV7g804xJ/JA8u72/EE/W7Yq2cSpxGKuAbrVzPm7i5olh6fmUltWHjlNTXI
         ekK0p2zxhQius2WpVR0DoLtdKDaCqyXX5gt8BQLHQAmCwN3V5SpBgCvxKdG+wWPRtaNE
         Hjk0KpLuWRP4+tUHHQxEUNvqIhzbZDuhGHbZl8PC3aDS+lRW7R0LsdbePaPXcPAlQSnh
         b7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/C3AmKiDkvvGubOr3K4XsqgrnjzuSUzEVK44KJ9VBKY=;
        b=JvXG1AcC7eYnwyf/VFLNCPvrlbHNak6LcErjgiAHHHE5SSDxqIMiDjiR6sMFmxMgdb
         kvlgonkjD/EiReqoHIohKPMWN43263OTFhSFLXcQiZ4SxwcmVXCmZRVkF8hpR1ChNX5k
         8FoatzGlTu2BkuR3Rj1qAiyHOFaoYd948PK5C547pFTZpd/waANdD+kzwF9u6bZv+1nE
         7is2ustCEB/ZYW8Qyy3d0K/lXswDyFfhH+07+T8ZyEwaz56Y8qmdcJnwNd7aQVlTS5TL
         uI8QlKdWqVk783xDjhrC3oQtBbzP1DdNFPMBA3y5kaw2WWgfiRL5J4lUyj8JkZl8+vGj
         KmTg==
X-Gm-Message-State: AO0yUKWFXsqKLpt7HXu+xCh0XLjfPfaXyQS0cesl+Rny0anil8ftSN/V
        EsRkYBQlcQ4NBPM91JTMuwY=
X-Google-Smtp-Source: AK7set9oVc2qdyIPY6C1mZgaaBgczxnd7c8e3XpxJAGG4uaIRnJ2l99FoFlyUdYrOucMu/d5A5N0vA==
X-Received: by 2002:a17:90b:3b49:b0:237:d59d:5f89 with SMTP id ot9-20020a17090b3b4900b00237d59d5f89mr28362657pjb.4.1678462379954;
        Fri, 10 Mar 2023 07:32:59 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:32:59 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 02/11] cifs: generate signkey for the channel that's reconnecting
Date:   Fri, 10 Mar 2023 15:32:01 +0000
Message-Id: <20230310153211.10982-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Before my changes to how multichannel reconnects work, the
primary channel was always used to do a non-binding session
setup. With my changes, that is not the case anymore.
Missed this place where channel at index 0 was forcibly
updated with the signing key.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/smb2transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 381babc1212c..d827b7547ffa 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -425,7 +425,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
 
 		/* safe to access primary channel, since it will never go away */
 		spin_lock(&ses->chan_lock);
-		memcpy(ses->chans[0].signkey, ses->smb3signingkey,
+		memcpy(ses->chans[chan_index].signkey, ses->smb3signingkey,
 		       SMB3_SIGN_KEY_SIZE);
 		spin_unlock(&ses->chan_lock);
 
-- 
2.34.1

