Return-Path: <SRS0=AHfl=CY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831FFC433E2
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 18:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 230EC206DB
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 18:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgIOS1h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Sep 2020 14:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgIOS1U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Sep 2020 14:27:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1489CC06174A
        for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2020 11:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=ajhWPqMPABc7JVPLiJ6fjvd2rzSoPSkLmchFxeBWqCE=; b=AcdJLfA5HWj1xMUDOZECC8UXnc
        MNVCHs7/gTQDtrtRN5oWvBGDMudi1YolC9OxEqYassKf+8vaxv+yK0tjU1TiwdAeEhrot3xN/6wEM
        WD+6/xPL3/8BL3j7AYsgNV+vaskzFLxqrFqrzY3sgXvB3+1msjX91PkS2dMLpuQzJcU9qT+2biGn/
        UBQSh9uihm7dUqKLGXokpLr2kgHxV2zgVynBuAPTW19eI9Kc3dn7N0gZD429PCpNfeLln3rko544h
        mvaPUCy5Vm4F2fBiRn9Qs6wLWRJE6P4F9ilYPlfuI0Rd6hIdVFeeqhH8lB4QSY13uNXi5etCD6Nxx
        zX2cfOXUdG76L9OGfv8JrtfDNOnVMjtRsWTrNWbD/4ACERIIBbS7WgQYh0mwhzeX6oLB8h0WA1bOD
        Uox4F+p0l1dhMqGldUuicN0grpqUxk1r7lRXpLiBAfXPSjd+EZ5gzv9qAONkUTdLEusfiU9qEaqmN
        UY6qEivoaPd3I6u7x8kYz4iN;
Received: from [2a01:4f8:192:486::6:0] (port=61064 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kIFfh-0003KC-El
        for cifs-qa@samba.org; Tue, 15 Sep 2020 18:27:17 +0000
Received: from [::1] (port=26204 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kIFff-002LJz-Ii
        for cifs-qa@samba.org; Tue, 15 Sep 2020 18:27:15 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14492] Minshall-French symlinks cannot be searched for with
 "find . -type l"
Date:   Tue, 15 Sep 2020 18:27:15 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14492-10630-b4a3uPAED5@https.bugzilla.samba.org/>
In-Reply-To: <bug-14492-10630@https.bugzilla.samba.org/>
References: <bug-14492-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14492

--- Comment #2 from Steve French <sfrench@samba.org> ---
Presumably have to flag files which are 1067 bytes with an additional check
before returning their file type in readdir

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
