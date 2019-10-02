Return-Path: <SRS0=Gq5t=X3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E81C352AA
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Oct 2019 01:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A659A2168B
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Oct 2019 01:24:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SELtzi6L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbfJBBY5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Oct 2019 21:24:57 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46160 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729681AbfJBBY5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Oct 2019 21:24:57 -0400
Received: by mail-io1-f65.google.com with SMTP id c6so52935145ioo.13;
        Tue, 01 Oct 2019 18:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WW4/xkSDQIhkfsesG9YoLnUMFaDJjWvzNHAEkW7fJkA=;
        b=SELtzi6LjPYxNmk8TonlToYJ4dYGk/DN/z7VRaW2PzJqDnDQaeOgeMZP8OI+vQnSpw
         O4xP5NaXSwqj7tsClZcMPkxop33TffDN5xUboR3xabL07aaIv48fVdZlk4PaEvQT7Qsu
         T1U2kVyrfKhSP77hvAjdDypCgFCwkYs9LbYyG76k7NGbQ/wCwAZgJP/qyj8d5Mecfluc
         nTya1o8pxjDteRZSM7GQMakA071DvylNWInlaTtqBevulSTwArJxz8rnBm37bPnzTHyo
         LXzOTKZvZyqJQ8D6me/wa1HxQmXhOefjLqRI3O80Z782g7ub22+sA1zFlpRJiPWEvGjd
         EyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WW4/xkSDQIhkfsesG9YoLnUMFaDJjWvzNHAEkW7fJkA=;
        b=RJcuHXfOFw132Q4b+pYQuXV4atxgh2JFKk9x3KMZFsPh/3x1V/9OY12c/Gk7Hc0hBF
         SdPk5E6yhB4WaobIcaTndZdvsuAT0oXSe6k0voq5ppEfyo+EHaOzUnLRSyJB7qBtBpoT
         XODRJr7FxjoVI6pSi59cBN0WAnKitKOCA9hObGxw/SyIcZDHl7n0q+2FpE7MB9bFUqXD
         o7KKk0AGT0J7jWArBGNjecprRIpmY7UBLCLqX40npL+MC8qrEaOt/LhiJ9a241IX7ByV
         8c9kNqx/XB6ZBBTEwBh0oVg9kEWd/NGob3+/c8DgtIcTZ0calBLoKWOJBUjBTRnzYjn5
         vDfA==
X-Gm-Message-State: APjAAAVIUmV4uwMwAcVSSTFROCWqHBowPnspbzwO7ehF1yeQfGCYQg4L
        53nWHzN+XE+VzCo9tAxK9TM/Yljbr8ekk20dVUTMepB08rc=
X-Google-Smtp-Source: APXvYqwPE/tA65lT7b97m29565vMbtiutIr7UlQrMhri6hjabguFSCCYzFrADLTzw+T2Q2e4tXm6uRC+6WwGY65gP3w=
X-Received: by 2002:a92:d641:: with SMTP id x1mr1188239ilp.272.1569979495933;
 Tue, 01 Oct 2019 18:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mspD=iMnO-CuyHMf3jmS0zm7fbqNOXe0cqMcKsXfLAu-Q@mail.gmail.com>
 <20191001231017.67txq4dhrvhyzbu5@desk.local> <CAH2r5mvnYtmfpHY+jeUbN4JehQwY1XfBWYVNSLO+wx1wkAA6gA@mail.gmail.com>
 <20191002001859.qeyo3btl7tosz3vo@desk.local>
In-Reply-To: <20191002001859.qeyo3btl7tosz3vo@desk.local>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 1 Oct 2019 20:24:45 -0500
Message-ID: <CAH2r5mtzAgcJTrGuderq4DEHBXtPujcQ8DWJUzM0w=hHX8WbJQ@mail.gmail.com>
Subject: Re: Many unexpected warnings with current sparse
To:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Paulo Alcantara <paulo@paulo.ac>,
        David Howells <dhowells@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-sparse@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Oct 1, 2019 at 7:19 PM Luc Van Oostenryck
<luc.vanoostenryck@gmail.com> wrote:
>
> On Tue, Oct 01, 2019 at 06:14:23PM -0500, Steve French wrote:
> > It may be related to the following sparse make warning:
> >
> > No rule to make target
> > '/usr/include/x86_64-linux-gnu/bits/huge_val.h', needed by
> > 'sparse-llvm.o'
> >
> > I don't see huge_val.h in the Ubuntu 19 version of libc6-dev
>
> Yes, I've been bitten myself by this. It's fixed since a little while.
> So, just doing a clean build or removing all the deps (.*.d)
> should allow you to build sparse.
>
> I've verified the problem with asm and __inline in quota.h:
> it's autodetected by kconfig (CC_HAS_ASM_INLINE) so the exact config
> doesn't matter (only gcc's version does) but in all cases recent
> versions of sparse don't have a problem with it

Removed the dependencies and rebuilt as you suggested and it worked ...
and even better ... with the noise removed I now see two real bugs
(endian conversion missing on two lines) and only one possible problem
with sparse/gcc itself

Sparse now flags this line from one of Paulo's DFS features merged last year:

      struct smb_vol fake_vol = {0};

with

      "warning: Using plain integer as NULL pointer"

What is the recommended way to initialize a struct to avoid the sparse warning?


And what about the "namespace" warnings from the fscache (cache.o)
code that now show up?  I hadn't seen those before.
Any easy way to remove them?

"WARNING: module cifs uses symbol sigprocmask from namespace
fs/cifs/cache.o: $(deps_/home/sfrench/cifs-2.6/fs/cifs/cache.o), but
does not import it."
-- 
Thanks,

Steve
