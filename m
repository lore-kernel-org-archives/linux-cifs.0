Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFA4C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 05:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 288D62083D
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 05:49:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbMslhX6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbfB1Ftr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 00:49:47 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33870 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1Ftr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Feb 2019 00:49:47 -0500
Received: by mail-pl1-f196.google.com with SMTP id d15so9203783plr.1;
        Wed, 27 Feb 2019 21:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QLb5BtAHtBejceR8+wPasoxwq+0zBA9K4Oc3oeTDWws=;
        b=fbMslhX6jVjQj+/cY28+spXJ7jlicyOtMNoIJiWMxGWUD3cjo/h74enkYFpwILAcBq
         twe7ak8rEHKXIPn1bNZzoEz5jAt74Ed/Q+Y+Wq6Mtbv40hBKLe0QBlZM0fywReGtoJ/l
         fY61w4C9uAeOowGDRdGhxm4zI+1NmwkJiROQaStorqA1++N16TlPpfYnosWOWCvMeEaD
         0SlsNPkr0yRJUC7XFYWcq2CqhSzY2Y58edBBKBdHT2yu+clsHGNY3hu0e09ArRY9gB36
         asdie3RJJLCqwbhYna0MR1E368SAiaU/SXfC1QUwuvFxcqcGy8gBcbgxjWAqAFtehs55
         c6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QLb5BtAHtBejceR8+wPasoxwq+0zBA9K4Oc3oeTDWws=;
        b=GUt9fGBgMNhgiKT4L5OER0BpDErk7QdknYpj2cwOoXNZ80gaCpJwjEAMCA4+I7yLsZ
         eV+MRIysgy2YSwwO7V0cPIv+yncKFYClol9UazO4LJ2NCT4QKOx4RQBVSOxCTaIea8li
         varYB3kvOKg2+NOaCyOkduFc47C+KnYMxEID9xpx85815uBxo1J+luLqJ35umVIuvBHl
         qyv14Dy4wxDBiMf1EetolMXRlopNVMLY4wXWRh9qcgu8QummndVGu8xA1PBkQd7e1CRh
         kxhUxKmz9x9d8+An6o8OBtR+rdl89gqaoS0RTdA8HoTWviIbr3zilLMA94pmFLpmP+eD
         vYgQ==
X-Gm-Message-State: AHQUAubzJJrD7jxI82iBEUsP9EnwLBudKKJTMR9hCXcEhwmkDzQOr76w
        Xe4zMkWB5tS1MvkmtkFnbFPyl7yRhIa2+L3Fceg=
X-Google-Smtp-Source: AHgI3IaXYGqSsEvLtauMUT6fuGhlq/VTDg42wxNmh8OPWuSXJqHU612IDVq83Qh42FHvCrPo1DZ+rmWluLHAuSoA0XA=
X-Received: by 2002:a17:902:42e4:: with SMTP id h91mr6347059pld.18.1551332986591;
 Wed, 27 Feb 2019 21:49:46 -0800 (PST)
MIME-Version: 1.0
References: <CAN05THSpSLnGF84S0a0+qu=UHw8HArKbuChmP7usRqKNChNC8w@mail.gmail.com>
 <20190227202156.GB23505@fieldses.org>
In-Reply-To: <20190227202156.GB23505@fieldses.org>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 27 Feb 2019 23:49:35 -0600
Message-ID: <CAH2r5mud5qLQqww6p18VoUmRPdoxibrrtfPEA1NuZ+=Xo7nG=g@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Using buildbot for automated testing of CIFS.KO
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 27, 2019 at 2:22 PM J. Bruce Fields <bfields@fieldses.org> wrote:
>
> On Wed, Feb 27, 2019 at 05:22:07PM +1000, ronnie sahlberg wrote:
> > Hi Folks,
> >
> > I am Ronnie Sahlberg, CIFS.KO developer at RedHat.
> > I want to come to LSF/MM to talk CIFS and network protocols with
> > colleagues in the FS world.
> >
> > I have an idea for an informal talk I would like to give:
> > "Automated testing of kernel fs modules using buildbot. Experiences so
> > far in CIFS land."
> >
> > This would be a practical presentation showing examples of a system we
> > implemented recently
> > for cifs.ko to have a standard set of tests to run to ensure quality
> > and (hopefully) avoidance
> > of regressions for the patches that are sent to Linus for the CIFS.KO module.
> >
> > At this point we are starting to see very promising results on fixing
> > bugs before they hit Linus tree.
> > I would like to show and talk about how we set this up and why we did
> > it this way.
> >
> > To see what it looks like right now, this is what I think will go as a
> > pull request when the next merge window opens:
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/137
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/98
>
> Am I reading right--did one of those tests take twice as long as the
> other?  I wonder why?
>
> Just curious.  Always happy to hear about other folks' test setups.

No - these runs were quite different - two distinct groups of tests.
"cifs-testing" group is longer and tests to three types of server
targets, while the "azure" target tests 67 of the xfstests to Azure
server target (albeit with different configurations for some of the
tests).  There is an additional test group for "DFS" (Global Name
Space) and we will probably add more.

A big hole right now is lack of RDMA ("SMBDirect") tests - in part due
to lack of good options for emulated RDMA in virtual machines.


-- 
Thanks,

Steve
