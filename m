Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE8DC433B4
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 08:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BD8561418
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 08:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239886AbhD2IOy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Apr 2021 04:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240006AbhD2IN5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Apr 2021 04:13:57 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60CFC06138D
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 01:13:05 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id g38so77404526ybi.12
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 01:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=b76vM1IypgnkZqfSEHZRmw6Z7RUnNV/uUjNjj4OAp2c=;
        b=qwnK4XPV6Lg4Z9hwWFHJSROExv/dnoUwcs+mBBOLGvzKL/rASwCkgBFkvL1f7idxVV
         c332W7dvfWFju2W8dmvGmUNtT2HlhBCYLJlhcZ5TVkR8xUcu5Ngj9+M/DUSOLWS0imG7
         6zk3281YP4aMjBEaMrODK97cy1B+lyzHM7Lt0dSng2Zqnd2jHjEJNWa4pFykrhYaCEmj
         wFJSi5LyhLyw+O1hF7ufE9tB3/eFfK9scIG3X3fJgOKj5XyX667itOK7GCEABbt12gEK
         yl+aNqvshEE8Bdy7r31iY0qCrNUYxupDBW6Uee3Arc2D9xVEgbX9lkQtuHWvg3suc4HJ
         AdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=b76vM1IypgnkZqfSEHZRmw6Z7RUnNV/uUjNjj4OAp2c=;
        b=iAXAB1JiqMyIOq0iMYwG3sRg4+7mFCPhMA4nILg50NRjpYf8DpUi+9uZIalXuQaRjt
         reyXoyFXDdpuXuDJ07P+QcPXH2AhmXTRTnJScwcVqJsws7viCkj4DOhEW8x1BrWFFjw2
         8/SzIiIxKNgLztE3D66ReDCIY/ZVg8PdwdnLlpYHupSgTVG3Alyj4iXSzCCCmWi0XYRa
         l1t1zTxP0YgN8LJOQ6IIXVvOMTVTZeP/kqd40E8ChM+X3S+GXD7CN2bwtMJkz4eksyu5
         rG8D4oWnKCWNI34N8vHT+tjRqHH9VWUbRDupV0v9Nsh1mMRdAf58uEDs/doiW7F6lNAm
         Rs4g==
X-Gm-Message-State: AOAM5338L1vprQK+VruT3lLYFAFYty/L56hPZ52MKkMjLPYwXZgFU4FW
        idsrdyHb9ekTMdRUFdMuWWaKrdu7vsmfB9wzcpc=
X-Google-Smtp-Source: ABdhPJy+peJSkVJxVpwPtGTyrhZeRmXDtKtwRU+yFKUf/w5A03jji5lKFUYh++WRqy2ODGufoVxkdn83kXLODd6xOIo=
X-Received: by 2002:a25:41d5:: with SMTP id o204mr2800047yba.185.1619683984841;
 Thu, 29 Apr 2021 01:13:04 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 29 Apr 2021 13:42:53 +0530
Message-ID: <CANT5p=qykPGoWwtfSdXe9BsXp083M9-7zaAXJgkPok0Onp6Zow@mail.gmail.com>
Subject: [PATCH] cifs: detect dead connections only when echoes are enabled.
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="00000000000090b8e205c1181092"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000090b8e205c1181092
Content-Type: text/plain; charset="UTF-8"

Hi,

Recently, some xfstests and later some manual testing on multi-channel
revealed that we detect unresponsive servers on some of the channels
to the same server.

The issue is seen when a channel is setup and sits idle without any
traffic. Generally, we enable echoes and oplocks on a channel during
the first request, based on the number of credits available on the
channel. So on idle channels, we trip in our logic to check server
unresponsiveness.

Attached a one-line fix for this. Have tested it in my environment.
Another approach to fix this could be to enable echoes during
initialization of a server struct. Or soon after the session setup.
But I felt that this approach is better. Let me know if you feel
otherwise.

Please review and comment.

-- 
Regards,
Shyam

--00000000000090b8e205c1181092
Content-Type: application/octet-stream; 
	name="0001-cifs-detect-dead-connections-only-when-echoes-are-en.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-detect-dead-connections-only-when-echoes-are-en.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ko2lnv290>
X-Attachment-Id: f_ko2lnv290

RnJvbSBkYzYwNGUwOWVhZGYwNjAzZTJmM2RkYzdlZWVlMGY4MWU4ZDU2NTJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDI5IEFwciAyMDIxIDA3OjUzOjE4ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogZGV0ZWN0IGRlYWQgY29ubmVjdGlvbnMgb25seSB3aGVuIGVjaG9lcyBhcmUgZW5hYmxl
ZC4KCldlIGNhbiBkZXRlY3Qgc2VydmVyIHVucmVzcG9uc2l2ZW5lc3Mgb25seSBpZiBlY2hvZXMg
YXJlIGVuYWJsZWQuCkVjaG9lcyBjYW4gYmUgZGlzYWJsZWQgdW5kZXIgdHdvIHNjZW5hcmlvczoK
MS4gVGhlIGNvbm5lY3Rpb24gaXMgbG93IG9uIGNyZWRpdHMsIHNvIHdlJ3ZlIGRpc2FibGVkIGVj
aG9lcy9vcGxvY2tzLgoyLiBUaGUgY29ubmVjdGlvbiBoYXMgbm90IHNlZW4gYW55IHJlcXVlc3Qg
dGlsbCBub3cgKG90aGVyIHRoYW4KbmVnb3RpYXRlL3Nlc3Mtc2V0dXApLCB3aGljaCBpcyB3aGVu
IHdlIGVuYWJsZSB0aGVzZSB0d28sIGJhc2VkIG9uCnRoZSBjcmVkaXRzIGF2YWlsYWJsZS4KClNv
IHRoaXMgZml4IHdpbGwgY2hlY2sgZm9yIGRlYWQgY29ubmVjdGlvbiwgb25seSB3aGVuIGVjaG8g
aXMgZW5hYmxlZC4KClNpZ25lZC1vZmYtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jv
c29mdC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0LmMgfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9j
b25uZWN0LmMKaW5kZXggMTIxZDhiNDUzNWIwLi5kNDMwZTU3ZTc0YmMgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC00NzYsNiArNDc2LDcg
QEAgc2VydmVyX3VucmVzcG9uc2l2ZShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJ
ICovCiAJaWYgKChzZXJ2ZXItPnRjcFN0YXR1cyA9PSBDaWZzR29vZCB8fAogCSAgICBzZXJ2ZXIt
PnRjcFN0YXR1cyA9PSBDaWZzTmVlZE5lZ290aWF0ZSkgJiYKKwkJc2VydmVyLT5lY2hvZXMgJiYK
IAkgICAgdGltZV9hZnRlcihqaWZmaWVzLCBzZXJ2ZXItPmxzdHJwICsgMyAqIHNlcnZlci0+ZWNo
b19pbnRlcnZhbCkpIHsKIAkJY2lmc19zZXJ2ZXJfZGJnKFZGUywgImhhcyBub3QgcmVzcG9uZGVk
IGluICVsdSBzZWNvbmRzLiBSZWNvbm5lY3RpbmcuLi5cbiIsCiAJCQkgKDMgKiBzZXJ2ZXItPmVj
aG9faW50ZXJ2YWwpIC8gSFopOwotLSAKMi4yNS4xCgo=
--00000000000090b8e205c1181092--
