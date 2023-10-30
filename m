Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C71C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjJ3LAb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjJ3LAb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:31 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FEAB3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:29 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1cc2f17ab26so12394695ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663628; x=1699268428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JfBQ0kZpS0waR4OSRDMf+jgERxVRLh5PmV9Xsh8YXgc=;
        b=WCXrSsi+JTzwDGFir365W/QzP1Ai7dmplKDWmvj6akG3Y40Bq2cW0x4eeF/hbCPwfy
         2ub/K9yHXZ2bzle9rqP/qW1oxZiqDArcgijKREwGuPzQpYKieP4/Py9TwzUawqi11TFf
         Wb7hxmYDAQMwrxCBQnuXMpGvsv+mhJ3vNsaVp1vSsOBdl0MzabsSdOm45kxxV8/ukaMy
         /KspZ94dahT6JXBisYKs4cL28drMqBXL9W8xmcmlLJB42gWjRBj1j/ibrbfZ5JOtnaAD
         nqKx2djmaWpYKv7HLHvyAVxca6Vh2RrSjBvhwouEsxVR/H+xdno1Otp1+z2L8CVLbI4x
         zzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663628; x=1699268428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JfBQ0kZpS0waR4OSRDMf+jgERxVRLh5PmV9Xsh8YXgc=;
        b=wYazZMCdcz09K04okNCJV8sth0HJ9qmGhi7Zm+qcE0t5BKM/++wZFAO0c8reIcLhog
         3Fya97oo+ofzIn2lqZqlzXGDdymOAtId77OhlJid3Zmb39xXKKRpHahLOrE7HQIuQk0Z
         nBar4IhEEx6CjC6Lk/pjYml3i9TH4tavM7gQeuBUcZeQR0ubAac1o95SQ82xi+PKrMUo
         8LaAeh78hHwbr7st/EhhA4B3/CKLNsj/vllYn+y/8DNQIryc0fh/caK/PguAUSy0axC4
         lfI9ThYj3jZM4wLyV13HmSnZEwWJZrQiiQ9pAXlAe8Ud68X0JvfKyjH8k1S3d11KHzyG
         +KIg==
X-Gm-Message-State: AOJu0YynexVlAfqpAzCuBiEhUaMeIzD9oOlbgNfELCZ6+98qs1n5yqcF
        67ncln0onkheCF7h6Vvyl+d7BJ2hNgFZyw==
X-Google-Smtp-Source: AGHT+IF0r676uf78wOZb+NWgXSHxo7pypZBClLRCfFOQD9AYylWPgl9XlBF3tYzlVygYBcO6tcom/Q==
X-Received: by 2002:a17:903:190:b0:1cc:50ad:4e with SMTP id z16-20020a170903019000b001cc50ad004emr1524300plg.47.1698663628484;
        Mon, 30 Oct 2023 04:00:28 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:28 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 01/14] cifs: print server capabilities in DebugData
Date:   Mon, 30 Oct 2023 11:00:07 +0000
Message-Id: <20231030110020.45627-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

In the output of /proc/fs/cifs/DebugData, we do not
print the server->capabilities field today.
With this change, we will do that.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 76922fcc4bc6..a9dfecc397a8 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -427,6 +427,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		if (server->nosharesock)
 			seq_printf(m, " nosharesock");
 
+		seq_printf(m, "\nServer capability: 0x%x", server->capabilities);
+
 		if (server->rdma)
 			seq_printf(m, "\nRDMA ");
 		seq_printf(m, "\nTCP status: %d Instance: %d"
-- 
2.34.1

