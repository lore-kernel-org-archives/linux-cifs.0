Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013CCC433E1
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 16:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C43F120658
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 16:29:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="lbgzK/S9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgHMQ3Z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 12:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgHMQ3Y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 12:29:24 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE543C061757
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 09:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=D+fRNvIaOvRW0PtdYSetldI2oPUr8NTYkfXM7s3jjck=; b=lbgzK/S9cPMhj7sQN1DXlfnmfQ
        d1UREI6/sxjlfFTY6vco/ZyHz137mY6DCijXDTUOIVI4hzKhQeXrkYIR+JbwTa48+NdUzJidDOhic
        EemMo7W190w2MdkDPQlpa1u1aObWlpXeRyh59KFAI2Pw/uvrBELw93SiHBqdm7TrZLvUOWiW3JI6U
        C6rWYQenZo9TXFKK9tLLVQmKGKgQczJOxpjQBCCzkSOGuyyIiRhzYjiOFC7GbTO4WtoN484m29YNb
        23n3tdmtbZnIzb+OF8r708eyB69u/bRs0l8KdHq831rJh7CNf6oHyJV2lkX2sN1fVPpXfAYdnec+O
        BD2UzhUH7GUbt3FIR4CS3xr/wBwYPjmrwyhahC3GFFYC1Sjh7BLoaVVi0XS8V0d4MdLDFCdIxov4S
        hqgELzeIRX3txNkqULopubUrpTWiiBrjrB70Pyp8kcYn4jcmfkobRnrsDtBbtDOF2WV3sdDGHEaJt
        /VeBHxf6iMwiEdQx5gNOBycm;
Received: from [2a01:4f8:192:486::6:0] (port=53866 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k6G6U-0002cr-JE
        for cifs-qa@samba.org; Thu, 13 Aug 2020 16:29:22 +0000
Received: from [::1] (port=39820 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k6G6U-00933z-BL
        for cifs-qa@samba.org; Thu, 13 Aug 2020 16:29:22 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 9283] getcwd: cannot access parent with cifs
Date:   Thu, 13 Aug 2020 16:29:21 +0000
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
X-Bugzilla-Resolution: WORKSFORME
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status qa_contact resolution
Message-ID: <bug-9283-10630-f9wZD6PRoM@https.bugzilla.samba.org/>
In-Reply-To: <bug-9283-10630@https.bugzilla.samba.org/>
References: <bug-9283-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D9283

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         QA Contact|cifs-qa@samba.org           |
         Resolution|---                         |WORKSFORME

--- Comment #6 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
works for me. also comment#1 said this also happens with ext3, so there see=
ms
to be a different problem.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
