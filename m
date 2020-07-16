Return-Path: <SRS0=Z9xR=A3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6950BC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jul 2020 17:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A4542070E
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jul 2020 17:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="V4cGIBRw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgGPRuR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jul 2020 13:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPRuQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jul 2020 13:50:16 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0866BC061755
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2020 10:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=aUl/qN8mb4yuArHX+zrn35/3U1G+f0yMtutFKCr+k1w=; b=V4cGIBRwPB+FXOSefr9RwOAuxF
        kG4W4YElg8ciHDTD/TDNpyQsKLeETTqXLGRbvIYGeQzk/MYtbUMk76bzXcediPgzlxLsQ4Ehe+unD
        qGKs2VCa9sczCiY7dF6w0Ta085l2avbuVHFGHbTQwErB7wRnzXc5u+2IcC03ISAO/7vH0xU5HqVaW
        4gF+2UcoEiNiCziugI1QIYFMFMu+rjhI+mTarFDB7lNs7tpnU+/gz+DD01KC1Xd3giyUKtcu//5G7
        en8+tfvsUjzUtIdj3GtnK7Wy0DMUb1avv6pKAEgKvhy3tLuOtPBTfwREnWWzHKuBBT2zXcy6c8v/X
        xIOXBeyAtNR6dDZD4O56ogb6MK68a13hq6dyK7HsWxsHm2+/FZaq7mKhgZ/fjMuNwww493mGaf0GM
        QFEuqHZVaB1kGRC0qdmJv4ffv1SHBoiM/QFu4M0nTx+ps3/bw2di23DLw9eywNlEXlG3LRjuIBcVy
        OgQX+JSjd+3IoHYK8liqs0FB;
Received: from [2a01:4f8:192:486::6:0] (port=40324 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jw81N-0002X7-7k
        for cifs-qa@samba.org; Thu, 16 Jul 2020 17:50:13 +0000
Received: from [::1] (port=26282 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jw81M-006OYz-T7
        for cifs-qa@samba.org; Thu, 16 Jul 2020 17:50:13 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] New: Shell command injection vulnerability in mount.cifs
Date:   Thu, 16 Jul 2020 17:50:10 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-14442-10630@https.bugzilla.samba.org/>
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

            Bug ID: 14442
           Summary: Shell command injection vulnerability in mount.cifs
           Product: CifsVFS
           Version: 2.4
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: major
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: vadim@mbdsys.com
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

mount.cifs command is using "popen" library call in get_password=20
which allows for shell command execution.=20
Example:

sudo /bin/mount -t cifs -o username=3D"test \$(id)" //1 /mnt

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
