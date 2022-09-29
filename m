Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F0CC32771
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 02:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiI2CEs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiI2CEr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 22:04:47 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CC42FFED
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 19:04:45 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c30so140065edn.2
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 19:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=/yHVLslIoG2pMXCC3OpznnW0OduKxcgAXeZpNpyIO3M=;
        b=T2iicewx13NGvc21h+tqZuPC7BQShM6IpWUNJnAu5hvQ5kFhldsSMfmAtzsEF81woP
         pi2ukhSHk06xzRkLnK/MRdiSKghFyJv7+dUXa4lupkNbCB9afXrsAmL5+DJiBkXE89RI
         +vQtIiHab4Xy9j+Dzn/170rY7e+2oIhilo73WfFdmyDwCqH+4AexOJ5e8oN9ONnH/lE0
         rMXVTnZ1MROGiczz2Xt9nmlnTWK/6rCMWddDSh0zfcbXtAxWGcl0izrC/mgT5VwPbcQX
         JJ39lDXszET5n6g5YqT2h+xKcFTATYc7e3SUFsd0UbfkmyDxfJxIr1lfJSh21MGLF0bO
         gejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=/yHVLslIoG2pMXCC3OpznnW0OduKxcgAXeZpNpyIO3M=;
        b=1xQPP+4AEfBeqloqpjRA18rDwLiqCLGuLRHm8OqIpfRPqa5deMj/qcS2eMQdah4ppN
         dXXYNB9Wr3eQcX+PlsNj4iBPT2qGwph9BCpEnVjlvzRQOD2/WIiBW6MZX+42/Fr+CDKG
         7NNrP1T7DpKpneHCeMbawUq4Rnq0mz9GV2kxGVm4azioMVZC0Eok3EQqTm9FQndrsmoP
         NKkft1V4O5pMK+VCAyT/jN4Zas7z29g2jxtQcS5tnGSVNUmc4r76uPGWxvFnWRsH86Qf
         vQ9L0KPtxBzwYh6qaOMuBuDPSUq6amT0cECPizxM8RLy8AASku5PdZUOv6TG3aKS4mE6
         B1eA==
X-Gm-Message-State: ACrzQf2uxIqR+2CtYzHRSOIQfDUUIYlCtLkBAR07oeknKABWWNZrDFn8
        grR+LMXoh1xNf9IROkjPvaE/iwk0UMFMIzTcaYieL1pN
X-Google-Smtp-Source: AMsMyM6KAwLmu2Af4QbtenE/Xd/kgOaLiPyw0KtGSMESjYT8NtdWa8WlkEUbrX28TUR3gHBXKkMrMaYlIC0iqUVCESo=
X-Received: by 2002:a05:6402:1014:b0:451:d2a1:236e with SMTP id
 c20-20020a056402101400b00451d2a1236emr962654edu.212.1664417084414; Wed, 28
 Sep 2022 19:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtg603usx5f=-+U6S-Lv5oWKjoxFpmKUC6xMq-XB2gTxg@mail.gmail.com>
 <CAH2r5mu2aGmf0uM6GBAV8zhA2rUiJ_nJ1CEP631J+KrWadOeLg@mail.gmail.com>
In-Reply-To: <CAH2r5mu2aGmf0uM6GBAV8zhA2rUiJ_nJ1CEP631J+KrWadOeLg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 29 Sep 2022 12:04:31 +1000
Message-ID: <CAN05THTN24JMTgsthX3fghkyFDEjmBOH9qpqCpennPXEb+68pw@mail.gmail.com>
Subject: Re: Buildbot: builder cifs-testing build 1038
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 29 Sept 2022 at 01:56, Steve French <smfrench@gmail.com> wrote:
>
> ---------- Forwarded message ---------
> From: Steve French <smfrench@gmail.com>
> Date: Wed, Sep 28, 2022 at 10:16 AM
> Subject: Buildbot: builder cifs-testing build 1038
> To: ronnie sahlberg <ronniesahlberg@gmail.com>
> Cc: CIFS <linux-cifs@vger.kernel.org>
>
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/1038
>
> Theories on the xfstest failures with the first five of your six dir
> lease patches?

Interesting that the git tests fail.
Remove the last patch you have in that series for now  and I will
investigate it in a few days.

>
>
> --
> Thanks,
>
> Steve
