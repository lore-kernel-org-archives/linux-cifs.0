Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4F7ECAAD4
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Sep 2022 19:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiICTWs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 3 Sep 2022 15:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiICTWs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 3 Sep 2022 15:22:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C332C4DB5C
        for <linux-cifs@vger.kernel.org>; Sat,  3 Sep 2022 12:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=wPbplubGwqz9s5S8xLyQxucNAZl4d5qWFH+D2xv0PeU=; b=XfSqrLG+cgQZ4GOq4/Sm99lPxs
        aGQb3tz+HIP//RVFtwqXDmYNjjFo9qvpY7zNieiBqom9tEBoXPc2+Mn64Wx4Sqrm1WHMoNgvDqOZL
        pYR4y7chyoAMe38LPw9qdez8po+Gc61Z7mntiTlumT7SKZ8q5gJGxaVF1IftZcGpnzGQ7dyabwnjB
        J+YM+WnoD/0SbiGLxvs36OJSmnKjYJkl9g2yQvVIQCyC+0p5uyKUdjoAIWDosHJcOd9p+9Jug/0vA
        rIMrMpI8zub+gMf6l5dxHrtRTP9BqaRSPP7oAIHCRdk7QQIXjEX2SVu70piu4JGxWLUDTjYgjfSBS
        gKvd1ABq2oG8tHpVE78Orj3uI8kdFxGZsVO7Vb77sKbIGoZKjC0gd1qmgrlJkjg6jmbzZICjmLlAZ
        PtXOaOTw/8Yn7OCu4Ofw21FyrErv6xSNSfZKYvyYuJVsCkldJVwPuwUpKkB6ZP8JHziEbimkTONqB
        t30XaehdbX9FKnomm1GRajc8;
Received: from [2a01:4f8:192:486::6:0] (port=36192 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oUYj6-002wVQ-Kc
        for cifs-qa@samba.org; Sat, 03 Sep 2022 19:22:44 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oUYix-000AqX-At
        for cifs-qa@samba.org; Sat, 03 Sep 2022 19:22:35 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13570] CIFS Mount Used Size descrepancy
Date:   Sat, 03 Sep 2022 19:22:34 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: Samba 4.1 and newer
X-Bugzilla-Component: File services
X-Bugzilla-Version: 4.15.9
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ematsumiya@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13570-10630-5jBBbuYWhw@https.bugzilla.samba.org/>
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

--- Comment #6 from Enzo Matsumiya <ematsumiya@suse.de> ---
You can do something like this, with tcpdump package installed:

<in terminal 1>
> $ sudo mount.cifs <...mount options...> //10.0.0.220/storage /cifs/server

<in terminal 2>
> $ sudo tcpdump -i eth0 -s 0 -w wrong-df.pcap port 445

(of course, replace "eth0" with the network interface that connects to
10.0.0.220)

<back to terminal 1>
> $ df -h

<go back to terminal 2>
> press ctrl-c to terminate tcpdump capture

Then you attach the new file "wrong-df.pcap" here please, along with the si=
ze
shown by "df -h" in terminal 1, and the size you expected to see.

A "df -h" output from the server side at the same time you see the discrepa=
ncy
would be nice as well.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
