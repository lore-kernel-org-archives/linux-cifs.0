Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDCBC433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 10:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4381461164
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 10:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhEKKlC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 06:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhEKKlC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 May 2021 06:41:02 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D840C061574
        for <linux-cifs@vger.kernel.org>; Tue, 11 May 2021 03:39:56 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id u19-20020a0568302493b02902d61b0d29adso16315657ots.10
        for <linux-cifs@vger.kernel.org>; Tue, 11 May 2021 03:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mdcqW+KWuNLspQeI0uQffB9x0etiRD+WGNtdXxIgjjk=;
        b=CTeA09hNnzrp19VfquqQW2UbagKV3OIFdYYLlmy5lYWiyOO6V9AcUcNzlt1vBOjjtM
         tkgQc7CGxYrzcmz/2LXbekcgNnxuH2Q3aT1g1URNB8obMUMs57ZQUc/PiYkc69rse+ou
         ZuW8fUdzV8tuAT15T4C/F+fwzoxwUh+2HynKf57UqqELOPUyYt5cePj1fSiK1yWbATME
         Ujp3wrJcDAmJmduw13sGPaccedgM4Rp2NSuyfZ/lfhqMXr3y4ZRR/OOI4s78p6yTivV3
         lgZS7emnCxbxYcFU8BC8EGV5DlIKYUnvmjs4L1vcNfl/qmbb1v3jPAKlnCu3qGdiqOmZ
         f62w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mdcqW+KWuNLspQeI0uQffB9x0etiRD+WGNtdXxIgjjk=;
        b=oOXpNRQ1tBmokE8ht/ekk41KFRkb5OeQe9WOV1yVz/zgnZhMUOfablMHgBLhCeBU9X
         I3Q+Pjv16jjzRQ1CJEGaT3vLlI0Q+mRo2pMvYZ/ArNv5RJEsxDvjPcYWOIWSqr1bargb
         3h9R0wJ8/ci/OO9kxUiOKJ4HMSKB84XViynWzRcASbJR/WEm8RGyrYKBYMjWkASVqh/m
         jKNW3c1hjyNflf7Oln1xcwKbiZcwy2OUavJAPRn9YigCUhUiBR+bZTRVAwWnZNoUNf4p
         XVF9xKRwtGMkhueW9wEv4/g/5Du20LxC+uvU3Oy2Tt7Cgka+PqX7bhd7mBbabQrpkbkB
         /3bg==
X-Gm-Message-State: AOAM531cZ2Sk2ycdVvYv1m75N9ymSXSpCYzDFKtDTRFpsQUQqSOq7lth
        6cWvxkSX2b08Hs07ErYy3BOBPgvaaQQlXBB2Ya/+sILQd/7roA==
X-Google-Smtp-Source: ABdhPJywpy0SygRMx7iuZ8xIaIGE9UuuwN+pvt8osg9Z7tiqZ3mHfGNMJuv1Fq+m1kRVziqde/Yd31YAszLFVYHbOA8=
X-Received: by 2002:a05:6830:349b:: with SMTP id c27mr7849160otu.251.1620729594970;
 Tue, 11 May 2021 03:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAEVyU88zhTKVrbk-+YCrd4fTN=za8906CwFFGzDk0OovSD4=QA@mail.gmail.com>
 <877dkcuj8k.fsf@suse.com> <CAEVyU89=egaEAdvCD=FVkLwP4akzY3y8q=0hFW-hSryq0sxnxg@mail.gmail.com>
 <871rajv9ug.fsf@suse.com>
In-Reply-To: <871rajv9ug.fsf@suse.com>
From:   Calvin Chiang <calvin.chiang@gmail.com>
Date:   Tue, 11 May 2021 12:39:43 +0200
Message-ID: <CAEVyU88hgNyNgscCHf_GSNNDYbjPWSyH2033fbDEBXM2oLCiQQ@mail.gmail.com>
Subject: Re: Unable to find pw entry for uid
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

many thanks Aurelien for helping a newbie to get started!
just getting this setup now. i'll post back if i manage to find something.

On Thu, 6 May 2021 at 23:19, Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Calvin Chiang <calvin.chiang@gmail.com> writes:
> > I guess after i make the change in the cifs.upcall.c file i need to
> > autoreconf /config /make /make install ?
> > is it correct that this will overwrite all the files from the
> > cifs-utils package on my machine?
>
> Yes you need to make sure you have all the dependencies required to
> build cifs.upcall (your package manager of your distro might provide a
> way to get 'build dependencies' of a package). If it's missing some the
> configure script might disable the build of cifs.upcall so make sure it
> is built. You can run
>
> as regular user:
>
>    autoreconf -i
>    ./configure
>    make
>
> Check where is installed your current cifs.upcall ($ whereis
> cifs.upcall) usually it's in /usr/sbin/. I would recommend keeping a
> copy of the old one.
>
> as root (or sudo):
>
> make backup once:
>
>     cp /usr/sbin/cifs.upcall{,.backup}
>
> then to build and use new one (rm is to make sure it is rebuilt):
>
>      rm -f cifs.upcall && make && sudo cp cifs.upcall /usr/sbin/
>
> Good luck
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
