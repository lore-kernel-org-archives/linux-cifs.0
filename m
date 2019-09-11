Return-Path: <SRS0=GFFJ=XG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A7EECDE20
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 05:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D87121D7B
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 05:13:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U1J323ZD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfIKFNh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Sep 2019 01:13:37 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:34522 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfIKFNg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Sep 2019 01:13:36 -0400
Received: by mail-io1-f47.google.com with SMTP id k13so27758445ioj.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Sep 2019 22:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=FRmIM+b4/ZgTTvQ1jHgYdMIfmSKHuW3c2p/QmLaG3M0=;
        b=U1J323ZDsdHeaG2nQLFfNrg9MNxcH5fbxSe999fcTHG6mXqk+M21S187TZJBIBD3eN
         Z9iaApYRXoAzgtRdoi66vrGXxqCVS4Pt+lmXUTRHaDy8msaMTDKzSLgy+jVWtwUeX7Rl
         bfZ5EyvINsFfhDDExj4YYGzwf0BK+oKrCCx4EfqsiIAqUyQuI7wA/fZlGKRSyYaLflfb
         qDM9GAvOekuTVQ1rh9x5oPZ50lwUxNPI1GwtbTe2Pj8eOtLdkmiJlK4Ca9r72S17aDHg
         9A36X0hq0t2gelbCyaLIleRoGRU/3pOKjzzdtntSZDm9ONc/mlrBNMUyarab8pbIJVoD
         bovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=FRmIM+b4/ZgTTvQ1jHgYdMIfmSKHuW3c2p/QmLaG3M0=;
        b=mNXOrUAxZGBg1extU8SKPH1kHXGYszGFL7ddKTn2XxdWVBRWQqMFamuaoE/pZaI6vM
         rmmdtQvjP7jypmvRdzQmGTSFczw+STEXAevJM6TZGY2FeqnGFjBYUU0aYQAPmru/cAiW
         nBtyS/3gmRxHdWn1Iq3s7cv2C68Vnof1YbVO6HsZxtUwu0781j+WqZ+iDnu4P17A6hvQ
         4yfIRMAtpqY/xBRgo06yjDm1ZFsJBqzdXa1itHez7hQhzIXw7SVd9ycVZcZ2kRhyI8W4
         wTgldbXKh8QZwPH0YqC974zWQicMQo0lMcHZTWjUaZXbK92ueLJak2U1VjIovYUk36gW
         9amw==
X-Gm-Message-State: APjAAAVoIbFpMA2X7EHdXn1Nn/9h6GN3VtJq/TdH24TkM1clH0icPSRY
        YZw9HLQ8YrD+MVFKJwEfDmQPd5gYCQVU2AvNOiNBIf14WRk=
X-Google-Smtp-Source: APXvYqzAs9QqBaRuj6o7AJr9zX3rltcnl5nlZ2AJnHTdAefREJEXOUYG7U1qHWlDSt0eQd0vyqWH4k7IBu4d76iyPQE=
X-Received: by 2002:a6b:9203:: with SMTP id u3mr7834366iod.3.1568178814209;
 Tue, 10 Sep 2019 22:13:34 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 11 Sep 2019 00:13:22 -0500
Message-ID: <CAH2r5mtFA5c5XxL6ohwyGqj=zPc0mUR1_VNvcMyhrZZJuwcBPA@mail.gmail.com>
Subject: [SMB3][PATCH] Fix share deleted and share recreated cases
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002a6b450592401506"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002a6b450592401506
Content-Type: text/plain; charset="UTF-8"

When a share is deleted, returning EIO is confusing and no useful
information is logged.  Improve the handling of this case by
at least logging a better error for this (and also mapping the error
differently to EREMCHG).  See e.g. the new messages that would be logged:

[55243.639530] server share \\192.168.1.219\scratch deleted
[55243.642568] CIFS VFS: \\192.168.1.219\scratch BAD_NETWORK_NAME:
\\192.168.1.219\scratch

