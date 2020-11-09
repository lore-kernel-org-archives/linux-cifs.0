Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAD1C2D0A3
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 17:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E1EB20665
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 17:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3TCyAbo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgKIRqw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Nov 2020 12:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgKIRqw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Nov 2020 12:46:52 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8995CC0613CF
        for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2020 09:46:52 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id i193so8994601yba.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2020 09:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=o9dinhhD1mE/dChK4CM7kxTxUMTWu8V9GMC+qYwUhqM=;
        b=l3TCyAboIKTyohSwriFSCrcBmnW8RqfNqB7dadTUG82WMf7iQglivuyrPqTn79jKjv
         /lvX5bA3sZBATlYubnK3NMx0ZcHrz7h2tW+HZqCMT6kKCpxPuyCQDDxZ4VHnBnmFTUNz
         90uRZZqDNwn4OlQrV1zFk/9YpXBz+9WShnBIL7Txc/dEE9aRvn/FRfpR1nZrkcEcNr5b
         H37fPXEMm7CV4ZXjs5KLTcWJsVhbMFx/cnYs35/o7dOBWAzTLxe3uhQcrBRq7Cw0+t/Q
         8y0VZgbPdjxv52szizn+302QDo/a5xOf09TzuIty5nimm/riuoECaHWs68tCI1DEPOxn
         Omrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=o9dinhhD1mE/dChK4CM7kxTxUMTWu8V9GMC+qYwUhqM=;
        b=W0Xh3QAoJH2PPTUrnEqJZV+gMIbK6eyKO4iWgC9+WGM6LPJuh1VdhWKcPKSDkvU/dA
         MPfOoAobe8rHylHM60OXI+oU2gImxQbbvPWGxqxh9OZKDZWEAU6nD9lRvgW/X0eWjUrf
         tjegBiVlfejCZvYvbx172OrNF0uWCOaZZs3evAPUdqOZ95qPDpSRxbOlUpRAV+czTrU6
         ZkAWwtOUDFeRe7MO9Y3DwsCJTkd1BGzNKpjFXuzAsDYZoxFRF4xDm3KF0EcWFJKxnZse
         FhS3xrk23DVjcxgUxp1UmU9tmyh1iGvoJeuGaMgIDN8BuaW0XCrbV0rk01H3L8VGW1lX
         gVYw==
X-Gm-Message-State: AOAM533QizESqH/eiZAPONIkYqj7wN+fsP5oVfz0z2rkZUDa0XpUrFtG
        m+hSiR/xToInmrutXJNJIrmoywMoInkdAKx0HWc=
X-Google-Smtp-Source: ABdhPJxa3b+NT1BPPTdTrrrV68kDBWNoAGvAuiQBHXE/xoNVhtXPw2cYv/Ch0HnBHtFsE6tesyq35J13IdZD35G6314=
X-Received: by 2002:a25:b7cf:: with SMTP id u15mr21228372ybj.34.1604944011811;
 Mon, 09 Nov 2020 09:46:51 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=r-okF50zXNU8wnqv-mUUwAcGTyZ1_6YumQb_tY94LmFw@mail.gmail.com>
In-Reply-To: <CANT5p=r-okF50zXNU8wnqv-mUUwAcGTyZ1_6YumQb_tY94LmFw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 9 Nov 2020 23:16:41 +0530
Message-ID: <CANT5p=rHYSaYNiv4OUi_5vj4S_XH_vJmbVPFPAyTFBxvCgwGVw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: Fix unix perm bits to cifsacl conversion for
 "other" bits.
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b5b71505b3b02565"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b5b71505b3b02565
Content-Type: text/plain; charset="UTF-8"

Also attaching the sticky bit implementation.
Have tested out some positive and negative test cases too. Works well,
from what I can tell.

Regards,
Shyam

On Mon, Nov 9, 2020 at 11:12 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> Here's the patch as per the discussion. I'm trying to maintain a
> preferred order of ACEs as much as possible. I had to modify the
> reverse conversion logic, since deny ACEs can appear in the middle of
> the list now.
>
> Tested thoroughly with many permission modes, conversions and reverse
> conversions.
>
> FYI, there's a sticky bit implementation which I've patched on top of
> this fix. Will send that for review soon.
>
> --
> -Shyam



-- 
-Shyam

