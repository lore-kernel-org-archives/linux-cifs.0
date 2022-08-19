Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4578FC28B2B
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 17:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354592AbiHSRcP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Aug 2022 13:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354597AbiHSRcC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Aug 2022 13:32:02 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C299159C29
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 09:50:40 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id v128so5000779vsb.10
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 09:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=1X2k0fk5hloTVsC4l1/RYGlXdOMhJKvIY9ZL2oQVQ0k=;
        b=gdwlwj8rXWkcJa62+0K6/wJYR6J4UuvT6qiu5+SHtkTTGyRxGSckEuuBkfXNptrxic
         2UHMgo0+WwuHZrcwKMxhxjab5yBPNclZ81F7ZNKYLQeJJihS96pWOCFz8/DYuFe0fYnG
         GLn3AbEnsEKDN79+vG0i/m0+q7vLtRYT+nFRR8xVZIqlohaFsq9OmogqLGLL7w+L5EQl
         g6UlusFmOE/MkPQq4ofUZjRaHPd5W2yBpLwGZmSItmZwuynrO/RGJLXMw0/bL6RyAHre
         JV+Lp4nkJf4uNecghU4l2T8zx41nozd0vBb/DbGBlB8STylyetBMUTeBiFCzsYxDOnVn
         RK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=1X2k0fk5hloTVsC4l1/RYGlXdOMhJKvIY9ZL2oQVQ0k=;
        b=ck0Z+iv8j7cOVWjHhM9uGBbs6/tHu2xBa+JrhIqUmUEaD7OjRvmZYIb3eXvnU+GB37
         4X7u23j0o7WFARURmLYGWo9C8uyQcgtLOchXoTfjmtgBVh1etkWfcG7G97kFtINMgA/A
         Q+JXdt6vnVVDYrtDa0b+JqVlr3Cuh++aXLtGQkqsI9YksZccA48ROhXeKL4Wf4Zsmhmb
         ezweLrXwP7jyGGR5+Gc+1Ei5e82DesO0rxqgBTWe5Rm8MKBc/57lBwkDDPSaLu/eBNFG
         rlYIfBfCzd5cP+LHuyIYyxbr9UrYCsLhZwDdyQXwc3h53MHlhCY0kehO46csOTuWxCjP
         SdgQ==
X-Gm-Message-State: ACgBeo1kLRtRWK4/WQqHXItmrCLPP7qK6wLNWaF1yRTuwQ+gCaL3OMFJ
        hrA/cV0OZ5FGHedeHfMYlQdqtDk98DY5fUA2ZjlifGDrACqRNg==
X-Google-Smtp-Source: AA6agR7Idcw/vICURq8+wOiXzPG7scSXApSWW2+vn0TH2pITUHSm1gOVzewTSirfj7YFHxDAUt3HcmLmzGUA8MPo/3Q=
X-Received: by 2002:a05:6102:1626:b0:390:2616:663e with SMTP id
 cu38-20020a056102162600b003902616663emr1159311vsb.6.1660927741751; Fri, 19
 Aug 2022 09:49:01 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Aug 2022 11:48:51 -0500
Message-ID: <CAH2r5mvShnJidFDQkdULTDQFteSKimcphT_GGfVb0zXx9PkNcQ@mail.gmail.com>
Subject: missing update to deferred_close_scheduled field
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     rohiths msft <rohiths.msft@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000000b88ec05e69ae090"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000b88ec05e69ae090
Content-Type: text/plain; charset="UTF-8"

