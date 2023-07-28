Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBADC001DE
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 18:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjG1Soa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 14:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjG1SoV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 14:44:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980D12D42
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 11:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=TfkKKP4Uj1zh4nhosz3K+5JC9HJFi40zWhiSL6agr64=; b=GHKE20LsE/WV0FdCUOj0AusQ8R
        x9GVqw6fNjIBaogk2yvO0oBoVv3tFTb4VnNvgWifAf1oQ5BL2U4nBeHKe2RM2Pv3H2+CKuXl2TNzR
        4eIhgHOuMl9n64jiA+NjW5yKIonPyXlc/gtdRW0fZFu7PM8dWJmmdiSkwqgUadtss3O8bUO7Jkor9
        VFqQR5489qV5yXKM2EPoVtF16OvUImLktF40TQHQoPQfAHuu24w81UWK0VxavH5YSQqBD5M7zwPbA
        Vpvy8ZldIylkVUBZNbYuHU0ZI3bQtwJzXRgWNsOoOfHdhIDuFk4yl4hrZH0LgvjQ7xHAXbNPBOI4P
        ijcqSGy1fm3NfJVXghx1YHnbU47b3oAhx7pBwPHkE+VeBDZ8UM7klMTTI2dPk1rrhFHnil3R7NT65
        7227IDV71Uv/+Vpfgji3yRTPoz4DZtOS9P74s9Yzr6b/Jx326qe0z37+v5YGh9BBuIbH8/bjzf7RT
        BGQiTjH+qZlorC63eYWEHBnT;
Received: from [2a01:4f8:192:486::6:0] (port=50238 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qPSRi-004jtt-0Z
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 18:44:14 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qPSRh-000OVH-F3
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 18:44:13 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Fri, 28 Jul 2023 18:44:13 +0000
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
Message-ID: <bug-15428-10630-BAcuhFl4hI@https.bugzilla.samba.org/>
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

--- Comment #6 from Scott Harvey <sbharvey@verizon.net> ---
Created attachment 18011
  --> https://bugzilla.samba.org/attachment.cgi?id=3D18011&action=3Dedit
Windows 11 and Windows 10 host failing to mount Wiresshark pcapng trascript

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
