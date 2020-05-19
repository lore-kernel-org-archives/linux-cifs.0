Return-Path: <SRS0=BTJv=7B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F54C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 20:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E00207D4
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 20:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZU+GZHkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgESUfI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 16:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgESUfH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 May 2020 16:35:07 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F81C08C5C0
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2020 13:35:07 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id g4so1211262ljl.2
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2020 13:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gz6n1pq8CUXICrMiTHpAubeiztHemLqyVj40iozb7O4=;
        b=ZU+GZHkfqDJfKahpPhk6mhX5+nMQecttlHBBJXvStiodQQFB8WQElYbMay6xu5+NEn
         garcesD06DtLHzYxCjJ3fiLXpN9G2PkZXcOcZ5klDR4B6MoYQOw2bideSoKRW+G75qUe
         Yl9r9o8KkbxChMkiiDzDKekyQXBvIssw9flY3cy2jbqoVm/ZVR4IFQhizsRzvyP36aY8
         jGQcyf+rNiqON6pwUqBn+OBs+X5f7wD42htRuEqsSLU6KNRf9KUfJo3axxeuiv0jQQFU
         Ci+jkQBcRsXiEM8+etecGo4nKsdHip+7ARzyuBsm4EIVejEzpwtq2ls+lmC3U8BnkQ1P
         E3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gz6n1pq8CUXICrMiTHpAubeiztHemLqyVj40iozb7O4=;
        b=K9FLkwUtq/dS8j6fICAQl0wZoPFFoc4mH9I61CKp4T1++Ot6X/s8RHRiJaTFaHikPC
         9d9sgxndUmF7S+G4vPDfoa4QK9UEGUIlPgI97ex1rfwuMBsB6aaWyzzfeo8oXgjLWO6e
         kBdhAmMBnnpsR1V/t0nEDrN2wDWn77X2qn9x8inuMEHv7RBC5er7lIwkqobIVFsSuPHm
         qie4Uy4iFthWZkDGLtiqXhwvOxxtTAKjgSHQJTf/oBbeAVlcBHAblliLNnT6x1Pgi7L3
         KVZvPVZISZnUFSbUMQsllGNdseItI1oKEf9d+NS4XAU6OVVJijtLPNkhHJ7jVGOac+MR
         SpZw==
X-Gm-Message-State: AOAM532TncmGDXhNokSha5zLIybDJpgnRy4tfJqwZbXw02iEiT9Kbdko
        vlbVO/zUMvMv+b4MBgRTwoRUN+hykpJIS7bGUBvGEw==
X-Google-Smtp-Source: ABdhPJzxF893HHf0b2ZEyl9CAhhfeGtJ/d0ye7NDp7yj5nsVDPzNrWGLr/pOlQFuumr/Hk8rs2aqC5L0BSzh1k+cfUw=
X-Received: by 2002:a2e:a58f:: with SMTP id m15mr729954ljp.146.1589920506005;
 Tue, 19 May 2020 13:35:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muydPce3j9R_he3DE0uMhPF-A40J0aPVEOXH-LKdjr3nA@mail.gmail.com>
In-Reply-To: <CAH2r5muydPce3j9R_he3DE0uMhPF-A40J0aPVEOXH-LKdjr3nA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 20 May 2020 06:34:54 +1000
Message-ID: <CAN05THTyf8LOMQT4iTsrQN+h1OTAObp5oTn+jxU3SGbq4An93A@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Add 'nodelete' mount parm
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hm.

Do we need this in the cifs module? We already have so many cifs
specific options.

I mean, this feature might be useful for when handling buggy applications
but there is nothing cifs specific in it.

Should this rather be a mount option that affects the VFS layer
itself, and thus protects
ALL filesystems from these kind of buggy applications?

(It can also be solved by ACLs on the server. A top level ACE that
denied delete and that is inherited to all
child objects)

Regards
ronnie s


On Tue, May 19, 2020 at 6:14 PM Steve French <smfrench@gmail.com> wrote:
>
>     In order to handle workloads where it is important to make sure that
>     a buggy app did not delete content on the drive, the new mount option
>     "nodelete" allows standard permission checks on the server to work,
>     but prevents on the client any attempts to unlink a file or delete
>     a directory on that mount point.  This can be helpful when running
>     a little understood app on a network mount that contains important
>     content that should not be deleted.
>
>
> --
> Thanks,
>
> Steve
