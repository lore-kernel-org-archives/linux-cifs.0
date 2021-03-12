Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93775C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Mar 2021 06:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A57964DC4
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Mar 2021 06:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhCLGys (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Mar 2021 01:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhCLGyf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Mar 2021 01:54:35 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D707C061574
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 22:54:35 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id f16so5411207ljm.1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 22:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=31+59ZCqcSat5PcKxzGO6fYfhqFRiRkM0ziNKVPzmmA=;
        b=TIkNCERVf/RXd9CDBsNzpFk3/rgfSZJooAgLsDe883ow6TcrIEzQ8ESH4dFgIB23yr
         J9BRfO+aHFQ7wcm3QTsXvJthcmeqz4WgTVzE5JdwUON6hYNMZvVgYaG5sf7AMlB2tm1B
         9STCLrWTdjdal40+8MslRNRKLL2ZC8pc8opnEPXtLvKBRBz3wlq2uvIr+mQQipBiDJ1S
         wibDz8elpAWsgfDLU2kkcT6BeWt3FuDyEAwR2pL9cY4Ukkt1agVSGNxG/cLA39gXh/xv
         tIwXjK40Uo1dmOxUWJOHH8XMmn9/WIPWckon9+lha0Mp610RJcneKbdWIAK7rp1igyiV
         D0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=31+59ZCqcSat5PcKxzGO6fYfhqFRiRkM0ziNKVPzmmA=;
        b=TfQbUJOqeTilDaH/KjiOMg5XoaF1JDn4F1EzjDUF1buyYa12GIZC1YHYdEckErqDW3
         mztpr9Mr+FvsRMLSb5CskFOpM0rQuLAdqH5mZVIQ+ZCCucV9OXWgh/VGCDiW/2XFGc2z
         X++WvXcot48OJXuXJ9t8ixJUZmHSlTsvqT/kVAWy4fe2rEKiJHBJBR/LEcpkb6BCsY0P
         6L/z2VwdMM11Pw3yC2Hke/IHzRZ2s3u5UN9TMqp3zu4TAYt5n0SqocgsCX/nlULi8QnC
         jI47W2xRVrc86500bgofcqDlIWQXCzPnykq8Hj621Qn4vCZzilWkwD7nZRwR7jrmJqVc
         g0IQ==
X-Gm-Message-State: AOAM531+2qGklXoa6/TkKOtpbrKUzwyJ5yUwE4L/y7VwvGY+urlPOzAU
        jP0tiv7T7gK5uCx6r2BVbScESHNBo3tztBQhFYU=
X-Google-Smtp-Source: ABdhPJwG/SRp70K9stj3i9NvwwUvRMSYbppJiPfhPumYKQDXTYDj18AJiYflg2jZKShgHriwRH0DLRNLB4O9S3VEonI=
X-Received: by 2002:a05:651c:548:: with SMTP id q8mr1537730ljp.256.1615532073346;
 Thu, 11 Mar 2021 22:54:33 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 12 Mar 2021 00:54:22 -0600
Message-ID: <CAH2r5mv4nqpw2PoCsX_oJ=gJg-cbS9a3LtSyzv5Wq3obFOaTfQ@mail.gmail.com>
Subject: Testing to current ksmbd from cifs.ko
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I see a "STATUS_INVALID_PARAMETER" returned on tree connect from
cifs.ko mounts (current 5.12-rc2 equivalent of cifs.ko running on
5.11) to current ksmbd (on 5.12).  Here is the relevant dynamic trace
entries:

      mount.cifs-20747   [002] .... 40007.155508: smb3_cmd_enter:
 sid=3D0x2 tid=3D0x0 cmd=3D3 mid=3D4
           cifsd-20754   [001] .... 40007.156752: smb3_add_credits:
conn_id=3D0xf server=3D10.0.0.0 {xN_FS_FREh\Nuse_dela=D8=BE\~ current_mid=
=3D5
credits=3D127 credit_change=3D33 in_flight=3D0
      mount.cifs-20747   [002] .... 40007.156969: smb3_cmd_err:
 sid=3D0x2 tid=3D0x0 cmd=3D3 mid=3D4 status=3D0xc000000d rc=3D-22

The wireshark trace shows very similar tree connects.  The first to
IPC$ which succeeds and the second which fails to the test share.

Ideas?


--=20
Thanks,

Steve
