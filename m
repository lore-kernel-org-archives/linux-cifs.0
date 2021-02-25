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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5F9C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 05:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2E6764DDC
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 05:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBYFRT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 00:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhBYFRS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Feb 2021 00:17:18 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A89AC061574
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 21:16:38 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id x19so4252920ybe.0
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 21:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3PC7qPZm0ipXoklycNj6TGNj78JBgN6/Hi4OfEUMDHo=;
        b=GXRCH0a4D7Wo8BMz5qjIX61D37sG8JuMEBeOxqRB72neq6QCjjPSc7ju7vmXcQmE7r
         AGYZvPxvb1zotiVd6OXKPECsNaE2v3ACaDzXEvf23gPuK0T+3+iYOUlQddaFLMfjfI24
         v8kF0Kq59A3lqs9yZimHJtoW9o6RqVh97A9l9Nxq9QXM1iMAyBdHTT9XbCW86RJGXnee
         PZdjq/4G7r2Z/5fiA03TDu7HLO/IwF06PHRZEPbxoJEIW65s73cUhcBwRF8UPAPlv9p9
         pfDNA8CzAXStzV0LwNIEVOOVud9nINV+xabbjs58rxTQQ8nn7qCpxGK+Hp1m+yeF9/FW
         fSyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3PC7qPZm0ipXoklycNj6TGNj78JBgN6/Hi4OfEUMDHo=;
        b=D+EE7s3V4zQRLWATeeRiI4od6vNiF4U6C0BNxjwK1OSVUPzO0UVE8lVe4bzZCE1l7v
         vUgxLrvFy+Gsry7zHfTZPiWZvblj7Uzsg7Di6H6unsZ5Dz9gIfnUmMkpPVOZfliXjec5
         uLkOo0r/leTOkq0blVOddYn2tgSbwWvkLpu3nhmizPo39RdTmnV/tUL3jSAsWS11xhUb
         YuXBjOpf2/nHj34/UybXJVXwgknrWfWYkKlv0mVZJ1niyeL+fpCJLErOsQtgMtZrdhXB
         6Aev/HskIDMmzXuh0mWxZhNdd2ISd9W21IWzwak+KIYYHyotaI76Zh6s99PPVvurBpG+
         UH/w==
X-Gm-Message-State: AOAM53252J73kcgfuV4K7rLsre1ZDfpTAH1VJzt79gwYPyuliXNi3jzQ
        boXjBFFZd67SUQv1ufJQc9yE5kG7a0rwRb+5EpaHDts5Nwg7DGPy
X-Google-Smtp-Source: ABdhPJwuph1onXV0uFHX3IES4K5E4DQDeJIm2QZCn50lcrkCO6HsiSmOhWTjIZK4xx58LErUaGYFNGvDRToEKC/jv00=
X-Received: by 2002:a25:442:: with SMTP id 63mr1600363ybe.131.1614230197580;
 Wed, 24 Feb 2021 21:16:37 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msdUQ=CVM6s7ENeH7SP-teYAOioOGq7zY5sDXZFrFYiCA@mail.gmail.com>
 <CAH2r5mv6Oo5UUMOyFmKO_6xmdXZvQa_TtmFjgdN_ZoBcgSbJkA@mail.gmail.com>
 <10881e42-9632-30b0-344d-66ed8e9cb340@talpey.com> <CAH2r5mvGG1-DOZq1Eby3jfX86YLgpCihmYgV=EPJoR16PhEN7Q@mail.gmail.com>
 <CAH2r5muLz67kjmxiboeW3DwJ2KhEQgJs_U6MCAxzVZ+TY+ucCA@mail.gmail.com> <05b2482a-e499-9239-a956-0b322fa7d800@talpey.com>
In-Reply-To: <05b2482a-e499-9239-a956-0b322fa7d800@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 25 Feb 2021 10:46:26 +0530
Message-ID: <CANT5p=pUbZ=tAJiDBM7PS5F64A78D2f52Wbv38gxtW7L2KOZXg@mail.gmail.com>
Subject: Re: [PATCH] convert revalidate of directories to using directory
 metadata cache timeout
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.

I'd prefer it if the default value of acdirmax is much higher, and not
the same as acregmax value.
Otherwise, this becomes something that we ask the users to do only
after they start complaining about performance.
Maybe we can change it once we document these new options in the man page?

Regards,
Shyam

On Thu, Feb 25, 2021 at 9:20 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 2/24/2021 1:20 PM, Steve French wrote:
> > Added additional patch to add "acregmax" so now behavior is more similar to nfs.
> >
> > "acregmax" changes file metadata caching timeout
> > "acdirmax" changes directory metadata caching
> > "actimeo" does what it did before - and changes both.
>
> Clever. It's a little weird that specifying either max with
> actimeo will kick a warning, and maybe surprising to someone
> who sets both maxes to the same value will see actimeo instead.
> But they'll get over that. :)
>
> You can add to all three, my
> Reviewed-By: Tom Talpey <tom@talpey.com>
>
> > On Wed, Feb 24, 2021 at 11:31 AM Steve French <smfrench@gmail.com> wrote:
> >>
> >> On Wed, Feb 24, 2021 at 10:11 AM Tom Talpey <tom@talpey.com> wrote:
> >>>
> >>> On 2/23/2021 8:03 PM, Steve French wrote:
> >>>> Updated version incorporates Ronnie's suggestion of leaving the
> >>>> default (for directory caching) the same as it is today, 1 second, to
> >>>> avoid
> >>>> unnecessary risk.   Most users can safely improve performance by
> >>>> mounting with acdirmax to a higher value (e.g. 60 seconds as NFS
> >>>> defaults to).
> >>>>
> >>>> nfs and cifs on Linux currently have a mount parameter "actimeo" to control
> >>>> metadata (attribute) caching but cifs does not have additional mount
> >>>> parameters to allow distinguishing between caching directory metadata
> >>>> (e.g. needed to revalidate paths) and that for files.
> >>>
> >>> The behaviors seem to be slightly different with this change.
> >>> With NFS, the actimeo option overrides the four min/max options,
> >>> and by default the directory ac timers range between 30 and 60.
> >>>
> >>> The CIFS code I see below seems to completely separate actimeo
> >>> and acdirmax, and if not set, uses the historic 1 second value.
> >>> That's fine, but it's completely different from NFS. Shouldn't we
> >>> use a different mount option, to avoid confusing the admin?
> >>
> >> Ugh ... You are probably right.  I was trying to avoid two problems:
> >> 1) (a minor one) adding a second mount option rather than just one (to
> >> solve the same problem).  But reducing confusion is worth an extra
> >> mount option
> >>
> >> 2) how to avoid the user specifying *both* actimeo and acregmax -
> >> which one 'wins' (presumably the last one in the mount line)
> >> We could check for this and warn the user in mount.cifs so maybe not
> >> important to worry about in the kernel though.
> >>
> >> I will add the acregmax mount option and change actimeo to mean
> >>      if (actimeo is set)
> >>              acregmax = acdirmax = actimeo
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> >
> >



-- 
Regards,
Shyam
