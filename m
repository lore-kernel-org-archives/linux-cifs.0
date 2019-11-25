Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E7CC432C0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 15:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B36FD2068F
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 15:35:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KBNSGdkD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfKYPfX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 10:35:23 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40773 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbfKYPfX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Nov 2019 10:35:23 -0500
Received: by mail-io1-f67.google.com with SMTP id b26so14794780ion.7
        for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2019 07:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ePFtl5y8ytuv9PKi71sdnTYGr2uV+MVGEI+M7VfqqzY=;
        b=KBNSGdkDqZHIkTNJr3LPv2foEkpyRkHNyHFt4VmARu4mYEYYpoltwNTnRtd5hSDt6J
         SQbU61WMSaHgezchkemMSgYKxEXV3/Ccl5ibgMRz1ZKmP286uDPykKntKFYrCMVZA8Pp
         U2MQUN0VNcW7TduRAJF5hbeFZa4ku6LPukiotL0uedXgGYUwn2XsJqlc9YQXdYk1ofcb
         ZGzA/8FWVH8OdgEMWXFR5yqMtT1aDCxrtiDrZt7JCPdMePaQkTWyNyGloONrHn/8NBVd
         IiEJaU4NzqwKcRd2uPSEHNql9Gzw8fVw2hfpkBnYOGL7mqm2dvMnweJ8d7lSw9NM6FeV
         /6MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ePFtl5y8ytuv9PKi71sdnTYGr2uV+MVGEI+M7VfqqzY=;
        b=l33afNstatMGUbMVDmyUQYvsJBZgilV+1YEL0rBVh1cvTSZaCnjK82XU3kud8P2yJn
         aBcTb/Kj0+xEHqmTN3gEp01/p3g5Q5Yw/yZtWdOMCiqr0KBhy0eaQ3pi0qdG6AoRJ/mz
         eafJ8dJUp2ZCunuVTGsjq6ZTicuYGTd+wns6uGF1EmU4RG8QzqjB6QWS0ikMv0omqoKe
         5jQiVTwqiq0vUt5yEcZ0hYBLvzEb9pUjopNbHD4OV202+BHjlRlRJUb8Fn0VvCzSgfpD
         nHJJILQAB/wmce5pzdU6s+Ha7NS/EjKzClKYwyIaMdSZXCxqDaCCk/KUSxx3/aiZRKz5
         wWNQ==
X-Gm-Message-State: APjAAAXPpdZoFQwrgkdNs/CCLQ8T3fljizOCBqYXc4InIqOVK0FNOLTM
        NQdMGwUCFPx7IncCydDcYB/UPytflyLlwimjWSkxPQ==
X-Google-Smtp-Source: APXvYqxtF0D6Z6dU8kAEKjQD9Rj4HxGOw3sOfbq6+QLtHSgPn2arO7/GiTN7VEoWIQC1N/MVmaLcpJePbx1aqmeY320=
X-Received: by 2002:a6b:dd16:: with SMTP id f22mr25909289ioc.272.1574696120831;
 Mon, 25 Nov 2019 07:35:20 -0800 (PST)
MIME-Version: 1.0
References: <20191122153057.6608-1-pc@cjr.nz> <20191122153057.6608-4-pc@cjr.nz>
 <87fticw5bx.fsf@suse.com>
In-Reply-To: <87fticw5bx.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Nov 2019 09:35:10 -0600
Message-ID: <CAH2r5mthG19J-vkMXDeNKcw_AdeWTHxKphTLzdacbO_GYSeFog@mail.gmail.com>
Subject: Re: [PATCH 3/7] cifs: Fix potential softlockups while refreshing DFS cache
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Cc:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tags added - tentatively merged into cifs-2.6.git for-next pending
testing (buildbot)

On Mon, Nov 25, 2019 at 5:41 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> "Paulo Alcantara (SUSE)" <pc@cjr.nz> writes:
> > We used to skip reconnects on all SMB2_IOCTL commands due to SMB3+
> > FSCTL_VALIDATE_NEGOTIATE_INFO - which made sense since we're still
> > establishing a SMB session.
> >
> > However, when refresh_cache_worker() calls smb2_get_dfs_refer() and
> > we're under reconnect, SMB2_ioctl() will not be able to get a proper
> > status error (e.g. -EHOSTDOWN in case we failed to reconnect) but an
> > -EAGAIN from cifs_send_recv() thus looping forever in
> > refresh_cache_worker().
>
>
> I think we can add a Fixes tag:
>
> Fixes: e99c63e4d86d ("SMB3: Fix deadlock in validate negotiate hits recon=
nect")
>
> Otherwise looks good.
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
Thanks,

Steve
