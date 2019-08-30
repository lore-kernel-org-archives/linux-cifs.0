Return-Path: <SRS0=0p8I=W2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39086C3A59F
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Aug 2019 03:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A6122186A
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Aug 2019 03:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m9odDYGs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfH3Djg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Aug 2019 23:39:36 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:38171 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbfH3Djf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Aug 2019 23:39:35 -0400
Received: by mail-io1-f43.google.com with SMTP id p12so11315370iog.5
        for <linux-cifs@vger.kernel.org>; Thu, 29 Aug 2019 20:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=iPiVVygyTzshFzwm87GgNCZ7/PmuMy0RzTW47icynMg=;
        b=m9odDYGsF7+ftXabJz81XkN5Ysbx7BNwUWvTe1Qydef1uXVAtqLj6ENnM4M13K5QtF
         E3NF0xdUulyvpGP4VPBBNp7kNbby9yeVlis9bWFfBYqiOeTBZe1jqrHqmwW4afCvzrVm
         XXanYoTpDNMBGL43/Nh2myvP6z25HY0gsdHiTUm1Fg6tu/fsdzuP6TBq4BSmFnkuIpuE
         PHRtqZ/0wC3I2kVjSfUsQuUQ7w1Oo4dcOwGT7BCZQUSVa9OxvNklhv3J3Nbq0bCP+JBx
         iknK8+AYbL4zXFuLzMA70tiTnCgCOtOvBcxKH9BmLbQzT+c1GmwWQFRTWCDIhtD0KkNO
         lMjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iPiVVygyTzshFzwm87GgNCZ7/PmuMy0RzTW47icynMg=;
        b=deHwARxN0jdPhA3g9jfGe10dHMQtBtSIoWy9aZNV1E6+fT4pM6JCyJssne4UjzPmqh
         7fLi3ogj+8Li6/zMbYNQE8zTCUhG01SMQHNSAMvcdi19MTGmEyeK9bemK5OwRS4KK6r9
         xJ20zwR+MVwsc0qqwzCLSj7xkV1azXKqomY33ZjIySyDcHufHYJbgnv4E9UiWI7m84xY
         sdsLRAfMyMKUvjqU0/hCj1G04EQGeMkfxTpbv0GdiazAEXlGX9ac9HyjTW3qOIvwIcHR
         vwIFPru8NECNzl7puli/STO60EAInumrMWCvsQKTNfHzhH1dKSya5G1lLG6TWm6dEgsD
         d1JQ==
X-Gm-Message-State: APjAAAX/Ff0IzbUDp/sOnOZHlJrYkqZMEX0T1sy8DLRaUbYkDwDbUiLI
        qidv7J7f8olIQgxYBWtfYtS6SEKIYI2EmzEMD846SlNkZjc=
X-Google-Smtp-Source: APXvYqwDVc4342YdVnU/Cw2UDk2KyV2bEzE9CSSxVRKoQHUeR98/xnS7mciT3xLReHpHxRNH0Fp0ysCZ+6kA+jNtHiw=
X-Received: by 2002:a6b:6a07:: with SMTP id x7mr1838234iog.168.1567136373844;
 Thu, 29 Aug 2019 20:39:33 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Aug 2019 22:39:22 -0500
Message-ID: <CAH2r5msb7OMdV4FnVYxFZXT2ppm=rv3V9b_1ivfB+jZN-wM75A@mail.gmail.com>
Subject: [SMB3][PATCH] Add more detailed log information on cache=ro mounts
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e0d45605914d5ece"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e0d45605914d5ece
Content-Type: text/plain; charset="UTF-8"

Make it easier to tell if the share we are mounting with cache=ro is
considered read only by the server.  Obviously there are cases where
the user could know that no one will be writing to the share but this
additional information could be helpful.

$ dmesg
[374786.661113] CIFS: Attempting to mount //localhost/test
[374786.661130] CIFS VFS: mounting share with read only caching.
Ensure that the share will not be modified while in use.
[374786.662199] CIFS VFS: read only mount of RW share

[374793.473091] CIFS: Attempting to mount //localhost/test-ro
[374793.473109] CIFS VFS: mounting share with read only caching.
Ensure that the share will not be modified while in use.
[374793.474266] CIFS VFS: mounted to read only share


-- 
Thanks,

Steve

--000000000000e0d45605914d5ece
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-some-more-descriptive-messages-about-share-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-some-more-descriptive-messages-about-share-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jzxkixfw0>
X-Attachment-Id: f_jzxkixfw0

