Return-Path: <SRS0=FePp=Q5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EF5C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 04:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 555AF2086A
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 04:30:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EbLZiCqP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfBVEaO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Feb 2019 23:30:14 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39921 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfBVEaO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Feb 2019 23:30:14 -0500
Received: by mail-pf1-f193.google.com with SMTP id i20so503137pfo.6
        for <linux-cifs@vger.kernel.org>; Thu, 21 Feb 2019 20:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4w/wTCSxzqf/Cebk8lR4xVAxF0BKjTmDF7lSk0gSrqs=;
        b=EbLZiCqPYLuM2qIEaEyAi57XITvOutBu5k2A/PqkCMxa0qGtdliQ5wNsK8XAJek0bb
         o3dlK4btEs3Fkl1/EIXRQKS6nHRLVD/LteW/KMDTs7058bU62PqE1dfF6OYqhNe8kAOP
         eINibz0Zk4/yG915rS2OjOHkrbNmaPPxisoWPS/1MIPOVPWG/8wnWViy/14NjFZk2ekA
         4chOzTNM3DBAMmcEuLJuP7+1Zm1lIuSzTnxeACGB4l+R042p/pZ4GXa78mu6wJ7ikEJI
         mkwk9ux/qzL8wryZMyb3kRtz1ZdFfA9jWrdaz5wq6KYKPqZFPam3opZSH8uXTehSFzkl
         YziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4w/wTCSxzqf/Cebk8lR4xVAxF0BKjTmDF7lSk0gSrqs=;
        b=phuwl4luBH4qFzYW7EuwvU+cmn0XnHbMkOo3YysKiKJjecMbE9JKd9BzwDjQhLc28y
         hq80MjcQkp4Nqts52rkodEg2+N2uyNP5qOVeBvsqj4OttW0EvAHkErdhAUze2ryij4Up
         Oi+e+l6DM4EOuOLWHDtaGsnveEp8SVmRsJtZ1kwc9EPltdr6jhynVlSpD5l0DrnSOVK9
         aSU3QAyOWLW+rTuDv6BRFtcMAMB1UhhXO+CJUb4wD3OL+h5Eaz8gRJ+Y7MKCztois4cu
         Ph5WX3wLY/FDfcIop1nBcQ+sTqvVcxgbsEKdv+RI9S2JWBrtLQBXaXsEWY0RpUeTueyX
         l1ww==
X-Gm-Message-State: AHQUAuahTSSq+xC+qTEUCX4Gna3o5auK4RTUrp0r4YRb9Yi7OqilDSTF
        oC678v+ZsVAAxZn+5iDraWQVJ+K0yewxY0J4ktMsiw==
X-Google-Smtp-Source: AHgI3IagjzAIKJPido0KDuRtCqedn6kc5wl0+kKtpYP6LvailVSql5l1QrNKBrcMy+7Lwl/ATa8906ijKaDOdREhZ6w=
X-Received: by 2002:a63:2312:: with SMTP id j18mr2095773pgj.344.1550809813578;
 Thu, 21 Feb 2019 20:30:13 -0800 (PST)
MIME-Version: 1.0
References: <5C6B997B.8050203@tlinx.org> <CAKywueSgMhDzKOx04_C8X3HEhn_0w6cwM43c3=FXdjCsZ3x9UA@mail.gmail.com>
 <5C6DAEFC.2060909@tlinx.org> <5C6F3167.7090402@tlinx.org>
In-Reply-To: <5C6F3167.7090402@tlinx.org>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 21 Feb 2019 22:30:02 -0600
Message-ID: <CAH2r5mskDv3ZB8gUpRDN6iPzaZaGeXuN-uHikGvj+5K4epN2Xg@mail.gmail.com>
Subject: Re: upcalls seem to have problems with symlinks, junctions et al.
To:     L A Walsh <cifs@tlinx.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I have wanted to change this code and improve it for a while - one
thing which is tricky is showing mode bits when no permissions to read
permissions though, and we also need to clean up and simplify some of
this code.   Let's follow up on this in a few days, if you are
flexible and can install some test patches

On Thu, Feb 21, 2019 at 5:17 PM L A Walsh <cifs@tlinx.org> wrote:
>
> On 2/20/2019 11:48 AM, L A Walsh wrote:
> >
> >>> ---
> >>> ls: cannot access 'Documents': Operation not supported
> >>> ...
> >>> ls: cannot access 'Prog64': Operation not supported
> >>>
> >>> d????????? ?       ?            ? Documents/
> >>> ...
> >>> d????????? ?       ?            ? Prog64/
> >>> ...
> >>> Depending on timing, Sometimes I will get most or all of
> >>> them appearing the same as they would on windows.
> >>>
> >>> If I can't resolve them more quickly, is there a know
> >>> or two to increase cache size and item lifetime?
> >>>
> >>>
> >> Which kernel version shows symlinks right and which - wrong?
> >>
> ----
>     Wrong is 4.20.3... I'm not sure, using the "upcall" for the linux
> client reading Metadata(owner+ACL) has ever worked right
> for the various forms of symlink/symlinkd/mountd/junction, since
> I see a message from me on the cifs list trying 4.10.1 and
> having resolution problems related to file-system redirects.
>
>     They "should" work the same way...as when I list them locally
> since I'm accessing the machine as the same user (the linux
> machine is a samba4 PDC and I'm using the same user-id to
> access it on both sides).
>
>     The only time they fully work is when I assigned the mount
> ownership to my local user that owns or is in a group that
> owns most of the links.  Is there something flakey
> about reading the link info -- since it works when I mount
> it using 1 UID.
>
>     There may be cache timing issues as well, but they are too
> ephemeral to pin down.  The question marks seem to be fairly
> consistent on these names (all of which are some form of
> NT-pointer to another place - junctions
>
>
>
>


-- 
Thanks,

Steve
