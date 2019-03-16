Return-Path: <SRS0=lfdc=RT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767B2C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 20:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BFFE218D0
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 20:46:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eeYBanXm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfCPUqz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:46:55 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:38577 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfCPUqz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Mar 2019 16:46:55 -0400
Received: by mail-pf1-f180.google.com with SMTP id n125so8637381pfn.5
        for <linux-cifs@vger.kernel.org>; Sat, 16 Mar 2019 13:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=mJ2JCSerem9o8SyEnq2fK97fTg5RR4nUzhUwehMRodM=;
        b=eeYBanXmmzOADmA0A7SOD9ccG1UKGkH88KAiMcOFkku7CFI3oBJbnQzEm3LpawNS6C
         Stn4JnOU1reTYiDMcJ+pWHKW/N6JrhE54Kirn2QD4rAtbgQ4G4PETk4sOG/EO/8Qd375
         YuCKIci/uLhx7KAuK2l8SInAAUPHsOk7ZxGZsOfx/q6hDOeFYS4a4xWcUgPhTchnyJSB
         UUl6mkIa0XV5ycpFj6woWR0EfhwvXrmX4ZuY3rc4G/Fkdl2GpYAM5XK+0sga3/XTRO8K
         IrpTp20WlhTdOQt9UJU/A62UmA3T+JNhLAZ8ckqEjTlykjlgritI2vqf4VI9IQwbPM6Q
         b4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=mJ2JCSerem9o8SyEnq2fK97fTg5RR4nUzhUwehMRodM=;
        b=detgOxOXblIoPqF7YUACLN4lWBZdeQaRV1KtJfiBIhhwFPQQNvsAiWD7z6bklCw8kZ
         sO7CUN7fybZ4nL4ttRjghISlBgnXpvluSet5a3mWRHPMRWkZzZ7LwOghDYI0/L1asQfN
         8Nf9jJfQMZ65B7ppWzQtCnOHzoTL7CubMWnB4qiN82jKP8IsdlqYjyRc1WEuH82duvo3
         C3d2lXiqu9PgwRScAEe3NboghCy1lR9aKOQbTUpDm/LEe/OhxajRCBVQmb/zzbCUtjYC
         Uy7rl0ZcUif9sMI42U0RC/tdt2283ykiBjh12kNVtZxKDPkwehfdmbBWtC0vmmy4Hhi+
         tL8g==
X-Gm-Message-State: APjAAAWjIHzK33dosC6wr1nYQivXl1yGYz1jNVyhFYsiwboGtXtLL++t
        v3Mv26TeZiJ40Ph/KS4LBW8KtFReLp+ZrTj7tsw=
X-Google-Smtp-Source: APXvYqyl4D+Bf+rrJLlohcHdgzJdS3K0X81EJguKv0ePZGkt8qRkfoL2NiLXv41GO13Vn8+EJLEmB5p+Cb0Nnyn/9nQ=
X-Received: by 2002:a17:902:1744:: with SMTP id i62mr11384382pli.24.1552769214471;
 Sat, 16 Mar 2019 13:46:54 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 16 Mar 2019 15:46:42 -0500
Message-ID: <CAH2r5ms6rN=Wh8P5hMtdQT01Ve9SLyogYYUVS5xLq6WSz_-_FQ@mail.gmail.com>
Subject: [PATCH] [SMBINFO] add missing usage text for fsctl-getobjid
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000072917b05843c415a"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000072917b05843c415a
Content-Type: text/plain; charset="UTF-8"

By the way this (getobjid FSCTL) could be useful for Samba server to
add support for - seems useful (to know a unique identifier for the
volume, and for the file at 'birth').





-- 
Thanks,

Steve

--00000000000072917b05843c415a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smbinfo-missing-help-for-fsctl-getobjid.patch"
Content-Disposition: attachment; 
	filename="0001-smbinfo-missing-help-for-fsctl-getobjid.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jtbyoant0>
X-Attachment-Id: f_jtbyoant0

RnJvbSAxZGU1NGVmZTIzMmYxNjFiNjMwM2Q3Y2I2MDA0Nzk4MTZlODRlZjE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTYgTWFyIDIwMTkgMTU6NDI6NDAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWJpbmZvOiBtaXNzaW5nIGhlbHAgZm9yIGZzY3RsLWdldG9iamlkCgpBZGQgdXNhZ2UgZGVzY3Jp
cHRpb24gZm9yIG5ldyBvcHRpb24gZnNjdGwtZ2V0b2JqaWQKClNlZSBzZWN0aW9uIDIuMS4zLjEg
b2YgTVMtRlNDQwoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3Nv
ZnQuY29tPgotLS0KIHNtYmluZm8uYyB8IDQgKysrLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL3NtYmluZm8uYyBiL3NtYmluZm8u
YwppbmRleCAyNjgxMTRiLi4zM2ZjYTk1IDEwMDY0NAotLS0gYS9zbWJpbmZvLmMKKysrIGIvc21i
aW5mby5jCkBAIC04OCw3ICs4OCw5IEBAIHVzYWdlKGNoYXIgKm5hbWUpCiAJCSIgIHNlY2Rlc2M6
XG4iCiAJCSIgICAgICBQcmludHMgdGhlIHNlY3VyaXR5IGRlc2NyaXB0b3IgZm9yIGEgY2lmcyBm
aWxlLlxuIgogCQkiICBxdW90YTpcbiIKLQkJIiAgICAgIFByaW50cyB0aGUgcXVvdGEgZm9yIGEg
Y2lmcyBmaWxlLlxuIiwKKwkJIiAgICAgIFByaW50cyB0aGUgcXVvdGEgZm9yIGEgY2lmcyBmaWxl
LlxuIgorCQkiICBmc2N0bC1nZXRvYmppZDpcbiIKKwkJIiAgICAgIFByaW50cyB0aGUgb2JqZWN0
aWQgb2YgdGhlIGZpbGUgYW5kIEdVSUQgb2YgdGhlIHVuZGVybHlpbmcgdm9sdW1lLlxuIiwKIAkJ
bmFtZSk7CiAJZXhpdCgxKTsKIH0KLS0gCjIuMTcuMQoK
--00000000000072917b05843c415a--
