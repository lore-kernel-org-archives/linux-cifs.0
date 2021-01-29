Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41455C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Jan 2021 02:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 044676146D
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Jan 2021 02:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhA2CFi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhA2CF3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Jan 2021 21:05:29 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB8BC061573
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jan 2021 18:04:48 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id u7so7724264iol.8
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jan 2021 18:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MB0TlIxvxFJW95GB8vVeuPfNt5HqjFr0ihjLnRhDiow=;
        b=dMrR69OFTWxsUcu1PoI0unfmnaEbFsaHA3OWm1N1ztJBlngvucucG/KIGoBqxF9Jh4
         HVAIpX7KXo+VyK9LaKevQ65kRTO68l7PxowI60jP+abE/LI+EDsVuKzl3R8sgEi+1qXX
         5ImpT1/G2Sh65Z1Ea5SkA20mf73h20xm/SexO2hnvqCP3U/JbvmD5w0YWi7LCAC/yVCW
         XuM3coOjGqTglkkL407F9IgEAJ/GoiIiU2YSiycaolaLF+R7BKOpGRZaRJ9qNKGCrjAf
         /r8QYYORvwZt4moN9l4cIvGRvqFgOBZasJit7Pv/LvdCM2VKYT62mHKccIWfjE/cwLFz
         VXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MB0TlIxvxFJW95GB8vVeuPfNt5HqjFr0ihjLnRhDiow=;
        b=qmu0hIK0GSKxmgR50NUr8+nglYKrgzUJKkKP/BO9mGAXJEUjbViLoISTHlmVBmUauY
         jA+C0n75T7Mauqrbi0iE7RMQuVGVVMnU1KID9JMtz2+8GZar5+6XpdSSKREqiTJBDfHJ
         adbk8d/NK0zQr+dAMtJcFwK7fwLVFDVBHMFiOTGC33ssnTZGeEBShxKErBOM0g1BrU2n
         7e3UB/CpgSrT4YRaz9qBA4djuojm1JP7mDbX5Q6gTJ5dhz9THkCZT2uEba/8iO4BQyzp
         93m2qiIVdPSRTdw1YECBzxhXJfpvzC0AwO/5J2G0yf9PMulyzwcwWxqOOQZ8oP+jp+uo
         4aEQ==
X-Gm-Message-State: AOAM530XcSaI+bElpW8F3ESkojoM34O9d7+sihqQtfNM+yce7unrHT07
        r5L3Ehkg3y5UVKZoU/3vbigL+HTdKGnLzzz+x0WuMRq7
X-Google-Smtp-Source: ABdhPJye0umTEaF8nDr10qsn30krEt78OMMMfcvvYr8c8daXqRO7nSAv5qa8bEIF9GbqwB1Y83SnvUeOY/GDvnSN1Og=
X-Received: by 2002:a6b:f107:: with SMTP id e7mr1797751iog.191.1611885887842;
 Thu, 28 Jan 2021 18:04:47 -0800 (PST)
MIME-Version: 1.0
References: <6013618B.40707@tlinx.org>
In-Reply-To: <6013618B.40707@tlinx.org>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 29 Jan 2021 12:04:36 +1000
Message-ID: <CAN05THQbTV6h43_Bd8pjVcsvNp4F2yby=cgfc36F=mX3iAaw_g@mail.gmail.com>
Subject: Re: cifs _seems_ to be unneccessarily increasing memory footprint.
To:     L Walsh <cifs@tlinx.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Authentication requires crypto, as does signing.

These are module dependencies so they are loaded when the cifs module is loaded.
They are not loaded on demand.

Or did I misunderstand?

regards
ronnie sahlberg

On Fri, Jan 29, 2021 at 11:28 AM L Walsh <cifs@tlinx.org> wrote:
>
> Looking in my loaded modules, 'cifs' is loading
> libdes, fscache and libarc4.
>
> My main question is why does a cifs filesystem that is
> mounted from the network need libdes and libarc
> if it is not using any encrypted connections on the wire?
> (FWIW wire a a dedicated line between a Win WS, and a
> linux file server, but encryption has never been needed.
>
> So what is causing these modules to be loaded in now?
>
>
