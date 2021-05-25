Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B6B0C47086
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E501161401
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhEYTor (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 15:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhEYTor (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 15:44:47 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BA9C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 12:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=MLSCNhr5jw0Ti9tzzvfeL1cjjAgXyNPC63aWYlsvRR4=; b=tJS7gBoznYTslUt6UrfzlLfp5R
        sZjdg34J6ZoJ4foT55GhEVhW7nmetaHZgUzm4FX2/alPmVQJJP5J2BePB+vRrmLxBr5aKmUMDsUMx
        Zq8cBV/Jlsbg+8iPGmXgYFtwpvf04rXrvLccftO8KEyoSOTRFSVc4i9tQ45DaUdMnM3nZ7oR0IZBk
        1VDyzCzjaMJemKE8YwQwLjFow14jJKT4RPy3dnXZZQ40z0Ce2XOBmbKbYf9PAjI68RpNdd/ZkOJP0
        gqCnGBqpXm0IEJ8LhUi9Se/sYKeOKNAfqaYm01WhfcLATJTvfBnh9JQdiiNvq+u4uEajuNvvQPeDO
        3tMqnvfRZlyBjNkanyZrPI/cGauApvO3TZDomHIbPKxNu2PEmfl7EYbWgBGZodvO74sS8PsZ1pVAr
        ODiUAzxe1D86xK/EIquhnH8NcvdMtfiQUlhZFXIzfk4GzJKjDQ7QZVHB4khwKtcTayt3QWH5Jg7vd
        7mFIUpb6CHJgXwha0arAFnx5;
Received: from [2a01:4f8:192:486::6:0] (port=55972 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llcxO-0006qj-Kt
        for cifs-qa@samba.org; Tue, 25 May 2021 19:43:14 +0000
Received: from [::1] (port=33856 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llcxO-008jxV-6h
        for cifs-qa@samba.org; Tue, 25 May 2021 19:43:14 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 19:43:13 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-14713-10630-CVigzmx8ko@https.bugzilla.samba.org/>
In-Reply-To: <bug-14713-10630@https.bugzilla.samba.org/>
References: <bug-14713-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14713

--- Comment #18 from Steve French <sfrench@samba.org> ---
Created attachment 16629
  --> https://bugzilla.samba.org/attachment.cgi?id=3D16629&action=3Dedit
session-setup-response-when-no-seal-on-mount

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
