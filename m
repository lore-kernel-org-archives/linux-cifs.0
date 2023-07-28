Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C9AC001DE
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 18:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjG1Sym (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 14:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbjG1Syl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 14:54:41 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A16D19A7
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 11:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=snbAexWPzO5cpdwnQXDftHI6Xpr/E2hWs7PrwDGBj8c=; b=nBG4YogHak5UXnOn50u2M5lA/w
        CzwDh5ctvExJHppvxUU6+Y4VC0D5CsQdifV6TVQTw8XF8xrt7JS01PJyp5VCA1TNRBsQx0stUJ0vt
        M0qw5dCj6GlbllqZu4t9/1H91qNH6d8uognrmGSwWHdbHem5aMm+MHPPVqt4DHztL5/nimopyHsJN
        EwXmfIEm5n7+m6Ztu7Gqv5aLQNEFOEx0+fAg1tlyUlIwrWy+2lBdnpjdR8To74MWYiwev40xIYcH0
        KjGj2YTl9462AoRdJ29c6Zu4OyiozWqWUCpimkiINkOO8haF5Eb3UvpxTnsBZBsjD8hTyjD48KyN4
        sV3DAPrBX+A56pCNsPUVNzFz8Oc/m+u7bxuqAa8vl1b6q+32NZx0+SYs7QcWQ8aesWQXEbjFXEAmp
        FuR5+gkhEkrNredyC6VC8plyLVSrJtdrhAaki3Lxj3fcoj5meL9lLcak0tEboQfZ/gxGZRXGYzSo8
        Frru4BrQbR2EWCRzrx4SR9/r;
Received: from [2a01:4f8:192:486::6:0] (port=57438 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qPSbg-004k3a-0y
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 18:54:32 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qPSbf-000OVm-O1
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 18:54:31 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Fri, 28 Jul 2023 18:54:31 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 4.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sbharvey@verizon.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-15428-10630-dxLAtjdl5q@https.bugzilla.samba.org/>
In-Reply-To: <bug-15428-10630@https.bugzilla.samba.org/>
References: <bug-15428-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15428

--- Comment #7 from Scott Harvey <sbharvey@verizon.net> ---
Created attachment 18012
  --> https://bugzilla.samba.org/attachment.cgi?id=3D18012&action=3Dedit
pcapng trascript shows successful Linux mount of Windows 10/11 shares

The mount.smb3 operation appears to be successful after confirming with Sam=
ba
version 4.18.5.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
