Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7974BC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 03:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJCDyz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Oct 2022 23:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiJCDyx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Oct 2022 23:54:53 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9C1DFD4
        for <linux-cifs@vger.kernel.org>; Sun,  2 Oct 2022 20:54:51 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id x124so2027785vsb.13
        for <linux-cifs@vger.kernel.org>; Sun, 02 Oct 2022 20:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=zUXLzI+Hw4Bl3+pJAmtmgzITf6zZTSbdSsLgK2BKlCI=;
        b=QO54OzbGrfx45lGU+N6T6CXdH4OFuEQ2SYWKZih8ClgO6Z3u0l+/81zAX9bQTtvu2p
         5jbVHuhgxE+WD64FtCHtz/VsTBuX3ulgfz/wbrIFyQgDys8JVsd8WDbx/TYj29B4PBIV
         OfQ3G2E7RVLgYpvpMQh+zF1NDDhQqLW0N3v/CiuEMT2VyzelKHtYmOlX8ssj3C8ht9qw
         6+HwODfhTIksaz1O+zV83D8vFe5LuM2eC17DvMXwahx2VsA3LCCZHcWRhWgWG2/VyG5V
         9GfgmUu0M3eckLyiRtIJqeT1CeEZrzxARyrIQwlJoGci0U0qLRHkcAKkcNOAw162Y4nU
         BKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=zUXLzI+Hw4Bl3+pJAmtmgzITf6zZTSbdSsLgK2BKlCI=;
        b=NbO1ZSVGRlQXS8YOzm+xarE/0kbHKEXL2l7LHYcYl0X7K5jeFpsc6U1N1Iv478XMnF
         BI9WlHPOKpjiX1fqra6oBCQxHu5RXp7L3hwUwApL7TuJza0w6IOAj8qinzzH/X3TKmXK
         t9mYiqzJG0qoP2bHqXBZNYTenFiEhfCJQQj7Oo6c0KxE3dHBXe5CRU/BLC+DgVRN7CQK
         IPW55kK6OeH/dIcrVDUI1N6M/7IZzn1avjLotsXTTLI5CvHbjXXTjZebSdTOZCCC0dWE
         /02TZWnRwYBGg6m4Z4RgqxbUVEtV3TTxjkd9JI5r1Tv7J9GB1njCigqiS63Sn9XU/tYA
         /W0w==
X-Gm-Message-State: ACrzQf0vmpTnW+wNQg1qJ27wPZ62Xxd9wIxPCdI/SJphgl5blMX4oZOd
        QEFIGBfQelPB2G59tmtxUpJxDBdbJJht0dBiLnE=
X-Google-Smtp-Source: AMsMyM7NGjE4aheecK5MJpGmv5SRy0shTOlCinCAXzO1Ed+XdY4USQVT5kOBlliQyiKyZtotFbUUjwUj3Myua7iXJvU=
X-Received: by 2002:a67:f2d5:0:b0:3a6:5f77:86b5 with SMTP id
 a21-20020a67f2d5000000b003a65f7786b5mr1343815vsn.29.1664769290169; Sun, 02
 Oct 2022 20:54:50 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 2 Oct 2022 22:54:39 -0500
Message-ID: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
Subject: [PATCH][smb311 client] fix oops in smb3_calc_signature
To:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002c86f805ea194ec3"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002c86f805ea194ec3
Content-Type: text/plain; charset="UTF-8"

shash was not being initialized in one place in smb3_calc_signature

Suggested-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>

-- 
Thanks,

Steve

--0000000000002c86f805ea194ec3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-fix-oops-in-calculating-shash_setkey.patch"
Content-Disposition: attachment; 
	filename="0001-fix-oops-in-calculating-shash_setkey.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l8s8mg5x0>
X-Attachment-Id: f_l8s8mg5x0

RnJvbSA2NTE0NWE0YjNiNDQzNWE3MGMwMDYyYWY1YzZjZjIyNWIyNWU5YTVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMiBPY3QgMjAyMiAyMjowOTo0NSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGZp
eCBvb3BzIGluIGNhbGN1bGF0aW5nIHNoYXNoX3NldGtleQoKc2hhc2ggd2FzIG5vdCBiZWluZyBp
bml0aWFsaXplZCBpbiBvbmUgcGxhY2UgaW4gc21iM19jYWxjX3NpZ25hdHVyZQoKU3VnZ2VzdGVk
LWJ5OiBFbnpvIE1hdHN1bWl5YSA8ZW1hdHN1bWl5YUBzdXNlLmRlPgpTaWduZWQtb2ZmLWJ5OiBT
dGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIydHJh
bnNwb3J0LmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYyBiL2ZzL2NpZnMvc21i
MnRyYW5zcG9ydC5jCmluZGV4IGRmY2JjYzBiODZlNC4uNjRlMTJiMGE1YTNiIDEwMDY0NAotLS0g
YS9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYworKysgYi9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYwpA
QCAtNTM1LDcgKzUzNSw3IEBAIHNtYjNfY2FsY19zaWduYXR1cmUoc3RydWN0IHNtYl9ycXN0ICpy
cXN0LCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJdW5zaWduZWQgY2hhciAqc2ln
cHRyID0gc21iM19zaWduYXR1cmU7CiAJc3RydWN0IGt2ZWMgKmlvdiA9IHJxc3QtPnJxX2lvdjsK
IAlzdHJ1Y3Qgc21iMl9oZHIgKnNoZHIgPSAoc3RydWN0IHNtYjJfaGRyICopaW92WzBdLmlvdl9i
YXNlOwotCXN0cnVjdCBzaGFzaF9kZXNjICpzaGFzaDsKKwlzdHJ1Y3Qgc2hhc2hfZGVzYyAqc2hh
c2ggPSBOVUxMOwogCXN0cnVjdCBzbWJfcnFzdCBkcnFzdDsKIAl1OCBrZXlbU01CM19TSUdOX0tF
WV9TSVpFXTsKIAotLSAKMi4zNC4xCgo=
--0000000000002c86f805ea194ec3--
