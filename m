Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCAEC432BE
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Aug 2021 12:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6994B604DC
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Aug 2021 12:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhH0Mh7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Aug 2021 08:37:59 -0400
Received: from mx01.geo.uzh.ch ([130.60.176.135]:33204 "EHLO mx01.geo.uzh.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231414AbhH0Mh7 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 27 Aug 2021 08:37:59 -0400
X-Virus-Scanned: Debian amavisd-new at geo.uzh.ch
Received: from brisen.service.geo.uzh.ch (unknown [130.60.176.40])
        by mx01.geo.uzh.ch (Postfix) with ESMTP id 4C77B260121;
        Fri, 27 Aug 2021 14:37:09 +0200 (CEST)
Received: from smtpclient.apple (unknown [192.168.246.10])
        by brisen.service.geo.uzh.ch (Postfix) with ESMTPSA id 3A50FBD518;
        Fri, 27 Aug 2021 14:37:09 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Kernel lockup upon dfs_cache_update
From:   Thomas Werschlein <thomas.werschlein@geo.uzh.ch>
In-Reply-To: <87wnotmjgi.fsf@cjr.nz>
Date:   Fri, 27 Aug 2021 14:37:08 +0200
Cc:     linux-cifs@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <129D2168-B041-402A-B111-D9A68B85E5D9@geo.uzh.ch>
References: <C36709C4-A89B-40A8-819B-F54828F8788D@geo.uzh.ch>
 <87wnotmjgi.fsf@cjr.nz>
To:     Paulo Alcantara <pc@cjr.nz>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


> On Tue, Aug 10, 2021 at 5:02 PM Paulo Alcantara <pc@cjr.nz> wrote:
> 
> Thomas Werschlein <thomas.werschlein@geo.uzh.ch> writes:
> 
>> Hi
>> 
>> We are mounting SMB shares from Windows and FreeBSD servers to AD-joined (Ubuntu) Linux clients, using DFS and Kerberos.
>> 
>> A sample /etc/fstab entry looks like this:
>> //files.d.example.com/shared /files/shared cifs defaults,sec=krb5i,vers=3,seal,multiuser,noserverino,username=LINUXCLIENT$ 0 0
>> 
>> The machine account LINUXCLIENT$ is able to browse the DFS tree and mount the shares.
>> The credentials for the principal LINUXCLIENT$@D.EXAMPLE.COM are stored in the default keytab (/etc/krb5.keytab).
>> In order to access a share a user needs a personal KRB ticket (either through kinit or GSSAPI delegated credentials upon ssh login).
>> 
>> This works fine on Ubuntu 18.04 (4.15.0-153-generic Kernel, 2.10 cifs.ko), but doesn't on Ubuntu 20.04 (5.4.0-80-generic, 2.23).
>> To be precise: it works for the first 10 hours (the ticket lifetime) even on Ubuntu 20.04.
>> 
>> My findings so far:
>> - this lockup (after 10h) *only* occurs when DFS is involved. Mounting a target share directly "survives" the ticket expiry
>> - this problem does *not* manifest with the newest kernel/cifs.ko combo (5.14.0-051400rc5-generic/2.33)
>> 
>> Therefore:
>> Could it be, that the DFS patches contributed by Paulo Alcantara on June 4 2021 (https://www.spinics.net/lists/linux-cifs/msg21999.html)
>> fixed this problem?
> 
> Yes, that is possible.  We found out some deadlock and race scenarios
> but couldn't remember if the above was one of them.  Still worth having
> those commits backported.

Thanks for your (possible) confirmation.

> 
>> 
>> Two of his comments point into that direction: 
>>  [...]
>>  - keep SMB sessions alive as long as dfs mounts are actives in order
>>    to refresh cached entries by using IPC tcons.
>>  [...]
>>  - skip unnecessary tree disconnect of IPCs when shutting down SMB
>>    sessions (it didn't even work before).
>> 
>> Am I on the right track here? And if so: are there any plans to backport Paulo's patches to current kernels?
> 
> Yes.  I don't know if there any plans, but the only tricky part is
> changing the commits to work with the old mount api on <5.11 kernels.

I wasn't aware of Ubuntu's "LTS enablement stack" (https://wiki.ubuntu.com/Kernel/LTSEnablementStack).
A simple 'sudo apt install --install-recommends linux-generic-hwe-20.04' brings the latest LTS to Kernel 5.11.0-27 and cifs.ko to 2.30.

Strange enough (but gratefully so) this did solve my problem - the lockups don't manifest anymore.
I wouldn't have expected this, since your patches from June 4 brought cifs.ko to 2.31. Must be some earlier change then?

Anyway, our problem is gone. Thanks again.

Best regards
Thomas
