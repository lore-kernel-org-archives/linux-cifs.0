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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B59C433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 03:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2524823A1D
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 03:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgLIDWD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Dec 2020 22:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgLIDWC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Dec 2020 22:22:02 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1C1C0613CF
        for <linux-cifs@vger.kernel.org>; Tue,  8 Dec 2020 19:21:22 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id m12so735668lfo.7
        for <linux-cifs@vger.kernel.org>; Tue, 08 Dec 2020 19:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=G0KPx2aADKGuH/YUBK7w7NQszfpM/k6DdeKwHEl9hJ0=;
        b=QMJ95IkvLkqDfU022DSJf7VxJatw+e4uYiLOThay178nhVAGrDOwCa9xAS1ya/Zgwy
         VwtBN5v0DYj20TS1/Hb/+rGOgodrQAMkxbKFDi2OsDaygatYZ6krO2UQz2T32hmEen1r
         QnzWqcAv+U+k8QW2DC+as2ojIVJCh1JQcWT4baOo70RccRrOeo3qEds4nzf4McptXFtH
         gz/PaR+mnSnxYwAcgLjtOmeexfnsWRor1ixg6wV4vfliDky+FsajXqO2iBqVjjMd62Ld
         3k3InXL3SK42vpyA77lKXzJxUYHUaOhMK04JqH2DqfgF0MUxRrYpJASqO/PK9xco9fnX
         c3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=G0KPx2aADKGuH/YUBK7w7NQszfpM/k6DdeKwHEl9hJ0=;
        b=B+JDNSNblM61FE01rhSJl5GQvmg1eSewYVcIS+8Rr0cPT6Yl1APOkOhUgIhgxyBlaP
         2D/H3/s5FpgEOR0P2P306ULOO7WMZEgtYYaJX/7sSIk9rkvwocAZjT69nUKN50uvxy6d
         VSXIUvazCBanwvz2jYdYU2EVYjAAWxRVJGoXSKa00PvtpqWwK++kEQ7Cc4KUD4w6PNP8
         nm+sfyNkMG7IdZSr49IWo6h4j0q5hdblaO59TvymJb9wheADvX8zLbppAOhyDVLc31sZ
         q6877dhU+oiNnU5q4VkBZ7NWkdy5tlSIaacvg/NsXiyR805337IGxXu/Tmt2v++TEpom
         TIeg==
X-Gm-Message-State: AOAM5330UG5cdZodnFxz5DgV4LVGzqZ96CQ1YDdqHiS93SPAR0/FbjTa
        Mu1Ra3VHnd8UYPcHyDYx7ggTs4HfnywFx7GiZt4DqAeyWvokAw==
X-Google-Smtp-Source: ABdhPJx3ORDu2fwDDBhTLh5eSw9ciSo1GN9PzlwMEXJRpXH9p+hjU6lgP75FQZkBC1G+9z4EOWhe1HV127Y6I56bdUE=
X-Received: by 2002:ac2:48b2:: with SMTP id u18mr249100lfg.313.1607484080285;
 Tue, 08 Dec 2020 19:21:20 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 8 Dec 2020 21:21:08 -0600
Message-ID: <CAH2r5mtx6zWZ2T_Erb=6JQ3mHJxh=bHydww-F52ts3zsvgd8Jw@mail.gmail.com>
Subject: [SMB3][Multichannel] avoid confusing warning message on mount to Azure
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000009695f805b5ff8df5"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000009695f805b5ff8df5
Content-Type: text/plain; charset="UTF-8"

Mounts to Azure cause an unneeded warning message in dmesg
   "CIFS: VFS: parse_server_interfaces: incomplete interface info"

Azure rounds up the size (by 8 additional bytes, to a
16 byte boundary) of the structure returned on the query
of the server interfaces at mount time.  This is permissible
even though different than other servers so do not log a warning
if query network interfaces response is only rounded up by 8
bytes or fewer.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3d914d7d0d11..22f1d8dc12b0 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -477,7 +477,8 @@ parse_server_interfaces(struct
network_interface_info_ioctl_rsp *buf,
  goto out;
  }

