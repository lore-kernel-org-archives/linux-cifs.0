Return-Path: <SRS0=rDaF=SF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11610C4360F
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Apr 2019 04:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D49B4206C0
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Apr 2019 04:27:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tuttDmrJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfDCE1f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Apr 2019 00:27:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43156 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfDCE1f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Apr 2019 00:27:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id z9so7628488pgu.10;
        Tue, 02 Apr 2019 21:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PdkoXEhApTwhfvj0n2bSA4MraR0FOtrJZZg+GexoHbk=;
        b=tuttDmrJasaKT8xGu/mMu631Y1yABCj8LdKfoRf85VzfRkNwdiyY+8JCqjyo6KHqpr
         S+Yhk6UjrY5XKeBO82keGuPbY5HFaQWs/F91M16qsjy/1NJRmVIABonT4YmnI4nobHWr
         1KjqUyJgq6bagu/MZUG2clyFk+Y6a8k+I9+g6rStdzXmQC1IAFW1MnRDkwjslwlVPPs7
         uUH04x2PIE3kSoO8wcertubgHi2b3ZMWFHdyuLXZtVmyT9tj9Zws2FaUV5jUF0Z9SLys
         l9jzoo3pwDg0zOs9pMLbPFT6/nNncZOI7uBXlw0u97UckR2F6xr8OBNDfxNqsUrFGvvs
         UI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PdkoXEhApTwhfvj0n2bSA4MraR0FOtrJZZg+GexoHbk=;
        b=KNn01O0VWLJBSJj1FyPBCF15UnScxspX0vuzX0JuRnZSQryZgOSUnhME2Uay+IoZJj
         No7GaLOWa1TteKiZebCdXdxdO+69nHDUp+nEgDLDFAUeAjS9jQC2wxZBY8oZO1k0nxeD
         jn1dl2e3IzWYXO5uFLSbqaYgB1Rv0TvlqOahaKYuP6w0xoUdrdg7FkETmh2cSdp7u4zM
         qjTWElYMJTiMCY/RBRptCeAfcX0RoGhvnAA+3c23lRwcRo7gRKaC+GMZ/TI/ylVbhj1I
         MS+wxM+UqOiG4S04HoWcFe3a+2tYoGC2HsTrfB8Ui8kK9PxRpfn3mchNetaRBOZC/T6N
         AxiQ==
X-Gm-Message-State: APjAAAUhoC7q9qhm7TYy4mL/cM/C0RglXunD80pX6Y9h1TcYQosUWq+i
        qSXvcjcvglTWLgRh0POFvN7FB39rfvxPBkbxa8E=
X-Google-Smtp-Source: APXvYqzZsppQAQVjntqhwpSnlg5kvy5/w8vuxP3FiXBp0U483ch6C3OilhyWnzFul/kBvKppajLNzjIbBp9m1qK0m5Q=
X-Received: by 2002:a63:5f05:: with SMTP id t5mr19848906pgb.176.1554265654072;
 Tue, 02 Apr 2019 21:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190403074039.7c7af691@canb.auug.org.au>
In-Reply-To: <20190403074039.7c7af691@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Apr 2019 23:27:22 -0500
Message-ID: <CAH2r5mtrpLk4OO-T1texGVx8cjMtNaRbSHKXgzxTqqFFga-kSA@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Kenneth D'souza" <kdsouza@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixed - Updated author to match signed off line

On Tue, Apr 2, 2019 at 3:40 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Commit
>
>   d0cb257cb7b0 ("Show locallease in /proc/mounts for cifs shares mounted with locallease feature.")
>
> is missing a Signed-off-by from its author.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
