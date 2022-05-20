Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED5BC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 20 May 2022 08:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244210AbiETIhL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 May 2022 04:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347040AbiETIhK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 May 2022 04:37:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D52A9D4C2
        for <linux-cifs@vger.kernel.org>; Fri, 20 May 2022 01:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD31E61ACF
        for <linux-cifs@vger.kernel.org>; Fri, 20 May 2022 08:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA01C36AE3
        for <linux-cifs@vger.kernel.org>; Fri, 20 May 2022 08:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653035829;
        bh=hhWX5UPZ8PRN7Xl7A1XP8g0vCgfDbhcqRh3/Nq1D++8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=VTgA6gB+Mn+f/xCxoAa89JhXAD/XnS/ca0qB0PP6HpVmC09KkOH6XndnNdKA9riSN
         s5MjxabH+/fsD+dKgQ0J/q7sDOQdV8zofvdmcrkXc3kgUHh1uEzNlzqFEEVGNvmOFx
         yuvBuiv7Kj67tiXOZvccQ2K5bjidwTx0K2T9nFC/Z4LImxsT1JSRGEJnjApy5akoOI
         fC6DaAzCjISsAiTQX/9AeBOUviLIRc6MiCYkKP7/vZ2v8cist1+8T0vjyFxlNlDAVI
         G+f52VW6q9PCe82IQE00xPZ/OoC7vDbT7NyQjMhfo0kvMGBV+RfFqDxLPfcm4wxGB8
         gsu0CkUFh607A==
Received: by mail-wm1-f41.google.com with SMTP id bd25-20020a05600c1f1900b0039485220e16so4667080wmb.0
        for <linux-cifs@vger.kernel.org>; Fri, 20 May 2022 01:37:09 -0700 (PDT)
X-Gm-Message-State: AOAM533dr5z7pm6SdBhWLVEECMw2ERLQD/1uUKziYbrW46RPQ7C/aAe2
        +V/VMUoi58WBd6RGSg8ZbjGJIXroXB9MOPAT+KA=
X-Google-Smtp-Source: ABdhPJwQya94EsDY2Iq88E8sO3YmfWS7p4qsvDyaH2Ajitsp7p5hSz65dA/1GDpfBJNVAaGSaUdwEwWJGcOm8H2Orlo=
X-Received: by 2002:a05:600c:3b11:b0:394:57eb:c58b with SMTP id
 m17-20020a05600c3b1100b0039457ebc58bmr7565293wms.3.1653035827378; Fri, 20 May
 2022 01:37:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Fri, 20 May 2022 01:37:06
 -0700 (PDT)
In-Reply-To: <3738077.1653027611@warthog.procyon.org.uk>
References: <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <3738077.1653027611@warthog.procyon.org.uk>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 20 May 2022 17:37:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8DsN+KH8jTaNBn0noRGd=f6rwmgfDj-DAq9+iqdpOZ-Q@mail.gmail.com>
Message-ID: <CAKYAXd8DsN+KH8jTaNBn0noRGd=f6rwmgfDj-DAq9+iqdpOZ-Q@mail.gmail.com>
Subject: Re: RDMA (smbdirect) testing
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-05-20 15:20 GMT+09:00, David Howells <dhowells@redhat.com>:
> Namjae Jeon <linkinjeon@kernel.org> wrote:
>
>> You seem to be asking about soft-ROCE(or soft-iWARP). Hyunchul had been
>> testing RDMA of ksmbd with it before.
>
> Yep.  I don't have any RDMA-capable cards.  I have managed to use
> soft-IWarp
> with NFS.
Ah, I have the real hw, so I haven't tried it. I'll do it at this time.
>
> Also, if you know how to make Samba do RDMA, that would be useful.
As I know, samba doesn't support it yet. It is known as in-progress.

Thanks!
>
> Thanks,
> David
>
>
