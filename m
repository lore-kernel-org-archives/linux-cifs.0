Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EEEC43334
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Jun 2022 06:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiFTGNn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Jun 2022 02:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbiFTGNl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Jun 2022 02:13:41 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035836146
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jun 2022 23:13:41 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id o9so4358173edt.12
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jun 2022 23:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TQ4cnfsz5QzuT8KE3wqBmVlwzjpzu0jxQviuj06Q0Vc=;
        b=GeBKO1Xik+i0k0rALB7H0AVvNn4UnckHPTPF0uO9rT3IaaxNQPjmgTdgDWWxyfP62s
         E1jmP/e3GC+f6QFMXvFf4WiQLIGRFffdtP1P539Z+9HolPAnPL+jgNpqzHnJgYA0JePW
         a20QjqQ6qInQ6FXXh/wpC7hZvCWoauY0NVj9KcSLWdp7zHfeNJtU8hhRP4idfsxvFs6/
         CNfV5NfN8P45H9zf7vBKPe/1jLSHVhgJm/M+a37RZqmtgiyisQfWDWAVN4NTkyZMkwrP
         0cBkkBJ7M1vUVzUFBLc4v35Y6mpDvvrdc9p3A7qo4sO9SfBdHe2xeoSUOAgJAN5o0Qtj
         h4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TQ4cnfsz5QzuT8KE3wqBmVlwzjpzu0jxQviuj06Q0Vc=;
        b=6OkT865kuNqI1pokmzrjwvLgcqY354uhQdp1+E0eIsh3asfj5pg96KpzIkqsycsxyh
         sDRT35ibTEekRDLfOmROW+DvlK98iMtyxleHMJRIKXJ3JHwP97mI2uc7zzPcIX0+mxY+
         lAIh4lllYAdmYwDSOR0+gPhEut2jTE0eIF9ie3OmB/zxfTcN54fWV5zX3CndzyBMd5Gk
         wAw+mJNr6/hZVdZ+Ji3KUFP1FuR+KK3ITbqrKctwDma0HGRERjMvABDaz3pRV30tNYLd
         fCe/4tDI0LRmtm9D4260v068dzySjR+e3tdLjwCB4PIB2Fj9OZxLqmvciXIsdUf+Ifwc
         gMAw==
X-Gm-Message-State: AJIora/4uxqQTaVtTgiUyx+MtjOU83o7Y9sVnrZSrXgPU/sVNkFCcshk
        G6JT6ADxt7QDo8Sz6E4sIkBm05GqlTkdOknanwsPEMlJsGs=
X-Google-Smtp-Source: AGRyM1to17XgIm9FwTFtdW3yXtND+nChwsLmye/BlVLZVHV/2Qy28NOFxHuNsLNtjiMWkKfmTWxd0adqfl9b9LCo43Q=
X-Received: by 2002:a05:6402:e9f:b0:435:644e:4a7d with SMTP id
 h31-20020a0564020e9f00b00435644e4a7dmr17907827eda.114.1655705619461; Sun, 19
 Jun 2022 23:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvXJ6cjpeHPJY+V4iHVUUFckYvFQ-CjHf-fAb9ZLjRrfw@mail.gmail.com>
In-Reply-To: <CAH2r5mvXJ6cjpeHPJY+V4iHVUUFckYvFQ-CjHf-fAb9ZLjRrfw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 20 Jun 2022 11:43:28 +0530
Message-ID: <CANT5p=rBWA1t2T9MAfJYLbdg+eY9wy3-WH3CnWXGw2imH8nV1Q@mail.gmail.com>
Subject: Re: [PATCH][SMB3 cient] fix error connecting to channels (negprot failure)
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 20, 2022 at 12:08 AM Steve French <smfrench@gmail.com> wrote:
>
> smb3: fix empty netname context on secondary channels
>
> Some servers do not allow null netname contexts, which would cause
> multichannel to revert to single channel when mounting to some
> servers (e.g. Azure xSMB).
>
> Fixes: 4c14d7043fede ("cifs: populate empty hostnames for extra channels")
>
> See attached patch
>
> --
> Thanks,
>
> Steve

Hi Steve,

Thanks for handling this when I was away.

Regarding the change, it looks good to me.
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

Was this the cause for failure of cifs/104 test in buildbot?
Is that test passing after this change?

-- 
Regards,
Shyam
