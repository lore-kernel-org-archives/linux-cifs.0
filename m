Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71ABC4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbjJ3LAl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjJ3LAj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:39 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253DA8E
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1cc58219376so2982365ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663636; x=1699268436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TSCBoTpZQNnQSt2SvBhlDPv2smh1rFdBZGtA8T/SKTk=;
        b=GfOtue1nHbXMfjUtLq4oTR0CU8LqPQw7ON6BCdSlhQHlROty/c94Hg12fpai7riFXp
         gO2xJHXnAhUct0tnD8GV5A0A2uaihY9SRmmQ4SngmxtzIk5DaajGr+PxI/P9WBY8zSRT
         jkJJGAwBCKB7JNn3+8RUMOwxtO7gwLQWCHO10NV7dHsC/KCPhOcwtccCNPvLsLQJEOEC
         Ue12+746hsR+Wdw+rbjpdMcZKOVqFQiiCUvCe0m/khsDG8xTVQK3zfYMeBfWD1wZ1Q85
         0Wzym96tSqgw5x+Vx0m4sn25ADXLnZjmBo1YYcYKIJpjflTFHnxBt6EHakJeXiR+IaxV
         sXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663636; x=1699268436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TSCBoTpZQNnQSt2SvBhlDPv2smh1rFdBZGtA8T/SKTk=;
        b=Vjeuf9zIyp8x+gJgOIAzdrpxT7CLQXT4ovzYgGibFoqN1bXMOeY0yGHUEu4IQLtJyI
         ELnXFSfojaNajc8TglK8It/0NTBqTMTnPSMmumnCPyFl00dj0dQdn1vIPmcBca270kw4
         +ozTS6FsTOmT7j8APqSb7X+6up29Ak0AoZfjt3XRqm4fxLs6zhhZfQ5UIhFBnQz54csu
         ISKq2ZZBUDC5RyKp820HFxIe1XgltCpiFODCctzy7Edr92fWYiHe9sehhczhqFDGjnPP
         p9ciqooh7KsnAAi00EdQGJG2qqGfwok7GXND3KFvDzkJcHLPboPPXG/dqwcEozFUDKv6
         7bVg==
X-Gm-Message-State: AOJu0Yzow1qnP/zHsMaLmz+m2Zim6CTAmq1QEW89UzGARGbw/sGxnvR1
        xtuJf9I6RqnLSkgQEbtuD80=
X-Google-Smtp-Source: AGHT+IGXR4BtS6R+ESnLf/pIU1OZuXwKIghFE/tnM5aKJsiHsK9UDSRbAZddtzDdgu5pdUkVyZmlXg==
X-Received: by 2002:a17:902:f301:b0:1cc:31a8:d733 with SMTP id c1-20020a170902f30100b001cc31a8d733mr4895644ple.44.1698663636571;
        Mon, 30 Oct 2023 04:00:36 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:36 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 04/14] cifs: do not reset chan_max if multichannel is not supported at mount
Date:   Mon, 30 Oct 2023 11:00:10 +0000
Message-Id: <20231030110020.45627-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

If the mount command has specified multichannel as a mount option,
but multichannel is found to be unsupported by the server at the time
of mount, we set chan_max to 1. Which means that the user needs to
remount the share if the server starts supporting multichannel.

This change removes this reset. What it means is that if the user
specified multichannel or max_channels during mount, and at this
time, multichannel is not supported, but the server starts supporting
it at a later point, the client will be capable of scaling out the
number of channels.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/sess.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 79f26c560edf..c899b05c92f7 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -186,7 +186,6 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	}
 
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
-		ses->chan_max = 1;
 		spin_unlock(&ses->chan_lock);
 		cifs_server_dbg(VFS, "no multichannel support\n");
 		return 0;
-- 
2.34.1

