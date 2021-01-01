Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86304C433DB
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jan 2021 19:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DBA3221F2
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jan 2021 19:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbhAAT7K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Jan 2021 14:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbhAAT7K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Jan 2021 14:59:10 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26124C061573
        for <linux-cifs@vger.kernel.org>; Fri,  1 Jan 2021 11:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=OR3PrxJuBkuYDp48Tu/wJCqazQjCTGlxeFR5kQiF6zQ=; b=jWaNIcZCApm0f31B5ORRMOby6c
        u7Qt/4Q1BizZBiywHkBXJAjhlzmHrmxtP1YYNF7rmf4kKt0DMs6IEfpwfdjMrWVsd41kLzirYfbei
        rYmzhUVyLnvPCBR2PWoSZOzSXiU2Ugmw7CyDOZkfRfFQ3t/n+3rwGeaNGOBzEcE+JORIIendjZQbA
        DBNEKbvL1HHgKhHyOOHAEpfKsNDOxSd8fAea4RMOqEUya2dspaTyKgWdD5fKfiurqmjzO5s6PW3+8
        aZdwjWriWa5hfW+j1XDEJHtl+7+z449E3eVCBOUsg+AIWxVF1Huj/zjoPwsaRU5xSfUH5EsCcuCSz
        I5z7yrLOTf8Kwuz0d8sF0vATry8KTgsKAy3Pi3TvlcSUWtSbjKuc/gpZEfbGoalMbC7Od6c8ts0kM
        GJbD5fYWvJOtwatMniOl4y9Tzp2PME3jZ3KFJNZzyjR+c+mb9BhhFk7ce+vpDfdUPleVhyWNA/l7r
        hUKpyzupXkF+c2jCRLoEuPI4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kvQZ7-0005ah-Ju; Fri, 01 Jan 2021 19:58:26 +0000
Date:   Fri, 1 Jan 2021 11:58:21 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Xiaoli Feng <xifeng@redhat.com>, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH][SMB3] allow files to be created with backslash in file
 name
Message-ID: <20210101195821.GA41555@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5msH3LZuF69UFcfgtG7XXurMDc=-Ab7Ct4XwfARR8d+wRA@mail.gmail.com>
 <20210101060050.GA1892237@jeremy-acer>
 <CAH2r5mt+5LQB59w0SPEp2Q-9ZZ2PV=XDMtGpy2pedhF8eKif0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mt+5LQB59w0SPEp2Q-9ZZ2PV=XDMtGpy2pedhF8eKif0A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jan 01, 2021 at 09:12:14AM -0600, Steve French wrote:
>On Fri, Jan 1, 2021 at 12:00 AM Jeremy Allison <jra@samba.org> wrote:
>>
>> On Thu, Dec 31, 2020 at 09:35:23PM -0600, Steve French via samba-technical wrote:
>> >
>> >This patch may be even more important to Samba, as alternative ways of
>> >storing these files can create more problems. Interestingly Samba
>> >server reports local files with backslashes in them over the wire
>> >without remapping, even though these are illegal in SMB3 which would
>> >cause confusion on the client(s).  Has anyone tried Windows mounting
>>
>> Samba should mangle names containing '\' to 8.3 names.
>
>You were right mangled names was enabled.  But that is also
>interesting - it does expose a bug in smbclient.
>
>When you connect smbclient - doing a ls of a subdirectory with
>reserved characters worked, but doing an ls of the parent (root
>directory of share) caused smbclient to disconnect.  See below
>
>smb: \> ls rsvd-chars
>  rsvd-chars                          D        0  Fri Jan  1 08:55:49 2021
>
>556368460 blocks of size 1024. 296010296 blocks available
>smb: \> ls
>  .                                   D        0  Fri Jan  1 08:54:28 2021
>  ..                                  D        0  Thu Dec 31 21:42:28 2020
>  topdir                              D        0  Mon Dec 14 16:01:25 2020
>  lock1.txt                           A      200  Fri Dec 18 12:28:18 2020
>  lock_rw_shared.dat                  A      200  Fri Dec 18 12:28:18 2020
>  lock_rw_exclusive.dat               A      200  Fri Dec 18 12:28:18 2020
>  autounlock.txt                      A      200  Fri Dec 18 12:28:18 2020
>is_bad_finfo_name: bad finfo->name
>NT_STATUS_INVALID_NETWORK_RESPONSE listing \*
>smb: \> SMBecho failed (NT_STATUS_CONNECTION_DISCONNECTED). The
>connection is disconnected now

Can you log a bug please and give full setup instructions
to reproduce. This isn't enough to show me what the bug is.
I need a directory listing from the Server side to show
me what files are in the root of the share.

Also, you neglect to tell me what Samba version you are
using (which is a pre-requisite for a bug report Steve,
you know this :-).
