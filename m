Return-Path: <SRS0=mIXx=TJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F012C04AAF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 May 2019 04:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49DC520989
	for <linux-cifs@archiver.kernel.org>; Thu,  9 May 2019 04:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFRQsnGg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfEIEh1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 May 2019 00:37:27 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:44253 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfEIEh1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 May 2019 00:37:27 -0400
Received: by mail-pf1-f179.google.com with SMTP id g9so593205pfo.11
        for <linux-cifs@vger.kernel.org>; Wed, 08 May 2019 21:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=diAdZ54Z6L91gN8pxCLk4ZF12brlkm64ieBPXxkRE7M=;
        b=gFRQsnGgEWNUo+ZjuVEzmIGfZnV6y2dCZorUH8AfzoXbXhcT8zWlgHT1DubiJ3W7RU
         wVQDOnna2o9j5IoT7HRlLWEWZAyGpeeC9aIw/CW3d8BNRnThZ63wktFW3HKFB/WTGTZv
         6isWBbvK4Odb+843qufkZAImUXCfSAWIQxeAQDQ6a4nQByD0WBn3IRND+nns/Sj4OiVb
         iM2BVpujw8eTccqYSvaunVQZ/C2oWMJtPeHLpSflK37Lg829RgIYtxvuGw8UhgeGCPPL
         x4MHoWjeuKM0ijGSGBzHhgJHYHtV6B9vVH7z0D/tihKYKbAyH6GWLZN7fCKv/sjVxihe
         bWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=diAdZ54Z6L91gN8pxCLk4ZF12brlkm64ieBPXxkRE7M=;
        b=jZJgTQFxBL/tHHzF3VX2+xn2krp9E8603GQGrxEIwMC8XKUhMUphRVBK2gNkshSr9T
         Ew8U8B0glFZFm93OMNoaJTNUK71KaiKZBTeVa1V3jBriMC3VDYxeajo9AT/RAyZGdZ95
         Pcti6zaGjSB1/4sTI/ezI9Avf+hjmW2mPWkY1+mjirbtuRYAPXTF46ZIntf0qMDicJmM
         IFUl9stkqJ3tPrSA0ZmvVA9d6woSPSneYixWMWmJ6loQYatMV6vwWUBcEoUK5bCtaVUn
         w3jzXR+VCQw1J4c+wiwYSW3Wyyxk2Rf0+i/v2K+311eaN/gScBpQ7+PWRpjQYdKdajDu
         Of8w==
X-Gm-Message-State: APjAAAWBMSAZCRTVzkPit0zMGJcvFizcPijzcVlbIPX5ffV0EZv+N+dJ
        5H5heJp2lBoobsyNQvxr1umn9RTgnDmjq50b/TwIbg==
X-Google-Smtp-Source: APXvYqwzfWO+Sx3BzG9Of84K1oDceQcT5zB4JQzRzOENIFKK3ZIrPnZInfA8iAXFsR3dzzj32qARPV460bIRH4RzKKk=
X-Received: by 2002:a63:f843:: with SMTP id v3mr2805338pgj.69.1557376646251;
 Wed, 08 May 2019 21:37:26 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 8 May 2019 23:37:14 -0500
Message-ID: <CAH2r5mtP-mPWTO0gCHraUg6m=V5WNH0u1dOnd=k4114Z8AVE6w@mail.gmail.com>
Subject: [SMB3][PATCH] Display session id in /proc/fs/cifs/DebugData
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000c8c24b05886d014b"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c8c24b05886d014b
Content-Type: text/plain; charset="UTF-8"

Pavel noticed that we don't display the session id in
/proc/fs/cifs/DebugData yet it is important.  Patch to add this
attached

--
Thanks,

Steve

--000000000000c8c24b05886d014b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-display-session-id-in-debug-data.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-display-session-id-in-debug-data.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jvg5u2dz0>
X-Attachment-Id: f_jvg5u2dz0

RnJvbSBmN2RlMzM3ZjljZmYwNDcwZDBkMWRiMDQ5NGExZDFmY2QxYTk4ZTFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgOCBNYXkgMjAxOSAyMjo0MTozNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGRpc3BsYXkgc2Vzc2lvbiBpZCBpbiBkZWJ1ZyBkYXRhCgpEaXNwbGF5aW5nIHRoZSBzZXNz
aW9uIGlkIGluIC9wcm9jL2ZzL2NpZnMvRGVidWdEYXRhCmlzIG5lZWRlZCBpbiBvcmRlciB0byBj
b3JyZWxhdGUgTGludXggY2xpZW50IGluZm9ybWF0aW9uCndpdGggbmV0d29yayBhbmQgc2VydmVy
IHRyYWNlcyBmb3IgbWFueSBjb21tb24gc3VwcG9ydApzY2VuYXJpb3MuCgpTaWduZWQtb2ZmLWJ5
OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZz
X2RlYnVnLmMgfCAyICsrCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9jaWZzX2RlYnVnLmMgYi9mcy9jaWZzL2NpZnNfZGVidWcuYwppbmRleCA2
YTY5ZjExYWFjZjcuLmJlZjc4YjNhOTNkMyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzX2RlYnVn
LmMKKysrIGIvZnMvY2lmcy9jaWZzX2RlYnVnLmMKQEAgLTM4MCw2ICszODAsOCBAQCBzdGF0aWMg
aW50IGNpZnNfZGVidWdfZGF0YV9wcm9jX3Nob3coc3RydWN0IHNlcV9maWxlICptLCB2b2lkICp2
KQogCQkJCWF0b21pY19yZWFkKCZzZXJ2ZXItPmluX3NlbmQpLAogCQkJCWF0b21pY19yZWFkKCZz
ZXJ2ZXItPm51bV93YWl0ZXJzKSk7CiAjZW5kaWYKKwkJCS8qIGR1bXAgc2Vzc2lvbiBpZCBoZWxw
ZnVsIGZvciB1c2Ugd2l0aCBuZXR3b3JrIHRyYWNlICovCisJCQlzZXFfcHJpbnRmKG0sICIgU2Vz
c2lvbklkOiAlbGx1Iiwgc2VzLT5TdWlkKTsKIAkJCWlmIChzZXMtPnNlc3Npb25fZmxhZ3MgJiBT
TUIyX1NFU1NJT05fRkxBR19FTkNSWVBUX0RBVEEpCiAJCQkJc2VxX3B1dHMobSwgIiBlbmNyeXB0
ZWQiKTsKIAkJCWlmIChzZXMtPnNpZ24pCi0tIAoyLjIwLjEKCg==
--000000000000c8c24b05886d014b--
