Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CEFC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Feb 2022 07:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiBNHxJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Feb 2022 02:53:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiBNHxJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Feb 2022 02:53:09 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FF25B3CB
        for <linux-cifs@vger.kernel.org>; Sun, 13 Feb 2022 23:53:02 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id p19so43565488ybc.6
        for <linux-cifs@vger.kernel.org>; Sun, 13 Feb 2022 23:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ia2tt8+ptc8yIY0SEFcLL1aiG3ffN+q2941Ezj1CSec=;
        b=qGGbjcBzs7ly+dgBM3vgot0LAOWv6vm+j9ANiELp0Gtpa8MuabFklJRGOZ91LyxXnl
         UhN+jvRO2pVJWK4LSoMNRXysghUaKREF89VIhoQBc2tL9rcWBdWRQ6lD356OJPeXoIi9
         B4BBZ7gltFmLaPB1QkeE6P+ysyghEixR7mOyef+pq7r5ncbq9XN0gh4bVefmeyokqcQb
         GUfk6oGqx0ZxfsG7iT/IDvWO6+UXSSTGal+NMPGPxbhQi/TghGvZOd5w3wzHacXYGrkp
         95xL7R1eo5Erba+mv9owVOH7M8wnMJ0+lnDjP0B+IlDPw56jSGBdkD0+Hg7a+KoOdliL
         xzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ia2tt8+ptc8yIY0SEFcLL1aiG3ffN+q2941Ezj1CSec=;
        b=1bYqcK4vzMsXSZvIir2TidR8yVxpWV1OgxsAMcQC+EjZjtDKGwzhYa2HKfRDGXMH8d
         gqJ+Wdh4qh6EbXBsWstjvxxEoHsiyDSrn1HS2/qBRB6/I/Lm7py+CIKRIPCnjkGWZnFf
         qtl5jSoiRHZNOlbPUm7ksH17ENWJkLbKUtmFxYwf2MnLcJURTy57MfrSzb4gSy795lpC
         /PS9lApBlK5CdsPKUiFc8iPsADM+b//LWgHHxLOH6bA4Umz6nPBdTT/esc5TUajOiTh2
         XXkMYVgJ9iqdKbMAPFyVIVdW/+H99smMAnNLM79DG+CFqNxHcQpqB4unL4JmKBU2Pa/4
         Xy6A==
X-Gm-Message-State: AOAM531/i1+8bKTXlBSra79weI1XzvzdCMm855G7uTnnoWK44sIWcMA6
        Nndq7WQmtFVnwUIqRgrIiLn6pfoaO3Y91cJHuBQ=
X-Google-Smtp-Source: ABdhPJwDl9GD98iFFoe1bQ4tEtF5wNuNmLxDWSvoxqPhA6rH25Y5iQQbnziYgi6fIcSsb+/8zh6sJS5BpQuT6YDOCzs=
X-Received: by 2002:a25:e308:: with SMTP id z8mr11022025ybd.53.1644825181342;
 Sun, 13 Feb 2022 23:53:01 -0800 (PST)
MIME-Version: 1.0
References: <20220213224052.3387192-1-lsahlber@redhat.com>
In-Reply-To: <20220213224052.3387192-1-lsahlber@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 14 Feb 2022 17:52:50 +1000
Message-ID: <CAN05THRUfzu5G2Zn36Wopw8U-Ey4pZPpxdYsYkqBZaDnDt2SQA@mail.gmail.com>
Subject: Re:
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

I  have added a test to the buildbot to verify the fix.
I.e. two ACEs when file are created, one for mode and one for AuthenticatedUsers
and that after chmod we still have two ACEs but the one for mode has
been updated.

The test is cifs/107
and it can also show how we can now modify the mountoptions we need on
a test by test
basis by using -o remount, ...     wooohooo new mount api :-)



On Mon, Feb 14, 2022 at 9:47 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Steve, List,
>
> Here is a small patch htat fixes an issue with modefromsid where
> it would strip off and remove all the ACEs that grants us access to the file.
> It fixes this by restoring the "allow AuthenticatedUsers access" ACE that is stripped in
>
> set_chmod_dacl():
>                 /* If it's any one of the ACE we're replacing, skip! */
>                 if (((compare_sids(&pntace->sid, &sid_unix_NFS_mode) == 0) ||
>                                 (compare_sids(&pntace->sid, pownersid) == 0) ||
>                                 (compare_sids(&pntace->sid, pgrpsid) == 0) ||
>                                 (compare_sids(&pntace->sid, &sid_everyone) == 0) ||
>                                 (compare_sids(&pntace->sid, &sid_authusers) == 0))) {
>                         goto next_ace;
>                 }
>
> This part is confusing since form many of these cases we are NOT replacing
> all these ACEs but only some of them but the code unconditionally removes
> all of them, contrary to what the comment suggests.
>
> I think some of my confusion here is that afaik we don't have good documentation
> of how modefromsid, and idsfromsid, are supposed to work, what the
> restrictions are or the expected semantics.
> We need to document both modefromsid and idsfromsid and what the expected
> semantics are for when either of them or both of them are enabled.
>
>
>
>
