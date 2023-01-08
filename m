Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CB8C53210
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Jan 2023 10:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbjAHKWa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Jan 2023 05:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjAHKW3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 8 Jan 2023 05:22:29 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F281DF58
        for <linux-cifs@vger.kernel.org>; Sun,  8 Jan 2023 02:22:28 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id r26so8372086edc.5
        for <linux-cifs@vger.kernel.org>; Sun, 08 Jan 2023 02:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UumxcqQ4KUwc+6fyD8Dug0wSqlaIDrCXfmBZ/B1Ycp4=;
        b=fJ1OZyVh3uAEOJnGscexqGn0CqhsHGHyCesaTtfrZ++a4ZZIImEU9i3Q7qEFfAHXcM
         Ai0UhJE5hdJWwm6HnXxElwxJR9CqYGV+T84WO9HLxK2nlyDK/sYbwn/4qcghrB0P1Se3
         X02CdkzqhbPs8tkscjgBAM720qOrlsIZyyxUYHCJqErbGNj5aAfzRVKtG0pKAmQRco1b
         xANxn8v95ITkpFWy5Ib2hiHqwt/98iBP6JA3Alubw223qPCVmyKp1hiFgNQ6Dx3FlH+e
         bsTTB86eSRVpjQ9pIhPLjAPEC/ez9988Nat257Psm/jiPOD5GtCsZKB36/4nv4EKdxdh
         1fIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UumxcqQ4KUwc+6fyD8Dug0wSqlaIDrCXfmBZ/B1Ycp4=;
        b=4KuqjpwldOIFF+1bcpg1qrS0i/CVVgBPPG5jL4xC2sZ/rkLp583LQNBCRhyVPsxwEB
         7iosRY2oV/i/WPWXPAXvUc7/rHDcSD32ihOGWtSklMVjfJJOGjLGHxpVxP7o7Mn7CBSj
         V6Dc5S9aQriZLZEAgmK0+4vBkM1h4Gt26S96OHehGcBAI8ntWiI5Fy/hc+8j2njL68WQ
         ZXNVS5GIkVRkwbpfX+7fr2R/7csoy6IkfV8mmYdn/OVRrF/sn9GEe6vaWicm7iDOqRVI
         h1Q7jT10IbrgSONqE/Cllxk+ZmTZo+4/k1ox9ELCUKeHzxvr1THX38fqKd58bX0//31O
         8t7Q==
X-Gm-Message-State: AFqh2ko6V5Grozx6hSK5QBb89IRqkuYIxAZjgoHFVrW7MW1CWXo9nA3h
        w0YZdvrSfmljZ4m+WowJuOJ9r0sGMN2oitHl8PWUqoBHUXI=
X-Google-Smtp-Source: AMrXdXtuCeVWm7uUc/Phksp0CvirZwpTe96q1s3hiznuttLvlF7xA4Az+9uAyerNp7Gq6v4MzwvnULCmqbGnd/rVnR0=
X-Received: by 2002:a50:ab4b:0:b0:46a:b1a9:c34e with SMTP id
 t11-20020a50ab4b000000b0046ab1a9c34emr8324827edc.212.1673173346573; Sun, 08
 Jan 2023 02:22:26 -0800 (PST)
MIME-Version: 1.0
References: <bug-2159009-264875@https.bugzilla.redhat.com/> <bug-2159009-264875-75dbnIpzuh@https.bugzilla.redhat.com/>
In-Reply-To: <bug-2159009-264875-75dbnIpzuh@https.bugzilla.redhat.com/>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sun, 8 Jan 2023 20:22:14 +1000
Message-ID: <CAN05THRKBAghwkyMO4+mSoEogn6RWcMkxvj_TUTysVtTBgVtdA@mail.gmail.com>
Subject: Fwd: [Bug 2159009] Visting CIFS Shares Freezes Machine
To:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like upstream has a few recent regressions now. We probably need
to look into expanding our test coverage so that we catch this before
they hit linus tree.

---------- Forwarded message ---------
From: <bugzilla@redhat.com>
Date: Sun, 8 Jan 2023 at 20:15
Subject: [Bug 2159009] Visting CIFS Shares Freezes Machine
To: <ronniesahlberg@gmail.com>


https://bugzilla.redhat.com/show_bug.cgi?id=2159009

Alexander Bokovoy <abokovoy@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |acaringi@redhat.com,
                   |                            |adscvr@gmail.com,
                   |                            |airlied@redhat.com,
                   |                            |alciregi@posteo.net,
                   |                            |bskeggs@redhat.com,
                   |                            |hdegoede@redhat.com,
                   |                            |hpa@redhat.com,
                   |                            |jarodwilson@gmail.com,
                   |                            |jglisse@redhat.com,
                   |                            |josef@toxicpanda.com,
                   |                            |kernel-maint@redhat.com,
                   |                            |lgoncalv@redhat.com,
                   |                            |linville@redhat.com,
                   |                            |masami256@gmail.com,
                   |                            |mchehab@infradead.org,
                   |                            |ptalbert@redhat.com,
                   |                            |steved@redhat.com
           Doc Type|---                         |If docs needed, set a value
          Component|cifs-utils                  |kernel
           Assignee|ronniesahlberg@gmail.com    |kernel-maint@redhat.com



--- Comment #3 from Alexander Bokovoy <abokovoy@redhat.com> ---
Moving to kernel package. cifs-utils is a user space one that does not
implement the SMB protocol but rather helps to establish the session. The bug
is in the kernel side of things.


--
You are receiving this mail because:
You are on the CC list for the bug.
You are the assignee for the bug.
https://bugzilla.redhat.com/show_bug.cgi?id=2159009
