Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F7F4C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 02:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbiEXCAb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 22:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiEXCA3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 22:00:29 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06949880E1
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 19:00:28 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id 68so9291534vse.11
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 19:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=edPdA60haplwpDiUrBxThlI9v7AIAgcIcDq6QFbgDcg=;
        b=aHzdYN6IQ5meGFCFD1V1+Pq+yTOLb8I0QBhESQWXv+nyucLPFzBmjsQ8t2i7EBoykY
         Wo8FWPPYmRPbftAAGKS0mC9b3fNBVNnzC1f6YQq+9eWbWEMMZ7tRfhyN6eJTKOyJvhyG
         X4oDHkhWqkvRHlu2Ly5+suXf1r3001ZQlAUiq5Wu0zCesF3Hlf2J0gEPI0e1oGPrI5Jc
         MUBJElJWgofq9oDLOLu3qflY5wBaoukZUOL8VUrzIluUpsW/MKD6W+rb0yzEki4oHhMB
         y+5Nlezd/W+ZA2AgopTUNd9/FBnF0EBks+rv39KHnZcX3sgGpt5QPtpSQaTf71IIyOx1
         cNXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=edPdA60haplwpDiUrBxThlI9v7AIAgcIcDq6QFbgDcg=;
        b=3ugT95NB4yREEE4Lro0Iah95itHMyKDzhUkhg9VJmApK523GeQ9uqIVz+R4VX2rNLH
         KmG3lfHcjcf1l5k2NrEccbw1IOTuxqzPyxdVIJst3+/oL5Ctyzkx0A4tydFnB890E71S
         iw6rpjErwUNeBBd2BpfJLsTGFaOnxutV8vlpa4OtnqJWzRAN2rAk5BUd+HUvRLO9L6uv
         YaS/inu8rDckbKRefAcXMBFUfmp1LfJOgMipqPqMNotpGYBX05MtaFWrgxA2+3lYrVNn
         KwGYQSjMoXvVSnA70kYSbm5SCnDtnATtzqNCtswZj+arTgRc4WteyWLfkXFu7sgSULjw
         Exbw==
X-Gm-Message-State: AOAM533/KbjJp1+Qn8R3wxb1frSTa6nZGOvSxy6HK7UOwly9+iKqWslB
        kXSb8buENFeB4+EQA/ydS0WMBp5bMihD5beaFu8=
X-Google-Smtp-Source: ABdhPJzZBHLhDfuf1qi0ydL063ZRrgQuxXwyBh6s54Zp/PlQYmqg2P8CNfSQSNYrQWT7LFF6TDllam8S3w6CFINQlE0=
X-Received: by 2002:a67:fe57:0:b0:335:ef50:1b94 with SMTP id
 m23-20020a67fe57000000b00335ef501b94mr8331090vsr.6.1653357627049; Mon, 23 May
 2022 19:00:27 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 23 May 2022 21:00:16 -0500
Message-ID: <CAH2r5mtJhnTEjv4dHN6Nf+oa1+k+W4hCMk_how3LdH+6BhMmcA@mail.gmail.com>
Subject: [SMB3][PATCHES] two patches for minor coverity warnings
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000000c26c705dfb85274"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000c26c705dfb85274
Content-Type: text/plain; charset="UTF-8"

Fixes for two minor Coverity warnings

-- 
Thanks,

Steve

--0000000000000c26c705dfb85274
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-smb3-don-t-set-rc-when-used-and-unneeded-in-query_in.patch"
Content-Disposition: attachment; 
	filename="0002-smb3-don-t-set-rc-when-used-and-unneeded-in-query_in.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3jifmac1>
X-Attachment-Id: f_l3jifmac1

