Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4454AC43334
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Jun 2022 18:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbiFSSiR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 Jun 2022 14:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiFSSiQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 19 Jun 2022 14:38:16 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEA16265
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jun 2022 11:38:15 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id g6so8707186vsb.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jun 2022 11:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=WD1tJoTlVO8iMOFUha8+Jc8kIyGKD6D97x7uiglNq4I=;
        b=Gp03q5DjC1fX3IT0d5X8eDwOPUBVsPQa7lPbWLCj7z4qmRRAmrK6asFqm7SM4LuoHK
         XFRrjeln5r49JyM82lOroHiuai2pxblz0GPNozyzRmNnMwv/+hwadSaOPz2PHsFUhuAq
         18xb7tjVhbDwSCaR9V14ty4RjTHUHnhgKEVrotXzZ5Kxh4umfFndjgDwk19gbhFFnTez
         BNtWhRh4/Q4a6jfnZk3qltPig2zR8+onH3iFKEcXGEMUga5m/SsYBzbU2W299GYVvPE8
         JR5DmnnwBHWp0yURPAMdmRAw2+O9Jub61n9Y3ryW+/Q6mZzNxxU8hRcECV8yaPkvx8Zi
         h6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=WD1tJoTlVO8iMOFUha8+Jc8kIyGKD6D97x7uiglNq4I=;
        b=wqS/TPPp9kir991mQ3raND7A1+2Jb4ZGdvjhbtM0vYLcPcYb3CZpZIiacMHiEEdObz
         htnLyLKWI1vw1wfqlHK2KFeSnIbcJUrWKGzsNG8fSmsCLocmqaIIWY0shwXj4eq96JQM
         wIDrmw9U7BYfc2z9MANYylgwaYfdTQbhMKe9ST0Ah12k+KT2+M3cLnHeB0tMTfdbgV7b
         JtabG3V39TFUNJhjJ4SVoYb0JYnZSHvx5GT0hQBR/6wrHKHb1jLzsLkZg1GlD5iF7tGe
         Q7o9fiOmVG3veHM9Ervg4WKVp9CJh2xLketx3FIVThL4NwryTKvagw7QHuPknChJOXO2
         OGuQ==
X-Gm-Message-State: AJIora83LnXzQ8kcqVA8u3bbvg72FC7Uz8XpvNeFGdysiPFuQktU2l6w
        pamn4TOv52GzBJtFtalM2Q2dSSbTh5U8WX6iuXAC0dmdE8E=
X-Google-Smtp-Source: AGRyM1ufrdEzNruYTJm8XjiHaE2uY9isBZVWxWv7hRdWQvoPF8qIfie7RW9RGW3UFiyqhp660U9hwjltFQmiPgoKWqI=
X-Received: by 2002:a05:6102:1052:b0:34b:8a41:b963 with SMTP id
 h18-20020a056102105200b0034b8a41b963mr8214622vsq.17.1655663894600; Sun, 19
 Jun 2022 11:38:14 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 19 Jun 2022 13:38:03 -0500
Message-ID: <CAH2r5mvXJ6cjpeHPJY+V4iHVUUFckYvFQ-CjHf-fAb9ZLjRrfw@mail.gmail.com>
Subject: [PATCH][SMB3 cient] fix error connecting to channels (negprot failure)
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000004e319205e1d14a44"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004e319205e1d14a44
Content-Type: text/plain; charset="UTF-8"

smb3: fix empty netname context on secondary channels

Some servers do not allow null netname contexts, which would cause
multichannel to revert to single channel when mounting to some
servers (e.g. Azure xSMB).

Fixes: 4c14d7043fede ("cifs: populate empty hostnames for extra channels")

See attached patch

-- 
Thanks,

Steve

--0000000000004e319205e1d14a44
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-empty-netname-context-on-secondary-channels.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-empty-netname-context-on-secondary-channels.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l4lnh4iz0>
X-Attachment-Id: f_l4lnh4iz0

