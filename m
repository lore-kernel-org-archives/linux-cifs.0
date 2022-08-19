Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25915C28B2B
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 18:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiHSSrz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Aug 2022 14:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349248AbiHSSry (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Aug 2022 14:47:54 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC13DC0B1
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 11:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=Ig50zYIqibixa783TtTxu5zXNYvuP3e79XrSDJAQHHc=; b=hf0LG5sKWrBn2PQB+NNhmRcJhi
        k/zRshe307mrcDQB6VSe3XdUepyhDW1qT8ZRmBL0uxfEeX/08LBV4eoFB41ZGYpe1gFrvLtsTM53l
        fJpYYHQbwspiO+BbCFpd8GBxKC5oMp32DxGZ6lhn8sj8zzANqqO9aXIcxu54GlPe1LEkvx63Inxk4
        INwH5L77hs4tiivtrfwr8O43XKBJdgcr2SpSzxK9+wumrxAWvVobXpgBGJh1QkeoDojf2/pXSP7BH
        qpDUOvXpk4z024f6FiohuSQ2Wg8AkLmBepAjHyNPjIhn8iKmAYXGUfNN7VXolegtXGaGiXCsZ4LLA
        RUTLtFhsudFiMsRRsIqoyvkJzWjIpA5XkpVTm7kUUJdxc5EwPUjYX+ZREosGbB3s+uBi/3JxnxiTB
        hta90J7+ioFJtesFLg05DwlR23wncQB8bzcsannZVPVeLC+2cDtCmdsa8S+W+xLxlAfBqkVPGh7lK
        0S16PovyqjK1GjdqLBzVOPuK;
Received: from [2a01:4f8:192:486::6:0] (port=32616 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oP724-000t48-3k
        for cifs-qa@samba.org; Fri, 19 Aug 2022 18:47:48 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oP71z-000Xdv-6S
        for cifs-qa@samba.org; Fri, 19 Aug 2022 18:47:43 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13570] CIFS Mount Used Size descrepancy
Date:   Fri, 19 Aug 2022 18:47:43 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: Samba 4.1 and newer
X-Bugzilla-Component: File services
X-Bugzilla-Version: 4.15.9
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kato223@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: product version component
Message-ID: <bug-13570-10630-1YFUfIMjTg@https.bugzilla.samba.org/>
In-Reply-To: <bug-13570-10630@https.bugzilla.samba.org/>
References: <bug-13570-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13570

Terrance <kato223@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Product|CifsVFS                     |Samba 4.1 and newer
            Version|2.6                         |4.15.9
          Component|kernel fs                   |File services

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
