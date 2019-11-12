Return-Path: <SRS0=+Q0n=ZE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FB5C17440
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Nov 2019 21:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C89020818
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Nov 2019 21:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKLVwy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:52:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38262 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfKLVwx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Nov 2019 16:52:53 -0500
Received: from mail-pl1-f200.google.com ([209.85.214.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <matthew.ruffell@canonical.com>)
        id 1iUe5i-0002uG-P9
        for linux-cifs@vger.kernel.org; Tue, 12 Nov 2019 21:52:50 +0000
Received: by mail-pl1-f200.google.com with SMTP id h7so13803341pll.18
        for <linux-cifs@vger.kernel.org>; Tue, 12 Nov 2019 13:52:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=14po5GSb10XCLM5qiypNjpVOhIJ2gDZn74IerOODagU=;
        b=qEMVc79DvfxIJeO6zrEa0Iee1ZvsK+9d+d06RL5gmS53siMHYJaEMHE959uFcjUQVs
         icaHgYJjF7g1N8Vx+dCaO45akHHY4g4UvXB4rJ88Ay5RnXsE6OtIsVyG6OeX+mqMQBGT
         OyKzLzolwXbNZmlPe+SXjsgpIa2TnM8e/76H2fhbkgb2+SJVqSXPxzRs/7xNNchkp+Q3
         x03uYsZnum55ncY+zhYd0t/DReTw2LCWQ2YyIQalLvyRWQ0pcndWzi81uagjFnkxy1PB
         SzNPD/pmjJWSTCp/Ia+erZr2rS4F33n7iyOzCZfbJLCIuVYziYutSdtNabetRw6ryGGy
         RuWg==
X-Gm-Message-State: APjAAAWcDOTZ9ZXRRRdMzEGngezISUxU4C0WyrzyU3bQ1v7+fixzT5of
        VgDHCwjcfcwyqV00F/iS1V8zH/ePa3rhTJerRFTk2ZbIYCX9Fe1cKBkrrB2RLWGC6OezATGQ6x8
        ZPB35zCkUuHn1qG45tLnSSBEE+VO5Ltnn/VIvDEs=
X-Received: by 2002:a63:a34e:: with SMTP id v14mr37705834pgn.58.1573595569429;
        Tue, 12 Nov 2019 13:52:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqzRQ4ayLxp3P51eM5qEG9Du8S4iRHGIsCZEIxHf6DB2qmLMCB4hmzX1hqvGtGLuvK2qov0B9w==
X-Received: by 2002:a63:a34e:: with SMTP id v14mr37705804pgn.58.1573595569089;
        Tue, 12 Nov 2019 13:52:49 -0800 (PST)
Received: from [192.168.1.107] (222-154-99-146-fibre.sparkbb.co.nz. [222.154.99.146])
        by smtp.gmail.com with ESMTPSA id y14sm20335341pff.69.2019.11.12.13.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:52:48 -0800 (PST)
To:     linux-cifs@vger.kernel.org
Cc:     sfrench@samba.org, palcantara@suse.de
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: PROBLEM: DFS Caching feature causing problems traversing multi-tier
 DFS setups
Message-ID: <05aa2995-e85e-0ff4-d003-5bb08bd17a22@canonical.com>
Date:   Wed, 13 Nov 2019 10:52:44 +1300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve, Paulo, and maintainers of CIFS,

We have come across a problem where kernels 5.0-rc1 and onwards cannot mount
a multi tier DFS setup, while kernels 4.20 and below can mount the share fine.

The DFS tiering structure looks like this:

Domain virtual DFS (i.e. \\company.com\folders\share)
|-- Domain controller DFS (i.e. \\regional-dc.company.com\folders\share)
    |-- Regional DFS Server (i.e. \\regional-dfs.company.com\folders\share)
        |-- Actual file server (i.e. \\regional-svr.company.com\share)

On the 5.x series kernels, after getting the DFS referrals list through to the
Regional DFS Server, which responds with the correct server/share, instead of
going to the Actual file server, the kernel backtracks from the Regional DFS
Server back to the Domain controller and requests the share there. Of course,
this share does not exist on the Domain controller, as it only exists on the
Actual file server, and the connection dies.

We have collected a packet capture, and the flow looks like this:

4.18.0-21-generic Ubuntu kernel - Good

Host                                            request/response
--------------------------------------------    ----------------------------------------------------
Domain controller / Domain DFS Root             company.com\folders
Domain controller / Domain DFS Root             Referral List
Regional Domain Controller / Domain DFS Root    start convo
Regional Domain Controller / Domain DFS Root    <Regional Domain Controller>\Folders\Country\<Share> referral
Regional Domain Controller / Domain DFS Root    <Regional Domain Controller>\Folders\Country\<Share> referral
Regional DFS server                             start convo
Regional DFS server                             <Regional DFS Server>\Root\Country\<Share>
Regional DFS server                             STATUS_PATH_NOT_COVERED
Regional DFS server                             request referrals
Regional DFS server                             Referral List
Actual File Server                              convo started
Actual File Server                              <Actual File Server>\<Share>
Actual File Server                              Good response

5.0.0-26-generic Ubuntu kernel - Bad

Host                                            request/response
--------------------------------------------    -------------------------------------------
Domain controller / Domain DFS Root             company.com\folders
Regional Domain Controller / Domain DFS Root    start convo
Regional Domain Controller / Domain DFS Root    <Regional Domain Controller>\Folders\Country\<Share>
Regional Domain Controller / Domain DFS Root    STATUS_PATH_NOT_COVERED
Regional DFS server                             start convo
Regional DFS server                             <Regional DFS Server>\Root\Country\<Share>
Regional DFS server                             STATUS_PATH_NOT_COVERED
Regional Domain Controller / Domain DFS Root    <Regional DFS Server>\Root\Country\<Share>
Regional Domain Controller / Domain DFS Root    STATUS_PATH_NOT_COVERED

If you are interested in any parts of the packet capture, let us know and I will
provide you with portions that you need.

We also enabled CIFS dynamic debugging with:

echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
echo 7 > /proc/fs/cifs/cifsFYI

From there the debugging output was more or less the same between the two kernel
versions, until the problematic area:

Linux 4.18:

Full log: https://paste.ubuntu.com/p/D9XwBbvTXc/

Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000257 to POSIX err -66
fs/cifs/connect.c: build_unc_path_to_root: full_path=\\<Regional DFS Server>\Root\Country\<Share>
fs/cifs/smb2ops.c: smb2_get_dfs_refer path <\<Regional DFS Server>\Root\Country\<Share>>
fs/cifs/misc.c: num_referrals: 1 dfs flags: 0x2 ...
fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: <Actual File Server> to <IPV4 Address>
fs/cifs/connect.c: Username: XXX
// mounts the share successfully

Linux 5.0:

Full log: https://paste.ubuntu.com/p/9sXPj7WMQv/

Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000257 to POSIX err -66
fs/cifs/connect.c: build_unc_path_to_root: full_path=\\<Regional DFS Server>\Root\Country\<Share>
fs/cifs/connect.c: build_unc_path_to_root: full_path=\\<Regional DFS Server>\Root\Country\<Share>
fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \<Regional DFS Server>\Root\Country\<Share>
fs/cifs/dfs_cache.c: do_dfs_cache_find: cache miss
fs/cifs/dfs_cache.c: do_dfs_cache_find: DFS referral request for \<Regional DFS Server>\Root\Country\<Share>
fs/cifs/smb2ops.c: smb2_get_dfs_refer path <\<Regional DFS Server>\Root\Country\<Share>>
fs/cifs/smb2pdu.c: SMB2 IOCTL
Status code returned 0xc0000225 STATUS_NOT_FOUND
fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000225 to POSIX err -2
// mounting the share fails shortly after

Since there seems to be problems with how referrals are handled, I examined
the commit history, and came across the new DFS caching feature introduced in
5.0-rc1.

I built a test kernel at:

commit e7b602f43719fc6173ae86d2de8f6f07c6858ddd
Author: Paulo Alcantara <palcantara@suse.de>
Date: Wed Nov 14 15:38:51 2018 -0200
Subject: cifs: Save TTL value when parsing DFS referrals

Which is the commit directly before the first commit of the DFS caching feature,

commit 54be1f6c1c37498bba557049df646cc239fa37e3
Author: Paulo Alcantara <palcantara@suse.de>
Date: Wed Nov 14 16:01:21 2018 -0200
Subject: cifs: Add DFS cache routines

I also built a test kernel at the end of the patch series which implements the
DFS caching feature, at:

commit 14e92c5dc7a1a1d4a82fb7142b5642837fef962a
Author: Steve French <stfrench@microsoft.com>
Date: Mon Dec 24 01:05:22 2018 -0600
Subject: cifs: Minor Kconfig clarification

We then tried to mount the CIFS share, and found that:

e7b602f43719fc6173ae86d2de8f6f07c6858ddd -> mounts successfully
14e92c5dc7a1a1d4a82fb7142b5642837fef962a -> fails to mount.

So there is a problem somewhere in the DFS caching feature, covered in the
following commits:

https://paste.ubuntu.com/p/XcNwp3dVBV/

We have also tried 5.3.5 mainline kernel, and the issue is still present.

We are available to help out with gathering more debugging data and trying
test patches. Please let us know what data to collect, or patches to test, and
we will collect whatever you need to get this fixed.

Thanks,
Matthew Ruffell
Sustaining Engineer @ Canonical

