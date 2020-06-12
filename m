Return-Path: <SRS0=RdgD=7Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C6BC433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 17:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD9E2083E
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 17:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCCw1xgm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgFLRPG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Jun 2020 13:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgFLRPE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Jun 2020 13:15:04 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CA5C03E96F
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2020 10:15:03 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dr13so10814294ejc.3
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2020 10:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1fkSUR6TThDTILf/6zeboEmMqmkvkgJxscOLVA2LLtI=;
        b=DCCw1xgmjr9NVDPAgFVCt+gZwo0oG2D8jUVMdE/ezHEKFXzYmyJ9v3T3yqPJLEu5Ee
         6EDlJNzq+NX9pg6iUxuN5DRz5j/l6iXwcmKW9lOfE3KOlkr9Fw87IUrPdEPHL64U9MGc
         fj9TiRmP5tgNOx8qNStWALZeTcnEVZW3AyGI0BgJnvKYjvgaGukAt3U6os40uFue8RJQ
         xfAdBJlzkCaEcyP/cyt2o+EzfloXKy0M75Ff58Wge5Es+6VGthnmwEXhPWsSPvD9kGOr
         84Q16xg6IOkb194IjqgJGybZsUenZ4TKlyrVTvunIJHaq85RflWxw8Hk5t2PlwZMSG+E
         DP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1fkSUR6TThDTILf/6zeboEmMqmkvkgJxscOLVA2LLtI=;
        b=WQKmY8MN0TS1YtmuSmG2UC2L5fhv37LnWK3S96OAjQ6C/4lJz4E5Kghz3g9taiLBVq
         /j8VMuuhCGWdyMtnIVbn9yYTcYznukBnVZp9J4Pvq4r40Hm4d6h90q/GTU6d46CaylNz
         d1e/VTRlCdKSk12TK3jhdPTICyMXgd0SuAvEzIqyr0PrIQmxFJuJmrxJ9PYAXk53GlgF
         ROEhUgzlebS/KOlU8AW8wuycVdECpbzBRpzBpErqFb4uHFki3/CuTtzXmw/+Hv6PLPSb
         MTD8q+ibGjH/h9ZZ0NIipXAIOyKwydElLDlCAEOY2UmVcJbGpXBilNZdTDZ/j16xdzkO
         L6CA==
X-Gm-Message-State: AOAM533rRlis8UBHAeXKJhfg5qSlDEEKRaG6rcocrvYWbofdo0uBnST1
        WjJASJ6f0tdDhmgavuLh5y11g95nf6NgVP4nIw==
X-Google-Smtp-Source: ABdhPJyKJM5TdC0RQt7IJg15vwnD75ShtFQ4RxM34krZTrwl1M6WC1oW607D9MDoJEM06VIq2hRyijWGEPnrGZYiw1E=
X-Received: by 2002:a17:906:95d6:: with SMTP id n22mr14062535ejy.138.1591982102639;
 Fri, 12 Jun 2020 10:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mupjgsgSbswUTGkB-62c+VrZvH+f3i8hubKT6n3fyvuNA@mail.gmail.com>
In-Reply-To: <CAH2r5mupjgsgSbswUTGkB-62c+VrZvH+f3i8hubKT6n3fyvuNA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 12 Jun 2020 10:14:51 -0700
Message-ID: <CAKywueQzC5Ljf=SYUte3O9rfY_YSvFZPAmY+VujK33WcEb=MfA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix chown and chgrp when idsfromsid mount option enabled
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 12 =D0=B8=D1=8E=D0=BD. 2020 =D0=B3. =D0=B2 08:40, Steve Frenc=
h <smfrench@gmail.com>:
>
> idsfromsid was ignored in chown and chgrp causing it to fail
> when upcalls were not configured for lookup.  idsfromsid allows
> mapping users when setting user or group ownership using
> "special SID" (reserved for this).  Add support for chmod and chgrp
> when idsfromsid mount option is enabled.
>
> --
> Thanks,
>
> Steve
