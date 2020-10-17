Return-Path: <SRS0=jgI2=DY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26EACC433DF
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Oct 2020 19:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC7DE207EA
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Oct 2020 19:48:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/0jKPd6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439595AbgJQTse (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 17 Oct 2020 15:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439594AbgJQTse (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 17 Oct 2020 15:48:34 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B8FC0613CE
        for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2020 12:48:25 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id r127so7760433lff.12
        for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2020 12:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GI+YLGNINloFjcNe0NNffy3m2w+4Oj9fkPtUe9LWsFw=;
        b=W/0jKPd6FfYip5wSffNt7i/R7aHD+2OqZG5hBFA7p7ozbAD1Oz4yH6izyVmLthuvjE
         2KNzAoOXWdDI1XjVHTuPbivb+UsJjYw29WGVk7VW/7xPVDCFQnpFn+DRC95w8soqOr5+
         fhfVIhvyE1068VLgoVZbyQ7PdhH1Ugc5XzAUCDj9mxRgHMQp4UO1hV4b3OUjrgRFW9GQ
         nvHLtnNZnU57rDafJqZ7NzVFt2yzXzGoiRA5x8/wTQz3n1KVTzausEIg3bC+qdWxJG0+
         rjS59nzmmY8UFjTvc/AnMOIej8jFKFbqcg5xluYLCIq0+bnzPbzqwkDS3/QObSIjPnBI
         I5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GI+YLGNINloFjcNe0NNffy3m2w+4Oj9fkPtUe9LWsFw=;
        b=Jew37/pSIjT8s+3EocOoZZ7UONsBW0v6bC6rEDmAt+QYqwdkmC+Fxr5VR+1o33eG7C
         smLRmzR4BRTQw4ZHqU8YfsgEpM7QbQImpHfPFnkYBJi/U87PGdrM4Q3eLbwrOP173XeL
         WAnu1zWHcKiiqUcvpfXXm+nTWPPw2ZNmQO6yK99iAG7UdMA9SWnCAP+BGjAW8aRQOt4T
         7azHw/72qj7YSym6sexGuoI5yzTnZh7GWgZjDYrOjmvF+qRqzSlZ6p+3Awxl0h7fbv/d
         eU+gEjk7iyFWvG7MZtrIV8aVB51losl3m2Fgekf9DwzHo/rLee0MUyjCDDVsyAxvwK9Z
         ScdA==
X-Gm-Message-State: AOAM5314cF9IFhAwK4SLvYH8rF2HypwgTQfWSsel2ob0ZL7B+cWPJ1oT
        KQ4ayEyxx0D6W6DBeA2o/CVLcAn7fZGsseqM0Gw=
X-Google-Smtp-Source: ABdhPJy9G8/WOkyiJxlF3Aq0okkUyXr7gn0VH74xCz9dFTXvqR84R52Z/XhQjYQGj+Y7kRIrUnq1hIc7IVhDLPb9Cjs=
X-Received: by 2002:a19:241:: with SMTP id 62mr3211904lfc.165.1602964088435;
 Sat, 17 Oct 2020 12:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv_0rLQF=npjc4CVJBDhsc8Eu_sJtY6xUDbBXs7aYhSzA@mail.gmail.com>
 <5280e8f2-0c9a-c82c-5e5e-9b2d67888da4@talpey.com>
In-Reply-To: <5280e8f2-0c9a-c82c-5e5e-9b2d67888da4@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 17 Oct 2020 14:47:58 -0500
Message-ID: <CAH2r5msmVV57GWUCZE+=Z2uSkbm5ABiga+MNxZm1Mu+OSERE_w@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] do not fail if no encryption required when
 server doesn't support encryption
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

To be consistent with others including Samba we used "seal" (a long
time ago it seems now) to be the mount option to mean "require
encryption for this mount"

See various references to seal (to mean encrypt) in
https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html for
example

Not sure the etymology here of "seal" but my guess is that its use to
mean "encrypt" came from the alternative meaning of "seal" not a large
aquatic mammal but instead "apply a nonporous coating to make it
impervious."

On Sat, Oct 17, 2020 at 12:08 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 10/17/2020 5:03 AM, Steve French wrote:
> >      There are cases where the server can return a cipher type of 0 and
> >      it not be an error. For example, if server only supported AES256_CCM
> >      (very unlikely) or server supported no encryption types or
>
> It seems me that the simpler statement is that there are
> no ciphers supported in common between client and server.
>
> >      had all disabled. In those cases encryption would not be supported,
> >      but that can be ok if the client did not require encryption on mount.
> >
> >      In the case in which mount requested encryption ("seal" on mount)
>
> I'm confused. Doesn't "seal" mean signing?
>
> Tom.
>
> >      then checks later on during tree connection will return the proper
> >      rc, but if seal was not requested by client, since server is allowed
> >      to return 0 to indicate no supported cipher, we should not fail mount.
> >
> >      Reported-by: Pavel Shilovsky <pshilov@microsoft.com>
> >      Signed-off-by: Steve French <stfrench@microsoft.com>
> >
> >



-- 
Thanks,

Steve
