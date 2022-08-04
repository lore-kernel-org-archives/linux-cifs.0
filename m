Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B901BC19F29
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Aug 2022 03:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiHDDB4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiHDDBz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Aug 2022 23:01:55 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D4D45073
        for <linux-cifs@vger.kernel.org>; Wed,  3 Aug 2022 20:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=kO3sYsW3iKEtcn0+tWBbTia3pa373kwMNK7PpNNX+TY=; b=aveqv1e6hJkINYaicwyOfbWk4h
        GWhxASxJFmgSC053tRdIsD1geWXzFwXpoIiwJZUCa/qBjyXXza6D0MJET+UJJk+X5OKIDVB2Ud5Cw
        ehuij47/SaeFJPaZj4lTq2u9OpTuUgIsiKu+5gNc8i2tRIdzdYLle8smgJ4ohXmc4mbwpxDsGBDBm
        40oqlmRn0cuUZk+R6l9QW3anvbAIfKzg+T7bZM74D0jmMJtMRZHETxZW/p5EmN9U7u9KuAp9jF0kT
        csXKW1VXEhAzJ8Wwroa6sHS8dZ5P6Q1xX4yQkTuKMCRZW60sHbvhwPN1lcruAL17AURXNutxMRQlh
        N2ZBnkUKmtYgJ/fYf5obpu/hVAmAerE06Sjqi2HY7+6+bfMjUzDriytmAjLJDlbnX0uUrmRXGPNSJ
        13hzC8pUnZwoWRcFsMrmN1Dl3C38jd8KzsuHxMLvRBGE4WebaIdCFp3blUqePSc/DWgs1qhKuZuFZ
        2Ul7cUnzX6xniNBi3/GSQQ1q;
Received: from [2a01:4f8:192:486::6:0] (port=57236 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oJR7P-007yEf-0m
        for cifs-qa@samba.org; Thu, 04 Aug 2022 03:01:51 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oJR7G-002hqA-5M
        for cifs-qa@samba.org; Thu, 04 Aug 2022 03:01:42 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15136] New: Access to cifs gets stuck for a while (>20s) after
 disconnecting from network
Date:   Thu, 04 Aug 2022 03:01:40 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 4.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wangrong@uniontech.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone attachments.created
Message-ID: <bug-15136-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15136

            Bug ID: 15136
           Summary: Access to cifs gets stuck for a while (>20s) after
                    disconnecting from network
           Product: CifsVFS
           Version: 4.x
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: wangrong@uniontech.com
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

Created attachment 17460
  --> https://bugzilla.samba.org/attachment.cgi?id=3D17460&action=3Dedit
patch for code update

After the network is interrupted, a new SMB request will wait for a
fixed 10 seconds for network reconnection before sending, and return an
error if it times out.

Because 10 seconds is too long and there are operation retries, system
calls (such as stat) take a long time (greater than 20 seconds), which
makes application respond slowly.

Here, the duration of waiting for network reconnection is exposed to
the user space through the mount option, which is convenient for users
and applications to set according to the actual situation.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
