Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D08C001DF
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 17:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjG1RzA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 13:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjG1Ry7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 13:54:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F02010CB
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 10:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=RbtgmC7mV3bVnxjuXVY2noHrtcwGIeerUdc5b656zVM=; b=188lyFBXGrowkNhk5cqBx1AICr
        C5rIp4goHD/ZzHxHfeWi1HeWZfi+aSaiUBqHun1XWBu1bdXXKZB+G/TxTJdhCp9xQX0EkcJZ5KSUa
        4isV5vSOtUmq7xEDRH1E0S0G64VbinOvIr9nkZTsj+qTKM+Ikfb/TyXYKfn4W/xVwVJOxOzE4WcB0
        M12d49U0R7QbWd1BYwziu3FSsJYgI5Xl3h8/l/B+9zPIpnDmRne9fm0WF+cfra0LxnrpOaBWF7a78
        KE/i3FzPIZmK4gxbsp078TAZDSph8h0+0sH4A4jwFVu3gNz9ifgAU7Ven/yf/3HXvO/nntpxVnYxk
        1EZ0W6vz7VXqcv4ALr5dEjHj8wgrjXVtBUqIuOfJv1D2qqyonvaOyUcv5DwPyzPIEBPI/A5K0+0d/
        KEBF/Hy3xHDT/p6a8zv3Qake9dOGAx9yQXsv9JIl9KUGFBqB1rk2ohIYXXZIJrTkZE1govTxu4Ide
        +nirMUuaXnNH3TH3BqWApOiQ;
Received: from [2a01:4f8:192:486::6:0] (port=39240 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qPRfx-004jG0-2U
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 17:54:53 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qPRfx-000OQs-AB
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 17:54:53 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Fri, 28 Jul 2023 17:54:53 +0000
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
Message-ID: <bug-15428-10630-Wlmu265V2J@https.bugzilla.samba.org/>
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

--- Comment #4 from Scott Harvey <sbharvey@verizon.net> ---
Created attachment 18009
  --> https://bugzilla.samba.org/attachment.cgi?id=3D18009&action=3Dedit
Successful mount.smb3 prior to windows update(s)

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
