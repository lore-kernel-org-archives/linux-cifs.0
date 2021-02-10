Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C574C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 02:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA6E64E4B
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 02:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbhBJCMe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbhBJCKi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 21:10:38 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CD0C0613D6
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 18:09:57 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id f2so777202ljp.11
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 18:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4q6EwqS7RdfHU6E3rJputlAnWO4HtzmJCGqUpIw98uE=;
        b=ARnAeXFRLfBi10gTHkzMixt+Wgw7rHn60sS1Y3VgRXqiq5qn8JrlLSj86ZGnYet05H
         FUNOLBDmfSXUWK1HsXbKKkYOVrT+QA+yQnMD/Yldsoox5HL6jihKle22wHB3EkUySfWy
         mqgqeSsXUzADK1hUzk+5C5m7WKRDB/mC9hmBTVhDTb1rPfWYpRiozgvlYCg8+wA/9Vcu
         /QYuip4AncpdQk2OjAmGKhrtGdiMdqp1aLZUHSi7AGY9srQn7EY8697xyAQdc1lvm0Up
         3jHEBD/2PYSVlQnzSnXoBykLUwNNVfrwh9SbRcj5kpJLU6BHBPxaLMLEQt1T/Fr0Hsqk
         rFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4q6EwqS7RdfHU6E3rJputlAnWO4HtzmJCGqUpIw98uE=;
        b=eq7Bc9pAv6dLw9dpj6UplWYexkcK8MBsrnhSd0Ro2dQq7AMnncCE3vidyjIQhbOOnS
         nTzXAt1Z0vl/3PFoMx1V5Wv0p/0z56RQQXcMXxqMowQ/O5Sxyveqkm1kvUBNVNRwV64y
         ob+HU8ldqPVQOGvUbPBICFVvQnVHi4VBgvQ/aWSsIhjeEJxiYojHDsKcSTZUAykq9aPf
         h3bCvHLmlT1hVP0m67aoVapSoFtW/KbNHJ4HoPKebohLPvDa9oQX3OfiIISZaPr9UpDG
         daWTqVJ1ODmC30kVJbugWvc2xTBlDEm+XSQS958KDrbmrbM9xzVJ6Ggt8jhAuZt6PzOS
         ZRig==
X-Gm-Message-State: AOAM532yq1k/Rt2R/aMg+vaAhSkDRVZYM/BN/ldV8PV01YSx5Hvc4xtw
        xUTpF/n2Nx8bMDJCZTrvhki0dga62szvmg/enHO8ZmrDNco=
X-Google-Smtp-Source: ABdhPJx/NVrLvfD+jei4Qsp7i62QV+hrh+9EkjYGGfmZ/LjBpm7bDYoe1hXf+6PVH78Y4yX7iM9uLrQ/3VF0VAIjIZ0=
X-Received: by 2002:a05:651c:3cb:: with SMTP id f11mr475811ljp.272.1612922996205;
 Tue, 09 Feb 2021 18:09:56 -0800 (PST)
MIME-Version: 1.0
References: <CANFS6ba33DORg99OYHwaD9yJ+r6rt8A7v_R36_Uf_hHkw=agyw@mail.gmail.com>
 <CAN05THQyVJ_4CN41Ep1Wn93BuFYgqUZ1fqCVnqiUebHtobu1tg@mail.gmail.com>
In-Reply-To: <CAN05THQyVJ_4CN41Ep1Wn93BuFYgqUZ1fqCVnqiUebHtobu1tg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 Feb 2021 20:09:45 -0600
Message-ID: <CAH2r5mvRds+QT33zw=3qtfDt4a7jEW-y0H6baP05oUFXVAoEkQ@mail.gmail.com>
Subject: Re: "noperm" mount option not working
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Feb 9, 2021 at 7:56 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> On Wed, Feb 10, 2021 at 11:18 AM Hyunchul Lee <hyc.lee@gmail.com> wrote:
> >
> > Hello Ronnie,
> >
> > from the commit 2d39f50c2b15 ("cifs: move update of flags into a
> > separate function"),
> > "noperm" is disabled if "multiuser" is not given. this happens even if
> > "noperm" is given.
> > Could you explain why this is required?
>
> That was a bug. Thanks for spotting this.
>
> I have sent a patch to fix this to the list.
> >
> > Thank you,
> > Hyunchul



-- 
Thanks,

Steve
