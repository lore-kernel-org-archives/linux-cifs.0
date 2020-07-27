Return-Path: <SRS0=Ubs5=BG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA395C433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Jul 2020 21:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 979FB206D7
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Jul 2020 21:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="AHptFGZI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgG0Vyt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Jul 2020 17:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgG0Vyt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Jul 2020 17:54:49 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABCBC061794
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2020 14:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=ZfOA0+fbNuaPaAfdvkVPPPHGjGCVuiBCoBdfIwqVtno=; b=AHptFGZI7ENDRj8i++xLIljHj6
        a0JZmH3elwHANTttEmeBSU8ibMw+mYVnXOfhs304KGWOKFcLU/qOPKk4j1f1psWvx46e2Ise26l98
        60Es57d78RaZx161PJjCs690nx3yjTgbEgx5guhkxWgslqXSJ4cvi8XQP7VcX52oPWnrpFpmdKVcE
        AdvEm9Kd4OpU0V06RZINnKJlSQIaEnlQv6xGNXy5mrdUeQTLPL1WdZZ8Gx0rWFlmONzD5pk4/YUwD
        kOUKIB3R5eHwo2ht1b3UzWY2Fx8dwEt1Vfi5pJYp6gR60Fz54IRLUpRQWe6E6tyPhHTcfRY1EY9wV
        yj5WCLc2Jk+vSWXGQAo3+5Z53Loi1SA72XuH6RKI6T432DLtaWNVQxModuWQfzIMnB+yKZOZ3Kc0Y
        8u8vSAmzBcXQbTC4m91DXXniwo6gEom6XREwd4qowXPu0sPDADd/RWMcjx2r7kP2pj665SQlEginh
        ivbB8wCCUzkhXzXnmOnuBZrc;
Received: from [2a01:4f8:192:486::6:0] (port=45710 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k0B54-00074r-3X
        for cifs-qa@samba.org; Mon, 27 Jul 2020 21:54:46 +0000
Received: from [::1] (port=31662 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k0B53-007aAl-FS
        for cifs-qa@samba.org; Mon, 27 Jul 2020 21:54:45 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] CVE-2020-14342: Shell command injection vulnerability in
 mount.cifs
Date:   Mon, 27 Jul 2020 21:54:43 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.4
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14442-10630-pRyz8q3MI1@https.bugzilla.samba.org/>
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

--- Comment #17 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
The content of attachment 16135 has been deleted for the following reason:

accidental binary upload

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
