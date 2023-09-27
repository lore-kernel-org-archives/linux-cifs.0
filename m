Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C8EE80AAE
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Sep 2023 14:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjI0OOU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbjI0OOT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Sep 2023 10:14:19 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A831F193
        for <linux-cifs@vger.kernel.org>; Wed, 27 Sep 2023 07:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=1Fqs+wrZ3y/u4V9/XRs+2VZOQfCwxw9YCPbjHbCICoE=; b=1rBcvReF7Tt/+a4b20H66RW7B+
        jbhm23/aQdFdwFaemEDf+o0jG2mpi2y0H5ljuNfs3zDsjyUa7roprAEF5enG+EOjYuIR5ZSX+ouz0
        uVTBpJzbZfGjXVLUeNWe5Nuy1AnSr2WFzg3u9QTLgqHODPn3kPSJJd/CBQqJgFCeb593ISuN0ZOVI
        b2Nd0JDevtzS+E9VTud/ueGTmROLXpEdwiEuhecpfRBIZg3klv9XeDETsLArbDB3Mh/0SVipZGv3a
        xt1SsUSZDiryKslZkxz6k2dzJJetRn7dUXTcz4sQJ8V+Y1nsDbG5Z6iVlI/xJjP2bozsi9MG6w8bT
        tej/T8Q3M14jjyY7/fEqmnEnZrhrDL97SI9GR5aLM7A3G/N/eyjVnor0LO1P6+V+SeFn4jdX++5cC
        8Uaqi0fdR/L1/aGjP+6b4OyDQVUOJeERL4PAot8ZzEjs9W9yG+ZMskt+VHiuEQwYJxCCsw72fdBmb
        sU0oR0B7TXBB3GEXDkm7tvug;
Received: from [2a01:4f8:192:486::6:0] (port=39260 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qlVIs-00Fe9w-09
        for cifs-qa@samba.org;
        Wed, 27 Sep 2023 14:14:14 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qlVIr-0021Bk-Qc
        for cifs-qa@samba.org;
        Wed, 27 Sep 2023 14:14:13 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15480] Mounting Azure Fles Share using cifs-utils fails
Date:   Wed, 27 Sep 2023 14:14:13 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sverrir.jonsson@thyssenkrupp-materials.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15480-10630-zapno6fq8c@https.bugzilla.samba.org/>
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

--- Comment #7 from Yonz <sverrir.jonsson@thyssenkrupp-materials.com> ---
Attached is the TCPDUMP

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
