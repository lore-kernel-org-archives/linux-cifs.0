Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE2EC74A5B
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 20:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjC2UOr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjC2UOq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 16:14:46 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498B930C7
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:14:45 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680120884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VvcK8pPKGoMb+e/vJ530ayb6XTxEW5G8XyoQ83G4DZA=;
        b=fyfElq5OBbtu7HIv2q0rN7jVnWaAKS3Pmh4SYCk2d50o5mtqq0LjdJVQWbX/lDa12LvCWw
        0SdotpVGYKnDhGvlWM7NXjGAKfjMF3TcjLd5KaFmn8VLT/ujkKSsFfOdrs6/7pFXEGBzFI
        /1NTwJ/kA/GFRv8Pj7v8mGcQcUKp6IInjf6VN9zt5SfwcrUomWLF7insWwy8OB819U1n7U
        nqHW4hGu9YkI09qWFvxd5k0PfxCaQIYjFhul8qoxaW8SZSZXvMWU50dJTQZoGc9XgWaT1x
        UNTgD/1KaaUk0PHseHhlZUlHuy6kRBLRcUP/sFK1p1ie+dgIo8Q6l+aHed9nDg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1680120884; a=rsa-sha256;
        cv=none;
        b=rvnu4FrxUfJRTYeEUu5DB8WncX7R2U5LgbXeZseDKv00eT/1aHYoVaIUj23KWJNiPNiHDj
        vG+qMUvXs9jGHW6OAHFgZTxVlVv5LJbKfcJR89qovqPi9307iRgBJMNETZzl4VxbzaIsu/
        4KsF6FwdVZt09bmYCm3T8BpeHd6V7kf12q/fRlJ19XIGGdHHsT0Gg4hZbHp98444cyEozi
        EFkwR1sFJZ/C87Xw6u+FZBqZe+W4iLKZYGUGnC+XQPeLUUKB8EhJ4D/7GLPSJ4T0G0C44X
        +EyayzERRWrVQd2HFHGv2qtzD/lS8uT7VlQSZGwgMy+Jm2aB8Hv9jxMQAxlcfw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680120884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VvcK8pPKGoMb+e/vJ530ayb6XTxEW5G8XyoQ83G4DZA=;
        b=kpEyYBdNfnW+Ry2nZG27vKxAZv0uJHh3FA91WRM51QUhl84f8J2u7IQAKneE5L0YBdO5BZ
        Ah1ybZ7IZXNdtwmkuhBRCIYJRG66ZfsvYA0cFgu16ZGmJZ8DFOqKvUivLPYzAYOL8NyHY5
        uIDlaerdKicEl2qeoXTLipNiI++5tSm5DMw12Kupn4lP1HQNmO5xETVou+5zniUTPoeylq
        MAk8yFEg2BYxr2l2oSrjffN1Q+sRqc5dHv3UY2Ctgj8uhd85S4xibIGcVdj6DPq6RNceT7
        6rSj71cXo5GsGNThr+3bEpsvz1nrKuJXYy6vYrZZCWEi1nzQa+2hfJVP4C+zRg==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 4/5] cifs: prevent infinite recursion in CIFSGetDFSRefer()
Date:   Wed, 29 Mar 2023 17:14:22 -0300
Message-Id: <20230329201423.32134-4-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-1-pc@manguebit.com>
References: <20230329201423.32134-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can't call smb_init() in CIFSGetDFSRefer() as cifs_reconnect_tcon()
may end up calling CIFSGetDFSRefer() again to get new DFS referrals
and thus causing an infinite recursion.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifssmb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c9d57ba84be4..0d30b17494e4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4382,8 +4382,13 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 		return -ENODEV;
 
 getDFSRetry:
-	rc = smb_init(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc, (void **) &pSMB,
-		      (void **) &pSMBr);
+	/*
+	 * Use smb_init_no_reconnect() instead of smb_init() as
+	 * CIFSGetDFSRefer() may be called from cifs_reconnect_tcon() and thus
+	 * causing an infinite recursion.
+	 */
+	rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc,
+				   (void **)&pSMB, (void **)&pSMBr);
 	if (rc)
 		return rc;
 
-- 
2.40.0

