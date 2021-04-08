Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3C4C433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 10:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A17E3610C7
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 10:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhDHKvT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 06:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHKvS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 06:51:18 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94718C061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 03:51:07 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g38so2120794ybi.12
        for <linux-cifs@vger.kernel.org>; Thu, 08 Apr 2021 03:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MWLs2d5Sb5yBAHwdW/1TMC/gtmESOyJW9s3EtVBmGlk=;
        b=n4ekP395jJhrTDNRrIfvCB3fQRLyu5ZAeYLnS34ZlKhDvHeqFWgjq4w7OhJyqe+P+2
         nACoBpLs0E2Zu9eHJf8ehybYtXCrTzj+kvAwOoiFPDy8ZBIrzoDvWz79glNanWYI9KFx
         ca+ZhI6V0MZqTX1mM7wrxqk0FaQZYH3t+1iMrcOfVCV3OjwVWfFjhkYco1sq05PysYKO
         8F+BkHhpA3MgGX+Drj6CfO4wJCCIiY4/Wu1Po1uY7F8fwToyymd68xmYGKI8HKMpA+Z6
         wQwSnQHAawI/mqOq4bLgN5Pz99OZg4w2t+xToSp3Jl+WoAL6IP9hOc0BFWBiJVgrJxb5
         yvGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MWLs2d5Sb5yBAHwdW/1TMC/gtmESOyJW9s3EtVBmGlk=;
        b=Ju1YfCbCyTIDgdwKwu7582YnX47J+LCMdVGVizLRovbvPDsvmDUi8FgjIzyfq92HKU
         UAU0pGhhVIBqOgVzM0CTA3KDpzfQzBU7X9e/bgFZsCXEzNJyPw1fLvhwQp/1vi574gjl
         lo3hVxLpoIiD0lCpGex9Zx3h2PdNCvrxx2j7bsGEgLeb8QtZxGEEltZwFbNryYx4L5HX
         MKREeNpJU8nKeFGwg9sb4U+3PflpvcjIB6TZyfzzzatA2DBBGV1SflHQ2k+XYLAmiDln
         3BGo/omo7iOglLrvme1bpDBb0v+H6h3AistQAKMPznAIlCuP8YJcZsBxwroU5+Fo4fKX
         71dg==
X-Gm-Message-State: AOAM532eec/COa1KCMbInJ/ejLMvaZiY/6bf4VzxTqt4LFmpz2gmaBui
        EwK4uqMmYO6O4r21T4w34Ja9DVua2CeFiSYxyPk=
X-Google-Smtp-Source: ABdhPJxt+522h3FFgGEhsROVkJeUh5Ln5myn2qgv+T4GPwsmR/BSqdXsWMHd99u5dnAyNJ81BXhoTXeEPAw/fWP8Vy4=
X-Received: by 2002:a25:31d5:: with SMTP id x204mr10779439ybx.3.1617879066825;
 Thu, 08 Apr 2021 03:51:06 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
 <87im50vi9v.fsf@cjr.nz> <CANT5p=pHPPwf8H1ZbBT+yr4CP17+BB2evDBxPVjYrvr+kdF1FQ@mail.gmail.com>
 <CAKywueSCF-ZgmJZif=kkspk_b8Xp3ARUGHD64nnc5ZbVk3EcxA@mail.gmail.com>
 <CAH2r5mv1=tpjPOZhq97t+X99dfSDtzWepp5bpqPqjf9Z1t6+sg@mail.gmail.com>
 <CANT5p=rq+jXGyZG-23dpOVOomObXmXEdr9FsO-=-vX9tH+kkCA@mail.gmail.com> <878s5t4185.fsf@suse.com>
In-Reply-To: <878s5t4185.fsf@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 8 Apr 2021 16:20:55 +0530
Message-ID: <CANT5p=rcXNH45roAVy8Zht889dKfexmEWFwKTvyssHA-cNA6rA@mail.gmail.com>
Subject: Re: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aur=C3=A9lien,

That logic is already there.
If reconn_set_ipaddr_from_hostname() returns failure, we log it and
continue with the reconnect to the old server->dstaddr anyway,

Regards,
Shyam

On Thu, Apr 8, 2021 at 2:11 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > The intel bot identified an issue with the earlier version of the fix,
> > when not compiled with DFS.
> > Here's an updated version with that fix too.
>
> Ah I guess that's why resolving wasn't done on reconnect outside of DFS:
> it requires the DNS resolver which requires upcalling i.e. having
> keys-utils, request-conf.conf and dns_resolver key installed and
> properly configured on the system to be able to reconnect.
>
> Maybe we should fallback to retrying the same ip if resolving isn't
> available.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Regards,
Shyam
