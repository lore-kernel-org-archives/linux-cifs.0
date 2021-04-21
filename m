Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAFCC433B4
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 17:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F4A61164
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 17:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241450AbhDURTT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239774AbhDURTT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Apr 2021 13:19:19 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4FEC06174A
        for <linux-cifs@vger.kernel.org>; Wed, 21 Apr 2021 10:18:46 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id m7so37777125ljp.10
        for <linux-cifs@vger.kernel.org>; Wed, 21 Apr 2021 10:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=xhbE5Y+Q73HxpuNvlnsrA54suBX0vDBfs6mkhYk+UKQ=;
        b=Kod00dR6mB6Qn5e7LVZJ69wpoZgunY9RisUMi6xSY4jnUtTimaHaf6D2FzZb5NJS0L
         2sNdUTevLa+k0aarm+6bsphDdG9/Pik8TgtKAHFo0GLGODReYbjKu3ChXphkKReqrXtA
         CdJmO2ivavSTK1Xjsb8/UHwmYLZlcR7xpDA+0Ob31zxGrky6VBRMCabaErqg3Hl4X7+J
         A2Rnaws55sYmULHvqxI6Yb0Qz8dyJerFkWQBQb3e4wsx3jbvh5hZ6iU/Ze1SaLaqryoc
         Bk4sivIErMf5JiH9+Z/roDjRQrLOTFcqZfugkZL5aeIuEr4QUuHkYMK1g0kEvpFcYFcU
         9xnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=xhbE5Y+Q73HxpuNvlnsrA54suBX0vDBfs6mkhYk+UKQ=;
        b=Co/ZB36Lxq27lasWEl2DawowtgXNKllavC1ryX5W4gnFOa7cMOgt5g0q/Vw8zCzWLI
         inNeCAu8D1hmsqwYfUJh/oVFji83iI0VI2cCFhQQjcyq7FB5HsGBbnkwiZkFsdTY2Kb9
         np2Ye/DcqIRrjl4aVGcTewYkER1N75dfnzyrfqESyToYV2zJq/ccD+cTfziuboG1aOQJ
         +p2XsDgUU/H9pvQlXKnPazkVn42XeJziDbm/AU3qxakj0KSEZDxGYu1Dm3/8TKMt1xl0
         AlQUhJwKMHVhnBIYJwKICY2QiI15XaXvfcWUkHoqj6l7XmSh6SDSNpFiejyC6qWlE6ge
         fnPg==
X-Gm-Message-State: AOAM531N3lyzCwyCyhP0YMIAOD6bWQktZ9Aps+cOudLLLO9YCmHerwUh
        vKJipxFavSwH2kErOPgYDWrfhSaHj9olRn8V8a6yHhd6aZY=
X-Google-Smtp-Source: ABdhPJxlKoNZca8UuM/dywpMh47JqX6v7+L9JI8GwXsc4zq/lC3UEZqaoHg+foA2Ra+Fu7BuPNZf9bJJNmlQ2zF23Pc=
X-Received: by 2002:a2e:a78b:: with SMTP id c11mr20321939ljf.6.1619025524120;
 Wed, 21 Apr 2021 10:18:44 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 21 Apr 2021 12:18:32 -0500
Message-ID: <CAH2r5mse7yH8VxL4x3bRz1qe2K1p69mo6ApMZzQH_v8ZLpy6kA@mail.gmail.com>
Subject: ksmbd testing progress - buildbot run passed
To:     CIFS <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net
Cc:     Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Current Linux client (minus the deferred close patches) to current
ksmbd on 5.12-rc8 as a test target passed all tests:

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/32

-- 
Thanks,

Steve
