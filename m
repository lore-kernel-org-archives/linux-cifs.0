Return-Path: <SRS0=RdgD=7Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9809C433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 17:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96EF620836
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 17:13:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QuHfcNCF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFLRNk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Jun 2020 13:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgFLRNk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Jun 2020 13:13:40 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E16C08C5C2
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2020 10:13:38 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id s28so4880561edw.11
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2020 10:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AZ74Gj7UvstdRIJwIZObZ8wpsCSw8LTudnzT16n1c7c=;
        b=QuHfcNCFYE4nSgooMrmH5oKQs70OwV6Te21vN1Vp5ecxvJFxd3ugnBg843okBN4tsO
         gFKZqIP4MvOT4+hgVAS/ZVBTJsng5s2t5hDJY+imMuzMQfHm4CRvoMccjQJUEAHAisTh
         qH4++Xp2ujWMi+lJ1tILEnTemSijF7Z1nnifewz/7+olsu37Wp+1DaoX2yTG9pebh4Ul
         G7/qLW1bUm5bFl5Rr82zAwHIWTFsfXpryfrjg/+5GtbTLXaxmtTYSmmSgnNu9Ko3lxTr
         r7Oc8N8wrpXA68YR8mGPeRNOCAl3pb80Wl9ghrATv2w9I4sfK2Up9oZ+sx55h7prybZY
         pdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AZ74Gj7UvstdRIJwIZObZ8wpsCSw8LTudnzT16n1c7c=;
        b=FXLVTJ5y5AEW0Jkjfl2I/MVKLETmntLGKD+6kbFjor9txHcbg6NNmY1L4gYtp/P4/u
         XX8A1TKHJi/GZNhttm6rntIS6UoaY3l7AdQdzpBp3JxaOq5OFvdwz5Gd0y7S6Fh+pY/h
         DpBgW6Un8VCRIKQIhQNzCY8zhutIhvNmiK8Wts6A1Spt/ArJLyRbPGKp6uN/e3q1elur
         GVxBa6Tw+tDwASRuqtmNEYKW6elExXNiHPeTHTD7WoyJtgYY77S+qYQBiScKdyqBa4rm
         y+IZ8aQbIkQcLF6wGDvfXzRdWPLsyicHb+Ac/zX4JII5LnuvSyLf6kyWoKCVr/B+yNdZ
         FdIg==
X-Gm-Message-State: AOAM531Px20maAEJNLsvOIIsedu49KfL+aX7DHLP/EV25EVXyUaaxWAW
        s4RTCLBAnJYwyKHg6O9dUbZYG1GW2RxDK6C9UQRYHKQ=
X-Google-Smtp-Source: ABdhPJzolEoFmMIrW3ORwAmkiVXcsJ8X4vDCn/+yLzyP0PFJwORqNIzWrWWymJ/KSIxCbf5VwI59HARtaLn/bjj/D0A=
X-Received: by 2002:a50:ccc5:: with SMTP id b5mr12163768edj.340.1591982016789;
 Fri, 12 Jun 2020 10:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msn-fB-zi7waM8AWhpwRu0HpY_MNO86ED=8ykc-ZM5VkA@mail.gmail.com>
In-Reply-To: <CAH2r5msn-fB-zi7waM8AWhpwRu0HpY_MNO86ED=8ykc-ZM5VkA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 12 Jun 2020 10:13:25 -0700
Message-ID: <CAKywueQCH_=cywB6w53xje+Okm_WSxB0qSHjGGz6CgGMuia6MA@mail.gmail.com>
Subject: Re: [PATCH] smb3: allow uid and gid owners to be set on create with
 idsfromsid mount option
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We probably need to add an FYI log message inside
setup_owner_group_sids to print resulting SIDs for both UID and GID.
We do have a similar log message for mode.

--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 12 =D0=B8=D1=8E=D0=BD. 2020 =D0=B3. =D0=B2 07:32, Steve Frenc=
h <smfrench@gmail.com>:
>
> Currently idsfromsid mount option allows querying owner information from =
the
> special sids used to represent POSIX uids and gids but needed changes to
> populate the security descriptor context with the owner information when
> idsfromsid mount option was used.
>
> --
> Thanks,
>
> Steve
