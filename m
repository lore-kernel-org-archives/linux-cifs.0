Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D499FC38A2D
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Oct 2022 02:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJVCuJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Oct 2022 22:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJVCuI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 Oct 2022 22:50:08 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2477F1743C
        for <linux-cifs@vger.kernel.org>; Fri, 21 Oct 2022 19:50:04 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id l8so2037542vko.11
        for <linux-cifs@vger.kernel.org>; Fri, 21 Oct 2022 19:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P/ciOlsg0or1HetACIF0dIVfx/1yvu0iVTMb4BdT4RU=;
        b=KrIlFN6S+AMhYP3cUWhrU7SiN3oslyRSNzZM8aXL3wKgIR0C92b5OY2nuRTVyACZQD
         LrsMIAjx5B4BefEVgZXhW3lCpmpsTo/xkbKH4sjzer/IfmTdpkeh5ZWab5dZNvZa05k5
         zMUFZusYqzBimkcuhwLrfWT56UWvo5q2I/wxTSdV8f/ri33mcwTf2xjaz6QtqpOsfd2C
         b/JDS+W0X3I0Jp1FcmbqIeJGTDQjP5tUdcSkClaRVS2c1XtIBOxbJhcSi91WgVcHvIvE
         D4b4adiuuzH0eekzgnVDpI5GrY3hCjSPn8VUX7K2tKk0ws14236mcbxDpeHBL3dZqJs/
         6YXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P/ciOlsg0or1HetACIF0dIVfx/1yvu0iVTMb4BdT4RU=;
        b=aL6u3jLLUi6LJs47zaghY8AfUH92hUIKhxxMiIqEmQFAY3ulqSRmWV/FAXngetNoAv
         4RfSIVfcQwjjtj6QkrmTfwWQ1rHuoTt0tA5B0quRxSjdUhG+Ix1iEiAQEDbMbQL0LRpR
         bNKvA6uCFsIEohf+KTwKpgDaM7NaPr0Yyl+STo72sr4FS06KqMUgCRw0C8K+pjB0U/oz
         6tj/OBXkO4H2xTrnfFO8KRF+nGyyewO/FOJxC47zbl+K71V5hH4u1s8UzjhEVbyKauBX
         KeTROvxn2xrPwEWWnI40J7/kSheRDyAuIse7zgHI8jTecLpIBywVUkcg/x24cCtgOSKO
         nZ3A==
X-Gm-Message-State: ACrzQf3bAsHjtMNj3ld13AQC3ryEKK15rJEaA/M3Ax+DW2zI9OouL9BQ
        EmIf7t5Ejnfkqic05ieymnIeDml1sZ3zlDf5EtCxWBEM1LU=
X-Google-Smtp-Source: AMsMyM7oGGVgK0I8b1glL9bzhAlrGgGa54JgC3Ka26QwvgFWkDp/jSCIFoiX6jL63fToVg4YvSKImGj0dhj6cfQkgc0=
X-Received: by 2002:a1f:d583:0:b0:3aa:9112:570f with SMTP id
 m125-20020a1fd583000000b003aa9112570fmr14162441vkg.3.1666407003109; Fri, 21
 Oct 2022 19:50:03 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 21 Oct 2022 21:49:48 -0500
Message-ID: <CAH2r5mteAkioMJWfQG9MpZym9-Co1uAetebe91ENnJ3ryKO69A@mail.gmail.com>
Subject: vfstest idmapped mounts
To:     Christian Brauner <brauner@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed test generic/645 is skipped on cifs.ko due to
        "src/vfs/vfstest --idmapped-mounts-supported ..."
returning an error for
         generic/645
casuing
         [not run] vfstest not support by cifs

Any ideas on what it takes for a filesystem to support idmapped mounts
(in this case cifs.ko)?

I see places in src/vfs/vfstest.c where it is checking for
MOUNT_ATTR_IDMAP but I don't see filesystems checking this.

Is there any more info on which filesystems support idmapping and
examples to look at to make  sure we are supporting it properly?
-- 
Thanks,

Steve
