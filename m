Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE67C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 03:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiFBDuw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jun 2022 23:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiFBDuv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Jun 2022 23:50:51 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043792A3069
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 20:50:50 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id e184so6235297ybf.8
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jun 2022 20:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IBdNYD60efGATnwpUuCo8jNHsQwHl2PtmLe075HGPb0=;
        b=Pr49W4Xjh8gto8paMDyhQwa/LU689IVKzqSXy8dFqbzGFK53amCPZPGLPX6ShMLPy5
         jgOU8DLUteOd1fF9b5z07z0eUIa080Yod8816PFBvCHZuP86nUMwoJfP+x5JarEsgZ4d
         3lfLgB1q6O6ftEa3vM69SrA5CJ38ZH6raAPwg/RwUgNBCoExy5J0BZ14R9cMvIT51kfh
         F4xBBTCeLr8zFoJqayR5lt+zFj9+g53MvleMcuPCx7IXfJLW2J5FaeCLXDLPFlnJQ/g9
         GGmGw2xJsQiUmSCnAyhbXYDvj5AVbUb6NxTrie68vXkyIsFOhuqmBlAhW5aEiZ3XHLE2
         4lTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IBdNYD60efGATnwpUuCo8jNHsQwHl2PtmLe075HGPb0=;
        b=muRjMjlePBWfw+VhKfh2G0jf314vRlUvndwkHpWgeIi6TN5DRbWQbbEBhyfwltRLYG
         SPTmQfRo4EWC8srjIiw8UBHvq2sXx0VjEiwglxFQkiCbGs7kqYUdDH0Fds68INNbbBav
         fA2RW5QMhcUh6Hce4Z3m9TuJ+qAO8d1gJt7i8ZH5IFLES2NCrKgZiRmg2cOrzwlTZOM9
         ICtAO24BgsEgWShXNzznpChSZ1BYJhsZTFVsBdzapOdApWR+3U49ggdM5HfKz2FiagoT
         gfr33oa5eMlgZScCbZIgaan6PrNdEIS9WyTPBfP0hrqnlB//aKfig90Uk0b/hOg0IdF0
         2k/A==
X-Gm-Message-State: AOAM5332y2BMBPaVYdIUB7zYnePTMYc2e+VMlNMSRezmLKg8oDC3O+Mr
        Io2lDNf2h0i/+sjWDo5/72CTrZjpBcYx5blWMYBzon/9
X-Google-Smtp-Source: ABdhPJzDB+OHYG9BwcCexRyKhjKP/8O8uLhNZEeYaPbqIeyKQGYCVqb4ZE8N9IfzdV9Zta4ZRV77q0S2S920LHuswn8=
X-Received: by 2002:a25:fe08:0:b0:655:85c6:af82 with SMTP id
 k8-20020a25fe08000000b0065585c6af82mr3153036ybe.150.1654141849171; Wed, 01
 Jun 2022 20:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtUe2f0xi5zu0Np0bkyv7K9BKKgUkUJp2b25BteHBFjeg@mail.gmail.com>
 <CAH2r5mufZdKWrUGbp0Pha5C6YrYqUR-=vT2Pw8TixtzVaQuk0Q@mail.gmail.com>
In-Reply-To: <CAH2r5mufZdKWrUGbp0Pha5C6YrYqUR-=vT2Pw8TixtzVaQuk0Q@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 2 Jun 2022 13:50:37 +1000
Message-ID: <CAN05THSsPTYBfKyxvO7eO3mOViEi+KFG3a_V9qhwG0yu02OX3Q@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Do not build smb1ops.c if legacy support is disabled
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

looks good   reviewed by me

On Thu, 2 Jun 2022 at 13:47, Steve French via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Another minor one to remove some unneeded SMB20 code when legacy is disabled
>
>
> On Wed, Jun 1, 2022 at 9:39 PM Steve French <smfrench@gmail.com> wrote:
> >
> > We should not be including unused SMB1/CIFS functions when legacy
> > support is disabled (CONFIG_CIFS_ALLOW_INSECURE_LEGACY turned
> > off), but especially obvious is not needing to build smb1ops.c
> > at all when legacy support is disabled. Over time we can move
> > more SMB1/CIFS and SMB2.0 legacy functions into ifdefs but this
> > is a good start (and shrinks the module size a few percent).
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
