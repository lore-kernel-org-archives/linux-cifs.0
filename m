Return-Path: <SRS0=bM6M=4H=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325E4C34047
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Feb 2020 17:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 049352464E
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Feb 2020 17:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582131643;
	bh=v+9b/hr8Jv4VAOV0zdeJ4j1Oyz2AnGcLWoJAJWFKAVw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lRrkaqVm0OBKVXEJ4iIDDAaMMwnMv5lkn5kgrurd9+Nj/etWOjVLKLJLMO0SwFTal
	 YKuUrq6+V8aHU7zqaVNo4aTFMBkj6OWgeLa1YzZuuaeiLT7rVdo3LnuRtdC/dgeBn5
	 kZSOw1CK453V5Whb9xaqCgtlGi3P2FvbjZi4FBzM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgBSRAm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Feb 2020 12:00:42 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41661 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgBSRAm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Feb 2020 12:00:42 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so1115167ljc.8
        for <linux-cifs@vger.kernel.org>; Wed, 19 Feb 2020 09:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+5MHK2yWJoKDFDgFN/xoudtHEVHOYHcak3UXICAOE48=;
        b=QIshA1U9KR9JH3ePvLT5ZY3Vx07hTFRKDbl+K9mKTvwZGUJgQmsNDzQNHyD8IIWR2d
         Q0yRg6+HxDrXEGdXe9VGj4GRg91S0SZg3nykCIODKvhX+L/Jppo0cyFJQEhwA9V8JwEk
         yE0AI/4FI83Suua0qMGWnvqbFXRE2hRE7jPY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+5MHK2yWJoKDFDgFN/xoudtHEVHOYHcak3UXICAOE48=;
        b=fmcmIWhbSu/2jaY/VdANXTJp5ioHuTxVierigN6XPTWdoj/ovBs/yWLFZ5adGMVXFB
         knrjQzlEy32hQ8IVNyGdxWmAk3VptkmAfcNPyFLIizT8j4IQpCqVF9TKLk7cDZlYGwvr
         hGl5797VkPsFe8Ug2xxRgrv1qjOzVaCK0hMq0nnwwEgahpc8TDRqhVpYBTG2SmSoUt2F
         7RGgVGZ3rTaMo68J8AO9gS7AY/cS10jCLu9S5MBIqlfpBWIVeC1DGmHOb0uhoyPjZbqb
         mEvpVk0pWvaBeTRBBxP0apImSPRqfFVnQW0PjPZZY5lhmOcodPR/yBgil/DE1gE1hMEH
         SSUw==
X-Gm-Message-State: APjAAAWot02D4Po2ZWKxxQJzwvxlX4LR5Vcm1mhuPhmK/kE3r5o4U4og
        IRgvyXn3m1ItYqruEYwLMzIGi+aAHcA=
X-Google-Smtp-Source: APXvYqxG1qrGHhfXNHm6hkK9p5UUNPk69+JjUdz1IMmCGEUNjeb5bidTaGnaeuYCqfWxCZZEEanmsA==
X-Received: by 2002:a2e:9050:: with SMTP id n16mr16434949ljg.49.1582131639766;
        Wed, 19 Feb 2020 09:00:39 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id u9sm156470ljk.33.2020.02.19.09.00.38
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 09:00:39 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id n18so1111384ljo.7
        for <linux-cifs@vger.kernel.org>; Wed, 19 Feb 2020 09:00:38 -0800 (PST)
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr16681270ljk.201.1582131638422;
 Wed, 19 Feb 2020 09:00:38 -0800 (PST)
MIME-Version: 1.0
References: <158212290024.224464.862376690360037918.stgit@warthog.procyon.org.uk>
 <CAMuHMdV+H0p3qFV=gDz0dssXVhzd+L_eEn6s0jzrU5M79_50HQ@mail.gmail.com> <227117.1582124888@warthog.procyon.org.uk>
In-Reply-To: <227117.1582124888@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 19 Feb 2020 09:00:22 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjFwT-fRw0kH-dYS9M5eBz3Jg0FeUfhf6VnGrPMVDDCBg@mail.gmail.com>
Message-ID: <CAHk-=wjFwT-fRw0kH-dYS9M5eBz3Jg0FeUfhf6VnGrPMVDDCBg@mail.gmail.com>
Subject: Re: [RFC PATCH] vfs: syscalls: Add create_automount() and remove_automount()
To:     David Howells <dhowells@redhat.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>, coda@cs.cmu.edu,
        linux-afs@vger.kernel.org, CIFS <linux-cifs@vger.kernel.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 19, 2020 at 7:08 AM David Howells <dhowells@redhat.com> wrote:
>
>
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> > The above nicely explains what the patch does.
> > However, unless I'm missing something, this fails to explain the "why"
> > (except for the vague "[...] is something that AFS needs ...".
>
> I'm not allowed to implement pioctl() for Linux, so I have to find some other
> 'structured' (to quote Linus) way to implement the extra functions for the
> in-kernel AFS client.

Honestly, the "create_mountpoint()" thing isn't any better. It's worse
and exposes an interface that makes no sense.

What are the insane pioctl semantics you want?

If you can't even open a file on the filesystem, you damn well
shouldn't be able to to "pioctl" on it.

And if you *can* open a file on the filesystem, why can't you just use
ioctl on it?

So no, the new system calls make no sense, and your explanation for
them is lacking too.

Give a very concrete example of what you want to do, and why AFS would
be so super-duper-magical, and why you can't just use ioctl on an
existing directory.

And no, "maybe the directories aren't readable" isn't an excuse, as
mentioned. Why the hell would you want to do pioctl on a non-readable
path in the first place?

                Linus
