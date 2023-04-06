Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEDCC7618D
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Apr 2023 13:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjDFNMq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Apr 2023 09:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbjDFNMm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Apr 2023 09:12:42 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9308A51
        for <linux-cifs@vger.kernel.org>; Thu,  6 Apr 2023 06:12:35 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so20205723wmq.3
        for <linux-cifs@vger.kernel.org>; Thu, 06 Apr 2023 06:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680786754; x=1683378754;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=97jhiXzpmv5lcGNd0zqtVJxxGpnjhau/0QYQc6x4Wec=;
        b=jQjkwvJ0aySHsI6rnSO5YDn7OzLHnkAoE9OJBUCF8mUxBcpw+io3AU6eNvL8LKeLUF
         RrsYypIzb2NvXsLk9DDjiQmgBP4x3aLvTb4qnisBD0olB2dELGECT5at48ycjhKLSRPh
         PSaId3HqylCVrKk6md+QcTsDXtCeXE5nQHIdcS8WiOLTmOwyLvQLpAbaUPZL/B6GjgRX
         gPMMnlmZ2akhDARvUzLaiFiAPM0B/j62/K14dKRMT+zix1Amz/+MHyNHsAn+1TdByp5U
         wp4NahftDkhn9DTQazeA4GybkivcrQg2JOZxSI4Ta+etMZpOXDmx712LUniVwCEeD2jo
         uUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680786754; x=1683378754;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=97jhiXzpmv5lcGNd0zqtVJxxGpnjhau/0QYQc6x4Wec=;
        b=gD3GdR9h4ZujSAL5i/UzJW2Wrk57uhiiK5OgEEbI7LZrWqQOQhPB7Ak8wLSDpCPTpr
         wrH+DBXQNi9qZBo3zCfQhzJoPVubxJX3X38kAtOdAxOBn3d8rK50QXH3Bn7+v6IkhsR9
         JyGbvQBFX0VycWVmNt56t3RCtCoVlBvVQd0k69C3xiHfIs7BrLirH8+vB9DVyKKYpwje
         qy5puITwe8d6/0xbdwiTBdq4E2fPDPAElyrnHqguSKBuVc4/nggjHT944B5/x4rCd4nc
         Hvqo7YcCg58m+OfTVgFO8HZR/zDBq0xdzg4Mzp0gkg6YVlzDaTBd3XwejAELklH+vjEo
         ahew==
X-Gm-Message-State: AAQBX9d2djffVvLtL30mRzfnJbw+8fr47FaehDw67s06nhbG3+SnUWtY
        pJENp13lMtWRWcO0x+dO1+M=
X-Google-Smtp-Source: AKy350ZpiSTUC7IW/BotMJKA/CANpkeWgKNAsypUTDTwrmmaQck8S0YcnMIaIsQMyuuXjDa8cKG7/w==
X-Received: by 2002:a05:600c:22d6:b0:3eb:2da5:e19 with SMTP id 22-20020a05600c22d600b003eb2da50e19mr7297059wmg.27.1680786753629;
        Thu, 06 Apr 2023 06:12:33 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id d10-20020a1c730a000000b003f0373d077csm1534857wmb.47.2023.04.06.06.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:12:33 -0700 (PDT)
Date:   Thu, 6 Apr 2023 16:12:28 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: reduce roundtrips on create/qinfo requests
Message-ID: <98e488d0-4a32-4635-a777-4a216e35c647@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Paulo Alcantara,

The patch c877ce47e137: "cifs: reduce roundtrips on create/qinfo
requests" from Dec 12, 2022, leads to the following Smatch static
checker warning:

	fs/cifs/smb2ops.c:865 smb2_is_path_accessible()
	warn: variable dereferenced before check 'cifs_sb' (see line 834)

fs/cifs/smb2ops.c
    811 static int
    812 smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
    813                         struct cifs_sb_info *cifs_sb, const char *full_path)
    814 {
    815         __le16 *utf16_path;
    816         __u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
    817         int err_buftype = CIFS_NO_BUFFER;
    818         struct cifs_open_parms oparms;
    819         struct kvec err_iov = {};
    820         struct cifs_fid fid;
    821         struct cached_fid *cfid;
    822         bool islink;
    823         int rc, rc2;
    824 
    825         rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
    826         if (!rc) {
    827                 if (cfid->has_lease) {
    828                         close_cached_dir(cfid);
    829                         return 0;
    830                 }
    831                 close_cached_dir(cfid);
    832         }
    833 
    834         utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
                                                                   ^^^^^^^
Unchecked dereference inside the function.

    835         if (!utf16_path)
    836                 return -ENOMEM;
    837 
    838         oparms = (struct cifs_open_parms) {
    839                 .tcon = tcon,
    840                 .path = full_path,
    841                 .desired_access = FILE_READ_ATTRIBUTES,
    842                 .disposition = FILE_OPEN,
    843                 .create_options = cifs_create_options(cifs_sb, 0),
    844                 .fid = &fid,
    845         };
    846 
    847         rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
    848                        &err_iov, &err_buftype);
    849         if (rc) {
    850                 struct smb2_hdr *hdr = err_iov.iov_base;
    851 
    852                 if (unlikely(!hdr || err_buftype == CIFS_NO_BUFFER))
    853                         goto out;
    854 
    855                 if (rc != -EREMOTE && hdr->Status == STATUS_OBJECT_NAME_INVALID) {
    856                         rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
    857                                                              full_path, &islink);
    858                         if (rc2) {
    859                                 rc = rc2;
    860                                 goto out;
    861                         }
    862                         if (islink)
    863                                 rc = -EREMOTE;
    864                 }
--> 865                 if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
                                                                                    ^^^^^^^
No point in checking after a dereference.

    866                     (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
    867                         rc = -EOPNOTSUPP;
    868                 goto out;
    869         }
    870 
    871         rc = SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
    872 
    873 out:
    874         free_rsp_buf(err_buftype, err_iov.iov_base);
    875         kfree(utf16_path);
    876         return rc;
    877 }

regards,
dan carpenter
