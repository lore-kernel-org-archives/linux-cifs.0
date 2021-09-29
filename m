Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F209C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 17:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ADDA61527
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 17:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343872AbhI2RNa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 13:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345228AbhI2RN3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 13:13:29 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B78C06161C
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 10:11:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id i19so10754369lfu.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 10:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uUbnHbLyf5o1DnBsGiccLe6lWUa/JEseyE2dPuIMIsw=;
        b=DMG19+w4Mox8aAfb7Jb2ptW+nUyECAU3xVBS3HSMz15vWFc4gRJQuMjp+07uSZ+Dw7
         OAWvkMQzxm0uvOgW+RQB3zzw5OoJMvjmcKNzI+qdawW/+nBeirGG1mgm/I+wra9OfOGO
         3kiHBToHC7oCkC94MvpIfnhIo9aht9AUIQgJlZVB5CChh28OcGUeHQ6RwPZFb36TsIyg
         tf1puBkutGGHmXb8f81JFHBs6IyjHwk1BT9s+VBU61kVBEO70b6J/jVaFloAxUYMwtoX
         dRR3fopT0rAC8xfti7g8sodTyph7EqnMe9JDGDKFWwzJ9mlJk/HmWudJ1rzWMSYfxnz2
         DMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uUbnHbLyf5o1DnBsGiccLe6lWUa/JEseyE2dPuIMIsw=;
        b=d/TYl6A18RDoVas2mo9JhPKhqcqHcwDvMVjtcYuRb+dQPYoCMXeyT33PkLANHUfcfu
         9hrnJ8WkX90YKTAZWTQ7hLU/I15sH/4C6rSD181nYkPi1rkHUQadNGF+leGQSJqMnPzM
         iHwRLN7QGk/u8kyEGgzLXQwlfSOMC9VSHAgRLpnunilt49gyBfQQtmQo6DjtjwdRMN9r
         0B+cyvBkbRtVOYRcx227FpDudhN75hv2sbw8GU2Q/atS+UkApqZkdiSZz9JImZLw1fgU
         SAMaEd+bH2nDiWAGQ/F9D/1TLLbcnQWvq3hcbi/bpNe2EePG7tAMrMcHsP7bOaJRRW0/
         cguA==
X-Gm-Message-State: AOAM530kM+iyV2AKcUtUQInnlL64H+r6zAiT8uqVdrpj9lhJ6xiay0Us
        2Xsx5YTNC03qbzk2DRbMgd3mULMGRHy9O7I1io9Yftmv
X-Google-Smtp-Source: ABdhPJzgt8rCvkWTEzaXP+d2sqxrHRVKqT5t9tgGwcG7pcclCL+s5toHaAl1GGsaiosXbNs0YohXbDJ+VR22J1ugMCA=
X-Received: by 2002:ac2:44b6:: with SMTP id c22mr734906lfm.601.1632935506505;
 Wed, 29 Sep 2021 10:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org> <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org> <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
 <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org> <YVNR6w7dq0HMIcFA@jeremy-acer>
 <76fcdc45-0a94-d9e6-14c8-1c638d0bd00f@talpey.com> <YVSJWPa8dalyzsl0@jeremy-acer>
 <ce52c130-74de-feaa-6995-6a0d947816a6@samba.org> <27908e3e-140e-8c7a-e792-414fec5b5190@talpey.com>
In-Reply-To: <27908e3e-140e-8c7a-e792-414fec5b5190@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 29 Sep 2021 12:11:35 -0500
Message-ID: <CAH2r5mvPy0UBJ2z=gSbyOSK9cMYMdB-Unr4Jk14Fve4W1XFTJQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
To:     Tom Talpey <tom@talpey.com>
Cc:     Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 29, 2021 at 11:45 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 9/29/2021 12:38 PM, Ralph Boehme wrote:
> > Am 29.09.21 um 17:42 schrieb Jeremy Allison:
> >> On Wed, Sep 29, 2021 at 11:28:09AM -0400, Tom Talpey wrote:
> >>>
> >>> I completely agree that email is inefficient, but git is a terrible
> >>> way to have a discussion.

Agreed

> >> Maybe send the initial patch to the list with a link
> >> to the github MR so people interested in reviewing/discussing
> >> can follow along there ?
> >
> > well, if I could have it the way I wanted, then this would be it. But I
> > understand that adopting new workflows is not something I can impose --
> > at least not without paying for an insane amount of Lakritz-Gitarren
> > that I tend to use to bribe metze into doing something I want him to do. :)
>
> I'm in for github if you send me some too!

gitnub is fine for many things, and we can automated "kernel
development process"
things presumably with github easier than alternatives:
- running "scripts/checkpatch"
- make with C=1 and "_CHECK_ENDIAN" support turned on
- kick off smbtorture tests (as Namjae already does in his branches in github)

BUT ... we have to ensure a couple things.
- we don't annoy Linus (and linux-next and stable maintainers) by doing things
like web merges in github (he complained about the meaningless/distracting
github web ui empty merge messages)
- we don't miss reviewers in Linux who also want to see them on
mailing lists (presumably
some of fsdevel - ie more general patches that other fs developers outside
smb world need to comment on)


> >
> > Once such a collaboratively worked on patchset stabilizes, it can of
> > course again go to the mailing list.

Makes sense


-- 
Thanks,

Steve
