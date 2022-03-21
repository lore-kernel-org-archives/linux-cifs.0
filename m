Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2ACBC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 12:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344255AbiCUMPE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbiCUMPD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 08:15:03 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A885BD30
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 05:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=wBXHxTEhuz9+VHJdR416353cjd8/AsVVP63ocifb8sg=; b=YH3w8IBB9SyBSKWajnENu9VrzY
        KqRUWSheAqot1m79gsXDEfIx9PK2/gnVZj56Ul0ydubtfdniZ7E+VVrk0Eipq712PVexIy4TaQgkw
        xVs54kBvnATxkYA/MgM3sBx12RFAGTN08NOuG543P+1Ww8wkOwV72Hc9lm8MugDBkdRB1aeiearPg
        x/cXhu8oLOP9YfQgkoQ511L5iu9R9liWtAU6tKcZ9mWIAzYJsTUoAb7oEL7WTbt9gncVs+5fh1fJO
        l7mGoN+soX7xNLSc/wTUpQLgs8by9wBtgZgl0shBE8boI7SC5dfiwgClCFMCFDjrOkWiWTV0StTRg
        9t3dYHyLbPeJ+y3SRVBrvbTmC7Bi3o3rB7IzbQ6CkICDsFk6bJ4hzGBivUHqsTa52zlTucQYzoQiK
        zRAO7cSWyfzCXd6eVOV1/E/Fm2alTZr3ym2mPXIpPWgWSzqzHEOve5wS6hA9h/kEWGmtOlpJLXSHW
        ADHotjfy1OHgGhVBD4iW3jEM;
Received: from [2a01:4f8:192:486::6:0] (port=56468 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nWGul-002ceU-19
        for cifs-qa@samba.org; Mon, 21 Mar 2022 12:13:35 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1nWGuk-001dbR-4x
        for cifs-qa@samba.org; Mon, 21 Mar 2022 12:13:34 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15026] Partial arbitrary file read via mount.cifs
Date:   Mon, 21 Mar 2022 12:13:33 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ddiss@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_group
Message-ID: <bug-15026-10630-KUxzDHhFE4@https.bugzilla.samba.org/>
In-Reply-To: <bug-15026-10630@https.bugzilla.samba.org/>
References: <bug-15026-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15026

David Disseldorp <ddiss@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
              Group|                            |samba-devel

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
