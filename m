Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B84C7EE22
	for <linux-cifs@archiver.kernel.org>; Wed,  3 May 2023 22:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjECWVz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 May 2023 18:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjECWVy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 May 2023 18:21:54 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFD18A7E
        for <linux-cifs@vger.kernel.org>; Wed,  3 May 2023 15:21:53 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jPvQ89mKtQVhXNu4PeLmuaUsl7Gms2IweZvA/FA8NkQ=;
        b=MJAKPXNdVzUGHCC1aVgJAR8JQLwAA5/Z4uBo11vDowKEUcNJVtdnf1ycBmkZ3mSHiKwgh8
        V79YaZMAgoAs15lVFBBzQ9AJamXlo1hBxVpwTeO3RkMecT7ETO1//RtdwfqzJqmWmA84MY
        whRmXoIpA2+RjWYVB57cuKV54frA8OhBUh3GXL8ySulnYcPCLWyUsui/VaSCtAODEYyycM
        EodiQpzOToVPRDVp7W/xc79f/gymIlu9yBAj17FdxGI89aCBlwopMtJkiz+e/55ju901cZ
        7VH9ypUfSQbOjSvbsFMscLapLWRHzx+BafWKMXyfPdMwnszi1qQXoAMyRGIhxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jPvQ89mKtQVhXNu4PeLmuaUsl7Gms2IweZvA/FA8NkQ=;
        b=HWkcjK2ThzOZKhHLQvV3YF5mIAsFn+3sfSnb4ruddEzp7IL6FMqjTSq4NtNqO5Q5zh5mFH
        Y2BCswt+dfLW4AlQCf4vDw4wpwxQTfyGWXlq5lHZRn5HrPNeRg2qlpEopqIQ96ZH65fhLp
        8qV00/wc72tan0XYdsOx4AaadrCXz4P+ZEDdI2IKWV60U0W+m00diW60dAR5Fj5Gi5c5A+
        Lt4rkcbfjcmdjPJw1yrV79FMebNVLH3DNf9nD49iqwMI+zRDGJxNdkUDdPN66aSdv110+7
        Yp/5IjZeWc+Ju93qvXXUppDCfKmml7aE4QprkU4f7SYjGcFh9MxVIe92MhchEA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1683152512; a=rsa-sha256;
        cv=none;
        b=nWM2KJVhjDRP56+iE7l8WnOLZQoYliJ6TwfSgLk0jFoIda3smIOcl158bPmfTa1lEiOoc1
        UE9ie+VBIfxseGFHYyogkJmh2XTuVC/3DJ3MS5T/kvd1IvOOVJ/L9Dscib/9o77zY7ZKnF
        eNZYVa/sTRRu/kr1/kqTzXtVqqbP4MCOZv78UBFUtLISBFd0Z4lxuWtD/Nfmy9HEHR0qBW
        yoA+o10WEPyFqIhrweO7xWZZMUk3DfxfY3BrAAVpDQk7PRFVoqvZcU2NCrksE2XbFRtEs3
        JrZLtn5kPpMaF6UYhdCZA4kMyl1lWu47dJjREpG+vndHfdZV7fBXuFaJSQER+w==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 5/7] cifs: print smb3_fs_context::source when mounting
Date:   Wed,  3 May 2023 19:21:15 -0300
Message-Id: <20230503222117.7609-6-pc@manguebit.com>
In-Reply-To: <20230503222117.7609-1-pc@manguebit.com>
References: <20230503222117.7609-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Print full device name (UNC + optional prefix) from @old_ctx->source
when printing info about mount.

Before patch

  mount.cifs //srv/share/dir /mnt -o ...
  dmesg
  ...
  CIFS: Attempting to mount \\srv\share

After patch

  mount.cifs //srv/share/dir /mnt -o ...
  dmesg
  ...
  CIFS: Attempting to mount //srv/share/dir

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifsfs.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ac9034fce409..32f7c81a7b89 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -874,14 +874,12 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	struct cifs_mnt_data mnt_data;
 	struct dentry *root;
 
-	/*
-	 * Prints in Kernel / CIFS log the attempted mount operation
-	 *	If CIFS_DEBUG && cifs_FYI
-	 */
-	if (cifsFYI)
-		cifs_dbg(FYI, "Devname: %s flags: %d\n", old_ctx->UNC, flags);
-	else
-		cifs_info("Attempting to mount %s\n", old_ctx->UNC);
+	if (cifsFYI) {
+		cifs_dbg(FYI, "%s: devname=%s flags=0x%x\n", __func__,
+			 old_ctx->source, flags);
+	} else {
+		cifs_info("Attempting to mount %s\n", old_ctx->source);
+	}
 
 	cifs_sb = kzalloc(sizeof(struct cifs_sb_info), GFP_KERNEL);
 	if (cifs_sb == NULL) {
-- 
2.40.1

