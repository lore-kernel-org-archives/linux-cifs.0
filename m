Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2A4C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 09:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A64261103
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 09:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbhIGKAv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 06:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhIGKAu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 06:00:50 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0825C061757
        for <linux-cifs@vger.kernel.org>; Tue,  7 Sep 2021 02:59:44 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso1172306pjh.5
        for <linux-cifs@vger.kernel.org>; Tue, 07 Sep 2021 02:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6E1IHRfuK0QKnb5J1Cnvln+5nY7KJz29n+pahsDSy4w=;
        b=e7azfc4GEcCjJJdZlC3m3ac8M8sTeFNAH7Ox3mi18QHX6AFOC7K/CsNnGzO5wgEpI3
         65ucC0HlfVImZWS3c++ObuhAYNEjD8kRNLPCg3IYHK+avZ21+o9kBefWeaTr/052GNgC
         yzj6RxoZfA+37VAr6OFZbwv0h3jR1gS8N3SW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6E1IHRfuK0QKnb5J1Cnvln+5nY7KJz29n+pahsDSy4w=;
        b=QXsxnDrPufqzTPKqppEn/jQlLJYw7WayjEbFbD67LVijAJKz5Dp9NuUQcEW1EzD9QC
         mi8BZsosELDn/B42maaZ58zNkIaBs8GqqPonENLo046Vji1BHqDOJtOLtnwDH7s0VXRd
         lAuaFFi0X4StAsAUk4j0AEuolFrNcwexpdwrQbNJW0YA9hmL9z++d5/i4zrq+0MtoXdV
         sYSCRECfdur+ru57Q1yDcCaX7ufwBReQ+5Lag2cBfQuJqxmafheGyNIyL6gH6cDAnviq
         1c7F0Ru/xz4RKkrmSEPCBeolfg3eXxLMP0p+TrzVI/bb0fwct435OFIFimPRbzletuNU
         6NCw==
X-Gm-Message-State: AOAM533Yp5rF++t3JHH9GJtgNlN3lo3CV5IGrNHQeowM4uYXClXTN2QI
        36qL5Nj5aDrfpW/0tYDhc3ForQ==
X-Google-Smtp-Source: ABdhPJxrogRVtyBb2ubiJ71vxVXr8ITmgC2AAbCgQvpVgvYrXyUudcrxPaSNcnu0OyTUcvNphkPWBg==
X-Received: by 2002:a17:90a:f18b:: with SMTP id bv11mr3722912pjb.82.1631008784322;
        Tue, 07 Sep 2021 02:59:44 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:4040:44a5:1453:e72c])
        by smtp.gmail.com with ESMTPSA id j11sm10337763pfa.10.2021.09.07.02.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 02:59:43 -0700 (PDT)
Date:   Tue, 7 Sep 2021 18:59:38 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: remove unnecessary conditions
Message-ID: <YTc4ClL0EwuHsPXP@google.com>
References: <20210907073428.GD18254@kili>
 <YTcdbOgmB7758K+/@google.com>
 <20210907085430.GM1957@kadam>
 <YTcrA2U2n5QAUkt5@google.com>
 <20210907091411.GG1935@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907091411.GG1935@kadam>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/09/07 12:14), Dan Carpenter wrote:
[..]
> > > > 
> > > > Can make_kuid() return INVALID_UID? IOW, uid_valid(uid) here as well?
> > > 
> > > No need to check twice.  We're going to check at the end.
> > > 
> > > > 
> > > > > +
> > > > > +		/* If this is an idmapped mount, apply the idmapping. */
> > > > > +		uid = kuid_from_mnt(user_ns, uid);
> > > > > +		if (uid_valid(uid)) {
> > >                     ^^^^^^^^^^^^^^
> > > The check here is sufficient.
> > 
> > My point was more that a potentially invalid UID is passed to kuid_from_mnt()
> > and kgid_from_mnt(). I don't see map_id_up(), for example, checking that
> > passed UID is valid. So decided to double check.
> 
> But you've seen it now, right?

A linear search in array of 5 elements or a binary search in array of 340
elements? Yea, I saw it. I'd prefer one extra uid_valid(), if you'd ask
me - why call the function if we already know that it'll fail.
