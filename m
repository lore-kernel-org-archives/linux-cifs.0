Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C652CC001DC
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 02:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjG1Cx5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 27 Jul 2023 22:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbjG1Cx4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 27 Jul 2023 22:53:56 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6C62126
        for <linux-cifs@vger.kernel.org>; Thu, 27 Jul 2023 19:53:54 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2b9c55e0fbeso18344571fa.2
        for <linux-cifs@vger.kernel.org>; Thu, 27 Jul 2023 19:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690512833; x=1691117633;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j8xQ2OoJUWdEFlsZoCnISKJFpUGC9OqdyqiaJAofRAQ=;
        b=BJJClK/Q/uC26EIMtG7y+BRzWboRFnc5TQTHomSpE3pn+IWuWzbSuv4+/5FctUM3Dw
         dOXm7guPGE/Ucl7tF21Htlz2BiPjHXyGOm5pYLICxOgiR9bu6PcNzZ0W2WkPhlZ4BQrb
         vU3TQH74gUho1x5ihtl+VPvJkVzHokB6N0zha/TP0ipekSBigiayPu2xONY6l6PjEy5n
         s8NhnFut8THhdQrSL2W/WZemZUUG6wD+b7P8GajAa6gMz+azuH9tueTetpzN3Wg3FiGV
         Zt74w1DG+EmhqDfKYtDoQ+hWTg7iompGXpJFq9R2d1J3JnYBton5F7DuSpqAk22OaU/V
         WZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690512833; x=1691117633;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j8xQ2OoJUWdEFlsZoCnISKJFpUGC9OqdyqiaJAofRAQ=;
        b=jK0hF+F+kjlg32Boc4J1XD084YS8QNgOxD1AWrnruSakNT+rLERdEe/twEzVtaR+b7
         fgUA20TX3jTuApf5YGnX2pG5/Auax5T0/PTSbfBI3VK5bd2P0aI6Fg+02HvejTjsCvyN
         xm8XYV8+SjsUd48Tm/TnGhVy9A8ZE3knEtzZI/4V5GZlOqGr9Uvf14kg7ER+RE6WK4gL
         4lUZH3j0m1f9eKafc/N8IKPHoLgLWt9+JQe90UGC1m5jabQJcYo+nDdfpUz/GY6qykYI
         P7n1gMQwiIhlFKNJceg69rKiCbSUrw3oPKaYq3Oafh2X4aIeKYrJLX7x/V0C7+k7obZY
         kJjA==
X-Gm-Message-State: ABy/qLa4vPA06e4WBsuccJdvx8VXi5mQ2W/qXLi3awTXoZIvOrMMF2Cp
        1v+6xZOJPXcBT19AlsD18iKReZz9zPSz4YPK/rbg/bPf
X-Google-Smtp-Source: APBJJlH+ByS3ywsMF3X+Jyt+BE8n+f3Je7XdPkSEZuc0A8S71ZUtuKCEjssE65m3lraMe1cvdCDmZUdXX3X3qZpEi1w=
X-Received: by 2002:a2e:3e15:0:b0:2b4:7380:230 with SMTP id
 l21-20020a2e3e15000000b002b473800230mr598571lja.13.1690512832784; Thu, 27 Jul
 2023 19:53:52 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 27 Jul 2023 21:53:41 -0500
Message-ID: <CAH2r5muhc8Xd_G-ECop51uf3PJO=G5aWFJDYMnN_BSaL_dMj1A@mail.gmail.com>
Subject: update to new mount api missed synonym: "nolock" (synonym for nobrl
 mount option)
To:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Any opinions on whether to fix the conversion to the new mount API a
few years ago which lost the synonym for "nobrl" (used to incidate
that we do local byte range locks only, don't send byte range locks to
the server for this mount point).   NFS uses "nolock" for the
equivalent mount option.  Prior to 5.11 kernel (when we converted to
the new mount API) you could mount with either "nobrl" or its synonym
"nolock" (which might be more familiar to nfs users).  Should we readd
the lost mount option synonym "nolock" back to
fs/smb/client/fs_context.c? Opinions

-- 
Thanks,

Steve
