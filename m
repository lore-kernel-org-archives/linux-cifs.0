Return-Path: <SRS0=c4TP=VM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61A4C7618E
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Jul 2019 07:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B1BF20838
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Jul 2019 07:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jtFWvSgg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfGOHuo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Jul 2019 03:50:44 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:33297 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfGOHuo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 15 Jul 2019 03:50:44 -0400
Received: by mail-yw1-f68.google.com with SMTP id l124so7074873ywd.0;
        Mon, 15 Jul 2019 00:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2PPKKiy4TOkySs84erSTaGPrR7iQ7CdeTu3bd/bWAIQ=;
        b=jtFWvSggLjAdlRoLceRlD3L8mhrjoJM+b0hNi6SVyoUIjpIXh+1F1+YFQT/gTco5dG
         YOxQod8ltqERqXGxaHtsPX6i9FbySs8UfKp7XsGbfrYXJWBGYgnA1baouQncNkf4apuu
         QiZzFEcrjgqh2/rbw4fMJ2mE1x8tbTBoWLxa5m7hWHCUP97jGjeL0Yoc5PEplVb4Ocsi
         0IMYSmkyG/2z7OFEi/xdE4IA+v56nG3HEecfIDojLpKKF9Loav6H1bw4KCprkvAq2fNl
         JbbqfG9sP3mybUuHsb8iDiJBjasVnMssEQALlAHSOBpclwfIaZwZ9SOx6HWFrJnrgCHP
         3z4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2PPKKiy4TOkySs84erSTaGPrR7iQ7CdeTu3bd/bWAIQ=;
        b=DmTZnizGocCjRg7zINPh8aR/iqY2kSPlSM0sywe4SESL7iKOFeeE4mmlqj8PYjyh9G
         lej2wg8owvRv6UAdsg6+fvdx+bAqWG3RdrIH24rge12OSBtTKpveXotRFpzPTKVOu/bR
         aggHFGs1y8AZxxbO0WodlhdgsALfXBP9DxxzK8Y2JWnBHtQyJPkjbxnc7CNPTqj7sHSc
         t+GgCTWyGT3Y7l9tCwhhxbAYAbFsOmWUT0x7Coj55m3B9irbLfTWJs12ymYllfZIwjkE
         Q93PsRxSHsetPtcKPwAqNBFVw8KXKe09jZmAeaSEk1PwF6I5sf/mRFUyp1g1Iv94Uauy
         njLA==
X-Gm-Message-State: APjAAAXne7RJlj+oZJKHsChg7+AB2DWI+twZJV/K8Uiyg6LTqzrXUgpu
        R7a9m3gUsgrqQZhYwJcodv04aSJ5vfIH5f7HDd4=
X-Google-Smtp-Source: APXvYqxlHNixHRSxJaTHsrNyfNsQ/iEjX941UVv5ReMsihu6kuOIKxsk1kVQyd+N4jh7C6Kvt7BZ7YjXMrjrZ/jqRf8=
X-Received: by 2002:a81:3c12:: with SMTP id j18mr15450493ywa.294.1563177042978;
 Mon, 15 Jul 2019 00:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms8f_wTwBVofvdRF=tNH2NJHvJC6sWYCJyG6E5PVGTwZQ@mail.gmail.com>
 <CAH2r5muC=cEH1u2L+UvSJ8vsrrQ2LV68yojgVYUAP7MDx3Y1Mw@mail.gmail.com> <CAH2r5mu0yMPX+JFrWvnciYdWVRxGYgPsSX2UKOj2O70-bxzrsw@mail.gmail.com>
In-Reply-To: <CAH2r5mu0yMPX+JFrWvnciYdWVRxGYgPsSX2UKOj2O70-bxzrsw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 15 Jul 2019 10:50:31 +0300
Message-ID: <CAOQ4uxiQC9_OnrdzV+XniFeTDorAe-YHxWEC5c9pT_mxa62JxQ@mail.gmail.com>
Subject: Re: [SMB3][PATCH] fix copy_file_range when copying beyond end of
 source file
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jul 11, 2019 at 6:19 PM Steve French <smfrench@gmail.com> wrote:
>
> I noticed that the copy_file_range patches were merged (which is good)
> - see below.
>
> Anything else to merge for the changes to cifs.ko that we discussed
> earlier.

There was the cifs patch that I sent you:

cifs: copy_file_range needs to strip setuid bits and update timestamps

That was not included in Darrick's branch.

> I wasn't sure about the "SMB3: fix copy file when beyond
> size of source" patch - it may be redundant.  I will need to check

It is redundant, but if you plan to forward a patch to stable, it
will be easier for you to forward just the CIFS patch, so up to you.
I am not sure if and when I will get to testing and forwarding
copy_file_range patches to stable. Not sure it makes sense.

> with current mainline.  Anything else needed for the enabling of
> copy_file_range cross mount etc.

The mtime update patch is not *needed* for enabling of
copy_file_range cross mount. It is a correctness patch.
So copy_file_range cross mount should work in mainline
with cifs as long as other cifs related bugs have been fixed.

Thanks,
Amir.
