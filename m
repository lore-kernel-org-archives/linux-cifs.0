Return-Path: <SRS0=AHfl=CY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 893CBC433E2
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 18:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12461206DB
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 18:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgIOS07 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Sep 2020 14:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgIOSYw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Sep 2020 14:24:52 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7FDC06174A
        for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2020 11:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=bMbyzxc0gfz4RASkkeN49i2rX4Xc1wk+5/T1npeWOT4=; b=yQKYud9kcryxNdNkQ6NC/uoS3x
        0PlKOSqjBGhxR7yiyysHbV2q+FJp2To+B3zDuFbWBzVcIGLbZ0IAVznckbVWl+3Z/fv7Zq7q+My/4
        5uK4wakDMlhHDbEgUqg4TeM8i0YVRldIjkQBoq0hAXknd4zwGi6i8Fymn/tXkToHFYZBaiFAWVfCT
        iEwwTx64ks28ULnP1oinL+CIXR7YP7U1nV57xmMh/tyYFoT1tQakCbVK7sev8+vSK9E5lrtuUAwxb
        TLGn3T2n9cBqDdPvhr2hmLzVrVeCGbg+QgnTWjoaz+03u8NwiKcbmy2KLM4Ivebh5Gs6nYsEtZjIK
        yCrxlHmV0/FbM4+Y4LCobH8s7M9jVnDSy9ZxVPFNjRmoo7Nwi+X9ywW0pN+3EKsEQuXJgfPZrlcfi
        kgmokMuq/FRaGCp1xr7L5T8kUI00UYnqy7kFLrmZBVhLQtFcQNAVoHSEttx59+7VlhHfJePYZYUnW
        3k2YGAPXK6tnijUxuwWZM9do;
Received: from [2a01:4f8:192:486::6:0] (port=61054 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kIFdH-0003JR-QV
        for cifs-qa@samba.org; Tue, 15 Sep 2020 18:24:47 +0000
Received: from [::1] (port=26196 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kIFdD-002LJm-1Z
        for cifs-qa@samba.org; Tue, 15 Sep 2020 18:24:43 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14492] Minshall-French symlinks cannot be searched for with
 "find . -type l"
Date:   Tue, 15 Sep 2020 18:24:42 +0000
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
X-Bugzilla-Changed-Fields: bug_status
Message-ID: <bug-14492-10630-B8wHvxa5Fh@https.bugzilla.samba.org/>
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

Steve French <sfrench@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |ASSIGNED

--- Comment #1 from Steve French <sfrench@samba.org> ---
I can reproduce this to Samba as well.  Investigating

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
