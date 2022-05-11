Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED255C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 11 May 2022 00:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiEKAls (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 May 2022 20:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEKAlq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 May 2022 20:41:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0B9715E623
        for <linux-cifs@vger.kernel.org>; Tue, 10 May 2022 17:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652229705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jJSi4aKW6GZ1pHGof78LzVnOA8S/9TyEfDUNqPbCc+o=;
        b=be10Elmha7YlxI8BeIwskkRvX5MSMyTfhLGFqnrraz5DWrB0GqV9sIt6MuvYw158ibJe3k
        pwcKxGBSFETXW7Af6beNg1Rs+Nwo5py73TCWixWTNyhz8S/e/muNZWA5+/wylHO4bv5BaP
        RKhiugFGlgXTdMiIarniYW+3j/WyYK4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-uh79AtL7Mb6XNrbxAeAOIw-1; Tue, 10 May 2022 20:41:43 -0400
X-MC-Unique: uh79AtL7Mb6XNrbxAeAOIw-1
Received: by mail-ed1-f72.google.com with SMTP id eg38-20020a05640228a600b00425d61d0302so321248edb.17
        for <linux-cifs@vger.kernel.org>; Tue, 10 May 2022 17:41:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jJSi4aKW6GZ1pHGof78LzVnOA8S/9TyEfDUNqPbCc+o=;
        b=3wO9fpgZBMIk7gtNDdg22SdBesQjzDP2ohGnlEjdI099ohOYqfxV2tqQ9fAqJ3BrgQ
         CWKpkPVb9sGlU8NP0TSBzM2BRtu6RjTQDoNGMECySryvRlcevVY0I4vWKPvzA4Xx4agq
         ZBlQfT8EQbEw1SyhnT0cBiqJF1w24s4kKp19jGsxIYNXAc2kXg1lY0Ck9DuzcyvqyjX1
         NWAJpdKr+48Goum+lgOZs3/fvHb0Is2oVVTcmH0mG6EM3ODrIVBWzgQ0F/WmnMY6WHT3
         /DFanpvXOMu4XxYNayhbfRs+4nZLk11+XRgU+s65Q05BsQKv3XIGOUs1Qu0ywEy2YJRx
         129g==
X-Gm-Message-State: AOAM530yMNDwdfQ7XXi65foaiKsACuLZ6Vfl/IvvA/p2RII8r2xfwgEG
        r3G15w87TtKJp1pQFSdDRYhqL7g3CAhvg9heAMQgth0+3+U1Tda6utRkh+pXo/SYQVvYh4BT6hf
        E99hMYOU4zofWLfbZM+zQZdjCRsQ624URCGgb6g==
X-Received: by 2002:a05:6402:10cc:b0:428:90ee:2572 with SMTP id p12-20020a05640210cc00b0042890ee2572mr16927897edu.103.1652229701807;
        Tue, 10 May 2022 17:41:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyF2HUc/dll9QPPnpdm3pY0NcdAe4NwshG5SdxlS090nyjj47Qqe2W6n1Y2slRKuxaRzZjUp7k+6pbig8BmsJE=
X-Received: by 2002:a05:6402:10cc:b0:428:90ee:2572 with SMTP id
 p12-20020a05640210cc00b0042890ee2572mr16927887edu.103.1652229701658; Tue, 10
 May 2022 17:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220509234207.2469586-1-lsahlber@redhat.com> <20220509234207.2469586-5-lsahlber@redhat.com>
 <20220510225705.vf7ibmpdjqdeq72v@cyberdelia>
In-Reply-To: <20220510225705.vf7ibmpdjqdeq72v@cyberdelia>
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Wed, 11 May 2022 10:41:30 +1000
Message-ID: <CAGvGhF77=ygG6DmWatqjh9PGDjgd4TxyuaYqyhN-TiLHq238qw@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: cache the dirents for entries in a cached directory
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, May 11, 2022 at 8:57 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Hi Ronnie,
>
> On 05/10, Ronnie Sahlberg wrote:
> >+struct cached_dirents {
> >+      bool is_valid:1;
> >+      bool is_failed:1;
>
> Just as I commented in the other thread, having both fields above confuses me.
> Shouldn't using is_valid/!is_valid be enough?

We need two because semantically there are three states we need to describe:
1, we have successfully cached all entries and cache is valid
2, we are in the process of building the cache, and the cache might
eventually become complete and valid
3, we are in the process of building the cache, but there has been a
failure and the cache will never be complete or valid

>
>
> Cheers,
>
> Enzo
>

