Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248FBECAAD5
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Sep 2022 21:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiICVxy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 3 Sep 2022 17:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiICVxx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 3 Sep 2022 17:53:53 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7794AD57
        for <linux-cifs@vger.kernel.org>; Sat,  3 Sep 2022 14:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=Lao/DWI3/+e5td47pUpXOJJQIVaU1w9miD5JKrHUpzk=; b=OqsdJ6zsmGVPUTd5RZNStBRzP4
        pDIxpqxkIwoLiDXx18dp5ZyMvKYvK3u3ANR03nPKsuFfOTX8nN3h4pLY/WPzV60qzR6hFxJZaCYhB
        qRjvxcFk0FiPhKQatnXQOwYIeaky+CrzIjLl9Fl7X09XlyjnL35k05v8XC6vgbyAEVGgGXM3h7FX+
        l1Oe2uj/vWn/MMZ7poE3+qNwsZTOhlA9Fg2+yB6yDihBoDPgf7yHM3t1euu603jvR37khUn2tYgRn
        r+229IOEX21U9lYXQfKC448FdCqyfL9xYOT0w8xeLVXjttn7ScAw55X0j1yZtDBKghR+qap689klQ
        JhF4FqrAIUcqONuljqpfFJ4/vhCHnax/jdxgOS9HsHFgGTD5Cd0cacd8eHIUr+wtpIdswtfksDek4
        ldincMU1mWLvobHlNe+jJZnWzfW/G0p3/8Tf4csNelPbWsZ1/G74P38Dq6NOXSukU45S8gNZkDO/G
        Q9gIjXhq9er37au7aXllfqBH;
Received: from [2a01:4f8:192:486::6:0] (port=36224 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oUb5K-002x55-E0
        for cifs-qa@samba.org; Sat, 03 Sep 2022 21:53:50 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oUb5J-000B1S-L3
        for cifs-qa@samba.org; Sat, 03 Sep 2022 21:53:49 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13570] CIFS Mount Used Size descrepancy
Date:   Sat, 03 Sep 2022 21:53:49 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-13570-10630-nBOncUpxf5@https.bugzilla.samba.org/>
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

--- Comment #7 from Terrance <kato223@gmail.com> ---
Created attachment 17506
  --> https://bugzilla.samba.org/attachment.cgi?id=3D17506&action=3Dedit
Incorrect Space when using Samba share being reported

File containing incorrect Space when using Samba share being reported

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
