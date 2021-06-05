Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA67C47082
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 14:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F42613AA
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 14:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhFEOLM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 5 Jun 2021 10:11:12 -0400
Received: from mail-yb1-f170.google.com ([209.85.219.170]:40678 "EHLO
        mail-yb1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFEOLL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 5 Jun 2021 10:11:11 -0400
Received: by mail-yb1-f170.google.com with SMTP id e10so17878268ybb.7
        for <linux-cifs@vger.kernel.org>; Sat, 05 Jun 2021 07:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=90eZYb42UXWdsVekDB+T7JUj+xTEGjRegCPYx29VauM=;
        b=EBtjHgPpOAxrInekvSkd0r4vYy9UoLKcaHclDeqFZEiIiQlZET5tcvdj+MMSLipXEI
         wopqUye1v29wHy7EblYAwEZDTrWdaKWA09DNz4x1XlegBJW8zedmEdYh1yAYfR7bhrc6
         1WUINHAeXJbp9y3y+G97FLCh+y57Jqzz5P8yG1yIrFgpDA8pSLAAd5otccbRr5qkQ7NU
         wj1ddgiE5nqxwJJS9xUcAw+Z8YBsh3Lw/qnfGACLjFk9KFisfMJsRHT2i3i1k2ZsIwos
         izNGQZMHSaV/w3CaviYZubGadnE3E/MLE6Bkt6JLfzSKMgBpi4670gF7sirG1d6x9opi
         1IbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=90eZYb42UXWdsVekDB+T7JUj+xTEGjRegCPYx29VauM=;
        b=m023qyRPUR4zL0AtU1SwPVxtTX6/ZNlHh84F0/szHquOQa0pDJIqOGhmPPO6P1fRyF
         emWWkex4AnRmRdrPkCWk1d5u57TBoW0X8DG+c7iq/HvlMX6GVRpHRfDc4uKnnRLWFWLo
         j9Gl0P/QFOcAanDlG8jsITDY5RCt9R4bQjIQUtoETPyoTbVG3EaaIo2Y/0CGcW5ZDeVR
         jgmbYVD1ze9MU/5jCeMNox+vCO+ZPBhcSdy1wIwdOvPEievTEQEXOOijmJJpY7owFEOO
         ztRH3uL1ktxte5UHL1jYF5JQb4vgorL8aauYmBF/EUl1CvnihV7+cMMzXjWYlGry6211
         kwJA==
X-Gm-Message-State: AOAM532ITBIQeQCrJ9fjdNgYtR+YzoYdmyLPTjD1Rd8rx22mO9CHtjRd
        bBaHpaHY+hM/zKaEmS60swf2dAXV4iR+ZOIY6r0=
X-Google-Smtp-Source: ABdhPJxiwI2kpMNzbwo/Gi/t6+ARU58cX8+MpvDFUEVWx02mS+gTvMTaae0fYHDFDjWzBw17a9q3qcRERMF1g3ghibE=
X-Received: by 2002:a25:af04:: with SMTP id a4mr12478588ybh.131.1622902103683;
 Sat, 05 Jun 2021 07:08:23 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
 <875yywp64t.fsf@cjr.nz> <CANT5p=o6Oq-27Xj4Z6-XzXKL45Dwg7JjGw2HA9jv5+YFQKpHUg@mail.gmail.com>
 <87y2bpk5xu.fsf@cjr.nz>
In-Reply-To: <87y2bpk5xu.fsf@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 5 Jun 2021 19:38:12 +0530
Message-ID: <CANT5p=ro-sZfc8bPhh7COEp_KBHF6KNzbSV30WyRo2NHLneqAw@mail.gmail.com>
Subject: Re: Multichannel patches
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The buildbot testing once hit a deadlock when running with the above patches.
I found one possibility during cifs_reconnect, where a deadlock can occur.

I've fixed that and some warnings that kernel bots have identified in
the below two patches:
https://github.com/sprasad-microsoft/smb-kernel-client/pull/5/commits/f3e65f72b03b03bc4b301e8e04e9babb0e9582cf.patch
https://github.com/sprasad-microsoft/smb-kernel-client/pull/5/commits/7b3e867e994a7cbc88efe85c95167ae49d4b7a9d.patch

Regards,
Shyam

On Fri, Jun 4, 2021 at 8:55 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > @Paulo Alcantara That would be great if you can help testing my
> > changes. Please test with these new changes.
>
> OK.
>
> >> The super is only used for providing cifs_sb_info::origin_fullpath as key to find the corresponding failover targets in referral cache.
> > I'm wondering what would happen if there are multiple tcons to the
> > same origin_fullpath (possibly in different sessions)?
>
> That is certainly a problem, indeed.  I'm waiting for the DFS tests to
> finish and then send a series that contains a potential fix for that --
> e.g. not sharing TCP servers when mounting DFS shares.  We used to not
> share tcons with DFS mounts because they might contain different prefix
> paths but connected to same share, however that wasn't enough because
> multiple DFS mounts may connect to same target servers, although they
> might failover to completely different servers.
>
> > Also, doesn't failover targets apply to each channel under a session?
> > Shouldn't we switch targets on reconnect of secondary channels too?
>
> That's a interesting question.  I recall discussing this with Aurelien
> some time ago while running a few DFS + multichannel tests.
>
> So yes, I agree with you that when we successfully reconnect to failover
> target (primary channel), then we should also update all secondary
> channels with the new server's ip address and reconnect them.



-- 
Regards,
Shyam
