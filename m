Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139AEC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 19:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiCATHz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 14:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiCATHt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 14:07:49 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CD942484
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 11:07:07 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id bn33so23182049ljb.6
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 11:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+FYbGAw6yxU17iUDUp61Ry7f+ZSO9wN0ehJ+hGfk2DQ=;
        b=NEmpYuhxkY3jphhiKwB9rL7CFHETV0OarciDwH/Y25b8gogpFDGLbcsm2Hp5JlhbRM
         fgLdNaX0z1k1bpDTdAa2T+xhPoQGBlkWInAyVtxomjmoWydKKz6S1Vw5P8QyPxUNcXPG
         O8s4ZVUjpR1ZVkG2oqZOMI9ApgRXI/RsyC5iE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+FYbGAw6yxU17iUDUp61Ry7f+ZSO9wN0ehJ+hGfk2DQ=;
        b=YHYVcsX5YOq6Haizg9ay+/xd5TEJTKWPhK3mf/MW4AOptdp4cpYhNAAxcUlxo4xp0F
         XwqNMEz0hgS1iLvb2x4zpGNzLdVoB6erTVNpy3Vhf8qyturRV30iqAsL4cCWLLN4F8y0
         0St6ome8Nkn7kF8Zaj5EVpu+2mpbtQpn3A9Y3IbMJZZmBoOj0qGgDgeeS3gPgMzPyIBg
         WilFvn0FF1yNxmM4ox6rV/TYDob3xH81QbhyIH+IibKwHf8fOoxeSzh1c9QhUyKPp8bi
         y4f59TxPnEI57ErG4XvoJ4n6RRORJCDEcV7ey4M7PxCgcEhQNCpJXd9b/1R2H3t1HUCk
         5FVw==
X-Gm-Message-State: AOAM530vx4uQqYXrsDONA5JYAUoNbuW0ErxH5mzYfpUHXVLxTAt/NYSe
        aIRVja/TIRrv+1Q1Ziy6TbMBGL4Me+G8yczN8HE=
X-Google-Smtp-Source: ABdhPJyIST/Rquap7xdTfrGx8Z0NdNlwVz65hkCa6zc/WHnRmfYyB7u0GQ95IWlKEb7gugb5Ir3NbA==
X-Received: by 2002:a2e:b444:0:b0:235:656:9133 with SMTP id o4-20020a2eb444000000b0023506569133mr18493518ljm.481.1646161625241;
        Tue, 01 Mar 2022 11:07:05 -0800 (PST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id z25-20020a2eb539000000b00244db8751a7sm2053436ljm.67.2022.03.01.11.07.02
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 11:07:04 -0800 (PST)
Received: by mail-lj1-f169.google.com with SMTP id l12so11284188ljh.12
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 11:07:02 -0800 (PST)
X-Received: by 2002:a2e:3013:0:b0:246:2ca9:365e with SMTP id
 w19-20020a2e3013000000b002462ca9365emr17902580ljw.291.1646161622598; Tue, 01
 Mar 2022 11:07:02 -0800 (PST)
MIME-Version: 1.0
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com> <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <282f0f8d-f491-26fc-6ae0-604b367a5a1a@amd.com> <b2d20961dbb7533f380827a7fcc313ff849875c1.camel@HansenPartnership.com>
 <7D0C2A5D-500E-4F38-AD0C-A76E132A390E@kernel.org> <73fa82a20910c06784be2352a655acc59e9942ea.camel@HansenPartnership.com>
In-Reply-To: <73fa82a20910c06784be2352a655acc59e9942ea.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 1 Mar 2022 11:06:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiT5HX6Kp0Qv4ZYK_rkq9t5fZ5zZ7vzvi6pub9kgp=72g@mail.gmail.com>
Message-ID: <CAHk-=wiT5HX6Kp0Qv4ZYK_rkq9t5fZ5zZ7vzvi6pub9kgp=72g@mail.gmail.com>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sgx@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        tipc-discussion@lists.sourceforge.net,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Feb 28, 2022 at 2:29 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> However, if the desire is really to poison the loop variable then we
> can do
>
> #define list_for_each_entry(pos, head, member)                          \
>         for (pos = list_first_entry(head, typeof(*pos), member);        \
>              !list_entry_is_head(pos, head, member) && ((pos = NULL) == NULL;                   \
>              pos = list_next_entry(pos, member))
>
> Which would at least set pos to NULL when the loop completes.

That would actually have been excellent if we had done that
originally. It would not only avoid the stale and incorrectly typed
head entry left-over turd, it would also have made it very easy to
test for "did I find an entry in the loop".

But I don't much like it in the situation we are now.

Why? Mainly because it basically changes the semantics of the loop
_without_ any warnings about it.  And we don't actually get the
advantage of the nicer semantics, because we can't actually make code
do

        list_for_each_entry(entry, ....) {
                ..
        }
        if (!entry)
                return -ESRCH;
        .. use the entry we found ..

because that would be a disaster for back-porting, plus it would be a
flag-day issue (ie we'd have to change the semantics of the loop at
the same time we change every single user).

So instead of that simple "if (!entry)", we'd effectively have to
continue to use something that still works with the old world order
(ie that "if (list_entry_is_head())" model).

So we couldn't really take _advantage_ of the nicer semantics, and
we'd not even get a warning if somebody does it wrong - the code would
just silently do the wrong thing.

IOW: I don't think you are wrong about that patch: it would solve the
problem that Jakob wants to solve, and it would have absolutely been
much better if we had done this from the beginning. But I think that
in our current situation, it's actually a really fragile solution to
the "don't do that then" problem we have.

              Linus
