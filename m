Return-Path: <SRS0=6k4I=4N=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0335C35DF2
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Feb 2020 05:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B25DC24684
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Feb 2020 05:16:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W69oMfgX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgBYFQA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Feb 2020 00:16:00 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40073 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYFQA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 Feb 2020 00:16:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id b185so6543579pfb.7
        for <linux-cifs@vger.kernel.org>; Mon, 24 Feb 2020 21:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Y+TBtCjMUWvqwV7Y7dPOwCIak5/Tc8pStA1sRr5jIt8=;
        b=W69oMfgX4SrzbCsxkh4xip1++cs5H+g8iEovbng4yf0hfWjSE1dAR3V7ZX2s1Gxc5M
         XySd0ImKZcduLK3oRpr0jfy92DZylyyvQ8xMMimyLaCoJvzVl1cJLItTMO3j6+yGMGGr
         6fX2l5Mq9TYx6aZxuyJPfknwV74V8PK+QtVwf9rpKUny2upQFnyHTpP343oXdTIOtwal
         1gQNdefBrVaa9ihBLhffU1B2R77HbFiGifMFr1xiLWPtediarVEWy4b3SqPgedZjf55k
         oc9Vf5BFE4wLulsZ6X5LPxtsX7T0udVGjSqd7aYZk/y+7LKvurxaUBOsvABq5Sxi3coV
         ywYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Y+TBtCjMUWvqwV7Y7dPOwCIak5/Tc8pStA1sRr5jIt8=;
        b=KZ7rgk5V72n0dOeHxm7hHsImMzSm37x59jWydJEVHY02fNwEQe3exKICpruLyT/w4m
         IRUYaxqI7FHn5IMUTjoXveHfT5EWre138FRoWT3KjmKagIefpBxTUROqt5JOGLv5K5jY
         BoTIBU8+aqKeiMTRHA9o79NTwIRajPTfnOxBdrChhZYy3e0Dqw46E4FpuBDXoV87iHC2
         9W4IuDb28h1YcXfk4IAtKj0npv/neILK3oCSpp8It+ZE+CSWv2lTDMKIlaAKR1vGaeO/
         sBp5757UaqWfBiJp0LPlCe/jb/bj/SWkwinj0CcywzygkhxSqx4S6NdzhqBCkZQNxtCr
         5NLw==
X-Gm-Message-State: APjAAAUkW/oxCP2CHjWTf78ljVJ6c6iHChzgYYYARUe1MTkkhUVn2L5D
        9qTdgvmUay2fe1N560KVQlWSBIeb
X-Google-Smtp-Source: APXvYqwNtkbCjJJLegZm05UpmsELo8nMS+ajrG8bxup/FdieQbo5Y58lA7ytKAPEt4ZnJhUB19c5Jg==
X-Received: by 2002:a65:5905:: with SMTP id f5mr19252633pgu.87.1582607759535;
        Mon, 24 Feb 2020 21:15:59 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r198sm15644100pfr.54.2020.02.24.21.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 21:15:58 -0800 (PST)
Date:   Tue, 25 Feb 2020 13:15:51 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: unlock file across process
Message-ID: <20200225051551.erpp36onb2kxmxjn@xzhoux.usersys.redhat.com>
References: <20200214043513.uh2jtb62qf54nmud@xzhoux.usersys.redhat.com>
 <370134c148a5f4d12df31a3a9020b66ef316a004.camel@kernel.org>
 <20200214142836.2rhitx3jfa5nxada@xzhoux.usersys.redhat.com>
 <CAKywueRV8+8qVP6e5nsvbpMQtwDU5mQGw5h51w=5rOsCN+Oj0w@mail.gmail.com>
 <20200219021039.3mpkrmvipd6z3wes@xzhoux.usersys.redhat.com>
 <CAKywueRvfABoVrdipic6x5_V31K0sOqs8T5y9VzJuyB4Q40bUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKywueRvfABoVrdipic6x5_V31K0sOqs8T5y9VzJuyB4Q40bUQ@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Feb 24, 2020 at 11:39:27AM -0800, Pavel Shilovsky wrote:
> вт, 18 февр. 2020 г. в 18:10, Murphy Zhou <jencce.kernel@gmail.com>:
> >
> > On Fri, Feb 14, 2020 at 11:03:00AM -0800, Pavel Shilovsky wrote:
> > > Also, please make sure that resulting patch works against Windows file
> > > share since the locking semantics may be different there.
> >
> > OK.
> >
> > >
> > > Depending on a kind of lease we have on a file, locks may be cached or
> > > not. We probably don't want to have different behavior for cached and
> > > non-cached locks. Especially given the fact that a lease may be broken
> > > in the middle of app execution and the different behavior will be
> > > applied immediately.
> >
> > Testing new patch with and without cache=none option, both samba
> > and Win2019 server.
> >
> > Thanks very much for reviewing!
> >
> 
> cache=none only affects IO and doesn't change the client behavior
> regarding locks. "nolease" mount option can be used to turn off leases
> and make all locks go to the server.

Great to know! I can't find it in any man page. Doing more tests.

Thanks!

> 
> --
> Best regards,
> Pavel Shilovsky
