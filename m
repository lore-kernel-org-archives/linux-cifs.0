Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0A6C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 05:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2617E2146E
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 05:03:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NtNmXG0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfCUFDa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 01:03:30 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44393 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfCUFDa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Mar 2019 01:03:30 -0400
Received: by mail-qt1-f195.google.com with SMTP id w5so106596qtb.11
        for <linux-cifs@vger.kernel.org>; Wed, 20 Mar 2019 22:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Od/qtTg8pmY86Z9NpvHf4HEglRaVvOMohnSEOKnMPUI=;
        b=NtNmXG0nYo0d6csmJetUIoOfzfJbKOreiQXg3HqHlTlPEf48DekYrwLpN9gUeXE6ut
         8oxMTQIAPuMvF3J5pvu3iig3MLDtif5vchtxOBWsVyAYhP9ZkfaIbN2edXh3aXZD+np7
         XXfdAk5JzKHuLMfOlUKSZe6LfuwNA95oysbC17NadLlhSaQCKSKzqtOpBH8Rgg3y8FO/
         cmIhC5/opJkt+CL2wt5IC2sYlBdcDYenuFAcLlJjKcYmADT8ERBEmUzlJZ/0iEptGRMu
         49Ct+tWTlZT7mEa/NifCxXf65hxI+cqV6I26WtMaCtHBAXAw0do5F6be3Ii2mRDQaKS8
         QPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Od/qtTg8pmY86Z9NpvHf4HEglRaVvOMohnSEOKnMPUI=;
        b=hXUfwHnapxoovFWbxQ4NScK8X5/c06n03xVwTERmtSb6CimX9q6crvdo86+EFCpI1z
         pDlT/yFRXemFEGMhCBSPz6y962/qDDnwUUtsBZPr9xhN++SW4XgnIt/u9iM9q3atCz/W
         LRE1H0pT2f7QoauJ7wD3NZPvTpI18qH7gZVBfSHBUOZe/SwlUXtoE7eF7Hds2gy1O6sB
         zYKtVB30yjrJfRrLrn3XAQOa/7P3FSWjR/jD3TongHWlcNWt717pbDntbzce96IJJ6mP
         VzuBFRmQK3GGxbfNDrYxd2jN4Jd8twseqOPh3mh/dzHOo8KR3epPxclbu+YZEvd8XU8m
         jzog==
X-Gm-Message-State: APjAAAW+G8YeWcmCVMtOD3kMRS6suX/Sr5rF2erYrgo1Hk3xePoL2QUA
        WSC5CQv6Cv7GZIO+Z/oee74PQl8NPYSog3Du0SA=
X-Google-Smtp-Source: APXvYqw385WTLYXXIiWC5CEtw6a3QgEd1fcMsDY5VAvnIncvPpeIHUiAcXm5ebqBItz0EK7DdFmNqm9mBYWUl3iCJLQ=
X-Received: by 2002:ac8:2c89:: with SMTP id 9mr1315360qtw.287.1553144609384;
 Wed, 20 Mar 2019 22:03:29 -0700 (PDT)
MIME-Version: 1.0
References: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
In-Reply-To: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 21 Mar 2019 15:03:18 +1000
Message-ID: <CAN05THQb3-p=XX=WpCxv1zfP4e3sBLMY54bg+n=wy9HQCOiJiw@mail.gmail.com>
Subject: Re: "Bad SMB2 signature for message" with kernel 5.0.0, works with 4.19.0
To:     Andreas Hasenack <andreas@canonical.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Andreas.
I have reproduced the issue and sent a patch to the list.
It should show up shortly with the title "cifs: allow guest mounts to
work for smb3.11"

Can you try that patch and verify that it fixes the issue?

Regards
Ronnie Sahlberg

On Thu, Mar 21, 2019 at 4:40 AM Andreas Hasenack <andreas@canonical.com> wrote:
>
> Hi,
>
> I can't mount a share as guest using SMB2 or higher when running the
> 5.0.0 kernel (ubuntu's 5.0.0-7.8 specifically). When I switch to a
> 4.19.x kernel (4.19.0-12-generic), then it works.
>
> This is the mount command and output:
> root@ubuntu:~# mount //localhost/pub /mnt -o guest
> mount error(13): Permission denied
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> The share is a simple one:
> [pub]
> path = /pub
> guest ok = yes
>
> The server logs this:
> [2019/03/20 18:24:46.245816,  0]
> ../../libcli/smb/smb2_signing.c:169(smb2_signing_check_pdu)
>   Bad SMB2 signature for message
> [2019/03/20 18:24:46.245860,  0] ../../lib/util/util.c:508(dump_data)
>   [0000] 2D 60 1F CA 49 06 92 B0   69 06 60 82 42 39 21 F8   -`..I... i.`.B9!.
> [2019/03/20 18:24:46.245894,  0] ../../lib/util/util.c:508(dump_data)
>   [0000] 75 F8 77 09 63 D5 4A 7B   9F 91 51 93 6D 12 6F 6F   u.w.c.J{ ..Q.m.oo
>
> Here is a dmesg output with cifs debugging enabled:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1821053/+attachment/5247960/+files/dmesg.txt
>
> That output was from a kernel running patch
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.0/cifs-do-not-skip-smb2-message-ids-on-send-failures.patch,
> just a quick attempt to see if that fixed it, but it didn't.
>
> mount.cifs is version 6.8
>
> Server is samba 4.10.0.
>
> Is this a known issue?
>
> Thanks!
