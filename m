Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE03DC433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 19 May 2021 21:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82EA561007
	for <linux-cifs@archiver.kernel.org>; Wed, 19 May 2021 21:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhESVXR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 May 2021 17:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhESVXQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 May 2021 17:23:16 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6669CC06175F
        for <linux-cifs@vger.kernel.org>; Wed, 19 May 2021 14:21:55 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id s25so17210780ljo.11
        for <linux-cifs@vger.kernel.org>; Wed, 19 May 2021 14:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=YSdDdC0gaMA0xJt2lAbKeZ9IboXWh1Iz+byUH13CjMA=;
        b=ljpxH92lkHJ6DqmPH3e26NzJhsPcRgNOSrBLrnF8yoDl3HqMsgLy7mySxEs9jcmi1x
         RNBSsC6zEpYIH9xoP89MVgJOTOiWjJZvjU5Wvh5+n/zv2Uotl4KkLNCwToIqk74wN1VM
         VWFQQK7eZM8BQbeWCZCrOfU0uDcgPUD9N5928PzLlJ69y5S2GAgIXwN7BlyFu+Y0DBWk
         eU6o42//RuKO0ztYS4h1RQb/nt4i+KIeyJ9R3ISFxFgFoOUEKwZI716MBxKPGv/jSKKK
         M6UCQRuj4Rx5SwBstbwVScLSBjsVWanc+sU42dG9z/naBP3OFcbPbWtU/7f2iOmwipHy
         N1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=YSdDdC0gaMA0xJt2lAbKeZ9IboXWh1Iz+byUH13CjMA=;
        b=Pt3A1kAEGKx64GZ8bGMbuk+mXE5Cbv2qA8ML6NN5jKrSYC+LcpSEnmSEQBJg2Hug5E
         S/qtrtwwv0inmc4ByutTM7pUG0IS3iTzsWmf+0YByEboXV+fhcL5m7whq5c6ea56BQPe
         wZ204L8l6T5TaC7NgLKKv1crHJ8Vde7iEpYpUYsZhNDytlysx9fbA0PBybDSRorqzZMx
         Z44RqRQiEAJ2hmdaFh6/UbxWS2q2Nsq59hHFCnJPmEEqmJ97xQk5unL7mdwwKTfwbYEL
         ZJHuR4yuhm72NSCUCauPf8Y06KaruF46d0J/ueJ9UbBO1cFC2uSkaVsQeAG9nV3jwi2E
         e+1g==
X-Gm-Message-State: AOAM533L4SOeYJSv1D1EfaC3aMLOt5hAWLai7cy7XkvC+IJc6p/GQaHJ
        YUzye4ZBJ1cwNKYEoQzdh+Db1yL19aB5ievookCVYuirTJI=
X-Google-Smtp-Source: ABdhPJxdVnYRGjAZRBl3dycd+liefT1+pqvxI/qbCc55axMyXbETF09LrZmIgB32yFEkaRi8ZU4iikXsOFfvZZQl8P4=
X-Received: by 2002:a05:651c:2002:: with SMTP id s2mr763814ljo.477.1621459313557;
 Wed, 19 May 2021 14:21:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv-q=8b7L7r8_V66b2TXXKGFx95hRFFbEa1biCv-tzxDw@mail.gmail.com>
In-Reply-To: <CAH2r5mv-q=8b7L7r8_V66b2TXXKGFx95hRFFbEa1biCv-tzxDw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 19 May 2021 16:21:42 -0500
Message-ID: <CAH2r5msCa6RQ0_bhefr5oyp=71NL7HANC7qBexpgeRGAov_bnA@mail.gmail.com>
Subject: Fwd: ksmbd and reflink support - enables many more functional tests
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Wed, May 19, 2021 at 4:20 PM
Subject: ksmbd and reflink support - enables many more functional tests
To: COMMON INTERNET FILE SYSTEM SERVER <linux-cifsd-devel@lists.sourceforge.net>
Cc: CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <namjae.jeon@samsung.com>


Did a run of reflink dependent xfstests against ksmbd (from current
5.13-rc2 linux client) and see a very promising number (35+) of new
tests that we should be able to enable.  See below:

generic/110 0s ...  0s
generic/111 0s ...  0s
generic/115 0s ...  0s
generic/116 0s ...  1s
generic/118 0s ...  0s
generic/119 1s ...  0s
generic/134 1s ...  1s
generic/138 0s ...  0s
generic/139 1s ...  1s
generic/140 0s ...  0s
generic/142 1s ...  2s
generic/143 2s ...  1s
generic/144 1s ...  1s
generic/146 1s ...  1s
generic/148 1s ...  0s
generic/149 0s ...  1s
generic/150 1s ...  0s
generic/151 0s ...  1s
generic/152 1s ...  1s
generic/153 0s ...  0s
generic/154 1s ...  1s
generic/155 0s ...  0s
generic/161 1s ...  1s
generic/164 8s ...  8s
generic/165 9s ...  8s
generic/166 6s ...  16s
generic/167 5s ...  230s
generic/168 46s ...  37s
generic/170 44s ...  103s
generic/175 7s
generic/176 58s ...  50s
generic/178 1s ...  0s
generic/179 0s ...  1s
generic/180 0s ...  0s

After test 180 (for tests 181, 183, 185 and following eg.) I got
"could not connect to server" on all tests so ksmbd may have crashed
at that point
-- 
Thanks,

Steve


-- 
Thanks,

Steve
