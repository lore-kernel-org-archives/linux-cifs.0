Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9729C7EE22
	for <linux-cifs@archiver.kernel.org>; Tue,  9 May 2023 06:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbjEIG2y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 May 2023 02:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234648AbjEIG2x (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 May 2023 02:28:53 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C87265A4
        for <linux-cifs@vger.kernel.org>; Mon,  8 May 2023 23:28:52 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f24ddf514eso2396299e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 May 2023 23:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683613730; x=1686205730;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PR8MLH39bpVXuYi/n+DI0wKNumvoHpECw2yLEsV+23E=;
        b=r0jjvirKiQxy7rvMqGCOiO6kkkTwBXaeJ6NrbzsaF9HUwqSQoMOqjOSxNsVSyevx6O
         /CTnZ+UBD2nHHT8yhLOQGT79pPTsB0ZRn5NKnI4JIxQ6rVkzGYvIK5gNbQxjO11G+MN8
         x5xh6AV+7UowQzA0ir2ny+8ojSu+yQRRhpS1u2dA9vMUEycISXSm7As3CDwcQoF0Gx8Q
         3wuQ+oRQcm6446n/39H/S5EipDkfzhoijyGTr1d3RAJ9sGwr8Y6OTlhf9qbD0DeEQyhR
         tfHuzT4izqdjxr9thXuJQMu8tirIBUEHu/qTGkSLtKkZPCfNt7125jtjB4Mq1+jHTyrU
         GVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683613730; x=1686205730;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PR8MLH39bpVXuYi/n+DI0wKNumvoHpECw2yLEsV+23E=;
        b=kR5AAyKzOyKGnQu1pTi/eq5AQplFeiCQM48wZvqaBjjw2Aag5KUaTJxppovxK3riZN
         tDAHOeahEJWu1/ExUMTmr85J/7yF/Mp0T4YF5Rmzx/MX+Mn2V7Ek8v0PQ/eakebnNAo1
         e2dlCj7pZnO14W4ZTf0t3o7pvy0VIbMmGMYuNCBDfCLUTBIGtoYUlfeOdE4DzqddJTW7
         KENFKd6Mt/DvyhNWTGukUrLH9ziANaHBaPGjFokUurPHQEnEQepBX0DY8FHr2+qSpKdl
         tP69HfGZmaOJNPIQqXFYlmtWj7JoQU2ceepzqM/l1EjP+yOkDWL9FX06dgl3jLUEJ7Ec
         tD2w==
X-Gm-Message-State: AC+VfDx8DOcNgxiEWFPakspMwMRjvTgdDCS074Owv27JRCA20pmwnxYA
        WlUg+PhgiNQ56Wc3eFdpS3uwOCFjybKHem3NRuO96OqHLhKBMw==
X-Google-Smtp-Source: ACHHUZ4BMRC2xz2nUpO8W0FQD213rcVkEOoET5lLZsMHj17lR6C0q0TYvSblRN4C/vpPCbNpF3IdTYJfBn8wfs1r9rk=
X-Received: by 2002:ac2:4f8e:0:b0:4f1:3eea:eaf9 with SMTP id
 z14-20020ac24f8e000000b004f13eeaeaf9mr403645lfs.24.1683613729915; Mon, 08 May
 2023 23:28:49 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 May 2023 01:28:38 -0500
Message-ID: <CAH2r5mvqK0CkcR_DOwUfDVzsWco-SXb4rTt14b-YF5CpqCNrZQ@mail.gmail.com>
Subject: [PATCH] SMB3: force unmount was failing to close deferred close files
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Bharath S M <bharathsm@microsoft.com>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000004fd9e305fb3cde0d"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004fd9e305fb3cde0d
Content-Type: text/plain; charset="UTF-8"

In investigating a failure with xfstest generic/392 it
was noticed that mounts were reusing a superblock that should
already have been freed. This turned out to be related to
deferred close files keeping a reference count until the
closetimeo expired.

Currently the only way an fs knows that mount is beginning is
when force unmount is called, but when this, ie umount_begin(),
is called all deferred close files on the share (tree
connection) should be closed immediately (unless shared by
another mount) to avoid using excess resources on the server
and to avoid reusing a superblock which should already be freed.

In umount_begin, close all deferred close handles for that
share if this is the last mount using that share on this
client (ie send the SMB3 close request over the wire for those
that have been already closed by the app but that we have
kept a handle lease open for and have not sent closes to the
server for yet).

Reported-by: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Fixes: 78c09634f7dc ("Cifs: Fix kernel oops caused by deferred close
for files.")

See attached
-- 
Thanks,

Steve

--0000000000004fd9e305fb3cde0d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-force-unmount-was-failing-to-close-deferred-clo.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-force-unmount-was-failing-to-close-deferred-clo.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lhfw3u350>
X-Attachment-Id: f_lhfw3u350

RnJvbSA2Yzg0MGM3MDRkOWRjM2YwMjk3MGM0NmViZWJiMzU5ZTQyM2MwNTQ4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgOSBNYXkgMjAyMyAwMTowMDo0MiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjM6IGZvcmNlIHVubW91bnQgd2FzIGZhaWxpbmcgdG8gY2xvc2UgZGVmZXJyZWQgY2xvc2UgZmls
ZXMKCkluIGludmVzdGlnYXRpbmcgYSBmYWlsdXJlIHdpdGggeGZzdGVzdCBnZW5lcmljLzM5MiBp
dAp3YXMgbm90aWNlZCB0aGF0IG1vdW50cyB3ZXJlIHJldXNpbmcgYSBzdXBlcmJsb2NrIHRoYXQg
c2hvdWxkCmFscmVhZHkgaGF2ZSBiZWVuIGZyZWVkLiBUaGlzIHR1cm5lZCBvdXQgdG8gYmUgcmVs
YXRlZCB0bwpkZWZlcnJlZCBjbG9zZSBmaWxlcyBrZWVwaW5nIGEgcmVmZXJlbmNlIGNvdW50IHVu
dGlsIHRoZQpjbG9zZXRpbWVvIGV4cGlyZWQuCgpDdXJyZW50bHkgdGhlIG9ubHkgd2F5IGFuIGZz
IGtub3dzIHRoYXQgbW91bnQgaXMgYmVnaW5uaW5nIGlzCndoZW4gZm9yY2UgdW5tb3VudCBpcyBj
YWxsZWQsIGJ1dCB3aGVuIHRoaXMsIGllIHVtb3VudF9iZWdpbigpLAppcyBjYWxsZWQgYWxsIGRl
ZmVycmVkIGNsb3NlIGZpbGVzIG9uIHRoZSBzaGFyZSAodHJlZQpjb25uZWN0aW9uKSBzaG91bGQg
YmUgY2xvc2VkIGltbWVkaWF0ZWx5ICh1bmxlc3Mgc2hhcmVkIGJ5CmFub3RoZXIgbW91bnQpIHRv
IGF2b2lkIHVzaW5nIGV4Y2VzcyByZXNvdXJjZXMgb24gdGhlIHNlcnZlcgphbmQgdG8gYXZvaWQg
cmV1c2luZyBhIHN1cGVyYmxvY2sgd2hpY2ggc2hvdWxkIGFscmVhZHkgYmUgZnJlZWQuCgpJbiB1
bW91bnRfYmVnaW4sIGNsb3NlIGFsbCBkZWZlcnJlZCBjbG9zZSBoYW5kbGVzIGZvciB0aGF0CnNo
YXJlIGlmIHRoaXMgaXMgdGhlIGxhc3QgbW91bnQgdXNpbmcgdGhhdCBzaGFyZSBvbiB0aGlzCmNs
aWVudCAoaWUgc2VuZCB0aGUgU01CMyBjbG9zZSByZXF1ZXN0IG92ZXIgdGhlIHdpcmUgZm9yIHRo
b3NlCnRoYXQgaGF2ZSBiZWVuIGFscmVhZHkgY2xvc2VkIGJ5IHRoZSBhcHAgYnV0IHRoYXQgd2Ug
aGF2ZQprZXB0IGEgaGFuZGxlIGxlYXNlIG9wZW4gZm9yIGFuZCBoYXZlIG5vdCBzZW50IGNsb3Nl
cyB0byB0aGUKc2VydmVyIGZvciB5ZXQpLgoKUmVwb3J0ZWQtYnk6IERhdmlkIEhvd2VsbHMgPGRo
b3dlbGxzQHJlZGhhdC5jb20+CkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KRml4ZXM6IDc4
YzA5NjM0ZjdkYyAoIkNpZnM6IEZpeCBrZXJuZWwgb29wcyBjYXVzZWQgYnkgZGVmZXJyZWQgY2xv
c2UgZm9yIGZpbGVzLiIpClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWlj
cm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNmcy5jIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9j
aWZzZnMuYwppbmRleCA4MTQzMGFiYWNmOTMuLjhiNmIzYjY5ODVmMyAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC03NDQsNiArNzQ0LDcgQEAg
c3RhdGljIHZvaWQgY2lmc191bW91bnRfYmVnaW4oc3RydWN0IHN1cGVyX2Jsb2NrICpzYikKIAlz
cGluX3VubG9jaygmdGNvbi0+dGNfbG9jayk7CiAJc3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19s
b2NrKTsKIAorCWNpZnNfY2xvc2VfYWxsX2RlZmVycmVkX2ZpbGVzKHRjb24pOwogCS8qIGNhbmNl
bF9icmxfcmVxdWVzdHModGNvbik7ICovIC8qIEJCIG1hcmsgYWxsIGJybCBtaWRzIGFzIGV4aXRp
bmcgKi8KIAkvKiBjYW5jZWxfbm90aWZ5X3JlcXVlc3RzKHRjb24pOyAqLwogCWlmICh0Y29uLT5z
ZXMgJiYgdGNvbi0+c2VzLT5zZXJ2ZXIpIHsKLS0gCjIuMzQuMQoK
--0000000000004fd9e305fb3cde0d--
