Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5864BEB64DD
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Jul 2023 00:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjGVAEi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Jul 2023 20:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjGVAEh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 Jul 2023 20:04:37 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE5E12F
        for <linux-cifs@vger.kernel.org>; Fri, 21 Jul 2023 17:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=AQLffwQK1YXvmIR0NCkDKqeW++DaE203huRVYhUGXAs=; b=vVn07TtimNH7+Lucg9GER9y/Ao
        kHttHaPiOxVfKkmgD02a9r8g8SRurUmya7+mS7WwSd8fQrvjpd1oidkN9dtcD2/GdlLdulv1XD9qk
        YRogxWDAabMK/IrPN03AIq3Zr/xuLSdQhLuzri/fPpzUbEUH5C5DP16BjL5TVvkdibTugHd8kVvRN
        e5qCEGv4rSivqP/vQQp/Y0P0RaRVOjdTb9do16P+k465kiXxdZglZSRLhYSL4T3snYcjZJdyvdnQI
        vRPCgFAUtawNQx6JA4SvU6yENoa4VsOBPA+sGwtxvHmOgp3bKBB+EJoE8IJ96fJmWas1mRQbYKnzo
        cYJ0DWmAlrdDwdcMvNQlJ1GwEa9mNZa4IH0tCMZao3hYCFr8NvdOFP3ZMhSz5tlQX9Evoqwd+4iBH
        l5f2qiri8+UAGAtg9bAXf1EglDvZTAEh80JsudrOTTlqEWY98IuEP8YqEpX6J/0sP/LyUzkY+InP9
        jIFhy1xszN9FRy7MaOgm5U+7;
Received: from [2a01:4f8:192:486::6:0] (port=50940 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qN06r-003Q4z-2V
        for cifs-qa@samba.org;
        Sat, 22 Jul 2023 00:04:33 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qN06r-001ejJ-EG
        for cifs-qa@samba.org;
        Sat, 22 Jul 2023 00:04:33 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Sat, 22 Jul 2023 00:04:33 +0000
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
Message-ID: <bug-15428-10630-qV3KLHKM3E@https.bugzilla.samba.org/>
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

--- Comment #1 from Scott Harvey <sbharvey@verizon.net> ---
Created attachment 17994
  --> https://bugzilla.samba.org/attachment.cgi?id=3D17994&action=3Dedit
Unsuccessful mount.smb3 after windows update

This what was logged after Windows 10 host was updated to kb5028166

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
