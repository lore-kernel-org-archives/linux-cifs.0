Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF416C19F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 20:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiHKUln (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 16:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiHKUlm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 16:41:42 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D5F1163
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 13:41:40 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o3-20020a17090a0a0300b001f7649cd317so6523145pjo.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 13:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=R+5hOHvX85DFFjQrpCIbOIxoDdqY9myTD23SUeazbOo=;
        b=JAkdj6z+K2C5Sg6YWN9FtrPiegIQmiU0qie5jki0B8HapeIEvimV2qj5/rEUjOviT4
         Gmf74gbKtCELHxr8vmkBf2srX+A1OszVSIpQZc8ZxB1uSkFXFtwMz68/tw+Wqoxt+fq4
         JSLKa+GGUDL1jX+Cjfe8SE0ksLij6I3y7HFgzC8kK01w1ycS4BNbd9A1qEvKo8lHCz0V
         UWh/HOLhBVO9LOyYtIc31+Ybprz9RaSs/xRYYldZYtugEdtlCW93A5J6JAJwwkvlQFn4
         SqbqFiTLCT9w4qnCr0BPgkuVdq1T8IXj2NngZotiiyct4goBpwQbFCxVX1sEyAvt+r9S
         wE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=R+5hOHvX85DFFjQrpCIbOIxoDdqY9myTD23SUeazbOo=;
        b=MvOLrv53amgdUTe28VzNv/r7+AMr5xxe/y18TgBoCEzEuGWYEBDcBbBskCU6C7v1/S
         oKYVIsc16cAhiakEMYZ01qDG3YZ9dhBIC2SRsfmhMq24XT0o+tAOLU0G1hE2Bzww/vec
         n5KVSbQCpEtcGYmrnMhF26sY1QBsCRjQiNEMUESilXYwBj8qHI0ycC8LT+1lGJ5eFhOn
         QdZS5lS/51k3lpy7CyYSWDPdFFdXIfFvh5fRXHHvflm+Pk1aEABj8NQ0nInKqEP7bh0U
         znKT2oxf0XI6sA/rK9AcmReCECzQiBSx135VZn3SjQGQnOVvSh5tpkzqbdtv6sXHel/l
         BS5w==
X-Gm-Message-State: ACgBeo38SYLYPrEC4iAakltyYAufD/1qu3LTB6rrhk68eQHAAfp1yRU3
        sCtP6+C0hNtQuUk1JgYh5xzVsj5B5Ac3lQauTiZPr9fLXkY=
X-Google-Smtp-Source: AA6agR4RTSadR8Pah3jdwcDGiiv0lILl7EIIZSeKQMJQ0saVVHJ+Fv/ixoY+/qlkLi03SkmyK4wc4/XqRBg0f/HxIPk=
X-Received: by 2002:a17:90b:38c9:b0:1f7:28bb:aa16 with SMTP id
 nn9-20020a17090b38c900b001f728bbaa16mr699809pjb.201.1660250499491; Thu, 11
 Aug 2022 13:41:39 -0700 (PDT)
MIME-Version: 1.0
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Fri, 12 Aug 2022 02:11:27 +0530
Message-ID: <CAGypqWz9K1v68vtp1QwcsAtBgprwKkbFAmm8uc6k=HawoJ2Tqg@mail.gmail.com>
Subject: [PATCH] SMB3: fix lease break timeout when multiple deferred close
 handles for the same file.
To:     linux-cifs@vger.kernel.org,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000042c44f05e5fd3102"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000042c44f05e5fd3102
Content-Type: text/plain; charset="UTF-8"

Fix lease break timeout when multiple deferred close handles for the same file.

Solution is to send lease break ack immediately even in case of
deferred close handles to avoid lease break request timing out
and let deferred closed handle gets closed as scheduled.
Later patches could optimize cases where we then close some
of these handles sooner for the cases where lease break is to 'none'

--00000000000042c44f05e5fd3102
Content-Type: application/octet-stream; 
	name="0001-SMB3-fix-lease-break-timeout-when-multiple-deferred-.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-fix-lease-break-timeout-when-multiple-deferred-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l6pgklij0>
X-Attachment-Id: f_l6pgklij0

RnJvbSA5YzBjZDI3NTBjNjdkN2Y2MGJlNTZjMzJkMjE1YzkwYzc4MGM3ZDYxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogVGh1LCAxMSBBdWcgMjAyMiAxOTo0NjoxMSArMDAwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjM6IGZpeCBsZWFzZSBicmVhayB0aW1lb3V0IHdoZW4gbXVsdGlwbGUgZGVmZXJyZWQgY2xvc2UK
IGhhbmRsZXMgZm9yIHRoZSBzYW1lIGZpbGUuCgpTb2x1dGlvbiBpcyB0byBzZW5kIGxlYXNlIGJy
ZWFrIGFjayBpbW1lZGlhdGVseSBldmVuIGluIGNhc2Ugb2YKZGVmZXJyZWQgY2xvc2UgaGFuZGxl
cyB0byBhdm9pZCBsZWFzZSBicmVhayByZXF1ZXN0IHRpbWluZyBvdXQKYW5kIGxldCBkZWZlcnJl
ZCBjbG9zZWQgaGFuZGxlIGdldHMgY2xvc2VkIGFzIHNjaGVkdWxlZC4KTGF0ZXIgcGF0Y2hlcyBj
b3VsZCBvcHRpbWl6ZSBjYXNlcyB3aGVyZSB3ZSB0aGVuIGNsb3NlIHNvbWUKb2YgdGhlc2UgaGFu
ZGxlcyBzb29uZXIgZm9yIHRoZSBjYXNlcyB3aGVyZSBsZWFzZSBicmVhayBpcyB0byAnbm9uZScK
ClNpZ25lZC1vZmYtYnk6IEJoYXJhdGggU00gPGJoYXJhdGhzbUBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL2NpZnMvZmlsZS5jIHwgMjAgKy0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMTkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9m
aWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCBlNjRjZGE3YTc2MTAuLjhkOTdhYmJkZTkwYSAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxlLmMKQEAgLTQ4MTEs
OCArNDgxMSw2IEBAIHZvaWQgY2lmc19vcGxvY2tfYnJlYWsoc3RydWN0IHdvcmtfc3RydWN0ICp3
b3JrKQogCXN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciA9IHRjb24tPnNlcy0+c2VydmVy
OwogCWludCByYyA9IDA7CiAJYm9vbCBwdXJnZV9jYWNoZSA9IGZhbHNlOwotCWJvb2wgaXNfZGVm
ZXJyZWQgPSBmYWxzZTsKLQlzdHJ1Y3QgY2lmc19kZWZlcnJlZF9jbG9zZSAqZGNsb3NlOwogCiAJ
d2FpdF9vbl9iaXQoJmNpbm9kZS0+ZmxhZ3MsIENJRlNfSU5PREVfUEVORElOR19XUklURVJTLAog
CQkJVEFTS19VTklOVEVSUlVQVElCTEUpOwpAQCAtNDg0OCwyMiArNDg0Niw2IEBAIHZvaWQgY2lm
c19vcGxvY2tfYnJlYWsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCQljaWZzX2RiZyhWRlMs
ICJQdXNoIGxvY2tzIHJjID0gJWRcbiIsIHJjKTsKIAogb3Bsb2NrX2JyZWFrX2FjazoKLQkvKgot
CSAqIFdoZW4gb3Bsb2NrIGJyZWFrIGlzIHJlY2VpdmVkIGFuZCB0aGVyZSBhcmUgbm8gYWN0aXZl
Ci0JICogZmlsZSBoYW5kbGVzIGJ1dCBjYWNoZWQsIHRoZW4gc2NoZWR1bGUgZGVmZXJyZWQgY2xv
c2UgaW1tZWRpYXRlbHkuCi0JICogU28sIG5ldyBvcGVuIHdpbGwgbm90IHVzZSBjYWNoZWQgaGFu
ZGxlLgotCSAqLwotCXNwaW5fbG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJyZWRfbG9jayk7Ci0J
aXNfZGVmZXJyZWQgPSBjaWZzX2lzX2RlZmVycmVkX2Nsb3NlKGNmaWxlLCAmZGNsb3NlKTsKLQlz
cGluX3VubG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJyZWRfbG9jayk7Ci0JaWYgKGlzX2RlZmVy
cmVkICYmCi0JICAgIGNmaWxlLT5kZWZlcnJlZF9jbG9zZV9zY2hlZHVsZWQgJiYKLQkgICAgZGVs
YXllZF93b3JrX3BlbmRpbmcoJmNmaWxlLT5kZWZlcnJlZCkpIHsKLQkJaWYgKGNhbmNlbF9kZWxh
eWVkX3dvcmsoJmNmaWxlLT5kZWZlcnJlZCkpIHsKLQkJCV9jaWZzRmlsZUluZm9fcHV0KGNmaWxl
LCBmYWxzZSwgZmFsc2UpOwotCQkJZ290byBvcGxvY2tfYnJlYWtfZG9uZTsKLQkJfQotCX0KIAkv
KgogCSAqIHJlbGVhc2luZyBzdGFsZSBvcGxvY2sgYWZ0ZXIgcmVjZW50IHJlY29ubmVjdCBvZiBz
bWIgc2Vzc2lvbiB1c2luZwogCSAqIGEgbm93IGluY29ycmVjdCBmaWxlIGhhbmRsZSBpcyBub3Qg
YSBkYXRhIGludGVncml0eSBpc3N1ZSBidXQgZG8KQEAgLTQ4NzUsNyArNDg1Nyw3IEBAIHZvaWQg
Y2lmc19vcGxvY2tfYnJlYWsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCQkJCQkJCSAgICAg
Y2lub2RlKTsKIAkJY2lmc19kYmcoRllJLCAiT3Bsb2NrIHJlbGVhc2UgcmMgPSAlZFxuIiwgcmMp
OwogCX0KLW9wbG9ja19icmVha19kb25lOgorCiAJX2NpZnNGaWxlSW5mb19wdXQoY2ZpbGUsIGZh
bHNlIC8qIGRvIG5vdCB3YWl0IGZvciBvdXJzZWxmICovLCBmYWxzZSk7CiAJY2lmc19kb25lX29w
bG9ja19icmVhayhjaW5vZGUpOwogfQotLSAKMi4zNC4xCgo=
--00000000000042c44f05e5fd3102--
