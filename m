Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2730C07E96
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 02:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B4161C81
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 02:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhGGCs5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Jul 2021 22:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhGGCs5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Jul 2021 22:48:57 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8946C061574
        for <linux-cifs@vger.kernel.org>; Tue,  6 Jul 2021 19:46:16 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id y42so1401895lfa.3
        for <linux-cifs@vger.kernel.org>; Tue, 06 Jul 2021 19:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=zp9FK4ClBBXMRVq3i9TrKEbK6GCWnIVqRpypGdPGgI0=;
        b=L21NRDTq6wGGhV5/aaUYJXVz/FAj44HFb89R4liQpyQ+c60cTS7qdR1Ai7H3Ud9Yyf
         50K7n9gQncPpaUCyJGY/NIkgDOsy0sCXH0pkUQZwlInCJClMHzpuQGqRdz0fheXliOkG
         dDjGON/XufEcPz1mwMbmUwgDp3yuqyPZz3A72liW5ilJ0JSTQ9poXCNZBkElm+nsf2US
         td9AWllXLLmO/JuZGT3GjHEdTVTke3EkxUaLn6cMHpR17sYiUr5hQ0btYQy995inwpOB
         3Rk1BFaOO1brltPJkslTBLqksP3eu6RuS/+PL2SZjp283cs7JmGrpiiARXjf43lhv6q0
         vX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zp9FK4ClBBXMRVq3i9TrKEbK6GCWnIVqRpypGdPGgI0=;
        b=KB9Fh7X4EHeEjNeOqEoFX/mx0lGGGlCrERVk2DYjNzmOo/LN9ZHQUbzV69Ew250dIK
         psKnzKC1+lro0RBiT8OiqeBMS3CXeg9AGDQFH7a532Krl1ErU+Pbxx0lkEcwDzAWMLRI
         KW1e5Tebo0zpuIBNey0nCts6wVEwgrNoGDpyU+EnKBGzqvilgNlqZP06ETrePsgb+VeJ
         Wx+eravvRKjBlBkEwX3AUKvYW3kA8xzTPcjG8qU4vR04Ukq71qjrERDGm+JKFpU3ohfn
         eAy6hDKrJLDv7DvU0SJT3hKwzNA0dF5N/gHEFnUQBtykaXGzPj5LR3HPO76pU75b+ZiR
         +ZJw==
X-Gm-Message-State: AOAM530BdQuH2R8NK5Ou0Jy4eO0p/jYXOiqDzUZ8fMwkJ2xxa3uQPbHT
        5SjxAjmtOzhHX2od3yRkPeIjYkm+ePkWdRgUOnvN0mA7ZxY=
X-Google-Smtp-Source: ABdhPJw3pD19Z+oNo3+hpRy5nUtlgoWwyxO2OBsNjES/IhFeV3cNR/4bsv0QoygcljBWhvWbtPI/tUeZIcK/ylhcINE=
X-Received: by 2002:a19:5043:: with SMTP id z3mr15927248lfj.282.1625625974956;
 Tue, 06 Jul 2021 19:46:14 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 6 Jul 2021 21:46:01 -0500
Message-ID: <CAH2r5mudi2+JF---Ou_8eojmH0f8o7Fz2NejuNvFmPaLPCbUww@mail.gmail.com>
Subject: [CIFS][PATCH] Clarify SMB1 code for delete
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000c67ba005c67f8a29"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c67ba005c67f8a29
Content-Type: text/plain; charset="UTF-8"

Coverity also complains about the way we calculate the offset
(starting from the address of a 4 byte array within the
header structure rather than from the beginning of the struct
plus 4 bytes) for SMB1 SetFileDisposition (which is used to
unlink a file by setting the delete on close flag).  This
changeset doesn't change the address but makes it slightly
clearer.

