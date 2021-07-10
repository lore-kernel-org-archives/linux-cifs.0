Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB973C07E95
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Jul 2021 17:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8937F61289
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Jul 2021 17:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhGJRmA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 10 Jul 2021 13:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbhGJRmA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 10 Jul 2021 13:42:00 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE58C0613DD
        for <linux-cifs@vger.kernel.org>; Sat, 10 Jul 2021 10:39:14 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id q4so14156776ljp.13
        for <linux-cifs@vger.kernel.org>; Sat, 10 Jul 2021 10:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=R+0R/kJcF+H0X2cTNNI6FBoHFBz0pbVPBEAdfzhZFkk=;
        b=N0XB4xPBgXMa2aa6o/N38zjOaRQkBlvKgiixsOrspeWca6r74GIJKJgtKtFC1VmB6C
         Ir+clPTFfGstKia82m8aoceDPgnPZ6a/5xxkYlCFn65AAXz7Ek4WKRiw+/M19PyqzrWY
         UprrLd8I1fTOidTiMAtX2FS/z587TTAi+5lT0V1UC59yjqWWNRBlCJzh/oc+EmbK5cCK
         OtocVIGVMEuhN+aHxs1YAj/FdMfGx9ifyW7onvOS8hDr/LsSOotNPhWR8g2euo2nyGKN
         rHf3jy/SBQa+B9D45pFoN6xLaGveemvXCV1+dBqlT5hPYpUHOG7vSwLscZEXYscyHFUn
         DBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=R+0R/kJcF+H0X2cTNNI6FBoHFBz0pbVPBEAdfzhZFkk=;
        b=dcyRUMcKN8A1G40weXECagJGt0wZEUSjjFHuTkiaFZ9OhiLoz21QWoOF1eFYfcVoa8
         I/dxq5eJnYMugE1hIb+0FeEMfXPu0ZmWw9L6KK9MQSwG5MtsjycgMUBGzHfo7PO6V50z
         XABjgNvM4UnYySbsiPYm7BuhSFrtp+hGVwqDw+w0pqvKNlxY9Q3q1ZM/i93dQW3xKgJJ
         MExtf76XHdbcC8W+1fk9EL9DeuabKBy2W/6RySz2sJhs0BP6QuoxgUAkRA13geJU/VSc
         GQyNwVwAg/AMKBHFSnScBvROtNPL7ZQmq2GEpCSMruKvtq0f2I9sNY01Q8TuUI694WRV
         hQxw==
X-Gm-Message-State: AOAM532/DZ7E8qrLi1iH03uzktge1GzpnqFMaVsk4bdkanaqIEvtLMxs
        pp8yeFu5tYDiI7uKx24xRkyRul6aOovJF36Yhzzq/D3Quzjj8g==
X-Google-Smtp-Source: ABdhPJzbhLgT2dy6iAv1x2lTXsUbCvb3l4dbyUsgDutm4T/nz6KF0ywUnIRPnSfEu58K3gxjP7XhtAwK3+6XqI2Q3AU=
X-Received: by 2002:a2e:140e:: with SMTP id u14mr27362244ljd.148.1625938752476;
 Sat, 10 Jul 2021 10:39:12 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 10 Jul 2021 12:38:59 -0500
Message-ID: <CAH2r5msSOfXnwz7u=RQWStSnbPW2VKvDz_N77G++0VJbj6qOiA@mail.gmail.com>
Subject: mount error reporting bug with DFS and new mount API
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Found a problem with how we report errors with the new mount API for DFS.
When you mount to a target where some of the DFS referrals are not in
DNS (in this case I had forgotten to update /etc/hosts with the IP
address for one of the targets) you get the wrong (and very confusing)
error on mount:

     mount error(4): Interrupted system call

dmesg shows:
[351218.107319] CIFS: Attempting to mount \\192.168.1.162\dfs-test
[351218.184027] CIFS: VFS: cifs_mount failed w/return code = -4

It should be something like "path not found" or "Unable to find
suitable address" etc


-- 
Thanks,

Steve