--000000000000b5b71505b3b02565
Content-Type: application/octet-stream; 
	name="0001-cifs-Enable-sticky-bit-with-cifsacl-mount-option.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Enable-sticky-bit-with-cifsacl-mount-option.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_khau3p9n0>
X-Attachment-Id: f_khau3p9n0

RnJvbSBiZjA5YmQwZjFhNDNkY2VlN2FjZmE3MzY1MDBmYjg3OGZhZDY2MjA2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBNb24sIDkgTm92IDIwMjAgMDY6MTI6NDkgLTA4MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBFbmFibGUgc3RpY2t5IGJpdCB3aXRoIGNpZnNhY2wgbW91bnQgb3B0aW9uLgoKRm9yIHRo
ZSBjaWZzYWNsIG1vdW50IG9wdGlvbiwgd2UgZGlkIG5vdCBzdXBwb3J0IHN0aWNreSBiaXRzLgpX
aXRoIHRoaXMgcGF0Y2gsIHdlIGRvIHN1cHBvcnQgaXQsIGJ5IHNldHRpbmcgdGhlIERFTEVURV9D
SElMRCBwZXJtCm9uIHRoZSBkaXJlY3Rvcnkgb25seSBmb3IgdGhlIG93bmVyIHVzZXIuIFdoZW4g
c3RpY2t5IGJpdCBpcyBub3QKZW5hYmxlZCwgYWxsb3cgREVMRVRFX0NISUxEIHBlcm0gZm9yIGV2
ZXJ5b25lLgoKU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNhY2wuYyB8IDQxICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tCiBmcy9jaWZzL2NpZnNhY2wuaCB8ICA0ICsrKysKIGZzL2NpZnMv
Y2lmc3BkdS5oIHwgIDIgKy0KIDMgZmlsZXMgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgMTIg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzYWNsLmMgYi9mcy9jaWZzL2Np
ZnNhY2wuYwppbmRleCBhODI4MzczYzFlZmYuLmRlMDZmMDQ0YmYxMyAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9jaWZzYWNsLmMKKysrIGIvZnMvY2lmcy9jaWZzYWNsLmMKQEAgLTYxNyw2ICs2MTcsMTcg
QEAgc3RhdGljIHZvaWQgYWNjZXNzX2ZsYWdzX3RvX21vZGUoX19sZTMyIGFjZV9mbGFncywgaW50
IHR5cGUsIHVtb2RlX3QgKnBtb2RlLAogCQkJISgqcGRlbmllZCAmIG1hc2sgJiAwMTExKSkKIAkJ
KnBtb2RlIHw9IG1hc2sgJiAwMTExOwogCisJLyogSWYgREVMRVRFX0NISUxEIGlzIHNldCBvbmx5
IG9uIGFuIG93bmVyIEFDRSwgc2V0IHN0aWNreSBiaXQgKi8KKwlpZiAoZmxhZ3MgJiBGSUxFX0RF
TEVURV9DSElMRCkgeworCQlpZiAobWFzayA9PSBBQ0xfT1dORVJfTUFTSykgeworCQkJaWYgKCEo
KnBkZW5pZWQgJiAwMTAwMCkpCisJCQkJKnBtb2RlIHw9IDAxMDAwOworCQl9IGVsc2UgaWYgKCEo
KnBkZW5pZWQgJiAwMTAwMCkpIHsKKwkJCSpwbW9kZSAmPSB+MDEwMDA7CisJCQkqcGRlbmllZCB8
PSAwMTAwMDsKKwkJfQorCX0KKwogCWNpZnNfZGJnKE5PSVNZLCAiYWNjZXNzIGZsYWdzIDB4JXgg
bW9kZSBub3cgJTA0b1xuIiwgZmxhZ3MsICpwbW9kZSk7CiAJcmV0dXJuOwogfQpAQCAtNjUyLDcg
KzY2Myw5IEBAIHN0YXRpYyB2b2lkIG1vZGVfdG9fYWNjZXNzX2ZsYWdzKHVtb2RlX3QgbW9kZSwg
dW1vZGVfdCBiaXRzX3RvX3VzZSwKIH0KIAogc3RhdGljIF9fdTE2IGZpbGxfYWNlX2Zvcl9zaWQo
c3RydWN0IGNpZnNfYWNlICpwbnRhY2UsCi0JCQljb25zdCBzdHJ1Y3QgY2lmc19zaWQgKnBzaWQs
IF9fdTY0IG5tb2RlLCB1bW9kZV90IGJpdHMsIF9fdTggYWNjZXNzX3R5cGUpCisJCQljb25zdCBz
dHJ1Y3QgY2lmc19zaWQgKnBzaWQsIF9fdTY0IG5tb2RlLAorCQkJdW1vZGVfdCBiaXRzLCBfX3U4
IGFjY2Vzc190eXBlLAorCQkJYm9vbCBhbGxvd19kZWxldGVfY2hpbGQpCiB7CiAJaW50IGk7CiAJ
X191MTYgc2l6ZSA9IDA7CkBAIC02NjEsMTAgKzY3NCwxNSBAQCBzdGF0aWMgX191MTYgZmlsbF9h
Y2VfZm9yX3NpZChzdHJ1Y3QgY2lmc19hY2UgKnBudGFjZSwKIAlwbnRhY2UtPnR5cGUgPSBhY2Nl
c3NfdHlwZTsKIAlwbnRhY2UtPmZsYWdzID0gMHgwOwogCW1vZGVfdG9fYWNjZXNzX2ZsYWdzKG5t
b2RlLCBiaXRzLCAmYWNjZXNzX3JlcSk7CisKKwlpZiAoYWNjZXNzX3R5cGUgPT0gQUNDRVNTX0FM
TE9XRUQgJiYgYWxsb3dfZGVsZXRlX2NoaWxkKQorCQlhY2Nlc3NfcmVxIHw9IEZJTEVfREVMRVRF
X0NISUxEOworCiAJaWYgKGFjY2Vzc190eXBlID09IEFDQ0VTU19BTExPV0VEICYmICFhY2Nlc3Nf
cmVxKQogCQlhY2Nlc3NfcmVxID0gU0VUX01JTklNVU1fUklHSFRTOwogCWVsc2UgaWYgKGFjY2Vz
c190eXBlID09IEFDQ0VTU19ERU5JRUQpCiAJCWFjY2Vzc19yZXEgJj0gflNFVF9NSU5JTVVNX1JJ
R0hUUzsKKwogCXBudGFjZS0+YWNjZXNzX3JlcSA9IGNwdV90b19sZTMyKGFjY2Vzc19yZXEpOwog
CiAJcG50YWNlLT5zaWQucmV2aXNpb24gPSBwc2lkLT5yZXZpc2lvbjsKQEAgLTcxNywxMCArNzM1
LDYgQEAgc3RhdGljIHZvaWQgZHVtcF9hY2Uoc3RydWN0IGNpZnNfYWNlICpwYWNlLCBjaGFyICpl
bmRfb2ZfYWNsKQogfQogI2VuZGlmCiAKLSNkZWZpbmUgQUNMX09XTkVSX01BU0sgMDcwMAotI2Rl
ZmluZSBBQ0xfR1JPVVBfTUFTSyAwNzcwCi0jZGVmaW5lIEFDTF9FVkVSWU9ORV9NQVNLIDA3NzcK
LQogc3RhdGljIHZvaWQgcGFyc2VfZGFjbChzdHJ1Y3QgY2lmc19hY2wgKnBkYWNsLCBjaGFyICpl
bmRfb2ZfYWNsLAogCQkgICAgICAgc3RydWN0IGNpZnNfc2lkICpwb3duZXJzaWQsIHN0cnVjdCBj
aWZzX3NpZCAqcGdycHNpZCwKIAkJICAgICAgIHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0ciwgYm9v
bCBtb2RlX2Zyb21fc3BlY2lhbF9zaWQpCkBAIC05MDQsNiArOTE4LDcgQEAgc3RhdGljIGludCBz
ZXRfY2htb2RfZGFjbChzdHJ1Y3QgY2lmc19hY2wgKnBuZGFjbCwgc3RydWN0IGNpZnNfc2lkICpw
b3duZXJzaWQsCiAJX191NjQgb3RoZXJfbW9kZTsKIAlfX3U2NCBkZW55X3VzZXJfbW9kZSA9IDA7
CiAJX191NjQgZGVueV9ncm91cF9tb2RlID0gMDsKKwlib29sIHN0aWNreV9zZXQgPSBmYWxzZTsK
IAogCXBubmRhY2wgPSAoc3RydWN0IGNpZnNfYWNsICopKChjaGFyICopcG5kYWNsICsgc2l6ZW9m
KHN0cnVjdCBjaWZzX2FjbCkpOwogCkBAIC05NDQsMzEgKzk1OSwzNSBAQCBzdGF0aWMgaW50IHNl
dF9jaG1vZF9kYWNsKHN0cnVjdCBjaWZzX2FjbCAqcG5kYWNsLCBzdHJ1Y3QgY2lmc19zaWQgKnBv
d25lcnNpZCwKIAogCSpwbm1vZGUgPSB1c2VyX21vZGUgfCBncm91cF9tb2RlIHwgb3RoZXJfbW9k
ZSB8IChubW9kZSAmIH4wNzc3KTsKIAorCS8qIFRoaXMgdGVsbHMgaWYgd2Ugc2hvdWxkIGFsbG93
IGRlbGV0ZSBjaGlsZCBmb3IgZ3JvdXAgYW5kIGV2ZXJ5b25lLiAqLworCWlmIChubW9kZSAmIDAx
MDAwKQorCQlzdGlja3lfc2V0ID0gdHJ1ZTsKKwogCWlmIChkZW55X3VzZXJfbW9kZSkgewogCQlz
aXplICs9IGZpbGxfYWNlX2Zvcl9zaWQoKHN0cnVjdCBjaWZzX2FjZSAqKSgoY2hhciAqKXBubmRh
Y2wgKyBzaXplKSwKLQkJCQlwb3duZXJzaWQsIGRlbnlfdXNlcl9tb2RlLCAwNzAwLCBBQ0NFU1Nf
REVOSUVEKTsKKwkJCQlwb3duZXJzaWQsIGRlbnlfdXNlcl9tb2RlLCAwNzAwLCBBQ0NFU1NfREVO
SUVELCBmYWxzZSk7CiAJCW51bV9hY2VzKys7CiAJfQogCS8qIEdyb3VwIERFTlkgQUNFIGRvZXMg
bm90IGNvbmZsaWN0IHdpdGggb3duZXIgQUxMT1cgQUNFLiBLZWVwIGluIHByZWZlcnJlZCBvcmRl
ciovCiAJaWYgKGRlbnlfZ3JvdXBfbW9kZSAmJiAhKGRlbnlfZ3JvdXBfbW9kZSAmICh1c2VyX21v
ZGUgPj4gMykpKSB7CiAJCXNpemUgKz0gZmlsbF9hY2VfZm9yX3NpZCgoc3RydWN0IGNpZnNfYWNl
ICopKChjaGFyICopcG5uZGFjbCArIHNpemUpLAotCQkJCXBncnBzaWQsIGRlbnlfZ3JvdXBfbW9k
ZSwgMDA3MCwgQUNDRVNTX0RFTklFRCk7CisJCQkJcGdycHNpZCwgZGVueV9ncm91cF9tb2RlLCAw
MDcwLCBBQ0NFU1NfREVOSUVELCBmYWxzZSk7CiAJCW51bV9hY2VzKys7CiAJfQogCXNpemUgKz0g
ZmlsbF9hY2VfZm9yX3NpZCgoc3RydWN0IGNpZnNfYWNlICopICgoY2hhciAqKXBubmRhY2wgKyBz
aXplKSwKLQkJCXBvd25lcnNpZCwgdXNlcl9tb2RlLCAwNzAwLCBBQ0NFU1NfQUxMT1dFRCk7CisJ
CQlwb3duZXJzaWQsIHVzZXJfbW9kZSwgMDcwMCwgQUNDRVNTX0FMTE9XRUQsIHRydWUpOwogCW51
bV9hY2VzKys7CiAJLyogR3JvdXAgREVOWSBBQ0UgY29uZmxpY3RzIHdpdGggb3duZXIgQUxMT1cg
QUNFLiBTbyBrZWVwIGl0IGFmdGVyLiAqLwogCWlmIChkZW55X2dyb3VwX21vZGUgJiYgKGRlbnlf
Z3JvdXBfbW9kZSAmICh1c2VyX21vZGUgPj4gMykpKSB7CiAJCXNpemUgKz0gZmlsbF9hY2VfZm9y
X3NpZCgoc3RydWN0IGNpZnNfYWNlICopKChjaGFyICopcG5uZGFjbCArIHNpemUpLAotCQkJCXBn
cnBzaWQsIGRlbnlfZ3JvdXBfbW9kZSwgMDA3MCwgQUNDRVNTX0RFTklFRCk7CisJCQkJcGdycHNp
ZCwgZGVueV9ncm91cF9tb2RlLCAwMDcwLCBBQ0NFU1NfREVOSUVELCBmYWxzZSk7CiAJCW51bV9h
Y2VzKys7CiAJfQogCXNpemUgKz0gZmlsbF9hY2VfZm9yX3NpZCgoc3RydWN0IGNpZnNfYWNlICop
KChjaGFyICopcG5uZGFjbCArIHNpemUpLAotCQkJcGdycHNpZCwgZ3JvdXBfbW9kZSwgMDA3MCwg
QUNDRVNTX0FMTE9XRUQpOworCQkJcGdycHNpZCwgZ3JvdXBfbW9kZSwgMDA3MCwgQUNDRVNTX0FM
TE9XRUQsICFzdGlja3lfc2V0KTsKIAludW1fYWNlcysrOwogCXNpemUgKz0gZmlsbF9hY2VfZm9y
X3NpZCgoc3RydWN0IGNpZnNfYWNlICopKChjaGFyICopcG5uZGFjbCArIHNpemUpLAotCQkJJnNp
ZF9ldmVyeW9uZSwgb3RoZXJfbW9kZSwgMDAwNywgQUNDRVNTX0FMTE9XRUQpOworCQkJJnNpZF9l
dmVyeW9uZSwgb3RoZXJfbW9kZSwgMDAwNywgQUNDRVNTX0FMTE9XRUQsICFzdGlja3lfc2V0KTsK
IAludW1fYWNlcysrOwogCiBzZXRfc2l6ZToKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2FjbC5o
IGIvZnMvY2lmcy9jaWZzYWNsLmgKaW5kZXggNDU2NjVmZjg3YjY0Li5mZjdmZDA4NjJlMjggMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2FjbC5oCisrKyBiL2ZzL2NpZnMvY2lmc2FjbC5oCkBAIC0z
MCw2ICszMCwxMCBAQAogI2RlZmluZSBXUklURV9CSVQgICAgICAgMHgyCiAjZGVmaW5lIEVYRUNf
QklUICAgICAgICAweDEKIAorI2RlZmluZSBBQ0xfT1dORVJfTUFTSyAwNzAwCisjZGVmaW5lIEFD
TF9HUk9VUF9NQVNLIDA3NzAKKyNkZWZpbmUgQUNMX0VWRVJZT05FX01BU0sgMDc3NworCiAjZGVm
aW5lIFVCSVRTSElGVAk2CiAjZGVmaW5lIEdCSVRTSElGVAkzCiAKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvY2lmc3BkdS5oIGIvZnMvY2lmcy9jaWZzcGR1LmgKaW5kZXggNTkzZDgyNjgyMGMzLi5jZTUx
MTgzZWNhZjQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3BkdS5oCisrKyBiL2ZzL2NpZnMvY2lm
c3BkdS5oCkBAIC0yNjIsNyArMjYyLDcgQEAKIAkJCQl8IFdSSVRFX09XTkVSIHwgU1lOQ0hST05J
WkUpCiAjZGVmaW5lIFNFVF9GSUxFX1dSSVRFX1JJR0hUUyAoRklMRV9XUklURV9EQVRBIHwgRklM
RV9BUFBFTkRfREFUQSBcCiAJCQkJfCBGSUxFX1JFQURfRUEgfCBGSUxFX1dSSVRFX0VBIFwKLQkJ
CQl8IEZJTEVfREVMRVRFX0NISUxEIHwgRklMRV9SRUFEX0FUVFJJQlVURVMgXAorCQkJCXwgRklM
RV9SRUFEX0FUVFJJQlVURVMgXAogCQkJCXwgRklMRV9XUklURV9BVFRSSUJVVEVTIFwKIAkJCQl8
IERFTEVURSB8IFJFQURfQ09OVFJPTCB8IFdSSVRFX0RBQyBcCiAJCQkJfCBXUklURV9PV05FUiB8
IFNZTkNIUk9OSVpFKQotLSAKMi4yNS4xCgo=
--000000000000b5b71505b3b02565--
