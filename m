Return-Path: <SRS0=DFiv=3Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BFD5C35247
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Feb 2020 23:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 613E2217BA
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Feb 2020 23:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BLZVZZkJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBEXEe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Feb 2020 18:04:34 -0500
Received: from mail-il1-f178.google.com ([209.85.166.178]:39229 "EHLO
        mail-il1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgBEXEe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Feb 2020 18:04:34 -0500
Received: by mail-il1-f178.google.com with SMTP id f70so3390830ill.6
        for <linux-cifs@vger.kernel.org>; Wed, 05 Feb 2020 15:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=w1PUhh1S3rBKKi5/fO6aSNAouKANmIQH2C94TgiDlvc=;
        b=BLZVZZkJ46msYtDj2uKmQMB90gcqhhUDlKK36dGCEukI90qJ7P1/ztdJhy6o2iWz3h
         38QSa6ZNvPoEc0b04Zge31xIqW6lg/pftUOr8mInhG4BtJM4LxxU6KTUoNG/W5kHnCtl
         abQvz2dXkGCE9W0f9kPZyszS95A0ltvUigG/cDeSUhz4ax0HheaQbUyIUBQNYcLQn9Lh
         pDo9KOsYqTwaG3/6oQNFueQgPW8MG/y8ISMMjqn2rehvkUKosch5pdMv8sffL2DQnXxU
         JbmgMAuW/Z8BAb7nJkB/N82dwQN1aRF6y75czMLTUDQBCvAkbGLItjS1+FbF8nfNY/63
         Ho8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=w1PUhh1S3rBKKi5/fO6aSNAouKANmIQH2C94TgiDlvc=;
        b=U9xaYLzfOdxelZLV9ag1njqeiAIi0QxIOeLgtyZUYcNKJc4Ws15bI4YRFx4yErEB4a
         S+ifrbsm9jU8rA2bxHjTEIkbKPrDoZvgq4uD7n3LQmTcPy2+veKl9SIcZ0KzX5sWyk24
         IsSvrz+nMUTwaV+gQOYIuXIX44AUlVmU3oB8AwrhfvIOapqMJKts8dMfTJjcJaW40BlU
         Fs5qVyOOWmKl5DSO33UsPT1LK+mZDbHts1oEFp1qULLODE50CIjlhQVMaP/XdVcnxQ14
         OOGj8fPB3C1ikCm05bIHel9RRwb/41zvHH9MTrItgJVFHApnN90R8ZpifV8andm4OyfG
         Utsw==
X-Gm-Message-State: APjAAAXVoHVmM2dxaS2gHhN5QWn8yNTkBAZW3VMIkGTdsOAhjmbLESHD
        jjLJ9Zw8Bkj8w7JAMzNDya0UkC/00rT8n4DrzGaD1/5d
X-Google-Smtp-Source: APXvYqwx6HXjclPAGFRy4SW2ZeIcRBnNZT+hIY9+kz7I+AIT2dFAchIqUEhyH2Peqpr/f23YYwxho4JXFRI3yOReEkQ=
X-Received: by 2002:a92:9f1b:: with SMTP id u27mr596800ili.173.1580943873757;
 Wed, 05 Feb 2020 15:04:33 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Feb 2020 17:04:22 -0600
Message-ID: <CAH2r5mtPHXf4jy+TFxtRmHGfBBe6nza9=5aCWkm2h3wDLp850w@mail.gmail.com>
Subject: [CIFS][PATCH] log warning once if out of disk space error on write
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000001d097059ddc2e58"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000001d097059ddc2e58
Content-Type: text/plain; charset="UTF-8"

Had a confusing problem reported - turned out to be out of disk space
due to a write with large offset on a non-sparse file.  Having a
warning message logged once would have helped.



-- 
Thanks,

Steve

--00000000000001d097059ddc2e58
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-log-warning-message-once-if-out-of-disk-space.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-log-warning-message-once-if-out-of-disk-space.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k69x5lel0>
X-Attachment-Id: f_k69x5lel0

RnJvbSA3MzI2MjE3ZTcwMGUyOTNiZWNhMWY4YjM5Y2RmMTFiYTFkMjQ4NDM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgNSBGZWIgMjAyMCAxNjo1MjoxMSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IGxvZyB3YXJuaW5nIG1lc3NhZ2UgKG9uY2UpIGlmIG91dCBvZiBkaXNrIHNwYWNlCgpXZSBy
YW4gaW50byBhIGNvbmZ1c2luZyBwcm9ibGVtIHdoZXJlIGFuIGFwcGxpY2F0aW9uIHdhc24ndCBj
aGVja2luZwpyZXR1cm4gY29kZSBvbiBjbG9zZSBhbmQgc28gdXNlciBkaWRuJ3QgcmVhbGl6ZSB0
aGF0IHRoZSBhcHBsaWNhdGlvbgpyYW4gb3V0IG9mIGRpc2sgc3BhY2UuICBsb2cgYSB3YXJuaW5n
IG1lc3NhZ2UgKG9uY2UpIGluIHRoZXNlCmNhc2VzLiBGb3IgZXhhbXBsZToKCiAgeFsgODQwNy4z
OTE5MDldIE91dCBvZiBzcGFjZSB3cml0aW5nIHRvIFxcb2xlZy1zZXJ2ZXJcc21hbGwtc2hhcmUK
ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KUmVw
b3J0ZWQtYnk6IE9sZWcgS3JhdnRzb3YgPG9sZWdAdHV4ZXJhLmNvbT4KUmV2aWV3ZWQtYnk6IFJv
bm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJwZHUu
YyB8IDMgKysrCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCA3OTk2ZDgxMjMwYWEu
LjFhNzMyZmY3MWRlNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lm
cy9zbWIycGR1LmMKQEAgLTQwMjksNiArNDAyOSw5IEBAIHNtYjJfd3JpdGV2X2NhbGxiYWNrKHN0
cnVjdCBtaWRfcV9lbnRyeSAqbWlkKQogCQkJCSAgICAgd2RhdGEtPmNmaWxlLT5maWQucGVyc2lz
dGVudF9maWQsCiAJCQkJICAgICB0Y29uLT50aWQsIHRjb24tPnNlcy0+U3VpZCwgd2RhdGEtPm9m
ZnNldCwKIAkJCQkgICAgIHdkYXRhLT5ieXRlcywgd2RhdGEtPnJlc3VsdCk7CisJCWlmICh3ZGF0
YS0+cmVzdWx0ID09IC1FTk9TUEMpCisJCQlwcmludGtfb25jZShLRVJOX1dBUk5JTkcgIk91dCBv
ZiBzcGFjZSB3cml0aW5nIHRvICVzXG4iLAorCQkJCSAgICB0Y29uLT50cmVlTmFtZSk7CiAJfSBl
bHNlCiAJCXRyYWNlX3NtYjNfd3JpdGVfZG9uZSgwIC8qIG5vIHhpZCAqLywKIAkJCQkgICAgICB3
ZGF0YS0+Y2ZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZCwKLS0gCjIuMjAuMQoK
--00000000000001d097059ddc2e58--
