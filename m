Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C785EB64DD
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Jul 2023 00:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjGVAAd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Jul 2023 20:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjGVAAc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 Jul 2023 20:00:32 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA4130E3
        for <linux-cifs@vger.kernel.org>; Fri, 21 Jul 2023 17:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=vp737VbsI9W+BcFCzc9mxmjcPCYbLamKCzu+Y239O28=; b=xdBXuW2/1nJ1PAEcws5jeVWmbp
        uMcKSpa1UZJmxDfPVynSE0cgi2jc2xGncsk8d9cH99cLQxuPLMtdtEFlelAwaSgQAEQG9m44lIvAn
        Ur8Am6mfC+6DZJEbo3lL87w5aHrAg52g7etxBiUKa3qHI6rMbYkNpEe/pJikUDXySiFCSy03P5b2y
        C9wEsuD6Q0pnFZlzs81tHdJ4yTSKf+D/6knZw65IMVgiMOpRIC44DM8CESNgJZ28rCM6VvbvvvOg0
        MpTOftAu9wcOV4q6Vc+Cq4sXCERdr5JnIc7pCtlW1lFdncuAbHTroCmm3Nmirbt1XlX5Bf+yMlMTf
        fSJhfkFtgaBwJHEHPot6VPktA5MDZ7BkqR6PhD1cQQ4MoVa0gBxHqsXCCcJK8dlxEtjIPuEw63Uw+
        OJ3Los58TI6hucHrl1Lqea5l/dX5ZBG2y7BmGHrUaUARp/qG6cUOxRNAD5N4+8u9bVMeM0hRSgEtK
        qH44ELBVr9fZcbr93vqzhLUC;
Received: from [2a01:4f8:192:486::6:0] (port=58338 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qN02i-003Q3H-0t
        for cifs-qa@samba.org;
        Sat, 22 Jul 2023 00:00:17 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qN02f-001ePH-Jk
        for cifs-qa@samba.org;
        Sat, 22 Jul 2023 00:00:14 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] New: Linux mount.smb3 Fails With Windows Host After
 Update July 2023 Update kb5028166
Date:   Sat, 22 Jul 2023 00:00:11 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 4.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sbharvey@verizon.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone attachments.created
Message-ID: <bug-15428-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15428

            Bug ID: 15428
           Summary: Linux mount.smb3 Fails With Windows Host After Update
                    July 2023 Update kb5028166
           Product: CifsVFS
           Version: 4.x
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: major
          Priority: P5
         Component: user space tools
          Assignee: jlayton@samba.org
          Reporter: sbharvey@verizon.net
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

Created attachment 17993
  --> https://bugzilla.samba.org/attachment.cgi?id=3D17993&action=3Dedit
Successful mount.smb3 prior to windows update

Prior to July 2023 windows host "shares" could be mounted in Linux Servers =
with
the command mount.smb3.  After Windows security update kb5028166 the mount
command no longer functions.=20

I believe this is related bug 15418 "Secure Channel Faulty ..."=20
Attachments are added that show that a Windows 10 host "share" can be mount=
ed
successfully and when the share cannot be added after the Window 10/11 secu=
rity
update kb5028166 has been applied.

Here is the dmesg message when the mount.smb3 command fails:
cat dmesg_mnt_failure.txt
[507009.217361] CIFS: Attempting to mount //win10-testhost.harvey.net/public
[509040.494271] CIFS: Attempting to mount //win10-testhost.harvey.net/public
[509040.665517] CIFS: Status code returned 0xc000018d
STATUS_TRUSTED_RELATIONSHIP_FAILURE

Linux Version and distribution:
swupd info
Distribution:      Clear Linux OS
Installed version: 39630
Version URL:       https://cdn.download.clearlinux.org/update
Content URL:       https://cdn.download.clearlinux.org/update

uname -a
Linux netserver03 6.4.3-1333.native #1 SMP Mon Jul 10 21:56:56 PDT 2023 x86=
_64
GNU/Linux

samba --version
Version 4.18.1

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
