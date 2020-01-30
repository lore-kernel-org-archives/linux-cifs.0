Return-Path: <SRS0=B7dF=3T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399C2C2D0DB
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jan 2020 18:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088BB20702
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jan 2020 18:55:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGanAmQa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbgA3Szb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jan 2020 13:55:31 -0500
Received: from mail-il1-f172.google.com ([209.85.166.172]:37657 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgA3Szb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jan 2020 13:55:31 -0500
Received: by mail-il1-f172.google.com with SMTP id v13so3990134iln.4
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2020 10:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CZeEb8FjE4DHJGjCeMVoihLV/ZKhpSh79haiybxPqxc=;
        b=hGanAmQaf1UvSvK/UmSFWeCfnDsaME3CyOCdRXwRurVF9JhdhZo/YFsrfND/lrkiN1
         +ZpkFVfFsOYotm8HU/egDxnkGkjXVnTHm0IeBZaGlcAjM+9Eb+YoK5Am8Eaf+BJ3RNnj
         /XMYI35PTMNiDOCPedebN5DaaVqk6tG9TcyFnKB9G/7QSDxcLV/fxmdsU2Ee2yQjdEGw
         XeOveJduf0QS/svaI/Ckd6KaMM4aoOjKW9zpZC12hqbMe4/rU5G7pKZa3aTkEWcf/8X9
         0V+7mmXmM92D0uyLL/CFebRYcCTR3osRzelTrbyiA+eQJAo7q416QR78nRLoekmtKzRc
         IUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CZeEb8FjE4DHJGjCeMVoihLV/ZKhpSh79haiybxPqxc=;
        b=eecHvW58T9a95FyY1qIEx53l4dSjQLYCJqQDR+1lt10UEOLml5lyc//5rAnmMPN65L
         dJV4Zr3+wth8zAZuVVvP6rMl7iJnV4hYkaw7OGaoY1eTJZwUEOC8w4BBTmv09hh0NEXy
         kInQST6xJk6B0jHpG7SW0hxoUqi+qAkYktSet3AXZiEpE8Tpy30TFoX5dd8HkQ3x0xc2
         zrShcBte1GhpSOLp5HWcspfcnAsYe8O3aipZbR8fdz8n19FWTwr3okW7gU4ilLKJv+2F
         v0FQ0lKZMBviuPIFptHRMWuUu31UWxBOzDs99KGrBaT7TquEGrWMekWbXK+Qm5IAc+yV
         E+3Q==
X-Gm-Message-State: APjAAAUknkE8LPUCG9JPHq94ppMOVvH2Sl3jF9Ve6ZRoNE8ktm9sPwAd
        yrGqd9SLT6iKWL+I+UKGk66v2IN0sJjn6rrdZ47JGEHegGU=
X-Google-Smtp-Source: APXvYqxcjxi5Ug64bB+V+4C0ZtozDYlYx1bsjSyTyjO67e9yU8EbD9HOnRuaLakMkGa7uut5x67iZ567PdOoYQvx1Hw=
X-Received: by 2002:a92:cb8c:: with SMTP id z12mr5537168ilo.5.1580410530041;
 Thu, 30 Jan 2020 10:55:30 -0800 (PST)
MIME-Version: 1.0
References: <39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com>
 <87png0boej.fsf@cjr.nz> <5260c45c-0a31-168d-f9db-83bb6bd4a2cf@prodrive-technologies.com>
 <878smoqouf.fsf@cjr.nz> <VE1PR02MB55503665681374E805CA7815F53C0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87k16417ud.fsf@cjr.nz> <VE1PR02MB55502AA359141C1D29B2AB82F53F0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87y2uh264k.fsf@cjr.nz> <3ddf0683-0213-1c43-bcc7-cfc3cb8bc28b@prodrive-technologies.com>
 <871rs8eq3j.fsf@cjr.nz> <CALe0_75hsoemi1-du=-YO=xO_gR7-41RKirwNrnU+L753Ycrhg@mail.gmail.com>
In-Reply-To: <CALe0_75hsoemi1-du=-YO=xO_gR7-41RKirwNrnU+L753Ycrhg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 30 Jan 2020 12:55:19 -0600
Message-ID: <CAH2r5mvEjD9rggUyTJMXKiyPn9fyRAq9DDWsn5xAkJC_6bFfrw@mail.gmail.com>
Subject: Re: cifs.upcall requests ticket for wrong host when using dfs
To:     Jacob Shivers <jshivers@redhat.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix is already upstream, merged into mainline Linux (commit
5739375ee4230980166807d347cc21c305532bbc)

On Thu, Jan 30, 2020 at 11:47 AM Jacob Shivers <jshivers@redhat.com> wrote:
>
> Hello Paulo,
>
> I ran into this issue and noted that I can reproduce this 100% of the
> time with a Samba SMB target. I tried with Windows SMB targets, even
> when they are not part of the direct DFS namespace, but I have so far
> been unable to reproduce that way.
>
> Hello Martijn,
> Would you mind stating who the provider is for the impacted SMB target
> in your environment?
>
> Thanks,
> Jacob
>
> On Thu, Jan 9, 2020 at 8:06 AM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Hi Martijn,
> >
> > Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
> >
> > > Yes, so far so good. Thanks a lot for the quick response! Not a trivial
> > > patch as far I as i can judge.
> >
> > Cool! Thanks for the confirmation. Just sent a patch with this fix, BTW.
> >
> > > Also the machine we have running with your other DFS patches is running
> > > for 8 weeks now and survived several relocations of our dfs shares and
> > > adding/removal of DCs!
> > >
> > > Is there any news on the acceptance of your [PATCH v4 0/6] DFS fixes?
> >
> > I don't have any news, but I'll talk to Steve and Aurelien about them.
> >
> > Thanks,
> > Paulo
> >
>


-- 
Thanks,

Steve
