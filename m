Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F67C433B4
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 18:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 033976143B
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 18:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245165AbhDUSTv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Apr 2021 14:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242578AbhDUSTv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Apr 2021 14:19:51 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0915C06174A
        for <linux-cifs@vger.kernel.org>; Wed, 21 Apr 2021 11:19:17 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id z6so4901065wmg.1
        for <linux-cifs@vger.kernel.org>; Wed, 21 Apr 2021 11:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=s8c0NicUYEcrV4Ty9VZzFaPkBNNf0fYBSQj9DkmA98E=;
        b=fj4ygWqUaqI2DjKE1EsuRqQA4TKLqIt18wyIc08fbNdeTpXkNcp5asLqy6XvmxTFu8
         qtlyrjuKwQ9cahhmUzf6Ppu1LAwzIYP/ydy2QdUpq2XM1rSLhCJgYX7GcZwWm3KiWeTN
         1P0vyCaGucbAu7i906LGRJKgRlME+ERsyidEamJ1fG51lGKHKX4mSbDE5lQ1xfmgTVys
         UEDJXyRz9LE0F9J4dFZ36ZfIYTky18MQwQLNoPes5ifRwylsWcX+SxwJRoVJyUhInQpm
         XfZO3AXN7Y5IHv3UvCKzp8GeB9u4KTkW6sh4YGbCL02h6Fm/Y7lZI/hQurApw0J/fjxi
         K0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=s8c0NicUYEcrV4Ty9VZzFaPkBNNf0fYBSQj9DkmA98E=;
        b=sZ37IkrFsnK+LXcRZXY9hBCKeHSvD1os3TcmKTQ6gmPC+k7uOKKmPzaSvgfMMLcRLG
         2NyKXJULUfjZw48HARpZqVQa4tPaXnvCSKyBCr34RxrTzewQkne4ROjVlWPaZHX44jBN
         f06zZtGrYubjfghdV+P8Tf7VBAOQVOqXThUV4AwI7fdtscn2Nze/fBbu0ZTuzZZT10st
         Kl86nW2vQru/iv3aPsl4LntzUBp8yImA6yoxZEmVOcCvaT6JFztMJsxFbeJo//AWpANt
         P/tJqhpRDg0G4HQaahkwK7LjNQhyrFK+oUYjbbAKXiTRZOF3jxU/tLlh3Yd35x/k5flr
         L1Zw==
X-Gm-Message-State: AOAM531ErynIETWbMSzV7vt3MkvGM4LzIpsk8licTxpCs+WjPIbXIJHz
        m3HTddtnTeoGPxFrgbNGYQjSxw==
X-Google-Smtp-Source: ABdhPJxWOYMIelVOrkVm+X9MwIj1na0ucqe+KIhmU3hVCqPnyAapm42ozK38OWwD9ut+jp9fUHfsmg==
X-Received: by 2002:a1c:1982:: with SMTP id 124mr4878387wmz.148.1619029156466;
        Wed, 21 Apr 2021 11:19:16 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ec4b:6d50:c93f:f2c4:62f1:b1e8? ([2a01:e34:ec4b:6d50:c93f:f2c4:62f1:b1e8])
        by smtp.gmail.com with ESMTPSA id q5sm3096569wmj.20.2021.04.21.11.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 11:19:16 -0700 (PDT)
Message-ID: <59fe8024e86ea318e81e26ef68d66f279b19496c.camel@freebox.fr>
Subject: Re: [Linux-cifsd-devel] ksmbd testing progress - buildbot run passed
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net
Date:   Wed, 21 Apr 2021 20:19:15 +0200
In-Reply-To: <CAH2r5msA3cdaRuvxWzEtKxS5TfHhq6zQofL-zrss3x9mgp4=bA@mail.gmail.com>
References: <CAH2r5mse7yH8VxL4x3bRz1qe2K1p69mo6ApMZzQH_v8ZLpy6kA@mail.gmail.com>
         <1157a5af41b38f8826a08e9684ea2b124a0cc21f.camel@freebox.fr>
         <CAH2r5msA3cdaRuvxWzEtKxS5TfHhq6zQofL-zrss3x9mgp4=bA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 2021-04-21 at 12:55 -0500, Steve French wrote:
> On Wed, Apr 21, 2021 at 12:42 PM Marios Makassikis
> <mmakassikis@freebox.fr> wrote:
> > On Wed, 2021-04-21 at 12:18 -0500, Steve French wrote:
> > > Current Linux client (minus the deferred close patches) to
> > > current
> > > ksmbd on 5.12-rc8 as a test target passed all tests:
> > > 
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/32
> > > 
> > 
> > It doesn't look like any test was actually run though.
> 
> The run times look plausible.  Let me know if you see anything
> suspicious.  I can ssh in to make sure - but probably fine.  I only
> typically worry about tests that take less than 3 or 4 seconds (to
> doublecheck that they aren't skipped)
> 
> > I looked at some of the tests output and they all had umount
> > errors:
> > 
> >   umount: /mnt/test: not mounted.
> >   umount: /mnt/test: not mounted.
> 
> That is normal, the tests unmount at the end of the previous one
> (unless it times out) and tries to unmount again before the next one
> starts.
> 
> > The warmup smb3 generic/001 hints at cifs.ko not being loaded:
> > 
> > rmmod: ERROR: Module cifs is not currently loaded
> > mount error(113): could not connect to 192.168.122.13Unable to find
> > suitable address.
> 
> That was because the test client VM had some out of memory issues and
> so I shut down the windows server test target
> (which is not relevant for these tests)

Right, thanks for the explanations. For a second there I thought this
was a case of 'the test failed successfully' :-).

Marios

