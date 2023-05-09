Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE30C77B7C
	for <linux-cifs@archiver.kernel.org>; Tue,  9 May 2023 06:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbjEIGtO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 May 2023 02:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbjEIGsp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 May 2023 02:48:45 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1976AD043
        for <linux-cifs@vger.kernel.org>; Mon,  8 May 2023 23:48:43 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2ac7462d9f1so60582351fa.2
        for <linux-cifs@vger.kernel.org>; Mon, 08 May 2023 23:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683614921; x=1686206921;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bo9V9ZKkmXLgx/8ns8SX7trpZLoUO2dWHdvtCr5IC/c=;
        b=sbsWcyzdo8CQGv450/ek06kWa+pRia7srzpqZT/f3zS0aKsPVdi1nx7wFqbU/zFyUB
         hQazOBI1HOx6S0JQ4jq80EPq8tvBr3HvOv1CB1C4I7WWU4MSz1MPDrhIrSMI8ZuFM1w0
         M6CNJrTxfK0mxu9bf4r2gLT057L0ZTPJ6J068xSEnvCueR6kojPWU781byW5R9jOT8bN
         xk2iCD+wY2PSho0DNsv42AU0DpuuKbjAHVFGSIU4C0DHvRUKeK5BgRXF3RHWArqbiwQk
         pNbNiiPZFCshIifBNd293w1NuwteR6QgT7Tw8M8PHcOaIU4snY/7o8zjypTdFi2IFqlB
         sNdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683614921; x=1686206921;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bo9V9ZKkmXLgx/8ns8SX7trpZLoUO2dWHdvtCr5IC/c=;
        b=WYFvGlDwBEkDXKYQSVJ+t/frIb6xeuwhoWgGYe7GEJjXQMoPDRIwp+hgrHvy53+W0T
         q4LzN7zMoLiyeTBHWxk5wzAL1U2w3e5Ij4PW4KkR5txWs8Pe9K5sDw/dA5O5c6jVX4o9
         sYOBdSnPmiQ04gN4kDfu8vkZrfar8otGfoUhk27jNDkje64h8oqQeQ7HvyW04mDA2v87
         KaOA/0jBLlIdLT8R5G7FtrKf97KlfB5yvmvikC0CZqmlsesH/OwDboN3Shez5Kb6up+Y
         2oo0v8VY0ShoHDONOCweWNKb0Y0QgZv4Minmdj3ZyuDnpMZDyEFo8sF6vVZUcIr/Sfol
         rPAQ==
X-Gm-Message-State: AC+VfDyEJ0ELJyFwFsISOd1Arw46+o/Wf0NAKL2g3d9O+ojGouNlRC+5
        msuVXZ95GXV+LFf0dD5ZR9gDfLHgzG82AhpixrrgB/VTwu1I3Q==
X-Google-Smtp-Source: ACHHUZ7Vt/QUy5pAHpRyUVMRICD/rtF5Qryf0udnts+4icl79d4zQvdfb0sdCTwH31i62SbIBY3hedOKRmp0pswD1aM=
X-Received: by 2002:a2e:8883:0:b0:2a8:e53f:c174 with SMTP id
 k3-20020a2e8883000000b002a8e53fc174mr544275lji.26.1683614920436; Mon, 08 May
 2023 23:48:40 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 May 2023 01:48:29 -0500
Message-ID: <CAH2r5mvba99c2YKNgD3KQS5yytdWpudPpWAzw8idgL5=jUMJUg@mail.gmail.com>
Subject: [PATCH] smb3: fix problem remounting a share after shutdown
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000459a4a05fb3d2536"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000459a4a05fb3d2536
Content-Type: text/plain; charset="UTF-8"

xfstests generic/392 showed a problem where even after a
shutdown call was made on a mount, we would still attempt
to use the (now inaccessible) superblock if another mount
was attempted for the same share.

Reported-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Fixes: 087f757b0129 ("cifs: add shutdown support")

See attached

-- 
Thanks,

Steve

--000000000000459a4a05fb3d2536
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-problem-remounting-a-share-after-shutdown.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-problem-remounting-a-share-after-shutdown.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lhfwtt420>
X-Attachment-Id: f_lhfwtt420

RnJvbSBjZTNkZjgxNjlkMzE1NzlmMTczZTg1MmIxM2RiYjdlMTEzNjkzYzJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgOSBNYXkgMjAyMyAwMTozNzoxOSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCBwcm9ibGVtIHJlbW91bnRpbmcgYSBzaGFyZSBhZnRlciBzaHV0ZG93bgoKeGZzdGVz
dHMgZ2VuZXJpYy8zOTIgc2hvd2VkIGEgcHJvYmxlbSB3aGVyZSBldmVuIGFmdGVyIGEKc2h1dGRv
d24gY2FsbCB3YXMgbWFkZSBvbiBhIG1vdW50LCB3ZSB3b3VsZCBzdGlsbCBhdHRlbXB0CnRvIHVz
ZSB0aGUgKG5vdyBpbmFjY2Vzc2libGUpIHN1cGVyYmxvY2sgaWYgYW5vdGhlciBtb3VudAp3YXMg
YXR0ZW1wdGVkIGZvciB0aGUgc2FtZSBzaGFyZS4KClJlcG9ydGVkLWJ5OiBEYXZpZCBIb3dlbGxz
IDxkaG93ZWxsc0ByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogRGF2aWQgSG93ZWxscyA8ZGhvd2Vs
bHNAcmVkaGF0LmNvbT4KQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpGaXhlczogMDg3Zjc1
N2IwMTI5ICgiY2lmczogYWRkIHNodXRkb3duIHN1cHBvcnQiKQpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0LmMg
fCA3ICsrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4IGVlZWVkNmZkYTEz
Yi4uOGU5YTY3MjMyMGFiIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9j
aWZzL2Nvbm5lY3QuYwpAQCAtMjcwOSw2ICsyNzA5LDEzIEBAIGNpZnNfbWF0Y2hfc3VwZXIoc3Ry
dWN0IHN1cGVyX2Jsb2NrICpzYiwgdm9pZCAqZGF0YSkKIAogCXNwaW5fbG9jaygmY2lmc190Y3Bf
c2VzX2xvY2spOwogCWNpZnNfc2IgPSBDSUZTX1NCKHNiKTsKKworCS8qIFdlIGRvIG5vdCB3YW50
IHRvIHVzZSBhIHN1cGVyYmxvY2sgdGhhdCBoYXMgYmVlbiBzaHV0ZG93biAqLworCWlmIChDSUZT
X01PVU5UX1NIVVRET1dOICYgY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MpIHsKKwkJc3Bpbl91bmxv
Y2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKKwkJcmV0dXJuIDA7CisJfQorCiAJdGxpbmsgPSBjaWZz
X2dldF90bGluayhjaWZzX3NiX21hc3Rlcl90bGluayhjaWZzX3NiKSk7CiAJaWYgKHRsaW5rID09
IE5VTEwpIHsKIAkJLyogY2FuIG5vdCBtYXRjaCBzdXBlcmJsb2NrIGlmIHRsaW5rIHdlcmUgZXZl
ciBudWxsICovCi0tIAoyLjM0LjEKCg==
--000000000000459a4a05fb3d2536--
