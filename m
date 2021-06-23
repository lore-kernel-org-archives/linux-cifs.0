Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6229CC2B9F4
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 01:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 354D1611CE
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 01:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFWBGP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFWBGO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 21:06:14 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EBAC061574
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 18:03:58 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s22so660906ljg.5
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 18:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KTjDRd9b+aLcrTZ1m/ciseHLt4RCRJiJuXaoxtD3nYM=;
        b=f+7P6S4Y96kbSCHTf1aArcb5vfV/SeKVxYxrzJ24wkdtQs7uKBF0edXT5H7KuJHvGX
         JJGRI4XPHbxF9FpHqngeI0OpKwhYHfUFROvHYsRTwaH39JmTAKh55TP/7nIszmiBXq6Z
         4cXZm31rQdvLmrU+pw+v3weXEe0K31rLfvvFoL85udX/JW/iGDzS2IS/zte8Mp4buAlw
         3pdBqZ5actG/i6S6ZO8DPGo4bxvxkR67a6SZNeyBlskk44WukeyQvKaiEhKQEVbJ9WT/
         EcAdbbTnnxLpL0OpjqN+Bzre2ehCYRgyW3E3BU8wnueYv4iimn+a13eTSAzYCuvRz53m
         W2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KTjDRd9b+aLcrTZ1m/ciseHLt4RCRJiJuXaoxtD3nYM=;
        b=gBeTlnqDY7IbK0dO1ch8/EjFZjW2EzohErZvVhEKeaHMGtxDN+cMTCemU8yDhssQGl
         g04Kl2WFmQotMKnYTCKDGzsbMoIkEtc0cFcp/B5HHvCPGxOEApdfuYV3C/P9jEJaYC3A
         ncmkMQ+Bx/ZpCekatkfWT0RZ8Ta11XHxKfMpN9HTGzwCgOQJ5TmuBA1yr1dcoqOdnPy4
         FiZDz766Zr8L8jiRWaKh9T8xvgQAZoOD2MxsNnjRA/4WMp+Ub2jO4yaBOWCT9RSXYoGI
         xFwNcPcmXsXe253Qg94ZUYh/yTEOj0zhNe8XrMPtf8LC3VnaMVdP8alWgtuQCTn6+jI3
         +yOg==
X-Gm-Message-State: AOAM532lXJPsVdYImyIdPEU2MTO3LxmutVCeXnZSetQWb2pq6jOl7qP7
        u5uttuRsfUS2rD+sNIBkGNIPtlk04cU5Q5OdmdYAQZ4kVUGhaw==
X-Google-Smtp-Source: ABdhPJzm/kcsqjmbN9pnDezoxtos2KKOc83xpPWi9YJIdEffpG25SO0fWvpcrC2/MP8RjeFv0ulTq9me6V4DcCyGzTM=
X-Received: by 2002:a2e:86d7:: with SMTP id n23mr5589803ljj.406.1624410236179;
 Tue, 22 Jun 2021 18:03:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 20:03:45 -0500
Message-ID: <CAH2r5mtN+0MLW3e_xhqEP3R_EFULWjrzScuyYZgZ2AE9ukERRA@mail.gmail.com>
Subject: [PATCH][CIFS] missing null check for newinode pointer
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000018ec9905c5647b19"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000018ec9905c5647b19
Content-Type: text/plain; charset="UTF-8"

in cifs_do_create we check if newinode is valid before referencing it
but are missing the check in one place in fs/cifs/dir.c

Addresses-Coverity: 1357292 ("Dereference after null check")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/dir.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 912333082b18..aca6ed58cc44 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -384,10 +384,11 @@ cifs_do_create(struct inode *inode, struct
dentry *direntry, unsigned int xid,
  goto out_err;
  }

- if (S_ISDIR(newinode->i_mode)) {
- rc = -EISDIR;
- goto out_err;
- }
+ if (newinode)
+ if (S_ISDIR(newinode->i_mode)) {
+ rc = -EISDIR;
+ goto out_err;
+ }

  d_drop(direntry);
  d_add(direntry, newinode);

-- 
Thanks,

Steve

--00000000000018ec9905c5647b19
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-missing-null-check-for-newinode-pointer.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-missing-null-check-for-newinode-pointer.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq8rwmgz0>
X-Attachment-Id: f_kq8rwmgz0

RnJvbSA4MjUyYzBiYzczY2FkNzNhOGY0Zjc2ZTkwYzIzODFlZTM0ZmZiYzBmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjIgSnVuIDIwMjEgMTk6NTM6MDggLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBtaXNzaW5nIG51bGwgY2hlY2sgZm9yIG5ld2lub2RlIHBvaW50ZXIKCmluIGNpZnNfZG9f
Y3JlYXRlIHdlIGNoZWNrIGlmIG5ld2lub2RlIGlzIHZhbGlkIGJlZm9yZSByZWZlcmVuY2luZyBp
dApidXQgYXJlIG1pc3NpbmcgdGhlIGNoZWNrIGluIG9uZSBwbGFjZSBpbiBmcy9jaWZzL2Rpci5j
CgpBZGRyZXNzZXMtQ292ZXJpdHk6IDEzNTcyOTIgKCJEZXJlZmVyZW5jZSBhZnRlciBudWxsIGNo
ZWNrIikKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29t
PgotLS0KIGZzL2NpZnMvZGlyLmMgfCA5ICsrKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5z
ZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Rpci5jIGIv
ZnMvY2lmcy9kaXIuYwppbmRleCA5MTIzMzMwODJiMTguLmFjYTZlZDU4Y2M0NCAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9kaXIuYworKysgYi9mcy9jaWZzL2Rpci5jCkBAIC0zODQsMTAgKzM4NCwxMSBA
QCBjaWZzX2RvX2NyZWF0ZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZGVudHJ5ICpkaXJl
bnRyeSwgdW5zaWduZWQgaW50IHhpZCwKIAkJZ290byBvdXRfZXJyOwogCX0KIAotCWlmIChTX0lT
RElSKG5ld2lub2RlLT5pX21vZGUpKSB7Ci0JCXJjID0gLUVJU0RJUjsKLQkJZ290byBvdXRfZXJy
OwotCX0KKwlpZiAobmV3aW5vZGUpCisJCWlmIChTX0lTRElSKG5ld2lub2RlLT5pX21vZGUpKSB7
CisJCQlyYyA9IC1FSVNESVI7CisJCQlnb3RvIG91dF9lcnI7CisJCX0KIAogCWRfZHJvcChkaXJl
bnRyeSk7CiAJZF9hZGQoZGlyZW50cnksIG5ld2lub2RlKTsKLS0gCjIuMzAuMgoK
--00000000000018ec9905c5647b19--
