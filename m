Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D21C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 21:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71122610A3
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 21:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhHRVFb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 17:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbhHRVF1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Aug 2021 17:05:27 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A6BC061764
        for <linux-cifs@vger.kernel.org>; Wed, 18 Aug 2021 14:04:52 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id i6so5276203edu.1
        for <linux-cifs@vger.kernel.org>; Wed, 18 Aug 2021 14:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oDqJlYXiw+6Amb6kqnO52rNAF97NREuOwotCqXpZ5rU=;
        b=U+asAXW1py8eCONLbjXAA+ZoDWxev0ownMq4tlhZveou1o9bMHS8bj+nPhwAJZOe6z
         lvXkpe2fuUhaeYCFaFy4mlaPxFB71fJ6ax762Y+opENo+/3LoA5IJIOncJbgvmuw/6Ei
         dab5srumWf8BKbZy+L/K/8hVzU/pXK30zC872wGzS43olYqNVdVuwZs3hVx1JxXylg9j
         uHhQiHZTB+kh9vpO3ul4ZYnPAivfx6XAYj7R3wTLdB18lbFYfbRFETzxQbA0OOhZYtjF
         VFLPZcOUtskq4x2oQDC8FJ0Dye8vowtNOY642+LVHZPfcb5ashRzKX2gY3VBfnGQr+WO
         +AfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oDqJlYXiw+6Amb6kqnO52rNAF97NREuOwotCqXpZ5rU=;
        b=sRuGzjYRFxmdW6NR5GIlHlodpEQB3YHeA6GJf26xOh4lCywPC2kk+7sirYWET7tYon
         T8sObJ08PtVIIGXE7sKg5Nj2gZ/naXBJfgzHwoRXz4vMfKLudZvQO+yM+0+lOXBofGIO
         8IZENmExM4a+Cq8gCM1iAxEW7vzLPbMdLux38ZkM+dn1by46w0Bszwe1nYj9xYyTh0eG
         OgCBQIgFp4FxqI8m5BebhpkduCpV7K+H3XQINyq4rkJcHolSOOo3vLFYoBJexiRV0XAa
         XFycZSiGX9F27pSkYS+z84UdINsxkwCP0olCu/RnPgS4/xYVwRyNlwLEldWEQtMRGgXu
         GeBw==
X-Gm-Message-State: AOAM533vCmwMJvVNpQqSJiokUNEFD3CjKvz5xD5XsowHn/yU0PRkb5rC
        TyrO1wN++2Qh8dIU1L8lT2gohzx8KaqGSCZ8JbY=
X-Google-Smtp-Source: ABdhPJz5DEXsnPUuzhxMLBNr+GhBdrl8GeB47ASYFk1SodeyLWJQDtai3xjUM9xs4eVVlMddt/BaLCYYtoFX5ZmOiFI=
X-Received: by 2002:a50:cc08:: with SMTP id m8mr11913406edi.60.1629320690795;
 Wed, 18 Aug 2021 14:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210818041021.1210797-1-lsahlber@redhat.com> <815daf08-7569-59ce-0318-dfe2b16e1d96@talpey.com>
 <CAN05THR_Y+uoER=iNiwoiZ0yPcJ2T-LvRqOew59G53SafUMg3g@mail.gmail.com>
 <CAH2r5mvj5w1NxkyH4XE6S6J0O7VFJ-XWB_Og_JsmA0M8i=AW2A@mail.gmail.com> <da151f08-bd19-9bbe-8e4b-9d7a698a9c4d@talpey.com>
In-Reply-To: <da151f08-bd19-9bbe-8e4b-9d7a698a9c4d@talpey.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 19 Aug 2021 07:04:39 +1000
Message-ID: <CAN05THS56vy_8HH7yNv1fMCBoTxBfhM5V0MZo1G3UtHZOm+uNw@mail.gmail.com>
Subject: Re: Disable key exchange if ARC4 is not available
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Aug 19, 2021 at 4:33 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 8/18/2021 12:51 PM, Steve French wrote:
> > On Wed, Aug 18, 2021 at 11:29 AM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> >>
> >> On Wed, Aug 18, 2021 at 11:18 PM Tom Talpey <tom@talpey.com> wrote:
> >>>
> >>> On 8/18/2021 12:10 AM, Ronnie Sahlberg wrote:
> >>>> Steve,
> >>>>
> >>>> We depend on ARC4 for generating the encrypted session key in key exchange.
> >>>> This patch disables the key exchange/encrypted session key for ntlmssp
> >>>> IF the kernel does not have any ARC4 support.
> >>>>
> >>>> This allows to build the cifs module even if ARC4 has been removed
> >>>> though with a weaker type of NTLMSSP support.
> >>>
> >>> It's a good goal but it seems wrong to downgrade the security
> >>> so silently. Wouldn't it be a better approach to select ARC4,
> >>> and thereby force the build to succeed or fail? Alternatively,
> >>> change the #ifndef ARC4 to a positive option named (for example)
> >>> DOWNGRADED_NTLMSSP or something equally foreboding?
> >>
> >> Good point.
> >> Maybe we should drop this patch and instead copy ARC4 into fs/cifs
> >> so we have a private version of the code in cifs.ko.
> >> And do the same for md4 and md5.
>
> Copying such code makes me uneasy. It's going to confuse everyone
> who tries to turn off one and misses the other. To say nothing of
> the risk of testing and addressing bugs.
>
> BTW, are we sure that servers even work if the client selects
> something other than ARC4, or whatever?
>

Removing ARC4 does work, at least against windows servers.
But it comes at the cost that we can not do key exchange, which
weakens the authentication.

Thinking about it, removing ARC4 because people want to make the
kernel "more secure"
would come at a cost of making cifs "less secure" :-(

The same situation, removal, exist for MD4 which is a core part of
NTLMSSP and can not be
disabled without full removal of NTLMSSP in its entirety.
For that case it was suggested that we "fork the md4 code and move it
into fs/cifs".


I don't think it is viable to remove NTLMSSP from the cifs module as
this would in reality
break cifs for most users so the only viable option might be that we
have to create a private fork of this.
And if we are already going to fork md4 and copy it into fs/cifs we
can just as well do the same for ARC4.

There are other modules depending on md4 too that can not disable it
without breaking all the users that need it
so I guess they will have to do the same.

I imagine that the kernel will then end up with no single common md4
hash in its cryptographic library
but several identical private copies of the md4 code in different modules.
lol


-- ronnie

> T
>
> > Yes ... and allow a build option where ARC4/MD4 are removed from the
> > build and NTLMSSP disabled,
> > forcing kerberos in the short term, and then we need to get working
> > ASAP on adding some choices in the future,
> > perhaps something similar to
> >
> > https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj852232(v=ws.11)
> >
> > where Windows allows plugging in additional auth mechanisms to SPNEGO
> > (and pick at least one new mechanism beyond
> > KRB5 to support in the kernel client ...)
> >
