Return-Path: <SRS0=FePp=Q5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FD0C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 09:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE1722081B
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 09:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbfBVJ4h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Feb 2019 04:56:37 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:46396 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfBVJ4h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Feb 2019 04:56:37 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id x1M9uVDc036163;
        Fri, 22 Feb 2019 01:56:33 -0800
Message-ID: <5C6FC74F.3020907@tlinx.org>
Date:   Fri, 22 Feb 2019 01:56:31 -0800
From:   "L. A. Walsh" <cifs@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To:     Steve French <smfrench@gmail.com>
CC:     L A Walsh <cifs@tlinx.org>, Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: upcalls seem to have problems with symlinks, junctions et al.
References: <5C6B997B.8050203@tlinx.org> <CAKywueSgMhDzKOx04_C8X3HEhn_0w6cwM43c3=FXdjCsZ3x9UA@mail.gmail.com> <5C6DAEFC.2060909@tlinx.org> <5C6F3167.7090402@tlinx.org> <CAH2r5mskDv3ZB8gUpRDN6iPzaZaGeXuN-uHikGvj+5K4epN2Xg@mail.gmail.com>
In-Reply-To: <CAH2r5mskDv3ZB8gUpRDN6iPzaZaGeXuN-uHikGvj+5K4epN2Xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/21/2019 8:30 PM, Steve French wrote:
> I have wanted to change this code and improve it for a while - one
> thing which is tricky is showing mode bits when no permissions to read
> permissions though, and we also need to clean up and simplify some of
> this code.   Let's follow up on this in a few days, if you are
> flexible and can install some test patches
>   
Usually links on linux have 777 permissions and aren't
changeable, though things are changing.

As for testing -- should be able, but maybe not
too fast.

Dunno if you rememeber, but I had some probs w/links back
around Feb 2-3 2017...and you asked for a wireshark
trace that I sent on on the 3rd...then we both got
distracted.
(same list)

I sometimes have a long cycle time...you too?  :-)

I could send the dump again... ;-)  Seriously, I went
back to using a single UID mount and that works around
the problem, as in my case I have perms to read all
of the links.

I just recently tried it again -- and hit the same
type of behavior. 

