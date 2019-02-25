Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C96C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 21:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51D9020842
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 21:09:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UfV6AiYL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfBYVJg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 16:09:36 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:41160 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfBYVJg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 16:09:36 -0500
Received: by mail-pf1-f180.google.com with SMTP id d25so5064859pfn.8
        for <linux-cifs@vger.kernel.org>; Mon, 25 Feb 2019 13:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hlIY92BUHVul7uCzgI0/Fxjoy+j12yglFMemkjgc5E8=;
        b=UfV6AiYLSDkPhg1NNfiDY9BmRais3pjC2qViGEbFz+8KT367BdeCi40zqHAE/YNKCG
         0H4q4ZNHmiA57/Z+HpTeLXh4TX9qpn9NR16bLi9zBnOcfIqBvrejNAf2YUEVvLWsGCXP
         4RkBoO8YriKg16IPzaPItWsfb/Q/A2AYmGJjKRj3+4vf6WbAD6yYO/HwupnHAtXN5n+w
         qKIkmlBCx49pimsCBAQ3HJgwUHDcylzRSLY7kW38wCciXtCle8S8nBi7kNwehOe3mP5e
         7XQY3CSY3pjkn0IiAvVifLy7DlMcPbzuynxNG3Doa6iSiPPBi0nE0bKbNwylxV+Yrrpv
         XjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hlIY92BUHVul7uCzgI0/Fxjoy+j12yglFMemkjgc5E8=;
        b=IbF1oYIY3IFMgxtteBZl+2WaLKMKB1ZSBKZIZxSi0pQAZNDdy7KjXuros2QXgaNvie
         zeKKHZHAg6VF80HDrENmv53B3jqGWqoYNQ335H0Ziet4jd8OTJSQXkqc/DYzhQQXMHT3
         WOwj8gl+7xTJgBQ+1mIxiUatuYvGetSn82xEXgyod9iGb5q2vXAycJiTgrWCWq2gvexj
         CNOa0eHTuvay4Grc2KCXfTs/calyQ9+afhis/tlOWlEl1IP+3IPz3xcbnda72+Qnszuw
         aDasOV/xplrjVwKt1oKIKfWRpaKxzZfQFYBiwWzVvmz/9s+1OvdlS1kBtrA640Ir2Ier
         THLA==
X-Gm-Message-State: AHQUAuaIZLW8jqLHBKQOeqQKpr0Lrcf2bRBH3YnLUG4FS0Im3LYWXQjZ
        2ewCiSEW27jtaB3q8H0tT3ptc5N8gefKXeHcX7RP4A==
X-Google-Smtp-Source: AHgI3IZ5IvD0lMICjmriGTSsTurWFqi4acmVRwWpu0gt/2XTVdiTYqH2xiskVGPNB1F3DwjbpFwuGVkgIfw6HtZXW2g=
X-Received: by 2002:a65:508b:: with SMTP id r11mr1036417pgp.242.1551128975377;
 Mon, 25 Feb 2019 13:09:35 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Feb 2019 15:09:23 -0600
Message-ID: <CAH2r5msw+fWYYm1tDFOcpy4Cny6asUOLyEpG+A1dUFbPwaKGUw@mail.gmail.com>
Subject: [PATCH] Missing read completion trace point
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000009434c80582be5bc6"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000009434c80582be5bc6
Content-Type: text/plain; charset="UTF-8"

We were missing one path in dynamic traces of smb3 reads (when ENODATA returned)



-- 
Thanks,

Steve

--0000000000009434c80582be5bc6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-missing-read-completion-trace-point.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-missing-read-completion-trace-point.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsku4icf0>
X-Attachment-Id: f_jsku4icf0

RnJvbSA5NzQ3ZjYzOWJkNDQ0NmY5OGQxZGQwNWRlNTNhYzc2ZTU1NjlkNzA3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjUgRmViIDIwMTkgMTU6MDI6NTggLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgbWlzc2luZyByZWFkIGNvbXBsZXRpb24gdHJhY2UgcG9pbnQKCldoZW4gRU5PREFU
QSByZXR1cm5lZCB3ZSB3ZXJlbid0IGxvZ2dpbmcgdGhlIHJlYWQgY29tcGxldGlvbgoobm90IGFu
IGVycm9yLCBidXQgY2FuIGJlIGluZGljYXRlZCBieSBsb2dnaW5nIGxlbmd0aCAwKSB3aGljaApt
YWtlcyBsb29raW5nIGF0IHJlYWQgdHJhY2VzIGNvbmZ1c2luZyBmb3Igc21iMy4KClNpZ25lZC1v
ZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZz
L3NtYjJwZHUuYyB8IDUgKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21i
MnBkdS5jCmluZGV4IGVjOWFiZTI5MzI3OS4uYzY4MjA3YjQ2ZDk4IDEwMDY0NAotLS0gYS9mcy9j
aWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMzQwNCw3ICszNDA0LDEw
IEBAIFNNQjJfcmVhZChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc19pb19wYXJt
cyAqaW9fcGFybXMsCiAJCQkJCSAgICBpb19wYXJtcy0+dGNvbi0+dGlkLCBzZXMtPlN1aWQsCiAJ
CQkJCSAgICBpb19wYXJtcy0+b2Zmc2V0LCBpb19wYXJtcy0+bGVuZ3RoLAogCQkJCQkgICAgcmMp
OwotCQl9CisJCX0gZWxzZQorCQkJdHJhY2Vfc21iM19yZWFkX2RvbmUoeGlkLCByZXEtPlBlcnNp
c3RlbnRGaWxlSWQsCisJCQkJICAgIGlvX3Bhcm1zLT50Y29uLT50aWQsIHNlcy0+U3VpZCwKKwkJ
CQkgICAgaW9fcGFybXMtPm9mZnNldCwgMCk7CiAJCWZyZWVfcnNwX2J1ZihyZXNwX2J1ZnR5cGUs
IHJzcF9pb3YuaW92X2Jhc2UpOwogCQlyZXR1cm4gcmMgPT0gLUVOT0RBVEEgPyAwIDogcmM7CiAJ
fSBlbHNlCi0tIAoyLjE3LjEKCg==
--0000000000009434c80582be5bc6--
