Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3783DE7D0A1
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Sep 2023 00:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjIVAOH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Sep 2023 20:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjIVAOH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Sep 2023 20:14:07 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF6FF9
        for <linux-cifs@vger.kernel.org>; Thu, 21 Sep 2023 17:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=1/Mm2pVZnsaCbpP+BAeF7daeTfaAgu/Ri8PyaHP8atg=; b=vhqmCKMv1NSH5geOto/SqPYZM9
        CojEdHgIMev+Ooy9jzYnkK6b68J7ikgLUbtvBUMcpRZs3AHEfbO4zxuZ8947YJf4siGanHyO+Yxpd
        HL39H0Hoi/V+NJysjCAtIjNJakBG+F1XNXAllIWjh/U/Yr6DMRHoeLaCdhHzaaSLHdCox7yULvHJr
        Ox33pFSYOhy7V3lX9CHTF0tEtVmk1TZUera/zfWFMOeZyeLlUv4u9iBJ8AefrwdMMv6HM3v54XkCg
        9IbQbWiK9xwqRyDaVptb7L7LFcqiHy1CdIAaLlb+cJrRT576TtC7I5b+3Eu88mraHRw5CbLQsKSwz
        2yjlr4kLlXhnYqwWE3dU7yW0QeT9TM3XD1LPuBtR3v43bN2B9GfEfFQVfXnAt4jwt78bQgsY11Lk2
        5OzntxK2W7Jvt+M4IomP9MDZNpiVDqux3a1cfVrN783lkPFoSixKi6ZblM9bFz59LVSKU1dkb0dLH
        EGnOseKdUFhKzjKt41O4JWAp;
Received: from [2a01:4f8:192:486::6:0] (port=54740 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qjTny-00Ekuu-1L
        for cifs-qa@samba.org;
        Fri, 22 Sep 2023 00:13:58 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qjTnx-001WUq-Uy
        for cifs-qa@samba.org;
        Fri, 22 Sep 2023 00:13:57 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15480] Mounting Azure Fles Share using cifs-utils fails
Date:   Fri, 22 Sep 2023 00:13:57 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15480-10630-JUEW6vq33v@https.bugzilla.samba.org/>
In-Reply-To: <bug-15480-10630@https.bugzilla.samba.org/>
References: <bug-15480-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15480

--- Comment #4 from Steve French <sfrench@samba.org> ---
Since this might involve looking at (Azure) server logs, it might be better=
 to
open this as a Microsoft Azure support case to explore what is happening

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
