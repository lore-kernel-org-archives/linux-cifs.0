Return-Path: <SRS0=rQDn=XQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAAEC49ED7
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Sep 2019 09:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD90021835
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Sep 2019 09:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AW01f4lK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394076AbfIUJoc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 Sep 2019 05:44:32 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:45039 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394062AbfIUJoc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 21 Sep 2019 05:44:32 -0400
Received: by mail-io1-f43.google.com with SMTP id j4so21784861iog.11
        for <linux-cifs@vger.kernel.org>; Sat, 21 Sep 2019 02:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=udbQo3HwW3wvcBCXw3BLsLO1iikSmqxQh+yfiLe552g=;
        b=AW01f4lKePxU2m8hK9jM25qstyaQCNNP60OQnos9prG/ZODYWfskoC2dlmXv9alsw3
         cWZicj83VRFbkWmHeBJkdBL16aQQ/NinVcGiWPkliHyi5WCeQJaxPx8sE6LyAza6ro4Q
         QmCbKV5R+dhqz2M9wPrN3UkvSwy1ggvfgu6Ro40Rp+M5fQnEfx0ELdJ9PS0YrN+zrzuK
         ckhqOWI5CWmjwLvz+gGfaw6H21+yTkvxNi6Awt4Ijr7Qe8J6okWGWG7XUdYGeQB0AKWu
         mPXA1Rpq1tSOXakyhIQsRZYuXcZTEdRCWA4FfGhjeTgnTq9o/QDtELru3GZU13s2IqLD
         DtIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=udbQo3HwW3wvcBCXw3BLsLO1iikSmqxQh+yfiLe552g=;
        b=WxOtJINzP4nz1P0hyoysUWs5NJIC8ENlheaHM3KulAuTzJ90u6j4V6G89Xoe+ERmYi
         mvOjZAdXR6w52Ld7WzegAolTbpwWxVZm93qepLMNn9SnRPjqD7bq06BD5a/PLpErH9E2
         zs1D6aJecZlvfgaFX5xvBDctjZhlzrlYKBP2g8ZYs9RKgGafG/EC7BrMcnKd1Nsn1A+z
         Vuqr41IIQtURtFXjl1GXYISlBb/QzGIZ1mJMUunTr0Kc3Dk8WB41MWIif5DZFOxjKj40
         UQO2bZVBU/bGL6UPrCeUekStDfw5wyeSlX6YQI81agO8hLZgU8hYObwCDzopU8Hf1n1e
         nenA==
X-Gm-Message-State: APjAAAUuNdjd28uaZLmHPGe6OX9TtkHFpA3xlP2cLCIiWiwHvVx6dLo8
        hb4Efx6qAe872f6vj4Kv07EXyIel3mFDhad4JS8=
X-Google-Smtp-Source: APXvYqw2jcTj3DzQAaJiW66hWG1iMWy6QRNgrl9XaJWDBVRKiZFGlnF+ZEqbbSh6oQnylbwsQeKN3YXp0CebL0PpUFY=
X-Received: by 2002:a5d:8e0d:: with SMTP id e13mr12089725iod.3.1569059071088;
 Sat, 21 Sep 2019 02:44:31 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 21 Sep 2019 02:44:20 -0700
Message-ID: <CAH2r5mui+2q-DNW9a7-prRWt82ZLCc9hLBNsSQxNdVa=Go1QEg@mail.gmail.com>
Subject: WSL and remapping of reserved characters to Unicode remap range
To:     Edgar Olougouna <edgaro@microsoft.com>,
        Jeremy Allison <jra@samba.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Did some experiments today with files created by the Windows Subsystem
for Linux and noticed that they create files which have reserved
characters by using the SFU remap strategy not the default used by
Macs and Linux (the posix or "SFM" mapping)

But at least it means if you mount to a windows system which has run
the Windows Linux Subsystem you can simply do mount with mount option
"mapchars" and the file names should show up fine.

See example below (mounted to Windows directory created by WSL):

Virtual-Machine:~# ls /mnt/special-file-names
'dirwithtrailingspace '   filewith:colon         'filewith space'
'filewith*asterisk'      'filewith>greaterthan'   filewithtrailing.
 filewithbackslash       'filewith<lessthan'

--
Thanks,

Steve
