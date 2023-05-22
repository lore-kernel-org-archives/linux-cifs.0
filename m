Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFCFC77B75
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 15:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjEVPgS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 11:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbjEVPgR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 11:36:17 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE37CE
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 08:36:16 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-253724f6765so3650902a91.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 08:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google; t=1684769775; x=1687361775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rmBIymWQFv7eUJHkKnBb1WVUgTxwoZiRvWkcw9OY9Y=;
        b=krCTsnO8F8/nRYMK19QmZgZgoHDaQk7UHRch6knvztPZeg5eImdURRZydEUtyA/zCc
         gEa5QX5uT0hC2u/hgTQ/eOlUPvvapm0WytES8AkRkOdUrKuuHRmbhFSD1GveWjSSXHjR
         qPHhOvtSjJKYcNnRHgW/42JJag57mQtgftXk0KSm6KczNRncN/1xnOne9fPmsOkoJwKu
         Q+iwJvXtAMdF+Zgv5+MSjAr9CAbBAdBRXozhY3f+gCYv0cly+kshMpnR+vHMnqHLC8od
         H2QrJHzPA3g14ozSHOj5SNWiVOxl8ZG2Y0rQPVCpOyv4iNOsSGwbLM3XmhhrpC18VdTb
         /yKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684769775; x=1687361775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2rmBIymWQFv7eUJHkKnBb1WVUgTxwoZiRvWkcw9OY9Y=;
        b=I8spffDlEt1uQ4H1SGKZV6We/h5B3pbhExPjiY+TC/d2HeA+J/fyx/Mk81JwWqSIf1
         Un2IT24PZ6Pv35yo7u4MoICu0HgZehBFLXi+DRLlNcgBsPCSCLsJfn1ZxMUoG5QRmU0r
         Wr+MmXzxwL2CZ1bRywTfK6POT/LCO/F3eIaON39f8dGh02kqENieFDY7brjPR2Ytfar4
         pXt4f0/YIUWCtZcKCTZEDMklatpG0gRtGl9fwSEuqHIXJSHhiH76JXl6F/fB70yOgLkl
         12Xda1QPNz3j9Vo8/vdQDc0mKmGYykHa5UkQscDy9sUQ5Sr9qnL0h6RxS8xh2rSpNTOm
         8dSw==
X-Gm-Message-State: AC+VfDxRqhA13+u7oL/CKGtXFpQt/141DUr9/WmunWC5GPNyv6a5BO0E
        SynUeV23lclj5uElygW3c8FnKLTGfVOy3fjCKtDU7g==
X-Google-Smtp-Source: ACHHUZ6A8nOc33wxc/cfU+Vworyh91nsY0BRe5qj3zNu9LI6QXxdZ05LHodivHyS4CTHZjYoCSMzlSrru+j0q1YeNk8=
X-Received: by 2002:a17:90b:3ecb:b0:24e:5344:9c9d with SMTP id
 rm11-20020a17090b3ecb00b0024e53449c9dmr11099441pjb.38.1684769775492; Mon, 22
 May 2023 08:36:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
In-Reply-To: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
From:   Andrew Walker <awalker@ixsystems.com>
Date:   Mon, 22 May 2023 10:36:04 -0500
Message-ID: <CAB5c7xq3dZ6yh6VXKGoJD--gg41rMgZ_u6RJYGMyzc6SE78UgA@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Steve French <smfrench@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, May 21, 2023 at 9:08=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Looking through code today (in fs/cifs/xattr.c) I noticed an old
> reference to returning alternate data streams as pseudo-xattrs.
> Although it is possible to list streams via "smbinfo filestreaminfo"
> presumably it is not common (opening streams on remote files from
> Linux is probably not done as commonly as it should be as well).
>
> Any thoughts about returning alternate data streams via pseudo-xattrs?
> Macs apparently allow this (see e.g.
> https://www.jankyrobotsecurity.com/2018/07/24/accessing-alternate-data-st=
reams-from-a-mac/)
>
>
>
>
>
> --
> Thanks,
>
> Steve

Another issue with exposing ADS as xattr on Linux is that VFS caps max
xattr size at 64 KiB. I've seen MacOS resource forks in the wild with
sizes of up to 3 MiB. FCNTL sounds interesting.

Andrew
