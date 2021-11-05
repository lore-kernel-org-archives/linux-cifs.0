Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7821DC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 19:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3A261052
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 19:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhKETZL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Nov 2021 15:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbhKETZL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Nov 2021 15:25:11 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F8FC061714
        for <linux-cifs@vger.kernel.org>; Fri,  5 Nov 2021 12:22:30 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id f4so36238107edx.12
        for <linux-cifs@vger.kernel.org>; Fri, 05 Nov 2021 12:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=3jBjB8Aef9ZOpLV8JCiXmU3ySQD2BMCZN0szzJX0np8=;
        b=lzypw6qQmy55fNcLPncRP+xR5KrZx21o+RovZAOWV6i8r5RpB5jqRgJ5Rum+Ar71NG
         vdk/S+blFw3jiV6XJftLg0TBBWsQbYC49nrjdZWmFSVtmWIATK6HZh40hPZpOAkjshLv
         xrsBLbja1ii6bHMyeJXcJofZWkxvT2B0RyoTbnY5zy99C+M5P1Em/9foHwbGQS81fHx1
         nAZLiJUUI7bdcXdIfYhQzGC/ry0vQwfvt123OrwZ8Ii8g5zpPnpdZxuYr8fnQf5DWLNz
         Jh58MJSkUqE7oLJou5vL1Lp/UJLyQ6SJzLGEXprvDjoJgyiA+Sm3Az5rDIqNiKkYm63t
         qU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3jBjB8Aef9ZOpLV8JCiXmU3ySQD2BMCZN0szzJX0np8=;
        b=eaT3EN2NLV3PB/Iv+7qpuJBLi8fWd23osEUEI1x8uY3K3hCBPASAuEB6BvdUYEinoq
         w0gxH31oD6X4TZ3C22QhX2G2Njy4WkoEDgKHfJMdcSnq6XHiv6ECW3EHDxF9EECxVfKx
         Uk+68zdSPWBvCUm5EJzf1rPSWL/y88frHbZE+k/i/UnUpqVVJlY73KfctXwvHMcRKM3T
         I9v5xBUKrOtAqkEK2PNMVI9z+oGUq+p3SIwRaSer7kbnEVRtXdjtBJsstQ/SvtsAnfPH
         rn01E2OzBSg0aVChma2FJDGwrY6qf/MMAguS8PVdFv0wciD3M8xcR/PFVj34bomWYJVS
         6Txg==
X-Gm-Message-State: AOAM532Q3SNEkoMR8d+xAFjlXuTebragu/ZdxvH2PpvqJZlo6bBBktsN
        CWP1GFmEgbRuyRsfsk79qn0OeaZCXpyVpS68TsacBqPPqAE=
X-Google-Smtp-Source: ABdhPJzobLo5MTdTHXITIMeBgoBnLGttlkHA5/L7wKfhoJE+HkQwRwuv9dbP0GnfZZ/csfDYoupsnwwp1hGYPoUtgkI=
X-Received: by 2002:a17:906:7d09:: with SMTP id u9mr75683785ejo.120.1636140149455;
 Fri, 05 Nov 2021 12:22:29 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 6 Nov 2021 00:52:18 +0530
Message-ID: <CANT5p=rgHn59NVvH32FSKtNv_cyKi4ATSAExBmWT_qjb7km7Fw@mail.gmail.com>
Subject: [PATCH] cifs: send workstation name during ntlmssp session setup
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Please review this patch, and let me know what you think.
Having this info in the workstation field of session setup helps
server debugging in two ways.
1. It helps identify the client by node name.
2. It helps get the kernel release running on the client side.

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/d988e704dd9170c19ff94d9421c017e65dbbaac1.patch

I ran some basic testing with the patch. Seems to serve the purpose.
Please let me know if I'm missing something.

-- 
Regards,
Shyam
