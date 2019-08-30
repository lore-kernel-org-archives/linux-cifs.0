Return-Path: <SRS0=0p8I=W2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702ADC3A5A3
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Aug 2019 03:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D0B721874
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Aug 2019 03:57:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AaMSga96"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfH3D5o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Aug 2019 23:57:44 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:37058 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbfH3D5o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Aug 2019 23:57:44 -0400
Received: by mail-io1-f41.google.com with SMTP id q12so11377056iog.4
        for <linux-cifs@vger.kernel.org>; Thu, 29 Aug 2019 20:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZtrtGi67XZRSYvAJ3NC525RZ+VC3ah1DJl2ka8PlaJQ=;
        b=AaMSga96qO3g+tayPze1szY9DJ4OQjsOfNcJbjsfJmBcwa2vzRrPOe3bTs4NRM/2ym
         Bo3DSk7cWMT/Zix1c0SL0HS4Rtb3bsUiX2QbQhW2lBw/87yWpzcJktWyN/MwjK1gC+gN
         2RnIIC5QqhgvJYoHe19emIDzZKEM8NtNTz9NZ/7JHg4Vqv2r2olL2IrG57Bui7azGW+8
         3wobk1BcrUqJ6LT1jIR4GISGjP8AhPBM1MuZJqCET53UVW7JUvBdEwjC8YlNe5EOMLgn
         KCu7m3ls9bdprlMa1v9YFLfb/GONpSv6M4na7W2URG+mOnijfN2GK3OgnYX0hp6tB+ri
         US5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZtrtGi67XZRSYvAJ3NC525RZ+VC3ah1DJl2ka8PlaJQ=;
        b=jm5I+dzjj9WhXoeDGZRifgTAdK3DRyHAc8BE6ws/bfX8EYLdZWQ1NE7OM7S5TW5COQ
         f5Az3/hqrZ0Le9tgv7cblYJ2RBV7VWU9/WETr5LEmBQ2K4tF9n+JE9aHsW26WbU1qhuv
         ZplctL/p9cjFraU2zRdAyK4OgFQrTC3n20eZmx7+VfSWsp/Nxo10E8pixhcstx2a7XpY
         LviPS6cM/BHe5DRQhWmPRB9PwMO6ZG2BQZalcG+ogP/TBhsmwbFEfgBi5N/T2taSlq19
         o/KGt9FHP9bQSJ562MH4P3+LHSecN4y/UuI5VdpfHNwOdvn6JAoRmYks7VhZ86/bP7bo
         h+9Q==
X-Gm-Message-State: APjAAAWTj6b238mST0rslU/f9KdFwp12eJLqgYvvHcpPHeMRLfX658yI
        uS5eUWNvivU8yS46y+Uw8UpaPUbbaAdt9oyK7t8ooA==
X-Google-Smtp-Source: APXvYqwKv6GBpprmgaOoHwJ1XBGGNAkHyeAieFA0eW18O/iGK2Ga1LboZ3GL9xjYV/93K7jIT3Lhxmzi9oOhm22Pwb0=
X-Received: by 2002:a6b:be02:: with SMTP id o2mr5286009iof.109.1567137463768;
 Thu, 29 Aug 2019 20:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msb7OMdV4FnVYxFZXT2ppm=rv3V9b_1ivfB+jZN-wM75A@mail.gmail.com>
In-Reply-To: <CAH2r5msb7OMdV4FnVYxFZXT2ppm=rv3V9b_1ivfB+jZN-wM75A@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 30 Aug 2019 13:57:31 +1000
Message-ID: <CAN05THSgOnmOykm8kR1cfUpoS1kgmsgLGumwgYREX6dkeb6v0g@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Add more detailed log information on cache=ro mounts
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed by lsahlber@redhat.com

On Fri, Aug 30, 2019 at 1:40 PM Steve French <smfrench@gmail.com> wrote:
>
> Make it easier to tell if the share we are mounting with cache=ro is
> considered read only by the server.  Obviously there are cases where
> the user could know that no one will be writing to the share but this
> additional information could be helpful.
>
> $ dmesg
> [374786.661113] CIFS: Attempting to mount //localhost/test
> [374786.661130] CIFS VFS: mounting share with read only caching.
> Ensure that the share will not be modified while in use.
> [374786.662199] CIFS VFS: read only mount of RW share
>
> [374793.473091] CIFS: Attempting to mount //localhost/test-ro
> [374793.473109] CIFS VFS: mounting share with read only caching.
> Ensure that the share will not be modified while in use.
> [374793.474266] CIFS VFS: mounted to read only share
>
>
> --
> Thanks,
>
> Steve
