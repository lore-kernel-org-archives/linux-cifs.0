Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BCFC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 22 May 2022 05:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiEVFrQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 May 2022 01:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbiEVFrP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 May 2022 01:47:15 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B90B3AA79
        for <linux-cifs@vger.kernel.org>; Sat, 21 May 2022 22:47:12 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id p4so19149094lfg.4
        for <linux-cifs@vger.kernel.org>; Sat, 21 May 2022 22:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=uyjYxEVvx39n6G7aDyqQEIHvxLR3HMfTdiZTXIr8Aiw=;
        b=DbTf5TcMiNLtCuMFizUilEe0gxfGpU/9lc8Je8MbXXLKO4Nq4Np3RE04v0yhI1tbXj
         5ZeNLPVVt3cs4Sz1SuXgq0WgXOD8GlYsBgzn38Sr4ayWzyoA/mvd0Tf9tJ/A2BkSDKrT
         TYl9rPQnpaOMUo/oBVIVhbh/krarU4QINyQgRsFuNFkiGkoYBOdaV93gQRxYQ5vzp9Sq
         ywQfoos5IbMS7VzcpnIfp9q7huqrWaOY9AQL5XIHTtmMKDOCR8OCEHx+R4yQAZH0hoNT
         YXR6EgvqLr83pKE1KPhVe1xzD2WoTPICad4bmVnwDjea7AmpUT/tmARhmJO3h91Blmkn
         DEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=uyjYxEVvx39n6G7aDyqQEIHvxLR3HMfTdiZTXIr8Aiw=;
        b=DpXFQH4ihxTrdFOgyaBrTV9b55oDTY2FEtrFumqPrje9yOobS0GaWNj62kykPS/xO8
         WXFE5+YxXh6Bv+nJGRiRNp1NW6t+8AbRGVjRUv1VVXa9qhgjukobNjr39ZXjEcLRESc8
         AVmeoqOBtFWR5mzvar8lWUf+7V5OBcUXuCrhotf62kzjv0zKe0mUHs25m9J4T6bmwkN2
         3kGgIeAnsWhIXUnBe8B0OdVXY8T9xVb6FB9geDT512zCqlX9ud8eNV7ifUFTopmqfbwp
         u1tEpqeZG5kJyNMoAtRRM4zTHSPl0fYU0eb3l7SVFFWNKtXOHQqRUd2Nnsvro8h4ErTC
         22NA==
X-Gm-Message-State: AOAM5326Q7FhzdadYAh7RGTJjJ5qWfODoXXRb5TxwJJfLLGpnnnsPhSd
        z29gxMdQ4HSE83CKA0QLP1TZG7339nth6QF0FOy+T0X1sTU=
X-Google-Smtp-Source: ABdhPJx2/mLCanAl7vWgGdHXZlXVOdUfPzK1Oc+Gq8Ey8afzrFb9jStVYNWSRNm9RRq7tmCm+NYiVfJHvwndJ7rqoHA=
X-Received: by 2002:a05:6512:1583:b0:477:cc34:4a6c with SMTP id
 bp3-20020a056512158300b00477cc344a6cmr9980868lfb.595.1653198430052; Sat, 21
 May 2022 22:47:10 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 22 May 2022 00:46:58 -0500
Message-ID: <CAH2r5ms+KeC7U4E0DnggAL587EHb45F-34-u4bVeqRR7o_GC4g@mail.gmail.com>
Subject: [PATCH][SMB2] Add tracepoint for oplock break file not found
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002ad15d05df9341b2"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002ad15d05df9341b2
Content-Type: text/plain; charset="UTF-8"

Similar to the earlier patch I sent out for lease not found, this patch handles
the oplock case

In order to debug problems with server potentially sending us an oplock
that we don't recognize (or a race with close and oplock break) it would
be helpful to have a dynamic trace point for this case.  New tracepoint
called trace_smb3_oplock_not_found


-- 
Thanks,

Steve

--0000000000002ad15d05df9341b2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-trace-point-for-oplock-not-found.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-trace-point-for-oplock-not-found.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3gvncm10>
X-Attachment-Id: f_l3gvncm10

