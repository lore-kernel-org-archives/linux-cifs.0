Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C0AC19F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 21:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiHKVP3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbiHKVP2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 17:15:28 -0400
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD9625C68
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 14:15:26 -0700 (PDT)
Received: by mail-qk1-f170.google.com with SMTP id f28so4566620qkl.7
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 14:15:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=PYXTE58EuokZU+z2UHNf9Q+RbopgDavG6L73ydditw4=;
        b=6fiqXZExtcvUMznO5NieetiQHi41q/Vk5AGiThUmTsfXqEmBTsX2BNA4ytby5X1fXR
         YR453bKtpc5+6jyeZB4EDYqOGLWrIIAitYQyuOOqP6jsV0ezYAnrOrdrHfxDst7kNzph
         SK6QVXC8f8QyLhPOViUISxSWYTH7xDXQx+rRsekG557xxkO2TTHWYWkwBm20TkhWEwvR
         59NUTpag7vmzAm16Mu3BciTwxBDcAfBiPuRUpy7EtXT0t2tgvoWuBSRCGxUVMv8NWAxH
         moBRWU9YUh/Z0xmof3ZLX39T67NjUKGutIumzNsJc/LNKpIjyDA1bUK+RR26RLEoFy2l
         8Mwg==
X-Gm-Message-State: ACgBeo2FJwvisnD6dI478vTJHGKoL0V0HegmEvpk46/ORJMzLrPqbI26
        B8E5Cg7On7fEwehNn+5CGZWDdQUqeqbJBRSwG11k3W7yVA==
X-Google-Smtp-Source: AA6agR4ePdidHDEOrpbJHnrPgIJip/gYVbD3Yqt5nkuBLsKXKH2vXcyVkBbKs7NxdzWbNWNPgb1GBbfHygD5OJbgQdQ=
X-Received: by 2002:a05:620a:2589:b0:6ab:91fd:3f7 with SMTP id
 x9-20020a05620a258900b006ab91fd03f7mr760273qko.104.1660252525388; Thu, 11 Aug
 2022 14:15:25 -0700 (PDT)
MIME-Version: 1.0
From:   Pavel Shilovsky <pshilovsky@samba.org>
Date:   Thu, 11 Aug 2022 14:15:14 -0700
Message-ID: <CAKywueTujSTFAv5B=o2t6zjNdyVdVV6PaYQov-XR7duYXrs5tA@mail.gmail.com>
Subject: [ANNOUNCE] cifs-utils release 7.0 ready for download
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        samba@lists.samba.org, Steve French <smfrench@gmail.com>,
        Jacob Shivers <jshivers@redhat.com>,
        Alexander Bokovoy <ab@samba.org>,
        Michael Weiser <michael.weiser@atos.net>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        atheik <atteh.mailbox@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

New version 7.0 of cifs-utils has been released today.

It brings GSS-Proxy support which when configured allows unattended
access to shares (e.g. from batch jobs).

Links

webpage: https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball: https://download.samba.org/pub/linux-cifs/cifs-utils/
git: git://git.samba.org/cifs-utils.git
gitweb: http://git.samba.org/?p=cifs-utils.git;a=summary

Detailed list of changes since 6.15 was released:

3165220 cifs-utils: bump version to 7.0
7b91873 cifs-utils: don't return uninitialized value in cifs_gss_get_req
d9f5447 cifs-utils: make GSSAPI usage compatible with Heimdal
5e5aa50 cifs-utils: work around missing krb5_free_string in Heimdal
dc60353 fix warnings for -Waddress-of-packed-member
c4c94ad setcifsacl: fix memory allocation for struct cifs_ace
4ad2c50 setcifsacl: fix comparison of actions reported by covscan
9b074db cifs.upcall: remove unused variable and fix syslog message
2981686 cifs.upcall: Switch to RFC principal type naming
8a288d6 man-pages: Update cifs.upcall to mention GSS_USE_PROXY
aeee690 cifs.upcall: fix compiler warning
e2430c0 cifs.upcall: add gssproxy support

Thanks to everyone who contributed to the release!

Best regards,
Pavel Shilovsky
