Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03F4C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 16:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbiGYQmZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbiGYQmY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 12:42:24 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD54CB5E
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 09:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=tifqieUUTF3ZqHgc9LZmsrK9sH/WKiguBwfA5scvT8I=; b=vmjbbNwmbmjsDneLAVem2YoF1l
        OS5YFZXi2HS+nA6GGDzEISAxijPcudwv9Cd8fW/0BYAmnfdMXSKGvuktYH4BpgSM5tZS3q4PPUfnI
        bEc97XvL4E9gFccylY3b49Ez1Fs9K5osPGTKtCVmxAm46Qi2P+43+oZIN3j8Y5g31cS3WS0ng3Z5Q
        5m7sf+0N1sPtN9EbL+Nos8fvE9DxP5QBssn7szaGrOHTFOZnS3n8F9PV8SyF1DavP2nkid8NzuShJ
        F40NU+ZzU7ULnpJBTKCq11+Ml+8XIGYp7xX/aaiBYz94IOLkb1Qprwd1NRiMuVOtt71/2aA9nuimu
        t8kuTk2TW098ZOyKqSeS5ZS8iU2cJSQZSOc8XYs1lXKuUZgigKiEDuzEPzcfwWDGEoMrhtL0MM88a
        Baa8fAgeVEf/YIdqSaVXsmRT0Wy6MqPltF8tMsl9c1wJ/Q2U2MkDYceE9iL3TjWBzdN53+OUUYZQY
        KVwgRYnHIdtMEkSkmn0upqwb;
Received: from [2a01:4f8:192:486::6:0] (port=54664 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oG19v-006QC3-Uu
        for cifs-qa@samba.org; Mon, 25 Jul 2022 16:42:20 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oG19u-001mKw-H0
        for cifs-qa@samba.org; Mon, 25 Jul 2022 16:42:18 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 12379] Manjaro 16.06: STATUS_PATH_NOT_COVERED from a Windows
 Domain Controller with DFS
Date:   Mon, 25 Jul 2022 16:42:18 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: palcantara@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-12379-10630-dfkFc9Xnpd@https.bugzilla.samba.org/>
In-Reply-To: <bug-12379-10630@https.bugzilla.samba.org/>
References: <bug-12379-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D12379

--- Comment #6 from Paulo Alcantara <palcantara@samba.org> ---
Does your mount still work with mainline kernel?

If not, please provide verbose logs and network captures.  For more informa=
tion
on how to provide those, see [1].  Thanks.

[1] https://wiki.samba.org/index.php/Cifs.ko-testing

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
