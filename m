Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D82E82CA1
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Sep 2023 14:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjI0Oyh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjI0Oyg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Sep 2023 10:54:36 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8438F4
        for <linux-cifs@vger.kernel.org>; Wed, 27 Sep 2023 07:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=eo19jLShvkWn43v0+6abJhrnyYTofDA3u7AycKqYYyg=; b=xvxFHxAP3s9APJeZn0toUR3FsD
        b8xwsHNg1w52/ga0kolA/25TGNyP4Y+DwRTJZ5cAEWuXdZuvufegq2M6evhltNoEwXHT9ZuZpbFZ0
        JtrUh99WHWNCacosrBDxow4wf6nGCWOcNUAL5XxyGToYwjDMDbPjo1DQ+MTn5xW0oH36nmLjdHoxl
        RM2YhnLI2uEPa5pWph3e9lNbaoLl30jTfcZqFLFGNgWqt/v+IItVSVX0AvBN+9arDn1RP0H9BI0BC
        KOVl7AQo+VPNDynzl2+UFbniJs7JsFobNtzbRLPLz8MmK24SEbdoobLFI1Cc+xK6lqGecemiljF2G
        cDnEm5nCo/7sFygpBkKRPZonAN1Klo4GjnNP6654lUKPr7/9TsmpHrabNYobJ/fTqQkLSIU+0LzHo
        5tmIAWZ680IG0oDxFPWj0fKpq+dKgrCuH8mM2VnocdMGLlBQbYur6VUgy5Ga3rpcdAJ02MNB+ufx2
        qBODOaaKQvWM/P5VwtZm3mkY;
Received: from [2a01:4f8:192:486::6:0] (port=54212 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qlVvt-00FeYM-1X
        for cifs-qa@samba.org;
        Wed, 27 Sep 2023 14:54:33 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qlVvt-0021FF-4J
        for cifs-qa@samba.org;
        Wed, 27 Sep 2023 14:54:33 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15480] Mounting Azure Fles Share using cifs-utils fails
Date:   Wed, 27 Sep 2023 14:54:32 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15480-10630-cvkg5rG2jm@https.bugzilla.samba.org/>
In-Reply-To: <bug-15480-10630@https.bugzilla.samba.org/>
References: <bug-15480-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15480

--- Comment #8 from Steve French <sfrench@samba.org> ---
The trace you sent shows an access denied on SMB3.1.1 session setup
(NTLMv2/NTLMSSP not Kerberos).   The username looks plausible (based on the
netname context sent, it matches that), but the obvious question is the
password (either the one stored in your credentials file or passed on mount
depending on how you mount this).  You can also verify that the credentials=
 are
ok by using smbclient //server/share -U username%password

If that also fails then access to the network may be disabled from some sub=
nets
so best to contact Azure support since they can look at the storage account=
 and
networking configuration.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
