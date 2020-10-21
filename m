Return-Path: <SRS0=ZNV/=D4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA269C4363D
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 04:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7404621D6C
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 04:03:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SA4hdklV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgJUEDo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Oct 2020 00:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgJUEDo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Oct 2020 00:03:44 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B20FC0613CE
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 21:03:44 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id c141so1114613lfg.5
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 21:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=NNk8LRssaqazn1wXk6uTM5muK8cWXjM1KrI2CzX5ITY=;
        b=SA4hdklVZTpZ13GcktHfxVVop4A/J/9h24QQNRz7dfss55GqxE3qYgFNAUxT6VHaya
         4Y6ueJiPS6uayhuiOLbcWIyEgVe6bT7TEgJ8awMaWKOYAnt3UKimAsjcLJVV05tpiNUu
         JOUF5+xR6FU4qHsMZRJ/K+Pn+dWc/vo3klhqeiRnNNJEwrNwh4eWC9sBXR4NGS4OoDzq
         rUtZuiGRl1K+oRHIxuMSd80trAHI3bnR3IDUd4Qh3OKIZzR0SEZNi24zzqt1hFIJQzA/
         JbR7RCo5JShp8efWFefyJeurNfI6VyMjzWeambCeOYVYP05ZimHroWkVgz2kB3vCKkNa
         WMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=NNk8LRssaqazn1wXk6uTM5muK8cWXjM1KrI2CzX5ITY=;
        b=MRboBuEDE3anvFSwqbftXas/2eekgQM94sw0/7j3sDY9lekWfYK9MgHaETvo5wsbfN
         vfkOXgLcoWNvNK/Nk5A2xLY19u+SMcmplnaRrRdw/cBkPvKb9b+k6xZz/iv21ngi3/6Q
         OUPABNCIoY1tA6t5/CJzMLv3GH/fvOJtotaOJzRxkWlr6bdsIh6sWTfCz/Xq8aSGXcCL
         RMCZGKTrxAmSbrYp2EVWecux+fH/r5RCCJOnHZGMTda6ZDxQX7xrwy3uV59mKYiDb/bx
         X7WPKZwPV9tkK9V/KoMRFu7eT7DVoeafuNFg9EUkALcWqutLFGC+ojbxcxhsudrpcfOw
         yXkA==
X-Gm-Message-State: AOAM530Gy3ci/ElSFFenGEJ41r5tnzUVBEzGylbAi45bHOw84jRGTLtW
        ur4BtSZ9fG7la1tAlnXW5wtrFDk6TPyM45/QefZI/iRqJKbpgQ==
X-Google-Smtp-Source: ABdhPJwnyzNztBeW809vxMgFmnm35Wkfcn55N99/KgenvjcmCbHeAPizsnekNxwMNfwvGMt5VJaxGEh6LxE2/X14azs=
X-Received: by 2002:a19:83c1:: with SMTP id f184mr364549lfd.97.1603253022188;
 Tue, 20 Oct 2020 21:03:42 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 20 Oct 2020 23:03:31 -0500
Message-ID: <CAH2r5mu2s3Fu+_mWTiXFp+JYTAWZZrPCDyDNtWAhit2DjB890g@mail.gmail.com>
Subject: [PATCH][SMB3] fix stat when special device file and mounted with modefromsid
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000df8dd105b2266e80"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000df8dd105b2266e80
Content-Type: text/plain; charset="UTF-8"

When mounting with modefromsid mount option, it was possible to
get the error on stat of a fifo or char or block device:
        "cannot stat <filename>: Operation not supported"

Special devices can be stored as reparse points by some servers
(e.g. Windows NFS server and when using the SMB3.1.1 POSIX
Extensions) but when the modefromsid mount option is used
the client attempts to get the ACL for the file which requires
opening with OPEN_REPARSE_POINT create option.



--
Thanks,

Steve

--000000000000df8dd105b2266e80
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-stat-when-special-device-file-and-mounted-w.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-stat-when-special-device-file-and-mounted-w.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgivfgvb0>
X-Attachment-Id: f_kgivfgvb0

