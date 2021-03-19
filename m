Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3C2C433E2
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 15:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 343436187E
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 15:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhCSPHk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhCSPHZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 11:07:25 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AABC06174A
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 08:07:24 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id u10so10492808lff.1
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 08:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oHNcqct6XjOR38fxMNSd6Z8ZVgwdWAPy8cnNEnzwxkc=;
        b=kn87DTv64QGx/RFcu4BJdCJ2toJKAuiH4gYuBE4sXuVMpv8G76T303jOjCyvAfdCYI
         +rAf9fRTwUjv9ihU1dXWPYQAybT/SJ11gzMeg7rNtoyOD6lYCeiD3R2evpslq8XdmYOe
         Hk7fpCz74YXy8lAPB18/5kZxgatmNw0yI6zO+iuh7DojBHToXI3/xlbZWGGWY17Q6S3N
         YcddjSIc5RCyZcR3WaV3112fgHqldFjAjp4BHBwTppBEg/wZTc5DCIlkDrKkox7m7tx+
         bLQ7SGMSOoe68VbYo0GLdgWY6A+z9kQPUvsgvaQ33umsw+ViK2cQqUOj4rNxtXXwEpmL
         OBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oHNcqct6XjOR38fxMNSd6Z8ZVgwdWAPy8cnNEnzwxkc=;
        b=XylivEx2hekFQuVS+y0/kpi/+t0NTmZS/52p849nW3yLotmXHyBDREeCwALZkcjhxc
         wbuZm0VI4WxbXgNFDJJPV3ufgfr9FmUO1wMhEFyMVC2mu+rmRElwZzdOa3u9L21s19TQ
         LWLAPPJv6ffzWoh1EazzA4wGOKxWuafXnYOf2wX/bPVvWs+wCEKWcdZOEuC1g46MiRMt
         NHcgJvjA0MOztT0kBHoBl+2KHouzD2tD4oQ62eNUEJYrQdyHRc41+vB1bsiK0YdGsGJq
         ewBbS6TzlIFFFdxsovVdKbZGESvaPic8NKeBrKAA+uuoITd1q0PgbrZeYEOU8nxw8hGT
         Bugw==
X-Gm-Message-State: AOAM530CIMaWfSYmAEcMnRwBHT6flGRs9qarjrbXGBZ7ZoGT7RQGX1L4
        Bk75k4z/Q9hoM2yToyQsWawhsVDSeHVxJo4q5Oo=
X-Google-Smtp-Source: ABdhPJwCuSXeEGUXpJZomib1eieqsrN1J2lAlXYs4RjxAJeKm3nLhrX8zsQXxo4UPKvFVEr7sfLIb6PE7dIlkd17cp4=
X-Received: by 2002:a19:7515:: with SMTP id y21mr1135292lfe.282.1616166443023;
 Fri, 19 Mar 2021 08:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <YFNRsYSWw77UMxw1@mwanda> <20210319131232.GA1057389@infradead.org>
In-Reply-To: <20210319131232.GA1057389@infradead.org>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Mar 2021 10:07:12 -0500
Message-ID: <CAH2r5muai5cA7C+Afku-PjgHCm9Zh+SkEiU1jvybL4xi-bre8g@mail.gmail.com>
Subject: Re: [bug report] cifsd: introduce SMB3 kernel server
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Namjae was working on a better high level summary of status so I would
expect to see a better description of that posted soon.  They also
restructured the patch set into a smaller set since rereviewing years
of their incremental patches would be far more time consuming.  It has
been presented over the past year or so at various conferences.
Although he had done a good job presenting on cifsd at the big Storage
Developer Conference last year (and also SambaXP etc.), a lot had
improved recently (e.g. it already passes more xfstests than many
servers).  There have been posts about cifsd on samba-technical and
linux-cifs where issues overlapped (e.g. compatibility with attributes
that Samba currently saves as xattrs) so the project is well known at
least among the samba community (and apparently it is commonly shipped
in various embedded devices already).   There is also a public mailing
list for the project so some of the discussion among the core group of
developers working on it most is probably on that.

I have been focused on testing it with Linux client.  See e.g. the run
from a couple days ago

     http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/26

and I have been pleasantly surprised at the progress, and have been
trying to make sure the test results are very visible, but as Ronnie
and others have mentioned, cifsd has already been very very useful for
testing the client (Samba is harder to tweak for testing).

On Fri, Mar 19, 2021 at 8:14 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Mar 18, 2021 at 04:12:17PM +0300, Dan Carpenter wrote:
> > [ The fs/cifsd/ directory needs to be added to the MAINTAINERS file
> >   so this stuff goes through linux-cifs@vger.kernel.org ]
>
> Err, how did this hit linux-next?  I've never even seen the code posted
> to a mailing list.



-- 
Thanks,

Steve
