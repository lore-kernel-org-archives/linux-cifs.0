Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA990C432BE
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Aug 2021 22:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7B5E60E76
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Aug 2021 22:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhHPWUZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Aug 2021 18:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhHPWUY (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 16 Aug 2021 18:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83934600CD;
        Mon, 16 Aug 2021 22:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629152392;
        bh=YKbfqveW5N6PrKymvvb2EoK2UYjeEoMZZv9MnO8p2kQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=szs8TgkYPedA6TINs/C8u6K8r+SyUFLyfJlV4SQJ70kIexOLUionxEUm6yxTcTNAK
         rxCVPu+AYkHBMMsJeOmt2WTNKOnKmC5pr9VBvQGmfJ/IQ5V+peBAVjd6r4Ce+AcHLO
         +IJCBtOwIi6Y/RNETIRPD/TB71lprU54lVGiPBtE7EhNShb7T7+5XZSEQlE8WnooSL
         QxCMOp6OlEfRuebhTCUBSsgQHJbt8+6+IfkxlHZ/fynK1Jf0rk+O+A1JvLnKEkIZM3
         ZpTc47T9/MTA3DsfJmZrcs6OrOYONIxn5Pb9nCzfovh3jWzn+TOxjx3jOCb3q/G8cB
         7kAd0qqHRiFGw==
Date:   Mon, 16 Aug 2021 15:19:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        linux-crypto@vger.kernel.org
Subject: Re: Building cifs.ko without any support for insecure crypto?
Message-ID: <YRrkhzOARiT6TqQA@gmail.com>
References: <YRXlwDBfQql36wJx@sol.localdomain>
 <CAN05THSm5fEcnLKxcsidKPRUC6PVLCkWMBZUW05KNm4uMJNHWw@mail.gmail.com>
 <YRbT7IbSCXo4Dl0u@sol.localdomain>
 <CAN05THScNOVh5biQnqM8YDOvNid4Dh=wZS=ObczzmSEpv1LpRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN05THScNOVh5biQnqM8YDOvNid4Dh=wZS=ObczzmSEpv1LpRw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Aug 15, 2021 at 08:38:23PM +1000, ronnie sahlberg wrote:
> 
> What are the plans here? To just offer the possibility to disable all
> these old crypto and hashes on a local kernel compile?
> Or is the plan to just outright remove it from the kernel sources?
> 
> If the first, I think that could possible be done for cifs. I think a
> lot of the security minded larger enterprises already may be disabling
> both SMB1 and also NTLM on serverside, so they would be fine.
> 
> For the latter, I think it would be a no-go since aside from krb5
> there are just no other viable authentication mechs for smb.

Removing the code would be best, but allowing it to be compiled out would be the
next best thing.

> TL;DR
> If NTLMSSP authentication is disabled, there are no other options to
> map a share than using KRB5
> and setting up the krb5 infrastructure. And thus smaller sites will
> not be able to use CIFS :-(
> So while I think it is feasible to add support to cifs.ko to
> conditionally disable features depending in a kernel compile (no SMB1
> if des/rc4 is missing, no NTLM if rc4/md4/md5 is missing)  I don't
> think it is feasible to disable these by default.
> I will work on making it possible to build cifs.ko with limied
> functionality when these algorithms are disabled though.

FWIW, the way this came up is that the Compatibility Test Suite for Android 11
verifies that CONFIG_CRYPTO_MD4 isn't set.  The reason that test got added is
because for a short time, CONFIG_CRYPTO_MD4 had accidentally been enabled in the
recommended kernel config for Android.  Since "obviously" no one would be using
a completely broken crypto algorithm from 31 years ago, when fixing that bug we
decided to go a bit further and just forbid it from the kernel config.

I guess we'll have to remove that test for now (assuming that CONFIG_CIFS is to
be allowed at all on an Android device, and that the people who want to use it
don't want to use kerberos which is probably the case).

It is beyond ridiculous that this is even an issue though, given that MD4 has
been severely compromised for over 25 years.

One thing which we should seriously consider doing is removing md4 from the
crypto API and moving it into fs/cifs/.  It isn't a valid crypto algorithm, so
anyone who wants to use it should have to maintain it themselves.

- Eric
