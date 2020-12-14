Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67310C4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 07:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19413229C5
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 07:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgLNH4H (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 02:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438928AbgLNHz4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Dec 2020 02:55:56 -0500
X-Greylist: delayed 1081 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Dec 2020 23:55:11 PST
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2CEC0613CF
        for <linux-cifs@vger.kernel.org>; Sun, 13 Dec 2020 23:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=90HtEYACGhMgpDNRLvxeyIcTAYeJJhU1oYe7c3sTfIY=; b=W6At2IJkglrWsxsmmgDO1VWdw8
        XBEHvLqk+IfplkOydwCGTyTg7hekqPvftiUYrHipoWS35kKsDzT24TSD4L0ny6/QBVPeeTDP4w+Gp
        S4yxgqP9ed9RfeY0t9cXk1bHKNPFU5xROXygtrxw4MMrRy74vPw18fjDSxgs17DXB8QzdaUfuo15h
        OQLR1rArGEXEPxLSB2j0Q1QSoBrUPhdASvDaJcDdx5Gm9Hjxlpju4JX1tsuwMOdiXifaWH4FEL43A
        rvNr6PPBcGQg1duoxUp9XjjBdhZl+KZcrR2Q6hMgS6hpOabaQTsvq6Zei0xO541bxOq6j95wjgbJ6
        kNNyhxvlhJ+/zm9mkgdbaiq/bSQql2Fi75YnH3dkjVYfKPK1FSvhaxMkjLWWqBzHN0u1/hk381rzS
        ZTNGshMia/Sh8CsEPp0z2PrwpehbiWSUVTHDAOoejjZF6SQ2zCOzPsA2m1ZN5Zseffee9X0DdysQG
        aFzIW7w7GK3xdVcJojiDNp2a;
Received: from [2a01:4f8:192:486::6:0] (port=49560 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1koiPq-0005TP-Pv
        for cifs-qa@samba.org; Mon, 14 Dec 2020 07:37:06 +0000
Received: from [::1] (port=19000 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1koiPp-000tCn-VH
        for cifs-qa@samba.org; Mon, 14 Dec 2020 07:37:06 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 10125] cifs client returns cached data of deleted files
Date:   Mon, 14 Dec 2020 07:37:05 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vl@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component version assigned_to qa_contact product
Message-ID: <bug-10125-10630-WsTMTA7A22@https.bugzilla.samba.org/>
In-Reply-To: <bug-10125-10630@https.bugzilla.samba.org/>
References: <bug-10125-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D10125

Volker Lendecke <vl@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|Client Tools                |kernel fs
            Version|3.6.9                       |3.x
           Assignee|vl@samba.org                |sfrench@samba.org
         QA Contact|samba-qa@samba.org          |cifs-qa@samba.org
            Product|Samba 3.6                   |CifsVFS

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
