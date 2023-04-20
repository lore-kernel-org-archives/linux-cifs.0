Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF99DC77B72
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Apr 2023 16:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjDTQH3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Apr 2023 12:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDTQH2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Apr 2023 12:07:28 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69031FE3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Apr 2023 09:07:15 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-5ef6e0f9d5aso8390256d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 20 Apr 2023 09:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682006835; x=1684598835;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AlV3w4Cgx1dO9E/N+ZlatSlW13fE3dqy0QQWDS+ef9E=;
        b=Z0KLkweMyoICmoXy5xARFUAA9Z2qxs2EYTfCCRZVsuC6intJet9Yo1gHaM+rHFc+W6
         N3n0UcrTzRtG5HXXv7hdrGuAG5WmEMohGjhYk8XOxzP/8p/1fbp9u5kE+H4DTqa1pfKG
         wn0XoJEYVspKnPY9ND+LuDGmuvM/e+OgnBp9uVrSTDfTo1QtERw3khNGVM1Q/EP/3Ska
         yv4D47EsatztgDzjHKxICu3iyxse+PhNvS3Kc85B/SP7yCYOrNwl8uFoTii1miklJkYn
         j2HLJZTM7wIlLfxxR9X6mL3IflKxf+HlR/UABzkFoyqX0IOXp9ALXe2u5gaCiW4AoeeP
         6A0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682006835; x=1684598835;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AlV3w4Cgx1dO9E/N+ZlatSlW13fE3dqy0QQWDS+ef9E=;
        b=jduUT0Ir47Dciwv7z73LDMN418R0AhFoux1fioZzmvYmY9NWf+cmwJ2qF9tbtJJsfD
         xFdDLd78MB77mtElLR8jwFgp+w3RBamcrJ23yxff6P/DotbSTUW4SuFMXCa3M/eyAyHa
         SpBLHoFE9kV8sAgLNeAM99rzAWH0egfOAcqhwA8pKirruptJ2xA3W9EcNS9ysP9UmSj7
         QL7YEDYGULFHckXptYG/8Rpnyev/nvdrS1wm+PBweytgHu21pddug4XGdFUYoMtq8i8n
         p3HuKNvbEdUVg/YsOxUI4uawjZztHe06cDE8AeZjF4SZvaTMDzXFKdTZqmcFpCJEgrvJ
         QiZA==
X-Gm-Message-State: AAQBX9fr6X3+9JJbatXadTTV1aB5M/lhIeqPvisKFImu2iWpUvAQAGft
        q3M6+8Ewv/HsG32d3qy3p5k=
X-Google-Smtp-Source: AKy350byr6+f5V52NqNcORsSfB/eejDRtGRD8/JOd2/lzf9P84QXbwlBykPq0t9S9cDD3h0L/VXjhg==
X-Received: by 2002:a05:6214:5185:b0:5d9:a36d:3ed2 with SMTP id kl5-20020a056214518500b005d9a36d3ed2mr2839114qvb.45.1682006834842;
        Thu, 20 Apr 2023 09:07:14 -0700 (PDT)
Received: from ubuntu2004.1qqixozwsnuevircicbvxjrsib.bx.internal.cloudapp.net ([20.84.44.103])
        by smtp.googlemail.com with ESMTPSA id t11-20020a0cde0b000000b005dd8b934579sm493129qvk.17.2023.04.20.09.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:07:14 -0700 (PDT)
From:   Bharath SM <bharathsm.hsk@gmail.com>
To:     pc@cjr.nz, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] SMB3: Add missing locks to protect deferred close file list
Date:   Thu, 20 Apr 2023 16:06:46 +0000
Message-Id: <20230420160646.291053-1-bharathsm.hsk@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Bharath SM <bharathsm@microsoft.com>

cifs_del_deferred_close function has a critical section which modifies
the deferred close file list. We must acquire deferred_lock before
calling cifs_del_deferred_close function.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/cifs/misc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a0d286ee723d..89bbc12e2ca7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -742,7 +742,10 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+
+				spin_lock(&cifs_inode->deferred_lock);
 				cifs_del_deferred_close(cfile);
+				spin_unlock(&cifs_inode->deferred_lock);
 
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
@@ -773,7 +776,10 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+
+				spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 				cifs_del_deferred_close(cfile);
+				spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
@@ -808,7 +814,10 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 		if (strstr(full_path, path)) {
 			if (delayed_work_pending(&cfile->deferred)) {
 				if (cancel_delayed_work(&cfile->deferred)) {
+
+					spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 					cifs_del_deferred_close(cfile);
+					spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
 					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 					if (tmp_list == NULL)
-- 
2.34.1

