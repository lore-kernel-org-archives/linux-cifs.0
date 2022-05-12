Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC43C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 12 May 2022 15:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354081AbiELPup (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 May 2022 11:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345425AbiELPuk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 May 2022 11:50:40 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F47F68BC
        for <linux-cifs@vger.kernel.org>; Thu, 12 May 2022 08:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=1v5tkm2KVUIHGcu0SRbOF0GJPQYAuFpUO8dJ/+EuRc0=; b=OR0fBHIMj4i3qvzEJ6QnuvMqn3
        cyJmJYftWICzg6VHX4EbEfbXztKdRu2cj+11WUeZsi6UlcgjBaEO6/Kanm3ViibQ7tIUM0MVwocQA
        wxDw3rkzdj1nthDBeOf+Pis/P470qCzbi0+/hayrI1QO6HdOCYuJJLhp8e/VVwz8ziHm1NCUYqGD1
        pVzvyxK7+6cKulCLvo584EiTCGiNgpDmbtj8ZH8FquebwB+Cj8au0xAlZvQunwPol9GqcLr57Jfql
        123fOg5jjRGxdS4Iwnho0QWZoYTNIiRfYqbtMNwqUVp2H14lTCrItxh+MpD3FJJflOLph0l0lfL79
        rHxCzlQXWjsCItPab84/O/J8hWUvayVD7rQXjq8p1a5dRzu9iCg5hHkUznxT/65myAj/8BNomAJLH
        1cyf1LCl3NUBxhgGpBpAUk2XaMpmjN2VlQ05CTX/OvlvQXcC40eWP4v+EEktsjjkZlEc9KRVM1NDU
        APP9b9iObfOjN1+7PQQ463LS;
Received: from [2a01:4f8:192:486::6:0] (port=39314 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1npB5I-000XBV-Kz
        for cifs-qa@samba.org; Thu, 12 May 2022 15:50:36 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1npB5I-000MX3-4h
        for cifs-qa@samba.org; Thu, 12 May 2022 15:50:36 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15051] EBADF/EIO errors in rename/open caused by race condition
 in smb2_compound_op
Date:   Thu, 12 May 2022 15:50:35 +0000
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
Message-ID: <bug-15051-10630-OWCP0iuTdt@https.bugzilla.samba.org/>
In-Reply-To: <bug-15051-10630@https.bugzilla.samba.org/>
References: <bug-15051-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15051

--- Comment #2 from Steve French <sfrench@samba.org> ---
Created attachment 17284
  --> https://bugzilla.samba.org/attachment.cgi?id=3D17284&action=3Dedit
created patch based on Ondrej's suggestion

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
