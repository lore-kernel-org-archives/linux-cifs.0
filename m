Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E001FC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Apr 2022 02:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiD1C1J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Apr 2022 22:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbiD1C1J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Apr 2022 22:27:09 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A607DAB6
        for <linux-cifs@vger.kernel.org>; Wed, 27 Apr 2022 19:23:55 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 4so4893441ljw.11
        for <linux-cifs@vger.kernel.org>; Wed, 27 Apr 2022 19:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=U/7opeSlL2OpCJ2P61vzYEKHz/6VF3sjVHx7nq1GUzo=;
        b=E8AL5XFKqE9z0ToiYRQFlDcxjAKaD9vufP8LXY9taXWw4DDpQynxEb695tJ66nfa92
         YhbxY57oo6lulFxI7S8YsugJpVGvYSJkVV1j0GRilnSMR4cU4YpNEx1Rxai1zUftF8Ys
         Fnubs/24ngUfb01e/KHPcsOAZzPYCrseTNBO12+ZJS9lFwJJ0TNzpUu9GFMtV8DYs3C6
         iDAv8z14NsosWC1Y/YVsGs47jzj/aS1R2U/NjtB46k30OBNz1M32wR5ds2R42gQTgXBI
         rvgBS8BoT0Yc1ypm4XIrUvL+27ZVmdf7KJOwJN3e9C9ryFa5nPnxbAbFBQzy05PNl/Gw
         Muzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=U/7opeSlL2OpCJ2P61vzYEKHz/6VF3sjVHx7nq1GUzo=;
        b=5EfqoMRsNmtSmJCc4l5aESK76xtTXyUlzmht3l4cnNU/854P8WbciAhzOXNN1j47ad
         IkJ/fu/gWvBbEYV5oq+rLADWBSIG0W+nTasN6mO4HjRs7Zil3CxCoqBUXm3sEZ3ggPHd
         AdxnkHsWYs41TvPIc5KMNzf+NIGponVT5VcOViZg++2TN78JZgHMkDrEIH8emtqT5TW5
         tQFgYTtzVkeCs1R5XWT9rnohMYEhBRs7S8touFXjGvyGlLAVKw1AHqAgfOhyDl1d9zcD
         wHcS6NjrRztH+BkVXrbDZgrVv6zrxdPNZ5xOUVEP/ATxPAgIN93nBc98Fh+zgRQ3ag5u
         P0sQ==
X-Gm-Message-State: AOAM531bkrapDLZZ/qSJjbLYhDf65orqejaqY87LIBeTnCQQbOBVeHEl
        ryEiwV/BQabLSKwMoG/chtDck9uN/6KYx2Rx95CgV7tBY5E=
X-Google-Smtp-Source: ABdhPJxXn+BRYbeeViF5BcPhGha1ff0cSOYbbUYi+kfT3y8/QJyU0aLy7QpD24hhI8oMJMyaKRFV2/x3NlVrD4SAMaU=
X-Received: by 2002:a2e:b014:0:b0:23c:9593:f7 with SMTP id y20-20020a2eb014000000b0023c959300f7mr19761564ljk.209.1651112633518;
 Wed, 27 Apr 2022 19:23:53 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 27 Apr 2022 21:23:42 -0500
Message-ID: <CAH2r5ms4E+cz36UbGKHntwJ=k7KTfDHcJ9cNLNuBX1_3uQ8G4Q@mail.gmail.com>
Subject: "full backport" of cifs.ko fixes/features to 5.15
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In case anyone has any comments/corrections/suggestions.... I did a
full backport of all cifs changesets through 5.18-rc4 onto 5.15.
This may help those running older kernels who want something closer to
mainline rather than just the much smaller number of fixes that go
into 5.15 stable

See https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/5.15-backport

I did run the buildbot regression tests on it, but if anyone sees any
problems with it let me know.

-- 
Thanks,

Steve
