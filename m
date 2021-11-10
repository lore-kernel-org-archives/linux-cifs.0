Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DAFC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 09:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 000B061241
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 09:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhKJJXy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Nov 2021 04:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhKJJXy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Nov 2021 04:23:54 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E458C061764
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 01:21:06 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id e11so3914967ljo.13
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 01:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=X1OlPDF4EmsbfxJOTy/84UQNlfFv8Vf+Gr7OO9RQVcU=;
        b=WWgcicLJ93Z2kC6k+stgsJub6/FneP2DdcqTRu0pMV2lcqsj1xKRlE03G9z8OBP8HL
         weEr/zQSFmKuRduiY1BmpPe4t4FMH8OeePjIhpkfuvF2DYgsqwrg6N4FzBG5OrMKgdD5
         ESSLdfAAwyH78kbaOGXJ/lz6OHiGNPqzh0f4poSqS5TDCv8MGu2k9GUvmM+EBi4YPjPm
         sGVJ4QFhjfkB/VZQ9zmDbcNSR7AddLknAneTwbIL1ws+56xmHFGfW9cVJf1TuWbNfJiV
         EpY7F+xWGN+VojVfPL4qPr26JYqDv1IUf0vbnT2yeepyqfNIcmtmTAUjR/8Yrx9La4tp
         8IwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=X1OlPDF4EmsbfxJOTy/84UQNlfFv8Vf+Gr7OO9RQVcU=;
        b=8P3HlCdf7BSXE2s6dEooqOYiWeAhuYFSQWPyl5Ko91PVJNXXy9R+ZFEtQNxXTyxFQW
         U8Lbvi/RiPrjCZFFinibneR9HzGt+qVRCbTcZZpUUYmu6OKmSAIC6hXBty+Sxt7nxdwm
         j+wewgZqBdZCIGY5PVqhXeXy5bE01Ps1RXzc0gg2jM8yDJnCoKd+4mqL0tvp/5c8fjBK
         QMCC1K4l1WGFJ4JEF73G8uWR9P7VSSS0DG6b5ZdrqRt/J8B59cSoREjLOoOTG+so1/FK
         qxAt/MdElSEjYVgTD4HKxGv3RW5JmSaMlSQoW0L0tnsWm5a4+xAwJgxP+IOCsHpLVOwm
         G2WA==
X-Gm-Message-State: AOAM533bmKOt3Cb0mZrT0Bdb3eVvOfA9Pm16lrESn467cQVQY8NQ0Nxr
        j6AS1tDWFpE2hGkjWj1okIE0oRgE0WU34RrHZefoXgHoSok=
X-Google-Smtp-Source: ABdhPJwrmNj5Zxn7KYUnHAYuKril3V82VhtfXgBr6F2oQxV5ekITswS3fkx29G/OthzFjCEi2wWN17YybknWE5ZoZKs=
X-Received: by 2002:a2e:7114:: with SMTP id m20mr14463407ljc.229.1636536064837;
 Wed, 10 Nov 2021 01:21:04 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Nov 2021 03:20:53 -0600
Message-ID: <CAH2r5mvM2hEP6TTOWipZayRapLwZ-=BzrLBJDK_0J4ZHiRc6og@mail.gmail.com>
Subject: [PATCH] wait until we have the FS info from the server befor
 initializing fscache cookie
To:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ceff4c05d06bbe24"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ceff4c05d06bbe24
Content-Type: text/plain; charset="UTF-8"

With this patch now that the fscache cookie is initialized properly -
I do see an oops on the 2nd unmount if we mount the same share twice
... any ideas on fixing that?


    smb3: do not call setup the fscache_super_cookie until fsinfo initialized

    We were calling cifs_fscache_get_super_cookie after tcon but before
    we queried the info (QFS_Info) we need to initialize the cookie
    properly.

    Suggested-by: David Howells <dhowells@redhat.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>


-- 
Thanks,

Steve

--000000000000ceff4c05d06bbe24
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-do-not-call-setup-the-fscache_super_cookie-unti.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-do-not-call-setup-the-fscache_super_cookie-unti.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvtbb7910>
X-Attachment-Id: f_kvtbb7910

RnJvbSAwOTBmNTFhYjQ1NWRlZTI0OWE0YmMxMzQyOGY5NjRiZDdlODQ4OTU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTAgTm92IDIwMjEgMDM6MTU6MjkgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkbyBub3QgY2FsbCBzZXR1cCB0aGUgZnNjYWNoZV9zdXBlcl9jb29raWUgdW50aWwgZnNp
bmZvCiBpbml0aWFsaXplZAoKV2Ugd2VyZSBjYWxsaW5nIGNpZnNfZnNjYWNoZV9nZXRfc3VwZXJf
Y29va2llIGFmdGVyIHRjb24gYnV0IGJlZm9yZQp3ZSBxdWVyaWVkIHRoZSBpbmZvIChRRlNfSW5m
bykgd2UgbmVlZCB0byBpbml0aWFsaXplIHRoZSBjb29raWUKcHJvcGVybHkuCgpTdWdnZXN0ZWQt
Ynk6IERhdmlkIEhvd2VsbHMgPGRob3dlbGxzQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0
ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3Qu
YyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmlu
ZGV4IGY2NDVmOTk0YTUyMy4uMTg2Yzk1M2M0N2VjIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5l
Y3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMjM0OSw4ICsyMzQ5LDYgQEAgY2lmc19n
ZXRfdGNvbihzdHJ1Y3QgY2lmc19zZXMgKnNlcywgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4
KQogCWxpc3RfYWRkKCZ0Y29uLT50Y29uX2xpc3QsICZzZXMtPnRjb25fbGlzdCk7CiAJc3Bpbl91
bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKIAotCWNpZnNfZnNjYWNoZV9nZXRfc3VwZXJfY29v
a2llKHRjb24pOwotCiAJcmV0dXJuIHRjb247CiAKIG91dF9mYWlsOgpAQCAtMzAwMiw2ICszMDAw
LDggQEAgc3RhdGljIGludCBtb3VudF9nZXRfY29ubnMoc3RydWN0IG1vdW50X2N0eCAqbW50X2N0
eCkKIAkJCQljaWZzX2RiZyhWRlMsICJyZWFkIG9ubHkgbW91bnQgb2YgUlcgc2hhcmVcbiIpOwog
CQkJLyogbm8gbmVlZCB0byBsb2cgYSBSVyBtb3VudCBvZiBhIHR5cGljYWwgUlcgc2hhcmUgKi8K
IAkJfQorCQkvKiBUaGUgY29va2llIGlzIGluaXRpYWxpemVkIGZyb20gdm9sdW1lIGluZm8gcmV0
dXJuZWQgYWJvdmUgKi8KKwkJY2lmc19mc2NhY2hlX2dldF9zdXBlcl9jb29raWUodGNvbik7CiAJ
fQogCiAJLyoKLS0gCjIuMzIuMAoK
--000000000000ceff4c05d06bbe24--
