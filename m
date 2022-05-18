Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785D0C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 21:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243187AbiERVeA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 17:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbiERVd7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 17:33:59 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2342370E7
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 14:33:57 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id m6so4068358ljb.2
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 14:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=r7XZvQpgnTuiTga7VpVbKSJYtKZ/LYSvfLiOxLtdm1k=;
        b=MYgqdnQRzPk5qkZ5sZLhfY2orqlO+GDj5TiPzw1GH+XWQYF6qHhwZ//ODjXp5N07lh
         Lv3anL1YxUeG5TRQ/UbxjOeDt/B4h+XAjc8PFFUraI1zu8A2qURFSs7tZkgoMFZdMxsF
         y1D0UBGCWE8X7ge5AWNVfghnjy1XmyaRFFVrGBH0x51CMSPtK8gsKqvauUYKNQt8g2vc
         /emtyhaQntiVvNgB+8zrEWm2XtBjRmbrvuDgF0KdXYrh2UstLShH5eUNM5nCwItpV7uK
         fDBXqqJ3I46CRUUt4PpBQt+aG9y+JygssJrGz52Rnx/jDowVSC/JSoBEXuIm8fc+u8bZ
         d8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=r7XZvQpgnTuiTga7VpVbKSJYtKZ/LYSvfLiOxLtdm1k=;
        b=MgwBYx2uuoib7PwhqDc4gDM1kxKSg8GdlfVGVgk3HQ5WNSO/Oo0uahW7aGINlP6ngw
         5YXIhCPjH3YNSY+fhcruPCkyVIZnqVM+5LApRY4KWRnTQ64yki/Ns0zFmjvnu3djsZ3J
         DY6C8yNgm87cRnQzfDWz4IDszMXZeMdkbkPDktw+Z0jYffQj8bjCxAYE1UyXc9crsceR
         CZRWXpokk0lymy5vCeWGrqTM2UFiQ9jsAOZbaYGzTJpM+BEDuirypvX7GC71Kigi9MzB
         5Mn3EX6o27xsQYNFq99roA0/Naal/xHEvKGaxay4g6PdtST7NXtEcH6uLavAC0ct2Jwz
         JXEA==
X-Gm-Message-State: AOAM5335rgjeq7mdLAdicytqmQi742uQwss3Elv8eriq/U9wvdPT2Cj6
        AxcH6KUS60gMW0h34V5zgozNvN0MlGvPriNaj/rxyspG
X-Google-Smtp-Source: ABdhPJxoBvWmOW+4GyBP4+nn6k+nfkDr4aJCBKLKRzriTwQmPZvZ1npdY/6QYfErhhZnqCuNhi1BXT+yg7/xf6Q2paQ=
X-Received: by 2002:a2e:7f08:0:b0:253:c7e7:f571 with SMTP id
 a8-20020a2e7f08000000b00253c7e7f571mr787565ljd.398.1652909635796; Wed, 18 May
 2022 14:33:55 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 18 May 2022 16:33:44 -0500
Message-ID: <CAH2r5mtk36dm00uH+Y0bYu0c6J_k7LcEQUBa2H0SLEX4RLXUPg@mail.gmail.com>
Subject: [PATCH][SMB3] add dynamic trace point for debugging lease break not found
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b01d3f05df500364"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b01d3f05df500364
Content-Type: text/plain; charset="UTF-8"

Looks like we don't have a dynamic trace point to catch the case where
the server sends a lease break we don't recognize.  Attached is a WIP
patch for doing this.  Thoughts?



-- 
Thanks,

Steve

--000000000000b01d3f05df500364
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="dynamic-trace-lease-break-not-found.patch"
Content-Disposition: attachment; 
	filename="dynamic-trace-lease-break-not-found.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3c3pgs80>
X-Attachment-Id: f_l3c3pgs80

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm1pc2MuYyBiL2ZzL2NpZnMvc21iMm1pc2MuYwppbmRl
eCAzZmU0N2E4OGY0N2QuLjZmMDQ5ZGE1YThjMSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIybWlz
Yy5jCisrKyBiL2ZzL2NpZnMvc21iMm1pc2MuYwpAQCAtNjU2LDYgKzY1Niw5IEBAIHNtYjJfaXNf
dmFsaWRfbGVhc2VfYnJlYWsoY2hhciAqYnVmZmVyKQogCX0KIAlzcGluX3VubG9jaygmY2lmc190
Y3Bfc2VzX2xvY2spOwogCWNpZnNfZGJnKEZZSSwgIkNhbiBub3QgcHJvY2VzcyBsZWFzZSBicmVh
ayAtIG5vIGxlYXNlIG1hdGNoZWRcbiIpOworCXRyYWNlX3NtYjNfbGVhc2Vfbm90X2ZvdW5kKGxl
MzJfdG9fY3B1KHJzcC0+Q3VycmVudExlYXNlU3RhdGUpLCBsZTMyX3RvX2NwdShyc3AtPmhkci5J
ZC5TeW5jSWQuVHJlZUlkKSwKKwkJCQlsZTY0X3RvX2NwdShyc3AtPmhkci5TZXNzaW9uSWQpLCAq
KCh1NjQgKilyc3AtPkxlYXNlS2V5KSwgKigodTY0ICopJnJzcC0+TGVhc2VLZXlbOF0pKTsKKwog
CXJldHVybiBmYWxzZTsKIH0KIApkaWZmIC0tZ2l0IGEvZnMvY2lmcy90cmFjZS5oIGIvZnMvY2lm
cy90cmFjZS5oCmluZGV4IGJjMjc5NjE2YzUxMy4uMDlkM2RmZWQ4NmQ5IDEwMDY0NAotLS0gYS9m
cy9jaWZzL3RyYWNlLmgKKysrIGIvZnMvY2lmcy90cmFjZS5oCkBAIC04MTQsNiArODE0LDcgQEAg
REVGSU5FX0VWRU5UKHNtYjNfbGVhc2VfZG9uZV9jbGFzcywgc21iM18jI25hbWUsICBcCiAJVFBf
QVJHUyhsZWFzZV9zdGF0ZSwgdGlkLCBzZXNpZCwgbGVhc2Vfa2V5X2xvdywgbGVhc2Vfa2V5X2hp
Z2gpKQogCiBERUZJTkVfU01CM19MRUFTRV9ET05FX0VWRU5UKGxlYXNlX2RvbmUpOworREVGSU5F
X1NNQjNfTEVBU0VfRE9ORV9FVkVOVChsZWFzZV9ub3RfZm91bmQpOwogCiBERUNMQVJFX0VWRU5U
X0NMQVNTKHNtYjNfbGVhc2VfZXJyX2NsYXNzLAogCVRQX1BST1RPKF9fdTMyCWxlYXNlX3N0YXRl
LAo=
--000000000000b01d3f05df500364--
