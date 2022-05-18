Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFA2C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 17:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240917AbiERRNL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 13:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240916AbiERRNJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 13:13:09 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2151C83FF
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 10:13:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c12so3832148eds.10
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 10:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=r5JIfgLLduKzFYvEKWJNbO62tf06Frhd5TKwlhhU4WI=;
        b=WLp+Yew8TDGnYgOBH5pAdhqu45/nGgaUUxdWL8xRoxhYFDTdRU2K03bGv4+KrtRDDr
         ueyPAuefCAw0psHDJd3xkw4OR3aJzdWyoU/lmpl7a91ItqxPorRcG3z8hudzKX0GYY53
         HJq48DFgu+KN8SffdBXgfUiR/2soxMBtz5I/9KPb6NNR3Ab5Hgo/cgKqOoUKyTkdzZQh
         zd8qUZPm4oVgiCTU5LkdYzVFNgf2yvtQ0Ngny7NiNuCPqmejaxGQ2vyzvCGVIj3zSCzt
         y3Ke3XnHwtSshDoC3gg1xrst79gEyIAfBpPDOlww5JtJUfCDXRuTbUmPxTbAu6sqlDE/
         UajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=r5JIfgLLduKzFYvEKWJNbO62tf06Frhd5TKwlhhU4WI=;
        b=c25hvi2h8XSDtEQtIKlbomLjtt2ISxSdEB6sk6fqqB8clKMqp3BRRPaJVHy9enICnf
         jQnTSTw0qHBVpreohdOpC3X1d1MH+oDi0dKHposrfj9XocP4pO5Aoyy/l7rPjKC76/MB
         8d2663ctUBXpCIhzwYwZhv6CXmuEJyeO2LjVqRlblSaZ8wtKqzmt9dBfJ8D/2zJJ+jSE
         IKLTvi5SiLNdhsmeZS2ixXD6u/5+OdPyx5olVMSBFLckHSw7tX7TDQ2MdEQautq2ekuv
         8ZjuooYdZc+3IWaFOZuyATy6kiLEapIAwWL12wjRhtfjaafZYddQda7xtPM5JZ7xcCr/
         OAbw==
X-Gm-Message-State: AOAM530A0Vy2XSkAz3m+4cEzxGOBTGMwmCItQnyCZiZiXA6UrxkYSAC4
        OFk3sZPDGpxAk6zbSUPCg4oq9xXnpNcf+5O4ptQ=
X-Google-Smtp-Source: ABdhPJwmrCbwLuv2m+5YHz7lfK8yfY5QaSzsriE0OT2aaWurux0zHXU5tCSY0/ZehVd/pHnSrpoYsWihM7S+4wLJk6Y=
X-Received: by 2002:a05:6402:35cd:b0:428:3831:1ba7 with SMTP id
 z13-20020a05640235cd00b0042838311ba7mr790082edc.311.1652893987585; Wed, 18
 May 2022 10:13:07 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 18 May 2022 22:42:56 +0530
Message-ID: <CANT5p=pfEF91j3frZFJgxMLU6XmaC-pn=_oQnOF2BQPaj7Bh+Q@mail.gmail.com>
Subject: Multichannel fixes
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve/Ronnie,

During the final stages of 5.17 kernel, we identified that my recent
changes related to multichannel broke multiuser scenario. At that
point, we took the less risky, single line change that Steve
suggested.

These are more complete patches for fixing the scenario, while also
allowing parallel reconnects for the multichannel scenario. Please
review these patches.

[PATCH] cifs: do not use tcpStatus after negotiate completes
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/35a6b903a8aaa2ae78a764329fd34ecba00647eb.patch

[PATCH] cifs: use new enum for ses_status
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a1f9fbe6915573807250cd2deac417ee98736b0a.patch

[PATCH] cifs: avoid parallel session setups on same channel
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/c1e3cb0a09a6253a96068d0b7156511883de533a.patch

[PATCH] cifs: use session_estab from primary channel
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/f5130d025ba42bce5fd39268704a9c7b091ce8e1.patch

This time, I've verified that it does not break the multiuser scenario. :)

-- 
Regards,
Shyam
