Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24DBC433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6954B6113A
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhDIE2j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhDIE2j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 00:28:39 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B9AC061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 21:28:25 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id r20so4874732ljk.4
        for <linux-cifs@vger.kernel.org>; Thu, 08 Apr 2021 21:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Vv0lGw8D3AfyrwBR39W7agJyLjHNg/Wwg+gdyKV6fGw=;
        b=r4OHpG0bsakgZbCCoKpc4m39Q1C/Jp2TlsXw6/sTrsPpmLzh1gw0KbJJV4vTgogVhM
         ZeHi8BXgn/+MhlPoBWwcOfR5UMa70JqP136KHfozsZ77mF4/ecug8hhmyL826yTmiF5j
         Han6WKDgs36gScvCvVmroegI/vypwuppOGYcuF5pS3OaipwpnWNHZ4uS+WRwknLWS8Y5
         qJME0qKH4sD9A8fPzNd6C/p61Mh2Qrg8JxIjbVnfe2w90BVborlEqj7NzGzQ8Q4EVa1u
         S1g5ibNRt6ULyRfz4bPYfBX+bWUHfyBSSLaanlL3X79A0r7aniEM3tTBgRMVKFsYIhNP
         iyxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Vv0lGw8D3AfyrwBR39W7agJyLjHNg/Wwg+gdyKV6fGw=;
        b=ZcD8L0CW7as7isRZ9T4ft39av8YcNL7BT0c8rqD8ti8L4nhMIAIfvOTzj9CV54ZvBY
         rOWsKwY+fq4NqXi0IIkFxypMbnzKC5/5z8dhUx35/cFEWj/wC1/03/GEGNKe5y2WTkZo
         zhiLKKBZ3tftOV9P8sDroKcQ3XQ2Jh/kdW8O6TC1YfE3hY/5y4G+HtOMicCXsx2V9q13
         Kh88FeisFMrbV9vtQZa6sZgTvzQ6Q/kNwifBilAHNdKkOOCfi0FV/CdX0bP9gjq5Ts2W
         RTvFOC/QzD6DBSraaigNv3FIJqvZRkRUBWI9wW/1FDQksB2HhOptcjy43wO8oP3ckIph
         6MHA==
X-Gm-Message-State: AOAM5314hbOyjhXkc+bi1Ebqs336x0yNpHi0jGyM5FBWlxvbQvCEKr9X
        zKGzrGNS8KpDjmOw6YVS+lxe4gDJ++Gyb0sUAONvQgZcqOQ=
X-Google-Smtp-Source: ABdhPJx93ptXMopxfoR9n5+HaTXsNMZ843byWONYkHhbD+KRyXf23UOjtQq2ylVYY2r3MaLuvEhKArbheNOfsEOrfeI=
X-Received: by 2002:a2e:9907:: with SMTP id v7mr8214692lji.256.1617942504158;
 Thu, 08 Apr 2021 21:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210318175531.30565-1-aaptel@suse.com> <a07bc171d986e75f7edb9cf0fe842fa8c8e44892.camel@suse.de>
In-Reply-To: <a07bc171d986e75f7edb9cf0fe842fa8c8e44892.camel@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Apr 2021 23:28:13 -0500
Message-ID: <CAH2r5mvnW1At==3rWAn+Mu7WZ1-jHOmYkkyWjh+axsHoo4Lh4w@mail.gmail.com>
Subject: Re: [PATCH v1] cifs: simplify SWN code with dummy funcs instead of ifdefs
To:     scabrero@suse.com
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aurelien,
This didn't apply to current for-next when I tried applying it.  Can
you check and rebase the patch on current for-next?  Seems ok
otherwise.

On Wed, Mar 24, 2021 at 3:57 AM Samuel Cabrero <scabrero@suse.de> wrote:
>
> On Thu, 2021-03-18 at 18:55 +0100, Aur=C3=A9lien Aptel wrote:
> > From: Aurelien Aptel <aaptel@suse.com>
> >
> > This commit doesn't change the logic of SWN.
> >
> > Add dummy implementation of SWN functions when SWN is disabled instead
> > of using ifdef sections.
> >
> > The dummy functions get optimized out, this leads to clearer code and
> > compile time type-checking regardless of config options with no
> > runtime penalty.
> >
> > Leave the simple ifdefs section as-is.
> >
> > A single bitfield (bool foo:1) on its own will use up one int. Move
> > tcon->use_witness out of ifdefs with the other tcon bitfields.
> >
> > Signed-off-by: Aurelien Aptel <aaptel@suse.com>
>
> Thanks Aurelien, it LGTM.
>
> Reviewed-by: Samuel Cabrero <scabrero@suse.de>
>
> --
> Samuel Cabrero / SUSE Labs Samba Team
> GPG: D7D6 E259 F91C F0B3 2E61 1239 3655 6EC9 7051 0856
> scabrero@suse.com
> scabrero@suse.de
>


--=20
Thanks,

Steve
