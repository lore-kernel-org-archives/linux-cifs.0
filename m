Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957CDC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 13:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344261AbiCUNug (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 09:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238525AbiCUNue (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 09:50:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0832BB37
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 06:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=ihm8oHddnPjCBQxVnq59k/5yU6j+CZcX15GWxJmkEdI=; b=rpIlHoyfrX86HkavFmf19tINEg
        otrYNvr9eJs2dJmY6G1M3F27VTMIC2wRVOzPwdu91thQpiepFM3NoEsmOiiJOkQnO7b7ETYszeNvD
        3tUfL3VIH/yxabohU/wXiaMvrO6FDQRCaBCgrafzWDoprx9s/4mBNOgy8Q2U99jdgjZguQNdrqZAj
        Y291yKnQPNJm+TWmU9bWOcRXORCQWyZoY8bfTbPWC/GLHcMWIiqPJoul5/T83a9kHAma316MP9z0G
        BSAOPGwZA94DOGz+XAYbNn0jSvAqrctiAzUkiPjsad4L1ak1ZGpW3L2XJzn1KUYg+arZhy6me1/9W
        4MX7N4KtutL2Tkf8y9kjmOFiGdR2TrVgpM1GL01IxF/hx+uKDwY7wOT4IJTGprPazVAPC/TMvSPtN
        RjGjiccAHw/lnQ1g4eKUJ0fgoT1uUtG0M6rm9W5GSdysLd5pEIYVkFWX63gR0erRgu3Dnt1oeFQWz
        hFLB2D9IW1/gYsSu8AwNs9fF;
Received: from [2a01:4f8:192:486::6:0] (port=56590 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nWIPC-002do7-Dn
        for cifs-qa@samba.org; Mon, 21 Mar 2022 13:49:06 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1nWIPB-001dqd-T1
        for cifs-qa@samba.org; Mon, 21 Mar 2022 13:49:05 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15026] Partial arbitrary file read via mount.cifs
Date:   Mon, 21 Mar 2022 13:49:05 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jbe@improsec.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15026-10630-I4ibVbCrjj@https.bugzilla.samba.org/>
In-Reply-To: <bug-15026-10630@https.bugzilla.samba.org/>
References: <bug-15026-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15026

--- Comment #2 from Jeffrey Bencteux <jbe@improsec.com> ---
(In reply to David Disseldorp from comment #1)

> Please correct me if I'm wrong, but I don't expect that this would be exp=
loitable
> on regular systems unless mount.cifs is installed with setuid-root, or an=
 attacker
> somehow has access to the "credentails" path fed into a mount.cifs invoca=
tion.

That is partially correct, note that on a vanilla Debian 10, mount.cifs is
setuid-root by default:

$ ls -l /usr/sbin/mount.cifs=20
-rwsr-xr-x 1 root root 35600 Jun 17  2018 /usr/sbin/mount.cifs

And likely it is the case on other distributions as otherwise the following
message is returned:

$ ./mount.cifs //127.0.0.1/share /mnt/share -v -o credentials=3D/etc/sudoers
This program is not installed setuid root -  "user" CIFS mounts not support=
ed.

It however seems needed to either:

1) have privileged user rights to trigger the bug, such as the below line in
/etc/sudoers:

testuser ALL=3DNOPASSWD: /usr/sbin/mount.cifs

Which is less likely but possible.

2) Have the scenario you depict where a user can tamper a mount with a rogue
"credentials" option value.

This greatly reduce the risk IMO.

I think the explanation is in these lines of mount.cifs.c:

 115  * When an unprivileged user runs a setuid mount.cifs, we set certain
mount
 116  * flags by default. These defaults can be changed here.
 117  */
 118 #define CIFS_SETUID_FLAGS (MS_NOSUID|MS_NODEV)

I expect some people to use rules such as the above sudo one to circumvent =
the
problem.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
