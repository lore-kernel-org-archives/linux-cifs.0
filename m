Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56C0C00140
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jul 2022 13:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbiGZN4u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Jul 2022 09:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239279AbiGZN42 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Jul 2022 09:56:28 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B502870E
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jul 2022 06:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=I1BXhPCDW3D68OMFx5FiotuTRbykGmO6EhXNHfi8WgU=; b=3v9IwLWZCbqgmgKTJaWg5bly7u
        YNZeYH+942xItVMHAxS/GKzhkECgOlTKzilkdpOMwiBfUCn6N/ZiLz83AyujAe+70t+RRuaoQghVo
        NupuJoxCK5/K3qjWVUghyUWDolGEQmntp8EbW6HU0txPy+aRCPJ4z1ouOR7iLwWPKYsSVOFBKrDQz
        6kYSWO2qyl/llu2OTYPJDCLGI6z0R+hhwFb3GIzkjOHMeOy3imloUjkPoKAwc7ScOsMz7ObbjJW0q
        ziFDCTniBTK8j0wWf/DVQpeQBEvVyEbFGhE3zcgHAV2cshPseCrILBHL9b6Y3QhyqPe0Ub3YJ7+lA
        JNNeAroqzDBHUHIWx4UnLtt7Mba9R+l0glo28nkLkSxTvqeenjm3FlLpZAn6h+bt+XLCfNUMo3dWM
        fsH7GzUnC13SPfRnTK3HW0WiDPKIkvBg7KkEBBJbUUWnIP9ts7ic/q0cuDIPH9IrdyFDFfjem/B4O
        yb4CBQwA5ughZ2kDHa9Hrfm/;
Received: from [2a01:4f8:192:486::6:0] (port=54782 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oGL2U-006aMl-4r
        for cifs-qa@samba.org; Tue, 26 Jul 2022 13:55:58 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oGL2T-001rdr-Lg
        for cifs-qa@samba.org; Tue, 26 Jul 2022 13:55:57 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14201] DFS mount does not pass context option to actual share
 mounts
Date:   Tue, 26 Jul 2022 13:55:57 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: patrick.boeker@haltec.de
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: resolution bug_status
Message-ID: <bug-14201-10630-8Hdh6HrhVa@https.bugzilla.samba.org/>
In-Reply-To: <bug-14201-10630@https.bugzilla.samba.org/>
References: <bug-14201-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14201

Patrick B=C3=B6ker <patrick.boeker@haltec.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|---                         |FIXED
             Status|NEW                         |RESOLVED

--- Comment #5 from Patrick B=C3=B6ker <patrick.boeker@haltec.de> ---
Works on 5.17.5. So I assume it got fixed in the meantime.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
