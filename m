Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0879C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 23:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B324B2077B
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 23:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfBUXRA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Feb 2019 18:17:00 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:50732 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfBUXRA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Feb 2019 18:17:00 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id x1LNGtAC011117;
        Thu, 21 Feb 2019 15:16:57 -0800
Message-ID: <5C6F3167.7090402@tlinx.org>
Date:   Thu, 21 Feb 2019 15:16:55 -0800
From:   L A Walsh <cifs@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
CC:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re:upcalls seem to have problems with symlinks, junctions et al.
References: <5C6B997B.8050203@tlinx.org> <CAKywueSgMhDzKOx04_C8X3HEhn_0w6cwM43c3=FXdjCsZ3x9UA@mail.gmail.com> <5C6DAEFC.2060909@tlinx.org>
In-Reply-To: <5C6DAEFC.2060909@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/20/2019 11:48 AM, L A Walsh wrote:
>
>>> ---
>>> ls: cannot access 'Documents': Operation not supported
>>> ...
>>> ls: cannot access 'Prog64': Operation not supported
>>>       
>>> d????????? ?       ?            ? Documents/
>>> ...
>>> d????????? ?       ?            ? Prog64/
>>> ...
>>> Depending on timing, Sometimes I will get most or all of
>>> them appearing the same as they would on windows.
>>>
>>> If I can't resolve them more quickly, is there a know
>>> or two to increase cache size and item lifetime?
>>>     
>>>       
>> Which kernel version shows symlinks right and which - wrong?
>>     
----
    Wrong is 4.20.3... I'm not sure, using the "upcall" for the linux
client reading Metadata(owner+ACL) has ever worked right
for the various forms of symlink/symlinkd/mountd/junction, since
I see a message from me on the cifs list trying 4.10.1 and
having resolution problems related to file-system redirects.

    They "should" work the same way...as when I list them locally
since I'm accessing the machine as the same user (the linux
machine is a samba4 PDC and I'm using the same user-id to
access it on both sides).

    The only time they fully work is when I assigned the mount
ownership to my local user that owns or is in a group that
owns most of the links.  Is there something flakey
about reading the link info -- since it works when I mount
it using 1 UID.

    There may be cache timing issues as well, but they are too
ephemeral to pin down.  The question marks seem to be fairly
consistent on these names (all of which are some form of
NT-pointer to another place - junctions


  

