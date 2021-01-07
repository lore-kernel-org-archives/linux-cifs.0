Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95172C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 15:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67F6C23406
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 15:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbhAGPf1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jan 2021 10:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbhAGPf0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jan 2021 10:35:26 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F5DC0612F5
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jan 2021 07:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=oC0XHPI9vs4UEspSvU8FaI/sF6gqEswYPhsjf48DjR0=; b=XiUkvKVxdrPOyM6236XFaNF/rw
        d8KREDFGXUeee5+REyMK1c6AOXupoxjnR0CcZK9a1bH/uxGWPH/eLrtRwyQvwQUuTa6p9dj84rfpI
        gc2i/FL2rJghDp1SrHgw5cgZCkMylD6MJ+7XvnRil5MRM9RyTdPPGMCUZf9YneYqmH5Xpxuu5djws
        5I5S52tKz7AOsETblE0msjMSLt34VUMnf8hjTEHUKWwMVj1Ed4031o4SAcxd6CRxKU4ZCczcsb2jE
        HZnxp/AGW3UgxuSXxTQiFP17g8Uo2+ZzBXxqzbspHT4bCiZ22EAnotrPu7/NmcmStGSAGVPxk3IGB
        l9ImzenV/JbIJp9tS4xFQWh6isZxQK/tX/ovgm/d+nLYa1qbkyNRbiPoHQyNMa+4Iz6YiocThdEHe
        SrFhFrnyGUiftBZyVr0F5Phzz6Y78A6ZDDXX6qYC+iqXyAg7AZFiMvs3nuhTwKtCV9foZAQC0CIOm
        O3pl6QiVOntlsjHg6xYXuaeW;
Received: from [2a01:4f8:192:486::6:0] (port=58074 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kxXJC-0000eI-HG
        for cifs-qa@samba.org; Thu, 07 Jan 2021 15:34:42 +0000
Received: from [::1] (port=27514 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kxXJC-002xqD-A2
        for cifs-qa@samba.org; Thu, 07 Jan 2021 15:34:42 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13712] Unable to access files below folder name with trailing
 dot or space
Date:   Thu, 07 Jan 2021 15:34:42 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13712-10630-wUPXz6CZjW@https.bugzilla.samba.org/>
In-Reply-To: <bug-13712-10630@https.bugzilla.samba.org/>
References: <bug-13712-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13712

--- Comment #4 from Steve French <sfrench@samba.org> ---
Can you tell me which version you still see it failing in?  It works for me=
 in
5.10. See below:

root@smfrench-ThinkPad-P52:/mnt2# mkdir subdir
root@smfrench-ThinkPad-P52:/mnt2# cd subdir
root@smfrench-ThinkPad-P52:/mnt2/subdir# mkdir dir-trailing-dot.
root@smfrench-ThinkPad-P52:/mnt2/subdir# ls
dir-trailing-dot.
root@smfrench-ThinkPad-P52:/mnt2/subdir# echo foo > dir-trailing-dot./foo
root@smfrench-ThinkPad-P52:/mnt2/subdir# mkdir x
root@smfrench-ThinkPad-P52:/mnt2/subdir# echo foo > x/foo
root@smfrench-ThinkPad-P52:/mnt2/subdir# mv x dir2-trailing-dot.
root@smfrench-ThinkPad-P52:/mnt2/subdir# ls dir2-trailing-dot.
foo
root@smfrench-ThinkPad-P52:/mnt2/subdir# cat dir2-trailing-dot./foo
foo
root@smfrench-ThinkPad-P52:/mnt2/subdir# mount | grep cifs
//localhost/scratch on /mnt2 type cifs
(rw,relatime,vers=3D3.1.1,cache=3Dstrict,username=3Dsmfrench,uid=3D0,noforc=
euid,gid=3D0,noforcegid,addr=3D127.0.0.1,file_mode=3D0755,dir_mode=3D0755,s=
oft,nounix,serverino,mapposix,mfsymlinks,rsize=3D4194304,wsize=3D4194304,bs=
ize=3D1048576,echo_interval=3D60,actimeo=3D1)

This was fixed multiple years ago in patch:
commit 45e8a2583d97ca758a55c608f78c4cef562644d1
Author: Steve French <smfrench@gmail.com>
Date:   Wed Jun 22 21:07:32 2016 -0500

    File names with trailing period or space need special case conversion

    POSIX allows files with trailing spaces or a trailing period but
    SMB3 does not, so convert these using the normal Services For Mac
    mapping as we do for other reserved characters such as
            : < > | ? *
    This is similar to what Macs do for the same problem over SMB3.

    CC: Stable <stable@vger.kernel.org>
    Signed-off-by: Steve French <steve.french@primarydata.com>
    Acked-by: Pavel Shilovsky <pshilovsky@samba.org>

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
