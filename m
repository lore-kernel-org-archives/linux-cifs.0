Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379BFC07E94
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 15:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B17E613EA
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 15:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhFDPMp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 11:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhFDPMp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Jun 2021 11:12:45 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E4FC061767
        for <linux-cifs@vger.kernel.org>; Fri,  4 Jun 2021 08:10:42 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id r198so11257656lff.11
        for <linux-cifs@vger.kernel.org>; Fri, 04 Jun 2021 08:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YvFHzrQ0gqR4dxysEwWgsptFY7qWjmG0b8OVAeTVLSk=;
        b=QbZdVM4wv++MWYcaQfi7j63zsHQ47QTjhm5YE3JqJzUC8I7ar1H89srmDHSh/XEkH5
         Pucvji9DqatRWq8b6uF7CQYGqEIK81rtW7G29H8gJCj7Yruj77LEsoXQpbbwAV0d/dIj
         XzZIRHtDk2Um8WZOB8igqx3FgeOLAm9aBEg7WYFzSX0m7QkOP7JEjU5y8Y4dyhnphCq2
         qKJW+kJG8Vzq/TlsEqdPXCCct90GavC/24UBiR+9O1FxN8M/cUq0gjl6nIX+lQadNvsN
         Xi4eQNKTwZ4SBp/Pl7hgR4ec/zl6tgU5wmHyfCPx5oLdZUU0+2tjXHnBjY4t8jKwVA2u
         siJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YvFHzrQ0gqR4dxysEwWgsptFY7qWjmG0b8OVAeTVLSk=;
        b=h++P3sw4OUmZVV+01D1xnNqNG4X1Qv4YJt4+151aIuhIl8NLxZP9060RcWYre5/hxv
         D1gPM8pRluK73ZWOKQAtde9ncEjNLCU1BlLaBzBvy4Y0Naq1irnlf3wFNNAT5ZTciny+
         SfUpsv4a6g/vWASbSCCIgRCY7yvTGr7JxRLyvfNoejrUwXePOwY9gNdGL3DgFuRw8xL1
         xnuTTp9w3ZLChP/otjdYVafgKj8TReStNITya6MbHFuK1YhVsauwKCN3Wmnd2t1qOBrC
         9KZKuKVEaNpFRtWgiHKutUCGSJf5xT/Q1jUlKKJjwCN8yb5h9eQ7eem404Wk8zK/133m
         y9aA==
X-Gm-Message-State: AOAM530Wz/xTkKfYI8SyZTnx+g/BchCipNVdg9UFHIOX168jo1qWN3vq
        hFceXKtcBQZ6GCAZJ0rncAAvUkWtBV0XPBpfOe4=
X-Google-Smtp-Source: ABdhPJwEg3rV74+ktQOksFa9LEBkAYm+/msqx8LCESEdXwHsMFEApN49f3kCy4P/mdPhTPMbGKNeRAYvQK5JZe84CjA=
X-Received: by 2002:a05:6512:33d0:: with SMTP id d16mr3223323lfg.184.1622819438502;
 Fri, 04 Jun 2021 08:10:38 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
 <875yywp64t.fsf@cjr.nz> <CANT5p=o6Oq-27Xj4Z6-XzXKL45Dwg7JjGw2HA9jv5+YFQKpHUg@mail.gmail.com>
In-Reply-To: <CANT5p=o6Oq-27Xj4Z6-XzXKL45Dwg7JjGw2HA9jv5+YFQKpHUg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 4 Jun 2021 10:10:27 -0500
Message-ID: <CAH2r5mvBRknNBLbi_x41Zd_52Q502jELLuPVyLj2qsrN51-2aQ@mail.gmail.com>
Subject: Re: Multichannel patches
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged pending review and testing (after minor updates to
formatting in one patch)

buildbot run in progress on these 5 (and also includes Aurelien's small patch)

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/665

On Fri, Jun 4, 2021 at 4:13 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Thanks for the reviews.
>
> While rebasing older changes, I missed a single line during the
> channel add code, which had caused a regression.
> Fixed it and merged with the correct patch here:
> https://github.com/sprasad-microsoft/smb-kernel-client/pull/5
>
> I've also integrated Aurelien's comments into these patches.
> Also, I've a couple of minor patches here to fix fscache warnings for
> multichannel and to integrate new changes into DebugData.
> @Steve French Please use these new patches.
>
> @Paulo Alcantara That would be great if you can help testing my
> changes. Please test with these new changes.
> > The super is only used for providing cifs_sb_info::origin_fullpath as key to find the corresponding failover targets in referral cache.
> I'm wondering what would happen if there are multiple tcons to the
> same origin_fullpath (possibly in different sessions)?
> Also, doesn't failover targets apply to each channel under a session?
> Shouldn't we switch targets on reconnect of secondary channels too?
>
> On Wed, Jun 2, 2021 at 10:15 PM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> >
> > > P.S. There is a logic in cifs_reconnect to switch between the targets
> > > for the server. I don't think these changes will break the DFS
> > > scenario. The code will likely take effect only for when the primary
> > > channel reconnects (as DFS server entries are cached with super block
> > > as the key). Perhaps more changes will be needed there to also switch
> > > between the targets for individual channels (maybe use superblock +
> > > channel num as the key for caching entries?). Folks with better
> > > knowledge than me with this code may want to check on this?
> >
> > I don't think your changes would break it as well.  The super is only
> > used for providing cifs_sb_info::origin_fullpath as key to find the
> > corresponding failover targets in referral cache.
> >
> > I can help you testing your changes with some DFS+multichannel failover
> > scenarios.
>
>
>
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
