Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDF4C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 00:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FCB6613C8
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 00:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243393AbhI2AKQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 20:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243331AbhI2AKQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 28 Sep 2021 20:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58455613CD;
        Wed, 29 Sep 2021 00:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632874116;
        bh=Yz6ymVU7cTJ4u+rGuKK394k0z6PZYGEQG1U2TC4MqSc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=AhBgxiBGi8zGMQVP7Q8ZMUQ4F9AdlYKwy3ySAQZ4xVQhjYcgAGo8XWTpQ3aYjjF2V
         f0abswTJAcPesVCF/xmX2JYHqjBPNh2gYBPU9BYu910R3o7iKaANkFt1DbihR1gJtb
         EwABzojPIHmu5zRFOqSmfiS1n18e41jB8G5QhJuvf6JUm9IQiw8tQWTVcqfXphyKFc
         njxYzQHwTm7/nYn4s2LGHSFhDQbg002unHDtT/jP4eM8NbpgVrZQLPRKUwnn2A2fYi
         eKTNGc0bPIIz0fhHVD/vywf2+2Nnp5GHQ14fXd5eQRNCsPlYnueq/BlR4Awasjw/k6
         zBXXYqwu6jCCw==
Received: by mail-ot1-f51.google.com with SMTP id j11-20020a9d190b000000b00546fac94456so690457ota.6;
        Tue, 28 Sep 2021 17:08:36 -0700 (PDT)
X-Gm-Message-State: AOAM5316z8q6pbLTKq7fADwEvKg2m++kykTIUcqR9DxsB9wHlaL0IfFp
        5+Z+BZO0iv7JnUHHIM0gB2691dzcYk7u2+eA2qU=
X-Google-Smtp-Source: ABdhPJwxPMPdV1/HFmDUb6vrmv/TRyl+W0TBXZALfVKhpJvcyXmvZk3ZkXK4KVDsIdQ1tDSP2OCxGHsmaCXd5GCi9sc=
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr7316221ots.185.1632874115754;
 Tue, 28 Sep 2021 17:08:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 28 Sep 2021 17:08:35
 -0700 (PDT)
In-Reply-To: <20210928225634.28432-1-ematsumiya@suse.de>
References: <20210928225634.28432-1-ematsumiya@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 29 Sep 2021 09:08:35 +0900
X-Gmail-Original-Message-ID: <CAKYAXd82wCtdNOSzPu7LaivkGVga5QoXcHsU-z5KEGDd8R+o2A@mail.gmail.com>
Message-ID: <CAKYAXd82wCtdNOSzPu7LaivkGVga5QoXcHsU-z5KEGDd8R+o2A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix documentation for 2 functions
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-29 7:56 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
> ksmbd_kthread_fn() and create_socket() returns 0 or error code, and not
> task_struct/ERR_PTR.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