RnJvbSBkZDJhYmY4YmJlYjMxNzU1NWEwYWE3MTMyZjY2M2RmZTMwYWUyOTExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjkgQXVnIDIwMTkgMjI6MzM6MzggLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgc29tZSBtb3JlIGRlc2NyaXB0aXZlIG1lc3NhZ2VzIGFib3V0IHNoYXJlIHdoZW4K
IG1vdW50aW5nIGNhY2hlPXJvCgpBZGQgc29tZSBhZGRpdGlvbmFsIGxvZ2dpbmcgc28gdGhlIHVz
ZXIgY2FuIHNlZSBpZiB0aGUgc2hhcmUgdGhleQptb3VudGVkIHdpdGggY2FjaGU9cm8gaXMgY29u
c2lkZXJlZCByZWFkIG9ubHkgYnkgdGhlIHNlcnZlcgoKQ0lGUzogQXR0ZW1wdGluZyB0byBtb3Vu
dCAvL2xvY2FsaG9zdC90ZXN0CkNJRlMgVkZTOiBtb3VudGluZyBzaGFyZSB3aXRoIHJlYWQgb25s
eSBjYWNoaW5nLiBFbnN1cmUgdGhhdCB0aGUgc2hhcmUgd2lsbCBub3QgYmUgbW9kaWZpZWQgd2hp
bGUgaW4gdXNlLgpDSUZTIFZGUzogcmVhZCBvbmx5IG1vdW50IG9mIFJXIHNoYXJlCgpDSUZTOiBB
dHRlbXB0aW5nIHRvIG1vdW50IC8vbG9jYWxob3N0L3Rlc3Qtcm8KQ0lGUyBWRlM6IG1vdW50aW5n
IHNoYXJlIHdpdGggcmVhZCBvbmx5IGNhY2hpbmcuIEVuc3VyZSB0aGF0IHRoZSBzaGFyZSB3aWxs
IG5vdCBiZSBtb2RpZmllZCB3aGlsZSBpbiB1c2UuCkNJRlMgVkZTOiBtb3VudGVkIHRvIHJlYWQg
b25seSBzaGFyZQoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3Nv
ZnQuY29tPgotLS0KIGZzL2NpZnMvY29ubmVjdC5jIHwgMTAgKysrKysrKysrLQogMSBmaWxlIGNo
YW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggNGU2MjI5NTNkZDVhLi4wNzJj
MDFmNGU5YzEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29u
bmVjdC5jCkBAIC00MTk3LDggKzQxOTcsMTYgQEAgc3RhdGljIGludCBtb3VudF9nZXRfY29ubnMo
c3RydWN0IHNtYl92b2wgKnZvbCwgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKIAkJdGNv
bi0+dW5peF9leHQgPSAwOyAvKiBzZXJ2ZXIgZG9lcyBub3Qgc3VwcG9ydCB0aGVtICovCiAKIAkv
KiBkbyBub3QgY2FyZSBpZiBhIGZvbGxvd2luZyBjYWxsIHN1Y2NlZWQgLSBpbmZvcm1hdGlvbmFs
ICovCi0JaWYgKCF0Y29uLT5waXBlICYmIHNlcnZlci0+b3BzLT5xZnNfdGNvbikKKwlpZiAoIXRj
b24tPnBpcGUgJiYgc2VydmVyLT5vcHMtPnFmc190Y29uKSB7CiAJCXNlcnZlci0+b3BzLT5xZnNf
dGNvbigqeGlkLCB0Y29uKTsKKwkJaWYgKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19N
T1VOVF9ST19DQUNIRSkgeworCQkJaWYgKHRjb24tPmZzRGV2SW5mby5EZXZpY2VDaGFyYWN0ZXJp
c3RpY3MgJgorCQkJICAgIEZJTEVfUkVBRF9PTkxZX0RFVklDRSkKKwkJCQljaWZzX2RiZyhWRlMs
ICJtb3VudGVkIHRvIHJlYWQgb25seSBzaGFyZVxuIik7CisJCQllbHNlCisJCQkJY2lmc19kYmco
VkZTLCAicmVhZCBvbmx5IG1vdW50IG9mIFJXIHNoYXJlXG4iKTsKKwkJfQorCX0KIAogCWNpZnNf
c2ItPndzaXplID0gc2VydmVyLT5vcHMtPm5lZ290aWF0ZV93c2l6ZSh0Y29uLCB2b2wpOwogCWNp
ZnNfc2ItPnJzaXplID0gc2VydmVyLT5vcHMtPm5lZ290aWF0ZV9yc2l6ZSh0Y29uLCB2b2wpOwot
LSAKMi4yMC4xCgo=
--000000000000e0d45605914d5ece--
