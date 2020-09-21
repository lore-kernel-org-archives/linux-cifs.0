Return-Path: <SRS0=z3C/=C6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148B1C43463
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 10:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4CC121D43
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 10:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgIUKmh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Sep 2020 06:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgIUKmh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Sep 2020 06:42:37 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01304C061755
        for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2020 03:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=oERcsm+No9lLGXMiiR8v758apdh8QYnmXHrCR3bRx7A=; b=Y3zIhxK0r1M9WyKPdVHOmUxohx
        x9kzwv2Sr7Im+pHFEDYbd0sf36i7ykjCcSgjZcdOXyc9dVEQCd/u32+4WR3YKDDW1EUmQSXqTl8NK
        n6pIi9Piz4Yt9C/979se4gW57ANQM4X6Mfauk3IjpkIMkQ2CgAf66cSt9HLkd0/2Ylc0Bi2th39P+
        SeHBIKggsjR0qfMEre7nDxdg0we5qdJOJw3DLm70XVNiDRXUGe5CD3yfvLP4sOaoEQs3DQqOpOBk5
        EJlzdXRCp682JI36X664qtlZqoe/cscDnyh72YXOxNhPQKqMpVjpTTxFLs9mhS6cUnSAV3zN8L2XM
        RFPObFm7UUuDjT1rrU4idZUWwhgsZXlFWMbxzp9AIs00eiGJv7P6tOXNrsfsccyCbg+fyexZRo5Ll
        5ofhpYc5e6CmsvkRMnL+7F1NAywHu4qgYepx+gAEByMCQrB2dl5MqGp0jeW3PGnOhHDYnpEnGc7lI
        ENOrHQOtzqYxCG/oHiD00wsz;
Received: from [2a01:4f8:192:486::6:0] (port=18376 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kKJHH-0003im-6Z
        for cifs-qa@samba.org; Mon, 21 Sep 2020 10:42:35 +0000
Received: from [::1] (port=31056 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kKJHG-002ulO-Mh
        for cifs-qa@samba.org; Mon, 21 Sep 2020 10:42:34 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14507] New: cifs ACL exec permission granted where it should be
 denied
Date:   Mon, 21 Sep 2020 10:42:34 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-14507-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14507

            Bug ID: 14507
           Summary: cifs ACL exec permission granted where it should be
                    denied
           Product: CifsVFS
           Version: 5.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: major
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: bjacke@samba.org
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

if the owner of a file has exec permission, then cifs vfs seems to generally
grants exec permission on files where ACL does not actually grant exec
permission.

Example:

bjacke@cifstest1:/mnt3/a$ getcifsacl test.txt=20
REVISION:0x1
CONTROL:0x8c04
OWNER:S-1-5-21-4207148185-4040488370-1588356217-500
GROUP:S-1-5-21-4207148185-4040488370-1588356217-513
ACL:S-1-5-21-4207148185-4040488370-1588356217-500:ALLOWED/I/FULL
ACL:S-1-5-21-4207148185-4040488370-1588356217-513:ALLOWED/I/R
ACL:BUILTIN\Users:ALLOWED/I/R

I'm connected with a user who is just in the Users group and I *can* execute
the test.txt file. This should not be allowed. Only Administrator
(S-1-5-21-4207148185-4040488370-1588356217-500) has execute permission
according to the ACL.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
