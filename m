Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA6CC4708C
	for <linux-cifs@archiver.kernel.org>; Fri, 28 May 2021 13:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F9B5613E6
	for <linux-cifs@archiver.kernel.org>; Fri, 28 May 2021 13:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbhE1NU6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 May 2021 09:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbhE1NUy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 May 2021 09:20:54 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38D0C061574
        for <linux-cifs@vger.kernel.org>; Fri, 28 May 2021 06:19:18 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so4563827wmk.1
        for <linux-cifs@vger.kernel.org>; Fri, 28 May 2021 06:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=KHEzGzFikH3SJu/Ybokc0k+5WV3q415kYZPdWrqOZso=;
        b=H03dR1LXW6MQ6j3G8ad5caLfZm9OTEC/mbRUNsQ5YHOtrd+hr93pWFgAG0xSPEOyhS
         j7Es9s7y16LUqJmNX+JT0RI0l1H78tFGMktN2twlRsiMdL4KwPJUFx5JPdRaKnmSmWKU
         Ad6vYUNbUgvN5VNGwo2xjsZuPU9kwsY1pLQkK6AMDzdNI7lI8m8hbogJPhFSQ/1WpKzD
         bc/3uw1F3X9lGDiw0MK2rwuDmjgZGx4cWwBwrtIi2FvQrlHFAo6jTBtlo1EtI1293h9U
         f+XdrOQq77mUEj60I89EhSSRNXNUU9QaglTVsKAcMREgKqUenCEysLve4F7XbYVHjD6J
         ed4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=KHEzGzFikH3SJu/Ybokc0k+5WV3q415kYZPdWrqOZso=;
        b=Od1jj/SEMKR5JBVml+AGpCfj40PvHeU8/WTH0WuumtoPukomJkVJqmIquLEn6iNcL1
         shw+Rteb2UkwxWnpLSPvC8idTtU0UBaoz5X8xBxeE+FVT9MozPQAtp9iw27E4sns6CP4
         RY0vL+x/g3RQ7vDqXGUvU1g4RYYiB1RmxRCYE7v/N98dbVmO4+4vrLZQKfA/dQH7NPdA
         8UcYbip0rQ+L4GrQZoOmfnHJ8Q9qOMvuFR5E4l+v/mPDaUWAKHGoFfd6lCRnJnnrcA7n
         VyfFB5OFi9qogy2/i4lQM4dt25BKLIFGpTAwLFm1Hfzge4PSOINMBT3SMfaOtDEwGohq
         yWwg==
X-Gm-Message-State: AOAM533IU9TgE/jdxRurImuL/2/2syQy4nF2zSovDk5ZnfXb8db9EJxK
        k01zlzcgTr/UyRphMfWuWFDr9sXfQb5G4gQPgZqKYFW1iZZZww==
X-Google-Smtp-Source: ABdhPJwbNy4fjw19/GEyGRT1AbsC0Ug0yJGoZKYc64X3LKU0c2CjdqYlI4zZgmEAsH/7oXLMplIka5LhieezJhxTiYM=
X-Received: by 2002:a1c:146:: with SMTP id 67mr12488473wmb.61.1622207956340;
 Fri, 28 May 2021 06:19:16 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 May 2021 08:19:05 -0500
Message-ID: <CAH2r5mspycFk02EzpqF-CT9GwG81VGYp+yQuHoyZFgUsJ1fhpQ@mail.gmail.com>
Subject: Current cifsd-for-next passed buildbot regression tests
To:     COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Latest ksmbd test results still look good
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/43

-- 
Thanks,

Steve
