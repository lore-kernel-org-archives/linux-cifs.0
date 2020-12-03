Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57755C4361A
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 22:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA9C62220F
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 22:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgLCWJI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Dec 2020 17:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgLCWJI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Dec 2020 17:09:08 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4714BC061A51
        for <linux-cifs@vger.kernel.org>; Thu,  3 Dec 2020 14:08:22 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id z14so3395460ilm.10
        for <linux-cifs@vger.kernel.org>; Thu, 03 Dec 2020 14:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2h2mQHXLwpxsyBlfs24p1gLIXHr/MzxnR4HCzKk7DFU=;
        b=fMTNLHgZBY9eVZc4Oaq+BQIdra5x3iPtc6Isghi5iiqZBNFhqqRZOnYXT1cCKPVLWZ
         FmEgYLi1B1L1jMROjlEt7brN5L4m7qcKyAvx5321YT6cekYslbJNyC2F5OkmyhLzxgpj
         1661FAB6X+CPDLGPTLneTR8sOIcpPXQ6qiDsKK/miblnjxP4JqwdMvZlkCY5xK7+RRDT
         QPpkTFKzkHm22DJexlW4xJT4oHih4G4lAkHkdfp09V0XDH5oL8g4m6RVzE4Qvx6mcoyF
         w1BfWtB2EeCCRk0Oz/IT9embJMnpIt69i1D2AcBcQtVWKl5RW6qMVY050McyVpCzVIxl
         RtAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2h2mQHXLwpxsyBlfs24p1gLIXHr/MzxnR4HCzKk7DFU=;
        b=adQC+VkWzr7b7SZLbKaOfZsKO8QNJshnKBgKxqwewM04yp7NcdJX+F38RtdALrYy4n
         ryl67bnO0DKVbIRpkSnhibmVcmqpMg2nHE0u/Lczjv5oEIDzMdFQ+HiZNtHtnyHqfWXY
         BA4RNv+YHBmTQVM4kE8W0UOlLDZpUOboteF70f1RuoSWCM/IeNICQCqjZgLojn7bJVra
         okAr47c8kZlFuymjaPQyAebyOxY7es82E+1eoibpw1btpgAicn4HrrWsug3NXbn7PLVZ
         jyABwekaJBV1XMQBRSuQ297KZru5sXa3eza5jEfdz6yv1UQDhYVyxJ+Fo+MeQa3wOq0x
         nBiQ==
X-Gm-Message-State: AOAM5332noOH1at34YFoDSfjQDHruNXe3vFTwNnENkU5zLcZEkI+JyXo
        dcnjlff1xktOMaEDEteE44g1+LlIOpnxKbXVOeE=
X-Google-Smtp-Source: ABdhPJyuH+2zrQL2o9sZZiiOSp8+lFmTh9Ie/H/eMj62Oon/OyUmhGWrTGYKqcuOV17T40nC1TEVYJfaA1dQSfQpc+Y=
X-Received: by 2002:a92:c5a7:: with SMTP id r7mr1718962ilt.219.1607033301671;
 Thu, 03 Dec 2020 14:08:21 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtkt6-ezyTC6zoi+DBjYQ3qFwW3UneF0_4qETEt51Tm9w@mail.gmail.com>
 <CAH2r5mt+=ELCwSASFsPPjET=qf80_1tOTMPN-gG9cF=BQd-VBg@mail.gmail.com> <CAH2r5mv9_gvVtmBNSBDdnqkMAZMo9+fQExdgYEb+jEAMY4ad3A@mail.gmail.com>
In-Reply-To: <CAH2r5mv9_gvVtmBNSBDdnqkMAZMo9+fQExdgYEb+jEAMY4ad3A@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 4 Dec 2020 08:08:10 +1000
Message-ID: <CAN05THQuT8wf=-z1z5ERmEdfS4Nf72gHJiFUF_wbopR7FX-VQQ@mail.gmail.com>
Subject: Re: [SMB3][PATCH] ifs: refactor create_sd_buf() and and avoid
 corrupting the buffer
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

LGTM.

Maybe move acl.AclRevision down to where the other fields are assigned
so they are all assigned in the same place?

On Fri, Dec 4, 2020 at 2:46 AM Steve French <smfrench@gmail.com> wrote:
>
> updated the patch slightly by creating local variable for ace_count
> and acl_size to avoid excessive endian conversions
>
> On Mon, Nov 30, 2020 at 10:19 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Updated patch with fixes for various endian sparse warnings
> >
> >
> > On Mon, Nov 30, 2020 at 12:02 AM Steve French <smfrench@gmail.com> wrote:
> > >
> > > When mounting with "idsfromsid" mount option, Azure
> > > corrupted the owner SIDs due to excessive padding
> > > caused by placing the owner fields at the end of the
> > > security descriptor on create.  Placing owners at the
> > > front of the security descriptor (rather than the end)
> > > is also safer, as the number of ACEs (that follow it)
> > > are variable.
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
