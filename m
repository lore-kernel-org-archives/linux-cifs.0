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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B3AC4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 19:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5302F60EB2
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 19:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhGVTBY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jul 2021 15:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGVTBY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jul 2021 15:01:24 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D169C061575
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 12:41:58 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id y25so8002042ljy.13
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 12:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2T2UdF5U9AE4wfAUFdvnJ8TrivryyufCnja4iT0JhRA=;
        b=vIUKByWEsMxjcrJmTUysnP2BbmYDpNcLAguiRIZVa8K0SZfWuSthXmqbcqrFw13/am
         PjzyqSQaZzeYzKkdFonYx823lmLgPMBRCyPtf94/7B3htM8D95EG6PmQodYlOpYh2Ihc
         J/fmGY9PK0nNFbHnH2zVyysFCL3tMSLGCPzZKUl6O9apXSbRBh5jArioyzpdA9nzZd6q
         lqjMyu6tEPab29jqrYUPiGTJF6q8/J6LazP+BrRbDzZu3gITLd0qs4HEGojL9GXBUMrZ
         IZk4zYY2iZ9Fvge0MjqSueQ0hkASjNGK8tmPYK7b5bDpK36L8jwGx5X9PwJUIEpMs9o8
         MGWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2T2UdF5U9AE4wfAUFdvnJ8TrivryyufCnja4iT0JhRA=;
        b=YgHyjyQkScQL1INR1unB4WB8o1MP9WVW7BlrbXjlC3vg8rThO9rlECILYL3SEnwCK0
         H4CHd7utsdE50XAZP9n3ttrgRJH3Ki4g9WBZgsDccMcENU8tLUAiUkmp8S9/BusZEW4N
         dsJsjKaFbEirJ8n5ypEkwttVsRqPnS7hneBztlEIJI3lSrVVDyb4k0FONzwtccXi66NZ
         FaFvNeEqDftPZL/tVu+LOzyo85kNRd63cjQemJFWZsnGuc8BKOP9RzkkVsY4076tZQOm
         grA+Qe+ZMoS0EJvfqmZJzDmd3HW5Q5KrVRfh8UFbZAwD9uPKB7GOZV8+T6APOF/dX2cB
         oo8g==
X-Gm-Message-State: AOAM533Lvh58BTdWOsKFw34dpCKiBzcfhFqcuxInaNrIjaZ2cGMvFpqj
        lqnWVmAUMWGcUImknUl4vrsCKYOQmpkk5o07BE/NA6dC1BBvLA==
X-Google-Smtp-Source: ABdhPJytXDst+XXGq4OGsFWDInWT0mogBRo/vllTb9rbqjNLc07Gq/EyfZooQjuEuSP0gOV5N4Nq8qRRqBsy3Q0H3XM=
X-Received: by 2002:a2e:9613:: with SMTP id v19mr1083324ljh.148.1626982916370;
 Thu, 22 Jul 2021 12:41:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 22 Jul 2021 14:41:43 -0500
