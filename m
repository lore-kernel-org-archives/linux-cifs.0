Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F93BC433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Jan 2022 02:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbiAICm6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 Jan 2022 21:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiAICm6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 Jan 2022 21:42:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46278C06173F
        for <linux-cifs@vger.kernel.org>; Sat,  8 Jan 2022 18:42:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4300D60A1F
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 02:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9678EC36AE9
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 02:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641696176;
        bh=HEq8nbV6aAVfVjeJ8hiqcXhlrzyl2VPYDIjVNrtxOqY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=hUdMHuM+kIvgkW2+a89j6BnrzigpH8XhtChEtAzhcKOURkT9rjOHum4jIQAl8nFDr
         TQVkL/Jqyvt1wt56A7pPpoymOaFK8YIsdOQoVf1PDHbUAti8jCiZRN4LFWbDL1Kp1U
         BDXP/bHKCj4chEwa3YsCthZ+brelHjaA2ZXgequ805jHQK3c7q/kC+GdnpC/i0AWEU
         uOVSmcZRCiiTgiNFJF6KzajfnbPhPKiL/o+nMbGXSRS1W6QKjBpKWVO5vT3O/UW6FS
         YcLEcE7mLxAgC/1ral66zNrScPYUaD4KkdwMRIs3pnBMlc0qZGk5Iq7DC/7TXr+qo4
         wNMTVfCgUWjAA==
Received: by mail-yb1-f182.google.com with SMTP id c6so26462238ybk.3
        for <linux-cifs@vger.kernel.org>; Sat, 08 Jan 2022 18:42:56 -0800 (PST)
X-Gm-Message-State: AOAM531bt6oi91qYlXjQesyOndszYF13Oc9Vogmd2MGj9bbHKikYjQLk
        pJa+BFR1CGK9mV+xy5yRA3hcIjin+kUgZX1GSCc=
X-Google-Smtp-Source: ABdhPJw3BHKZbFUc1ogKz2MLrB2k+CPx7HUbvZFmIdQldTJxHkOGLYJeiX5A02UP8JWC9JizYk5s3n/t2H6LCR+UQW0=
X-Received: by 2002:a05:6902:102e:: with SMTP id x14mr64612288ybt.265.1641696175707;
 Sat, 08 Jan 2022 18:42:55 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:5011:b0:123:6c39:8652 with HTTP; Sat, 8 Jan 2022
 18:42:55 -0800 (PST)
In-Reply-To: <20220107054531.619487-1-hyc.lee@gmail.com>
References: <20220107054531.619487-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 9 Jan 2022 11:42:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9OBsUrFv5KjZ0b-6-N3-DE9Tz0e+5kcEhXtEjZfXHRPw@mail.gmail.com>
Message-ID: <CAKYAXd9OBsUrFv5KjZ0b-6-N3-DE9Tz0e+5kcEhXtEjZfXHRPw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: smbd: create MR pool
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-07 14:45 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Create a memory region pool because rdma_rw_ctx_init()
> uses memory registration if memory registration yields
> better performance than using multiple SGE entries.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
