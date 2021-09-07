Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5E8C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 03:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A71D60F13
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 03:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhIGDUQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 23:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhIGDUH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 23:20:07 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8356C061575
        for <linux-cifs@vger.kernel.org>; Mon,  6 Sep 2021 20:19:01 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id g184so8518960pgc.6
        for <linux-cifs@vger.kernel.org>; Mon, 06 Sep 2021 20:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PkQZihYPmfLXzqusdMh8EZu/5454FifzYyZDJ9HbUSc=;
        b=DZWloddjQ2BSx/hWXR/n0MTFD/Qwjr37YXHIOtnMJvZtIgSFkfqZBT9zdK/gZtRfyy
         x4jx4+BXGAoKxMNDiJvyC3LpnadOOuCruy5WLOMikO/yXVDBJYJ7kDj51xnHJ2R1HIcj
         drcmI0LvT8mzmH+vQ8HVCdjItka4IHvRGtmcztfKdWFQ5V2MXO6435DlKWt5UEudDtKf
         ot2LtQlPCMMi1skWs0vWtAiRUFydLffZJFnWf+p//yhJD7h2dXvcjItpefXSqIat8GUv
         vnMScaVDAc1IekeP7dylQ/AZ1kfqw3L4n4G0oB+6/MP7gAQ1ZPwrWLnu9SW8zUBF85Pa
         E4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PkQZihYPmfLXzqusdMh8EZu/5454FifzYyZDJ9HbUSc=;
        b=UoiuRcZ6KNl1A+4bAufWn1Q4kaDLWmJZw1dJaO3LUm2dxjIuXjkrqFQKVNr34RAVY3
         mnIfsJDjN8FktwHsnrEMdlgraRdbEt81BncCyhzKo3+G2DCpAKZApcbZsZV9p3J6NryS
         8OvIMkOQgnJqAtmkgzt7ijvLEfKZcmFY5jnX4reD76wvLbgl/elADi10aTAuCji2L6yi
         wK9eYXOLQViIF6GryWGnDM7zh0Tl+LeHTcM3wl3UuxOMHmStQHxliBJSWpoFWktqVP/k
         SMOBF9EW5gFUBdRwck4x64NegSbZsYR26/cR1+yiHEo9MlTMSC1ZNuNI6UYtMKeROied
         8qNQ==
X-Gm-Message-State: AOAM5311KSdoCqiZxP8eT1GGP6/wVntVRF3o5fHcHXpnHWGmCHtbinWU
        +YMfD5B2kk68CT4Fw3NuXnI=
X-Google-Smtp-Source: ABdhPJzw430pjC+bsWGCU8mmbOg5BWhKjH3ZQPqjxiZdAb+oVSEbvk6e60Mo3CbIzvvWK/97thD5ng==
X-Received: by 2002:a65:648b:: with SMTP id e11mr14887801pgv.138.1630984741151;
        Mon, 06 Sep 2021 20:19:01 -0700 (PDT)
Received: from xzhoux.usersys.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c21sm8933861pfd.200.2021.09.06.20.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 20:19:00 -0700 (PDT)
Date:   Tue, 7 Sep 2021 11:18:52 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Rohith Surabattula <rohiths@microsoft.com>
Subject: Re: [regression] lock test hang since 5.13-rc-smb3-part2
Message-ID: <20210907031852.fp5mqe6bar4ycekk@xzhoux.usersys.redhat.com>
References: <20210906114551.azccg5o4lh4fompe@xzhoux.usersys.redhat.com>
 <CACdtm0ZysFcRQga8DSrVz2iKVoFmTQihLzy+QY667+i06cQgAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACdtm0ZysFcRQga8DSrVz2iKVoFmTQihLzy+QY667+i06cQgAw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Sep 06, 2021 at 09:17:31PM +0530, Rohith Surabattula wrote:
> Can you please share the mount options.

 vers=3.11,mfsymlinks,username=root,password=xx

> 
> Did you observe the same failure with 5.14-rc5-smb3-fixes ?
> I ran the generic/478 test on 5.14 and didn't see any hang. But, test
> fails with below
> 
> generic/478     - output mismatch (see
> /home/lxsmbadmin/xfstests-dev/results//sm
>                                                b3/generic/478.out.bad)
>     --- tests/generic/478.out   2021-05-03 19:01:04.767577557 +0000
>     +++ /home/lxsmbadmin/xfstests-dev/results//smb3/generic/478.out.bad
> 2021-09-
>               06 15:39:39.625248615 +0000
>     @@ -1,13 +1,13 @@
>      QA output created by 478
>      get wrlck
>      lock could be placed
>     -get wrlck
>     -get wrlck
>      lock could be placed
>      get wrlck
>     ...
>     (Run 'diff -u /home/lxsmbadmin/xfstests-dev/tests/generic/478.out
> /home/lxsm
>                 badmin/xfstests-dev/results//smb3/generic/478.out.bad'
>  to see the entire diff)
> Ran: generic/478
> Failures: generic/478
> Failed 1 of 1 tests
> 
> Regards,
> Rohith
> 
> On Mon, Sep 6, 2021 at 5:16 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > Hi,
> >
> > Since this commit:
> >
> > commit c3f207ab29f793b8c942ce8067ed123f18d5b81b
> > Author: Rohith Surabattula <rohiths@microsoft.com>
> > Date:   Tue Apr 13 00:26:42 2021 -0500
> >
> >     cifs: Deferred close for files
> >
> > Xfstests generic/478 on CIFS can't finish like before. The test programme
> > never returns but killable. The kernel does not warn about soft or hard
> > lockups. So it looks like looping forever at some point.
> >
> > It's always reproducible. Without this commit, generic/478 fails the test
> > because of different lock schema but complete very fast. With this commit,
> > test hang like forever.
> >
> > Sorry that I do not look further here, because I have another bisecting to
> > do to hunting another regression.
> >
> > Thanks,
> > Murphy

-- 
Murphy
