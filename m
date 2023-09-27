Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E1EE82CA1
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Sep 2023 14:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjI0OzQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbjI0OzL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Sep 2023 10:55:11 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A889FF5
        for <linux-cifs@vger.kernel.org>; Wed, 27 Sep 2023 07:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=PA88LiMH66xeB6k1tT8NDW+MP7A/RP0CTimaZmbOP7A=; b=oY983GqCJ5BHsTZLWl2BbCJ6Et
        3q2ZwWL7TXU25zkFRhIMqfx8UPqPEM3wDjVv5bzJ1pMPMrislB2xqTY6utmxVpYH5yUOeUJG/OEmi
        VplnHkTYJIUJkYGryLuzknmqsej2d1upWsJnqPa+UIfwQAXnO6UiMJ0BMIe5AJXCItC1e+2KVeX8n
        AhqM1XLAGA6ezhVa2W41TABE3+0GhDdQijROe4UAlOiUT17H3duoGXVo773vVP+b1E1s8QjABfIgg
        y3FJUZFTtdYhDBcj81oUHlPPMqPS76QfDzqZjuVFD3R1djwQDLZuMjhR2ci8efLNz40j21sVi53zH
        kb9q6gNC3RCDGFUnHAtefun35/5xCAUHOoZz/GLMORM/xVQlTiXkuZg7G0lcVyemVPW1TnmL8iPDu
        oOOYDGeBkcKIg3EpIaKhVFE4fbdQhlRXPnOG9Wm7crJHbW22GuYhHRYdqnWjL1mM4RSZj8G8mgbUF
        ELKA1keDsh/r5IsMQXxlg9sg;
Received: from [2a01:4f8:192:486::6:0] (port=19646 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qlVwS-00FeYw-1T
        for cifs-qa@samba.org;
        Wed, 27 Sep 2023 14:55:08 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qlVwS-0021Fd-9S
        for cifs-qa@samba.org;
        Wed, 27 Sep 2023 14:55:08 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15480] Mounting Azure Fles Share using cifs-utils fails
Date:   Wed, 27 Sep 2023 14:55:08 +0000
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
Message-ID: <bug-15480-10630-RqH1dcwUQk@https.bugzilla.samba.org/>
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

--- Comment #9 from Steve French <sfrench@samba.org> ---
And check the network configuration for that storage account

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
