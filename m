Return-Path: <SRS0=kwxs=A5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FD3C433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Jul 2020 14:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 583402070E
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Jul 2020 14:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="m+XkyU38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgGROOW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Jul 2020 10:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgGROOW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Jul 2020 10:14:22 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1512BC0619D2
        for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2020 07:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=X2UI1roGY5hu3zGrDsEwfDoDliQP/p3MAYn8cS627Jo=; b=m+XkyU38E2VwX7mTbYHiPhwVyz
        egYjKQd5n5JSOye7w4UPmEEYVVOJrXp/apfVw3vOC8h0LcCthEDYbfKrQWShVUESP7iQGKbSJHtWB
        7BsGQqw3TZePUh8MKwZZCJm8t8G8bdWzpO/6btlUixu/uqTUt9FLV892iA/grER06Q0Asbh7mzgZH
        qaDhqf0W9PHD89LAXTBKuCd80Ea2BHn/1hV8jnfGr1QAHgqbkglJrUFKh039PKzp2QSD4DDltxlla
        a42I46sHF6P927a2wueA5p2eJJ6SK9vF74pdhdAZEXN4OZGKYBuH9w9jPz0nlbA5oAMLFwQo+EcQt
        sDZxJebY1gGvsMo0jt3ZA2sIOHcDe9Howthh0Hh4B1VBWd5FqD5FXX+mqk2W5r8DJpij8/9Ob4KUG
        UbVmMD9vSY6NRlASCdzxHMniiGd5FYuRahKOvWrYzjQX8OV8J3NDH9+Yh65X8oewn2wSqMIGfPDeQ
        F/r9KUctt/Wz0VYksrvhfxKd;
Received: from [2a01:4f8:192:486::6:0] (port=41128 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jwnbX-0003Dk-4k
        for cifs-qa@samba.org; Sat, 18 Jul 2020 14:14:19 +0000
Received: from [::1] (port=27084 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jwnbW-006Ywl-Pw
        for cifs-qa@samba.org; Sat, 18 Jul 2020 14:14:18 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] Shell command injection vulnerability in mount.cifs
Date:   Sat, 18 Jul 2020 14:14:18 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.4
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: vadim@mbdsys.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14442-10630-kdBBebwLE5@https.bugzilla.samba.org/>
In-Reply-To: <bug-14442-10630@https.bugzilla.samba.org/>
References: <bug-14442-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14442

--- Comment #6 from Vadim Lebedev <vadim@mbdsys.com> ---
(In reply to Lancelot Bogard from comment #3)
I confirm, even if systemd-ask-password is shell script
the arguments is not evaluated as command.
Example:
vadim@sys76:/tmp$ cat ./test.sh
#!/bin/bash

prompt=3D$1
echo prompt is $prompt

vadim@sys76:/tmp$ set -x; ./test.sh  '$(id)'; set +x
+ ./test.sh '$(id)'
prompt is $(id)
+ set +x
vadim@sys76:/tmp$=20


So it seems the patch fixes the problem definitively

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