Addresses-Coverity: 711524 ("Out of bounds write")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifssmb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a513a89aad1a..0863238ddd20 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5763,7 +5763,8 @@ CIFSSMBSetFileDisposition(const unsigned int
xid, struct cifs_tcon *tcon,
  param_offset = offsetof(struct smb_com_transaction2_sfi_req, Fid) - 4;
  offset = param_offset + params;

- data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
+ /* SMB offsets are from the beginning of SMB which is 4 bytes in,
after RFC1001 field */
+ data_offset = (char *)(pSMB) + offset + 4;

  count = 1;
  pSMB->MaxParameterCount = cpu_to_le16(2);

-- 
Thanks,

Steve

--000000000000c67ba005c67f8a29
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Clarify-SMB1-code-for-delete.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Clarify-SMB1-code-for-delete.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqsvq2u60>
X-Attachment-Id: f_kqsvq2u60

RnJvbSA1MzJkYjRiZjg1ZjlmMmZhZTEzMTU0ZmZjNDVjZmI3MTI3OWE1ZGFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgNiBKdWwgMjAyMSAyMTo0MjowOCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIENJ
RlM6IENsYXJpZnkgU01CMSBjb2RlIGZvciBkZWxldGUKCkNvdmVyaXR5IGFsc28gY29tcGxhaW5z
IGFib3V0IHRoZSB3YXkgd2UgY2FsY3VsYXRlIHRoZSBvZmZzZXQKKHN0YXJ0aW5nIGZyb20gdGhl
IGFkZHJlc3Mgb2YgYSA0IGJ5dGUgYXJyYXkgd2l0aGluIHRoZQpoZWFkZXIgc3RydWN0dXJlIHJh
dGhlciB0aGFuIGZyb20gdGhlIGJlZ2lubmluZyBvZiB0aGUgc3RydWN0CnBsdXMgNCBieXRlcykg
Zm9yIFNNQjEgU2V0RmlsZURpc3Bvc2l0aW9uICh3aGljaCBpcyB1c2VkIHRvCnVubGluayBhIGZp
bGUgYnkgc2V0dGluZyB0aGUgZGVsZXRlIG9uIGNsb3NlIGZsYWcpLiAgVGhpcwpjaGFuZ2VzZXQg
ZG9lc24ndCBjaGFuZ2UgdGhlIGFkZHJlc3MgYnV0IG1ha2VzIGl0IHNsaWdodGx5CmNsZWFyZXIu
CgpBZGRyZXNzZXMtQ292ZXJpdHk6IDcxMTUyNCAoIk91dCBvZiBib3VuZHMgd3JpdGUiKQpTaWdu
ZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMv
Y2lmcy9jaWZzc21iLmMgfCAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3NtYi5jIGIvZnMvY2lmcy9j
aWZzc21iLmMKaW5kZXggYTUxM2E4OWFhZDFhLi4wODYzMjM4ZGRkMjAgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvY2lmc3NtYi5jCisrKyBiL2ZzL2NpZnMvY2lmc3NtYi5jCkBAIC01NzYzLDcgKzU3NjMs
OCBAQCBDSUZTU01CU2V0RmlsZURpc3Bvc2l0aW9uKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0
cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJcGFyYW1fb2Zmc2V0ID0gb2Zmc2V0b2Yoc3RydWN0IHNt
Yl9jb21fdHJhbnNhY3Rpb24yX3NmaV9yZXEsIEZpZCkgLSA0OwogCW9mZnNldCA9IHBhcmFtX29m
ZnNldCArIHBhcmFtczsKIAotCWRhdGFfb2Zmc2V0ID0gKGNoYXIgKikgKCZwU01CLT5oZHIuUHJv
dG9jb2wpICsgb2Zmc2V0OworCS8qIFNNQiBvZmZzZXRzIGFyZSBmcm9tIHRoZSBiZWdpbm5pbmcg
b2YgU01CIHdoaWNoIGlzIDQgYnl0ZXMgaW4sIGFmdGVyIFJGQzEwMDEgZmllbGQgKi8KKwlkYXRh
X29mZnNldCA9IChjaGFyICopKHBTTUIpICsgb2Zmc2V0ICsgNDsKIAogCWNvdW50ID0gMTsKIAlw
U01CLT5NYXhQYXJhbWV0ZXJDb3VudCA9IGNwdV90b19sZTE2KDIpOwotLSAKMi4zMC4yCgo=
--000000000000c67ba005c67f8a29--
