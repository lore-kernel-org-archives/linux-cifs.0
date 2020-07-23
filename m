Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8194AC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 05:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53C9520768
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 05:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RGuFtM3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgGWFX5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 01:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgGWFX4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 01:23:56 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96E0C0619DC
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2020 22:23:56 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id i18so3308798ilk.10
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2020 22:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=WpMBGot8puTiMlmSpFVXBB0Q4QQ82yXT6C9rA9c3WHg=;
        b=RGuFtM3m8tx6EEtosK/nMI/nBTOkvWXUMT1l9IlcpiHaj+Qf/Ijg7UJ2TWtlaPWkjT
         YJqmqpq9LcQLI08MmWtoKmwLo3jWcsWaV8ffTNQgefrNqKXq6u2t8gNWrm4T+qYHK7IE
         MnPPwlw8WpYH4YMF82HOoe6e7DFBi/lg1jXca8M5WgH3EGpnu93H74jg3ND6NCSdG7uE
         6bOefmooTCzGdHdJJxmXiPfcQCRxFKtmu9poZBInsdRKoRH9jd9VINV1lh3GOZWDUvnT
         k18GZjky5t01DVfRqHnx1YDuq+pWor7rH9Hqr+tSf3dTwe05InyhxSP/61zKuyQMCBxE
         R3Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WpMBGot8puTiMlmSpFVXBB0Q4QQ82yXT6C9rA9c3WHg=;
        b=UFGE+eJo3KWnxItyk86cmVUXxPcombA8MxjU6jOMS51yGwXvNbEflIVFRbCpjggyi/
         nv0tcw4xkrCaWfruezLS9vTdgIECR2AfW1pxpwTue4JPNMbOep1rIbt2rA0Nk1fhe65G
         liIQInLi5YqTlhRW6UMnNtV14N10VM4be9BA5uwgQWRHiTv5W8W9RrGdSEQttjf22eF5
         lPNAAGzLYXliUTQQQb3d0JNv85VrhxPtMgdKG5+sl3vgLYyJc6R8d8TMHxGOaAREE66d
         EGFe2+LzVBIkQdTeqUPKK4e7P7CVzbcA0yR/KL3IMVK7sO2wb0hLEiBfinvz4FeeqI4j
         1yDQ==
X-Gm-Message-State: AOAM532U6iW2UZYhthqRou6qLKmrVYeX2LOH6PEMa6zISJjTYkcPcAgG
        be8EHSbzVgsAk6UWRX2JCHLTpZ6yfft9GhDZ3HSK0Gw1W1Y=
X-Google-Smtp-Source: ABdhPJwdbodK/Av+yJlue/WJjtwYGhr+2fFwJPeY5AeK8Vy4f42TY5ezdS/3/dnV0K0BPFkFonlm5m3otdf/SSOBuw8=
X-Received: by 2002:a92:d6d2:: with SMTP id z18mr3303661ilp.272.1595481835824;
 Wed, 22 Jul 2020 22:23:55 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 23 Jul 2020 00:23:45 -0500
Message-ID: <CAH2r5muh5W-OtXEKg7Ji7jBZa1h3-XVvHBn3izkyMrrWAbfrcQ@mail.gmail.com>
Subject: xfstest 129 slowness
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In trying to debug xfstest 129 I noticed odd behavior to Windows server

test 129 does 4 steps, and the second one is the very slow step

$here/src/looptest -i 100000 -r -w -b 8192 -s
$SCRATCH_MNT/looptest/looptest1.tst
$here/src/looptest -i 10000 -t -r -w -s -b 102400
$SCRATCH_MNT/looptest/looptest2.tst
$here/src/looptest -i 50000 -r -w -b 256 -s $SCRATCH_MNT/looptest/looptest3.tst
$here/src/looptest -i 2000 -o -r -w -b 8192 -s
$SCRATCH_MNT/looptest/looptest4.tst


So the problem is the second invocation of looptest - when it is doing
10,000 102,400 byte sequential writes and reads passing in the
truncate flag.  What I see in the network trace (at least to Windows
server) that is troubling is lots of "STATUS_PENDING" errors in the
write responses.

It appears that the test runs much faster to Samba
-- 
Thanks,

Steve
