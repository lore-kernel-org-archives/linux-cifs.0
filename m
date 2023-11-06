Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B02C4332F
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Nov 2023 19:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjKFTjN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Nov 2023 14:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbjKFTjA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Nov 2023 14:39:00 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D8D30D7
        for <linux-cifs@vger.kernel.org>; Mon,  6 Nov 2023 11:37:34 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-507bd64814fso6573961e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 06 Nov 2023 11:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699299452; x=1699904252; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5ALoxbMVm3+5AgYaHkckLLZwvjeKchBftBYzbJ/bn/M=;
        b=dqJkG4YwJgBmhozuCeBkPCLDThP+CvzRGJPUATzprJHsgW4ZqFqhBUIeSjfNMsO34L
         Uy8SC0PKqowFKGt7dMIFtywoxhHoCiEJDSDktRgp/b5V0LsQa2WaVvxKht110EQymj3X
         wIO5TRwS33nyp+JhV5yKmjtZjxgA6RoX1H8Jb2FMsqiRYy+qmh4pqkTa3697+X0ga36Y
         uzTTx1slBaSyN97iTB/yVsOtfXcaCsUJBERpUsShlBepH/EOqRUo3+9hQW63r3Jzb3x5
         jHvMrDpuvskNzwEXH5jVDu/jOkhleptPPlgBVB+lvJiVBccI+0yjdGwE46ZWr+K4VA6C
         nI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699299452; x=1699904252;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5ALoxbMVm3+5AgYaHkckLLZwvjeKchBftBYzbJ/bn/M=;
        b=JiRIONSPiOcEC0mQINXXdzrMrdH+Wv0no7hsxOzPY3X7XkXB62VFRTWEx7gEPlk/Ho
         OA4lwA9OBVw5a+jjYtBE2RG/+4l+dF+NHShhm2hfvxHzDqiQsyGty1UnHluVCbNTk6Vf
         1RWmkN7yIBg70T18XdwWq0Wx5kNOYGqu2nDdH5Zp/P9mH+3F5BaoDxqI08eyTdWHTfqZ
         8lfXuh1Wls2mp4LIA94TQY+Xg/Xkuz+ONrmnwK7AT1XPMXBrm3Uhqp75tl5z0ae2ivb7
         IQLENVGZbNvCGVCdl0GNNEFj/WoENfM84f80MWVfAWw0ZiL0d9+x8bwnNYmUBLjtrEp0
         td4Q==
X-Gm-Message-State: AOJu0YxhI/zDxZu+IpAHb8T5s/b/uWLt3v5khRVnuqpOARt/8qeD+T2f
        VC6xvXkiCW0EpAk5OvlIRFOnU/hYVscuevK/LLklhw1B2TP4qw==
X-Google-Smtp-Source: AGHT+IFgexWQeANMuBA/LxQ2MTL1h9jY23B1QYNU4ZTPh7kkpfeamCXjZ5lolYs7T7U+zW1HfkFRlnpy3+MNaD75v14=
X-Received: by 2002:ac2:4c82:0:b0:507:9a33:f105 with SMTP id
 d2-20020ac24c82000000b005079a33f105mr19796237lfl.69.1699299452048; Mon, 06
 Nov 2023 11:37:32 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 6 Nov 2023 13:37:20 -0600
Message-ID: <CAH2r5mu1TEV7hGG0_Bv8ukcG3bGc7PpATdYMRPZJCz1t1yFQZg@mail.gmail.com>
Subject: Minor smbdirect cleanup
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Long Li <longli@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000350927060980fc9a"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000350927060980fc9a
Content-Type: text/plain; charset="UTF-8"

See attached (minor rdma/smbdirect cleanup)

spotted when ran checkpatch against cifs_debug.c

-- 
Thanks,

Steve

--000000000000350927060980fc9a
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-smb3-minor-RDMA-cleanup.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-minor-RDMA-cleanup.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lonazxg80>
X-Attachment-Id: f_lonazxg80

RnJvbSAwNTYyZGZjOTlhOTFkNWZhZmY1OGM1MTJiNzZhOGYzYmIzM2E2MTVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgNiBOb3YgMjAyMyAxMzozMTo0NSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IG1pbm9yIFJETUEgY2xlYW51cAoKU29tZSBtaW5vciBzbWJkaXJlY3QgZGVidWcgY2xlYW51
cCBzcG90dGVkIGJ5IGNoZWNrcGF0Y2gKCkNjOiBMb25nIExpIDxsb25nbGlAbWljcm9zb2Z0LmNv
bT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgot
LS0KIGZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGll
bnQvY2lmc19kZWJ1Zy5jIGIvZnMvc21iL2NsaWVudC9jaWZzX2RlYnVnLmMKaW5kZXggMTMyYmEy
Nzc0MzhmLi41NTk2YzlmMzBjY2IgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc19kZWJ1
Zy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jCkBAIC03NjcsMTQgKzc2NywxNCBA
QCBzdGF0aWMgc3NpemVfdCBuYW1lIyNfd3JpdGUoc3RydWN0IGZpbGUgKmZpbGUsIGNvbnN0IGNo
YXIgX191c2VyICpidWZmZXIsIFwKIAlzaXplX3QgY291bnQsIGxvZmZfdCAqcHBvcykgXAogeyBc
CiAJaW50IHJjOyBcCi0JcmMgPSBrc3RydG9pbnRfZnJvbV91c2VyKGJ1ZmZlciwgY291bnQsIDEw
LCAmIG5hbWUpOyBcCisJcmMgPSBrc3RydG9pbnRfZnJvbV91c2VyKGJ1ZmZlciwgY291bnQsIDEw
LCAmbmFtZSk7IFwKIAlpZiAocmMpIFwKIAkJcmV0dXJuIHJjOyBcCiAJcmV0dXJuIGNvdW50OyBc
CiB9IFwKIHN0YXRpYyBpbnQgbmFtZSMjX3Byb2Nfc2hvdyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHZv
aWQgKnYpIFwKIHsgXAotCXNlcV9wcmludGYobSwgIiVkXG4iLCBuYW1lICk7IFwKKwlzZXFfcHJp
bnRmKG0sICIlZFxuIiwgbmFtZSk7IFwKIAlyZXR1cm4gMDsgXAogfSBcCiBzdGF0aWMgaW50IG5h
bWUjI19vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKSBcCi0tIAoy
LjM5LjIKCg==
--000000000000350927060980fc9a--
