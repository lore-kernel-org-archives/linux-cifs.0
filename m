Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4583C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 15:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63F6023406
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 15:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbhAGPq4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jan 2021 10:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbhAGPqz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jan 2021 10:46:55 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1E4C0612F5
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jan 2021 07:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=pf+Hce4A5Lhm9rc2VYIHU7bfuVTpBL01EgIY/eJ8XGw=; b=f/1dS/T2+ZPDoS+JmPvkfEq5sh
        c90X7Y2sxgWdFsHxUz29zaR1alRgUDD3CrH8OVgMttvujKcp4U7MyUONfNf7Vtz0VxWRcOAlEqK31
        EWp6c+ATYHCp7+jdE9j7sSmeSiCc+bEIl1LpkREtQjiyvW1eauttHP7ZdRFYqCSaZdEBQ7vzdRQ2b
        az7MTOPGWfzS796dp2yqcaAbzuMbLUto8k4Bgf7H1p10Wzjbl6Zu/21S58HCE5o+TjQH9+eYuVcrl
        JLwP217YTmYsY1DpcjG8pEmOEVJTaVhrL7H/yL+kRlUxoCVj0YpjCsR5Sik58+kd6ePncpdwc2wGo
        IfZAXlhac0UoLusyMxAx7oUlNFFrcLHNkt81gCyeWbUa7oCSkxuoWO0yMZ0AuijYTG08w8qzPDHwY
        80jam+t4W52LM6TSZXTLptsIxQgu/AvCuPvjrTfDvAmLqmy1BbtGbTkd1cmPGgBmC/qTWOAqLS8oL
        MBAAbU1f5fWMcWu615BHfcdy;
Received: from [2a01:4f8:192:486::6:0] (port=58084 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kxXUL-0000lg-0f
        for cifs-qa@samba.org; Thu, 07 Jan 2021 15:46:13 +0000
Received: from [::1] (port=27522 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kxXUK-002xqS-Lq
        for cifs-qa@samba.org; Thu, 07 Jan 2021 15:46:12 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13712] Unable to access files below folder name with trailing
 dot or space
Date:   Thu, 07 Jan 2021 15:46:12 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13712-10630-YbWtj2gckg@https.bugzilla.samba.org/>
In-Reply-To: <bug-13712-10630@https.bugzilla.samba.org/>
References: <bug-13712-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13712

--- Comment #5 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
it's a  quite recent kernel here:

root@cifstest1:/mnt2# uname -a
Linux cifstest1 5.8.0-33-generic #36~20.04.1-Ubuntu SMP Wed Dec 9 17:01:13 =
UTC
2020 x86_64 x86_64 x86_64 GNU/Linux

root@cifstest1:/mnt2# mkdir dir-trailing-dot.
root@cifstest1:/mnt2# ls dir-trailing-dot.
root@cifstest1:/mnt2# echo foo >dir-trailing-dot./foo
-bash: dir-trailing-dot./foo: Datei oder Verzeichnis nicht gefunden
root@cifstest1:/mnt2# uname -a
Linux cifstest1.int.sernet.de 5.8.0-33-generic #36~20.04.1-Ubuntu SMP Wed D=
ec 9
17:01:13 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
