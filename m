Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965F8EB64D9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Jun 2023 01:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjFTBwk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Jun 2023 21:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjFTBwj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Jun 2023 21:52:39 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706F5EE
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jun 2023 18:52:14 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2b47bfd4e45so21428611fa.0
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jun 2023 18:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687225932; x=1689817932;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YC/93DjrmC3fRBOjerb9X0hL/EiTAaZsce3gWolzdlg=;
        b=Bdz6TUovbUO/GmGQ6x1EXPfCX5+RbIi/MoBKuzlGB8Oc+FJMD7JbQj9dMEv72FlArA
         r6+O5cZcFWMp8Ry/F1eENq3+YoVSLmZNAxjQ6yaEtidluGraJvIqD1s7ay7fmE6sb+41
         FcLmskTRB7/HCfzBzqNBrTCfDiV+OEx6z8esEVicc311SVbBZUGz73X0crT11CIIBk12
         Q132Cv7v9bHDvLHvZjgBP8pacnCQgbsTIjuH2nzK5lbHEqTINWY2UYVrtwcVf9JyHHwl
         sib1HeDD9/XkXOLdX0URsGMuTp2b4IDrsISlcLCPpYEHx8Ocq0lIqYb48NaINcd8Yylw
         5nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687225932; x=1689817932;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YC/93DjrmC3fRBOjerb9X0hL/EiTAaZsce3gWolzdlg=;
        b=dT/CHwm46ImKtjIkAvIEqj8cnckrlEM+6JCsKABBCNLENLEKzpteORu12HFpmjVI/S
         CpzikIY4M5KyGtEbIGqBAeaGYFlHHCQ91wLD1pmPC+r6/9buu6bZDjZL8qHruWD93kqD
         +wbcdOxJfwgHYX3q73HjOBs1EafctmlqKQZWPnr4dm2ZAuGoeQhFCbFZTBhVjJGEE6yg
         jg+PjKnrbOm/wuPA+Zijcte6blKkdLczVa4WqV+QKN/kK7BSWfvxk3fGQwfhTwfAwpkW
         aDJEpMpff3ZSfkXiw6cFJiZYQRZdE9+CvgwxYEOVdtFfaDSywGb/nBHMfRiW5DDQiIX+
         vTjA==
X-Gm-Message-State: AC+VfDxVBRXQFn8+bzLfJr9ZKHJk+FBpVxHCDaMWAatmIxmIPM8Gr/EF
        g/vg4elzl+aLfFzjcMYLoT+5mQJn8+nt9O84ls5cgrT413E=
X-Google-Smtp-Source: ACHHUZ6dRqUQZu7HmyiAS05UD/eb1xnqsjemoB1feouSwN9ZQq5zmtGPMHlU72D9gi8Fq5ZDIVxe+xyIlasL+LnZgDc=
X-Received: by 2002:a2e:8395:0:b0:2b4:792d:a4a7 with SMTP id
 x21-20020a2e8395000000b002b4792da4a7mr2603657ljg.6.1687225932082; Mon, 19 Jun
 2023 18:52:12 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Jun 2023 20:52:00 -0500
Message-ID: <CAH2r5mvpS+XPMe_taXe7W8fc2GaG9eKVMXtUZQPg3AzY-QKdMg@mail.gmail.com>
Subject: [SMB CLIENT][PATCH] print more detail when invalide_inode_pages fails
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000005686ac05fe85e64c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005686ac05fe85e64c
Content-Type: text/plain; charset="UTF-8"

    We had seen cases where cifs_invalidate_mapping was logging:
       "Could not invalidate inode ..."
    if invalidate_inode_pages2 fails but this message does not show what
    the rc is.  Update the logged message to also log the return code.

    Suggested-by: Shyam Prasad N <sprasad@microsoft.com>

(see attached)

-- 
Thanks,

Steve

--0000000000005686ac05fe85e64c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-print-more-detail-when-invalidate_inode_mapping.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-print-more-detail-when-invalidate_inode_mapping.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lj3mq1s30>
X-Attachment-Id: f_lj3mq1s30

RnJvbSBiYmU0OTZhOWU1MGJmOTU4MjRhNjE5OWE0MzNlYmQxMjYyYjk1Y2ZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTkgSnVuIDIwMjMgMjA6NDU6MzMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBwcmludCBtb3JlIGRldGFpbCB3aGVuIGludmFsaWRhdGVfaW5vZGVfbWFwcGluZyBmYWls
cwoKV2UgaGFkIHNlZW4gY2FzZXMgd2hlcmUgY2lmc19pbnZhbGlkYXRlX21hcHBpbmcgd2FzIGxv
Z2dpbmc6CiAgICJDb3VsZCBub3QgaW52YWxpZGF0ZSBpbm9kZSAuLi4iCmlmIGludmFsaWRhdGVf
aW5vZGVfcGFnZXMyIGZhaWxzIGJ1dCB0aGlzIG1lc3NhZ2UgZG9lcyBub3Qgc2hvdyB3aGF0CnRo
ZSByYyBpcy4gIFVwZGF0ZSB0aGUgbG9nZ2VkIG1lc3NhZ2UgdG8gYWxzbyBsb2cgdGhlIHJldHVy
biBjb2RlLgoKU3VnZ2VzdGVkLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQu
Y29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
Ci0tLQogZnMvc21iL2NsaWVudC9pbm9kZS5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQv
aW5vZGUuYyBiL2ZzL3NtYi9jbGllbnQvaW5vZGUuYwppbmRleCAxMDg3YWM2MTA0YTkuLmMzZWVh
ZTA3ZTEzOSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9pbm9kZS5jCisrKyBiL2ZzL3NtYi9j
bGllbnQvaW5vZGUuYwpAQCAtMjM0NCw4ICsyMzQ0LDggQEAgY2lmc19pbnZhbGlkYXRlX21hcHBp
bmcoc3RydWN0IGlub2RlICppbm9kZSkKIAlpZiAoaW5vZGUtPmlfbWFwcGluZyAmJiBpbm9kZS0+
aV9tYXBwaW5nLT5ucnBhZ2VzICE9IDApIHsKIAkJcmMgPSBpbnZhbGlkYXRlX2lub2RlX3BhZ2Vz
Mihpbm9kZS0+aV9tYXBwaW5nKTsKIAkJaWYgKHJjKQotCQkJY2lmc19kYmcoVkZTLCAiJXM6IENv
dWxkIG5vdCBpbnZhbGlkYXRlIGlub2RlICVwXG4iLAotCQkJCSBfX2Z1bmNfXywgaW5vZGUpOwor
CQkJY2lmc19kYmcoVkZTLCAiJXM6IGludmFsaWRhdGUgaW5vZGUgJXAgZmFpbGVkIHdpdGggcmMg
JWRcbiIsCisJCQkJIF9fZnVuY19fLCBpbm9kZSwgcmMpOwogCX0KIAogCXJldHVybiByYzsKLS0g
CjIuMzQuMQoK
--0000000000005686ac05fe85e64c--
