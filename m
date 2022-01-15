Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D31A7C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 15 Jan 2022 05:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiAOFvU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 15 Jan 2022 00:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiAOFvS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 15 Jan 2022 00:51:18 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07B9C061574
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jan 2022 21:51:17 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m1so37099804lfq.4
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jan 2022 21:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Qg5iPorfKh3I5lmT67e3Zf1nNPuOH77dv0TKTa8nLoQ=;
        b=T/1yOGODjoTMxq5C+je9x6EfmXBYNWuNTruqtG6Cj27QOA0px9NAaGnyK98vl18Zus
         LsXI8KwQXTDRsSmBqTtcmscOQ9Nmi3ik7icjX/6PaG11EW1ukn+Whlw0m/p1fA9+D+aU
         qTSx1QvBU4fT7qDG0DyMf+Rbaw55aixAf2rTAqnThY9PPWL9yYzTUpdgefEsAs4FjALn
         IhLdSPemv/fUOr2nPDnFbl0AtX6z0Wo4sG+h2O+rqBOZnenRJ9JIsbPnnSLH/dHUgLG4
         FPY7KVWTWP6j0x8HMxPLMa6H6sBGjPKEW6mtR6T1s7OR2xP7SXAUk41qcPSwcPInSSMl
         q1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Qg5iPorfKh3I5lmT67e3Zf1nNPuOH77dv0TKTa8nLoQ=;
        b=GI1VH4IyAWTnu8iZ4f5JHe24+BUwXMhEaA2kX76lQZspd84B+0/Psj0mBq68XSSo4i
         qm2c7+i+TqeSiW6CaXlLD2HuxlSa/UateNvE5HpIxNmoN/XPNbz2WB0mVx2b9mNfjRFw
         abKqi4MCA3oDQuULcaZlZnANx6Uq8HLbIJN+U8JuyRKPywFu92u5PsLA8bubWKup8SSp
         TJcBfrFw9FHVH+VZMEIO1Lcsy9zcCsu+5P/RiDqDHKO8LTDCy04sqyUuNFHxqUdYY2yI
         uru+Vhb42TCj/ONJWDCIOqitz8eUAAEs5IocxcMA5ONKJtGDJ+zvCYxZ1S4zJaLZEdVe
         IL1w==
X-Gm-Message-State: AOAM532nHt/29AuHA47vAUKlcGyzg6dJN3oq7Bqm+a+7IlHraCi7HXQv
        RlbkpO9KTlX4a9flN7RqYBaVdecl99Yn1qMEW+sLER4V7Ec=
X-Google-Smtp-Source: ABdhPJwi/YHgGt+PTBCvLVcEWgQGjfZOjxMg5y8j1sXHuxIx81Zl88C7UFJMvsbQwTFNQyMEhldmsDNSMhfExScL594=
X-Received: by 2002:ac2:4c41:: with SMTP id o1mr8920863lfk.545.1642225876232;
 Fri, 14 Jan 2022 21:51:16 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Jan 2022 23:51:05 -0600
Message-ID: <CAH2r5mvOqDErGDenf9i2gOH5q0YOKpVs-E4HD-ZnkB33UTQ99Q@mail.gmail.com>
Subject: Multichannel patch series
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It looks like this change to connect.c (in
cifs-check-reconnects-for-channels-of-active-tcons) causes the problem
with DFS reconnect

@@ -4399,9 +4400,22 @@ int cifs_tree_connect(const unsigned int xid,
struct cifs_tcon *tcon, const stru
  char *tree;
  struct dfs_info3_param ref = {0};

+ /* only send once per connect */
+ spin_lock(&cifs_tcp_ses_lock);
+ if (tcon->ses->status != CifsGood ||
+     (tcon->tidStatus != CifsNew &&
+     tcon->tidStatus != CifsNeedTcon)) {
+ spin_unlock(&cifs_tcp_ses_lock);
+ return 0;
+ }
+ tcon->tidStatus = CifsInTcon;
+ spin_unlock(&cifs_tcp_ses_lock);
+
  tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
- if (!tree)
- return -ENOMEM;
+ if (!tree) {
+ rc = -ENOMEM;
+ goto out;
+ }

  if (tcon->ipc) {
  scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);

-- 
Thanks,

Steve
