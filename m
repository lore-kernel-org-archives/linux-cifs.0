Return-Path: <SRS0=hW7M=4I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E72C34031
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Feb 2020 06:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A95324654
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Feb 2020 06:02:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YVQbzqV7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgBTGCe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Feb 2020 01:02:34 -0500
Received: from mail-il1-f169.google.com ([209.85.166.169]:41239 "EHLO
        mail-il1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgBTGCe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Feb 2020 01:02:34 -0500
Received: by mail-il1-f169.google.com with SMTP id f10so22695733ils.8
        for <linux-cifs@vger.kernel.org>; Wed, 19 Feb 2020 22:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KxsmKEiTS88kyWKQdpasQktV17phbtF1I5mwS48S9uA=;
        b=YVQbzqV7NvDXfk0E8OaJLuCqwVpOMtjM0013ide3ZLnXH4spXbNrbhpGIvfbldo33E
         AaE8KIYdQ+inH85hEUMLUK6HwnrqNTiykt/X8MngTTqcG+vguur1JrdOF3I0JTeajyfZ
         LWGzq94lGC9FtMPny0pHD6HfoA0uqh8VqCHGXgmNSchGgncbEFplzoa2/XoYzUqNwiJq
         mf4yCetqtsL4xA2E1ikRYel7OSc7QPh8RPqK35fpOuCWUZe+SPhpZjBvFzYTWufURVa8
         ZreyTphhagwWrREQlxyRNbJHdwxzmA8F7YCKJER+m27VdVVKgZXnARuMfOkwkL6zbO8y
         aK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KxsmKEiTS88kyWKQdpasQktV17phbtF1I5mwS48S9uA=;
        b=olVH1WceGN9qiT2z+uPOlAZMp/stk15aTjEa3HqtJLmxPOnbSIu6ilftWBiFWw58Lo
         97yiMaxzOOv6yKrJP7ROtit7cnZNSbONjA0hKm3/hcI+Xny1DSjRVK0NI4phqfc3A4Im
         aG2RrpUJbZaAot4jYvp6KIHxWGF8yfLcyQjOu4HK51XhNmJo9ePZh+d5rOyKKBHmfGiO
         O5YiITq9x1wXqG5vEjizUg4BW/HhWRBi05FLcNh0Z2h/MZVLeNIuTUUyZykdFUp6U2+f
         Soy/MiyZlRp8ejfWDlNKP2JXNXzS59TyRpEPbV+VHPTacACSiNj59vsCgtYz3Jimztx+
         Ap4g==
X-Gm-Message-State: APjAAAXSWrjjA7Zm8gprgjR7YtKrGdc7WTx8x456r1ztI1B4YQe7xh5t
        AXdwvKNSn977ygtlrCcDin5VlyAv3XGscvzQphLZs31/
X-Google-Smtp-Source: APXvYqxIYXqihUcgBsuPLM5WXdiE2J8/+68JiTS8z51LVtaMYsgOMIE/0kW8bpt9ymwuTkgp8YQCY1aZD5Pk0yj2nKA=
X-Received: by 2002:a92:9a90:: with SMTP id c16mr27302812ill.3.1582178553683;
 Wed, 19 Feb 2020 22:02:33 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 20 Feb 2020 00:02:22 -0600
Message-ID: <CAH2r5msy+zQCWdBARfdw5TTk1va3vXU9f3JcWmd_xgHASJj9jQ@mail.gmail.com>
Subject: [PATCH] [CIFS] Add missing mount option 'signloosely' to what is
 displayed in /proc/mounts
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ab5df3059efba6f0"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ab5df3059efba6f0
Content-Type: text/plain; charset="UTF-8"

    We were not displaying the mount option "signloosely" in /proc/mounts
    for cifs mounts which some users found confusing recently


-- 
Thanks,

Steve

--000000000000ab5df3059efba6f0
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-add-missing-mount-option-to-proc-mounts.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-add-missing-mount-option-to-proc-mounts.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k6uc8rho0>
X-Attachment-Id: f_k6uc8rho0

RnJvbSA0NWJmNjg1ODRjZTkzNzkzNmZlMDdkMjJhNzJiMjFiYTQ3ODZmMTc0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTkgRmViIDIwMjAgMjM6NTk6MzIgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBhZGQgbWlzc2luZyBtb3VudCBvcHRpb24gdG8gL3Byb2MvbW91bnRzCgpXZSB3ZXJlIG5v
dCBkaXNwbGF5aW5nIHRoZSBtb3VudCBvcHRpb24gInNpZ25sb29zZWx5IiBpbiAvcHJvYy9tb3Vu
dHMKZm9yIGNpZnMgbW91bnRzIHdoaWNoIHNvbWUgdXNlcnMgZm91bmQgY29uZnVzaW5nIHJlY2Vu
dGx5CgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
Ci0tLQogZnMvY2lmcy9jaWZzZnMuYyB8IDIgKysKIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMuYwpp
bmRleCA0NmViYWYzZjA4MjQuLmZhNzdmZTUyNThiMCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZz
ZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC01MzAsNiArNTMwLDggQEAgY2lmc19zaG93
X29wdGlvbnMoc3RydWN0IHNlcV9maWxlICpzLCBzdHJ1Y3QgZGVudHJ5ICpyb290KQogCiAJaWYg
KHRjb24tPnNlYWwpCiAJCXNlcV9wdXRzKHMsICIsc2VhbCIpOworCWVsc2UgaWYgKHRjb24tPnNl
cy0+c2VydmVyLT5pZ25vcmVfc2lnbmF0dXJlKQorCQlzZXFfcHV0cyhzLCAiLHNpZ25sb29zZWx5
Iik7CiAJaWYgKHRjb24tPm5vY2FzZSkKIAkJc2VxX3B1dHMocywgIixub2Nhc2UiKTsKIAlpZiAo
dGNvbi0+bG9jYWxfbGVhc2UpCi0tIAoyLjIwLjEKCg==
--000000000000ab5df3059efba6f0--
