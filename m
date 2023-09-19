Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A05CD343F
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Sep 2023 06:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjISGVV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Sep 2023 02:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjISGVU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Sep 2023 02:21:20 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF16E191
        for <linux-cifs@vger.kernel.org>; Mon, 18 Sep 2023 23:20:56 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-502984f5018so8818417e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 18 Sep 2023 23:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695104454; x=1695709254; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vn/Ef8dEo50kPl9ZS7d92kvxbOdIpVpVXkjKTfy4vTY=;
        b=Ir0u0cj8Du0V3bZDSKzO0rXob7PymN2xdCJRORaVjOTovsIrBoVEfgcGP1uvHneN8n
         MjDWNzjI3LPQNuCM8lHeX/wxykdU+/JeTPvBfLXU+lcsYK2xnvqlD7RaZ3Pf8/YHmtOf
         R8hfOOlHxUCDgVpgjODijGz8fvicr+oFQuLYVT7jLq1AWuhiZov0GzuZCK4ypVhNIPId
         aY5MP+Wk6w/tNTC6Lzm0Z/hxF5sasAX1n/dNH0sEBbxd1RYEXyKRGimg6KKFjRDVinPp
         RHwLQDcluIfQyisDylVDbKOxxUlTuh3E+R9Hvr52e/ezN5nYDyR6zZbTp9/K8Um3BROk
         FxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695104454; x=1695709254;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vn/Ef8dEo50kPl9ZS7d92kvxbOdIpVpVXkjKTfy4vTY=;
        b=TopVeLDwLOiAMrztIRmB1rILdexM8MrPDyKKjrV0JX3XGa5SUMHZ9IuIB6ho2XmG2q
         UsboH4+q8hZF7Iq7R317Xjukc3FWPUvsPVmVnK+SE53fuj+YOx9c9xuFcsp3XzG+0smK
         nQ1MMT9Cj975ChBwHW7SOL8g37lJpwFCmC2FcdLCIQB7lYkV9k0VJieHgiFNfL7ux8Fb
         1ymwHO/ZSKhWslmSAORlUERJqZpAM7ouRLNmKb8CIf19VyHImwcunqEcKR1eVelo/sUY
         9FlWThUXRGZUDjm39fTn+vaxj5kWIpg5Gg1kfpQ6Ng9t8liRM1B9m0pkPTJxmKB+Yg9Y
         LUNw==
X-Gm-Message-State: AOJu0YwQsbbCzHbH1nrsvjM1D6kzu8cr/6Sr71+18MtUz/oLgLpVTvsJ
        mQGU1lrJzJmVW53jC19xcnj+sEbQKgFBD6MHxZcAbQCL6h4=
X-Google-Smtp-Source: AGHT+IH/4ib678LjeuzM8k5t4MmxPp5ujt4edKL/rgV0u70EpOaO5aAcm8kd6KzgySMzURPfXXRmazE8Vb9X1e5+Eic=
X-Received: by 2002:a19:4f1a:0:b0:4ff:95c:e158 with SMTP id
 d26-20020a194f1a000000b004ff095ce158mr9132996lfb.64.1695104454039; Mon, 18
 Sep 2023 23:20:54 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 19 Sep 2023 01:20:42 -0500
Message-ID: <CAH2r5mssSM9HhMXVu8570jX7Yx1CyERhjeg4S+Rp77HWrTHb6g@mail.gmail.com>
Subject: [PATCH][SMB3 client] add dynamic trace points for smbdirect (RDMA) connect
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Tom Talpey <tom@talpey.com>,
        samba-technical <samba-technical@lists.samba.org>,
        Paulo Alcantara <pc@manguebit.com>
Content-Type: multipart/mixed; boundary="000000000000d784080605b042ef"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d784080605b042ef
Content-Type: text/plain; charset="UTF-8"

     smb3_smbd_connect_done and smb3_smbd_connect_err

To improve debugging of RDMA issues add those two new tracepoints. We
already had dynamic tracepoints for the non-RDMA connect done and
error cases, but didn't for the smbdirect cases.

See attached patch

-- 
Thanks,

Steve

--000000000000d784080605b042ef
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Add-dynamic-trace-points-for-RDMA-smbdirect-reconnec.patch"
Content-Disposition: attachment; 
	filename="0001-Add-dynamic-trace-points-for-RDMA-smbdirect-reconnec.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lmpxdyd70>
X-Attachment-Id: f_lmpxdyd70

