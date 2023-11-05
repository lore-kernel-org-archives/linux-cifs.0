Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1D6C4332F
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Nov 2023 19:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjKETkM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 Nov 2023 14:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjKETkL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 Nov 2023 14:40:11 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C0D97
        for <linux-cifs@vger.kernel.org>; Sun,  5 Nov 2023 11:40:08 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c6ed1b9a1cso50988431fa.3
        for <linux-cifs@vger.kernel.org>; Sun, 05 Nov 2023 11:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riscv-rocks.de; s=google; t=1699213206; x=1699818006; darn=vger.kernel.org;
        h=organization:user-agent:in-reply-to:content-disposition
         :mime-version:references:mail-followup-to:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tdHd2RkgvpY71GPn4HPjS487djSpT0ZIFSpSt/ISOD4=;
        b=X+pYnuXdg+npAenZgI/rLCZKhu+KSdkHzJ8ndT9cNd7ZKL44TmojtUT5PoyQ/Eeimy
         GpHtTo2chAMtWDp0RfVrPHJkZHuyfHZJBh/GrcIWi5EPTPPRAdXALjTjGJOLfDp8D8zE
         v6dzb2iXgX73cNlwxLcQeN0uaH+2ax1MQ4uBDZ53hoALt19w/R10spXLtw21uC/M/0G4
         H4nLdbWi6qNvVgN4w5J7w977Ine4lLSwiCZ/276tQ6GHPJI5L9uneYlYLWQ8w4orVKvl
         TCEwOQyZXd81UlZX8MgDO2DnCpmemV8KBbJQ5AytMwp7/DqhtTXIrpo3h0uMxZjlSbDU
         WphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699213206; x=1699818006;
        h=organization:user-agent:in-reply-to:content-disposition
         :mime-version:references:mail-followup-to:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tdHd2RkgvpY71GPn4HPjS487djSpT0ZIFSpSt/ISOD4=;
        b=Rm9gJr67NW6B8nGZkLPlKboaBeYnmpTZWspCAjcnWlB/icIndgDazxyMUceSuYVt67
         hP+NckMDUZ1hX3i1ui/2nd3LSaBgRs9nLO1MLOv6kJ0LypSAEyIXR6U6+ZDvCeooEI5S
         4YRg9TgeGIRhPWanLJwMLuN5biiZSca6TKEUUWeEtqNzptn3tFbZXo+qYYHbDgroXi1R
         +lQHvUOCZHIhC94oxFCTa3xix8xbJM4KQjXsp1nNH7wb4KZk5WRSLZmDJtcrYxY7tW2B
         GeQjAe794n5pQVxx2zWklXGcsUqYJmKJ4elo9R5m50/f83elQoCt2PrVAwoNl6Myz+ga
         Go9w==
X-Gm-Message-State: AOJu0YxU4qW8JY6mTbBeiOXpmURpafwzXdk4OuAs2FEbmR+hfjvW6TDS
        JdnJAYVpoHNUZ3xth9jGDEG15g==
X-Google-Smtp-Source: AGHT+IEDpPOSyQlEYQ599s+ukx7cAmvJLebp+81/y24pOJVyTL+Gogp1IDESO1lAeGkRsIwrlb9Yeg==
X-Received: by 2002:a2e:9015:0:b0:2c5:4a0:f3cb with SMTP id h21-20020a2e9015000000b002c504a0f3cbmr20373578ljg.11.1699213206039;
        Sun, 05 Nov 2023 11:40:06 -0800 (PST)
Received: from fedora.fritz.box (p5494469c.dip0.t-ipconnect.de. [84.148.70.156])
        by smtp.gmail.com with ESMTPSA id bs14-20020a056000070e00b0032d8eecf901sm7650582wrb.3.2023.11.05.11.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Nov 2023 11:40:05 -0800 (PST)
Date:   Sun, 5 Nov 2023 20:40:03 +0100
From:   Damian Tometzki <damian@riscv-rocks.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Damian Tometzki <damian@riscv-rocks.de>,
        John Sanpe <sanpeqf@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Paulo Alcantara <pc@manguebit.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: smb cifs: Linux 6.7 pre rc-1 kernel dump in smb2_get_aead_req
Message-ID: <ZUfvk-6y2pER6Rmc@fedora.fritz.box>
Reply-To: Damian Tometzki <damian@riscv-rocks.de>
Mail-Followup-To: Eric Biggers <ebiggers@kernel.org>,
        Steve French <smfrench@gmail.com>,
        Damian Tometzki <damian@riscv-rocks.de>,
        John Sanpe <sanpeqf@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Paulo Alcantara <pc@manguebit.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20231022183917.1013135-1-sanpeqf@gmail.com>
 <ZUfQo47uo0p2ZsYg@fedora.fritz.box>
 <CAH2r5msde65PMtn-96VZDAQkT_rq+e-2G4O+zbPUR8zSWGxMsg@mail.gmail.com>
 <20231105193601.GB91123@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231105193601.GB91123@sol.localdomain>
User-Agent: Mutt
X-Operating-System: Linux Fedora release 39 (Thirty Nine) (Kernel
 6.5.9-300.fc39.x86_64)
Organization: Linux hacker
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, 05. Nov 11:36, Eric Biggers wrote:
> On Sun, Nov 05, 2023 at 11:05:30AM -0700, Steve French wrote:
> > maybe related to this recent crypto patch?
> > 
> > https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=783fa2c94f4150fe1b7f7d88b3baf6d98f82b41b
> > 
> > On Sun, Nov 5, 2023, 10:32 Damian Tometzki <damian@riscv-rocks.de> wrote:
> > > [   83.530503] CPU: 7 PID: 4584 Comm: mount.cifs Tainted: G        W
> > >     6.6.0 #61
> > > [   83.530508] Hardware name: LENOVO 20XWCTO1WW/20XWCTO1WW, BIOS N32ET86W
> > > (1.62 ) 07/12/2023
> 
> The above suggests that this warning occurred on 6.6, not on 6.7 pre rc1.
> 
> - Eric
Hello,

is little bit missleading but it is 6.6 from linus mainline git with all
the pull request. 

Damian

