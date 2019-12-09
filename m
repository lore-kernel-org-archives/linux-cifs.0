Return-Path: <SRS0=ClyU=Z7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FFE5C43603
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Dec 2019 02:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 758A0206DB
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Dec 2019 02:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575858203;
	bh=ckJe1f9z+0yhWD6XSFJBjDXQNPIHJUlBowWUcrDFwnM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lEZLmrbgqsULN+TBgi35vghVnKog0OEC9LKbmNvGM2CKFWW6iDwVb0nx9RO/uBhkF
	 DuWsbJFh1pEaoXI8sNb5+s/UrqmLXmFF2i5+wjtIwQhZy8nHZDwcuT9n0/l8hc18yb
	 sjf9T93O2EWLtaibNuAWy46RMmQesKWuEaHfmU7o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLICXW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Dec 2019 21:23:22 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33562 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfLICXW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 8 Dec 2019 21:23:22 -0500
Received: by mail-lf1-f68.google.com with SMTP id n25so9449295lfl.0
        for <linux-cifs@vger.kernel.org>; Sun, 08 Dec 2019 18:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jtNlyNh+mGdA2q4AO/JzXYXFrnuZqMnTZ+qQdX6qkbw=;
        b=dZTJ7Zvl+X4Orlt5MxUX7caFe5OE31NxlNViH1WqR1xDkCBQ5UDeD13DvceCigkefe
         NkUu8l4gfBUHZtIbZVYr5+fPLPBcJzA6yphObSdWg1lXpEgnqyLssA5GvFfNgnMwdzMh
         tAhKKkBhHK2297EJrC4yT/2mx9cAPYvsAmndE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jtNlyNh+mGdA2q4AO/JzXYXFrnuZqMnTZ+qQdX6qkbw=;
        b=fEL2M9kaqoRPgB423TdQNsFcouW1gpd+Mag/fc/MNxZW96x3TMEmqrQ4EG0qkjM0Mm
         3Odtmt2P2hQy4gnwu2j0Pc6e8wT8wPjuWRzbIKh0t/lPotjtuw4NAAIUgqwZGRK3EI/a
         K41+yzvWSX1N1oL9VoH/Zt1yfdZ2lvp2g4W3SSapzNtr1hX08zkmAG+yTLOvtBGjo+aX
         9KlV8rnt+xxV8s9SElOguMoqfKjaDtFpi3PkDJH4POLxvd6EmYh7G/E37RM27Ug0Vwqa
         Ykuf1DU2E8EetbO2p6Wp5TSAptVv5jQoy6PUufDoQGFZvhbPKZe5rfBSg+DgfhjQfIlC
         12hg==
X-Gm-Message-State: APjAAAVBKEXHkeIs1ONqJi7cPKbGSWNaavKY8d5BkBNq5xEMP09buPt1
        N+xHo+2OXwhk+YATw5/7UDUFWGC42Pg=
X-Google-Smtp-Source: APXvYqzcrm4QeGmS/dN5Wk5PblslYP86qARceXnuIt/TQmjsi7r5sYOlXNqkn5TvdZjYbR81CQCMMg==
X-Received: by 2002:a19:23cb:: with SMTP id j194mr2586124lfj.79.1575858200383;
        Sun, 08 Dec 2019 18:23:20 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id j204sm1483315lfj.38.2019.12.08.18.23.19
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2019 18:23:19 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id u17so13798733lja.4
        for <linux-cifs@vger.kernel.org>; Sun, 08 Dec 2019 18:23:19 -0800 (PST)
X-Received: by 2002:a2e:241a:: with SMTP id k26mr15164274ljk.26.1575858198831;
 Sun, 08 Dec 2019 18:23:18 -0800 (PST)
MIME-Version: 1.0
References: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net> <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net>
In-Reply-To: <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 8 Dec 2019 18:23:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
Message-ID: <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
Subject: Re: refcount_t: underflow; use-after-free with CIFS umount after
 scsi-misc commit ef2cc88e2a205b8a11a19e78db63a70d3728cdf5
To:     Arthur Marsh <arthur.marsh@internode.on.net>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Dec 8, 2019 at 5:49 PM Arthur Marsh
<arthur.marsh@internode.on.net> wrote:
>
> This still happens with 5.5.0-rc1:

Does it happen 100% of the time?

Your bisection result looks pretty nonsensical - not that it's
impossible (anything is possible), but it really doesn't look very
likely. Which makes me think maybe it's slightly timing-sensitive or
something?

Would you mind trying to re-do the bisection, and for each kernel try
the mount thing at least a few times before you decide a kernel is
good?

Bisection is very powerful, but if _any_ of the kernels you marked
good weren't really good (they just happened to not trigger the
problem), bisection ends up giving completely the wrong answer. And
with that bisection commit, there's not even a hint of what could have
gone wrong.

             Linus
