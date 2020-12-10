Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94473C4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 17:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EF39207A2
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 17:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgLJRCD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Dec 2020 12:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390969AbgLJRBz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Dec 2020 12:01:55 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0531C0613D6
        for <linux-cifs@vger.kernel.org>; Thu, 10 Dec 2020 09:01:14 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id o17so6334546lfg.4
        for <linux-cifs@vger.kernel.org>; Thu, 10 Dec 2020 09:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/SDn7XSD//JMgmHzQGwHDDf0+m5eCtVCF2/1KosZrok=;
        b=UwEtZHg05RJXsnUROKqX7TTNRric9/pJvT/s/WM6xC8SOzskYFNKnvvpSs+9hggq6Y
         yt3zCtTGE7toUIvaCEKXq2pz4oK21susOZaU10PJlxN3FoK1TMzJfS/oveOVdSA12cE4
         KnGql4Eg4Gfsv380QRwnYt1hXrbuZq66cBD61vzr3E48aD4UtqeP6Te9tL7q1Ek7lWDX
         fMXtGyt8RhzpnxasncWnRbtbxhxHBuAOTns2u2JrKm4IrctN6typraiVimFTDLjcRgox
         Ifus+HJ9t0hMwbGEbsttfBsUAg7Tc7p6pqOv1dsdv6tbovyRHwA31uj6GWlelUiaac1o
         XYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/SDn7XSD//JMgmHzQGwHDDf0+m5eCtVCF2/1KosZrok=;
        b=PGgQjkT6FUyvN1BUKVrATjpfmPf3mZVe3TwAPp7mDoUg9oGupcGBU8+o9uh8isDLH+
         YzBQyNqCqDnUIEVHXkLI/7YS8Rx6OaEczjTFB3sUzGpweGJr4YRoDi/g1CoHge/6x8QH
         n1daVSgAUUphgVTxQuOA8w+q4bCw3D6PicQJkieJvm2pbhBn8A60cywsSbOjBbckhkIh
         +pbUCQKy4fyMX/VISW+/smFjug374/NThSMFSuYYncA6MJbZ9uYrfVv223AOs4XgCuCk
         vnkWrJEghQte/xpN9jtWAR4WafCiVV/WtgPGoW8W1B6YWf8L93/R/G+Vet6A0E1r3Zdk
         CBrA==
X-Gm-Message-State: AOAM532/yqOesFGLsbgt3ZsklIyV+QEI24peRV2e9kvjjhCDsNBz9WjE
        Gt2/ylUEALITgNYmTqAstmakRberg8p8fagZ3hnfly+HBIA=
X-Google-Smtp-Source: ABdhPJxhfQZ2p7eNlIhaeJwm3vmR2Mc98PL2l2CJq9WZ51aotjlvLaPNWb+zDs9BnC4zTyKVBv2vAHyGGS4g9vyi5XM=
X-Received: by 2002:a19:6b19:: with SMTP id d25mr3231778lfa.282.1607619673224;
 Thu, 10 Dec 2020 09:01:13 -0800 (PST)
MIME-Version: 1.0
References: <BYAPR16MB26159527465394F378EB16FDE2CC0@BYAPR16MB2615.namprd16.prod.outlook.com>
In-Reply-To: <BYAPR16MB26159527465394F378EB16FDE2CC0@BYAPR16MB2615.namprd16.prod.outlook.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 10 Dec 2020 11:01:01 -0600
Message-ID: <CAH2r5mtZo68cjRFOXPxET2D2yr+J8xbAoNto0zx06b1uRwxX4g@mail.gmail.com>
Subject: Re: Merge commits to v4.19 from 4.20 & 5.6 for cifs Backup intent
 flag fixes
To:     Vidhesh Ramesh <vidhesh.ramesh@komprise.com>
Cc:     Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Nahush Bhanage <nahush.bhanage@komprise.com>,
        Chris Dearden <chris.dearden@komprise.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

You may want to contact the guys that package your custom distro.
Since some of those patches are marked for stable they would be
automatically backported but I don't know who provides your custom
kernel.   AFAIK these are likely to be backported already by Redhat so
if you are using CentOS 8.2 or RHEL8.2 there is a good chance that
these are already in.

On Wed, Dec 9, 2020 at 2:18 PM Vidhesh Ramesh
<vidhesh.ramesh@komprise.com> wrote:
>
> Hi Steve,
>
> We mount cifs shares on our centos machines running kernel v4.19 using ba=
ckupoperator privileges using backupid, however we do not see that the back=
up intent is used for all calls. We did find fixes for them in 4.20 & 5.6 b=
ut not in 4.19. Would it be able to merge these commits to 4.19 as well ?
>
> Here are the commits of interest.
> 1. https://github.com/torvalds/linux/commit/5e19697b56a64004e2d0ff1bb952e=
a05493c088f - v4.19.rc1
> 2. https://github.com/torvalds/linux/commit/61351d6d54e651ec4098445afa5dd=
c2092c4741a - v4.20.rc1
> 3. https://github.com/torvalds/linux/commit/4d5bdf28690a304e089ce750efc8b=
7dd718945c7 - v4.20.rc1
> 4. https://github.com/torvalds/linux/commit/0f060936e490c6279dfe773d75d52=
6d3d3d77111 - v5.6-rc1
>
> Vidhesh Ramesh



--=20
Thanks,

Steve