Message-ID: <CAH2r5mvdfWVp894wSrY0qB6+OCF-Qm+N_q2TkzJKaFCBxb-Kjg@mail.gmail.com>
Subject: [PATCH[[CIFS] Clarify SMB1 code for POSIX delete file
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000c9baac05c7bb7ae7"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c9baac05c7bb7ae7
Content-Type: text/plain; charset="UTF-8"

Coverity also complains about the way we calculate the offset
    (starting from the address of a 4 byte array within the
    header structure rather than from the beginning of the struct
    plus 4 bytes) for SMB1 CIFSPOSIXDelFile. This changeset
    doesn't change the address but makes it slightly clearer.

    Addresses-Coverity: 711519 ("Out of bounds write")
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d4144c182604..65d1a65bfc37 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -873,8 +873,11 @@ CIFSPOSIXDelFile(const unsigned int xid, struct
cifs_tcon *tcon,
                                InformationLevel) - 4;
        offset = param_offset + params;

-       /* Setup pointer to Request Data (inode type) */
-       pRqD = (struct unlink_psx_rq *)(((char *)&pSMB->hdr.Protocol) + offset);
+       /* Setup pointer to Request Data (inode type).
+        * Note that SMB offsets are from the beginning of SMB which is 4 bytes
+        * in, after RFC1001 field
+        */
+       pRqD = (struct unlink_psx_rq *)((char *)(pSMB) + offset + 4);
        pRqD->type = cpu_to_le16(type);
        pSMB->ParameterOffset = cpu_to_le16(param_offset);
        pSMB->DataOffset = cpu_to_le16(offset);


-- 
Thanks,

Steve

--000000000000c9baac05c7bb7ae7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Clarify-SMB1-code-for-POSIX-delete-file.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Clarify-SMB1-code-for-POSIX-delete-file.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_krfblzp40>
X-Attachment-Id: f_krfblzp40

RnJvbSA3YjA5ZDRlMGJlOTQ5NjhiN2M2YzExN2UzNGNhOTBjZWE5YzZkOTg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjIgSnVsIDIwMjEgMTQ6MzU6MTUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBD
SUZTOiBDbGFyaWZ5IFNNQjEgY29kZSBmb3IgUE9TSVggZGVsZXRlIGZpbGUKCkNvdmVyaXR5IGFs
c28gY29tcGxhaW5zIGFib3V0IHRoZSB3YXkgd2UgY2FsY3VsYXRlIHRoZSBvZmZzZXQKKHN0YXJ0
aW5nIGZyb20gdGhlIGFkZHJlc3Mgb2YgYSA0IGJ5dGUgYXJyYXkgd2l0aGluIHRoZQpoZWFkZXIg
c3RydWN0dXJlIHJhdGhlciB0aGFuIGZyb20gdGhlIGJlZ2lubmluZyBvZiB0aGUgc3RydWN0CnBs
dXMgNCBieXRlcykgZm9yIFNNQjEgQ0lGU1BPU0lYRGVsRmlsZS4gVGhpcyBjaGFuZ2VzZXQKZG9l
c24ndCBjaGFuZ2UgdGhlIGFkZHJlc3MgYnV0IG1ha2VzIGl0IHNsaWdodGx5IGNsZWFyZXIuCgpB
ZGRyZXNzZXMtQ292ZXJpdHk6IDcxMTUxOSAoIk91dCBvZiBib3VuZHMgd3JpdGUiKQpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lm
cy9jaWZzc21iLmMgfCA3ICsrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzc21iLmMgYi9mcy9jaWZz
L2NpZnNzbWIuYwppbmRleCBkNDE0NGMxODI2MDQuLjY1ZDFhNjViZmMzNyAxMDA2NDQKLS0tIGEv
ZnMvY2lmcy9jaWZzc21iLmMKKysrIGIvZnMvY2lmcy9jaWZzc21iLmMKQEAgLTg3Myw4ICs4NzMs
MTEgQEAgQ0lGU1BPU0lYRGVsRmlsZShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLAogCQkJCUluZm9ybWF0aW9uTGV2ZWwpIC0gNDsKIAlvZmZzZXQgPSBwYXJh
bV9vZmZzZXQgKyBwYXJhbXM7CiAKLQkvKiBTZXR1cCBwb2ludGVyIHRvIFJlcXVlc3QgRGF0YSAo
aW5vZGUgdHlwZSkgKi8KLQlwUnFEID0gKHN0cnVjdCB1bmxpbmtfcHN4X3JxICopKCgoY2hhciAq
KSZwU01CLT5oZHIuUHJvdG9jb2wpICsgb2Zmc2V0KTsKKwkvKiBTZXR1cCBwb2ludGVyIHRvIFJl
cXVlc3QgRGF0YSAoaW5vZGUgdHlwZSkuCisJICogTm90ZSB0aGF0IFNNQiBvZmZzZXRzIGFyZSBm
cm9tIHRoZSBiZWdpbm5pbmcgb2YgU01CIHdoaWNoIGlzIDQgYnl0ZXMKKwkgKiBpbiwgYWZ0ZXIg
UkZDMTAwMSBmaWVsZAorCSAqLworCXBScUQgPSAoc3RydWN0IHVubGlua19wc3hfcnEgKikoKGNo
YXIgKikocFNNQikgKyBvZmZzZXQgKyA0KTsKIAlwUnFELT50eXBlID0gY3B1X3RvX2xlMTYodHlw
ZSk7CiAJcFNNQi0+UGFyYW1ldGVyT2Zmc2V0ID0gY3B1X3RvX2xlMTYocGFyYW1fb2Zmc2V0KTsK
IAlwU01CLT5EYXRhT2Zmc2V0ID0gY3B1X3RvX2xlMTYob2Zmc2V0KTsKLS0gCjIuMzAuMgoK
--000000000000c9baac05c7bb7ae7--
