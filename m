Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B93AC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 16:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345266AbiEDQrb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 12:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353588AbiEDQra (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 12:47:30 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C475546B14;
        Wed,  4 May 2022 09:43:53 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nmI6O-0001sG-7M; Wed, 04 May 2022 18:43:48 +0200
Message-ID: <29f90334-53dc-4926-fc38-420b4d024f1b@leemhuis.info>
Date:   Wed, 4 May 2022 18:43:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Regression: CIFS umount fails since 14302ee33 with some servers
 (exit code 32)
Content-Language: en-US
To:     Paulo Alcantara <pc@cjr.nz>, Moritz Duge <duge@pre-sense.de>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
References: <715d745d-5a85-092a-68c2-b9b1dd8ad53e@leemhuis.info>
 <5fc82f02-be3a-6bb4-0800-aaf19a782655@leemhuis.info>
 <64a7de55-8f93-8e7a-4102-26f7d4dbe1dc@pre-sense.de> <87zgjx1d09.fsf@cjr.nz>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <87zgjx1d09.fsf@cjr.nz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1651682633;2b562ad7;
X-HE-SMSGID: 1nmI6O-0001sG-7M
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 04.05.22 18:25, Paulo Alcantara wrote:
> Moritz Duge <duge@pre-sense.de> writes:
> 
>> I'm still waiting for a reply from Paul.
> 
> The bug is currently being handled at [1].  Enzo has also asked you to
> send us network traces in [2] and you haven't sent any, yet.

Many thx for the update.

> I'm not "Paul", BTW.

Paulo, please accept my apologies, that was my fault.

> [1] https://bugzilla.opensuse.org/show_bug.cgi?id=1194945
> [2] https://bugzilla.opensuse.org/show_bug.cgi?id=1194945#c13

#regzbot link: https://bugzilla.opensuse.org/show_bug.cgi?id=1194945

Ciao, Thorsten
