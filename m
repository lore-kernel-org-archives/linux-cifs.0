Return-Path: <SRS0=Apod=SE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15744C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 00:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D61CE2084C
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 00:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kZ+4g/gK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfDBAev (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Apr 2019 20:34:51 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:40189 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfDBAev (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Apr 2019 20:34:51 -0400
Received: by mail-pf1-f169.google.com with SMTP id c207so5413328pfc.7
        for <linux-cifs@vger.kernel.org>; Mon, 01 Apr 2019 17:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=nLdbkXDmC+10a9nsqqKYGbh4/rEmF0O5Ss4GP9vK5+w=;
        b=kZ+4g/gKPX1vSp0K9Ege5EUkxxUxH+jt4JQZXwa/xDgHls86RHEMBfqkYZZ6Yt69Lm
         9Xt0pI2XRveYXIs1elBmjKYKFhJKbWPORR9jpZVbgPvoJc5eflvXlaY/VBapKaZkhuEp
         K8kyMdafnKbuBVrtROXabyShjD5ABAD4qpDXa/6lZGJ/xjYkT3nNgb84lkqoeB8uBcco
         xpfJGFQ1QCD85gNtwX2P6tMf9imbgXqmhjjPtIE8fS254/+Ci03k+UD25xtiluddku3j
         EojAPyTe4FEL7kdqTd9Q4bKgV314leYIROlbvkGqarjInXxj5djOWubmS0ji5Ng7t3OI
         TiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nLdbkXDmC+10a9nsqqKYGbh4/rEmF0O5Ss4GP9vK5+w=;
        b=Jsikn/NKorXUtpeUfnETtL3hEISCmqV691hgNcO3ii8fXUlRZuDYzINwCM6enS/FXs
         YrSbwchC2nJ/80PHEAv4BUFwCt5YJf2ZipYYNqMYY9AAXgMScJ1Ni/qNqiOTfAxVjwip
         Jpqd2gxRKcIr0TzX8Ke1d10AWj0FWtiRCgAFgkvo/JfllpqnI05EphGXQIRjHq24Z7dE
         pJOq5bHGOj4RB1ydm+GdX4ncgH+vo4hnf4AXPfB69txqSL6NxkaSmKNlPUQFar2xapWG
         Ram2mlhoVErP/PkiVFahBImigxT5+iYElnSjWBGjTtFvnvgCtPtCK0W0jPyRqjNvpLj4
         v2hQ==
X-Gm-Message-State: APjAAAU30/RgFQ08O2+mZALTxqHagGDD9eWmn/qT75usYkKlu9J1YmcA
        ST5Guvt4OCVGY04bbYWG3bjVk2EA8i9F63XX6sYCPQ==
X-Google-Smtp-Source: APXvYqw9z/R/338acipHG8qZp5m/P3b8B15QxVhLJv3rVft3N+FWz8r/T45de6QmC4EWraUDuQV36hFsQehN0YZ+6eo=
X-Received: by 2002:a63:e14e:: with SMTP id h14mr62467035pgk.184.1554165290231;
 Mon, 01 Apr 2019 17:34:50 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 1 Apr 2019 19:34:39 -0500
Message-ID: <CAH2r5msKoKPp=G7d8UWQu9-m5bAjqKOMhwR977Q5tk9nij=AZg@mail.gmail.com>
Subject: Added xfstests 306 and 452 to the buildbot
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added two tests (306 and 452) to the Azure test group now that they
pass with XiolLi Feng's xfstest patch (for remount).

This is great that the buildbot test groups keep improving.

-- 
Thanks,

Steve
