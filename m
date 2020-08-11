Return-Path: <SRS0=JwxV=BV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81E7C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Aug 2020 01:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93D7520716
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Aug 2020 01:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l4WZtnnL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgHKBv4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Aug 2020 21:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgHKBv4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Aug 2020 21:51:56 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83891C06174A
        for <linux-cifs@vger.kernel.org>; Mon, 10 Aug 2020 18:51:55 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a5so11014578ioa.13
        for <linux-cifs@vger.kernel.org>; Mon, 10 Aug 2020 18:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jZY8L1rcVOqK8VBHYorPPhANXo55YUrvD+G1QQdxJ60=;
        b=l4WZtnnLvLdgQgT6VMEHu39AhgBCCEE1gJt240p78zCJwf2xikQX1qA94FCdGYtEub
         fQ63Hz/ONd0TvUrKlTWmuKzZH/zZP5cT/Ngl2MBG3GNKBhfo2jYeUB6KaRspn2GZbyLv
         V/LArSUURX5nTf7+MF4n6vjA6Yt8PWtr2v6AzA6QxebDBmJ3w+yIIbDoMEYUnmNr7kyS
         Pf4YQEdm084MJ4NOTO0ylnBnBh7+uHI1eSJAjWC5RYlIHLc78MSPw2+Bri4CMf77AUTW
         TSsIwwnvT4XurQ4IEt2Q4mFeosNOEKd65ejvmhUU9sLLQv5eC+x2txvhxDFj8CibSWPz
         u5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jZY8L1rcVOqK8VBHYorPPhANXo55YUrvD+G1QQdxJ60=;
        b=i90efDLtqNVcCf+yLiNsG4UPLjjkppRWbQYnTtmiBDzNOgjecqcm5MkGWsrWilggRc
         ibNDsKQTGWrsaH3BTaviYavuOHlXofVW1qzNUBxDvVqLctvWJzvnec4nqM5sZ81ehpyK
         GaXBaevZATPTCCX4AZJR/eQ9jECiNFbfYt/hlP1WtXEIFoCPAeqaiDfqD39/0SAczShB
         ANBObEmQS9FLzQT5zjeyO8OfZq5bTg9NvP0CWhMwGYk858SoY2BZkbvuUdTc/csFLboP
         oLwohwKMubsIiOEwJlFWTu2aR6mwdVHQt9UpYlPOfDZTovp8M7nMz5DItT5LhvHdnqrX
         kNZg==
X-Gm-Message-State: AOAM531tpw9rjxWJjPO6Y48HKvotGxp+WC6GfdOo31SYsNdNJehM4/bN
        7sSt0SPFI2AOEifX4TNl8aEB4zS293CpbjwDrRk=
X-Google-Smtp-Source: ABdhPJz3z5Yt5kxqXHmQw00qQKVQw0oy0gDLmh0CJcJLP6eNexiGPt/RZMvtzgsz8NApXKW+jlR4n6/TVwroE+dBY8s=
X-Received: by 2002:a05:6602:1616:: with SMTP id x22mr4555800iow.65.1597110714710;
 Mon, 10 Aug 2020 18:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <1097808468.45751159.1597108422888.JavaMail.zimbra@redhat.com> <3704067.45751512.1597109127904.JavaMail.zimbra@redhat.com>
In-Reply-To: <3704067.45751512.1597109127904.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 10 Aug 2020 20:51:43 -0500
Message-ID: <CAH2r5mt389QPfeZPSTun9qkc=88ehFC1NzayewCoKU=qv+Epaw@mail.gmail.com>
Subject: Re: FS-Cache for cifs
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fscache (perhaps more so with the recent rewrite that Dave Howells
did) may be most well suited to cifs.ko (SMB3.1.1 mounts) among the
various file systems since it would allow offline caching of files and
directories leveraging:
1) handle leases and directory leases for "strict caching" models
or
2) directory change notification for "loose caching" models
(Although file version numbers are not provided, the combination of
creation time, 64 bit DiskFileId, and last write time with 100ns time
granularity is probably sufficient to use in conjunction with this)
In addition the protocol already supports four flags to control
whether client side offline caching can/should be done:
   SMB2_SHAREFLAG_MANUAL_CACHING
   SMB2_SHAREFLAG_AUTO_CACHING
   SMB2_SHAREFLAG_VDO_CACHING
   SMB2_SHAREFLAG_NO_CACHING

So fscache could be very, very useful for cifs.ko, especially for
metadata heavy workloads that are largely from one client ... but
fscache doesn't have tight integration with many cifs features (like
handle leases e.g.) yet.

It would make sense to better tie cifs.ko in with fscache (especially
as it has shown to be useful on other operating systems over
SMB3/SMB3.1.1).

On Mon, Aug 10, 2020 at 8:25 PM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Hello everyone,
>
> Recently I'd like to test fs-cache for cifs. But CONFIG_CIFS_FSCACHE is n=
ot set defaultly.
> Are there any concern to enable it? Test it to enbale fs-cache. It seems =
work. The file
> /proc/fs/fscache/stats is update when do some cp operations.
>
> Thanks.
>
> --
> Best regards!
> XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
>


--=20
Thanks,

Steve
