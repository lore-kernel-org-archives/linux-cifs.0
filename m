Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8041AC433FE
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Oct 2022 01:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJIBUl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 Oct 2022 21:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJIBUk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 Oct 2022 21:20:40 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19D51EAC2
        for <linux-cifs@vger.kernel.org>; Sat,  8 Oct 2022 18:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=8CiClzylQFdDu1AQwlXTkN+ESK3RcFr7X0LqZrqBSWM=; b=t/20+sG/U9aVpOFzY9rwxHxNIM
        TrzLHMKn7HmJ04EY9bscqBSXWR5yIHqip4h/Dq4lb4m0HAtuQ3cDSqqq677vRc06b1ZBQiEmMGRM+
        1sLgzz/LMaGvbrYM9+1aRXJTqYZ5EYQlOeUPGPf+6PdW3RvA5MJXbm1JuzglCjnwrguWZyxBWV6tR
        lUiKMQv+5+YSxNBGQuNmTL47unIFgaDRJhOIjlKsP6yWfASW3g02n2HV0xC9B66ZaW8Y+/ueHw2Lo
        OTVXqBV2SyJ8IKBiZECFTK5bOQuE8mqi6DEv/hhuyhmVUD4/azqGw0UigKk7kZOge0lBA67vFrZOQ
        H/y8wOTl7lHS7AJuo4Jol9ZFsjWQfd7ff+ZRA2vpAsghVH5cI9u3XYu7JJU11/vhzyRUz2ZmsZnLE
        O/9XJqk+fGvoWQbp5/YQZITP/Oz/4midSFZ2zQOE6R1q15EzOV1h1d4F/jcnHUvZAz8xShzHlK5xV
        ilpwU/DTjvfp+KltC3QoyZ14;
Received: from [2a01:4f8:192:486::6:0] (port=60726 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1ohKzc-003XjS-CU
        for cifs-qa@samba.org; Sun, 09 Oct 2022 01:20:36 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1ohKzX-0004Rq-Mb
        for cifs-qa@samba.org; Sun, 09 Oct 2022 01:20:32 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15196] New: O_APPEND not translated to FILE_APPEND_DATA open
 flag
Date:   Sun, 09 Oct 2022 01:20:23 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-15196-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15196

            Bug ID: 15196
           Summary: O_APPEND not translated to FILE_APPEND_DATA open flag
           Product: CifsVFS
           Version: 5.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: normal
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: bjacke@samba.org
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

While testing the "append data" ACL permission, I wantted to try this out w=
ith
cifs vfs against a Windows 10 machine as server.

"tee -a" is using O_APPEND but it looks like cifs vfs is not translating
O_APPEND open calls to SMB's FILE_APPEND_DATA. So files that have "append o=
nly"
permission but not "write data" permission will not be "append writable" by
cifs vfs  in cases where they shold.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
