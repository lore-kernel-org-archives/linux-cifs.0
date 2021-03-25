Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FDCC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 13:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C722E61A11
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 13:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhCYNUd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Mar 2021 09:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhCYNUH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Mar 2021 09:20:07 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F99C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 25 Mar 2021 06:20:07 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id y32so606236pga.11
        for <linux-cifs@vger.kernel.org>; Thu, 25 Mar 2021 06:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kOIppp9eQaOl5s3xHU5yVhrne8LywVRJMXL37bPGEsY=;
        b=IdGFZsQ9PD1m1jZIsDYoIOoUoaZHbU6mG9fXmsi/09Y+h/D2q8YCrFrNy0hlX4ZnB4
         L0P83TLTAFfzQgovBr/NtSgjteccGRRMkiZ01Imw/oC7QEhWjllGsMEOe6pJUbwpDI5p
         zZfPxLwq37EZOxOQ2/3bYLN+jJGaeE46YfZpCDnfnHOiWxmFehIBL+cq0jopJy9MFdN9
         iI+mj7S2inuX91g78SKvLjRbcfsywT+ZK8NogzeqIfecVKoskdOTtKBto14uftnAQ9sh
         bcEEL0fGQP82dgny/wZ+BobBifKwlcyObWtAYvVIbVGlE2ePeyDFE6v8Yyk8Sh/4v8dF
         SUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kOIppp9eQaOl5s3xHU5yVhrne8LywVRJMXL37bPGEsY=;
        b=iMtCAGqK+Cy1G+n4q3afSexmbVG8QWN6yKAPa8W2bjj8r9ziSTicZPwJo97cozYLs0
         ZPINRNUmXYqh1cbPRXU7EP+KCM5EpGhcqc4CQd/IOBfv6ffmJgWuU7y/6bf4757l4wsk
         /mQpa+qZBl1HoICE5GDKsKXeHbhWcFs7oCb8Dmf1bC2gwzdYE/EniohHHq4AdqZnmyBx
         Cx37gbRCThjD6ZRE86U3Rdv6grekDQ9it82qqTHo5UYXBx+iRNVALEdlS1YuKI4uzn7c
         uz3EcpqtZNXqHkV5GoFWTyXewK7lUXa6Zme27YUpaK7VmEstsFC0MfN89hhinPBLjEEz
         u3+w==
X-Gm-Message-State: AOAM533JfcZhINe+MHDI1Ir/Z6Q3wEgF5bs8xe3X3vHiN8oj9HkS/wCZ
        YVQgCGFFUBuSUOM7sQ1L8baHs+WxwSSQzKYJR8k=
X-Google-Smtp-Source: ABdhPJzJvTwe3iOFBuf5B06qFNAajibTwGxXYFb3q/2Zq5iROg2fM8r8PQNBH1iZHyWuZSQYGZi5Tdk4D2Xi16G/NPk=
X-Received: by 2002:a63:3ca:: with SMTP id 193mr7583374pgd.274.1616678406753;
 Thu, 25 Mar 2021 06:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qKxu17O__xWzwfbJJ4RAAK4whg63Yx6P6FGKVYrMkxOg@mail.gmail.com>
 <CAN05THSVmeYGqky=jG2_Jrf0GxdPumASnWoMx8TrzQ85hbDLDQ@mail.gmail.com> <CANT5p=p4j0ngRxsE-f9KF8b-QmoP2isdDoKGiWHGvn_q8W3C-A@mail.gmail.com>
In-Reply-To: <CANT5p=p4j0ngRxsE-f9KF8b-QmoP2isdDoKGiWHGvn_q8W3C-A@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 25 Mar 2021 23:19:55 +1000
Message-ID: <CAN05THSSMByhwUVRxFKoF_DdYFDMefz2ieCmdiRwbuxzL5kMKw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Adjust key sizes and key generation routines for
 AES256 encryptions.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

Handling all the keys as 32byte arrays internally should be fine
but for the cifs_dbg() output I think you should add a conditional and
print them either as 16 or 32 bytes, not always as 32 bytes.

I.e. don't print the 16 byte padding for the aes128 cases.

On Thu, Mar 25, 2021 at 11:08 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Aargh. Here goes... :)
>
> On Thu, Mar 25, 2021 at 6:29 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > -ENOPATCH ?
> >
> > On Thu, Mar 25, 2021 at 10:53 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > Hi Steve,
> > >
> > > Please include this fix for AES 256 encryption algorithm based mounts.
> > > I've validated this by mounting and performing I/O.
> > >
> > > --
> > > Regards,
> > > Shyam
>
>
>
> --
> Regards,
> Shyam
