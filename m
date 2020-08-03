Return-Path: <SRS0=CZtn=BN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B323AC433DF
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 12:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F03720738
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 12:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1o97qi/K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgHCMVO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHCMVM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Aug 2020 08:21:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96007C06174A
        for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2020 05:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=qN1NjSx5im30OB1I5oLiTCwq+z4BpRhDmkBK4CwW9T8=; b=1o97qi/Kv0jG18UfT6c7sUH/c0
        u5/x0i3Bq2h60CsDxWQc8D+b9GA7CkdNkPEU+dVlGbkKAi3FB6gN415aUFDUNoxZaVnRY6GH3LSdi
        W98ngnDb9vbasUONR4FIv2/4Yq9jmFfGTfVIHGhEZXPE1SZbaSNwVSQC0xhjk5SMf3/i1kXaqXzZc
        JxbfnkHXiifgn8qA7yzeNB22WWzmu0cuqcD3mggxUS9MZAHEGCGDg5q5Pidgrm1wqWy3kRzRN3liq
        CtbhduoqiyPjW7wCmDir3ZE7Xu8huJDN3S7uD8eiiKG3vbVTPbD/DxuiBTe8n+0UQtHkN9MYDbzWb
        TY44jgteEr9zpinfStb2GgfISrcv/6nrbbpMJ66fC01za5pwvUj1/8KhzyGT4zze43mMhY8lkm4Sy
        7kzF+Rao1uLVm6CCOWoJ7m67H+YNjeeErNaXGQNZ/trWw8y4cVi3Jee5o77OABqDsBk//Vjlfeeo6
        EyIyG+5snNhFXeYwRq1BBarM;
Received: from [2a01:4f8:192:486::6:0] (port=49328 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k2ZSo-0007xd-BH
        for cifs-qa@samba.org; Mon, 03 Aug 2020 12:21:10 +0000
Received: from [::1] (port=35286 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k2ZSo-008CcC-38
        for cifs-qa@samba.org; Mon, 03 Aug 2020 12:21:10 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14454] cannot get symlink file attributes and target with
 cifsacl mount option
Date:   Mon, 03 Aug 2020 12:21:09 +0000
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
Message-ID: <bug-14454-10630-OhP4Zrljfo@https.bugzilla.samba.org/>
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

--- Comment #3 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
Created attachment 16160
  --> https://bugzilla.samba.org/attachment.cgi?id=3D16160&action=3Dedit
dmesg smb3.0 without cifsacl

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
