Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CD9C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 09:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB5A61186
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 09:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhKJJRZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Nov 2021 04:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhKJJRY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Nov 2021 04:17:24 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F70C061764
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 01:14:37 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id f3so4347986lfu.12
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 01:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=NALQny5Gc91lNAaNsPWqzKB2dJi+SoLff9+VUIRbOcA=;
        b=SPTLRbOO/C6r8GVSmu7VOgKSXWzpYFWCUl/6GdjPQBG/JXU6Y7CT/rdYW/D8jruLGG
         MQP81nSZAN73/X03OHNOgpWJT2dkFDk64jOgQMlvF/KGkMxPPfefxBEZWQyrndJ63om/
         15OPdIjcND2/FHbt26qEZgHUEjuh2xffHMB7d7sLCr6nKMs3YXRAFK6uTKRIg4pRnsPE
         mq/R2rLUZhaBzzmnRbFThc8QIIGH3o0kzn7osMVWOSPIWzkeZTzh5R31XtF6FTaalg43
         swt3ioEoKNUmXg+hpbHQSTH06F27LvbEJTEwV6ayQjxM0g//G4BFhjawxotP17ilgm0s
         mksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NALQny5Gc91lNAaNsPWqzKB2dJi+SoLff9+VUIRbOcA=;
        b=1oh87k79+IS4U7sqryY24Lw4bTz+1eejDT1HNA9AUvfXe2vfMpYx83GKlYK1XVR7qv
         3IeJbXALAlJtwI41JFii5vBLBLBfNp5NqhfFcTK5WiJ+n+OHZrTdFF+4P324OyaaVY/t
         1y6hruoysiaaPwRIm7c4jPWOlXxVUpLq7cF8RFAfDNoQzNNy8umYridmF0GuWsY0vINK
         pj8NmHYItPA+sT8rY3M/E0NeJ9ro/GPV3TRyuvYjR9G3ujnCMJStiGYp+m+631Jzy6L6
         Q8qcYOUMNgor9V6EUcEP24I8+M7FdqpF4nNjIoNdrlaRCKKqWzvk1mrX56kIwLu+rwam
         R3Dg==
X-Gm-Message-State: AOAM530r+T2PMGGchJ/FB1/6GPMtATxkjC0AFMSmgpqsRfAFP8YYkdEf
        ySfTD+UkDz67b4131weZavF1jTSiNA6wdmJT6nk4Vwf9
X-Google-Smtp-Source: ABdhPJwtudKm0RwoEc6HGdRcaRY+fFaU09Xs97g8RFQ06BAA6YDnMuoPUs2s3ycSRGDs2/oRX6bZGjeT1ZZNEZ+IfFg=
X-Received: by 2002:a05:6512:3763:: with SMTP id z3mr13213625lft.601.1636535675529;
 Wed, 10 Nov 2021 01:14:35 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Nov 2021 03:14:24 -0600
Message-ID: <CAH2r5mtcGWchWxk8S7MCJa6zsuJZy6bxuwX7SeGm5K7MTT59cw@mail.gmail.com>
Subject: patch to removing minor DFS compile warnings
To:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000009a9b0305d06ba7fc"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000009a9b0305d06ba7fc
Content-Type: text/plain; charset="UTF-8"

  CHECK   /home/smfrench/cifs-2.6/fs/cifs/connect.c
/home/smfrench/cifs-2.6/fs/cifs/connect.c:4137:5: warning: symbol
'__tree_connect_dfs_target' was not declared. Should it be static?
/home/smfrench/cifs-2.6/fs/cifs/connect.c:4236:5: warning: symbol
'tree_connect_dfs_target' was not declared. Should it be static?


--
Thanks,

Steve

--0000000000009a9b0305d06ba7fc
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-remove-trivial-dfs-compile-warning.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-remove-trivial-dfs-compile-warning.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvtb2uta0>
X-Attachment-Id: f_kvtb2uta0

RnJvbSBjMTRhOTQyNGRjMzYwYTkxMjVjYjRlNzU1OGJhZmU5NDI2YmMwNWYxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTAgTm92IDIwMjEgMDM6MDk6NTIgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiByZW1vdmUgdHJpdmlhbCBkZnMgY29tcGlsZSB3YXJuaW5nCgpGaXggd2FybmluZyBjYXVz
ZWQgYnkgcmVjZW50IGNoYW5nZXMgdG8gdGhlIGRmcyBjb2RlOgoKc3ltYm9sICd0cmVlX2Nvbm5l
Y3RfZGZzX3RhcmdldCcgd2FzIG5vdCBkZWNsYXJlZC4gU2hvdWxkIGl0IGJlIHN0YXRpYz8KCkNj
OiBQYXVsbyBBbGNhbnRhcmEgKFNVU0UpIDxwY0BjanIubno+ClNpZ25lZC1vZmYtYnk6IFN0ZXZl
IEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8
IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4
IGMwN2Q1OTE1YjliMC4uZjY0NWY5OTRhNTIzIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3Qu
YworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtNDEzNCw3ICs0MTM0LDcgQEAgc3RhdGljIGlu
dCB0YXJnZXRfc2hhcmVfbWF0Y2hlc19zZXJ2ZXIoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2Vy
dmVyLCBjb25zdCBjaGEKIAlyZXR1cm4gcmM7CiB9CiAKLWludCBfX3RyZWVfY29ubmVjdF9kZnNf
dGFyZ2V0KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCitz
dGF0aWMgaW50IF9fdHJlZV9jb25uZWN0X2Rmc190YXJnZXQoY29uc3QgdW5zaWduZWQgaW50IHhp
ZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCSAgICAgIHN0cnVjdCBjaWZzX3NiX2luZm8g
KmNpZnNfc2IsIGNoYXIgKnRyZWUsCiAJCQkgICAgICBzdHJ1Y3QgZGZzX2NhY2hlX3RndF9saXN0
ICp0bCwgc3RydWN0IGRmc19pbmZvM19wYXJhbSAqcmVmKQogewpAQCAtNDIzMyw3ICs0MjMzLDcg
QEAgaW50IF9fdHJlZV9jb25uZWN0X2Rmc190YXJnZXQoY29uc3QgdW5zaWduZWQgaW50IHhpZCwg
c3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAlyZXR1cm4gcmM7CiB9CiAKLWludCB0cmVlX2Nvbm5l
Y3RfZGZzX3RhcmdldChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLAorc3RhdGljIGludCB0cmVlX2Nvbm5lY3RfZGZzX3RhcmdldChjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJICAgIHN0cnVjdCBjaWZzX3NiX2lu
Zm8gKmNpZnNfc2IsIGNoYXIgKnRyZWUsCiAJCQkgICAgc3RydWN0IGRmc19jYWNoZV90Z3RfbGlz
dCAqdGwsIHN0cnVjdCBkZnNfaW5mbzNfcGFyYW0gKnJlZikKIHsKLS0gCjIuMzIuMAoK
--0000000000009a9b0305d06ba7fc--
