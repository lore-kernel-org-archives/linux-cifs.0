Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD05CC4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 11:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87F4261058
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 11:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbhHRLpE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 07:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235660AbhHRLpD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Aug 2021 07:45:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A27066108F;
        Wed, 18 Aug 2021 11:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629287067;
        bh=VH3EOl41LEfQplFxwRq4nuHE2RW5Tz6hwjnDQbSLU+I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ruW7pjTfSjpsfXAD5HW8Krf6Z3tXzo/Y2ZJBuS1blj30wYKwz4Kk5y5/zNHIZHokg
         E9MumE/AQK7R/m9QgkuN/Vk3HZL2jrm/9rz09Y/Kwg1OH1bqMlCEoZteCIpvdmoMqb
         hv1pbWlSzsh3QewJ5mf1a0VtoSHva4TnSOtn/S9dzzkLkn5OUfIONUwMJwDpKkvYcF
         lzLwQojAij3tinlsodS1P3MPcp0EW00xWBJ7Mf0PPJwWjhpR6CA8WOVs9L2ZvJZw5p
         KJM9Uk2FS1zt/lZoo8HK9OjRCOuv7lyDffMOnmxXzqzTXa3g258DyAkO9Ubww9aajz
         5cX3/QjRPHp9g==
Received: by mail-oi1-f182.google.com with SMTP id t35so3528251oiw.9;
        Wed, 18 Aug 2021 04:44:27 -0700 (PDT)
X-Gm-Message-State: AOAM531aJOHawqDaebi+50WvEsRfgwUi9SuOmpbuf5VnbCM/UAhhyDyT
        CeDEaK6+jicnnadTD/3SefzvJNRNCodTGws6WRU=
X-Google-Smtp-Source: ABdhPJxer8eY+gsiVr7xzx0qXTMd7ZOJUoH5LtG0i50BA+y7aIrSsfl0dPPvZZUG333227QJSXO8PcFHWV0ZRj3hEwo=
X-Received: by 2002:a05:6808:2219:: with SMTP id bd25mr6687834oib.33.1629287067000;
 Wed, 18 Aug 2021 04:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <YRXlwDBfQql36wJx@sol.localdomain> <CAN05THSm5fEcnLKxcsidKPRUC6PVLCkWMBZUW05KNm4uMJNHWw@mail.gmail.com>
 <YRbT7IbSCXo4Dl0u@sol.localdomain> <CAN05THScNOVh5biQnqM8YDOvNid4Dh=wZS=ObczzmSEpv1LpRw@mail.gmail.com>
 <YRrkhzOARiT6TqQA@gmail.com>
In-Reply-To: <YRrkhzOARiT6TqQA@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 18 Aug 2021 13:44:16 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH93HU5SNUDLpn+c0ryJUYWpRKVXeoPK8jPOSwiS3_79A@mail.gmail.com>
Message-ID: <CAMj1kXH93HU5SNUDLpn+c0ryJUYWpRKVXeoPK8jPOSwiS3_79A@mail.gmail.com>
Subject: Re: Building cifs.ko without any support for insecure crypto?
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 17 Aug 2021 at 00:19, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Aug 15, 2021 at 08:38:23PM +1000, ronnie sahlberg wrote:
> >
> > What are the plans here? To just offer the possibility to disable all
> > these old crypto and hashes on a local kernel compile?
> > Or is the plan to just outright remove it from the kernel sources?
> >
> > If the first, I think that could possible be done for cifs. I think a
> > lot of the security minded larger enterprises already may be disabling
> > both SMB1 and also NTLM on serverside, so they would be fine.
> >
> > For the latter, I think it would be a no-go since aside from krb5
> > there are just no other viable authentication mechs for smb.
>
> Removing the code would be best, but allowing it to be compiled out would be the
> next best thing.
>
> > TL;DR
> > If NTLMSSP authentication is disabled, there are no other options to
> > map a share than using KRB5
> > and setting up the krb5 infrastructure. And thus smaller sites will
> > not be able to use CIFS :-(
> > So while I think it is feasible to add support to cifs.ko to
> > conditionally disable features depending in a kernel compile (no SMB1
> > if des/rc4 is missing, no NTLM if rc4/md4/md5 is missing)  I don't
> > think it is feasible to disable these by default.
> > I will work on making it possible to build cifs.ko with limied
> > functionality when these algorithms are disabled though.
>
> FWIW, the way this came up is that the Compatibility Test Suite for Android 11
> verifies that CONFIG_CRYPTO_MD4 isn't set.  The reason that test got added is
> because for a short time, CONFIG_CRYPTO_MD4 had accidentally been enabled in the
> recommended kernel config for Android.  Since "obviously" no one would be using
> a completely broken crypto algorithm from 31 years ago, when fixing that bug we
> decided to go a bit further and just forbid it from the kernel config.
>
> I guess we'll have to remove that test for now (assuming that CONFIG_CIFS is to
> be allowed at all on an Android device, and that the people who want to use it
> don't want to use kerberos which is probably the case).
>
> It is beyond ridiculous that this is even an issue though, given that MD4 has
> been severely compromised for over 25 years.
>
> One thing which we should seriously consider doing is removing md4 from the
> crypto API and moving it into fs/cifs/.  It isn't a valid crypto algorithm, so
> anyone who wants to use it should have to maintain it themselves.
>

+1 to moving the md4 code into fs/cifs, so that the CIFS maintainers
can own it and phase it out on their own schedule, and prevent its
inadvertent use in other places.
