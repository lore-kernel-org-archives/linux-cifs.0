Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE06C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 21:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F377C6135F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 21:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhHXVTf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 17:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhHXVTf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Aug 2021 17:19:35 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698ECC061757
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 14:18:50 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u16so33267574wrn.5
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 14:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=/ut4cq/KxBD7ywu4xHwT4BnJDn1f3xgIvy+bvlaN8+w=;
        b=IaiDXIj4+USno0sBUH1PF9/heZXiFLbEk/XR+EklDts3aiGT46W0t/ksjFYNgh1B36
         fZ/dssT636hldwkWxy3/qUYFNhi6n2MzG8sN3jk/O3dlu7+38ko9ekUh0/S9+i/RQSsb
         AM62yoA99tZEYksSsxa0dOC4tfOQnpWNsWr3TDOLVSPAk755KzvdrqTXKQy+3S85sOFu
         ie34l9nujQECQljox0Xyr6nZk2w7Nl37wie8ooxyIr65V7nfR6hRIt30X3OKoE8yYX1d
         j4YsYPKFA2RgexBXCqviMLwsuiUeKQCXT9yJN4kYA1G4uIzXNELTmAP3E/oCHPlntEX3
         Id8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=/ut4cq/KxBD7ywu4xHwT4BnJDn1f3xgIvy+bvlaN8+w=;
        b=NHUeKkLWue1SFBYKcM9kD4IYlKP+HBP17ELMw5Xm1nJxg4jBH6Pq6i2eVA3CHVHok4
         2fQDuTGoyQ72EPzCh4N4YD4dOp8HHcyv/HCYH314+7EmrCDODwe695UcouCpHoX45ZEV
         hfIRHY2E7NHQCszoeZY3FikzBbnXX5Dqj9HSofFjVyDQl3zUp4lmdoZPRdJjgwqtJn+I
         yYefNNjhDNOCUkqTZ5xtBjVBR5lf1+hQz89gbrE8cOi0wrZgGwsQQL5mZy4eqZKe+2w0
         2wuXfX5KrMaPMy8WxC2Rxtd/49W5U1CDl/fUUpqgZaU6x0L4yb/oOxuOeS58lQcRhjal
         ZToA==
X-Gm-Message-State: AOAM530Z3YrmIP/+5NDTf9po1RFKfKodDTlRNpvpRbIo+u8dXo5m5N+f
        jaG+wHPR3h/alLFS4hr1ZtFtG7uwaYFYNi/raO1kTjI/8Hk=
X-Google-Smtp-Source: ABdhPJy34HE51FwZyGSHhWhWsz3ztqrJfUL/uk7hjU2GgsiBzymkh84O+2iO52GReemgUMWLAEYWQDYehJjR0YYlazo=
X-Received: by 2002:adf:ed8d:: with SMTP id c13mr21606550wro.405.1629839928583;
 Tue, 24 Aug 2021 14:18:48 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 24 Aug 2021 16:18:37 -0500
Message-ID: <CAH2r5muXxAAYOUS6YOcu1P=D3-=AQkNkRb_BF+bufbeTZX9HSg@mail.gmail.com>
Subject: [PATCH] add cifs_common directory to MAINTAINERS file
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: multipart/mixed; boundary="000000000000fc1a9505ca54adfa"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000fc1a9505ca54adfa
Content-Type: text/plain; charset="UTF-8"

With some files moving into the cifs_common directory, we need
to add it to the CIFS entry in the MAINTAINERS file.

Suggested-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>


-- 
Thanks,

Steve

--000000000000fc1a9505ca54adfa
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-add-cifs_common-directory-to-MAINTAINERS-file.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-add-cifs_common-directory-to-MAINTAINERS-file.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ksqkl4id0>
X-Attachment-Id: f_ksqkl4id0

RnJvbSA3N2FmM2Y4YjU2MTZmMjNhODRlOWY3MTc5MTE5Zjk3ZDk5ZDI2NTViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjQgQXVnIDIwMjEgMTY6MTQ6NTMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBhZGQgY2lmc19jb21tb24gZGlyZWN0b3J5IHRvIE1BSU5UQUlORVJTIGZpbGUKCldpdGgg
c29tZSBmaWxlcyBtb3ZpbmcgaW50byB0aGUgY2lmc19jb21tb24gZGlyZWN0b3J5LCB3ZSBuZWVk
CnRvIGFkZCBpdCB0byB0aGUgQ0lGUyBlbnRyeSBpbiB0aGUgTUFJTlRBSU5FUlMgZmlsZS4KClN1
Z2dlc3RlZC1ieTogUGF1bG8gQWxjYW50YXJhIChTVVNFKSA8cGNAY2pyLm56PgpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogTUFJTlRBSU5F
UlMgfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL01B
SU5UQUlORVJTIGIvTUFJTlRBSU5FUlMKaW5kZXggYzZiOGE3MjBjMGJjLi5jMWQ4MDIzMmY5NDkg
MTAwNjQ0Ci0tLSBhL01BSU5UQUlORVJTCisrKyBiL01BSU5UQUlORVJTCkBAIC00NjI5LDYgKzQ2
MjksNyBAQCBXOglodHRwOi8vbGludXgtY2lmcy5zYW1iYS5vcmcvCiBUOglnaXQgZ2l0Oi8vZ2l0
LnNhbWJhLm9yZy9zZnJlbmNoL2NpZnMtMi42LmdpdAogRjoJRG9jdW1lbnRhdGlvbi9hZG1pbi1n
dWlkZS9jaWZzLwogRjoJZnMvY2lmcy8KK0Y6CWZzL2NpZnNfY29tbW9uLwogCiBDT01QQUNUUENJ
IEhPVFBMVUcgQ09SRQogTToJU2NvdHQgTXVycmF5IDxzY290dEBzcGl0ZWZ1bC5vcmc+Ci0tIAoy
LjMwLjIKCg==
--000000000000fc1a9505ca54adfa--