RnJvbSA4Mjk4ZjM4Y2UwYjk1ZjlhM2I1ZjdkODNkYmViN2EzMmM3NTU0MGNiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTggSnVuIDIwMjIgMTc6MjQ6MjMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggZW1wdHkgbmV0bmFtZSBjb250ZXh0IG9uIHNlY29uZGFyeSBjaGFubmVscwoKU29t
ZSBzZXJ2ZXJzIGRvIG5vdCBhbGxvdyBudWxsIG5ldG5hbWUgY29udGV4dHMsIHdoaWNoIHdvdWxk
IGNhdXNlCm11bHRpY2hhbm5lbCB0byByZXZlcnQgdG8gc2luZ2xlIGNoYW5uZWwgd2hlbiBtb3Vu
dGluZyB0byBzb21lCnNlcnZlcnMgKGUuZy4gQXp1cmUgeFNNQikuCgpGaXhlczogNGMxNGQ3MDQz
ZmVkZSAoImNpZnM6IHBvcHVsYXRlIGVtcHR5IGhvc3RuYW1lcyBmb3IgZXh0cmEgY2hhbm5lbHMi
KQpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0t
LQogZnMvY2lmcy9zbWIycGR1LmMgfCAxNCArKysrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQs
IDggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3Nt
YjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IGI1MTUxNDBiYWQ4ZC4uNWU4YzQ3Mzdi
MTgzIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUu
YwpAQCAtNTcwLDE2ICs1NzAsMTggQEAgYXNzZW1ibGVfbmVnX2NvbnRleHRzKHN0cnVjdCBzbWIy
X25lZ290aWF0ZV9yZXEgKnJlcSwKIAkqdG90YWxfbGVuICs9IGN0eHRfbGVuOwogCXBuZWdfY3R4
dCArPSBjdHh0X2xlbjsKIAotCWN0eHRfbGVuID0gYnVpbGRfbmV0bmFtZV9jdHh0KChzdHJ1Y3Qg
c21iMl9uZXRuYW1lX25lZ19jb250ZXh0ICopcG5lZ19jdHh0LAotCQkJCQlzZXJ2ZXItPmhvc3Ru
YW1lKTsKLQkqdG90YWxfbGVuICs9IGN0eHRfbGVuOwotCXBuZWdfY3R4dCArPSBjdHh0X2xlbjsK
LQogCWJ1aWxkX3Bvc2l4X2N0eHQoKHN0cnVjdCBzbWIyX3Bvc2l4X25lZ19jb250ZXh0ICopcG5l
Z19jdHh0KTsKIAkqdG90YWxfbGVuICs9IHNpemVvZihzdHJ1Y3Qgc21iMl9wb3NpeF9uZWdfY29u
dGV4dCk7CiAJcG5lZ19jdHh0ICs9IHNpemVvZihzdHJ1Y3Qgc21iMl9wb3NpeF9uZWdfY29udGV4
dCk7CiAKLQluZWdfY29udGV4dF9jb3VudCA9IDQ7CisJaWYgKHNlcnZlci0+aG9zdG5hbWUgJiYg
KHNlcnZlci0+aG9zdG5hbWVbMF0gIT0gMCkpIHsKKwkJY3R4dF9sZW4gPSBidWlsZF9uZXRuYW1l
X2N0eHQoKHN0cnVjdCBzbWIyX25ldG5hbWVfbmVnX2NvbnRleHQgKilwbmVnX2N0eHQsCisJCQkJ
CXNlcnZlci0+aG9zdG5hbWUpOworCQkqdG90YWxfbGVuICs9IGN0eHRfbGVuOworCQlwbmVnX2N0
eHQgKz0gY3R4dF9sZW47CisJCW5lZ19jb250ZXh0X2NvdW50ID0gNDsKKwl9IGVsc2UgLyogc2Vj
b25kIGNoYW5uZWxzIGRvIG5vdCBoYXZlIGEgaG9zdG5hbWUgKi8KKwkJbmVnX2NvbnRleHRfY291
bnQgPSAzOwogCiAJaWYgKHNlcnZlci0+Y29tcHJlc3NfYWxnb3JpdGhtKSB7CiAJCWJ1aWxkX2Nv
bXByZXNzaW9uX2N0eHQoKHN0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFiaWxpdGllc19jb250
ZXh0ICopCi0tIAoyLjM0LjEKCg==
--0000000000004e319205e1d14a44--
