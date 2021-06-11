Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFF5C48BD1
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Jun 2021 23:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33BCD61019
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Jun 2021 23:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhFKXwu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Jun 2021 19:52:50 -0400
Received: from mail-yb1-f171.google.com ([209.85.219.171]:44924 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhFKXwt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Jun 2021 19:52:49 -0400
Received: by mail-yb1-f171.google.com with SMTP id p184so6588434yba.11
        for <linux-cifs@vger.kernel.org>; Fri, 11 Jun 2021 16:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2xGLX9vDoLQPHdNZSCbb1B8cgposHtKKT8IIEId9+7Y=;
        b=Wk1YZDUQKg9Hw1rPkfogb6z6QfVf0+7BfluGivXuyJKJ48I2fGAoj2JK9GB0y7tTF1
         tJizuDLF9XMgK1nQ0lLGPFcLUYbX/acT85ZUazLE5J4rIYBAA5mjqdT/sco7pzte3MDB
         piVEzarjT3bbIwQI7AD3C7NvmkISaBP8tisG7FawviCSAMKw3V4OtpSRo7ZPyLj7TLIZ
         c8rjp8ZvqbpmfmVOlFw1GnGiip60UNMk0X8/lyI2JTlvKQIr7MP0Q8rXliEr7GVV8mHx
         AlA0RghsAbT9i0xgk2tkRPoHpMfmh80XfWp3HAqXBLH77tDAhhABEVSbE0OLao4EzsIq
         mU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2xGLX9vDoLQPHdNZSCbb1B8cgposHtKKT8IIEId9+7Y=;
        b=kTUoPtzjU4dsydvTQnh8uHu22bwrW/izmerxG/oXq2JSFAYmmllAOCZ9NYSy2ziRTe
         UaudDtgidPtYddvsHEFiWgJyjAw1uo5uOsyxWpB2JlyR9Z4yUqF7idbICuytrrwQypVu
         0D2dx3iNNW+3bU9wuDbGQkF6CbpPzMWgoh2h0pcfg6UmQo+2AvUVcMPQIJNQNEi1mX08
         xpuYCZbUGc9h2DFp/vijJ62rtBKQR59epL1exqHpidj8tUBi71sO20LPEtItWf8YObL2
         EfAN245qZRkITbHRML4Ib3fsqr2bRT94mmbj7j73xrJbgVb92jG06NTyswKjAVGZ2lGh
         iqsg==
X-Gm-Message-State: AOAM5333Loyem8xNX2WeMmvfyVJdOmb+uG1t/5R3qTZ+QELTlj8wGhx8
        c5wmT7q3T8q5MO6SBbrlg3HkI4PecS0DTBe+rl0vYvkB/rY=
X-Google-Smtp-Source: ABdhPJw543sOEaPzTs43H83/ZpJiPRxJ0F/0DljiPKF/GOUZgFKcQpg32oVTxqgjo+5NEyhZHlo3nIIcCEZnu7Ef66A=
X-Received: by 2002:a25:42d4:: with SMTP id p203mr8941809yba.97.1623455377324;
 Fri, 11 Jun 2021 16:49:37 -0700 (PDT)
MIME-Version: 1.0
From:   Bruno Bigras <bigras.bruno@gmail.com>
Date:   Fri, 11 Jun 2021 23:49:26 +0000
Message-ID: <CAJwt-Jns5=XneYgidODs+SjJmWvoq=BhwbvRA0Z4SDKLgdZs3Q@mail.gmail.com>
Subject: Is it possible to mount a cifs share with kerberos using the machine
 account (with active directory)
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When a Linux machine joins an Active Directory's domain, a computer
account is created.

A network share can be configured to give rights to the computer account.

Can I use that account to mount the cifs share with the computer
account (with the keytab file)?

Almost every example on the internet is about using a user account or
using multiuser (which also uses a user account).

Thanks,

Bruno
