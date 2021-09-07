Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CECBC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 10:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 521F2610E8
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 10:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343512AbhIGKfv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 06:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245704AbhIGKfo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 06:35:44 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DE3C06175F
        for <linux-cifs@vger.kernel.org>; Tue,  7 Sep 2021 03:34:38 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j1so6018066pjv.3
        for <linux-cifs@vger.kernel.org>; Tue, 07 Sep 2021 03:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A0g4QO4P0JFivl3i93tVvHLf7hXT+lwh80qMpB+sFIU=;
        b=PlG9uI4pcO0DKjy3pXIG40+g1Rbhd88KwsnPuktzA0Cj5bMkk5UgaEvGNwEq7BKpWw
         FpTjRHAtAXUUVA63co2DLmXJACk4J871tUa1DivRTLAFRhPKTPRsew9tyxD113qVVFEK
         JA3RKbw93J9xzqHoVn8t8HpNE4fq+eAKs/3Lw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A0g4QO4P0JFivl3i93tVvHLf7hXT+lwh80qMpB+sFIU=;
        b=WZ/+C3n8qWxZ7wVXKO9zDM48SFBZmlH7vrsAAMlVwRVEdMVcDkN7Mwb9h+TZSCWYMA
         EcBvb2ovMYXjVHbpH9Gx6g3yVoTePBiJdsWw/fbcCoJVo+M1uw+GWM1p/d+cPBZdB3ou
         bU0yyBFu9AKb5G8nA05irhzFR72cfj3PN3FebzGe3E6GrSM459S3ImfVEbS3NmdWwYpk
         PTi8gyatm3U01Ae0MQyBsHv7KZs3dYoFQSmXW4yXabWJyjNnLyeb65RVaXnX+dzFG5oo
         jqDwjtFj75mIC6tyLCoDcUzJbiDdXRarN0M9XP4oYZYTeAEHH2zqlu4s5gIXa4FIx7dp
         RTlQ==
X-Gm-Message-State: AOAM531NLvKcx1PAeks6TAAjSvRDtCj0WwnvFrhDSQF4K/oyG0zLDxxH
        YoihoZwQASYTw6qnqGiDkfQDSg==
X-Google-Smtp-Source: ABdhPJxqt9Cl0GMMJIDHlKAW0o79LWvz2tL8dP+PtsaMs6vPP0Qg42SAwBJIamsc/5wnjctucG12Ag==
X-Received: by 2002:a17:902:a50f:b029:11a:cd45:9009 with SMTP id s15-20020a170902a50fb029011acd459009mr14300427plq.38.1631010878319;
        Tue, 07 Sep 2021 03:34:38 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:4040:44a5:1453:e72c])
        by smtp.gmail.com with ESMTPSA id z12sm10230941pfe.79.2021.09.07.03.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 03:34:37 -0700 (PDT)
Date:   Tue, 7 Sep 2021 19:34:33 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: remove unnecessary conditions
Message-ID: <YTdAOWa/vLEhWQVt@google.com>
References: <20210907073428.GD18254@kili>
 <YTcdbOgmB7758K+/@google.com>
 <20210907085430.GM1957@kadam>
 <YTcrA2U2n5QAUkt5@google.com>
 <20210907091411.GG1935@kadam>
 <YTc4ClL0EwuHsPXP@google.com>
 <20210907101705.GH1935@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907101705.GH1935@kadam>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/09/07 13:17), Dan Carpenter wrote:
> > > 
> > > But you've seen it now, right?
> > 
> > A linear search in array of 5 elements or a binary search in array of 340
> > elements? Yea, I saw it. I'd prefer one extra uid_valid(), if you'd ask
> > me - why call the function if we already know that it'll fail.
> 
> It's a failure path.  Hopefully people will only give us valid data.
> 

I usually prefer to assume that remote clients are _not exactly_ nice folks.
Can this be a DoS vector - probably not. `cmp; je;` is several thousand
times cheaper that a bsearch, and this is a remote user request servicing
path. So. Just my 5 cents.

I'll leave it to you and Namjae to decide.
