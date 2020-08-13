Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F299FC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 17:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9B1520791
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 17:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A29Iym1n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgHMRoc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 13:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHMRoc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 13:44:32 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CEBC061757
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 10:44:32 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id t4so6274082iln.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 10:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=0NvUBAxpwY9jLqU7UP+ur67fA7ah0X6B2GiOdMW3lvs=;
        b=A29Iym1nZAv1N0AnlyFviset6wr+pizwAZ7n2FJZYNTXP3/FarUZnZ+QtIjCV3rAbM
         9r8uvJ4fZpY+pzMVYc4hLDXgG7WHfHFQv9V68yTrPmHJHtN/bQqJFsRouGshWjyy+yrT
         t4i17zqyjNy0cZEHY18y5bQeSFWezvt3Lotq0HSTcjHBfQrqQUrr9RNU1lbwPD4tuRKN
         6gcTnXr5mv8H4UKjXtMNILgbHlqMajvAfCi6tf4ZHYKWgj6Alsyd1R8hqFNcnbcyVTq5
         GbxEn3tsCIkFAV+TEdWZDyWFsTIIcjTjWbPGrXTB5Vu4lU0t3aBZ0SKv5z6rdq4Yp+sj
         o44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0NvUBAxpwY9jLqU7UP+ur67fA7ah0X6B2GiOdMW3lvs=;
        b=mGkSbkUeQfb3ljNqeUuMzzcmmmxreqgL3W45vVXXUN0qd0B5c5XnLUbbHcxW1AzmDT
         SKgncn8XK+0EttzCaGNiamvpSX73h1n1n/B/QfzMUcz7L1VkwMlU/DG2r6Lpi930d8bV
         k4MbyAWDvHwqVheoniRe4mhQdv9XeJ29stQ8p8jVEWMkLkhfHD5h8Oh5hRF+//ZIAO48
         bEWy5D6idYyzSRxFc61vvWXh4+QNhw7JzdFyDNEJaOR3Z6z55Q7kuwo7TCd2yzql/+xF
         jH76ZSb2ednI5BUUNzQwVu4gLAvPLiMSOvUZhbjIoqrE0DmUhabAaPUu/x2f1oNoYPGP
         ITrw==
X-Gm-Message-State: AOAM5332xsFgJRrZJiUX8DjdRmDsDTdiIBRSZe6dUhoJd9MwTLruEdiL
        WLCd2NI/F9ITcknFtZYakXwxKt/XcWPEMUYvGPwTlB3K174=
X-Google-Smtp-Source: ABdhPJx9O+uNkcRXuqaO6e0CjTRygVnuHCo+ykmVbA9ji8j0h/Gh5pIWi/sEiDqi4UjQfPKjdbsT/XNuFyRG9dvvz5E=
X-Received: by 2002:a92:849b:: with SMTP id y27mr5944654ilk.173.1597340670126;
 Thu, 13 Aug 2020 10:44:30 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 13 Aug 2020 12:44:19 -0500
Message-ID: <CAH2r5ms-cXJzTqbTuE8_095aUssB8RvaqBTkfY2gHROjg7GsAQ@mail.gmail.com>
Subject: [PATCH][SMB3] Fix mkdir when idsfromsid configured on mount
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000003a968405acc5db9e"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003a968405acc5db9e
Content-Type: text/plain; charset="UTF-8"

    mkdir uses a compounded create operation which was not setting
    the security descriptor on create of a directory. Fix so
    mkdir now sets the mode and owner info properly when idsfromsid
    and modefromsid are configured on the mount.


-- 
Thanks,

Steve

--0000000000003a968405acc5db9e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Fix-mkdir-when-idsfromsid-configured-on-mount.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Fix-mkdir-when-idsfromsid-configured-on-mount.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kdt3dv670>
X-Attachment-Id: f_kdt3dv670

RnJvbSBjOGUyZDk1OWRkYWM4OWVlNDRmMTcwYjJmMjU0OWU3NDk1ODFlYzU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTMgQXVnIDIwMjAgMTI6Mzg6MDggLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBGaXggbWtkaXIgd2hlbiBpZHNmcm9tc2lkIGNvbmZpZ3VyZWQgb24gbW91bnQKCm1rZGly
IHVzZXMgYSBjb21wb3VuZGVkIGNyZWF0ZSBvcGVyYXRpb24gd2hpY2ggd2FzIG5vdCBzZXR0aW5n
CnRoZSBzZWN1cml0eSBkZXNjcmlwdG9yIG9uIGNyZWF0ZSBvZiBhIGRpcmVjdG9yeS4gRml4IHNv
Cm1rZGlyIG5vdyBzZXRzIHRoZSBtb2RlIGFuZCBvd25lciBpbmZvIHByb3Blcmx5IHdoZW4gaWRz
ZnJvbXNpZAphbmQgbW9kZWZyb21zaWQgYXJlIGNvbmZpZ3VyZWQgb24gdGhlIG1vdW50LgoKU2ln
bmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgpDQzogU3Rh
YmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIHY1LjgKLS0tCiBmcy9jaWZzL3NtYjJpbm9k
ZS5jIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRpZmYgLS1naXQgYS9m
cy9jaWZzL3NtYjJpbm9kZS5jIGIvZnMvY2lmcy9zbWIyaW5vZGUuYwppbmRleCBiOWRiNzM2ODdl
YWEuLmViYTAxZDA5MDhkZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyaW5vZGUuYworKysgYi9m
cy9jaWZzL3NtYjJpbm9kZS5jCkBAIC0xMTUsNiArMTE1LDcgQEAgc21iMl9jb21wb3VuZF9vcChj
b25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCXZhcnMtPm9w
YXJtcy5maWQgPSAmZmlkOwogCXZhcnMtPm9wYXJtcy5yZWNvbm5lY3QgPSBmYWxzZTsKIAl2YXJz
LT5vcGFybXMubW9kZSA9IG1vZGU7CisJdmFycy0+b3Bhcm1zLmNpZnNfc2IgPSBjaWZzX3NiOwog
CiAJcnFzdFtudW1fcnFzdF0ucnFfaW92ID0gJnZhcnMtPm9wZW5faW92WzBdOwogCXJxc3RbbnVt
X3Jxc3RdLnJxX252ZWMgPSBTTUIyX0NSRUFURV9JT1ZfU0laRTsKLS0gCjIuMjUuMQoK
--0000000000003a968405acc5db9e--