> we are missing a line like this:
>
>        cfile->deferred_close_scheduled = false;
>
> in cifs_open here:
>
>         /* Get the cached handle as SMB2 close is deferred */
>         rc = cifs_get_readable_path(tcon, full_path, &cfile);
>         if (rc == 0) {
>                 if (file->f_flags == cfile->f_flags) {
>                         file->private_data = cfile;
>                         spin_lock(&CIFS_I(inode)->deferred_lock);
>                         cifs_del_deferred_close(cfile);
>                         spin_unlock(&CIFS_I(inode)->deferred_lock);
>                         goto use_cache;

So move set of deferred_close_scheduled = false into cifs_del_deferred_close

See attached

-- 
Thanks,

Steve

--0000000000000b88ec05e69ae090
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-missing-update-to-whether-a-close-is-deferred-i.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-missing-update-to-whether-a-close-is-deferred-i.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l70phg4n0>
X-Attachment-Id: f_l70phg4n0

RnJvbSA5MDE1M2VkNTM1MTU3NmIzZjFhNDk0MzU5MzY2NGQ1MmM3ZjhkODJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTkgQXVnIDIwMjIgMTE6MzM6NDQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBtaXNzaW5nIHVwZGF0ZSB0byB3aGV0aGVyIGEgY2xvc2UgaXMgZGVmZXJyZWQgaW4gYQog
cmVvcGVuIHBhdGgKCldoZW4gZGVsZXRpbmcgYSBmaWxlIGhhbmRsZSBmcm9tIHRoZSBkZWZlcnJl
ZCBjbG9zZSBsaXN0IHdlCndlcmUgbWlzc2luZyB1cGRhdGUgdG8gY2ZpbGUtPmRlZmVycmVkX2Ns
b3NlX3NjaGVkdWxlZAoKUmV2aWV3ZWQtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jv
c29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9jaWZzL2ZpbGUuYyB8IDEgLQogZnMvY2lmcy9taXNjLmMgfCAxICsKIDIg
ZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5jCmluZGV4IGZhNzM4YWRjMDMxZi4uMTJi
ZjA0MTRkYzg0IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUuYworKysgYi9mcy9jaWZzL2ZpbGUu
YwpAQCAtOTMwLDcgKzkzMCw2IEBAIHZvaWQgc21iMl9kZWZlcnJlZF93b3JrX2Nsb3NlKHN0cnVj
dCB3b3JrX3N0cnVjdCAqd29yaykKIAogCXNwaW5fbG9jaygmQ0lGU19JKGRfaW5vZGUoY2ZpbGUt
PmRlbnRyeSkpLT5kZWZlcnJlZF9sb2NrKTsKIAljaWZzX2RlbF9kZWZlcnJlZF9jbG9zZShjZmls
ZSk7Ci0JY2ZpbGUtPmRlZmVycmVkX2Nsb3NlX3NjaGVkdWxlZCA9IGZhbHNlOwogCXNwaW5fdW5s
b2NrKCZDSUZTX0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVkX2xvY2spOwogCV9j
aWZzRmlsZUluZm9fcHV0KGNmaWxlLCB0cnVlLCBmYWxzZSk7CiB9CmRpZmYgLS1naXQgYS9mcy9j
aWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5jCmluZGV4IDg3ZjYwZjczNjczMS4uM2U5OWRkNDA4
NWViIDEwMDY0NAotLS0gYS9mcy9jaWZzL21pc2MuYworKysgYi9mcy9jaWZzL21pc2MuYwpAQCAt
NzE4LDYgKzcxOCw3IEBAIGNpZnNfZGVsX2RlZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUlu
Zm8gKmNmaWxlKQogCWlzX2RlZmVycmVkID0gY2lmc19pc19kZWZlcnJlZF9jbG9zZShjZmlsZSwg
JmRjbG9zZSk7CiAJaWYgKCFpc19kZWZlcnJlZCkKIAkJcmV0dXJuOworCWRlZmVycmVkX2Nsb3Nl
X3NjaGVkdWxlZCA9IGZhbHNlOwogCWxpc3RfZGVsKCZkY2xvc2UtPmRsaXN0KTsKIAlrZnJlZShk
Y2xvc2UpOwogfQotLSAKMi4zNC4xCgo=
--0000000000000b88ec05e69ae090--
