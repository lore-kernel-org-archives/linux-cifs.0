Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A55C3C4361A
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 23:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55C90223E8
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 23:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgLCXYD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Dec 2020 18:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728521AbgLCXYD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Dec 2020 18:24:03 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7679DC061A4F
        for <linux-cifs@vger.kernel.org>; Thu,  3 Dec 2020 15:23:23 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id n14so3889659iom.10
        for <linux-cifs@vger.kernel.org>; Thu, 03 Dec 2020 15:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LUUXkayI6EGRDbj6xfyVs//radJ2hw6tmLpgnWsWy8Q=;
        b=K7jlfZa2xOouyZt24JtnLjNQaDnQ4JUBBFA7hRDiILseUmVhPjC87WFhEcRUaVV6x4
         kouHHNkkTQqB7T7RgcVTGyXFvGlYrE7Z6bJTa+JmSrFrEuILWZpADjK9uz78/0CtqivD
         +HPanp0QOCAuxa+86QrCzieLHhnxp8bvg0+Umv/dv1Hm0x77OdnNCZrCIm0lG645q13j
         zh2c2sgy2GcD2sy6kNrZ6qsK8/9oX0W2+F5qzUukrAocvkSEDTmqZovxD9FejApYeyP7
         Mjslq5X9Qs8E2EamqsN6+TLPBunC3cQfJq6vtew9tjswHpySWcnKJTZN0lHMteHIqtDP
         7cyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LUUXkayI6EGRDbj6xfyVs//radJ2hw6tmLpgnWsWy8Q=;
        b=NJsxGhLtDLcwxZ9hTQeNYer+HwVxaEhalABgPw2xsA7BVuwCVApazPqheNKNmTeatd
         ZmvmT1jIlml3M47gTdF+Im3Uj1V0X4ejmVlsZRiRoEowhTYpej8AO9G81uroRsf0kWIi
         z9tOsx2mqtiz6zooSQEF545mUKSpzJxXFiQKJZEzSO6YC7WRwANw1oKPxKiwMRWKa8lx
         3R7p8twVHmE7jpNUuS7xCCJv914EcYKjRDu73ubHNGnLCcNxLoV8hsw76gwnQ+c3PyE7
         aLX1dShS6KvhtxdSdGuhO5xNYogyAFqW/yFo3wzvbkS7WSI1uAhH026BCwB/h1OMelhM
         gl0Q==
X-Gm-Message-State: AOAM532hur+UOeklXbMiutdtPsDhCHRuZqQbJtkt9G1hDa1F+CkLZ8ur
        v4RQ5dEELmoyssCQ7BO+eoyswzs/1HvUGtb7OHU=
X-Google-Smtp-Source: ABdhPJz7+TfU90nTr708R00eT+ORNUqT5ZdwO5NB9GW7/JiiXPgum/HHTL/cm9FUvJ6QNBnMUiXX8MZjR963gZRDuyI=
X-Received: by 2002:a02:c90f:: with SMTP id t15mr2086697jao.20.1607037802920;
 Thu, 03 Dec 2020 15:23:22 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtkt6-ezyTC6zoi+DBjYQ3qFwW3UneF0_4qETEt51Tm9w@mail.gmail.com>
 <CAH2r5mt+=ELCwSASFsPPjET=qf80_1tOTMPN-gG9cF=BQd-VBg@mail.gmail.com>
 <CAH2r5mv9_gvVtmBNSBDdnqkMAZMo9+fQExdgYEb+jEAMY4ad3A@mail.gmail.com>
 <CAN05THQuT8wf=-z1z5ERmEdfS4Nf72gHJiFUF_wbopR7FX-VQQ@mail.gmail.com> <CAH2r5mvC0cLMyfWcvt-v=V4=u-EptB+_vrjemWLdawXQ=bH_gg@mail.gmail.com>
In-Reply-To: <CAH2r5mvC0cLMyfWcvt-v=V4=u-EptB+_vrjemWLdawXQ=bH_gg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 4 Dec 2020 09:23:11 +1000
Message-ID: <CAN05THRmM5n=Uv=t_fqwqwOLkSHW9GtKBqU5NLBOnEsd2PWvvQ@mail.gmail.com>
Subject: Re: [SMB3][PATCH] ifs: refactor create_sd_buf() and and avoid
 corrupting the buffer
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good!

On Fri, Dec 4, 2020 at 9:12 AM Steve French <smfrench@gmail.com> wrote:
>
> Updated with Ronnie's suggestion.
>
>
> On Thu, Dec 3, 2020 at 4:08 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> >
> > LGTM.
> >
> > Maybe move acl.AclRevision down to where the other fields are assigned
> > so they are all assigned in the same place?
> >
> > On Fri, Dec 4, 2020 at 2:46 AM Steve French <smfrench@gmail.com> wrote:
> > >
> > > updated the patch slightly by creating local variable for ace_count
> > > and acl_size to avoid excessive endian conversions
> > >
> > > On Mon, Nov 30, 2020 at 10:19 PM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > > Updated patch with fixes for various endian sparse warnings
> > > >
> > > >
> > > > On Mon, Nov 30, 2020 at 12:02 AM Steve French <smfrench@gmail.com> wrote:
> > > > >
> > > > > When mounting with "idsfromsid" mount option, Azure
> > > > > corrupted the owner SIDs due to excessive padding
> > > > > caused by placing the owner fields at the end of the
> > > > > security descriptor on create.  Placing owners at the
> > > > > front of the security descriptor (rather than the end)
> > > > > is also safer, as the number of ACEs (that follow it)
> > > > > are variable.
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
