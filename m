Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62D5C433E0
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Jan 2021 05:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAB582072C
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Jan 2021 05:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbhABF0N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Jan 2021 00:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbhABF0M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Jan 2021 00:26:12 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A87C061573
        for <linux-cifs@vger.kernel.org>; Fri,  1 Jan 2021 21:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=M7fR5RdbVhR16F9VifUn2xUzeSPJmR32nInQDMEh6oc=; b=BorFbc3cNtqD7t9b7O3xWz4DVU
        xG+sCJLp2ql1zkREpq1xyLQ0aH5MwdQQsEwYZUdDpPmwo7NaejRf3jNOaY5FOGi8FRUOnP4Y4dMRO
        o7rmmT/jApQsLckNkkab360xYCUu+a30PjO8uL+jjpy2PNRMWBOUQsL5rOtpNTZRyuCAg1DFaGJRp
        oT3vWsmW1Mtd/Zd9n8Hbs8DcnBztRwtFbDIWgTIaWoCEIe2hbeDaa90WXf69LsQMaXi5g0XJYVlRU
        SMUivQnzqPWgInAEhiYxowRQnuGSn0NNukmYr3WuGyfQByggpu4Fd077UvGQNzRB2GaxEHd3pJoEe
        TMEoIThMJAXdZQ6F7oYjBuPvHBeJIWQT2oHs/Qf9oRPGAtwF1s4UuQyUnaTX6MgYL2yHCJbVIEecX
        qAVAV1h8NiyP3ko2WMTgiHLoTtj/MDo4UCpijRuYHnsJ1HrVSpIhj3nVqPZ0FEPdCjBcugEK2kpyR
        NsXp4H+HSFWUlgwYjuJ8Yi4a;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kvZPr-0007U0-Dp; Sat, 02 Jan 2021 05:25:27 +0000
Date:   Fri, 1 Jan 2021 21:25:24 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Xiaoli Feng <xifeng@redhat.com>, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH][SMB3] allow files to be created with backslash in file
 name
Message-ID: <20210102052524.GA67422@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5msH3LZuF69UFcfgtG7XXurMDc=-Ab7Ct4XwfARR8d+wRA@mail.gmail.com>
 <20210101060050.GA1892237@jeremy-acer>
 <CAH2r5mt+5LQB59w0SPEp2Q-9ZZ2PV=XDMtGpy2pedhF8eKif0A@mail.gmail.com>
 <20210101195821.GA41555@jeremy-acer>
 <CAH2r5mvt_cHDbT0xaeLNQn=5cQ0T2-wPgpMkYEGQNdtDZ3kP=A@mail.gmail.com>
 <20210102025837.GA61433@jeremy-acer>
 <CAH2r5ms1V2KKb6T3ELQ-JsQ3fniOScTE2654_xLwnPruiekzEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5ms1V2KKb6T3ELQ-JsQ3fniOScTE2654_xLwnPruiekzEw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jan 01, 2021 at 09:49:06PM -0600, Steve French wrote:
>I exported the /scratch directory with smb.conf configured as
>
>[scratch]
>   comment = scratch share for testing
>   browseable = yes
>   path = /scratch
>   guest ok = yes
>   read only = no
>   ea support = yes
>   create mask = 0777
>   directory mask = 0777
>   vfs objects = acl_xattr
>   map acl inherit = yes
>   strict allocate = yes
>   map acl inherit = yes
>   mangled names = no
>
>Connecting with smbclient and doing a simple ls causes the disconnect:
>$ smbclient --version
>Version 4.12.5-Ubuntu
>$ smbclient //localhost/scratch -U testuser
>Enter SAMBA\testuser's password:
>Try "help" to get a list of possible commands.
>smb: \> ls
>  .                                   D        0  Fri Jan  1 21:19:52 2021
>  ..                                  D        0  Thu Dec 31 21:42:28 2020
>  rsvd-chars                          D        0  Fri Jan  1 09:14:04 2021
>  file-?-question                     N        0  Fri Jan  1 21:19:42 2021
>is_bad_finfo_name: bad finfo->name
>NT_STATUS_INVALID_NETWORK_RESPONSE listing \*
>smb: \> SMBecho failed (NT_STATUS_CONNECTION_DISCONNECTED). The
>connection is disconnected now

Well of course it disconnects. You set

"mangled names = no"

So the server returns the bad name. The smbclient
library notices the server is trying to screw with
it by sending invalid Windows names and disconnects
to protect itself.

This is by design. There is a *REASON* mangled names = yes
is the default. Otherwise you can't see valid server
filenames that contain : \ etc. etc. from a Windows client.

Even a file names AUX: has to be mangled. "mangled names = no"
is only useful for a pre-cleaned exported file system which
you can guarantee contains only Windows-compatible names.

This is not a bug, it's working as designed to protect
the client code.

There was a CVE where libsmbclient might pass up
names containing a '/' to the calling code (not
that they can exist on disk, but a malicious server
could send them) which might then treat it as a
path separator.