RnJvbSBmYjI2OTdhNTYxZjcyYjI4MDIzNjk3OTY4ZmFjZTFlYzI1ZGE4NTc1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTkgU2VwIDIwMjMgMDE6MTQ6MzkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBB
ZGQgZHluYW1pYyB0cmFjZSBwb2ludHMgZm9yIFJETUEgKHNtYmRpcmVjdCkgcmVjb25uZWN0Cgog
ICAgIHNtYjNfc21iZF9jb25uZWN0X2RvbmUgYW5kIHNtYjNfc21iZF9jb25uZWN0X2VycgoKVG8g
aW1wcm92ZSBkZWJ1Z2dpbmcgb2YgUkRNQSBpc3N1ZXMgYWRkIHRob3NlIHR3by4gV2UgYWxyZWFk
eQpoYWQgZHluYW1pYyB0cmFjZXBvaW50cyBmb3Igbm9uLVJETUEgY29ubmVjdCBkb25lIGFuZCBl
cnJvciBjYXNlcy4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9z
b2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L3NtYmRpcmVjdC5jIHwgNSArKysrLQogZnMvc21i
L2NsaWVudC90cmFjZS5oICAgICB8IDIgKysKIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWJkaXJlY3Qu
YyBiL2ZzL3NtYi9jbGllbnQvc21iZGlyZWN0LmMKaW5kZXggMmEyYWVjOGM2MTEyLi4yYTlmMDY0
Y2NjNmEgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iZGlyZWN0LmMKKysrIGIvZnMvc21i
L2NsaWVudC9zbWJkaXJlY3QuYwpAQCAtMTQwMSw4ICsxNDAxLDExIEBAIGludCBzbWJkX3JlY29u
bmVjdChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJc2VydmVyLT5zbWJkX2Nvbm4g
PSBzbWJkX2dldF9jb25uZWN0aW9uKAogCQlzZXJ2ZXIsIChzdHJ1Y3Qgc29ja2FkZHIgKikgJnNl
cnZlci0+ZHN0YWRkcik7CiAKLQlpZiAoc2VydmVyLT5zbWJkX2Nvbm4pCisJaWYgKHNlcnZlci0+
c21iZF9jb25uKSB7CiAJCWNpZnNfZGJnKFZGUywgIlJETUEgdHJhbnNwb3J0IHJlLWVzdGFibGlz
aGVkXG4iKTsKKwkJdHJhY2Vfc21iM19zbWJkX2Nvbm5lY3RfZG9uZShzZXJ2ZXItPmhvc3RuYW1l
LCBzZXJ2ZXItPmNvbm5faWQsICZzZXJ2ZXItPmRzdGFkZHIpOworCX0gZWxzZQorCQl0cmFjZV9z
bWIzX3NtYmRfY29ubmVjdF9lcnIoc2VydmVyLT5ob3N0bmFtZSwgc2VydmVyLT5jb25uX2lkLCAm
c2VydmVyLT5kc3RhZGRyKTsKIAogCXJldHVybiBzZXJ2ZXItPnNtYmRfY29ubiA/IDAgOiAtRU5P
RU5UOwogfQpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC90cmFjZS5oIGIvZnMvc21iL2NsaWVu
dC90cmFjZS5oCmluZGV4IGE3ZTQ3NTViZWQwZi4uZGUxOTllYzlmNzI2IDEwMDY0NAotLS0gYS9m
cy9zbWIvY2xpZW50L3RyYWNlLmgKKysrIGIvZnMvc21iL2NsaWVudC90cmFjZS5oCkBAIC05MzUs
NiArOTM1LDggQEAgREVGSU5FX0VWRU5UKHNtYjNfY29ubmVjdF9jbGFzcywgc21iM18jI25hbWUs
ICBcCiAJVFBfQVJHUyhob3N0bmFtZSwgY29ubl9pZCwgYWRkcikpCiAKIERFRklORV9TTUIzX0NP
Tk5FQ1RfRVZFTlQoY29ubmVjdF9kb25lKTsKK0RFRklORV9TTUIzX0NPTk5FQ1RfRVZFTlQoc21i
ZF9jb25uZWN0X2RvbmUpOworREVGSU5FX1NNQjNfQ09OTkVDVF9FVkVOVChzbWJkX2Nvbm5lY3Rf
ZXJyKTsKIAogREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX2Nvbm5lY3RfZXJyX2NsYXNzLAogCVRQ
X1BST1RPKGNoYXIgKmhvc3RuYW1lLCBfX3U2NCBjb25uX2lkLAotLSAKMi4zOS4yCgo=
--000000000000d784080605b042ef--