RnJvbSBkZTNmZTE4NjYzODAxZGRlZDY5ODc0NDE2NjRjZDU0YjMyNzY3MDNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjAgT2N0IDIwMjAgMjI6NTM6NTcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggc3RhdCB3aGVuIHNwZWNpYWwgZGV2aWNlIGZpbGUgYW5kIG1vdW50ZWQgd2l0aAog
bW9kZWZyb21zaWQKCldoZW4gbW91bnRpbmcgd2l0aCBtb2RlZnJvbXNpZCBtb3VudCBvcHRpb24s
IGl0IHdhcyBwb3NzaWJsZSB0bwpnZXQgdGhlIGVycm9yIG9uIHN0YXQgb2YgYSBmaWZvIG9yIGNo
YXIgb3IgYmxvY2sgZGV2aWNlOgogICAgICAgICJjYW5ub3Qgc3RhdCA8ZmlsZW5hbWU+OiBPcGVy
YXRpb24gbm90IHN1cHBvcnRlZCIKClNwZWNpYWwgZGV2aWNlcyBjYW4gYmUgc3RvcmVkIGFzIHJl
cGFyc2UgcG9pbnRzIGJ5IHNvbWUgc2VydmVycwooZS5nLiBXaW5kb3dzIE5GUyBzZXJ2ZXIgYW5k
IHdoZW4gdXNpbmcgdGhlIFNNQjMuMS4xIFBPU0lYCkV4dGVuc2lvbnMpIGJ1dCB3aGVuIHRoZSBt
b2RlZnJvbXNpZCBtb3VudCBvcHRpb24gaXMgdXNlZAp0aGUgY2xpZW50IGF0dGVtcHRzIHRvIGdl
dCB0aGUgQUNMIGZvciB0aGUgZmlsZSB3aGljaCByZXF1aXJlcwpvcGVuaW5nIHdpdGggT1BFTl9S
RVBBUlNFX1BPSU5UIGNyZWF0ZSBvcHRpb24uCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyb3BzLmMgfCA2ICsrKysr
KwogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
c21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggMmMzY2ZiMmU4ZTcyLi43ZTNlZGNk
YTA1NGUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9w
cy5jCkBAIC0zMDk5LDYgKzMwOTksMTIgQEAgZ2V0X3NtYjJfYWNsX2J5X3BhdGgoc3RydWN0IGNp
ZnNfc2JfaW5mbyAqY2lmc19zYiwKIAogCXJjID0gU01CMl9vcGVuKHhpZCwgJm9wYXJtcywgdXRm
MTZfcGF0aCwgJm9wbG9jaywgTlVMTCwgTlVMTCwgTlVMTCwKIAkJICAgICAgIE5VTEwpOworCWlm
IChyYyA9PSAtRU9QTk9UU1VQUCkgeworCQlvcGFybXMuY3JlYXRlX29wdGlvbnMgfD0gT1BFTl9S
RVBBUlNFX1BPSU5UOworCQlyYyA9IFNNQjJfb3Blbih4aWQsICZvcGFybXMsIHV0ZjE2X3BhdGgs
ICZvcGxvY2ssIE5VTEwsIE5VTEwsCisJCQkJTlVMTCwgTlVMTCk7CisJCWNpZnNfZGJnKFZGUywg
Im9wZW4gcmV0cnkgcmMgJWRcbiIsIHJjKTsgLyogQkIgcmVtb3ZlbWUgKi8KKwl9CiAJa2ZyZWUo
dXRmMTZfcGF0aCk7CiAJaWYgKCFyYykgewogCQlyYyA9IFNNQjJfcXVlcnlfYWNsKHhpZCwgdGxp
bmtfdGNvbih0bGluayksIGZpZC5wZXJzaXN0ZW50X2ZpZCwKLS0gCjIuMjUuMQoK
--000000000000df8dd105b2266e80--
