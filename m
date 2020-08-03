Return-Path: <SRS0=CZtn=BN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A069C433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 12:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 782D1204EC
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 12:20:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="RXm71EmD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgHCMUo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHCMUn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Aug 2020 08:20:43 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0F2C06174A
        for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2020 05:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=u0hheG/BA1R2EuvTv9rXxGD7qUPrDqBThYjFSUFNxuE=; b=RXm71EmDqjFMKM3NhAUzz8pqsp
        MrPybdc2oDrjhybFdOasiVWxJQMAylcdftV6M3mGz9yRnZcWbdNg8l87EbvyjXRehb0DEYdGgWsjY
        fVmIBJ8ftl7YYnun+dYovhWTudBId0w0uysorvMegFHMJVJOvhIHr+Du9xvzryyBnDUYzLOOO+d9Z
        RSbtRULDeMWnsDf6RHqJ4YUCe3EiPwYp6X7AFSv8L95uP1X1Hqfp5namg+xx4w1lT7leDFFS1qcZ3
        EAOL7h0eZW998ioPq/99pF0aorEjWyWDPHWr7h2a/Xf8ESSqab9WNhaElNWtudivZj5rFyFrjYi6N
        kN6IoSNynHFq11t611R17paVUpikkUSqPGGFuBpfGQ85UCTYlY+qxF031Bh/sume6srFnkAw7j2xE
        nsTUmx2Qemg16UFBlBBfWwU2J426tbpwFuK3eIvZab9Nu6A8W92zrCOPXBXUSuTT+oexIIYurSJEq
        YfCIBl7WuXwgqpoLIZrpuWgu;
Received: from [2a01:4f8:192:486::6:0] (port=49322 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k2ZSI-0007xK-Hx
        for cifs-qa@samba.org; Mon, 03 Aug 2020 12:20:38 +0000
Received: from [::1] (port=35280 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k2ZSI-008Cc2-Ch
        for cifs-qa@samba.org; Mon, 03 Aug 2020 12:20:38 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14454] cannot get symlink file attributes and target with
 cifsacl mount option
Date:   Mon, 03 Aug 2020 12:20:38 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-14454-10630-zmfyb3A7C4@https.bugzilla.samba.org/>
In-Reply-To: <bug-14454-10630@https.bugzilla.samba.org/>
References: <bug-14454-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14454

--- Comment #2 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
Created attachment 16159
  --> https://bugzilla.samba.org/attachment.cgi?id=3D16159&action=3Dedit
capture smb3.0 with cifsacl

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
