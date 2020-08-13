Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACDEC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 15:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB65A20829
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 15:17:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XD3C1xZS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHMPRg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMPRf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 11:17:35 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54028C061757
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 08:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=5qPaJZVhPBeMkAiMIPa7Q5EDctXO5wMSmO6Gc5un/LE=; b=XD3C1xZS7a1cC9Jjeulydi7Z3K
        qiF9SWUeI0n0B7Xz7Fi797kIGpdqNbbozQeIin/TjeOxd3wkgHmBd5gWMWUNJcoIMphLKniSct544
        IIdtCPOIzXCFrHJcSgfYFMnq9vEdbJ4QU63MBJ3YXxeKlxrEBQYtG+vEMEUp8V9sEMJzXdbFLbey8
        UC0BiCnF2E89S9fyVBRfxrgjlOg3FegYxqvdEmYD/DvQhUAj4D/VecVsv7R70OX4CAPQuQ0mFh1A+
        MW3uimOutmpFiBNWYuBZfX7XNpQrBmxyMJejQ2QGHreoQmdW3tfJmeBO+6miRFFyWYKrjGHJIBwNV
        oxX1XeKB8SijkItVrlrbSxDEVZozV1gZZwCpzCNQI2WejV9lCwVbnvZRkPOOEQZbeGV+KIX1g6qGL
        UsSDIEkNiq33M6so5pXIg7OxY6SM2oZSmAV1CQNPTHrkF+QLgZ2Y2ZU0L4Si8Y9wl5bDLkuOo/vW3
        H8bZw9ZdA2bbVUPTsVCR9OjC;
Received: from [2a01:4f8:192:486::6:0] (port=53788 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k6Eyz-00020v-H0
        for cifs-qa@samba.org; Thu, 13 Aug 2020 15:17:33 +0000
Received: from [::1] (port=39748 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k6Eyy-0092zN-AD
        for cifs-qa@samba.org; Thu, 13 Aug 2020 15:17:32 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 9006] Improve handling of network configuration switch (e.g.
 from eth to wifi)
Date:   Thu, 13 Aug 2020 15:17:32 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WONTFIX
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: resolution bug_status
Message-ID: <bug-9006-10630-Ni0wGauCSH@https.bugzilla.samba.org/>
In-Reply-To: <bug-9006-10630@https.bugzilla.samba.org/>
References: <bug-9006-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D9006

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|---                         |WONTFIX
             Status|NEW                         |RESOLVED

--- Comment #1 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
this is a generic TCP issue. Either SMB via MPTCP or QUIC might make such
network transitions smoother in the future.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
