Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7AC7C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 19:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbiEXTir (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 May 2022 15:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiEXTir (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 May 2022 15:38:47 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0743475205
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 12:38:46 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id j7so7241553vsp.12
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 12:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e8nuYc9dliw4emhvfxOE3OncwYJB+L9w1QybNQ/CRm8=;
        b=VuPVul49Dms2cyK69RRE+es9U2F/PYX1Kd3zllp+3kOWvytQRNBMLJouYDzC0vVz8x
         rqUHOLfgOetjyxDoyo/b0tQ/fVvrzGH25zZwSCNEtDIg33NIqL02chMtnuaYiYyYj/Ae
         UTk/iIHOj8Cdpv0skBjawl6qo2YppujM/R9KsgrwYDHnjYTvZfsfkuB8robGwCWhevGZ
         q48HZSodPaFbX7fChFmfehb3r7ehB5ijt2FpFVG4/P1wVQsyqnE7C8vBjpSLEsaaJVJQ
         hPFCDSR4ssWOnAbPb900lmqmkNi/4gQA3IUVbgvIWJuHnLf0d+avH/JZ7neOgUJu6prV
         kZbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e8nuYc9dliw4emhvfxOE3OncwYJB+L9w1QybNQ/CRm8=;
        b=0LUkGwWRlhDOhbxpazeddbXJdRjprXWHBs8xsbdiPo8P1U6RgVNO7CAehKCGwvaIHY
         NAEpNsG+oU7LeizmodWEe2KxhfboScOIQ5dK/DgJGLkYWBMOLVF1IKKCQy2dVbgyz8d4
         irQXEEhEFBygHICwd1t3yIT2ou3sAky6stZQlpkZ7ng+yPBIDAZO2vgSQDW9sVYFfvkI
         sNn7cm+wpd2GQXOtBYjaI8neTSAKWz03IpY6aySBFu6ukt5TVfdVs/tVWhcUjQG020+S
         x2luQUD/BMLR19kSPz/yg5rPO8/b4OFSp5o2fuCGFRbVL0DvRz+Mp3km475uXjGOBOyD
         92nQ==
X-Gm-Message-State: AOAM533vZTIwMRw9tEbK9JpQNhgIgvQKYiEbQCGpmkvIWHT8gt5DbhTP
        ucDxLmEPrw0U7QtuHDpVMDs8VxQ/+SZb3e+gCZji/O9Y
X-Google-Smtp-Source: ABdhPJwXzz1LNGMmYlHcG+netE3BYHFxOEYL8xBIxaC0ugc3Llp7mv58Oci6UHA5iUoCO6Bq3atoIxSlNjz/G4XcUOo=
X-Received: by 2002:a67:1787:0:b0:337:d8cd:35b2 with SMTP id
 129-20020a671787000000b00337d8cd35b2mr1584564vsx.29.1653421125025; Tue, 24
 May 2022 12:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220509234207.2469586-1-lsahlber@redhat.com> <20220509234207.2469586-5-lsahlber@redhat.com>
 <20220510225705.vf7ibmpdjqdeq72v@cyberdelia> <CAGvGhF77=ygG6DmWatqjh9PGDjgd4TxyuaYqyhN-TiLHq238qw@mail.gmail.com>
In-Reply-To: <CAGvGhF77=ygG6DmWatqjh9PGDjgd4TxyuaYqyhN-TiLHq238qw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 24 May 2022 14:38:34 -0500
Message-ID: <CAH2r5mvA8Cqw3HrxjQTB7yNoPLwKcFj4v2kxuTUae936+PYkQQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: cache the dirents for entries in a cached directory
To:     Leif Sahlberg <lsahlber@redhat.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged this patch (and the 3 earlier ones are already in
for-next) into cifs-2.6.git for-next pending testing.

Did minor whitespace cleanup

On Tue, May 10, 2022 at 7:41 PM Leif Sahlberg <lsahlber@redhat.com> wrote:
>
> On Wed, May 11, 2022 at 8:57 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
> >
> > Hi Ronnie,
> >
> > On 05/10, Ronnie Sahlberg wrote:
> > >+struct cached_dirents {
> > >+      bool is_valid:1;
> > >+      bool is_failed:1;
> >
> > Just as I commented in the other thread, having both fields above confuses me.
> > Shouldn't using is_valid/!is_valid be enough?
>
> We need two because semantically there are three states we need to describe:
> 1, we have successfully cached all entries and cache is valid
> 2, we are in the process of building the cache, and the cache might
> eventually become complete and valid
> 3, we are in the process of building the cache, but there has been a
> failure and the cache will never be complete or valid
>
> >
> >
> > Cheers,
> >
> > Enzo
> >
>


-- 
Thanks,

Steve
