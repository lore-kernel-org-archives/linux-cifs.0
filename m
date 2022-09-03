Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28031C6FA82
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Sep 2022 21:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiICVzb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 3 Sep 2022 17:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiICVz3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 3 Sep 2022 17:55:29 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBEB2A963
        for <linux-cifs@vger.kernel.org>; Sat,  3 Sep 2022 14:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=7Y6tW4xKb9IQe4noqhioLeOp5+pIzuUqk2mMJOFOW2Y=; b=ZghDmVlM9fYCWiiDEHeFd9eHC/
        zJP1m1WlV8EPfqdo+WgBjH6sP4ZF+adcGmf9nVBFiAYUMrhpjY1klbT8bt/9QOTnyBnnh9vCcpoJD
        y+V4DWf2VwCeKj0AH4Wr9Wf+c80lYL+OqlNmdqbRHmvZSBa6zJZchsJU97c3xvNRKHWqhdtMMFJ8v
        W4VeXgnXX+EZ9Mgh+clhz8JskquHh64JkOl4p48GT7ZsQrhL+1gxa4ErtdzbfFj6tWbN5jFfsa6b8
        f1GYLMsKNxMJiaTfPGyf5DoRzm0ArCjEr8SC0kfYePsmIcLXvarzCWgR6Xl6hOUHiNsjo1iYPvcu+
        IS6ebLlW4HpoxslTYqbtLl48ZNfseZ0HIgb+MVTKznR1UN55Lb0iJSIulGjjP5nGMxRnZoKptT9jm
        mjlj23Q88HZgYUXLgR/iBLUkuxOtp5qNsn3eMdToYWpLr8rjQuFzMuWOuu7kAo0Z0VYt0nUM2a0oF
        2G1Rbe59JR9qvR0PpjZSbE2R;
Received: from [2a01:4f8:192:486::6:0] (port=36230 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oUb6o-002x69-2b
        for cifs-qa@samba.org; Sat, 03 Sep 2022 21:55:22 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oUb6l-000B1t-BK
        for cifs-qa@samba.org; Sat, 03 Sep 2022 21:55:20 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13570] CIFS Mount Used Size descrepancy
Date:   Sat, 03 Sep 2022 21:55:16 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: Samba 4.1 and newer
X-Bugzilla-Component: File services
X-Bugzilla-Version: 4.15.9
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kato223@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13570-10630-SqsiUPsDTx@https.bugzilla.samba.org/>
In-Reply-To: <bug-13570-10630@https.bugzilla.samba.org/>
References: <bug-13570-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13570

--- Comment #8 from Terrance <kato223@gmail.com> ---
Top line is the Samba mounted share and the bottom line is the exact same s=
hare
mounted on NFS.

Filesystem                 Size  Used Avail Use% Mounted on
{..}
//10.0.0.220/storage        15T  9.1T  5.5T  63% /media/Samba
10.0.0.220:/media/storage   15T  8.3T  5.5T  61% /media/NAS

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
