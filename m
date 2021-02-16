Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4E2C433DB
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 20:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D214064EB6
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 20:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhBPUTn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Feb 2021 15:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhBPUTm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Feb 2021 15:19:42 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DBDC06174A
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 12:19:01 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id v6so13443568ljh.9
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 12:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8awngu1u7PCZ3tCsWPY6jd4zjlMm9KDphD+j8yN1oGk=;
        b=CNSQ6izIAD8uickYOktQyLxTRJWwweeZ/fBe+oPuipfo/cq961Sw4Ii5UeWGvDpRyD
         jFamsjFSZC7j4eVFvxnPF90/cEtIqOCMQu4CvK5m6ISOTsR0wqcLWZZkOL1reu0gcJ7B
         yz6xA2RBvLo/46Vuwd/ZtrH2m95Mp80Mobm+kDGrZ2kdoBfsSDyPng34OFBNnz34UgGU
         x5A/9NNa9fIjrSpqLAofK1Uzsuf6IUpt5NX1D3OQrMYgKSlMMsMCz8mS7A6wjbANcFsu
         SiAk5xI3zCNIW9jDHkWxKflhSqVa6UM/iiS5yp0RMvpLummrb7C0Os7gpHnNipI9pWbq
         VkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8awngu1u7PCZ3tCsWPY6jd4zjlMm9KDphD+j8yN1oGk=;
        b=pud8RU1ie3EaCg91Amdqb3olLw8ovMCtmSuPos5AQWixxVwVnLiKZuoGyjMkefz051
         AnJs99fH355Icv/YQu5v2N/DnIAAuxcieiN50O+04P0sMYw1wmXkMjMHlnmsjhF8lVpJ
         cEq1OFPVGuSjFQdcH2ieHJVwwbNxjTt8sXsev/ljujq4g2ch7dOB68cC3sTddtIEZ1Sk
         3zFKfvY8I5UtkUvAIRp60lSJa69NN5//3LILrouIlAHD3+Xfbt80rpH4X4Hnfc/ix62W
         4BREV8iii4dDgujSzMKRgloBShFeGGZHP6arCS41PVyCnyD5oYGgP4NMpLeSUpt4sqTL
         k6oA==
X-Gm-Message-State: AOAM5312rUR9EPCq2alulJnbS0+DoHw3UHQvMOUdCUtbIYwc2ZIWwZyD
        eCKmkT6wQ/Nb2LQxCqkc2tG0BCVpIA0gxmcv/PA=
X-Google-Smtp-Source: ABdhPJyzF5hFuGfRt9ACsbftWjF7NVzZ7+DapQVcFvH7mjIpzJy6XjInEJ7Tz6av4zG+7oId56xMM5V8QAXzGq2pDm0=
X-Received: by 2002:a05:651c:548:: with SMTP id q8mr13208609ljp.256.1613506740022;
 Tue, 16 Feb 2021 12:19:00 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com> <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
 <87a6sjopsc.fsf@suse.com> <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
 <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
 <87lfbyn647.fsf@suse.com> <CANT5p=qJjeVk1HDhvaiAQSYH3mj-rNBNA-j2TAUnoqQVTOQ_Ww@mail.gmail.com>
 <875z2yn0lx.fsf@suse.com> <CAKywueRoFL17DiMzmorZcd=OJvDY_8+P8WxGqKDx-tdnJrr_HQ@mail.gmail.com>
In-Reply-To: <CAKywueRoFL17DiMzmorZcd=OJvDY_8+P8WxGqKDx-tdnJrr_HQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Feb 2021 14:18:49 -0600
Message-ID: <CAH2r5mvDkOLAo2YQbEDGRERt2Z5wdnqHzfZaQ6+kdftkc8-E-A@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by conn_id.
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Feb 11, 2021 at 11:12 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> Hi Shyam,
>
> The output looks very informative! I have one comment:
>
> Servers:
> 1) ConnectionId: 0x1
> Number of credits: 326 Dialect 0x311
> TCP status: 1 Instance: 1
> Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
> In Send: 0 In MaxReq Wait: 0
>
> Sessions:
> 1) Name: 10.229.158.38 Uses: 1 Capability: 0x300077 Session Status: 1
>                      ^^^^
> Isn't this name (or hostname) a property of the connection? I would
> expect an IP or a hostname to be printed in the connection settings
> above.

The "Name:" (actually the IPv4 or IPv6 address, not the name) is from
ses->serverName not from the connection (tcp socket).  We should
probably change from "Name" to "Address" or equivalent in
/proc/fs/cifs/DebugData

See fs/cifs/connect.c lines 1841 and 1843

The "name" field could be added to the /proc/fs/cifs/DebugData output
for the TCP_Server_Info struct by e.g. dumping the "hostname" and/or
"server_RFC1001_name" fields.


-- 
Thanks,

Steve
