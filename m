Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33F7C433E3
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 11:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A28462071A
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 11:57:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IN6EHKhu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgGWL5u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 07:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWL5u (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 07:57:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A64C0619DC
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2020 04:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=01vlyTCSGUnLVFftXo87YXs4dsa4wvjeVjTeifh2fdM=; b=IN6EHKhu4c+HRd4YANQErMy4vI
        MgujM1xMrLC0SEz9haKaAj+TREDCf8fnkDFREXIFVGGcIpfe52nVzzDoW+m5KbjmPKB75NvblqgdA
        SBLSjnQNbZVbA3xE6V73cKtsx2Z8Jf6LTi6bD21cA3X9hX5YR7SQjo77M5OwYCJEisS8BHpX1ReCQ
        TburAN6fvsUQclIf+JSmvYK81wV9f0u6jRN6VD1FR3zOBBhCoquXGMwB1Ecuf+FAKcdklV2MmI5u9
        k/g8+Fs+Rf7NwbxUqgR/aEKVXVT6FKFnSD+/jFz8Hik5YkVAq5A/8uB+eQXqIAPJdYQSQSIxbXAZG
        98Mc2v2zj79mZ7OBxDYP5iRshITERt/HMeGwlMrQYw2uhjiU6NUxwmJECDVK3Epm2HhIoYnmTjzPk
        yrhzJqwu0H11bKquo4XdMzg5gRawEZf6S5Q7ZXFQhTbLh4+ekG1YAJUbN27dwFRvt2rtpHWN1H3R5
        SRLG1H/CsOzaRbg7gpSaiE3O;
Received: from [2a01:4f8:192:486::6:0] (port=43178 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jyZr8-0003oK-Ll
        for cifs-qa@samba.org; Thu, 23 Jul 2020 11:57:46 +0000
Received: from [::1] (port=29138 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jyZr7-00712n-Vu
        for cifs-qa@samba.org; Thu, 23 Jul 2020 11:57:46 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 6908] some programs fail to explore mounted shares
Date:   Thu, 23 Jul 2020 11:57:45 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc bug_status resolution
Message-ID: <bug-6908-10630-GLegfTUns7@https.bugzilla.samba.org/>
In-Reply-To: <bug-6908-10630@https.bugzilla.samba.org/>
References: <bug-6908-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D6908

Aur=C3=A9lien Aptel <aaptel@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aaptel@samba.org
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #1 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
smbfs is dead, Linux SMB fs is now cifs.

closing.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
