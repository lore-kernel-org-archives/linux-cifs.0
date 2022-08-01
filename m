Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF34C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 16:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiHAQhW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 12:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiHAQhF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 12:37:05 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D275418E10
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 09:36:17 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id f10so4786755uap.2
        for <linux-cifs@vger.kernel.org>; Mon, 01 Aug 2022 09:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kNrs7hWIPE1lYpDTyA5maJK34DzwF/dmuXI8ilDCJgE=;
        b=CUDxRCr2DWNQimtuDqnJ6nH8QmEfkr+tz6WbhpihSD0PP04NuBIMNhgqC7PbmMDtMH
         4gpCgHZpo93TSD2q03lzdtkaindqDv+Ye3iGDCo1oG4fP4jbzTptuChs3N3wnAQzAtWT
         o5GevQYmz+Ji31jbGBCzr7eiG6tsUWX4bSuvlHqIMJ5VmhBlRUuNaIjt3lehbsbjzETb
         oMO5gInhaW+QYf3htxvYARtzS0aixo3DErl3hLTkeTaZ14uuMujjlA6+sB+QI+V9ryHY
         3KoID+dYgD3hzvlSAi02blEZwAz9L2OAQNWSJhC3c38jFP8ssjXpR/IELWjMuHrxizKd
         wf/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kNrs7hWIPE1lYpDTyA5maJK34DzwF/dmuXI8ilDCJgE=;
        b=r03nwMqtD1sUHxtUtAApUVRmkLOJLh3qIpnPIbmyaHSk8/n3oY8mQrGGbtUSKUaShY
         Q+H85RkHY0ZsdS/j1nv/DHFOG8m8NremZaqQ+3hdATBxyHB4+0fCZ1mHCBSGZsuyidRF
         Y0+wjq6v9HvLWZsB2DJCaY3Q3CzmRey7nuUDwyGvOt/DTgNiand0RJ5T4HPxnPtebk7D
         g8ga5/Utz8S8fBUZPgPzirgusqN+d9NcIuVpgK2DooClvJNxAxFekXK9n9hVSI1x6I8N
         3FzkJKP43ygYO1pmfxIdTFiQX+MTe2aP8SW0Z+87Q1YaXY1EO7pOvfYG5glPudY8q4Ld
         v0cw==
X-Gm-Message-State: ACgBeo1GEd9PTD/FZH0rjdVaJPsLICJQD4xa+HAl4kPzEdsRRQEksZjn
        5y1jLyd23lyP27faHn9DwRpSXFHPQoLqZxrjGTg=
X-Google-Smtp-Source: AA6agR7MAvWqirt8IxwuYN4HWXIJ1q9csJNP6md0ijL2XfhvGPUkgWCBs03lWXn3ShNS0VDl0eHfFwx51YK95aS8gIk=
X-Received: by 2002:ab0:7a69:0:b0:384:dc02:a08e with SMTP id
 c9-20020ab07a69000000b00384dc02a08emr6395636uat.4.1659371770853; Mon, 01 Aug
 2022 09:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
 <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com>
 <20220801121507.zpcnz55jj2qre3kh@cyberdelia> <20220801123930.ltet3tadtdlf6hpq@cyberdelia>
 <f8632ab0-ddc4-ff8e-1bd1-3088cf05eb5c@talpey.com>
In-Reply-To: <f8632ab0-ddc4-ff8e-1bd1-3088cf05eb5c@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 1 Aug 2022 11:36:00 -0500
Message-ID: <CAH2r5muP5ZgcsypLSFm1t2cE8x4n_8fmu7heoUiW5x2L6rN__Q@mail.gmail.com>
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
To:     Tom Talpey <tom@talpey.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Aug 1, 2022 at 10:49 AM Tom Talpey <tom@talpey.com> wrote:
>
> I think a big chunk of cifsfs.c, and a boatload of module params,
> can be similarly conditionalized.

Good point - and will make it easier to read as well.  Perhaps I can
move most of cifsfs.c to smbfs.c and just leave smb1 specific
things in cifsfs.c so it can be optionally compiled out?
