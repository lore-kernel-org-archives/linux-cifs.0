Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF1FC00448
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Aug 2022 03:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiHYDZd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 23:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbiHYDZ0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 23:25:26 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1F516586
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 20:25:19 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id 67so19606482vsv.2
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 20:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=6wKfAi7TtcxnW1dDA+SVoH7B2j+fUCo/HQds8alP/Uk=;
        b=fVrEGNeLrTs2jTNly8RG6vUH1og7HSXCr+U+TtrRUfKwX3wgqMeKddlvZp42SoiF2M
         JVZEqJLjtv881J1bohDQy71U0vsFM9p8EgMT/izUwFnpBhC2Ris3qtwa0/o9Sy8woh/L
         UWQXxmouGN/uBncSE2sqJP5mDPsfLQIAZJ1TV9kXFVXONnnpmVKrkjkniHNLo7uLC9q9
         n9byF1Ut7DS3CEBqI513dOvQNG/3QD0yRiZOhVSqlRHtkA7osgCKsKsJhXQ813tOZCTo
         LJiNU7hWSjjtbzFT+VRloWIHDn7ynGikKdU/JaVURMJKqJM53Mk1JmoGvXd5eD44vjrA
         UjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=6wKfAi7TtcxnW1dDA+SVoH7B2j+fUCo/HQds8alP/Uk=;
        b=AdIxwcs12pnBx+2UtKl4bRD9aHqabf4qK9NG3ZEoeMJS3hb2Rai+HyPRMpJ29EhCHV
         o176quL55ggjSm4doT3k2BOjpYAxYiC22XP0nCzmzdU4yqPn0fHnbmNCeH6b30qC1VDi
         p4UUd/CDsIwqoyEHTo4o0WaGM/W6hBOl0dwBVR6OqDJcy1WnYwz1cSsits3Ez8a1jCr3
         uRPlze/wFLfHnNpsxvE9we6EBBsCQibVqjoLnOw33PEFebhyXoJEIfGkX1f17k4R4N1d
         meeRisihm3moe7BOFHZsDxEWsxuft5qxy5UrhOBjE8BFLB1ArRS2T4hIi4mRbtzVXIT6
         nFFA==
X-Gm-Message-State: ACgBeo2KAbg00xEo6l9n3NUcQj8qvDSWJJCD8zSegaIy+M9BruhgYruD
        RbblK3KMTceajjnDL4E+oKg9VAZV1fb1K27CaL3F9vsImYdxXA==
X-Google-Smtp-Source: AA6agR6rIjA5UZEjsTqiKzcYo4ZNLlY3/KugNmCJBIuXbmkugUkPzvQSSfoDV4r9LGH3c+nuRSoJR0p1T5aIBx+bpUs=
X-Received: by 2002:a05:6102:1626:b0:390:2616:663e with SMTP id
 cu38-20020a056102162600b003902616663emr742260vsb.6.1661397918512; Wed, 24 Aug
 2022 20:25:18 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Aug 2022 22:25:07 -0500
Message-ID: <CAH2r5mu1hymEWSAJP-7d=kEB39qU1Vq3-=P8pdQ38OtYQDVotA@mail.gmail.com>
Subject: excessive flush calls degrades buildbot perf significantly
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed that changing the config for local.config.smb3 in the
buildbot to add "nostrictsync" (which prevents sending SMB3 flush
requests to the server, but data is still flushed from the client,
written out) cuts 2 hours off the buildbot performance even though it
only affects about 90 (about 40%) of the tests (the others are run
with different configs):

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/1017

We probably need to be careful about cases where we send flush
requests to servers since it can be a very slow server operation.

-- 
Thanks,

Steve
