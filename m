Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577DDC2B9F4
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Jun 2021 20:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ED3F6113C
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Jun 2021 20:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbhFSVAe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Jun 2021 17:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhFSVAd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Jun 2021 17:00:33 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0757C061574
        for <linux-cifs@vger.kernel.org>; Sat, 19 Jun 2021 13:58:20 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x24so22919636lfr.10
        for <linux-cifs@vger.kernel.org>; Sat, 19 Jun 2021 13:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=wNQEiv2Curb6hQD/17jdXcqsigImEVaW4IOMLah0Lcw=;
        b=PoelrXvj4GR3p5/XB+81VDEB9JZHX+USiBwBOzJ0FEAAJd3zUAaycqYXJfF8MShxEw
         0TFE98sE3Me9eZM0FtLM3ch0qZ4yhxLuFVrJNSbBNjPCwhakBaGem+CILOLwV4HSVW4y
         tGhDNEA3oKGCIVDAD5ACvciLgsFzx/erHJFu9CVfYz0VL3sxo2KzXTuo23IR7waKgHRg
         LWq0wWA63BYr1PTjWUNErh6fMMTc0dJpW9e4QumTMSuNZ2EOB1UT0a/PyM4slUYRLUqI
         0A02jkzkE9kEo/U15k3k2NeA5UufzajLOxaqQ/yoa+F/cZx6VplmUbnb9mLqogzimoun
         M8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wNQEiv2Curb6hQD/17jdXcqsigImEVaW4IOMLah0Lcw=;
        b=dm5x6zkgXBDbw+GBxbCvXlXogh88138F4TgvgNcDSaVWzPLHY6FGqSc6PYlJW6CR9D
         jMmMNxp1N5XilA1zUon/yCCrSS+eMANIfjIDZxZJaj9vFGo1xvztnRBk2RLEbZtfrEcw
         O5tkQ7iVRupzBL6J+3cjKat+4//oq1onsPBANyhkHLPGX8S9ohyz0E2iPPPvtKIol2sO
         cL03sFZJt+rlPFZ2LVvsYwR43f7o8l0EnKeEyF+VdODdTNt9JK0v2Dp2Ln/3x4q9OWpT
         U1/vaP8dMPEQit73pIIkz38WzVge1GxDIVhlZrQ1BbCCE7TZVNDjnDco1shZ/l7J/uu+
         lluw==
X-Gm-Message-State: AOAM531KgTBejMTcOZ6gPMISmI9yXzvVkOk0w12jRpn7vqi57nwcVGdK
        zDXePk90FdZmQfzNOy8Aa0QTxz2d1cOumNczB8Rw+pPbzayROw==
X-Google-Smtp-Source: ABdhPJxSMwWKM72MQmFJwvYjm7t7SzgevJ2VJbjtPRfWcIYUv2ryGLdNigH2iTYsSybuPuh5BiMUh5gJMwulvZkJxK4=
X-Received: by 2002:ac2:419a:: with SMTP id z26mr8295111lfh.307.1624136298738;
 Sat, 19 Jun 2021 13:58:18 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 19 Jun 2021 15:58:07 -0500
Message-ID: <CAH2r5mu7qEexR2ivEfm0pAoFVJe2Orm7nWRPLMNyYpT_9kURkQ@mail.gmail.com>
Subject: [PATCH][CIFS] Fix uninitialized variable in SMB1 POSIX query info
 error path
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000276cd405c524b312"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000276cd405c524b312
Content-Type: text/plain; charset="UTF-8"

Fix SMB1 error path in cifs_get_file_info_unix.
We were trying to fill in uninitialized file attributes in the error case.

Addresses-Coverity: 139689 ("Uninitialized variables")


-- 
Thanks,

Steve

--000000000000276cd405c524b312
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-SMB1-error-path-in-cifs_get_file_info_unix.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-SMB1-error-path-in-cifs_get_file_info_unix.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq48s9pn0>
X-Attachment-Id: f_kq48s9pn0

RnJvbSAyMDljZWYyNDNmNDU0OGRlZDkzNDlkNWM2OTlhNzNhMmU0OGFiZDQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTkgSnVuIDIwMjEgMTU6NTM6MTggLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggU01CMSBlcnJvciBwYXRoIGluIGNpZnNfZ2V0X2ZpbGVfaW5mb191bml4CgpXZSB3
ZXJlIHRyeWluZyB0byBmaWxsIGluIHVuaW5pdGlhbGl6ZWQgZmlsZSBhdHRyaWJ1dGVzIGluIHRo
ZSBlcnJvciBjYXNlLgoKQWRkcmVzc2VzLUNvdmVyaXR5OiAxMzk2ODkgKCJVbmluaXRpYWxpemVk
IHZhcmlhYmxlcyIpClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9z
b2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2lub2RlLmMgfCA1ICsrKystCiAxIGZpbGUgY2hhbmdlZCwg
NCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9pbm9k
ZS5jIGIvZnMvY2lmcy9pbm9kZS5jCmluZGV4IDFkZmE1Nzk4MjUyMi4uZjYwZjA2OGQzM2U4IDEw
MDY0NAotLS0gYS9mcy9jaWZzL2lub2RlLmMKKysrIGIvZnMvY2lmcy9pbm9kZS5jCkBAIC0zNjcs
OSArMzY3LDEyIEBAIGNpZnNfZ2V0X2ZpbGVfaW5mb191bml4KHN0cnVjdCBmaWxlICpmaWxwKQog
CX0gZWxzZSBpZiAocmMgPT0gLUVSRU1PVEUpIHsKIAkJY2lmc19jcmVhdGVfZGZzX2ZhdHRyKCZm
YXR0ciwgaW5vZGUtPmlfc2IpOwogCQlyYyA9IDA7Ci0JfQorCX0gZWxzZQorCQlnb3RvIGNpZnNf
Z2ZpdW5peF9vdXQ7CiAKIAlyYyA9IGNpZnNfZmF0dHJfdG9faW5vZGUoaW5vZGUsICZmYXR0cik7
CisKK2NpZnNfZ2ZpdW5peF9vdXQ6CiAJZnJlZV94aWQoeGlkKTsKIAlyZXR1cm4gcmM7CiB9Ci0t
IAoyLjMwLjIKCg==
--000000000000276cd405c524b312--
