Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FF7C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 20:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CA4E61488
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 20:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbhA0Ukl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 15:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbhA0Ukh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jan 2021 15:40:37 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79871C061573
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 12:39:57 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id l12so3716409ljc.3
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 12:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=adamharvey.name; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=z3ULXjeAjQL3NFuw4ZbJGx/uXDr+2KZkM7RUUdCR3ZQ=;
        b=ARB3XZ+lXuHVdxjTE2X0zKXA2ZGlj9uVthhtY7lYIA5EBwUZ3xwfH/P9PSY0/TmSqN
         accqQ0khvTtRAGy4sx0y5QhN+Zt5LhPvE9izum1+aBWMNK8D/nVa3Y0N538I+I3P+ptM
         NERfknyt6obK891YxFa+73gomiNYSddFkBRUk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z3ULXjeAjQL3NFuw4ZbJGx/uXDr+2KZkM7RUUdCR3ZQ=;
        b=qjj4lXzueRaq6a3wK6d1yYRR/i2R7ZA3KTS9Czbo7kzLK8XbwQIVGFh54v2KNSyS3W
         NsJE5en2oySV6FtJAD1XusaJO+gL8UsjeHMuad6/cC3o+rO9utgTT5dVUKm8EsJroyRk
         iJdnhYVQefPt1mhXfB9vrcd6HNiz1pXQhgQSosDWSYSdHdWQCwoQAMQUvQ7VJWpKJ09I
         fE8AR+9VL0jVVpT8ImCShjko5HU/bm/LMYCkoZzo2LyrZX5I+ai0GjS7424W0z9fnZE1
         +aeXeAHeJr2Lzki0uaxT2ooU3SQigoHRqs71T0+/h052mK6+kkmJEthdpL6Mmlumwisd
         3IKw==
X-Gm-Message-State: AOAM531AcasGgPJifJi7MDw64tvbPYe5KkwAkgKxSf5CN0fFT4ik2VQ0
        V4bEHP26uOppKA7r0ibBt27ysC1RU+PHMngFmGu9EQ==
X-Google-Smtp-Source: ABdhPJxkuA+UK2gov9YPmc/Z7iXXTpOvwMHKyvBw37oMhU7LyN/WFeauCZ1xhx70TsLnH6nWNyCvg00VMA6BUUBTwmY=
X-Received: by 2002:a2e:9cc3:: with SMTP id g3mr6756763ljj.0.1611779995903;
 Wed, 27 Jan 2021 12:39:55 -0800 (PST)
MIME-Version: 1.0
References: <20210127071020.18052-1-adam@adamharvey.name> <87lfceabsg.fsf@suse.com>
In-Reply-To: <87lfceabsg.fsf@suse.com>
From:   Adam Harvey <adam@adamharvey.name>
Date:   Wed, 27 Jan 2021 12:39:44 -0800
Message-ID: <CADajX4DzoNehHZGqpd+3Bh0yM2U=B6AwL6bJ2EM6t6hkvr7L4Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: ignore the noauto option if it is provided
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 27 Jan 2021 at 02:56, Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Hi Adam,
>
> Adam Harvey <adam@adamharvey.name> writes:
> > In 24e0a1eff9e2, the noauto option was missed when migrating to the new
> > mount API. As a result, users with noauto in their fstab mount options
> > are now unable to mount cifs filesystems, as they'll receive an "Unknow=
n
> > parameter" error.
> >
> > This restores the old behaviour of ignoring noauto if it's given.
>
> I was looking at other fs code and it seems no one explicitely parses
> auto/noauto. Any idea why? This looks like it could be handled somewhere
> else.

Honestly, I have no idea. I'm just a regular user trying to get his
music share to mount on 5.11-rc5. :)

> Also I would have expected fsparam_flag_no("auto", Opt_ignore) to allow
> for both auto and noauto.

Good catch! I misread the fstab manpage last night and thought there
wasn't a matching "auto". I'll send an updated patch that supports
both.

Thanks,

Adam
