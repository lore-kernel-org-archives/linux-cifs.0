Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B491C10F0E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 17:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 561E0214DA
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 17:33:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CEhI+WrM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388457AbfDRRdR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Apr 2019 13:33:17 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:44130 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733192AbfDRRdR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Apr 2019 13:33:17 -0400
Received: by mail-pf1-f177.google.com with SMTP id y13so1410329pfm.11
        for <linux-cifs@vger.kernel.org>; Thu, 18 Apr 2019 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tQXVfCkp+Rku1WKWLf71XNLSbEtAMDQBQvdRM4K35pc=;
        b=CEhI+WrMREmzqzvzvWo1Tb8DIo/orPqLXfCaPtllRBM/Zkbn2/ESQKtv5CohpYB7lJ
         IPUhvY/m2vxyAZkgZESAMkGd+1pB8UV0d/KYRS2ioZASwHQcBmjRwTRTxRcm9mAB5YxJ
         44pLrnl6AJhPijHE3zgDwWQ1tXvbKE8U2TmKrIEwS8fNiAOrIkmo7mumYdfT89c64QKZ
         zFQH0yno59BgMKXBlu/MsxwxJlhmEYjIxXBF8CETnaAgTD0X/M3fsN4nMPWp8k/m97qq
         ZcKC5k2KzXffFicpNDhV3NDbHksrpp9WzNlasgAcU3B22pRhuXq0uwW+hE5ufPykNj2S
         zmTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tQXVfCkp+Rku1WKWLf71XNLSbEtAMDQBQvdRM4K35pc=;
        b=fEk56tGjWXSNJn16TRtCS1zLFry19zJnnehVrB1IPkEYKtpNcxh6L6IkznJxlQQNlE
         Rnr7A7S1DphbtypVrMn/+Kqqe8eZ+bmH0Xfeg2Kbdo/uuGEIJ/0ZYSeLRDARHVY4Cr1H
         +Sri/6Z3cJHZVRUelshs4Cv5n56v7Qn2409pvrbURRMgloNhwjKvc//pzybhGPpQpCc1
         bPFzi+MnE8ltaYu4Y9djomtdn1tYev2U1NaMt6CasJWyxDotfoicsia+1KeJ75sJtjIz
         UcMecsOfx1IDA3koTqk31F1VGqfd/MXZWZ87vEA89MnLHs3tTKLObTnua6+WgWQLVTFN
         /ZKA==
X-Gm-Message-State: APjAAAUdIHwk4bwb1a2kzRli5/9Ur7iH2BVvbOyZJUIuveZHCZe1MQst
        bWrM/WomyZC218XqDIYopgRCtKaAvb8q+UwPlCs=
X-Google-Smtp-Source: APXvYqwbq/AByd/48SfP/LBIY2ervRQr0/6xVQ8SbqiaCH+rfjbdSoW4al/B32C3dHuJQYfDMnFH21oBXFKHDb62kOs=
X-Received: by 2002:a63:a55:: with SMTP id z21mr6761835pgk.440.1555608796588;
 Thu, 18 Apr 2019 10:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvEYMEUjz8BDRUumn0yGq__VntNKx-8AzWcZgCDOJQv-Q@mail.gmail.com>
 <20190418172353.GB236057@jra4>
In-Reply-To: <20190418172353.GB236057@jra4>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 18 Apr 2019 12:33:05 -0500
Message-ID: <CAH2r5mtqnNk2u5UksF8vgoRe3gd5a5T2WQsWZdjzf-v+y=xETA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Add missing defines for new negotiate contexts
To:     Jeremy Allison <jra@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I got these from looking at the diff on the open specifications web site

https://winprotocoldoc.blob.core.windows.net/productionwindowsarchives/MS-SMB2/%5bMS-SMB2%5d-190313-diff.pdf

On Thu, Apr 18, 2019 at 12:23 PM Jeremy Allison <jra@samba.org> wrote:
>
> On Thu, Apr 18, 2019 at 11:06:57AM -0500, Steve French via samba-technical wrote:
> > See updated MS-SMB2 - two new negotiate contexts
>
> Link to latest update ? Is this a draft update
> or a full new version ?



-- 
Thanks,

Steve
