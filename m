Return-Path: <SRS0=AHfl=CY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B367EC433E2
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 02:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58E0120678
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 02:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgIOCO6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Sep 2020 22:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOCO6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Sep 2020 22:14:58 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D67C06174A
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2020 19:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=VjfOIjdtO42ne4MigcbGwpZp3deYe6ki73FF7xwgxNQ=; b=lZrz3JjbeWM/gend23lTR7OATq
        OL3FCgatGzmJUMYhmx6mVh2XDcUhHrpRphOzWvIZpSyMRwzJ94EEbx5f3aSvVSWCegtW1eRNhE/QV
        ZCdllYoRA7ZxnLQYlIbgQFMc3qsYVpHvYnGG40AhsYNe1O8HnobeM0XtLx1BiyylRf+KSGL63uHlO
        TQz+5XRKt23S+v/gGMTFaYATqSd55yz2yuOPn9zlZ4VgkbndKQQaPh+6H9cuZsXQNvJqEQj8GxZaC
        f0gYzUCP16fsKqLWG6auRHLpfZ41yMCwmHYd+CT6OLwb4aXUw+dUTHRPv2UsD/U7AvFBr6/5DSKkM
        QYM+UM6GtZvhCNUSTgJxrPLzmqNDjbyvvbtRutZBcoLv86FHfYIz4O8kjzq+Ukcc7vCCQFKIjLlq4
        NUfwtJvq0Lgj+QzsUBRf5tL4g+CYNtARZ9v6XvNF8FsgR6L+wFbQ8+8nwj606FrNjn5Pn/x/+a+g2
        M7e6K1s5edxPrkaJUdobRJmE;
Received: from [2a01:4f8:192:486::6:0] (port=60804 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kI0Uh-0002Vb-US
        for cifs-qa@samba.org; Tue, 15 Sep 2020 02:14:55 +0000
Received: from [::1] (port=25946 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kI0Uh-002KEx-IG
        for cifs-qa@samba.org; Tue, 15 Sep 2020 02:14:55 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14494] New: "setcifsacl" confuses "R" permission with "RX"
Date:   Tue, 15 Sep 2020 02:14:54 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: micah.veilleux@iba-group.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-14494-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14494

            Bug ID: 14494
           Summary: "setcifsacl" confuses "R" permission with "RX"
           Product: CifsVFS
           Version: 3.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: normal
          Priority: P5
         Component: user space tools
          Assignee: jlayton@samba.org
          Reporter: micah.veilleux@iba-group.com
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

When attempting to set "R" permission with "setcifsacl", "RX" (equivalent to
"READ") is set instead:
------------------------------
mcrw1:/TCS # getcifsacl testfile
REVISION:0x1
CONTROL:0x8004
OWNER:VPTC3\cifsuser
GROUP:VPTC3\Domain Users
ACL:VPTC3\Domain Admins:ALLOWED/0x0/RWDPO
ACL:VPTC3\cifsuser:ALLOWED/0x0/RWDPO
mcrw1:/TCS #
mcrw1:/TCS # setcifsacl -a "ACL:VPTC3\mveil:ALLOWED/0x0/R" testfile
mcrw1:/TCS #
mcrw1:/TCS # getcifsacl testfile
REVISION:0x1
CONTROL:0x8004
OWNER:VPTC3\cifsuser
GROUP:VPTC3\Domain Users
ACL:VPTC3\Domain Admins:ALLOWED/0x0/RWDPO
ACL:VPTC3\cifsuser:ALLOWED/0x0/RWDPO
ACL:VPTC3\mveil:ALLOWED/0x0/READ   # --> not ok, should be "R"
mcrw1:/TCS #
mcrw1:/TCS # rm testfile ; touch testfile
mcrw1:/TCS #
mcrw1:/TCS # setcifsacl -a "ACL:VPTC3\mveil:ALLOWED/0x0/RX" testfile
mcrw1:/TCS #
mcrw1:/TCS # getcifsacl testfile
REVISION:0x1
CONTROL:0x8004
OWNER:VPTC3\cifsuser
GROUP:VPTC3\Domain Users
ACL:VPTC3\Domain Admins:ALLOWED/0x0/RWDPO
ACL:VPTC3\cifsuser:ALLOWED/0x0/RWDPO
ACL:VPTC3\mveil:ALLOWED/0x0/READ   # --> ok
mcrw1:/TCS #
------------------------------

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
