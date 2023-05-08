Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405F1C77B75
	for <linux-cifs@archiver.kernel.org>; Mon,  8 May 2023 05:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjEHFhK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 May 2023 01:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjEHFhI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 May 2023 01:37:08 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593D6A271
        for <linux-cifs@vger.kernel.org>; Sun,  7 May 2023 22:37:06 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2ac79d4858dso45298731fa.2
        for <linux-cifs@vger.kernel.org>; Sun, 07 May 2023 22:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683524224; x=1686116224;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZS7iBiT3MqEhcXXQkzzeQcnpCKE5TAS9/DMn1oh0VNM=;
        b=ePfzG1OBB13l5ChKS6bHvHTNvxWThXVKgykVTmIWtkn9NTXfkumAZ/TWeQwjFZHM1X
         HOL4G3Nk1hjY6K39Fq0rGZx9cWjc/6mOBZeLk+7wklVX5Fl3x7+54YO+os9RK4tFH5Rr
         FzW4st/Vtl8QHCSV/6N1oXt7ZeEu/NbuOGU6gGkNxidStottOV1YAfanZOUVwwdVXVE3
         bznYfkMTq6dC/E313Zn/g9vcuIbq03ZqRThBmi0v0LHQiUW3y7S+ZZenf3WNSbp87E/1
         XaCzjY/8Cui+bOhK43lUsBruCKCnsnabY44TYN87pe3BguPZ++py4A9KTH4noqz2UVFL
         zktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683524224; x=1686116224;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZS7iBiT3MqEhcXXQkzzeQcnpCKE5TAS9/DMn1oh0VNM=;
        b=b/kEaT95PcaOpR6Qkcfn9/GJ7wHFVMg1t0UJTX7nKJSjgdUdEClaHeGevY6HNZ4gmO
         NqVpvjzjPO3Yuu+mBigIjy+yNYOgIdyuODR0NttK5wguyZVJa899Kzlz+kFRC/ZmEDgg
         Kbpg5uY1xuUagRVc15/72XjCC+1u56Spew50BvDhGPrfA1oujU5z0m8QcC5l72j20iwD
         fquEfvtdBmrazed1qU2CISPFuoUmm92Cvd/DnMeU0i3VNpNC3FirMq82yuLM4Et+l/Sc
         x9cUPFeAbCQ6P50GXjtWkGRdKAejrYNqWVYV6Oap7V6NXvk0CrXTaMJMIeXCyr1qEiy3
         bxEQ==
X-Gm-Message-State: AC+VfDy9XidRrE0eLOQG0k0jpxurLnTIB3g2iPDZr+rs7vZRuw2tzrM8
        l37cMeoV8oC+CnPoJ56xGw74e2MUr82uNzHINSe6qx2wy3d6uw==
X-Google-Smtp-Source: ACHHUZ4AbUTrDAhrw3HVUtrP9NNumAyAzWYCmsqkWoVEBS5WiP3TgTeOfH2JS4QC3ac6SKq2Z3DyAz6GCcnYj4IxVfQ=
X-Received: by 2002:a2e:93c3:0:b0:2a8:a5b8:185a with SMTP id
 p3-20020a2e93c3000000b002a8a5b8185amr2426649ljh.10.1683524223921; Sun, 07 May
 2023 22:37:03 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 8 May 2023 00:36:47 -0500
Message-ID: <CAH2r5mtN7BW6AoeNEAPM=+7YM2EUtxJJ9bt-ezsiFcDCYH+e4g@mail.gmail.com>
Subject: [PATCH][CIFS] do not reuse connection if share marked as isolated
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000005683d405fb2807b0"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005683d405fb2807b0
Content-Type: text/plain; charset="UTF-8"

"SHAREFLAG_ISOLATED_TRANSPORT" indicates that we should not reuse the socket
for this share (for future mounts).  Mark the socket as server->nosharesock if
share flags returned include SHAREFLAG_ISOLATED_TRANSPORT.

See MS-SMB2 MS-SMB2 2.2.10 and 3.2.5.5

See attached patch


-- 
Thanks,

Steve

--0000000000005683d405fb2807b0
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-do-not-reuse-connection-if-share-marked-as-.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-do-not-reuse-connection-if-share-marked-as-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lheeuekh0>
X-Attachment-Id: f_lheeuekh0

RnJvbSA0MzY1YTM5MWIxYjVjMGYyYTA2NWFiYWZhZmU0YWJkYTllOTYwMzhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgNyBNYXkgMjAyMyAxNzo1NzoxNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFtT
TUIzLjEuMV0gZG8gbm90IHJldXNlIGNvbm5lY3Rpb24gaWYgc2hhcmUgbWFya2VkIGFzCiBpc29s
YXRlZAoKIlNIQVJFRkxBR19JU09MQVRFRF9UUkFOU1BPUlQiIGluZGljYXRlcyB0aGF0IHdlIHNo
b3VsZCBub3QgcmV1c2UgdGhlCnNvY2tldCBmb3IgdGhpcyBzaGFyZSAoZm9yIGZ1dHVyZSBtb3Vu
dHMpLiAgTWFyayB0aGUgc29ja2V0IGFzCnNlcnZlci0+bm9zaGFyZXNvY2sgaWYgc2hhcmUgZmxh
Z3MgcmV0dXJuZWQgaW5jbHVkZQpTSEFSRUZMQUdfSVNPTEFURURfVFJBTlNQT1JULgoKU2VlIE1T
LVNNQjIgTVMtU01CMiAyLjIuMTAgYW5kIDMuMi41LjUKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZy
ZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8IDMg
KysrCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCBlMzNjYTBkMzM5MDYuLjllZDYx
YjZmOWIyMSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIy
cGR1LmMKQEAgLTE5NDcsNiArMTk0Nyw5IEBAIFNNQjJfdGNvbihjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywgY29uc3QgY2hhciAqdHJlZSwKIAlpbml0X2NvcHlf
Y2h1bmtfZGVmYXVsdHModGNvbik7CiAJaWYgKHNlcnZlci0+b3BzLT52YWxpZGF0ZV9uZWdvdGlh
dGUpCiAJCXJjID0gc2VydmVyLT5vcHMtPnZhbGlkYXRlX25lZ290aWF0ZSh4aWQsIHRjb24pOwor
CWlmIChyYyA9PSAwKSAvKiBTZWUgTVMtU01CMiAyLjIuMTAgYW5kIDMuMi41LjUgKi8KKwkJaWYg
KHRjb24tPnNoYXJlX2ZsYWdzICYgU01CMl9TSEFSRUZMQUdfSVNPTEFURURfVFJBTlNQT1JUKQor
CQkJc2VydmVyLT5ub3NoYXJlc29jayA9IHRydWU7CiB0Y29uX2V4aXQ6CiAKIAlmcmVlX3JzcF9i
dWYocmVzcF9idWZ0eXBlLCByc3ApOwotLSAKMi4zNC4xCgo=
--0000000000005683d405fb2807b0--
