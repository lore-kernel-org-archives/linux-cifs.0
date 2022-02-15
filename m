Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CE1C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Feb 2022 14:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiBOOP0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Feb 2022 09:15:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiBOOPZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Feb 2022 09:15:25 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4F89BAD6
        for <linux-cifs@vger.kernel.org>; Tue, 15 Feb 2022 06:15:15 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b14so7735824ede.9
        for <linux-cifs@vger.kernel.org>; Tue, 15 Feb 2022 06:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=JtxbWQSRF8DqLTk2YVEvbsJUWiYKkB1YZvzIEdrfYns=;
        b=aOnAXUo9dQ5+yKYf/yXaGb7HGcyQH62JAcpGe2T6/KYWUWH6K0ZdTGiMrvmcMqrIGx
         KVjVezmxHbiwHNwooNJ18BKvhyjz93rIgptPSvP6spBQnpcABHMQxWJxxmMxKNrTxBgF
         8+r9v7lmGCl6d8OVFkQbaRvCGHQOT7UdK7f0Y2RtgXxHRl0nW6sW6UjyLjt7f9aDZQic
         RFBEpixrpqpOLlmDXM3hrBWEQ/Xl+f2qSrJw/vsBUWcsoonTzR9Tte+8Tmt6V/utUml3
         fIWDBpRcKPvO3q469SEeu8UI3ziGAwe3VdgZkEJxwD3KGWqQ+9rInNRSO8QsiBrI/bBt
         o30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JtxbWQSRF8DqLTk2YVEvbsJUWiYKkB1YZvzIEdrfYns=;
        b=uuMtxcqqpCH4xqlWuRVOqFtGdPzt349bCcBdfTQgeQ/+ywLom2Ef8728D4V0mIlbE2
         kC7Jk4ovpWh534MkGR4gAW8s8LH7wL886qtBXUgGbbv0FkRfQn5C6UnjnN6SZHXkP/WD
         UsQaOefLe9edT8nfpa8LmvZ9y5kZP9HUsOBQ8C9xfzZSR6EwGdVGlTAO2Hm7Mb5rOQgA
         JnTkW+jcyfPf3oCEibxt2bt3u7WkgVuuoP1uk+5riALUNQdqEGKulQXDbmFWykwHZ5tC
         aY3R/8eLbzk1xFETabjDJ3WE+awTDesXmTPYc+Q3FxPJgsQRTtM4i3Vq6gY4rBE3ufsP
         /Vhg==
X-Gm-Message-State: AOAM533tPJg16Y8B0EM550uAZvp4rpcPQuoc9TvPcWXnnF1Mso0bQYwQ
        2UFY25vGoPZ5/F2ntnPv8zD+C5fq5gxUMXwYgk5jbtdT5Eo=
X-Google-Smtp-Source: ABdhPJzNHAJzCMnpLvgU1d9MaSiYqvElHOasvzbMcl1sQsm78zT+F+NORfC5chqE/wWRlvKKz2db4hFc6GZDpq2YLQs=
X-Received: by 2002:a05:6402:1e8e:: with SMTP id f14mr1072173edf.240.1644934514247;
 Tue, 15 Feb 2022 06:15:14 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 15 Feb 2022 19:45:03 +0530
Message-ID: <CANT5p=oyS-49nAvmddV=s+VOz+TG0SG7RcTEs6f25g_2hC-rUQ@mail.gmail.com>
Subject: [PATCH] cifs: use a different reconnect helper for non-cifsd threads
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

My patch last week was not sufficient to fix some of the buildbot
failures we saw recently.
Please review and use the following patch for new buildbot runs.

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/2b599dec7c9399b66b56419fcb252ab37de94e3b.patch

-- 
Regards,
Shyam
