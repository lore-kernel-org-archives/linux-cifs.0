Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA41AC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 16:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiGYQtP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236639AbiGYQtJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 12:49:09 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9E5CE35
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 09:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=VeZAj2ylVztu4RrKV9Xuvtz/WCvLhSNrnok92qub3eU=; b=AYCl21znpZENipP+8U4jYB0rLS
        cJh/LvjbWxiOnDt6LjVVKJvlJpQWHz1b0meMpI+XRH+2qYaH7suPJ8aRykwDbE11nKKVhY2PaAlhB
        SPgia7MKTUkMxNVORkspY1Icm4oqMwRoH6xuzzd/uiBh5Ix8m/dkXULVlVm2mMYcE8EAM3dkeVosF
        eILZMLyly3w7S2PtPpYKf5f1lHhuuPddNGTxRfgLwTBXxeC40Oc2RNDkoiCcsA4iax2GC+QkQyJpe
        UpaQX6Zs65kv/6qlYt+K7XXo0O7Tuy8kWieULK6KF5Iqv1Id+EtS/wn6IM1dk8rTYIxusJogPMpzd
        I3blOpzH4LmY1fQ3XMY7XblfNRVUWqXtq2HyitmMxk598en3yeZ1AVZPG+AIN77fOTBdInAn374Zi
        NJBrDKPaMx6+qfRf8anDkB2hLB6vOi2EXGk5VZcrs5nDs3QmJeJ6dHmF3kLOHSv2s6e3Ayrtj2S0w
        eTrVCcjPipRlknyhOpH7CrwB;
Received: from [2a01:4f8:192:486::6:0] (port=54674 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oG1GU-006QEy-2E
        for cifs-qa@samba.org; Mon, 25 Jul 2022 16:49:06 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oG1GT-001mLc-Ag
        for cifs-qa@samba.org; Mon, 25 Jul 2022 16:49:05 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14201] DFS mount does not pass context option to actual share
 mounts
Date:   Mon, 25 Jul 2022 16:49:05 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: palcantara@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14201-10630-OXclHx0znC@https.bugzilla.samba.org/>
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

--- Comment #1 from Paulo Alcantara <palcantara@samba.org> ---
Hi Patrick,

Does this still occur with mainline kernel?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
