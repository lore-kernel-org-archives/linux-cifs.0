Return-Path: <SRS0=/4jl=C2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA3FC43461
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 09:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B032B2076D
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 09:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=suse.com header.i=@suse.com header.b="mLnW0wv+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgIQJNu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Sep 2020 05:13:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:35644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbgIQJNu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Sep 2020 05:13:50 -0400
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 05:13:49 EDT
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=cantorsusede;
        t=1600333060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=famKF+XMOKxj9RIIBpLyn0W2SzDsJEQI3Coi+xTbT5A=;
        b=mLnW0wv+3lICt4WHfpf+SMU87ZTINOu+LRuzZFNRaVBPYbO84O5ustW+ZsJvpyWYwfh7K+
        JGTbI2WtzcJv6pWwyak5orzTXy48N7xuchQHtWX713y664p5oeleJKd+MHUFdpufNen47x
        ETue3Apd1sBGiCAfAkkUGgihen1muTEIMbO371/KiR7XthZAcJWcs25covNHInJhTjNCRa
        dbxQBX7EphkPjkIlStSdl4DI7FPVbdyQLqY6A1XgnkK3TR4dV9FRrcVRn7yJ8MpR82PzXA
        9y2rxGCOfV26KgTDAjHwts+o/1KdlTPDy5p0fRITWHoFV4l12Z/yXbV9MaNiKA==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 66804ACC6;
        Thu, 17 Sep 2020 08:58:14 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Subject: Re: [PATCH][SMB3] mount.cifs: use SUDO_UID env variable for cruid
In-Reply-To: <CANT5p=qV6BWojwBET+kYUwJf7tQDFoRtUb8O+pWHrqWMw5e5LQ@mail.gmail.com>
References: <CANT5p=oiTY63d5yVyywiTrCqpAmvaugMVVpQRV7RT7ZA9HU2+Q@mail.gmail.com>
 <87r1r2ugzw.fsf@suse.com>
 <CANT5p=qV6BWojwBET+kYUwJf7tQDFoRtUb8O+pWHrqWMw5e5LQ@mail.gmail.com>
Date:   Thu, 17 Sep 2020 10:57:39 +0200
Message-ID: <87wo0slr0c.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
>> This function later forks, so if you allocate before the fork, you need
>> to free in parent and in the child.
>
> Good point.
> I think I'm doing it right though. I allocate all that I need at the begi=
nning.
> And the function always terminates in mount_exit, both for parent and
> child. That is where the allocations are freed.

Ah yes ok

> I know the child will have the options buffer unnecessarily allocated,
> but isn't the code flow simpler this way?
> Please let me know if you see an issue there.

No it's fine I think

> Good catch. This code existed before my changes, and I had noted this
> bug. But forgot it during my changes. :)
> I was actually confused if I should reset after the label, or before the =
goto.
> After the label is an added overhead in the "happy" code path, so went
> with this. But it does reduce the chances of missing out a reset.
> For now I'll reset options before each goto mount_retry. Please let me
> know if you feel the other approach is better.

I think we can agree that mount.cifs is not performance critical code
but that it should be safe so I think reset after the label is
better. (To be honnest the whole function could use some refactoring and
be split up probably, but that can be a patch for later on)

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
