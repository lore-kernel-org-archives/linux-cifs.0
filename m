Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07875C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Apr 2022 13:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbiDONmT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Apr 2022 09:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiDONmS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Apr 2022 09:42:18 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CEE65D14
        for <linux-cifs@vger.kernel.org>; Fri, 15 Apr 2022 06:39:47 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id bn33so9552423ljb.6
        for <linux-cifs@vger.kernel.org>; Fri, 15 Apr 2022 06:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=kM8sYOQ7CLTijJg1z7fdLJMWp9Q249XQXPDh4ssH9q4=;
        b=cO//tLtufXlVcvnlB5ERtDug/0zy9tgTOOqQMp6XFHYmIzGJAe8Wb0sVAMGvN+I2Te
         eYfvKh/XpmOHesZdMlx63qD+LThUX5hrZrxvs7WdvMeyG0ME/QLtngbmSpF+yGvKLTkJ
         Q1J58ATLNXcrACdOWQj/Q1JHYqsgHWMoLmU3nSn4o/hubfANjuufGXtsCTdSy+OfdkMh
         Cb7CcvTCwM7iCOOlfvxV7aA4UcUy/HjzVF3oxFjtp7UUPWUlDCFmD+6oZTclChd8dMHA
         x4ZSEdKScoZJdgtnDqztmyKQFyvUeh+oEqEbeY2hlwDl3C4jIg8tli3QSlMw6+fCJ/CX
         vDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kM8sYOQ7CLTijJg1z7fdLJMWp9Q249XQXPDh4ssH9q4=;
        b=X3UMm5o/7mH2oAv8280uulXgW8B73UwAZb5rybTMr6WlyoNLJ5Th7qLeSyweS+YH5H
         JY2+SYc2b+/JKfeSjt81DwFZeIk7f3g3dDfOewAvttXR3AEn2WZMZz1sdK8oMjV+N/5P
         txq5suYpWvp/2i3loBi2lUPenoY1Lbkk71tDOMo219NbFLXr+FJ7iGle+qe/d4JPAif1
         86f7lAXYdBOLPppbzcWdtNDF9z2mWEhKZl3bzw5+S0WbUm2rLjsbebpVVlYklGeebSSv
         o3eYW7GELXHooBdYPs+lrjKOhy9Rpi/Bl+wtR1AgHPQ9uunqfaHr8Uz70UPmoIU/Ki4I
         6Zmw==
X-Gm-Message-State: AOAM531XW3e+Vj0ay26mSDxmNVAdeenE6UzMlG/86QwVCitmMwdr4V9+
        BNJhVgLCfJvoCCcD1cQaLC1UCP1IsEZtUwV8Z99vCZy9UOk=
X-Google-Smtp-Source: ABdhPJy4qm1LaDHjRhFep1UMr+zqO2L5moPpsqs8B7bMHLfhfgwcC/Mpdsg5flhKmTrCCfJ60HD0f3f6DmyKyhrZUKc=
X-Received: by 2002:a05:651c:b24:b0:24c:7ebb:a99d with SMTP id
 b36-20020a05651c0b2400b0024c7ebba99dmr4474421ljr.314.1650029984912; Fri, 15
 Apr 2022 06:39:44 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 15 Apr 2022 08:39:34 -0500
Message-ID: <CAH2r5muQ+HQZV6eVLC34eFtbWxZWBLG8mJbBzxGV_c-2ZJ6kDA@mail.gmail.com>
Subject: buildbot tests pass to current ksmbd
To:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

FYI - current mainline (Linux client) passed all tests to current ksmbd-for-next

Also let me know if we need to add more buildbot regression tests to
the ksmbd group

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/101

-- 
Thanks,

Steve
