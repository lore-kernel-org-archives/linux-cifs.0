Return-Path: <SRS0=ILFa=ZG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6B7C432C3
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 18:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 612DA20723
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 18:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bnDl7/3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfKNSkP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Nov 2019 13:40:15 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:39196 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfKNSkP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Nov 2019 13:40:15 -0500
Received: by mail-il1-f194.google.com with SMTP id a7so6262793ild.6
        for <linux-cifs@vger.kernel.org>; Thu, 14 Nov 2019 10:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SNfynySlMUI8yfKbApK226jvKHTRniNlM+6ydWl1094=;
        b=bnDl7/3lIDgs29mhVcID6AQ+mNKhuuNkBFYJ88fXfiP0Da7D/QIOCw+UnP/ukwJPap
         A48u3UCnRNgW7U4Vp/xi4PQH7GaRYZFTMmepG8u6IBeOR4TvLtMLIh3ojcY4/BrzxmCp
         Id+BwQ6/5YFsd/9GDXhDaa7sqbdvGJlZWdHoszjKI7GEyjJ8pyfFm5gN8ZgTmm1CgIt6
         4cjr3l5wCFFDHoTEhapMOGhFmlYTzA0clCYKA1LthgwdwpA7fnTB/SynvF2wzuawq5GD
         zgK2HV2X+IGOucZ4Yec6eQ3Vb5b5+mvdK3x5JXktjFmC4HDv0CbrYfiNliwPz5oLBmd9
         PeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SNfynySlMUI8yfKbApK226jvKHTRniNlM+6ydWl1094=;
        b=Tcb+xqfZFvI7h0gReX2PW2aFhbuT0kFSqm5HPPlLOLwwhD2hv0m2kcXeMU8l5At8gN
         GkjmNg0p9w4k+yNeKvcrGDK7ycGcp4v/RcCol1GCqD7AjSWaTKc65h231nTQ2yp3+f7b
         wKwlDAZVX8Mi2sM04b09wIA0m9aw13Qob1MxFpN1GaE8kElNm5iFcLNiFkoniU6EqI6K
         TFdWLH1OgmCyctKpMpTZYOhFaXRJGz0ED3MlMmAQHnMzyWOQDmywHBMTIP2d8yKUab9R
         g6TdDDEQHtWk4uTTzNxcnePE5Hsi9jaXSB7Tov48nKEBCG+hpFSa7o49TZIBOmVD7UiK
         UqsQ==
X-Gm-Message-State: APjAAAV0w5QxIrzVcPs/vXlsvLlGZpD9jxclW7DM/6+cdHaYvUg0UgyS
        NN99d8t7iLbvEYso+OLzF7ujWAU4J2cu+k/j9/vyTlIw
X-Google-Smtp-Source: APXvYqzb7Ptn43zvuRAGi7icMxEZTZoY99p2a0m3MTncBegG2aEefLoGtw7nbtb0cxEIBPfA/2m4RxrZqSWSzQ5BjDc=
X-Received: by 2002:a92:1793:: with SMTP id 19mr11514101ilx.3.1573756814066;
 Thu, 14 Nov 2019 10:40:14 -0800 (PST)
MIME-Version: 1.0
References: <20191114061646.22122-1-lsahlber@redhat.com>
In-Reply-To: <20191114061646.22122-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Nov 2019 12:40:03 -0600
Message-ID: <CAH2r5mtbu4PJCW4NN6798S-KcBqwMfbhtAJ_fjZzur92KHh5nA@mail.gmail.com>
Subject: Re: [PATCH 0/1] cifs: fix race between compound_send_recv() and the
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added cc:stable (also to Pavel's patch) and merged into cifs-2.6.git
for-next and also updated the github branch used by the buildbot

On Thu, Nov 14, 2019 at 12:17 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Steve, Pavel,
>
> I don't get any leaks on open() any more with this patch
> and no leaks on close() with Pavels patch.
>
> version 2:
> Use is_interrupt_rc() to decide if we should flag the mid as cancelled.
>
>


-- 
Thanks,

Steve
