Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90ED6C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Feb 2022 06:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiBGGSU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Feb 2022 01:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiBGEur (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Feb 2022 23:50:47 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA4EC043181
        for <linux-cifs@vger.kernel.org>; Sun,  6 Feb 2022 20:50:46 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id n8so24466163lfq.4
        for <linux-cifs@vger.kernel.org>; Sun, 06 Feb 2022 20:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=PQ7+LdtWbkHWKNl9CTBFFg0xqgyq3ew9jM8gttjb63o=;
        b=BIHggsgchtMJCtkz67QLTwqqJlnDOEdxa1FVL8moLHB18ArJsr/9ZlKOKwxBQKo0Lb
         f9OvSpCAQ8TuImTKsQ/9dV4SypJLrvdulJhso4IdWC7Nwcc1VICF4u0d018CRoHX8llI
         yw2G6W1fqkxZlN3v/GpH4aSzKL0sxCYXZSbNUWSBO6nUIp4sQBkMqaBB/5cGmaQzhWM0
         29BAtDTO8Iz5u8aWoDV/LPXEMrmRfckWtbpruDrSiBVTGdugCqmLHOSXMOwIdF900DfZ
         rVi7RBpz2r69QuwOykR6gxzq7T5W1b4O54HYYn29cGGn/B7EsUPpdz1Ya9tcQWh0tdd7
         t0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PQ7+LdtWbkHWKNl9CTBFFg0xqgyq3ew9jM8gttjb63o=;
        b=6V4FlBrVe9oVoCiS97sUr1oCFnDKgQmHQhieG3VMfBr6BIQl52bWfivaGF748NEgMJ
         GS7xMa6F+BkKiT6RoTHBd4aK3zQN7JQG1y4RYPXRrIjVMZPdlB708pqJwzPlFOWYDyRl
         ntVGptIhurgES9HpR/2YjcHzMLO/ej83pwj4nz72TQ0xkoupCpMlNye0Dpm1Q0tb47PV
         tup0xvJxHz8IslTp9GeEpbWkVVRSjLy3AQ8S7LAJCOoqMcK9nSELlWz7NqiusBQ2Aow1
         Jk5GSTs8/DK4B/zLrLXTuFUT2Ac1MyxSCwyGhR36bUIVxxly2QXz7o0UE7xUOzaEynNh
         +ucA==
X-Gm-Message-State: AOAM533J9OAwlyY80sgRhva08ePxxwyJVklRad62OnRICOAkN79pni1b
        j8ujMX6EaeFy/LOZFAQaZUTw1sCds8yXUA4NGCkjZSFNgw8=
X-Google-Smtp-Source: ABdhPJykm5Y+6IbGiCS/Tj/T+htH6UaNQjF+KQmq/1ngcrOPOimVdV8yqs4UX5a/+4cc9mkCdp/WsHqvaCHhaQd+Qog=
X-Received: by 2002:ac2:5df6:: with SMTP id z22mr7242326lfq.601.1644209444646;
 Sun, 06 Feb 2022 20:50:44 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 6 Feb 2022 22:50:33 -0600
Message-ID: <CAH2r5msPYuG-jUxBkqCz5tYg80JGpnjYTVXZFzzwRKwLJxdmFw@mail.gmail.com>
Subject: [PATCH][SMB3] improve error message when mount options conflict with posix
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e2a3b905d76657c3"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e2a3b905d76657c3
Content-Type: text/plain; charset="UTF-8"

POSIX extensions require SMB3.1.1 (so improve the error
    message when vers=3.0, 2.1 or 2.0 is specified on mount)


-- 
Thanks,

Steve

--000000000000e2a3b905d76657c3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-improve-error-message-when-mount-options-confli.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-improve-error-message-when-mount-options-confli.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kzc7tn3k0>
X-Attachment-Id: f_kzc7tn3k0

RnJvbSBkMGNiZTU2YTdkNWFjMTcwZjZjZjM3NTdlZjVhMTRkZDg1NGU3ZGE5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgNiBGZWIgMjAyMiAxODo1OTo1NyAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFtz
bWIzXSBpbXByb3ZlIGVycm9yIG1lc3NhZ2Ugd2hlbiBtb3VudCBvcHRpb25zIGNvbmZsaWN0IHdp
dGgKIHBvc2l4CgpQT1NJWCBleHRlbnNpb25zIHJlcXVpcmUgU01CMy4xLjEgKHNvIGltcHJvdmUg
dGhlIGVycm9yCm1lc3NhZ2Ugd2hlbiB2ZXJzPTMuMCwgMi4xIG9yIDIuMCBpcyBzcGVjaWZpZWQg
b24gbW91bnQpCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29m
dC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0LmMgfCAxMSArKysrKysrKysrLQogMSBmaWxlIGNo
YW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9j
aWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4IDBiNzQyYmQ1MDY0Mi4uY2Zm
NmMwMWZlYWUyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nv
bm5lY3QuYwpAQCAtMjM0MCwxMCArMjM0MCwxOSBAQCBjaWZzX2dldF90Y29uKHN0cnVjdCBjaWZz
X3NlcyAqc2VzLCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpCiAJCWlmIChzZXMtPnNlcnZl
ci0+cG9zaXhfZXh0X3N1cHBvcnRlZCkgewogCQkJdGNvbi0+cG9zaXhfZXh0ZW5zaW9ucyA9IHRy
dWU7CiAJCQlwcl93YXJuX29uY2UoIlNNQjMuMTEgUE9TSVggRXh0ZW5zaW9ucyBhcmUgZXhwZXJp
bWVudGFsXG4iKTsKLQkJfSBlbHNlIHsKKwkJfSBlbHNlIGlmICgoc2VzLT5zZXJ2ZXItPnZhbHMt
PnByb3RvY29sX2lkID09IFNNQjMxMV9QUk9UX0lEKSB8fAorCQkgICAgKHN0cmNtcChzZXMtPnNl
cnZlci0+dmFscy0+dmVyc2lvbl9zdHJpbmcsCisJCSAgICAgU01CM0FOWV9WRVJTSU9OX1NUUklO
RykgPT0gMCkgfHwKKwkJICAgIChzdHJjbXAoc2VzLT5zZXJ2ZXItPnZhbHMtPnZlcnNpb25fc3Ry
aW5nLAorCQkgICAgIFNNQkRFRkFVTFRfVkVSU0lPTl9TVFJJTkcpID09IDApKSB7CiAJCQljaWZz
X2RiZyhWRlMsICJTZXJ2ZXIgZG9lcyBub3Qgc3VwcG9ydCBtb3VudGluZyB3aXRoIHBvc2l4IFNN
QjMuMTEgZXh0ZW5zaW9uc1xuIik7CiAJCQlyYyA9IC1FT1BOT1RTVVBQOwogCQkJZ290byBvdXRf
ZmFpbDsKKwkJfSBlbHNlIHsKKwkJCWNpZnNfZGJnKFZGUywgIkNoZWNrIHZlcnM9IG1vdW50IG9w
dGlvbi4gU01CMy4xMSAiCisJCQkJImRpc2FibGVkIGJ1dCByZXF1aXJlZCBmb3IgUE9TSVggZXh0
ZW5zaW9uc1xuIik7CisJCQlyYyA9IC1FT1BOT1RTVVBQOworCQkJZ290byBvdXRfZmFpbDsKIAkJ
fQogCX0KIAotLSAKMi4zMi4wCgo=
--000000000000e2a3b905d76657c3--
