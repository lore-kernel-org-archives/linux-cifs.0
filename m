Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCB5C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 03:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiCQDWB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Mar 2022 23:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiCQDWA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Mar 2022 23:22:00 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBD324F05
        for <linux-cifs@vger.kernel.org>; Wed, 16 Mar 2022 20:20:43 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id bt26so6923925lfb.3
        for <linux-cifs@vger.kernel.org>; Wed, 16 Mar 2022 20:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=UpTkoax8yQoHyUmj474Rhlj5akVoLwWU2DH5DyLCx/g=;
        b=HIPgTdW1lWLF+gCn5B+q7+pSRrKNEIorhOa7xCo0Q/PxIKnBIEAXnHEkgq/LFhU5BQ
         Lpp2JFPDFWibUxxaO1kuka3XHEp4oaDMOiASbz8HBGrlaBVi/iNn8tW3UXkRjx4KmUo/
         HWGr8R/IPLGsZwrBqmysFuMY+qtf1kgtTIijYi+hrUmIgHwdE6vQku4xkULKsuMcr1oH
         E2yDdGhGZlWRrLmESY0O2L96AMSxLztym1+I1+scX5spjq7YRugqdvPP4fkYVCtHLNoH
         +MdZZyFtwMq17Dm6JQuGTzK6Ku0COyGJbqlQ6WNtKsuWJKBnqu0UaETuzCQ1sFRKF290
         ctvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=UpTkoax8yQoHyUmj474Rhlj5akVoLwWU2DH5DyLCx/g=;
        b=h/Ezx0wWnS+oYD+yykl6K5AtD15I128icAKP4dlN8To51crHNtWDXSkHj3CpVZ75U2
         spnms6lnxZKfyOefOHCrtIdFWeGATctqoUsoC7gD6ZcJhTWFULbBH6GYAFlvLhwgohsX
         iilrSW656o7x7oT1dLqZjOCv7imWA/r7KvJtsyIr0VRp6HBAyGQo1KF0eHezVm0MlJ5f
         DLwoViWGDwqSHNqFUUok3BACGYljVPfuZkILUO7yebIqCG9u8v9oD+Cw62ACC0k4bF3q
         WVH0eNH2PpYgZL3tTmhlEQUcrE89WbqwLjQo6PZXV41+IePJNX7waZIDvO3NAOiEJeu6
         6uuA==
X-Gm-Message-State: AOAM533L+HhjorWJwHAmW85mc16YjIbrne35eLaOsLI2EVoRhoI6w7q7
        L+Ah0YlOs10sBKYlM76IyjaPf+VaK/UERSkpwUJDat59g6Q=
X-Google-Smtp-Source: ABdhPJw/WWzIxcVTVsXB+ypa3mVBI/b8xJLurJUC+VxVH8xbKhD9BsBEl+ifrmK3esOycq6lN+Vpt2e68Mw7d8DJqqo=
X-Received: by 2002:ac2:5dd4:0:b0:448:b3ea:9171 with SMTP id
 x20-20020ac25dd4000000b00448b3ea9171mr1648130lfq.234.1647487241070; Wed, 16
 Mar 2022 20:20:41 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 16 Mar 2022 22:20:30 -0500
Message-ID: <CAH2r5mth2fYLzU5+oN09ipT7peRdyAiPCF-7_fLPsTpA-fKKLA@mail.gmail.com>
Subject: [PATCH][SMB3] fix multiuser mount regression
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Satadru Pramanik <satadru@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000c6d2bf05da6183bd"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c6d2bf05da6183bd
Content-Type: text/plain; charset="UTF-8"

cifssmb3: fix incorrect session setup check for multiuser mounts

A recent change to how the SMB3 server (socket) and session status
is managed regressed multiuser mounts by changing the check
for whether session setup is needed to the socket (TCP_Server_info)
structure instead of the session struct (cifs_ses). Add additional
check in cifs_setup_sesion to fix this.

Fixes: 73f9bfbe3d81 ("cifs: maintain a state machine for tcp/smb/tcon sessions")
Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/connect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 053cb449eb16..d3020abfe404 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3924,7 +3924,8 @@ cifs_setup_session(const unsigned int xid,
struct cifs_ses *ses,

  /* only send once per connect */
  spin_lock(&cifs_tcp_ses_lock);
- if (server->tcpStatus != CifsNeedSessSetup) {
+ if ((server->tcpStatus != CifsNeedSessSetup) &&
+     (ses->status == CifsGood)) {
  spin_unlock(&cifs_tcp_ses_lock);
  return 0;
  }

-- 
Thanks,

Steve

--000000000000c6d2bf05da6183bd
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-incorrect-session-setup-check-for-multiuser.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-incorrect-session-setup-check-for-multiuser.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l0ufct840>
X-Attachment-Id: f_l0ufct840

RnJvbSA2NTY3NDAwZGM5MzZjYThhZGQzOWJlMzZhZjM0Yzg3MjI2NzFmOGVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTYgTWFyIDIwMjIgMjI6MDg6NDMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggaW5jb3JyZWN0IHNlc3Npb24gc2V0dXAgY2hlY2sgZm9yIG11bHRpdXNlciBtb3Vu
dHMKCkEgcmVjZW50IGNoYW5nZSB0byBob3cgdGhlIFNNQjMgc2VydmVyIChzb2NrZXQpIGFuZCBz
ZXNzaW9uIHN0YXR1cwppcyBtYW5hZ2VkIHJlZ3Jlc3NlZCBtdWx0aXVzZXIgbW91bnRzIGJ5IGNo
YW5naW5nIHRoZSBjaGVjawpmb3Igd2hldGhlciBzZXNzaW9uIHNldHVwIGlzIG5lZWRlZCB0byB0
aGUgc29ja2V0IChUQ1BfU2VydmVyX2luZm8pCnN0cnVjdHVyZSBpbnN0ZWFkIG9mIHRoZSBzZXNz
aW9uIHN0cnVjdCAoY2lmc19zZXMpLiBBZGQgYWRkaXRpb25hbApjaGVjayBpbiBjaWZzX3NldHVw
X3Nlc2lvbiB0byBmaXggdGhpcy4KCkZpeGVzOiA3M2Y5YmZiZTNkODEgKCJjaWZzOiBtYWludGFp
biBhIHN0YXRlIG1hY2hpbmUgZm9yIHRjcC9zbWIvdGNvbiBzZXNzaW9ucyIpClJlcG9ydGVkLWJ5
OiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0
ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3Qu
YyB8IDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRl
eCAwNTNjYjQ0OWViMTYuLmQzMDIwYWJmZTQwNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0
LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTM5MjQsNyArMzkyNCw4IEBAIGNpZnNfc2V0
dXBfc2Vzc2lvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywK
IAogCS8qIG9ubHkgc2VuZCBvbmNlIHBlciBjb25uZWN0ICovCiAJc3Bpbl9sb2NrKCZjaWZzX3Rj
cF9zZXNfbG9jayk7Ci0JaWYgKHNlcnZlci0+dGNwU3RhdHVzICE9IENpZnNOZWVkU2Vzc1NldHVw
KSB7CisJaWYgKChzZXJ2ZXItPnRjcFN0YXR1cyAhPSBDaWZzTmVlZFNlc3NTZXR1cCkgJiYKKwkg
ICAgKHNlcy0+c3RhdHVzID09IENpZnNHb29kKSkgewogCQlzcGluX3VubG9jaygmY2lmc190Y3Bf
c2VzX2xvY2spOwogCQlyZXR1cm4gMDsKIAl9Ci0tIAoyLjMyLjAKCg==
--000000000000c6d2bf05da6183bd--
