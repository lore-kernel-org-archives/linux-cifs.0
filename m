Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0A8C433E6
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 10:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85E0A64F94
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 10:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhCKKuI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Mar 2021 05:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbhCKKtj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Mar 2021 05:49:39 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44DCC061574
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 02:49:38 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id p193so21251774yba.4
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 02:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n0RgWKx/mkgRE7bhiufZjgxHnFhc5kaQmVcLcEYkJTk=;
        b=prLDJvr0RO+VFqIOIIV4oBq0EPMiM9q/kr+gXNj8RoQyMk+As9lje0f4P6S48F91UE
         NjlJaa+ZreMfT8NfAgRpcmaG0LZo7zAQ4963WRKFt+wT9RClgY55HklqgHnA0di9M4CQ
         be0Xi+x5wsSOeb5iLuQ3to5/f4nHZwbKDiJcOPpcFYQwGrQ/3h7DRLJsUEBM9KK8NzB/
         lgdbZe3okVVGdmWSdszY5Hkx0WP7f7KVU7GeH+P3nsTYJc0a0I9Dtmc5pc/Z8XEHacNG
         bA1R1HJ+yvsip3ri0Izhbf2hBB/9QJGWBQIuJihvSIJYpJIQ3vWn79SVvAtsKZbYFTsa
         isIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n0RgWKx/mkgRE7bhiufZjgxHnFhc5kaQmVcLcEYkJTk=;
        b=d2XCDvV+g+cSvK3ey983OaxzfMkqJqWvF0EFWRcctlXOzp4vOOJLboJHGPrGwPIW4x
         7eKSlFjN4uH08Wdwr3zvGgxEVfaD65e2k0e1+F/xS75dYbyp7hMkGVglOAKGcJdTPZTh
         BWCTgezj0SMGkz3GqDsfkb29pEUwpJxp/l0frWOPMv/8wbmsvqXFOxnZ1quSsWvB3jZm
         HYGnvnPB8dNV6DuDwcNWDZ/hSBaBkxo4h3hhB13wtcM+XgfPwnTJJZONGLwNKGJzK8fz
         nKahhKEWWtKgRhvxV6ZHfryE5yyMlg6lsCSPRFrH5OBCOCdfEbVvX1fG39WGPHQ8Cewi
         QEfw==
X-Gm-Message-State: AOAM5337jodycibUYBjZpxZU6X28C+ivuDKNXYRbCdi6wb/pO3yDS26C
        rgvvZopz8iOygce9jHP0YwHpnLRs1d+1QdfYY89FFj0ubRPS7w==
X-Google-Smtp-Source: ABdhPJzMMjxA/YQ6J6gkyJCmWa3vwPkRGWP07+4BBNXjDWvYEsvSG5POm0BsFFqz+IkhSzX1vqm6lf5FPzQBEdvpLqo=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr10280985yba.3.1615459777839;
 Thu, 11 Mar 2021 02:49:37 -0800 (PST)
MIME-Version: 1.0
References: <20210305142407.23652-1-aaptel@suse.com> <CAH2r5mufnuA4cavG8JYq2q+-9kY3oHeoQrLyzeXgN2xFQ8P6_w@mail.gmail.com>
 <CANT5p=pzh7a9v1q15m056i=cN-MC4W2W2Lx3P68itHzd5EQnnQ@mail.gmail.com> <874khlx3pv.fsf@suse.com>
In-Reply-To: <874khlx3pv.fsf@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 11 Mar 2021 16:19:26 +0530
Message-ID: <CANT5p=r_3=YAj0v-q=R85FLH2S2EjMMinbezMvROqdyB+=X7OA@mail.gmail.com>
Subject: Re: [PATCH] cifs: try to pick channel with a minimum of credits
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Some code relies on server->* values so if you swap the server pointer
> it at the last moment I'm not sure those values will match the new
> server ptr.

I'm not sure that I understand this. I'm not suggesting that we swap.
I'm only saying that on getting a EDEADLK error from
compound_send_recv(), try another channel instead of returning that to
userspace.
Please let me know if I'm missing something here.

Regards,
Shyam

On Mon, Mar 8, 2021 at 5:22 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Hi Shyam,
>
> Thanks for the review. I also realized we cannot make this failproof so
> I went in with the idea to just avoid picking easy, non-confusing cases
> of unusable channels. If that's not good we can drop the patch all
> together.
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > Spent some time in this code path. Seems like this is more complicated
> > than I initially thought.
> > @Aur=C3=A9lien Aptel A few things to consider:
> > 1. What if the credits that will be needed by the request is more than
> > 3 (or any constant). We may still end up returning -EDEADLK to the
> > user when we don't find enough credits, and there are not enough
> > in_flight to satisfy the request. Ideally, we should still try other
> > channels.
>
> Yes you're right, it won't prevent failing if more credits are
> needed. The patch wasn't meant to be failproof, just to avoid most
> occurences of the problem. It's a simple sanity check with some
> false-positives and false-negatives.
>
> > 2. Echo and oplock use 1 reserved credit each, which the regular
> > operations can steal, in case of shortage.
>
> There's a dedicated server->echo_credit I think.
>
> > 3. Reading server->credits without a lock can result in wildly
> > different values, since some CPU architectures may not update it
> > atomically. At worse, we may select a channel which may not have
> > enough credits when we get to it
>
> If we are just doing a read on an aligned int, at least on x86 you will
> get either a stale value or the new value, you cannot get a garbage mix
> of both. Which CPU architecture doesn't provide cache coherency at that
> level? This is a complex question I couldn't find an easy answer to.
>
> In any case cifs.ko is already assuming it's valid in various places. We
> are doing it for some usage of the server->tcpStatus, ses->status,
> tcon->tidStatus at least.
>
> The problems of atomic read in pick_channel() aside, the credits might
> change from another process between the moment the channel is picked and
> the moment the credits needed are spent (server->credit -=3D XYZ). In
> which case it will also EDEADLK later on.
>
> > What if we do this...
> > wait_for_compound_request() can return -EDEADLK when it doesn't get
> > enough credits, and there are no requests in_flight.
> > In compound_send_recv(), after we call wait_for_compound_request(), we
> > can check it's return value. If it's -EDEADLK, we keep calling
> > cifs_pick_another_channel(ses, bitmask) (bitmask has bits set for
> > channels already selected and rejected) and
> > wait_for_compound_request() in a loop till we find a channel which has
> > enough credits, or we run out of channels; in which case we can return
> > -EDEADLK.
> > Makes sense? Do you see a problem with that approach?
>
> Some code relies on server->* values so if you swap the server pointer
> it at the last moment I'm not sure those values will match the new
> server ptr.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Regards,
Shyam
