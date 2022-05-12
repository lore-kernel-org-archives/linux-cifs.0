Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41500C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 12 May 2022 03:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343673AbiELDdY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 May 2022 23:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245183AbiELDdV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 May 2022 23:33:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14C7612AF
        for <linux-cifs@vger.kernel.org>; Wed, 11 May 2022 20:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=5jRqQcDbckc2l2lutk3zSYvz3AvRd2rEBeMTLRHtqak=; b=00hRFSpE59uhh/p1PkDWAPcHFI
        pPyUYYYv14kqdEOQ4XKOhPDW27JcOkoznGioS/mDy31Bn7Loys5SBAuGymGvPXDMqLdwLzrJYLTyU
        VDD70lyMGdeIVpHpk4htuMVfUc8om4HqvUA/MoC2yprnsVzEwEN3iO1kMaYU/zMMG2sQJw7TuJp0G
        ttbUMYzu5jVpJUynrT8IfBYPW9WYyoOJU7aW0Y0EAgGfNq/E+05J3fpLfQRRafzCIJY2jA8XdXdi2
        sSbdVYgSxj+JkXOmQxxGXTiNnbiq/6b/rSua7CH7AGgOYJ98T2sjvhYrA4nkt9jacMIyrs+dJiDUj
        UBNAiiUDj8dxsnQ3rqYNf+uXfj9ty5H9m5e/OFLA5/AeSMkfiUozYWiJ1KBBBPE+2uF7mMPDiy0ZC
        bJEUdnHmFJnuk7b0g6Yx2jZPBROnBBlPucdxcrNU9sAjo5APES+rYwFRZsu7OKXUw0HvTuwy0mjC+
        quDiFoem0BMBQM2hgrt08xtF;
Received: from [2a01:4f8:192:486::6:0] (port=39260 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nozZk-000RpX-FN
        for cifs-qa@samba.org; Thu, 12 May 2022 03:33:16 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1nozZj-000LEx-Lw
        for cifs-qa@samba.org; Thu, 12 May 2022 03:33:15 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15051] EBADF/EIO errors in rename/open caused by race condition
 in smb2_compound_op
Date:   Thu, 12 May 2022 03:33:15 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status
Message-ID: <bug-15051-10630-JnYZZgv7qv@https.bugzilla.samba.org/>
In-Reply-To: <bug-15051-10630@https.bugzilla.samba.org/>
References: <bug-15051-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15051

Steve French <sfrench@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |ASSIGNED

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
