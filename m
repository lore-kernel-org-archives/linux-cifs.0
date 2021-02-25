Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557CCC433E9
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 07:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C09F64ECE
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 07:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbhBYHjA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbhBYHii (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Feb 2021 02:38:38 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F704C061786
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 23:37:58 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id y202so4916695iof.1
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 23:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1f8E1P2pGTdUDkLDMpF9v0CslqPA3HGGhTjYJrJsX3M=;
        b=VA0cX86FGbvMKuOI0m0PEInj72Y36sNpI5/70irqMap6yqs1Yta4O9l+BG4q46p/6u
         Azc35Hd6ngWB6+KW+pgtlumq6RNPrOvTAoqYMHR86Lahojzmw9xyCkYpFOQ6/jeDXhP4
         HFMkp1RNtEvtmRtBQ/E6a9RRkqiXXiiT2q1ksqoC2KQMiBXYWnjKglmdgzPXorbmYRTg
         YOZ0Ew7IOr+bSUrwn5QEL0fnQZk9OIc1YonZwiT0v2wMMTEI9UWf957+evG/T3SwLSih
         j9DTQ+dWZ/kttOaNfBQ1Y9SuE8Yvqs88ZdTMl/jhijfst8tcnP5rrNllVpG5S8dMqYdF
         TFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1f8E1P2pGTdUDkLDMpF9v0CslqPA3HGGhTjYJrJsX3M=;
        b=k+rof1jHLkQFFzyGr/XIpAM9Zlvovqz81eXaWkM7g4cLhx+9TFgZQ5lFLRh0bGqLQo
         aJPTKnKwCWEr3UtViiA4WR82xV8lJ3hyvYwH2p93L7D+/HjQ96/x8zhNSIOdGebseEdW
         USm1LP9AQ7apmuF7JrUTiD7T/F8yAlYga11AxoCCwp9cu24qkLQBjcSZjdk5lkmMoXpD
         RA1DHqSYrTuqUENBHpgptYMuag08JyhiXLp58tOE8Bi+5jnlT2CV6mFSUTZwt75tmDHv
         dSlrHnFmLChQgsCCk+A+6GPwxBxxjBPAkv3jF+Cjnp5boDhMWoL32GbXuT78w8XhAgGA
         lsgA==
X-Gm-Message-State: AOAM531xajeEI4/ZnESaeOZctXSWa9XWSWj/rdvhL/A6l1sLdfsBo9v7
        yQLoXIvuRf7QmbSo7Hxgrk0sKxUa0AWYVaW2jcgO7J3h
X-Google-Smtp-Source: ABdhPJx6i2DSsK0nrnULUaYbRT7ykq7it2VJDvXmC2xXQWBwY2nM+F24O+XjZAzKzg2fzrZoVi3eYN5EatqFn8wUtME=
X-Received: by 2002:a02:ec5:: with SMTP id 188mr1960434jae.20.1614238677775;
 Wed, 24 Feb 2021 23:37:57 -0800 (PST)
MIME-Version: 1.0
References: <0736dea6-ab54-454d-a40b-adaa372a1f53@www.fastmail.com>
In-Reply-To: <0736dea6-ab54-454d-a40b-adaa372a1f53@www.fastmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 25 Feb 2021 17:37:46 +1000
Message-ID: <CAN05THRTEXjZ+TQB+X2kA_i8CgKctBDB1UhbifAu0WzqHOuNmw@mail.gmail.com>
Subject: Re: Using a password containing a comma fails with 5.11.1 kernel
To:     simon@simon-taylor.me.uk
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Simon,

Looks like the special handling of escaped ',' characters in the
password mount argument was lost when we
switched to the new mount api.

I just sent a patch for this to the list,  can you try that patch?

Thanks for the report.


regards
ronnie sahlberg

On Thu, Feb 25, 2021 at 2:56 PM Simon Taylor <simon@simon-taylor.me.uk> wrote:
>
> There seems to be a bug mounting a share when the password contains a comma with the 5.11.1 kernel.
>
> I used a credential file named commapw
>
> user=CommaTest
> pass=beforecomma,aftercomma
>
> and the mount command
>
> mount.cifs //workstation/arch /mnt/arch -o vers=3.1.1,cred=/root/commapw
>
> This successfully mounts the share when using the 5.10.16 kernel but fails when using 5.11.1.
>
> The debug log was:
>
> [ 3835.380355] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'source'
> [ 3835.380360] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'ip'
> [ 3835.380362] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'unc'
> [ 3835.380364] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'vers'
> [ 3835.380365] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'user'
> [ 3835.380366] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'pass'
> [ 3835.380367] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'aftercomma'
> [ 3835.380368] cifs: Unknown parameter 'aftercomma'
>
> The kernels are from Arch Linux packages:
>
> Linux 5.10.16-arch1-1 #1 SMP PREEMPT Sat, 13 Feb 2021 20:50:18 +0000 x86_64 GNU/Linux
> Linux 5.11.1-arch1-1 #1 SMP PREEMPT Tue, 23 Feb 2021 14:05:30 +0000 x86_64 GNU/Linux
>
> --
> Regards,
> Simon
