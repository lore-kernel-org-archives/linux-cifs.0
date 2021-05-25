Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68CDC2B9F8
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8480613BC
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhEYTKj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 15:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhEYTKi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 15:10:38 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B549C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 12:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=vdTsvPv3eiAI/Y4kQ6lmw/M3XaCVViZXa74Qf0Ax8gk=; b=SHzppx/xzAeHjk3QvQxOaipdOc
        mZb4QFe9stbaqXxDO1uFAo/8S6EV+I7I8rZkE/G9RIO3Dd3duiQ8ZLP1OCdlxQumfZ6apA3oyuSYZ
        QiM9om/5NLO4OOCMg52HM9oV7ElFBckN/VwKKSM7PWmmD7TnQV4duXSB+Q0SbC2aJvK/+gNdjok5Z
        qdqYcswcvu3ogpfEfUJwk0rEWznVTJpAzm6lhhByXmEo333ldoX4dtmxmSGkoLxAt6zUn/b0kv9rQ
        xpcYDTPk8tZ10yokszTgVEoZXYWVLSIRVE5t60svoiDPb8eE+IdblRDnFM0CyEUR/EBPBp8g1BZwX
        iyrFWP7xLd7r4t9KfFgOT4NdVCgFntpG3k8eK99s1lgtw5vj3L1GE3fznU1eDYbmtVifikLgH3I/C
        eymzr0ZgGMm3QHdyTUb2Dzhw0/+pmQB71VNgIH5rr0unql/THjzX6fU2kLe/kM1Yr7Uf4cbc0/di3
        4pQ4rol92wigNt2dObPkP9Wf;
Received: from [2a01:4f8:192:486::6:0] (port=55928 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llcQM-0006aM-13
        for cifs-qa@samba.org; Tue, 25 May 2021 19:09:06 +0000
Received: from [::1] (port=33812 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llcQL-008jvN-Lf
        for cifs-qa@samba.org; Tue, 25 May 2021 19:09:05 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 19:09:04 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richard.flint@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-g9MHmXHSx7@https.bugzilla.samba.org/>
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

--- Comment #11 from Richard Flint <richard.flint@gmail.com> ---
When I omitted vers=3D as you requested, I definitely did not specify seal.=
 I
have attached the server SMB configuration for completeness but the most
relevant settings are below:

server_lmauth_level=3D5
server_minprotocol=3D2.1
server_maxprotocol=3D3.1
server_encrypt_data=3Dtrue
server_reject_unencrypt=3Dfalse
server_signing_enabled=3Dtrue
server_signing_required=3Dfalse
restrict_anonymous=3Dtrue

I will get a wireshark trace with vers=3D3.1.1 as you requested shortly.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
