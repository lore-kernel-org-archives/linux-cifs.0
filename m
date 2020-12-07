Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2554EC0018C
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 15:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA7323741
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 15:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgLGP15 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 10:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGP15 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 10:27:57 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8092DC061749;
        Mon,  7 Dec 2020 07:27:42 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id r127so13274303yba.10;
        Mon, 07 Dec 2020 07:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=phc99HuuYD9VXJ3x5GtiGwc8Fm58CjNcdWxCONF1lr4=;
        b=W1sx0xc5Oyx9rInMyuvkllJOMoJ/K2uQESx8VLM9hcYq20EfXPbtKNkoEG1UEJJKn1
         jWoB/gpBoOvhCsp7xX5K/YJ25C7EfNSlpyw4QHRg37EKJCetQMRUdzVKHyldTlT5+Pcn
         0PX9ojzZJoRpucQDXdqVxCHi2/jqbqMNljxuM7OFp/rGTVgFNpkIAU+T319FqvPHqQws
         ggzjj7oK5S+Z0Eo+fNq+LDaxrJFDjzO8ELkoYlRpsdHJ6RYiOW/iKxNudYKmlsdybqh8
         uggdF/lszY2WP5tpD2eTEu1Bdl0qIv5VGoRXMxprHytrsDICL/KWPShVF4nLbLEj3/kw
         fRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=phc99HuuYD9VXJ3x5GtiGwc8Fm58CjNcdWxCONF1lr4=;
        b=kAXVhh2cvF2hTRI3kHc764YFW4r3GXe0Apd1Iz+Weli+4qUlo1L5gLO+J4nhYxCBwV
         OZZqp3PxHjlzU2Rj0YX39kZRjDIqERyxxFTSS1bEKJf7FbjYpjtFoSX9ZBeF7kyXlZ/l
         PihJyZ91gBFJbI1Qib93adaV86WOIYC+MtwvZ6daGdt5rMozXLf5S4fkqwe3XMPLZAd2
         8UafXhGFGmH+IEtouoLTZh/r8zicGBRd/QL1jOzSna5uOlDOcSAu1h7s3lG1F2IPmi20
         85cdnfP0FVXYlPnsViz6Ex9mPshsQJZsGbuLbfaXeoX3KblTn9sJ177pVMpSg76Ix3IY
         Zw/w==
X-Gm-Message-State: AOAM532cjitMSPrfh0PbdevFbzLiwKb/int2HGlq/bQjFjj00dxEJjNi
        /Ha4rs9mZ0i2ThE24aVBk22141o/KWkPaMrijrrM8VEnhE0=
X-Google-Smtp-Source: ABdhPJz3Ywtpw3noy4z1jp1OoPuIHl/rJhw4cgAY2X6IKQ9w8OIaenSGx7PQIbvT4pYrAZcAwUG48NAi5XbLczQnqvo=
X-Received: by 2002:a25:c68c:: with SMTP id k134mr24345206ybf.451.1607354861831;
 Mon, 07 Dec 2020 07:27:41 -0800 (PST)
MIME-Version: 1.0
References: <20201027204226.26906-1-pboris@amazon.com> <CAHhKpQ7v_nPwBx2czk7rVXK3ZrmsZrAkcxDFOgq0ABTOVc7iSA@mail.gmail.com>
 <CANT5p=q2YvkEOEa4bS=-nbPOc9Xwa=4gnc09csCcszMmMjYSPg@mail.gmail.com>
In-Reply-To: <CANT5p=q2YvkEOEa4bS=-nbPOc9Xwa=4gnc09csCcszMmMjYSPg@mail.gmail.com>
From:   Boris Protopopov <boris.v.protopopov@gmail.com>
Date:   Mon, 7 Dec 2020 10:27:31 -0500
Message-ID: <CAHhKpQ7PwgDysS3nUAA0ALLdMZqnzG6q6wL1tmn3aqOPwZbyyg@mail.gmail.com>
Subject: Re: [PATCH] Add support for getting and setting SACLs
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Boris Protopopov <pboris@amazon.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello, Shyam,

sorry for the delayed reply and thanks for looking at this patch. Yes,
the testing was done using the extended versions of
getcifsacl/setcifsacl (added setting owner and SACL support), the
patch for that posted recently via samba-technical (message ID
<20201120214918.12517-1-pboris@amazon.com>). I have tested
setting/getting the owner, DACL, and SACL, for all the DACL/SACL flags
(-a, -D, -M, -S), SACL type SYSTEM_AUDIT. This testing was done
against 5.10.0-rc1 and 4.14.203 (the latter required porting the
user-space patch). I believe this testing has fully exercised the code
changes in question.

I will look at contributing to the fsxtesting-cifs code, but I think
the setcifsacl/getcifsact patch that enables easy access to the
descriptor components is a pre-requisite for such contributions.

Thanks!


On Wed, Dec 2, 2020 at 5:43 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Boris,
>
> At a high level, the changes look good to me. Will go through the
> changes in more detail tomorrow morning.
>
> On a related note, we may need more test coverage in this area.
> Can you please share your testing output against your changes?
> Or even better, if you can contribute some xfstests for this use case:
> https://wiki.samba.org/index.php/Xfstesting-cifs
>
> Regards,
> Shyam
>
> On Wed, Dec 2, 2020 at 12:24 AM Boris Protopopov
> <boris.v.protopopov@gmail.com> wrote:
> >
> > Hello,
> > I am checking in to see if anyone had a chance to take a look at this
> > patch. I would appreciate any feedback.
> > Thanks!
> >
> > On Tue, Oct 27, 2020 at 5:01 PM Boris Protopopov via samba-technical
> > <samba-technical@lists.samba.org> wrote:
> > >
> > > Add SYSTEM_SECURITY access flag and use with smb2 when opening
> > > files for getting/setting SACLs. Add "system.cifs_ntsd_full"
> > > extended attribute to allow user-space access to the functionality.
> > > Avoid multiple server calls when setting owner, DACL, and SACL.
> > >
> > > Signed-off-by: Boris Protopopov <pboris@amazon.com>
> > > ---
> > ...
>
>
>
> --
> -Shyam
