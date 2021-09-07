Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E00C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 09:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCEFF610FE
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 09:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242828AbhIGJF2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 05:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245488AbhIGJFP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 05:05:15 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8889FC061757
        for <linux-cifs@vger.kernel.org>; Tue,  7 Sep 2021 02:04:09 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g184so9257618pgc.6
        for <linux-cifs@vger.kernel.org>; Tue, 07 Sep 2021 02:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JT40h1sqFKOXqQynjb32P0gwjUjlNSTVOulfaGgY9SY=;
        b=e+/yuG0NefU01Sn/0N6reRSzg64hFOX0e2EOZgQwHA/fJX9drVd8IEnz0/6hZ6TSUY
         iyZgb5WGpFSrKlJdxUwLChOZgef4Er8kh7A8HlrsCud6emMcaZZZAZC0BaV6489eCW73
         BtnctBXpzDC8Y186iUxsEuvAt03Sq+R8Xa/YQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JT40h1sqFKOXqQynjb32P0gwjUjlNSTVOulfaGgY9SY=;
        b=Z0R9iikdjDZC4vUKQFtB8EZA3UUd7/ox7rQM1rCIxKX1s0ppEJe4KQc3xRGkMHI7Y2
         ohb9H53hO8MmIX4ahpGGh3Ap3uqA82hAxNg/z5Zi92HIMcDg9fYkWp5YLPYE6xyxjvPv
         sMah/W8vpGg+TXNKBWjNDWvQbqz0/IRkKbmdsr1vy115WI0+vierLRCI9U57VNur39wo
         k/HkaQM4XBsUwmOBmjMTVQkubMiAxHMoXyBjmRG1izw4P/iUtMYVQZGavpMSGghfhsA8
         c5fpxGtT1PLy6yKxit2uTdcqX7m83NglXnpsP1hpdvnQnF6/R+B1myvYvp+XPg3pmw2x
         /WAQ==
X-Gm-Message-State: AOAM531R+jK6MRKzfrNNKPH2w1cZtvBDQXWswtXZqYIM89JOA5Mcq24I
        srE4V0GAeeDpiqRqeceLP1+RXQ==
X-Google-Smtp-Source: ABdhPJwm31KByBnVlIs7w8AhfNmb0SVtrFTViZTx/Z2vDwUsInRHv7kDRMPZxQRCnuti15RgLOsTmQ==
X-Received: by 2002:a63:1b60:: with SMTP id b32mr16009500pgm.422.1631005449064;
        Tue, 07 Sep 2021 02:04:09 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:4040:44a5:1453:e72c])
        by smtp.gmail.com with ESMTPSA id f10sm143297pfd.53.2021.09.07.02.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 02:04:08 -0700 (PDT)
Date:   Tue, 7 Sep 2021 18:04:03 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: remove unnecessary conditions
Message-ID: <YTcrA2U2n5QAUkt5@google.com>
References: <20210907073428.GD18254@kili>
 <YTcdbOgmB7758K+/@google.com>
 <20210907085430.GM1957@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907085430.GM1957@kadam>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/09/07 11:54), Dan Carpenter wrote:
> On Tue, Sep 07, 2021 at 05:06:04PM +0900, Sergey Senozhatsky wrote:
> > On (21/09/07 10:34), Dan Carpenter wrote:
> > >  
> > >  		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
> > > -		if (id >= 0) {
> > > -			/*
> > > -			 * Translate raw sid into kuid in the server's user
> > > -			 * namespace.
> > > -			 */
> > > -			uid = make_kuid(&init_user_ns, id);
> > > -
> > > -			/* If this is an idmapped mount, apply the idmapping. */
> > > -			uid = kuid_from_mnt(user_ns, uid);
> > > -			if (uid_valid(uid)) {
> > > -				fattr->cf_uid = uid;
> > > -				rc = 0;
> > > -			}
> > > +		/*
> > > +		 * Translate raw sid into kuid in the server's user
> > > +		 * namespace.
> > > +		 */
> > > +		uid = make_kuid(&init_user_ns, id);
> > 
> > Can make_kuid() return INVALID_UID? IOW, uid_valid(uid) here as well?
> 
> No need to check twice.  We're going to check at the end.
> 
> > 
> > > +
> > > +		/* If this is an idmapped mount, apply the idmapping. */
> > > +		uid = kuid_from_mnt(user_ns, uid);
> > > +		if (uid_valid(uid)) {
>                     ^^^^^^^^^^^^^^
> The check here is sufficient.

My point was more that a potentially invalid UID is passed to kuid_from_mnt()
and kgid_from_mnt(). I don't see map_id_up(), for example, checking that
passed UID is valid. So decided to double check.
