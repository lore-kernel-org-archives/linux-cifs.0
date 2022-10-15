Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D792C433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 15 Oct 2022 22:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJOWKV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 15 Oct 2022 18:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiJOWKT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 15 Oct 2022 18:10:19 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC43C2FFF8
        for <linux-cifs@vger.kernel.org>; Sat, 15 Oct 2022 15:10:18 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id l127so8221037vsc.3
        for <linux-cifs@vger.kernel.org>; Sat, 15 Oct 2022 15:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bGmBbsXjtURQLYMP6NXJpo8lOAMeqAmkjouux3YDUHg=;
        b=nLu4D+hmUBZNGclQc5/lcXtLW2Aqs3uXCi4laL9SaKOQMUCgfPKYG7VlpkCnC0fhW1
         H4HR4Odmpm7Ic3HOw+RbWwG8JftPYp+zEw/KiIhPPV6XdEXgtjHfIcdBnh5gV5owFb/B
         P9h8odXDiTiSGguJFboHVv4KLbaFKHfj9VFli17ycPAzvWU9JJ9B8iQcs67Y6DSzghwL
         Q2Su/VUX1QweuVFvXNW4mGXDxkUwvcZJve9XGnAOYU//vck7Y0WeF0/mjuSibNuechsB
         9tOPeDEHjWJqPcBddCKmcqYRHjyYH0G4MAaJoCSHQODjB0T/Pj/qNJjJ462Unrcm/9ot
         lL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bGmBbsXjtURQLYMP6NXJpo8lOAMeqAmkjouux3YDUHg=;
        b=df9kEtgekqw1pMQbaCzBFA3LrPjPmIpAWu/chhFkG+FzaPotpIN5SLzBlw3tR9iuo/
         2vHlj5FdV08jnAnVuymi3E/d75uIdHTUtdDYswabJMw7pZubD+v6HsfyheTMGIm99kr5
         +a+5u464rowEHGOegRrWZqOVZxwgBiomIWRVsAQ+HI8PS2VjvmB0ywLp82yen8KzHvs/
         2Eb+AsbP2g2YJ5GrB5hHYoQRcq6acB8ivWhs/nmNfAzhUABcwLuwSEI/bOVTWKV77V+/
         hPZV7k88pKyFEPUBba6fPHLMucqcZUdS3Zk0aCAkG0oEB2IPlCFHQDVzMpBDoxbgLe9c
         IyiA==
X-Gm-Message-State: ACrzQf3UE/uA573HPA77Kz9QdijoTMb9DhKnyaKX90n7bvfnsXVWsvLp
        IZFH5l93tOK/THflO0xPi4uIxh9VF65h5sGqKLDvbxvGjug=
X-Google-Smtp-Source: AMsMyM7UILnbCddI/kB3+hVxNG5phsy2dEZEW+b2HStBwglig4ZLke6py/J9eRZBJga7fR1nTf4er6jz4lOugyMrBdY=
X-Received: by 2002:a05:6102:5cf:b0:3a7:95ac:fc04 with SMTP id
 v15-20020a05610205cf00b003a795acfc04mr1762360vsf.17.1665871817568; Sat, 15
 Oct 2022 15:10:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 15 Oct 2022 17:10:06 -0500
Message-ID: <CAH2r5mvf3zjMb3=ceL9wknZhMwp6CrOQEyzZ7HaXDNidYpLCBQ@mail.gmail.com>
Subject: [PATCH][SMB3 client] Server interface count incorrectly calculated
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000ed884805eb1a01e1"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ed884805eb1a01e1
Content-Type: text/plain; charset="UTF-8"

smb3: interface count displayed incorrectly

The "Server interfaces" count in /proc/fs/cifs/DebugData increases
as the interfaces are requeried, rather than being reset to the new
value.  This could cause a problem if the server disabled
multichannel as the iface_count is checked in try_adding_channels
to see if multichannel still supported.

Cc: <stable@vger.kernel.org>

See attached

-- 
Thanks,

Steve

--000000000000ed884805eb1a01e1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-interface-count-displayed-incorrectly.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-interface-count-displayed-incorrectly.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l9ah23xv0>
X-Attachment-Id: f_l9ah23xv0

RnJvbSAxZDJhZWYwOTk1ODNlMzk2MTA1ODBkMjBmYjg2ZjZmOTliNjRjNzgyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTUgT2N0IDIwMjIgMTc6MDI6MzAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBpbnRlcmZhY2UgY291bnQgZGlzcGxheWVkIGluY29ycmVjdGx5CgpUaGUgIlNlcnZlciBp
bnRlcmZhY2VzIiBjb3VudCBpbiAvcHJvYy9mcy9jaWZzL0RlYnVnRGF0YSBpbmNyZWFzZXMKYXMg
dGhlIGludGVyZmFjZXMgYXJlIHJlcXVlcmllZCwgcmF0aGVyIHRoYW4gYmVpbmcgcmVzZXQgdG8g
dGhlIG5ldwp2YWx1ZS4gIFRoaXMgY291bGQgY2F1c2UgYSBwcm9ibGVtIGlmIHRoZSBzZXJ2ZXIg
ZGlzYWJsZWQKbXVsdGljaGFubmVsIGFzIHRoZSBpZmFjZV9jb3VudCBpcyBjaGVja2VkIGluIHRy
eV9hZGRpbmdfY2hhbm5lbHMKdG8gc2VlIGlmIG11bHRpY2hhbm5lbCBzdGlsbCBzdXBwb3J0ZWQu
CgpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5j
aCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJvcHMuYyB8IDEgKwog
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIy
b3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCAxN2IyNTE1M2NiNjguLjdlZTFkZDYzNWZh
ZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMK
QEAgLTUzMCw2ICs1MzAsNyBAQCBwYXJzZV9zZXJ2ZXJfaW50ZXJmYWNlcyhzdHJ1Y3QgbmV0d29y
a19pbnRlcmZhY2VfaW5mb19pb2N0bF9yc3AgKmJ1ZiwKIAlwID0gYnVmOwogCiAJc3Bpbl9sb2Nr
KCZzZXMtPmlmYWNlX2xvY2spOworCXNlcy0+aWZhY2VfY291bnQgPSAwOwogCS8qCiAJICogR28g
dGhyb3VnaCBpZmFjZV9saXN0IGFuZCBkbyBrcmVmX3B1dCB0byByZW1vdmUKIAkgKiBhbnkgdW51
c2VkIGlmYWNlcy4gaWZhY2VzIGluIHVzZSB3aWxsIGJlIHJlbW92ZWQKLS0gCjIuMzQuMQoK
--000000000000ed884805eb1a01e1--