RnJvbSBhNmJkZjk1ZWVlZTljOTlkNmE3YjEzOGFiNjgwNzZlZjBmOTY0OTI1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjMgTWF5IDIwMjIgMjA6NTQ6MDQgLTA1MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gICAgIHNtYjM6IGRvbid0IHNldCByYyB3aGVuIHVzZWQgYW5kIHVubmVlZGVkIGluCiBxdWVy
eV9pbmZvX2NvbXBvdW5kCgogICAgcmMgaXMgbm90IGNoZWNrZWQgc28gc2hvdWxkIG5vdCBiZSBz
ZXQgY29taW5nIGJhY2sgZnJvbSBvcGVuX2NhY2hlZF9kaXIKICAgICh0aGUgY2ZpZCBwb2ludGVy
IGlzIGNoZWNrZWQgaW5zdGVhZCB0byBzZWUgaWYgb3Blbl9jYWNoZWRfZGlyIGZhaWxlZCkKCiAg
ICBBZGRyZXNzZXMtQ292ZXJpdHk6IDE1MTgwMjEgKCJDb2RlIG1haW50YWluYWJpbGl0eSBpc3N1
ZXMgIChVTlVTRURfVkFMVUUpIikKICAgIFJldmlld2VkLWJ5OiBSb25uaWUgU2FobGJlcmcgPGxz
YWhsYmVyQHJlZGhhdC5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJl
bmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyb3BzLmMgfCAyICstCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9j
aWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IDBkN2ZlYjllNjA5ZS4uMjhk
MWViN2QwNmU5IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3Nt
YjJvcHMuYwpAQCAtMjcwMCw3ICsyNzAwLDcgQEAgc21iMl9xdWVyeV9pbmZvX2NvbXBvdW5kKGNv
bnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJbWVtc2V0KHJz
cF9pb3YsIDAsIHNpemVvZihyc3BfaW92KSk7CiAKIAlpZiAoIXN0cmNtcChwYXRoLCAiIikpCi0J
CXJjID0gb3Blbl9jYWNoZWRfZGlyKHhpZCwgdGNvbiwgcGF0aCwgY2lmc19zYiwgJmNmaWQpOwor
CQlvcGVuX2NhY2hlZF9kaXIoeGlkLCB0Y29uLCBwYXRoLCBjaWZzX3NiLCAmY2ZpZCk7IC8qIGNm
aWQgbnVsbCBpZiBmYWlsIHRvIG9wZW4gZGlyICovCiAKIAltZW1zZXQoJm9wZW5faW92LCAwLCBz
aXplb2Yob3Blbl9pb3YpKTsKIAlycXN0WzBdLnJxX2lvdiA9IG9wZW5faW92OwotLSAKMi4zNC4x
Cgo=
--0000000000000c26c705dfb85274
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-smb3-check-for-null-tcon.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-check-for-null-tcon.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3jifm9u0>
X-Attachment-Id: f_l3jifm9u0

RnJvbSBiYmRmNmNmNTZjODg4NDVmYjBiNzEzY2JmNWM2NjIzYzUzZmU0MGQ4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjMgTWF5IDIwMjIgMjA6NDI6MDMgLTA1MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gc21iMzogY2hlY2sgZm9yIG51bGwgdGNvbgoKQWx0aG91Z2ggdW5saWtlbHkgdG8gYmUgbnVs
bCwgaXQgaXMgY29uZnVzaW5nIHRvIHVzZSBhIHBvaW50ZXIKYmVmb3JlIGNoZWNraW5nIGZvciBp
dCB0byBiZSBudWxsIHNvIG1vdmUgdGhlIHVzZSBkb3duIGFmdGVyCm51bGwgY2hlY2suCgpBZGRy
ZXNzZXMtQ292ZXJpdHk6IDE1MTc1ODYgKCJOdWxsIHBvaW50ZXIgZGVyZWZlcmVuY2VzICAoUkVW
RVJTRV9JTlVMTCkiKQpSZXZpZXdlZC1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRo
YXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvY2lmcy9zbWIyb3BzLmMgfCA3ICsrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA1
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIy
b3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCBjYmU1NmVkMzU2OTQuLjBkN2ZlYjllNjA5
ZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMK
QEAgLTc2MCw4ICs3NjAsOCBAQCBpbnQgb3Blbl9jYWNoZWRfZGlyKHVuc2lnbmVkIGludCB4aWQs
IHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCXN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2Is
CiAJCXN0cnVjdCBjYWNoZWRfZmlkICoqY2ZpZCkKIHsKLQlzdHJ1Y3QgY2lmc19zZXMgKnNlcyA9
IHRjb24tPnNlczsKLQlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIgPSBzZXMtPnNlcnZl
cjsKKwlzdHJ1Y3QgY2lmc19zZXMgKnNlczsKKwlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2
ZXI7CiAJc3RydWN0IGNpZnNfb3Blbl9wYXJtcyBvcGFybXM7CiAJc3RydWN0IHNtYjJfY3JlYXRl
X3JzcCAqb19yc3AgPSBOVUxMOwogCXN0cnVjdCBzbWIyX3F1ZXJ5X2luZm9fcnNwICpxaV9yc3Ag
PSBOVUxMOwpAQCAtNzgwLDYgKzc4MCw5IEBAIGludCBvcGVuX2NhY2hlZF9kaXIodW5zaWduZWQg
aW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkgICAgaXNfc21iMV9zZXJ2ZXIodGNv
bi0+c2VzLT5zZXJ2ZXIpKQogCQlyZXR1cm4gLUVOT1RTVVBQOwogCisJc2VzID0gdGNvbi0+c2Vz
OworCXNlcnZlciA9IHNlcy0+c2VydmVyOworCiAJaWYgKGNpZnNfc2ItPnJvb3QgPT0gTlVMTCkK
IAkJcmV0dXJuIC1FTk9FTlQ7CiAKLS0gCjIuMzQuMQoK
--0000000000000c26c705dfb85274--
