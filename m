Return-Path: <SRS0=ZNV/=D4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4D9C388CE
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 04:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3BCB221FC
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 04:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNbkJ5vE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440129AbgJUETf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Oct 2020 00:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411917AbgJUETe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Oct 2020 00:19:34 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12A9C0613CE
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 21:19:34 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id n6so1275069ioc.12
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 21:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fGwWBrTXCBU14TfF21sseLCDuwxYh2cnRrr5ltOxie0=;
        b=KNbkJ5vEFGUh3sdQdvHb/fwvzPU+ARfLhaZ+nkAAbekhwOW4uQa7FjiqdTlxMpzG+u
         RDGbLRdkpAsSH9MB1Jjq6l5D/EYERM4H/q4yjCQZGmknWeT3Vm5Ym8bqf3Bvr/Zm9XFN
         2l6py7hEYIOXw+XZWlFcExiSsV7qRGgysK3EtW2F2DsTFIZQVnaa7Caz6N0jugFh+zey
         ALxWbSlSD0+HSpGI6KwjAdmOvnL0C9tPXyjidcdHWYfdH8MSEeaHDL8ynnp5fD54VRJn
         o6HBTXOexK3oTpbko5wZvOldG+SFbaqQaqikSV5HcuBMsP29Zsvuxy7oI2l8Sn3F7SY7
         kvdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fGwWBrTXCBU14TfF21sseLCDuwxYh2cnRrr5ltOxie0=;
        b=lITkGnqgAn7AgFFQLrQdnvN4LSbWmLsOISnAmBFnY6sujHiBX9ko9fItjkLmIxouXQ
         ZaKTUNsminLC+4k5/doCy1uxOMxV2TaJEmKmaAysLyBYDcmFPEOVmVx+0yt9rvDlY4yD
         9Pxpv++N+rSPYQafoQCksCpO9jBse0XZRwUdoUOvCuOKuIdtgtDDdGYEk5pMhtT1jn8B
         VL2X4aHf/hRiUqf9YrOzjmUjF/c5YoPjgXbYRkeIq/wDpNTvEggTlClBEf45Wtx7eUsi
         HEWwyOq35e0vumUVtyI3LECNZNvLyNscPC45MWCTcFJR1LjcpnAWvKVbHt77hwr3HyrI
         akKg==
X-Gm-Message-State: AOAM531HGcd699Ag8lM1O+xwtIbfVZn01mnTyKDP0Gekez+u30YgF42N
        qx1JHxL8x+VPOB/Wh4iRvzIfmcDciSnJxZY/gpw=
X-Google-Smtp-Source: ABdhPJzNevxHeDYq4DZuE88rYNR0RKBQmcrWJLy14OhzUCpVU+VfuodXibXGW4EJLFjLmNeEMcL+PW9R0CgRNTBDUlg=
X-Received: by 2002:a5d:904d:: with SMTP id v13mr1205318ioq.116.1603253974166;
 Tue, 20 Oct 2020 21:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu2s3Fu+_mWTiXFp+JYTAWZZrPCDyDNtWAhit2DjB890g@mail.gmail.com>
In-Reply-To: <CAH2r5mu2s3Fu+_mWTiXFp+JYTAWZZrPCDyDNtWAhit2DjB890g@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 21 Oct 2020 14:19:22 +1000
Message-ID: <CAN05THT4zcQaB8HHEsYi_nA9=VQMuqd53h0=BTSi+FtxYMuiMA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] fix stat when special device file and mounted with modefromsid
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Receiver-by me.

Should we set up a test for this in the buildbot?

On Wed, Oct 21, 2020 at 2:05 PM Steve French via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> When mounting with modefromsid mount option, it was possible to
> get the error on stat of a fifo or char or block device:
>         "cannot stat <filename>: Operation not supported"
>
> Special devices can be stored as reparse points by some servers
> (e.g. Windows NFS server and when using the SMB3.1.1 POSIX
> Extensions) but when the modefromsid mount option is used
> the client attempts to get the ACL for the file which requires
> opening with OPEN_REPARSE_POINT create option.
>
>
>
> --
> Thanks,
>
> Steve
