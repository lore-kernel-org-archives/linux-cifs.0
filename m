Return-Path: <SRS0=UMHq=DS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64250C433DF
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Oct 2020 07:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB6F207FB
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Oct 2020 07:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgJKHrE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 11 Oct 2020 03:47:04 -0400
Received: from mleia.com ([178.79.152.223]:44904 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgJKHrE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 11 Oct 2020 03:47:04 -0400
Received: from mail.mleia.com (localhost [127.0.0.1])
        by mail.mleia.com (Postfix) with ESMTP id 9AD8641022A;
        Sun, 11 Oct 2020 07:46:10 +0000 (UTC)
Subject: Re: [PATCH] cifs: fix memory corruption setting EAs on 32 bit systems
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, vladimir@tuxera.com
References: <CAH2r5mv9wcoLkBZbrxrOB_NTsm1fpiYc04b9akOAkHDtuiCF_Q@mail.gmail.com>
From:   Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <e5419388-33be-650f-8e5a-e0a83d21ec98@mleia.com>
Date:   Sun, 11 Oct 2020 10:45:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mv9wcoLkBZbrxrOB_NTsm1fpiYc04b9akOAkHDtuiCF_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20201011_074610_653992_E3558530 
X-CRM114-Status: GOOD (  10.46  )
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

On 10/11/20 1:54 AM, Steve French wrote:
> Original patch was corrupted.   Fixed the whitespace/tab and
> formatting issues and added cc:stable.
> 
> Merged into cifs-2.6.git for-next pending testing/review

thank you so much!

> Vladimir,
> Would you verify that the updated patch matches what you expect?

Certainly, I've compared my original patch with the commit on the
for-next branch, and the code change itself is completely equal to mine.

> Probably easier to send future patches as attachments or links to git
> tree commit to avoid the usual email corruption of non-plain text
> patches.
> 

Here the patch is a regular plain test file created by git-format-patch
utility and sent by git-send-email. Apparently any issues were caused on
the next stage of editing the commit message, that's what the diff says.

Thank you again for review, I have a few more changes in my queue, they
are not as critical as this one, thus I'll send them at a slow rate.

--
Best wishes,
Vladimir
