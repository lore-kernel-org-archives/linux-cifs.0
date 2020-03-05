Return-Path: <SRS0=MmJ1=4W=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAF9C3F2CD
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Mar 2020 06:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AEA321556
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Mar 2020 06:03:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="byICpEeZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgCEGD1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 Mar 2020 01:03:27 -0500
Received: from mail-yw1-f52.google.com ([209.85.161.52]:46163 "EHLO
        mail-yw1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgCEGD0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 Mar 2020 01:03:26 -0500
Received: by mail-yw1-f52.google.com with SMTP id y62so4570136ywd.13
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2020 22:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=di+BCj3E+sDLdxcnjG5LaOk3AYwvIBNiHoUh8uNXoGU=;
        b=byICpEeZWjWJPD1hxQ/G+1BJJP1wWTiokIlS+gh2ktFZOul0c8MkPRWC4AP6rHQEpG
         PQDg3uTm4NHyvD9aklhWjhFYTzE3vOYXTXNmbjnQGi9XrDWNSafXeTn87dxPBMG2YGME
         YOR5Abw4hzEmx9hXgcbfy0GenfbH2gCmUjLJwDiDv8jdHLrthHGw2MGepr+ZHprSBPIp
         Vd5K5+4gCeueJNln5gvbu83P2Slxnr+/3swDr/NvoFq/4Xt4mnMbZ7awmGmWtAM31zPg
         yVcktiZahVMfqWgByIJz7M9ukJH6rU//VKDKbJit0i37l6vyDHqOmr7p0DcTYGLpxznJ
         LNEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=di+BCj3E+sDLdxcnjG5LaOk3AYwvIBNiHoUh8uNXoGU=;
        b=q1m9hZ7xFrOXAalkv2Fab38N/3o9BllDXwlRBncJy+LVPbwLWpPvPt+teOa0ufQ7He
         ME1RN2Q5TiueVnQ9gaG7suyllfNNkB1afVV+rXOar6NnzXA9CsOmF/CDyNPS7R9rMZUi
         Cus5cfRrp+mdZNVe3NIVFA0yrsuzo0z7+m0yUkumnATRBnDdkoedpiiG9CK7o7ButIAS
         4P/FfTOGy8aN4wn+hnxFBl8o7P1BLIR7bbzWYKmXUnlcfSImsGFze24WG3rAKrZMPZf8
         5j6I2P/5PmHRgT/bYYClMMvHOMpmKUurxGEVlpsEa4UItS1cWAiT90/Q/Asz4S2qD4oM
         YrAg==
X-Gm-Message-State: ANhLgQ2GMLhxSvN/HH5s7G6PoxRfw6AxwZlLHngzfU6lbaJi/XosauqL
        fPo8j7PWgYYFiZGmUIyzxG5eYs8YhsNnprtUY7L71x/VdHo=
X-Google-Smtp-Source: ADFU+vufV/a8AY4MVXaLNBJqveSHQH/fP36hAnhwZ9sTDF0/qerRYfOFqBAdW2ZqU0EYBUIeyuWMBsq7Ya90eJPqA+A=
X-Received: by 2002:a25:e805:: with SMTP id k5mr6032493ybd.14.1583388205615;
 Wed, 04 Mar 2020 22:03:25 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 5 Mar 2020 00:03:14 -0600
Message-ID: <CAH2r5msKRKFdpg16DE-HvEGDDMZQOw2=nhL3xbBJoYEvyzHwnQ@mail.gmail.com>
Subject: [CIFS][PATCH] Make warning when using default version (default mount)
 less noisy
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000089b6ba05a0154b0b"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000089b6ba05a0154b0b
Content-Type: text/plain; charset="UTF-8"

    The warning we print on mount about how to use less secure dialects
    (when the user does not specify a version on mount) is useful
    but is noisy to print on every default mount, and can be changed
    to a warn_once.  Slightly updated the warning text as well to note
    SMB3.1.1 which has been the default which is typically negotiated
    (for a few years now) by most servers.

          "No dialect specified on mount. Default has changed to a more
           secure dialect, SMB2.1 or later (e.g. SMB3.1.1), from CIFS
           (SMB1). To use the less secure SMB1 dialect to access old
           servers which do not support SMB3.1.1 (or even SMB3 or SMB2.1)
           specify vers=1.0 on mount."


-- 
Thanks,

Steve

--00000000000089b6ba05a0154b0b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Warn-less-noisily-on-default-mount.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Warn-less-noisily-on-default-mount.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k7ecg2730>
X-Attachment-Id: f_k7ecg2730

RnJvbSBiMzdkNDExZjc0Njc3ZjljNWJhM2ZjMmFlZjE1MmNkNjZiNTFlODVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgNCBNYXIgMjAyMCAyMzo1Njo1MiAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIENJ
RlM6IFdhcm4gbGVzcyBub2lzaWx5IG9uIGRlZmF1bHQgbW91bnQKClRoZSB3YXJuaW5nIHdlIHBy
aW50IG9uIG1vdW50IGFib3V0IGhvdyB0byB1c2UgbGVzcyBzZWN1cmUgZGlhbGVjdHMKKHdoZW4g
dGhlIHVzZXIgZG9lcyBub3Qgc3BlY2lmeSBhIHZlcnNpb24gb24gbW91bnQpIGlzIHVzZWZ1bApi
dXQgaXMgbm9pc3kgdG8gcHJpbnQgb24gZXZlcnkgZGVmYXVsdCBtb3VudCwgYW5kIGNhbiBiZSBj
aGFuZ2VkCnRvIGEgd2Fybl9vbmNlLiAgU2xpZ2h0bHkgdXBkYXRlZCB0aGUgd2FybmluZyB0ZXh0
IGFzIHdlbGwgdG8gbm90ZQpTTUIzLjEuMSB3aGljaCBoYXMgYmVlbiB0aGUgZGVmYXVsdCB3aGlj
aCBpcyB0eXBpY2FsbHkgbmVnb3RpYXRlZAooZm9yIGEgZmV3IHllYXJzIG5vdykgYnkgbW9zdCBz
ZXJ2ZXJzLgoKICAgICAgIk5vIGRpYWxlY3Qgc3BlY2lmaWVkIG9uIG1vdW50LiBEZWZhdWx0IGhh
cyBjaGFuZ2VkIHRvIGEgbW9yZQogICAgICAgc2VjdXJlIGRpYWxlY3QsIFNNQjIuMSBvciBsYXRl
ciAoZS5nLiBTTUIzLjEuMSksIGZyb20gQ0lGUwogICAgICAgKFNNQjEpLiBUbyB1c2UgdGhlIGxl
c3Mgc2VjdXJlIFNNQjEgZGlhbGVjdCB0byBhY2Nlc3Mgb2xkCiAgICAgICBzZXJ2ZXJzIHdoaWNo
IGRvIG5vdCBzdXBwb3J0IFNNQjMuMS4xIChvciBldmVuIFNNQjMgb3IgU01CMi4xKQogICAgICAg
c3BlY2lmeSB2ZXJzPTEuMCBvbiBtb3VudC4iCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0LmMgfCAxMSArKysr
KystLS0tLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4
IDQ2YjYwMmRmYzRkMy4uMjUyNjI0NDZiMjIyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3Qu
YworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMjQ2OSwxMSArMjQ2OSwxMiBAQCBjaWZzX3Bh
cnNlX21vdW50X29wdGlvbnMoY29uc3QgY2hhciAqbW91bnRkYXRhLCBjb25zdCBjaGFyICpkZXZu
YW1lLAogCQlwcl9ub3RpY2UoIkNJRlM6IGlnbm9yaW5nIGZvcmNlZ2lkIG1vdW50IG9wdGlvbiBz
cGVjaWZpZWQgd2l0aCBubyBnaWQ9IG9wdGlvbi5cbiIpOwogCiAJaWYgKGdvdF92ZXJzaW9uID09
IGZhbHNlKQotCQlwcl93YXJuKCJObyBkaWFsZWN0IHNwZWNpZmllZCBvbiBtb3VudC4gRGVmYXVs
dCBoYXMgY2hhbmdlZCB0byAiCi0JCQkiYSBtb3JlIHNlY3VyZSBkaWFsZWN0LCBTTUIyLjEgb3Ig
bGF0ZXIgKGUuZy4gU01CMyksIGZyb20gQ0lGUyAiCi0JCQkiKFNNQjEpLiBUbyB1c2UgdGhlIGxl
c3Mgc2VjdXJlIFNNQjEgZGlhbGVjdCB0byBhY2Nlc3MgIgotCQkJIm9sZCBzZXJ2ZXJzIHdoaWNo
IGRvIG5vdCBzdXBwb3J0IFNNQjMgKG9yIFNNQjIuMSkgc3BlY2lmeSB2ZXJzPTEuMCIKLQkJCSIg
b24gbW91bnQuXG4iKTsKKwkJcHJfd2Fybl9vbmNlKCJObyBkaWFsZWN0IHNwZWNpZmllZCBvbiBt
b3VudC4gRGVmYXVsdCBoYXMgY2hhbmdlZCIKKwkJCSIgdG8gYSBtb3JlIHNlY3VyZSBkaWFsZWN0
LCBTTUIyLjEgb3IgbGF0ZXIgKGUuZy4gIgorCQkJIlNNQjMuMS4xKSwgZnJvbSBDSUZTIChTTUIx
KS4gVG8gdXNlIHRoZSBsZXNzIHNlY3VyZSAiCisJCQkiU01CMSBkaWFsZWN0IHRvIGFjY2VzcyBv
bGQgc2VydmVycyB3aGljaCBkbyBub3QgIgorCQkJInN1cHBvcnQgU01CMy4xLjEgKG9yIGV2ZW4g
U01CMyBvciBTTUIyLjEpIHNwZWNpZnkgIgorCQkJInZlcnM9MS4wIG9uIG1vdW50LlxuIik7CiAK
IAlrZnJlZShtb3VudGRhdGFfY29weSk7CiAJcmV0dXJuIDA7Ci0tIAoyLjIwLjEKCg==
--00000000000089b6ba05a0154b0b--
