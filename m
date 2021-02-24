Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2999C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 17:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0A7E64F14
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 17:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhBXRcy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 12:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhBXRcl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Feb 2021 12:32:41 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C198FC061574
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 09:32:00 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id f1so4288922lfu.3
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 09:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NGuQjNxEBuykGgOLePyB8OuEdM9bwMpNpG8nmCR16V8=;
        b=p9gBpDdMWw9XFpRfSqeOuwUTrdHYeRJbny2Xj+aOcSq7Ndj/ex3Ue2fnXGUve2vQiz
         g6o4Ql+Jy6MOhS2XisN4GMPPYydqJWoW9VUaNg8x5IpvwKxWcYR9C7K/Bfc7sssIfo/7
         5nwW6MFFtshN1yLQVyfIDevvYTETofZUAh77RB7yaED+wziY3qsgsJcIXOHdAKpAN8F/
         KGQHEwL2PF8wSGaf++8d+8ZbDZT6PjBJBiFsni+1mCxwdsU1Kf/K7i4qSFHQSQ5vk1kd
         OpTMcDPU7GiMf3oeqnXvLpdjtIOsw4E7kCIjwhMwjYGPgjZ8b6wH0I5L9TtfeNlLPqf9
         SyxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NGuQjNxEBuykGgOLePyB8OuEdM9bwMpNpG8nmCR16V8=;
        b=hihL19eF9TjizmdJTdxeiefrNu+SJg20psWwsTg68j6qPC9gh/dK17i8B2FKAA+ZdZ
         SIdaTB1DLV9DXhrjIF5zI10yNUxA7WQ+bkkr/X/EbB1RhkJ02pSG3/aD5IA6X2Ci3lfD
         PQjFTUesU98FmtBRlS365n8AQHAGF+iXUE4gJMxnilGB37bDLuq6AKpOrqQR1mijVdu7
         5L+OqzF03LZl7fQjGB/FRUK1YT6iM7dLI1in0MKZjMTM7y7QGYeSjPpT+tFuj8BtcDQ9
         vWqrLVT8BaKmq0xs0YhGbxlCCyB4DCHKFBi4SasUjCRsmGpjsQBqiZKrGmXL1FUH6m+C
         hGiw==
X-Gm-Message-State: AOAM531fvXl1Tb28tecSXR8zxPyWeoN181ipLJ0yNyrCshVflyvWohmL
        vxC6smIhmQN3tH9IpNSMxDBxazL0N2Qz+cpmZaVoFvqQVYw=
X-Google-Smtp-Source: ABdhPJzV8fcA8fWc2zCpLdQ3FzBDJ6l7q44OHgXvhLMbm8Z3a3Dfg4wjnKOVSAe0dQISxHS5NFd9phOMy8svEC9LWQ4=
X-Received: by 2002:a05:6512:1284:: with SMTP id u4mr20577473lfs.175.1614187919177;
 Wed, 24 Feb 2021 09:31:59 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msdUQ=CVM6s7ENeH7SP-teYAOioOGq7zY5sDXZFrFYiCA@mail.gmail.com>
 <CAH2r5mv6Oo5UUMOyFmKO_6xmdXZvQa_TtmFjgdN_ZoBcgSbJkA@mail.gmail.com> <10881e42-9632-30b0-344d-66ed8e9cb340@talpey.com>
In-Reply-To: <10881e42-9632-30b0-344d-66ed8e9cb340@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Feb 2021 11:31:47 -0600
Message-ID: <CAH2r5mvGG1-DOZq1Eby3jfX86YLgpCihmYgV=EPJoR16PhEN7Q@mail.gmail.com>
Subject: Re: [PATCH] convert revalidate of directories to using directory
 metadata cache timeout
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 24, 2021 at 10:11 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 2/23/2021 8:03 PM, Steve French wrote:
> > Updated version incorporates Ronnie's suggestion of leaving the
> > default (for directory caching) the same as it is today, 1 second, to
> > avoid
> > unnecessary risk.   Most users can safely improve performance by
> > mounting with acdirmax to a higher value (e.g. 60 seconds as NFS
> > defaults to).
> >
> > nfs and cifs on Linux currently have a mount parameter "actimeo" to control
> > metadata (attribute) caching but cifs does not have additional mount
> > parameters to allow distinguishing between caching directory metadata
> > (e.g. needed to revalidate paths) and that for files.
>
> The behaviors seem to be slightly different with this change.
> With NFS, the actimeo option overrides the four min/max options,
> and by default the directory ac timers range between 30 and 60.
>
> The CIFS code I see below seems to completely separate actimeo
> and acdirmax, and if not set, uses the historic 1 second value.
> That's fine, but it's completely different from NFS. Shouldn't we
> use a different mount option, to avoid confusing the admin?

Ugh ... You are probably right.  I was trying to avoid two problems:
1) (a minor one) adding a second mount option rather than just one (to
solve the same problem).  But reducing confusion is worth an extra
mount option

2) how to avoid the user specifying *both* actimeo and acregmax -
which one 'wins' (presumably the last one in the mount line)
We could check for this and warn the user in mount.cifs so maybe not
important to worry about in the kernel though.

I will add the acregmax mount option and change actimeo to mean
    if (actimeo is set)
            acregmax = acdirmax = actimeo


-- 
Thanks,

Steve