- if (bytes_left || p->Next)
+ /* Azure rounds the buffer size up 8, to a 16 byte boundary */
+ if ((bytes_left > 8) || p->Next)
  cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);


-- 
Thanks,

Steve

--0000000000009695f805b5ff8df5
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-avoid-confusing-warning-message-on-mount-to-Azu.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-avoid-confusing-warning-message-on-mount-to-Azu.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kiguiapr0>
X-Attachment-Id: f_kiguiapr0

RnJvbSBjZTg2ZTM1ZTg4ZGY2OWYyODkwZWQyYWI2OTllMjkyYzczOTBlZjJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgOCBEZWMgMjAyMCAyMToxMzozMSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjM6IGF2b2lkIGNvbmZ1c2luZyB3YXJuaW5nIG1lc3NhZ2Ugb24gbW91bnQgdG8gQXp1cmUKCk1v
dW50cyB0byBBenVyZSBjYXVzZSBhbiB1bm5lZWRlZCB3YXJuaW5nIG1lc3NhZ2UgaW4gZG1lc2cK
ICAgIkNJRlM6IFZGUzogcGFyc2Vfc2VydmVyX2ludGVyZmFjZXM6IGluY29tcGxldGUgaW50ZXJm
YWNlIGluZm8iCgpBenVyZSByb3VuZHMgdXAgdGhlIHNpemUgKGJ5IDggYWRkaXRpb25hbCBieXRl
cywgdG8gYQoxNiBieXRlIGJvdW5kYXJ5KSBvZiB0aGUgc3RydWN0dXJlIHJldHVybmVkIG9uIHRo
ZSBxdWVyeQpvZiB0aGUgc2VydmVyIGludGVyZmFjZXMgYXQgbW91bnQgdGltZS4gIFRoaXMgaXMg
cGVybWlzc2libGUKZXZlbiB0aG91Z2ggZGlmZmVyZW50IHRoYW4gb3RoZXIgc2VydmVycyBzbyBk
byBub3QgbG9nIGEgd2FybmluZwppZiBxdWVyeSBuZXR3b3JrIGludGVyZmFjZXMgcmVzcG9uc2Ug
aXMgb25seSByb3VuZGVkIHVwIGJ5IDgKYnl0ZXMgb3IgZmV3ZXIuCgpDQzogU3RhYmxlIDxzdGFi
bGVAdmdlci5rZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNo
QG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyb3BzLmMgfCAzICsrLQogMSBmaWxlIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggM2Q5MTRkN2QwZDExLi4yMmYx
ZDhkYzEyYjAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21i
Mm9wcy5jCkBAIC00NzcsNyArNDc3LDggQEAgcGFyc2Vfc2VydmVyX2ludGVyZmFjZXMoc3RydWN0
IG5ldHdvcmtfaW50ZXJmYWNlX2luZm9faW9jdGxfcnNwICpidWYsCiAJCWdvdG8gb3V0OwogCX0K
IAotCWlmIChieXRlc19sZWZ0IHx8IHAtPk5leHQpCisJLyogQXp1cmUgcm91bmRzIHRoZSBidWZm
ZXIgc2l6ZSB1cCA4LCB0byBhIDE2IGJ5dGUgYm91bmRhcnkgKi8KKwlpZiAoKGJ5dGVzX2xlZnQg
PiA4KSB8fCBwLT5OZXh0KQogCQljaWZzX2RiZyhWRlMsICIlczogaW5jb21wbGV0ZSBpbnRlcmZh
Y2UgaW5mb1xuIiwgX19mdW5jX18pOwogCiAKLS0gCjIuMjcuMAoK
--0000000000009695f805b5ff8df5--
