Return-Path: <SRS0=B7dF=3T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E02C2D0DB
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jan 2020 19:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 219FC20658
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jan 2020 19:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AfOEdyKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgA3THd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jan 2020 14:07:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30688 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727476AbgA3THd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jan 2020 14:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580411251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hRlr2R73vsSNo6ih7PE6X4K2KpQ7XN3/rNyD+b0SB4Q=;
        b=AfOEdyKPW8lUhqgYN2yYHpdQhbOgpMX3iXrqe5+B6wgVlDTL9VjsHleg9JBHKG4vlkGqXx
        2UyLnCZiSsI+etau4tauz+OTPYkPFCiJSFtL2CxJGVOQkP0OzYFHfPpPFx9Rzb9TK5AUPq
        YMEViF4TV8atd6ghCs1Rw8oBTZazi6c=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-xtA317f-PViCmCSk270sdg-1; Thu, 30 Jan 2020 14:07:30 -0500
X-MC-Unique: xtA317f-PViCmCSk270sdg-1
Received: by mail-pl1-f197.google.com with SMTP id 71so639571plb.18
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2020 11:07:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hRlr2R73vsSNo6ih7PE6X4K2KpQ7XN3/rNyD+b0SB4Q=;
        b=PvpF56VkTTbwK6BKSlMKNtwINwkdWXdQxEoTjQk3U+SWMd1tjfqgYcWNkTmW0qBGs1
         ndY5t+ahStu4VejSC2d30/WzgN1Ay6MXEa0fn+kCGsgz5MyH/nU2AFRFEzpBYWzTINpO
         lpJPRJrlOpm9TGJr1aUK4XYtQ8N41NPN3WJcljfoX/Ikyxgu21M71HHNxFo3h5xM4n0l
         otKkUIyVojss0uakbSH6tJUEDAdjicyqHb7TBgVNpA38+uQrDP3oISnsBx+q8nwK3tw2
         6ZANla5ttygADQZ7bs+Ffmnuo8zm3kd/Eiy0Bun+njc3qp7264b9zVpl9AylBaq2rRWs
         htYQ==
X-Gm-Message-State: APjAAAWri7y2LCiMAiLYRKJFbpiJE88BZysQGn41kCCyl9rfI9GjekJd
        dzfXY3vjGnZJijjzsffByK1ASr2T0kVtFLKWsEXHa99Vcdoq1FTG1oNa73a61Ydvn2g0VwSiMv/
        VI1yw0XN4jTPxl5h14Di0RZT6DecsFj7KO0oP/g==
X-Received: by 2002:a17:902:788b:: with SMTP id q11mr6142598pll.21.1580411248119;
        Thu, 30 Jan 2020 11:07:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqytLIVAmijqO485hTWM6heoDmyDKuBy8oJgHrHm7Xu4V9oWPN1jBSsqEso5auK8VtWAteZHeX4GdEQelujcgmc=
X-Received: by 2002:a17:902:788b:: with SMTP id q11mr6142569pll.21.1580411247745;
 Thu, 30 Jan 2020 11:07:27 -0800 (PST)
MIME-Version: 1.0
References: <39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com>
 <87png0boej.fsf@cjr.nz> <5260c45c-0a31-168d-f9db-83bb6bd4a2cf@prodrive-technologies.com>
 <878smoqouf.fsf@cjr.nz> <VE1PR02MB55503665681374E805CA7815F53C0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87k16417ud.fsf@cjr.nz> <VE1PR02MB55502AA359141C1D29B2AB82F53F0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87y2uh264k.fsf@cjr.nz> <3ddf0683-0213-1c43-bcc7-cfc3cb8bc28b@prodrive-technologies.com>
 <871rs8eq3j.fsf@cjr.nz> <CALe0_75hsoemi1-du=-YO=xO_gR7-41RKirwNrnU+L753Ycrhg@mail.gmail.com>
 <CAH2r5mvEjD9rggUyTJMXKiyPn9fyRAq9DDWsn5xAkJC_6bFfrw@mail.gmail.com>
In-Reply-To: <CAH2r5mvEjD9rggUyTJMXKiyPn9fyRAq9DDWsn5xAkJC_6bFfrw@mail.gmail.com>
From:   Jacob Shivers <jshivers@redhat.com>
Date:   Thu, 30 Jan 2020 14:06:49 -0500
Message-ID: <CALe0_77uoUgs__d-O9TS5SKqGSeuDk4rHXNzAOE=TWPOOESDyg@mail.gmail.com>
Subject: Re: cifs.upcall requests ticket for wrong host when using dfs
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I missed that.
I just checked again and I completely overlooked this.

Sorry for the confusion.


On Thu, Jan 30, 2020 at 1:55 PM Steve French <smfrench@gmail.com> wrote:
>
> Fix is already upstream, merged into mainline Linux (commit
> 5739375ee4230980166807d347cc21c305532bbc)
>
> On Thu, Jan 30, 2020 at 11:47 AM Jacob Shivers <jshivers@redhat.com> wrote:
> >
> > Hello Paulo,
> >
> > I ran into this issue and noted that I can reproduce this 100% of the
> > time with a Samba SMB target. I tried with Windows SMB targets, even
> > when they are not part of the direct DFS namespace, but I have so far
> > been unable to reproduce that way.
> >
> > Hello Martijn,
> > Would you mind stating who the provider is for the impacted SMB target
> > in your environment?
> >
> > Thanks,
> > Jacob
> >
> > On Thu, Jan 9, 2020 at 8:06 AM Paulo Alcantara <pc@cjr.nz> wrote:
> > >
> > > Hi Martijn,
> > >
> > > Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
> > >
> > > > Yes, so far so good. Thanks a lot for the quick response! Not a trivial
> > > > patch as far I as i can judge.
> > >
> > > Cool! Thanks for the confirmation. Just sent a patch with this fix, BTW.
> > >
> > > > Also the machine we have running with your other DFS patches is running
> > > > for 8 weeks now and survived several relocations of our dfs shares and
> > > > adding/removal of DCs!
> > > >
> > > > Is there any news on the acceptance of your [PATCH v4 0/6] DFS fixes?
> > >
> > > I don't have any news, but I'll talk to Steve and Aurelien about them.
> > >
> > > Thanks,
> > > Paulo
> > >
> >
>
>
> --
> Thanks,
>
> Steve
>

