Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD21C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 12:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D68CF218D8
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 12:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbfCUMZK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 08:25:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42846 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfCUMZJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Mar 2019 08:25:09 -0400
Received: from mail-oi1-f200.google.com ([209.85.167.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <andreas.hasenack@canonical.com>)
        id 1h6wkt-00036B-Se
        for linux-cifs@vger.kernel.org; Thu, 21 Mar 2019 12:25:08 +0000
Received: by mail-oi1-f200.google.com with SMTP id 1so2419155oii.1
        for <linux-cifs@vger.kernel.org>; Thu, 21 Mar 2019 05:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iTVWsDSv3Sq7B1q2CnxjYRAXW0NUSe927Wv2Smi6lXs=;
        b=prgDj1oaVbYoUEqbs69xFYoYZfxQzJsyZ3sqUbqv327VzKrgHycT0Z1E80kOpwydrQ
         44v7eJcRoan3Ci56LYOCynIzCpF5IePU72PjVtfaT6OcZ+MYuGWlI1fwp77tLJxQX2NV
         ahwmiAthe5vn/Atz3goJuKy6PUZdXbvVbrfCWb2fwrWJGW9DhoCOCR2SviUrsNHTIdVP
         NXqUfiFEa2Pu9hY81sVq3nW6KrNtJJgwF6pFLL54PdiMcicaCAJpvjoHxfTX+p+1M7Ee
         D4+vlteRhzFm/p3kmCGi+zB9L2R7fcB7gNDMfHyj0yJlkFw8bdfh2kufm811Hg9mEFi5
         3OAA==
X-Gm-Message-State: APjAAAW+cG4K2hHRnFmzrpoBz4ef8qDio1QZrUU9/wC/DAFAK9jk8wze
        UgvNFkOvfG62O38DJX62TPe+PqEGxcxPT7h7NiJW7KtMwOeHomQgs05PsCLsnY5nymMlz672MMf
        oIBUc0eJs9vAWjOVFwubYFGU9uZtJUMfJHxP9TxE9phVRC8i4HKCAsjk=
X-Received: by 2002:a9d:3635:: with SMTP id w50mr2069445otb.301.1553171106870;
        Thu, 21 Mar 2019 05:25:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxvvnRRFydYenXLppf35zGLTaXFeZrwm5cwIjcEkeUqCuPnyHfdyDBcC42bt0tKHGtXSPqBgj9FJuf4+9IkeKA=
X-Received: by 2002:a9d:3635:: with SMTP id w50mr2069435otb.301.1553171106648;
 Thu, 21 Mar 2019 05:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
 <CAH2r5mvm+pFsaGU1dQrkLJQ0O6ggkOff0yYLe6VV9m4RgpyfUA@mail.gmail.com>
In-Reply-To: <CAH2r5mvm+pFsaGU1dQrkLJQ0O6ggkOff0yYLe6VV9m4RgpyfUA@mail.gmail.com>
From:   Andreas Hasenack <andreas@canonical.com>
Date:   Thu, 21 Mar 2019 09:24:55 -0300
Message-ID: <CANYNYEHAS7cKF5wUEu673xaBZeY73C+z+kThahHzsiC+d8barg@mail.gmail.com>
Subject: Re: "Bad SMB2 signature for message" with kernel 5.0.0, works with 4.19.0
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Steve,

On Wed, Mar 20, 2019 at 10:44 PM Steve French <smfrench@gmail.com> wrote:
>
> Looks like you have "server signing = mandatory" in
> /etc/samba/smb.conf on the server.  Is that true?  That (in theory)
> should not work with guest according to the protocol specification but
> I am comparing with 4.19 behavior to see what changed (maybe we
> ignored 'sign' if guest?)

I have the defaults for samba 4.10:
root@ubuntu:~# testparm -sv|grep signing
Load smb config files from /etc/samba/smb.conf
Loaded services file OK.
Server role: ROLE_STANDALONE

client ipc signing = default
client signing = default
server signing = default

According to the manpage[1], "server signing = default" means:
"""
           By default, and when smb signing is set to default, smb
signing is required when server role is active directory domain
controller and disabled otherwise.
"""

So it should be disabled in this case.


1. https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html#idm8588
