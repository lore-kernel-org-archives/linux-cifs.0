Return-Path: <SRS0=PRx5=TA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D5AC43219
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Apr 2019 15:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DA7220835
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Apr 2019 15:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2A4SQtJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfD3Pwd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Apr 2019 11:52:33 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:35976 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfD3Pwd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Apr 2019 11:52:33 -0400
Received: by mail-pl1-f181.google.com with SMTP id w20so6305289plq.3
        for <linux-cifs@vger.kernel.org>; Tue, 30 Apr 2019 08:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=JENNT/zMh7cjuzo3wyN9F1O/GbACKbzf2WjWeWhoVrA=;
        b=N2A4SQtJ9c08ymo+fvhcZO32PrCqXYzx3pxffh3RhordqE9FbtGhoxPYi4w4q5D1Ci
         v1X+vxKzFL4+roTfOQvu484DgTBCqCaQuzI+23dwW4RPHx4D7Ga66PhburiFidX9Wvf5
         9n2PIQzGooB+sqrlWIZEgbpKw4lM0/8u7z1YWCBTORr3D1NjxvrM43/Gb2pc1/IXvvdU
         eG1EUqCAQ2JnHgcugp/Ih4YmPE7b7U+DnhwYyiVINyTeOQf8Rw4/s9lCcy9HrKEzdiX+
         ESfrlt72e3TqlCfe5jAFiBYe9/umgxx5vpv6mThOSNymlKqc2woW5qL7AbarJfzq5sVn
         k3VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JENNT/zMh7cjuzo3wyN9F1O/GbACKbzf2WjWeWhoVrA=;
        b=UTEB+ynpKl3+ePO4nEF7YpgtGHE2RgKLyX+IH1KP9L+hVX/Cgs6W1br7c6JnFN7KnR
         Jh/r5gwYXpfsk2WMhI736V3mK6DFFL8aBQUIzGaYHA7VWVUOntT+8bLjUc6TwnkIxrwU
         57EEtZCisl5eVwH46dQTgimsqd+DsCdbKbCHcedNix2wDrxMtjdcscnSHwzcQX2nN4jT
         rp83aJ3MPXVii3Ow+HJUWrM/z/DcB4nlGLeb/xucc8C9TeI3CTBFB9O2UtTaj+qT/1rU
         NeRvd40zXzNhRhfuKVzw4v6aucwOqqIKfL+uee40wj/5+mG2aH91pXlmBxmWCkFh4Bj/
         Xe4Q==
X-Gm-Message-State: APjAAAUZkI4Cl5QaLEtqeu8TPFW2I6KjEwhXsxBYad80oHeleutlDnsC
        gh5t1reK0JXe7dNoitr/YCJ6qDK0AZr1BpG13hq+AYoXJJw=
X-Google-Smtp-Source: APXvYqzqQ0B2d6mU6lh1kXQ75INbI04E8Ur6adjrx6fFWQHFwQr/xy/UKMIOE2tETU90kEPWKR7wGD357j3fH6STQuQ=
X-Received: by 2002:a17:902:b105:: with SMTP id q5mr13950901plr.290.1556639552027;
 Tue, 30 Apr 2019 08:52:32 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 30 Apr 2019 10:52:21 -0500
Message-ID: <CAH2r5mtxU3aONRMaZLKEMPBWydDZgjSiBS07sHXXK0zUeBmUdQ@mail.gmail.com>
Subject: Tests 112 and 469
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch is odd because it fails xfstests 112 and 469 to Azure, even
though Azure doesn't support the operation so should skip the same
part of the test with or without Ronnie's patch and tests should work.


commit d008b979e8e6196ab3f916ca076448f5c9f527f3 (HEAD, origin/for-next)
Author: Ronnie Sahlberg <lsahlber@redhat.com>
Date:   Fri Apr 12 09:56:23 2019 +1000

    cifs: zero-range does not require the file is sparse

    Remove the conditional to fail zero-range if the file is not
flagged as sparse.
    You can still zero out a range in SMB2 even for non-sparse files.

    Tested with stock windows16 server.

    Fixes 5 xfstests (033, 149, 155, 180, 349)

    Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>


-- 
Thanks,

Steve
