Return-Path: <SRS0=Kcr7=RG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8519CC43381
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Mar 2019 20:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4836D20835
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Mar 2019 20:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u7XIE4nX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfCCUqB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Mar 2019 15:46:01 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:42398 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfCCUqA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Mar 2019 15:46:00 -0500
Received: by mail-pf1-f174.google.com with SMTP id n74so1443970pfi.9
        for <linux-cifs@vger.kernel.org>; Sun, 03 Mar 2019 12:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hhXhe/QQl1CjhqWK423RcVWUzzB2Yc783bQUnjNjexk=;
        b=u7XIE4nX9GpziCFu3Cn9+F+cKVWQ6Bb6AFzWMCmY4plj0LGTn9nTuAW9ZjDFNeOO8y
         6Ny00k9UbdE+t/bbMnT4aOS5uopPKo6IHEC0vJ2qUhxQJzEGWh0bA3wjYVpII2OLCFZD
         Vj2OSV6IVZBy4ztccJ6dPjZVf4BEVmElU4Op4jwiq/zyr9zcjx1Lpu2stm7WuW0h/LG0
         bho30h4nQInQPq+sbrp6W66ingnRKwfMKgkFgmP28/AeWcPDwz3coikKTf5FJi1FzfQN
         wJxBaxNbLL9Oh5ctEH+29XVTZrtYVpA4flQ1K76NwN7P3ihmBAuoGGZVxx5WbTzuxrHk
         vHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hhXhe/QQl1CjhqWK423RcVWUzzB2Yc783bQUnjNjexk=;
        b=uK95Hzobd8BlJPiF7J0w8tkGVtWZ4mmK2U0oXYcXS3L4pCysDNu6hcahnhBwBNKfpB
         oXO+oB/SN1dVGgX2faI/xbNHmJ7ZF/FFbFXf/8H/Y1GwkuuKfSGlmxOF56VlTHav3Zxi
         sDGlQmuxYEdbANBiS/GLuKyYd327lnCXoPaP3+i80MVcI8Xkf8XtvrOnfZuTprgQX9c+
         8eCyEMcp+N1jPG7R/JY+sbPv7Kw61YP/UiMAeF99236ugwON2Cwz7YZqk0mQuma0kbek
         nd+D7mghd2n2qtxceEpz2TACPTucPaLLur3h8NNt5VRtNzzUfq+IFBuTt6prLMVLlGqN
         OKQA==
X-Gm-Message-State: APjAAAVLtrR0VJDHKB4/b4QcJG8YuH3jWr0tII4wB2Pcb8olAi1j4TMW
        KRXODEaY3lTWw7obqszNjCk6x/glf1+RUPERSZY=
X-Google-Smtp-Source: APXvYqwh8CC1aqTanSwOfo6II1YV85D/1s/5bmHuzrM0i6+yY2hW9MJKAFrAqH67oZiTr2Ba7DDxcWjpFwPB67+5i3c=
X-Received: by 2002:a63:8743:: with SMTP id i64mr15210415pge.69.1551645959687;
 Sun, 03 Mar 2019 12:45:59 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 3 Mar 2019 14:45:48 -0600
Message-ID: <CAH2r5muWo48Y=xF1idGqugMpDyoUeWs+ni2RKTfPvGvjypngaA@mail.gmail.com>
Subject: xfstest 112 fsx aio
To:     Long Li <longli@microsoft.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I do see a failure in xfstest test in last two runs (in the Azure
bucket (http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/106)
although it used to work (probably Long Li's patches are related) -
the cifs testing bucket passed.

Let me know if anyone spots what the problem is.

-- 
Thanks,

Steve
