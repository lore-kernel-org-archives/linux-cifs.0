Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA62C433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 18:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EAB361628
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 18:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhEKSIJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 14:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbhEKSII (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 May 2021 14:08:08 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62668C061574
        for <linux-cifs@vger.kernel.org>; Tue, 11 May 2021 11:07:01 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id h4so30006151lfv.0
        for <linux-cifs@vger.kernel.org>; Tue, 11 May 2021 11:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GMLDbwSnXMiv2VUpYwVXijZdILxOAmqSfiqlZNdtB4A=;
        b=s9Io4Acndj4CTXrpxvT/vUizj3T3B8X3wHJ8lQENjhTqv59mcPw2ZAkCLAP+FEYsMy
         849OZf++jXrh6f7IKjYU34CxmPbi+lJ71Se6fG4TfoOU/FlZPtrR620oRQ3byGbKvvqf
         pK+CwA72BgIdgdyfHPii1KVpGi8SSnSCbU7l2LeBuxt3rLUG1XTK/5KUpDf26g0diraA
         +3tUlrxZcUCREemQAeq40pieUGgF0w1AQ+IucmZZG9rdE+aiBPlfGt97FDzStZK3e3Ba
         X2zZrZZFZ/2YzrNEO5A13qM8fBn0M2jt5mmEcMdmxsWwLHUle6RQGcTO5Sr3jW/liqRU
         FdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GMLDbwSnXMiv2VUpYwVXijZdILxOAmqSfiqlZNdtB4A=;
        b=Uwv0MW9QM9tTMD80NBpak4pRcJvSGydUH7vhdl8WW8QcmtB/PKALohzy4GLXSzoMvM
         UmQKXqWdF+UBq5wOTTArMFFVhi6sIYWYND5+LnntMFSptskS1EFq4PLWGDMbj0hGW5pq
         h5QKVhqOIZPAnxGfVrye1PAeko1yn5sSr2KknPuEp7uDsuNJuGcb2XAavqQXPNU7vBum
         jF9AJjxkELZT1ZguJEeTnwl7t/NRl+rg90nf7Bu1fJVL7Ulb+BL+e8VZTuZx59Gig7Gv
         cXfXTT3MBa9bEqjEKaUeQmDJu15CHc3D/IcHEeLDbj7pRPL4AuL2d5NTF0PrLoBU+/UV
         GH9w==
X-Gm-Message-State: AOAM532tTqzoxunrVr/uTOGNXCWRQlWvTYDozhZcaG1etFr0aD3WUbh7
        3rUM6SEVHeevQ3vSyXQBWnztuwpD7DmsUx5nyrU=
X-Google-Smtp-Source: ABdhPJy82Nv8+JUIPMJRHby8hcNdFXOdndvTBO5yL1TpjsjxXxEMYcfhrzFFgFQbcWRSTqXyYBfazFUmhazpAv5IlOY=
X-Received: by 2002:a19:614e:: with SMTP id m14mr21200400lfk.395.1620756419767;
 Tue, 11 May 2021 11:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210511163952.11670-1-pc@cjr.nz> <8735uttb7s.fsf@suse.com>
In-Reply-To: <8735uttb7s.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 11 May 2021 13:06:48 -0500
Message-ID: <CAH2r5muebXV1_DMPG3d39xsP8JoW4U=2655vYCUqFbDihsbnLg@mail.gmail.com>
Subject: Re: [PATCH cifs-utils] mount.cifs: handle multiple ip addresses per hostname
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, May 11, 2021 at 12:46 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
>
>
> I would put in the commit msg that this requires recent kernel.
>
> We should probably merge kernel code first so we can reference it here
> in the commit msg, and say in the man page when did the kernel change.
>
> There can be cases where cifs-utils is more recent than kernel and
> mount.cifs will pass all the ip instead of trying them before passing
> the good one to the kernel but since it's an old kernel it won't try
> them all. We could add an option to enable new behavior or check the
> kernel version from within mount.cifs.. thoughts?

We could at least warn on older cifs.ko (which would be unlikely to
work unless someone backported features but didn't backport the
updated version #) by checking for the version number (2.32? 2.33?)

"cat /proc/fs/cifs/DebugData | grep Version" shows the version number
easily info (there are other ways to retrieve it as well)

--=20
Thanks,

Steve
