Return-Path: <SRS0=AHfl=CY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28DFC433E2
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 02:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 471B5207EA
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 02:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgIOCC4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Sep 2020 22:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgIOCC4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Sep 2020 22:02:56 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178D1C06174A
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2020 19:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=lKH06xIL/YRGGUbV3l3kbZT27PmIw2WlsilrhChGuuw=; b=R3zV8kUrZmR97mmmFuiZuAMFwc
        Ic6R5La1UBTHm6X7Q2h3y+HSzvnzEqcp2Mq+W2pRn0xQ2JslIqNEKmuAFXAM2okkdFGFKQGXTm28n
        1EBWiM5Pno1Zoot5C9KJcXHtPGs0t8axW2AWobPQ/Sqg+8TfhEhAxXXkxHyO39NmOAKCnn6pdqXVa
        2JLiT9+szCyU985dOoX9hRJURFD0kQo1lLjgUPcUg08/AS9ZzUr0ejmdg4yLOru13kc5Ng9Uknq2P
        tmBTS4TcEJZcavThQG34dqQUJPFINANPtbd7bVKe7KWGPc7b+vd51ETd5hSewORfK0eLvze5fKYPB
        rJGdm18PrSZK5w5+Hlb0QhDYz+/lJGLvGKgysRbqsLOwBkgX38skhVrLMH4Oe2JxBqw1W4+o0SYuZ
        M3IDCSE9IVbOWDCHUOLQK5oPPCO3r4JCdu/mHUSYxOmUNuVzLzppaV2PHfAP/VkGsIx3MhBf8bwxu
        VchrPmwu7vLCzUOLpOQSLzwm;
Received: from [2a01:4f8:192:486::6:0] (port=60784 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kI0Iw-0002RR-GJ
        for cifs-qa@samba.org; Tue, 15 Sep 2020 02:02:46 +0000
Received: from [::1] (port=25926 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kI0Iv-002KDR-4F
        for cifs-qa@samba.org; Tue, 15 Sep 2020 02:02:45 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14492] New: Minshall-French symlinks cannot be searched for
 with "find . -type l"
Date:   Tue, 15 Sep 2020 02:02:44 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: micah.veilleux@iba-group.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-14492-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14492

            Bug ID: 14492
           Summary: Minshall-French symlinks cannot be searched for with
                    "find . -type l"
           Product: CifsVFS
           Version: 3.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: normal
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: micah.veilleux@iba-group.com
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

Minshall-French symlinks are identified by "find" as files rather than symb=
olic
links:
------------------------------
mcrs3:/TCS # grep "TCS " /etc/fstab
//mcrs3/TCS /TCS cifs
user=3Dcifsuser,multiuser,domain=3DVPTC3,sec=3Dkrb5,mfsymlinks,vers=3D3.0 0=
 0
mcrs3:/TCS #
mcrs3:/TCS # touch testfile
mcrs3:/TCS # ln -s testfile testlink
mcrs3:/TCS #
mcrs3:/TCS # find . -type l
mcrs3:/TCS # find . -type f | grep test
./testlink
./testfile
mcrs3:/TCS #
mcrs3:/TCS # stat testlink
  File: testlink -> testfile
  Size: 8           Blocks: 16         IO Block: 16384  symbolic link
Device: 2ch/44d Inode: 10941196461752524492  Links: 1
Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2020-09-11 20:24:54.163302900 +0200
Modify: 2020-09-11 20:24:26.146021300 +0200
Change: 2020-09-11 20:24:26.146021300 +0200
 Birth: -
mcrs3:/TCS #
------------------------------

Version of sernet-samba is: 99:4.12.2-11.suse150

The underlying issue could be the same as for bug 14476.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
