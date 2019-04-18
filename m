Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE187C10F0E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 17:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6B46206B6
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 17:22:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FCHYCk4p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388347AbfDRRWH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Apr 2019 13:22:07 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38509 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733067AbfDRRWH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Apr 2019 13:22:07 -0400
Received: by mail-pl1-f193.google.com with SMTP id f36so1473639plb.5
        for <linux-cifs@vger.kernel.org>; Thu, 18 Apr 2019 10:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=T0onxyOqyDzJuYCzUtM90tfTCTOo/tMO0Dx6jm5d5xM=;
        b=FCHYCk4pUiIy6C8G0HRKMXudwZPvPhyG08yVjkBB2UFE7L4kUjtxv++HuJJ9hzEGDZ
         jLb3zHaLnb1TbFCOX32GKHserF9pctDXNrZrxoW5FIjgoy2oMQVBs1BUg9MlIOCMyf2E
         YBQMFI3nxqLfDficIU7d1RNwhzIt3/0PXV4/lOUZ+iu6HypeTeMpnEDSbQvXvspLUeWY
         gepi3G+cIJ2643RnThq3Uvathmqd3mGv9zXUDibZxkDwhy3GqZnJBISUQTXecdyDoVzf
         PdqImzZ5tnuu2loVs/jfNn9RJIm6KWEUueZGQyr4IAswT+8ittwY8tf5+hkwPPhroH8e
         kQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=T0onxyOqyDzJuYCzUtM90tfTCTOo/tMO0Dx6jm5d5xM=;
        b=S9OlCoXC6km+5qKYFKEUGpQQ6X8sOdkE1/aULZ5lLPca4eFeH4fmfE1ZKz82csycHG
         uW3ghyKtiTNOB+/BFsjqJd5sgwyu7+0WLFfO1Yb7qe3eXD6+P7IeABDvbjvnl5wDlu/g
         kLgedcokRjOQbKsPNCNPamJWmsSA35TUBtrnW7GhRgdAxFT0mhw1jMFCMelKwwYgIvEB
         wgU84HVV+Prl+xrBUIGyYmqP7Evm90gzxEPtHv6WUBxWLO+Q/KKz0pscE9JpB5a9GHDg
         ofRMfU+wjPqsXkRwcbRz3be2M2oYB5e/TrJqfXrIO8TdZcQpnfVbc9RoOi+BJFkeFJX2
         +Qew==
X-Gm-Message-State: APjAAAVKO0dfQKdckrvNrJwky+oUzY5T8wVzol0gxzoJTxhPHT29+Qqm
        JwTRm1NuGiqL+ukJmOi1qchHW4R7tHK8drlIO7xQ/hNp
X-Google-Smtp-Source: APXvYqwT8vJhBx9MtoEPT6+/keg/uU3xe/lacR5U7uAP41N4pWSz3F53YTbhuUQRev67vU6+yBZNITo6W1VZCF91ux0=
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr96788684plo.32.1555608125419;
 Thu, 18 Apr 2019 10:22:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt+GGF7qwghbNuPEfgMQtyFmKWz8pSeri=mw0W_3wieCQ@mail.gmail.com>
In-Reply-To: <CAH2r5mt+GGF7qwghbNuPEfgMQtyFmKWz8pSeri=mw0W_3wieCQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 18 Apr 2019 12:21:53 -0500
Message-ID: <CAH2r5mvdAAAVCsjZxtsYW0aQr5r28Uj63dHAUbptfuvyGVZmTw@mail.gmail.com>
Subject: Re: Full backport of all 83 CIFS/SMB3 fixes in 5.1 to the 5.0 kernel
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

And a full backport of all ~160 cifs/smb3 patches (in 5.1 and 5.0) to 4.20

https://github.com/smfrench/smb3-cifs-linux-stable-backports/blob/linux-4.20-full-backport/full-5.1-smb3-backport-to-4.20-kernel.zip

On Wed, Apr 17, 2019 at 11:41 PM Steve French <smfrench@gmail.com> wrote:
>
> https://github.com/smfrench/smb3-cifs-linux-stable-backports/blob/linux-5.0-full-backport/full-5.1-smb3-backport-to-5.0-kernel.zip
>
> The README file in the zip file has directions on how to build and load it.
>
> It passes current xfstests.  See for example:
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/145
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
