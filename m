Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C13EC432BE
	for <linux-cifs@archiver.kernel.org>; Sat, 31 Jul 2021 21:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29A4F60241
	for <linux-cifs@archiver.kernel.org>; Sat, 31 Jul 2021 21:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhGaV6D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 31 Jul 2021 17:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhGaV6C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 31 Jul 2021 17:58:02 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C988FC06175F
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jul 2021 14:57:54 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gs8so23875113ejc.13
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jul 2021 14:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Th7xEd3e0tjCoX7eyRIjudbxmCm+JeCG59+PywPMdfQ=;
        b=sYkUbk7Mq17fxzxat0PLHE/aENHIQptcLqqSwvbCQ2c1YfOgZ8919N709NlNkf19SM
         Dl5Hbmk8JfDraA6H2vnQ01q38FzC3tcbqGwssGDLs/IiviiL70QTobDnTzxUXK/MZMrs
         F6aL1mMr60aEdYf3gFkBusLoTA9Tk65KWZZuerCDITKWeoMfZqVFn790Xn77iMyR+Nb9
         em2JlSWOiLJn/yxhaJaDE6zaivyEr/panUMJnUIDEtbcpCIawApEMVfSh6X8wZIRRgan
         WENVStkPo05D9xu+T0PLekJ4t0kfmzr5lH4jK9kHDhPIjG5OXZ/kMxXRBi3IGNrZ26tf
         lyXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Th7xEd3e0tjCoX7eyRIjudbxmCm+JeCG59+PywPMdfQ=;
        b=l1FvuBcMLnV7SLZG+uNFuwoeC3YwYnR4aAb9NRZbYBzSdHo/aUVtqXy79tBtLD1CdW
         nNK+82RSnargNF5kJ3kNB/ioP+TBILlsPscRS2o1fseHu62TGjof+FnCVNcCOUCHh96P
         Hq5OauAy99VgiYGova3zVEeoOans3+Q0f4+XYwOhnb+hfuwP3B9oIjsrI/80CW3RYwM6
         xozCnxDIFF2gNjEirhSLTKyTXt3++P9Np0XCqGzJeDAceAB69M3MJOJ0cA7OK7QlcAEm
         gV62DnT/6fmaeZIWBN/TfySpCBVmORVFOtYnYYQ6gV69ymbsGcxq6i3lOS+MF1jTuxbj
         UgVw==
X-Gm-Message-State: AOAM532oeyRnyCCg9a0CgyWJmomJfjMMa29vU7ED3k4jhTnPGskbYkcy
        6eOqLybdGvjvdKIV+pGm9OyW84VaBSUtkzXRL4w=
X-Google-Smtp-Source: ABdhPJwC272A9Z1atdojJvR4hwUglHkvYbl5yP+9GDwmEaoeUnD6TWjQgbwRJNb3b6fcIcb8Z3EaI/zQUl9NyhYyVQo=
X-Received: by 2002:a17:907:9875:: with SMTP id ko21mr8953052ejc.83.1627768673397;
 Sat, 31 Jul 2021 14:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <CANXojcy9sAY6Sd62Xs2nnjPNHWuUWQwcSpAAyAoT+VPDWizhOQ@mail.gmail.com>
In-Reply-To: <CANXojcy9sAY6Sd62Xs2nnjPNHWuUWQwcSpAAyAoT+VPDWizhOQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sun, 1 Aug 2021 07:57:41 +1000
Message-ID: <CAN05THS_KtutZxOOap7xPU3d+XfEJJTe7XT9sZ1tVZFMcLAYEA@mail.gmail.com>
Subject: Re: Question about parsing acl to get linux attributes.
To:     Stef Bon <stefbon@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Aug 1, 2021 at 2:02 AM Stef Bon <stefbon@gmail.com> wrote:
>
> Hi,
>
> I'm working on a FUSE filesystem to browse and access SMB networks.
> I'm using libsmb2 for that. It's not online yet, but my software is here:
>
> https://github.com/stefbon/OSNS
>
> Now I found out that smb2/3 do not support posix like file attributes,
> but do (almost?) everything with acl's.
> Now I see the function parse_dacl in fs/cifs/cifsacl.c, which
> determines the permissions from the acl. I see also that when there
> are no acl's, the default is 0777. I made the same choice in my
> filesystem.
> I've got some questions:
>
> a. what does the sid_unix_NFS_mode stand for? Is it part of the "unix
> extensions module for Windows"?
>
> b. can you assume some order in the acl's, so you participate on that?
> I want to know there are optimizations possible.

The ACE entries in the ACL are processed in order, thus a user can
create very sophisticated
ACLs by ordering the entries carefully.

The ACEs are actually processed twice when access is evaluated.
First it handles all the DENY ACEs. So it goes through the ACL, only
looking a the DENY ACEs and ignoring all other ACEs.

Once it has processed the entire ACL this way, and IF the user was not
denied access,
then it will go through the entire ACL a second time, this time only
looking at the ALLOW ACE entries to see
if the user is granted access.


Example:
1, S-1-2-ALICE                  ALLOW   READ
2, S-1-2-BOB                     ALLOW  READ/WRITE
3, S-1-2-EVERYBODY      ALLOW   READ/WRITE
4, S-1-2-BOB                     DENY     WRITE

In this case, even though there are two ACEs that would grant BOB
WRITE access (the ACE for BOB and EVERYBODY), BOB is still denied
write access due to the presence of a DENY ACE for WRITE.

In this case the ACEs are evaluated in the following order
4, 1, 2, 3

>
> Thanks in advance,
>
> Stef Bon
