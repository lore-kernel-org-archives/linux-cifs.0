Return-Path: <SRS0=SUdu=VI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1847BC74A36
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Jul 2019 01:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E279A20844
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Jul 2019 01:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562810373;
	bh=yctOEGr15lqaEv9xSMz2miuVt2G/lSyyty867n1nn/w=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=i1TLaoTz9MqZUdkSYmuOikt2DUeyD0cfU2TeVUTmjc3XTzzHOp9LNN4CbZgbzxn5c
	 aLraz7izP97mE96SmF66LkduKJmS7522pBzhObdjPgKZa4TR413Nx26gvWz4SIIKIV
	 veCOtRj/IBjyyHAN2JqCS5kcJTdHA5Ef771r2hVk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfGKB72 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Jul 2019 21:59:28 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42335 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbfGKB71 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Jul 2019 21:59:27 -0400
Received: by mail-lf1-f66.google.com with SMTP id s19so2892175lfb.9
        for <linux-cifs@vger.kernel.org>; Wed, 10 Jul 2019 18:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NiaFfYJ216nYjgBrBY5JKQAHNiRjdATog8sl2JxZW+g=;
        b=MQOzZI79mvoiVs1sgBWHfqE+YJM9b7M05jQpHMpAAyRFe0Cs7GZ1SKjYmbrPj6ztHM
         B7Jmo2E1tOKxmtYLHAeJfiv0Yw5iWNpJ6su3Aywbxq++FWe46hRTt1FaTYFdrs51gDai
         Fc+1NUhQh/izklmNT0WE5mkHqoWlVg+hybjs0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NiaFfYJ216nYjgBrBY5JKQAHNiRjdATog8sl2JxZW+g=;
        b=h4d1V5Z4z8sXfWZXHPpVvx/mglgBcUcFSh+GN18+nNHhff6/XqjTA5gcRoH6P8fELF
         TxEh2J4D3yFn0qg+SBp2fD1CoqV6cUbUFbeU0P9INgfnqfHAMlN8IYil1NyYcEqpzygd
         cRoMl7veU4qCYGo+c8Ti6Yj+5bQfO80iJIXA5ARrorh53UMPkD+wZCQK9Q9ZPIf4ekWt
         ezvzAbBrkVg2eRimKGzcZ/bXbhueIV7hKlwlZYWu0TiR64NWnKoa3e4be128cqcoRGgz
         2LeSAhFnXKBumYqemQXH8FC2ArNtWub5Mcx2yRXnpXzwICyJHs6ys6pH4Y5EhRS17DKT
         BVxg==
X-Gm-Message-State: APjAAAXhnyIHaG03BZwjUeICqqDhwSWyVKsHSTZFPUgbZl6mdHTn3AW2
        wno1ayN3cX6oa3WFinMLlvSLTZ7GfvE=
X-Google-Smtp-Source: APXvYqzpcROcLOAYd/faiJO/I7RLG/sRiOB5Jxw+nurhSmfZMt9CNgjworv9ZWpykI80EGBdapYv8Q==
X-Received: by 2002:a05:6512:1d2:: with SMTP id f18mr339969lfp.173.1562810365324;
        Wed, 10 Jul 2019 18:59:25 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id u11sm794198ljd.90.2019.07.10.18.59.21
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 18:59:23 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id u10so2880546lfm.12
        for <linux-cifs@vger.kernel.org>; Wed, 10 Jul 2019 18:59:21 -0700 (PDT)
X-Received: by 2002:ac2:4839:: with SMTP id 25mr355474lft.79.1562810361547;
 Wed, 10 Jul 2019 18:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <28477.1562362239@warthog.procyon.org.uk> <CAHk-=wjxoeMJfeBahnWH=9zShKp2bsVy527vo3_y8HfOdhwAAw@mail.gmail.com>
 <20190710194620.GA83443@gmail.com> <20190710201552.GB83443@gmail.com>
In-Reply-To: <20190710201552.GB83443@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 Jul 2019 18:59:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiFti6=K2fyAYhx-PSX9ovQPJUNp0FMdV0pDaO_pSx9MQ@mail.gmail.com>
Message-ID: <CAHk-=wiFti6=K2fyAYhx-PSX9ovQPJUNp0FMdV0pDaO_pSx9MQ@mail.gmail.com>
Subject: Re: [GIT PULL] Keys: Set 4 - Key ACLs for 5.3
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>, keyrings@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-nfs@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 10, 2019 at 1:15 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> Also worth noting that the key ACL patches were only in linux-next for 9 days
> before the pull request was sent.

Yes. I was not entirely happy with the whole key subsystem situation.
See my concerns in

  https://lore.kernel.org/lkml/CAHk-=wjEowdfG7v_4ttu3xhf9gqopj1+q1nGG86+mGfGDTEBBg@mail.gmail.com/

for more. That was before I realized it was buggy.

So it really would be good to have more people involved, and more
structure to the keys development (and, I suspect, much else under
security/)

Anyway, since it does seem like David is offline, I've just reverted
this from my tree, and will be continuing my normal merge window pull
requests (the other issues I have seen have fixes in their respective
trees).

                 Linus
