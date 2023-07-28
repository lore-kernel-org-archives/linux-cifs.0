Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F52FC001DF
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjG1TER (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjG1TEQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:04:16 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C293C03
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=wD+gi+XoprZdTPv+OFVJAcrXiMvMgwdZLXOhSmyGxfk=; b=KrzhZh2cpOUUgaV8upJdHAYc+1
        VJnhzulrjI5a327GwNNS0UZhvoB6JxMf6aLdCuj9wCDCq7/LfXJ4+s+vxLN47FmxeXy0q5KVe7SqS
        SF4BVzqntBH6vziMyxhrk3fFhArwe9GtOFFN/9J9DpfwCvF1Ly3VKrzh+u9e0Ovey+YVgxyEDRYdS
        W9SzCc/2lG/hOsbZhLM6x9iTKMQwA9UieFqZiDq6brjlMo8KnJfPcEOMQF0nhOYooKhJDNj7khMwk
        WKu9VkJ5FIHkxKe6lkdcQqoVsup0LqXP3agUMmqJaKCQjIKZHUQjccHe7cH0eBS2oBNQ3/7LIJey7
        yNAoJVIeTyIItYCMglcfTph1Onqzf41dNfAZYWCWafPxNLyzydDOeky/hCysHdidxnCY0mVZv+x/L
        wMiQcp+iJwfBeZckhZOYuneTRwLPmaX/bY8vDDklVCgohYPTIRaK8YIGrZ4w5bO1yXCsatzjqv5w8
        5ScqCZEKfXIrt4YIIfT5mgFt;
Received: from [2a01:4f8:192:486::6:0] (port=57892 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qPSl1-004k9z-0w
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 19:04:11 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qPSl0-000OXI-Hu
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 19:04:10 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Fri, 28 Jul 2023 19:04:10 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15428-10630-c8BrYaDgfI@https.bugzilla.samba.org/>
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

--- Comment #8 from Scott Harvey <sbharvey@verizon.net> ---
It seems the more detailed comments about conditions of samba domain server=
=20
and the windows host did not make it into this reporting I will attach test
files
that go along with each of the pcapng attachents. They are small text files

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
