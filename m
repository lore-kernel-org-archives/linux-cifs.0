Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BD7C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 08:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345321AbiCUIje (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 04:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345232AbiCUIjd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 04:39:33 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816541152
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 01:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=bUShvee0qx8IlcYnB1PXqDAsDhsXiUVBta2H7Srk8mE=; b=2F3mh/ePlKuH0GTO6SIHxnYZXe
        wS/aKsS2y1Dk0pw5zXcTNpCNz8+0BI4a4v4oxvYu5GfIiUXk6rYA8fnxQPjbDAlRVei0HGa6VozJP
        w049eMu18ZZ2o1HI0cNGRPdXh9mOiwX3N7UdqTiyPS+/bjzIpZ1S+sToo1wvUU4QlM9RVsW6PmVL8
        amdqkvJYJ6fRbSqVwN/3b3CL1pPVgchT9XobfHvHz+Z3IxgmPnLurK/ZnsJmgp2CiVEMiFC1JJm19
        VsPLEr425xmkx7GxoPKnOKHzPEaeEjOgo2+C7jRez9MCR+fNvtVeVHQ7rATr8bGXjOZucmXNk4RN3
        bwAxWxGQcmmNJ7cyqzFhz+fm8rzdHF7PA081MTF7SL/usCoYCiZ7Uq3gXvkaN2f6chAlruTbpL+Nw
        B5cCjxKwyPFcEX8Ty7h2E96M4lNoVrWR3yc6mwtY2EACUrtSd7OvriCOnA5rLddEZuslDiAp+7vx4
        UieSF4h9i88GFq0Krb+pteHm;
Received: from [2a01:4f8:192:486::6:0] (port=56438 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nWDY6-002bDq-Oe
        for cifs-qa@samba.org; Mon, 21 Mar 2022 08:37:58 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1nWDY5-001dJb-N7
        for cifs-qa@samba.org; Mon, 21 Mar 2022 08:37:57 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15025] New: CVE-2022-27239: Buffer overflow in mount.cifs
 options parser
Date:   Mon, 21 Mar 2022 08:37:56 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ddiss@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: ddiss@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone bug_group
Message-ID: <bug-15025-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15025

            Bug ID: 15025
           Summary: CVE-2022-27239: Buffer overflow in mount.cifs options
                    parser
           Product: CifsVFS
           Version: 5.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: normal
          Priority: P5
         Component: user space tools
          Assignee: ddiss@samba.org
          Reporter: ddiss@samba.org
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---
             Group: samba-devel

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
