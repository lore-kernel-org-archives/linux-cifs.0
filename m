Return-Path: <SRS0=ClyU=Z7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D959C43603
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Dec 2019 03:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E8BF2071A
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Dec 2019 03:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575861044;
	bh=EB2YpaWu4xz71ABGteOELs6xI2WRD092KsDmrSaOY2w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=CuDZmOKYRkw5bkh1nfaRDdDPOgB0nfBwdwV/k/V3LY0Z5HangIL+PH6YrSnFRQchx
	 wbF9uNGXfRza2Cne/bR1yv98O1GRsSAN+oUddJIR6QDrmJpGihohOVCJ9Bk3RMa2/c
	 MaSQNTYWySOdXSBQ2ITNlMZjBBpZCK2B0qWx+W38=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLIDKn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Dec 2019 22:10:43 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45013 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfLIDKn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 8 Dec 2019 22:10:43 -0500
Received: by mail-lf1-f66.google.com with SMTP id v201so9424397lfa.11
        for <linux-cifs@vger.kernel.org>; Sun, 08 Dec 2019 19:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IsO7dZNBIbPprBYyThs91AYRzpngSHQwAmXmPwKBIg0=;
        b=MEH4ND4Nbsa4gl4HUUT5shBi2298BFMiOLZ4+lFC2yve4Ysbypny+1LndDWz1cqNTn
         4oOqiljoOg+6px1pt4OX19oYw3KLSxMURevpnBdU9w0Twjw/NymP62DqGoJk504Xl2N3
         6N3ACDfBvVDPRNdQ8p5o0tC5Mtx69DXAZkVXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IsO7dZNBIbPprBYyThs91AYRzpngSHQwAmXmPwKBIg0=;
        b=W/cu2t5m6jNu9+1O6iWr3Yt+tci0zUlJFzvCRavaXzaASvuTwdo5lEbaXKG7e7hpTL
         2i8ywoZhvUqv/rzn4ugBmegaEiI0GKUm8elD9MhSx0/IBP7HQoMlId/cj/C0xGLs/4uj
         XgvbRmADXWXCMiLe/MPBIVnuUupHskqzphV+Xi1ouyBKqJpkblZujNiKfSdb7bpvZZ1c
         NvBQNCV2DMx2BmL+eHSn8So/ahwjqpjneX0RYObwIhkxj4D1p/tSusa5a9TMqfLzf6IO
         2/rN6+wsdeJH+O0vZlHxnhzSp6bfAb1W9lmUDBZO2+fXgH2d4yFPJhcQ08Clcx4uwHad
         rbbg==
X-Gm-Message-State: APjAAAWvI2zEGju+FM+qCIeCTYuhPxWdUNbrVsMlKIpn/r6QmgUaYTPh
        FfWMap1schRTfRTFBGzgL3DHp9PBvnI=
X-Google-Smtp-Source: APXvYqw5MtHAhUrUgKM+HB60sIvVJqtxzD2gnBSL+42NpyBeWgBI6IKiG6QMxQde1Dk9aHT3F1mMLQ==
X-Received: by 2002:a19:ec10:: with SMTP id b16mr1397068lfa.81.1575861040913;
        Sun, 08 Dec 2019 19:10:40 -0800 (PST)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id z26sm10055161lfq.69.2019.12.08.19.10.40
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2019 19:10:40 -0800 (PST)
Received: by mail-lj1-f176.google.com with SMTP id u17so13877971lja.4
        for <linux-cifs@vger.kernel.org>; Sun, 08 Dec 2019 19:10:40 -0800 (PST)
X-Received: by 2002:a2e:99d0:: with SMTP id l16mr15611418ljj.1.1575861039824;
 Sun, 08 Dec 2019 19:10:39 -0800 (PST)
MIME-Version: 1.0
References: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net>
 <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net> <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
 <20191209025209.GA4203@ZenIV.linux.org.uk>
In-Reply-To: <20191209025209.GA4203@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 8 Dec 2019 19:10:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=whY0GL-FpnjUmc7fjDqz-yRJ=QBO7LT6aEzt-_raAb1bw@mail.gmail.com>
Message-ID: <CAHk-=whY0GL-FpnjUmc7fjDqz-yRJ=QBO7LT6aEzt-_raAb1bw@mail.gmail.com>
Subject: Re: refcount_t: underflow; use-after-free with CIFS umount after
 scsi-misc commit ef2cc88e2a205b8a11a19e78db63a70d3728cdf5
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Arthur Marsh <arthur.marsh@internode.on.net>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Dec 8, 2019 at 6:52 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, the thing that is IME absolutely incompatible with bisection
> is CONFIG_GCC_PLUGIN_RANDSTRUCT.  It can affect frequencies badly
> enough, even in the cases when the bug isn't directly dependent
> upon that thing.

It will easily affect timing in major ways, yes.

You're right that at least the CI bots might want to disable it for
bisecting. Or force a particular seed for RANDSTRUCT - I seem to
recall that there was some way to make it be at least repeatable for
any particular structure.

         Linus
