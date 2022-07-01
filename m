Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DEAC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jul 2022 06:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbiGAGhj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Jul 2022 02:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiGAGhi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Jul 2022 02:37:38 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7F13467E
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 23:37:35 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id a4so2277436lfm.0
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 23:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hdeRqKzLTWjL4KBLfrNDCWb1N2ztcATD/vHsugQ0oLQ=;
        b=ZqQP+miHF6jFh3e+Eobm6y9UE2b/3j6ja5jdmaK4xdgmGz0GV9Mbg4Z5gx57RJtfW6
         evwoCyFXiGsf4vTo8egkQjJtnZ84otNnGWhjjLHfkDNBySccJEYiuV/bQjwbfwO9FNQb
         7s9ZmJLgrPvA4DtsmXGa3Pmfz9Si5UG343lV7Xur3oNDverNivN3dNufoi4NTveduVKL
         +8ee8ajGRZw7rA7QudNqYuhRr31RgxCReYgmFJM8V1WqOqmfsOigmwu/Ouy4GM71Srln
         GQEiebNW63jGEUT2qeLzo3UEWa8yfoEd635LhfmSTMvVE2wJJ0cRDkRcyO+SXfrmNRLK
         WGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hdeRqKzLTWjL4KBLfrNDCWb1N2ztcATD/vHsugQ0oLQ=;
        b=00DiNcKGDf7XabFMmUTFNI78UIbSnuyWK5SBBGQGOttLfp+oG8+Yhd8Ctg3Pt1iPYH
         6tVAC96dJIxUgKNx26+gUD0nCRyg5NaSl/QTt5hgmeaopdkxpPX3kJx0lk5B3ZGp13Q3
         VsP6LfZKwlgfs03vIRWZuOBN9Wmm05TV2JBo3ehwYEpPqwkuiZkS66GrSAv7zl2qg7+8
         kgR/wapUMqPuavJ7nCJyulzT5sbrmoY2SrMyJOwzjaINvj6Yw9pyku+RG9ZdqMfk4Y8P
         Zger5ki6+EW6kSBSzZZB9TvcNPuNpwlFRnTQPIq3DjGPla+86u2n61K9tNZXPM7+xYfQ
         F1DA==
X-Gm-Message-State: AJIora+bMy1O9iaH99aT5hABecOZeDKLN5TfBGGcuAzIV7Kf5DC5QMiM
        Fp0eAUk3yLI9MgB59IWg9wED8W/hRl+m+/od7ww=
X-Google-Smtp-Source: AGRyM1tHwDZ7uGqEHGA15rs17wNiUhE4069GfXNa3WiQJLD6FncCrbVwoMVHMzbdeq9VfwB4jJSI0hChNfDsx2/uTvo=
X-Received: by 2002:ac2:4e4e:0:b0:47f:b3c0:2f3d with SMTP id
 f14-20020ac24e4e000000b0047fb3c02f3dmr7942632lfr.15.1656657453623; Thu, 30
 Jun 2022 23:37:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
 <75e51680-f6b1-d83e-0832-bc384b7157be@talpey.com> <CANT5p=rhUvsrveJDA+AsJ6=j=sWC97LiTH+HcTFxbqRtFKqkAw@mail.gmail.com>
In-Reply-To: <CANT5p=rhUvsrveJDA+AsJ6=j=sWC97LiTH+HcTFxbqRtFKqkAw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 1 Jul 2022 16:37:21 +1000
Message-ID: <CAN05THSaD5JbdkjfEzQDtNOL-M+ZQhm-yrz6n1ystJKXOsJArw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add mount parameter to control deferred close timeout
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm.hsk@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 1 Jul 2022 at 16:03, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Fri, Jul 1, 2022 at 3:23 AM Tom Talpey <tom@talpey.com> wrote:
> >
> > Is there a justification for why this is necessary?
> >
> > When and how are admins expected to use it, and with what values?
> >
>
> Hi Tom,
>
> This came up specifically when a customer reported an issue with lease break.
> We wanted to rule out (or confirm) if deferred close is playing any
> part in this by disabling it.
> However, to disable it today, we will need to set acregmax to 0, which
> will also disable attribute caching.
>
> So Bharath now submitted a patch for this to be able to tune this
> parameter separately.

Ok,  will the option be removed later once the investigation is done?
We shouldn't add options that are difficult/impossible to use
correctly by normal users.


>
> > On 6/29/2022 4:26 AM, Bharath SM wrote:
> > > Adding a new mount parameter to specifically control timeout for deferred close.
>
>
>
> --
> Regards,
> Shyam