RnJvbSBiMjMxYzVmNjhiOWZkYTQ0NjAyY2Q4ZTI2NmRiNmY0ZWI4ZjZkOGE3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMjIgTWF5IDIwMjIgMDA6NDE6NDEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgdHJhY2UgcG9pbnQgZm9yIG9wbG9jayBub3QgZm91bmQKCkluIG9yZGVyIHRvIGRl
YnVnIHByb2JsZW1zIHdpdGggc2VydmVyIHBvdGVudGlhbGx5CnNlbmRpbmcgdXMgYW4gb3Bsb2Nr
IHRoYXQgd2UgZG9uJ3QgcmVjb2duaXplIChvciBhIHJhY2UKd2l0aCBjbG9zZSBhbmQgb3Bsb2Nr
IGJyZWFrKSBpdCB3b3VsZCBiZSBoZWxwZnVsIHRvIGhhdmUKYSBkeW5hbWljIHRyYWNlIHBvaW50
IGZvciB0aGlzIGNhc2UuICBOZXcgdHJhY2Vwb2ludAppcyBjYWxsZWQgdHJhY2Vfc21iM19vcGxv
Y2tfbm90X2ZvdW5kCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jv
c29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIybWlzYy5jIHwgNCArKysrCiBmcy9jaWZzL3RyYWNl
LmggICAgfCAxICsKIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9zbWIybWlzYy5jIGIvZnMvY2lmcy9zbWIybWlzYy5jCmluZGV4IGYyMzZiZWFm
Zjk2ZC4uMTc4MTNjM2QwYzZlIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJtaXNjLmMKKysrIGIv
ZnMvY2lmcy9zbWIybWlzYy5jCkBAIC03MzIsNiArNzMyLDEwIEBAIHNtYjJfaXNfdmFsaWRfb3Bs
b2NrX2JyZWFrKGNoYXIgKmJ1ZmZlciwgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQog
CX0KIAlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCWNpZnNfZGJnKEZZSSwgIk5v
IGZpbGUgaWQgbWF0Y2hlZCwgb3Bsb2NrIGJyZWFrIGlnbm9yZWRcbiIpOworCXRyYWNlX3NtYjNf
b3Bsb2NrX25vdF9mb3VuZCgwIC8qIG5vIHhpZCAqLywgcnNwLT5QZXJzaXN0ZW50RmlkLAorCQkJ
CSAgbGUzMl90b19jcHUocnNwLT5oZHIuSWQuU3luY0lkLlRyZWVJZCksCisJCQkJICBsZTY0X3Rv
X2NwdShyc3AtPmhkci5TZXNzaW9uSWQpKTsKKwogCXJldHVybiB0cnVlOwogfQogCmRpZmYgLS1n
aXQgYS9mcy9jaWZzL3RyYWNlLmggYi9mcy9jaWZzL3RyYWNlLmgKaW5kZXggMDlkM2RmZWQ4NmQ5
Li4yYmU1ZTBjODU2NGQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJhY2UuaAorKysgYi9mcy9jaWZz
L3RyYWNlLmgKQEAgLTE1OCw2ICsxNTgsNyBAQCBERUZJTkVfU01CM19GRF9FVkVOVChmbHVzaF9l
bnRlcik7CiBERUZJTkVfU01CM19GRF9FVkVOVChmbHVzaF9kb25lKTsKIERFRklORV9TTUIzX0ZE
X0VWRU5UKGNsb3NlX2VudGVyKTsKIERFRklORV9TTUIzX0ZEX0VWRU5UKGNsb3NlX2RvbmUpOwor
REVGSU5FX1NNQjNfRkRfRVZFTlQob3Bsb2NrX25vdF9mb3VuZCk7CiAKIERFQ0xBUkVfRVZFTlRf
Q0xBU1Moc21iM19mZF9lcnJfY2xhc3MsCiAJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKLS0g
CjIuMzQuMQoK
--0000000000002ad15d05df9341b2--