In addition for the case where a share is deleted and then recreated
with the same name, have now fixed that so it works. This is sometimes
done for example, because the admin had to move a share to a different,
bigger local drive when a share is running low on space.

-- 
Thanks,

Steve

--0000000000002a6b450592401506
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-improve-handling-of-share-deleted-and-share-rec.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-improve-handling-of-share-deleted-and-share-rec.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0et60bx0>
X-Attachment-Id: f_k0et60bx0

RnJvbSA1YmNiMDcxN2Q0NWQ0MWJlMjc3NDFkMDA3MDgzNDFjNmU4MWU2ODBlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTEgU2VwIDIwMTkgMDA6MDc6MzYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBpbXByb3ZlIGhhbmRsaW5nIG9mIHNoYXJlIGRlbGV0ZWQgKGFuZCBzaGFyZSByZWNyZWF0
ZWQpCgpXaGVuIGEgc2hhcmUgaXMgZGVsZXRlZCwgcmV0dXJuaW5nIEVJTyBpcyBjb25mdXNpbmcg
YW5kIG5vIHVzZWZ1bAppbmZvcm1hdGlvbiBpcyBsb2dnZWQuICBJbXByb3ZlIHRoZSBoYW5kbGlu
ZyBvZiB0aGlzIGNhc2UgYnkKYXQgbGVhc3QgbG9nZ2luZyBhIGJldHRlciBlcnJvciBmb3IgdGhp
cyAoYW5kIGFsc28gbWFwcGluZyB0aGUgZXJyb3IKZGlmZmVyZW50bHkgdG8gRVJFTUNIRykuICBT
ZWUgZS5nLiB0aGUgbmV3IG1lc3NhZ2VzIHRoYXQgd291bGQgYmUgbG9nZ2VkOgoKWzU1MjQzLjYz
OTUzMF0gc2VydmVyIHNoYXJlIFxcMTkyLjE2OC4xLjIxOVxzY3JhdGNoIGRlbGV0ZWQKWzU1MjQz
LjY0MjU2OF0gQ0lGUyBWRlM6IFxcMTkyLjE2OC4xLjIxOVxzY3JhdGNoIEJBRF9ORVRXT1JLX05B
TUU6IFxcMTkyLjE2OC4xLjIxOVxzY3JhdGNoCgpJbiBhZGRpdGlvbiBmb3IgdGhlIGNhc2Ugd2hl
cmUgYSBzaGFyZSBpcyBkZWxldGVkIGFuZCB0aGVuIHJlY3JlYXRlZAp3aXRoIHRoZSBzYW1lIG5h
bWUsIGhhdmUgbm93IGZpeGVkIHRoYXQgc28gaXQgd29ya3MuIFRoaXMgaXMgc29tZXRpbWVzCmRv
bmUgZm9yIGV4YW1wbGUsIGJlY2F1c2UgdGhlIGFkbWluIGhhZCB0byBtb3ZlIGEgc2hhcmUgdG8g
YSBkaWZmZXJlbnQsCmJpZ2dlciBsb2NhbCBkcml2ZSB3aGVuIGEgc2hhcmUgaXMgcnVubmluZyBs
b3cgb24gc3BhY2UuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jv
c29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyaW5vZGUuYyAgICB8ICA2ICsrKysrKwogZnMvY2lm
cy9zbWIybWFwZXJyb3IuYyB8ICAyICstCiBmcy9jaWZzL3NtYjJvcHMuYyAgICAgIHwgMTMgKysr
KysrKysrKysrLQogZnMvY2lmcy9zbWIycGR1LmMgICAgICB8ICA1ICsrKysrCiA0IGZpbGVzIGNo
YW5nZWQsIDI0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy9zbWIyaW5vZGUuYyBiL2ZzL2NpZnMvc21iMmlub2RlLmMKaW5kZXggYzg2NjU1NWI2Mjc4
Li5kMmEzZmI3ZTVjOGQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMmlub2RlLmMKKysrIGIvZnMv
Y2lmcy9zbWIyaW5vZGUuYwpAQCAtMzM1LDYgKzMzNSwxMiBAQCBzbWIyX2NvbXBvdW5kX29wKGNv
bnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCWNpZnNGaWxl
SW5mb19wdXQoY2ZpbGUpOwogCiAJU01CMl9vcGVuX2ZyZWUoJnJxc3RbMF0pOworCWlmIChyYyA9
PSAtRVJFTUNIRykgeworCQlwcmludGtfb25jZShLRVJOX1dBUk5JTkcgInNlcnZlciBzaGFyZSAl
cyBkZWxldGVkXG4iLAorCQkJICAgIHRjb24tPnRyZWVOYW1lKTsKKwkJdGNvbi0+bmVlZF9yZWNv
bm5lY3QgPSB0cnVlOworCX0KKwogCXN3aXRjaCAoY29tbWFuZCkgewogCWNhc2UgU01CMl9PUF9R
VUVSWV9JTkZPOgogCQlpZiAocmMgPT0gMCkgewpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIybWFw
ZXJyb3IuYyBiL2ZzL2NpZnMvc21iMm1hcGVycm9yLmMKaW5kZXggODJhZGUxNmM5NTAxLi43ZmRl
Mzc3NWNiNTcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm1hcGVycm9yLmMKKysrIGIvZnMvY2lm
cy9zbWIybWFwZXJyb3IuYwpAQCAtNTExLDcgKzUxMSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
c3RhdHVzX3RvX3Bvc2l4X2Vycm9yIHNtYjJfZXJyb3JfbWFwX3RhYmxlW10gPSB7CiAJe1NUQVRV
U19QUklOVF9RVUVVRV9GVUxMLCAtRUlPLCAiU1RBVFVTX1BSSU5UX1FVRVVFX0ZVTEwifSwKIAl7
U1RBVFVTX05PX1NQT09MX1NQQUNFLCAtRUlPLCAiU1RBVFVTX05PX1NQT09MX1NQQUNFIn0sCiAJ
e1NUQVRVU19QUklOVF9DQU5DRUxMRUQsIC1FSU8sICJTVEFUVVNfUFJJTlRfQ0FOQ0VMTEVEIn0s
Ci0Je1NUQVRVU19ORVRXT1JLX05BTUVfREVMRVRFRCwgLUVJTywgIlNUQVRVU19ORVRXT1JLX05B
TUVfREVMRVRFRCJ9LAorCXtTVEFUVVNfTkVUV09SS19OQU1FX0RFTEVURUQsIC1FUkVNQ0hHLCAi
U1RBVFVTX05FVFdPUktfTkFNRV9ERUxFVEVEIn0sCiAJe1NUQVRVU19ORVRXT1JLX0FDQ0VTU19E
RU5JRUQsIC1FQUNDRVMsICJTVEFUVVNfTkVUV09SS19BQ0NFU1NfREVOSUVEIn0sCiAJe1NUQVRV
U19CQURfREVWSUNFX1RZUEUsIC1FSU8sICJTVEFUVVNfQkFEX0RFVklDRV9UWVBFIn0sCiAJe1NU
QVRVU19CQURfTkVUV09SS19OQU1FLCAtRU5PRU5ULCAiU1RBVFVTX0JBRF9ORVRXT1JLX05BTUUi
fSwKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5k
ZXggOWI3NDE0OWI0NzFmLi4zNjcyY2UwYmZiYWYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9w
cy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC03NDEsOCArNzQxLDE0IEBAIGludCBvcGVu
X3Nocm9vdCh1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBzdHJ1Y3Qg
Y2lmc19maWQgKnBmaWQpCiAKIAkvKiBDYWNoZWQgcm9vdCBpcyBzdGlsbCBpbnZhbGlkLCBjb250
aW51ZSBub3JtYWx5ICovCiAKLQlpZiAocmMpCisJaWYgKHJjKSB7CisJCWlmIChyYyA9PSAtRVJF
TUNIRykgeworCQkJdGNvbi0+bmVlZF9yZWNvbm5lY3QgPSB0cnVlOworCQkJcHJpbnRrX29uY2Uo
S0VSTl9XQVJOSU5HICJzZXJ2ZXIgc2hhcmUgJXMgZGVsZXRlZFxuIiwKKwkJCQkgICAgdGNvbi0+
dHJlZU5hbWUpOworCQl9CiAJCWdvdG8gb3Nocl9leGl0OworCX0KIAogCW9fcnNwID0gKHN0cnVj
dCBzbWIyX2NyZWF0ZV9yc3AgKilyc3BfaW92WzBdLmlvdl9iYXNlOwogCW9wYXJtcy5maWQtPnBl
cnNpc3RlbnRfZmlkID0gb19yc3AtPlBlcnNpc3RlbnRGaWxlSWQ7CkBAIC0yMjM3LDYgKzIyNDMs
MTEgQEAgc21iMl9xdWVyeV9pbmZvX2NvbXBvdW5kKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0
cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJcmVzcF9idWZ0eXBlLCByc3BfaW92KTsKIAlpZiAo
cmMpIHsKIAkJZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlwZVsxXSwgcnNwX2lvdlsxXS5pb3ZfYmFz
ZSk7CisJCWlmIChyYyA9PSAtRVJFTUNIRykgeworCQkJdGNvbi0+bmVlZF9yZWNvbm5lY3QgPSB0
cnVlOworCQkJcHJpbnRrX29uY2UoS0VSTl9XQVJOSU5HICJzZXJ2ZXIgc2hhcmUgJXMgZGVsZXRl
ZFxuIiwKKwkJCQkgICAgdGNvbi0+dHJlZU5hbWUpOworCQl9CiAJCWdvdG8gcWljX2V4aXQ7CiAJ
fQogCSpyc3AgPSByc3BfaW92WzFdOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmMgYi9m
cy9jaWZzL3NtYjJwZHUuYwppbmRleCBjYWI2OTZhYzY4YWIuLjAxZDVjNGFmMjQ1OCAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIycGR1LmMKQEAgLTI1OTUs
NiArMjU5NSwxMSBAQCBTTUIyX29wZW4oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfb3Blbl9wYXJtcyAqb3Bhcm1zLCBfX2xlMTYgKnBhdGgsCiAJCX0KIAkJdHJhY2Vfc21iM19v
cGVuX2Vycih4aWQsIHRjb24tPnRpZCwgc2VzLT5TdWlkLAogCQkJCSAgICBvcGFybXMtPmNyZWF0
ZV9vcHRpb25zLCBvcGFybXMtPmRlc2lyZWRfYWNjZXNzLCByYyk7CisJCWlmIChyYyA9PSAtRVJF
TUNIRykgeworCQkJcHJpbnRrX29uY2UoS0VSTl9XQVJOSU5HICJzZXJ2ZXIgc2hhcmUgJXMgZGVs
ZXRlZFxuIiwKKwkJCQkgICAgdGNvbi0+dHJlZU5hbWUpOworCQkJdGNvbi0+bmVlZF9yZWNvbm5l
Y3QgPSB0cnVlOworCQl9CiAJCWdvdG8gY3JlYXRfZXhpdDsKIAl9IGVsc2UKIAkJdHJhY2Vfc21i
M19vcGVuX2RvbmUoeGlkLCByc3AtPlBlcnNpc3RlbnRGaWxlSWQsIHRjb24tPnRpZCwKLS0gCjIu
MjAuMQoK
--0000000000002a6b450592401506--
