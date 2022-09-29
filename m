Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93408C07E9D
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 04:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiI2EnE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbiI2EnD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 00:43:03 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BFB128A0E
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 21:43:03 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id j7so315014vsr.13
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 21:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=WZtl3aoYvjFfRk6AUSjkZ9GScBcr93XiCoNdHcJK880=;
        b=c78YexJ2XwpwlIZ/WxBZGcWSNRMZaiEohrHd4s2Dj5v+cGwdh+L3bmgL7QaIDaALnI
         0Y1xs5kWuImABqkv0u8chd+p/N/PiG8Q5dcR2FPAuK6/VQ4FpAuYuwcRAWjbu1Cykc3O
         MmtWr6jrHssOCe5YU8zeS9VOJHwiLKjGIDsl6qP+Mj2UQxUQs+pw5PWmywPTtYhwRkzU
         ZPbMcLEjR684+yMcqjQwdm71cMIz2S0gR3/1vFFv4VGFgK/ksyTuAO0a95e/pEriNkSe
         dK79uFdOqX18bAl3jKk188zYyShXBXIxxrMTZOXMyhK6PqzL15KHlcKwVSDM4UE9VyCm
         Q50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=WZtl3aoYvjFfRk6AUSjkZ9GScBcr93XiCoNdHcJK880=;
        b=ZBjfLewq1UJWJhxS8yYrL2XyMTIgUPjkeGhlDIGuZvSwYC4seHmgW7YO02jbAhgK/s
         O1RMlYDGodNDusv7eRRc5Jo9kMcWWuvISfgiwQBe8y0ig12jTZ04q/m2tP+kIsmZMCwt
         QFVIP/fSGKW3/fxMf1vkqTn0Gdp7OZVdEoQuxZegQnXX9iwcE4LIa451cJpv9tAgctNa
         lsZg2xsbUIxAAeWk3DU2dWB8nRk0za0ODJtuKXp3OE4B+RJFKrGf4rWkGgwGVySQu2Bx
         J1waK4lHjmvsLLadZhdgFQJaUuAeyrQ7QDSyhx2cvLzaFQQnLcVBpkwkL0TxUvE1KS+X
         dN5Q==
X-Gm-Message-State: ACrzQf25ixVMCuy3szlyVTn1eVsBurVlJqUo8NHxfN1U1yTTp+ReH/oS
        TjTFKK9up5nmwY8wE+CiUEOlKDNkRzqC6+tTRh+DtUEILD0=
X-Google-Smtp-Source: AMsMyM7o7n1eMksc4bBMkyT90uL/sFZivxAnyoPxNcjd1WFNGnvIyHr41RTv58uxSLHQe3TiO0wAIJMpVArSb5VBHq8=
X-Received: by 2002:a67:ba0c:0:b0:3a5:ebd7:ccfc with SMTP id
 l12-20020a67ba0c000000b003a5ebd7ccfcmr397596vsn.6.1664426582314; Wed, 28 Sep
 2022 21:43:02 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Sep 2022 23:42:51 -0500
Message-ID: <CAH2r5muXa4pn4EYcW6quTgn1o++o6DYxAckpT9=CsRmcPKGL7w@mail.gmail.com>
Subject: cifs.upcall debugging
To:     Sachin Prabhu <sachin.prabhu@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This had should useful things about cifs.upcall (and an earlier one
about debugging cifs.upcall problems e.g. with krb5 mounts returning
errors)

http://sprabhu.blogspot.com/2019/06/howto-cifs-kerberos-mount.html

Shouldn't some of the cifs.upcall debugging info mentioned in an
earlier blog post be also added to wiki.samba.org ? e.g.

http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting

Any suggestions on how to debug cases where klist shows the principal
but cifs.upcall can't find it - see log entry:

get_tgt_time: unable to get principal

-- 
Thanks,

Steve
