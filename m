Return-Path: <SRS0=Y/WD=DN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79031C41604
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 283B520870
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejGCdQu3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgJFFZk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 01:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgJFFZk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Oct 2020 01:25:40 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441CAC0613A7
        for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2020 22:25:40 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id v60so8097020ybi.10
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2020 22:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IdvxR362jmTvknVMRRpQ9VymqxsvGU5//5/U9HJ7+a0=;
        b=ejGCdQu3UH0JAujZoHuGa45TlCijMXyd41RgWbURWL3DYRK80ydh0QUKxpm0pAT1Qs
         LlgRrIgjrx8VGepkpKvYSK0ORpKg//fCxbsgWjgwNNOhHB9x5vQv59cSkXDTaPqzWnf1
         yDUQfp5kY/Vsq189jQZwaALxA11k7NKsslzMOUQTHfjSUYHpplQ/kOPYncMKrFl6AcRy
         pjPg7K8AbNBcbGc9SjFmgSZSzh23Xy/s4QKxdGlvb3yxqo3GG/iZmPRc49ghUaEMVQKd
         49eYAerwkoiK5yzt9nzuzODxtUSmSItF6JcYb/wGYg2Qjwk/Oq6r0PigwlT+LYqQCDbp
         0g7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IdvxR362jmTvknVMRRpQ9VymqxsvGU5//5/U9HJ7+a0=;
        b=tVlOWcB8z9a552uytYjfQcqA7OuB78Or3TdqOnLjtlUgFibr2pdnQSgK0oWddF9+im
         447k26UJlQX81GM4OAqDVGPmXTeXAONl7Z4uudw06wy36CQHRjHKFI3IwustNQlpvICn
         l9GIbicWdgysP5jIhR85H20qTACcLZCiQAF1ccGVoThNT4mv+f4F+o6oHAWJmVI0a/06
         ku7J/Gc9QKonsKdOeFNSd8d1RGi32XpM1Wq50xwNQbsROtkZVon55INBbcGfLp9sXINv
         UghjlSjjXm3BFrj2awC4unTXWvPJ2VYCscI9ZBvOD+q8IlMMJ4AU2aILgUcVCe3AJ4FI
         g1Og==
X-Gm-Message-State: AOAM530YwOEwb8IbPeeJbKGg6waQikLwN1a7sXJ3paKq/40sEWxCV4mk
        acvKMq8E9A/RXV9TWr5+qhayli2ujDa1oGUrqCVPpD/ylw2Sbg==
X-Google-Smtp-Source: ABdhPJyYWGo4Iuoc70JyH1hNwMEIYxO+QcA15a8OxL9QBnWieoiYhsFd7TnzZmGt36eWTlydDh6no0Tr5Zwx+00T3IU=
X-Received: by 2002:a25:1405:: with SMTP id 5mr4521328ybu.97.1601961939332;
 Mon, 05 Oct 2020 22:25:39 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 6 Oct 2020 10:55:32 +0530
Message-ID: <CANT5p=oUOsR---hHYF2k0smsq+qu7K4W3hUYXD2-c3D_cCsf1g@mail.gmail.com>
Subject: ENOTSUPP to userspace
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Recently, we saw one customer hitting an error during file I/O with
error "Unknown error" 524. Since this error does not translate to any
error using strerror(), it was quite confusing. Only when I saw that
in errno.h in Linux kernel, I could see that this error corresponds to
ENOTSUPP, which we return in a few places in our code.

I also noticed that there's an error ENOTSUP, which does translate to
a userspace error.

My question here are:
1. What's the purpose of these two error codes which look similar?
2. Who should we talk to about having corresponding translation in strerror?
3. Should we be returning ENOTSUPP to userspace at all? The open man
page says that for ENOTSUPP: The filesystem containing pathname does
not support O_TMPFILE. Is this the only reason where we return
ENOTSUPP?

-- 
-Shyam
