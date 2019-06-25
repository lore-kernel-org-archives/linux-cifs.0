Return-Path: <SRS0=QLD2=UY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FA8C48BD4
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jun 2019 09:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A861214DA
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jun 2019 09:44:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7gk86sI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfFYJou (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Jun 2019 05:44:50 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:39125 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFYJot (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 Jun 2019 05:44:49 -0400
Received: by mail-pf1-f176.google.com with SMTP id j2so9196239pfe.6
        for <linux-cifs@vger.kernel.org>; Tue, 25 Jun 2019 02:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=llU9IFT5EZBFFg3qedfWDR9ytiNbVudrlCrNsGxNuq0=;
        b=T7gk86sIRLA5bvBEJg8kTtiSLjtMFWgdgTCNaLyHJwigPxOpcpF7Hwp+HfNER5LDdz
         lQUH3vP0cGj0YYJRHvroAxFwdpzVI1KJtKUur/HIUl1h9mOtjnqy+3CQZKfeZ20o2xJO
         lfkJz3m0nmyC7dNQneEL8zTWv9eSMAYOlihaAYVVC6GP0gFjOghjJZs+hljTEHajk2qS
         Cloa7rbqZWebZI/36qa9DAVS5dHjTtkMZ0Vyi9ugFZeU6iA4mmZSKAUy/ZArMZ8zuVYU
         DTfdTQ9bslHJ+J8czABu/RZwcLGfAdlhNpki7mH02lnM0nMbaNSUxmZRaKsCJzm2Dv0e
         Tl3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=llU9IFT5EZBFFg3qedfWDR9ytiNbVudrlCrNsGxNuq0=;
        b=dMRS0Zppsxwn03sFDv7jeR3vLj5+ne65bliS933DEW/VrNZQpdMe2ZQLQngqJhK6p6
         cbHNYPIG4rDxwfcnO8vcmhjRoZIh8ewwVNgqjvZMpkjuNHsAS+ufXl1rJ2/d/KHaIBKE
         lH6Bezy5lh/oQtjoqsxfZE1u8WkOaOwEYlA804K5JWv5lgqoVWbtjBrHdHXQRFLLw7Wq
         lwkoAPsAstd+HzfD/LiCKmL3XZRI89UyLP+NgRmHLFpspUCOnDb4k898RXv4Vil7UpuU
         4Z2iiFHtCH4/iA9St0gWIyr0xQmOZ/3EFMumQ7BeHjlVIDIhbR4qasDnMeg8OfM8+iFr
         oUxw==
X-Gm-Message-State: APjAAAURmjayTBwMJilX+/ioDFKW5extiDrq0r50hdUNMUTncZVTj24a
        I3l7m/2SQUqbNNoTW+Xf631kHo7UnJTudze0r2UreYj1
X-Google-Smtp-Source: APXvYqwHT/5+4FVcbz49guL9o/LBLM0R/q1CqlXHRuuSyzrWxFHS4N8MINbsyDLNroe6qj8W8MgkcYO0VWZQop8rvSg=
X-Received: by 2002:a63:d4c:: with SMTP id 12mr10040740pgn.30.1561455888755;
 Tue, 25 Jun 2019 02:44:48 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 25 Jun 2019 04:44:37 -0500
Message-ID: <CAH2r5msYuBS1Jvjs4_+YG0BK9zM=iuj_mWiJd49G1SVF5m6m+g@mail.gmail.com>
Subject: [PATCH][SMB3.1.1] Send new netname negotiate context
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000951045058c22c7c9"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000951045058c22c7c9
Content-Type: text/plain; charset="UTF-8"

Add new SMB3.1.1 netname negotiate context (only sent in request, no
response context to parse).  See MS-SMB2 2.2.3.1.4

-- 
Thanks,

Steve

--000000000000951045058c22c7c9
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Send-netname-context-during-negotiate-protocol.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Send-netname-context-during-negotiate-protocol.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxbmiff60>
X-Attachment-Id: f_jxbmiff60

RnJvbSBkNWU5MjcxYmNjN2VkYzIzMzYyOGU0M2U1MjNkNzgyNmM4MmViMzE2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjUgSnVuIDIwMTkgMDQ6Mzk6NTEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBTZW5kIG5ldG5hbWUgY29udGV4dCBkdXJpbmcgbmVnb3RpYXRlIHByb3RvY29sCgpTZWUg
TVMtU01CMiAyLjIuMy4xLjQKCkFsbG93cyBob3N0bmFtZSB0byBiZSB1c2VkIGJ5IGxvYWQgYmFs
YW5jZXJzCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgfCAyNSArKysrKysrKysrKysrKysrKysrKysrKy0t
CiBmcy9jaWZzL3NtYjJwZHUuaCB8ICA2ICsrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5j
IGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggOGUyODk0MDRmNmIwLi4zNGQ1Mzk3YTE5ODkgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC00
OTUsNiArNDk1LDIxIEBAIGJ1aWxkX2VuY3J5cHRfY3R4dChzdHJ1Y3Qgc21iMl9lbmNyeXB0aW9u
X25lZ19jb250ZXh0ICpwbmVnX2N0eHQpCiAJcG5lZ19jdHh0LT5DaXBoZXJzWzFdID0gU01CMl9F
TkNSWVBUSU9OX0FFUzEyOF9DQ007CiB9CiAKK3N0YXRpYyB1bnNpZ25lZCBpbnQKK2J1aWxkX25l
dG5hbWVfY3R4dChzdHJ1Y3Qgc21iMl9uZXRuYW1lX25lZ19jb250ZXh0ICpwbmVnX2N0eHQsIGNo
YXIgKmhvc3RuYW1lKQoreworCXN0cnVjdCBubHNfdGFibGUgKmNwID0gbG9hZF9ubHNfZGVmYXVs
dCgpOworCisJcG5lZ19jdHh0LT5Db250ZXh0VHlwZSA9IFNNQjJfTkVUTkFNRV9ORUdPVElBVEVf
Q09OVEVYVF9JRDsKKworCS8qIGNvcHkgdXAgdG8gbWF4IG9mIGZpcnN0IDEwMCBieXRlcyBvZiBz
ZXJ2ZXIgbmFtZSB0byBOZXROYW1lIGZpZWxkICovCisJcG5lZ19jdHh0LT5EYXRhTGVuZ3RoID0g
Y3B1X3RvX2xlMTYoMiArCisJCSgyICogY2lmc19zdHJ0b1VURjE2KHBuZWdfY3R4dC0+TmV0TmFt
ZSwgaG9zdG5hbWUsIDEwMCwgY3ApKSk7CisJLyogY29udGV4dCBzaXplIGlzIERhdGFMZW5ndGgg
KyBtaW5pbWFsIHNtYjJfbmVnX2NvbnRleHQgKi8KKwlyZXR1cm4gRElWX1JPVU5EX1VQKGxlMTZf
dG9fY3B1KHBuZWdfY3R4dC0+RGF0YUxlbmd0aCkgKworCQkJc2l6ZW9mKHN0cnVjdCBzbWIyX25l
Z19jb250ZXh0KSwgOCkgKiA4OworfQorCiBzdGF0aWMgdm9pZAogYnVpbGRfcG9zaXhfY3R4dChz
dHJ1Y3Qgc21iMl9wb3NpeF9uZWdfY29udGV4dCAqcG5lZ19jdHh0KQogewpAQCAtNTU5LDkgKzU3
NCwxNSBAQCBhc3NlbWJsZV9uZWdfY29udGV4dHMoc3RydWN0IHNtYjJfbmVnb3RpYXRlX3JlcSAq
cmVxLAogCQkJCTgpICogODsKIAkJKnRvdGFsX2xlbiArPSBjdHh0X2xlbjsKIAkJcG5lZ19jdHh0
ICs9IGN0eHRfbGVuOwotCQlyZXEtPk5lZ290aWF0ZUNvbnRleHRDb3VudCA9IGNwdV90b19sZTE2
KDQpOworCQlyZXEtPk5lZ290aWF0ZUNvbnRleHRDb3VudCA9IGNwdV90b19sZTE2KDUpOwogCX0g
ZWxzZQotCQlyZXEtPk5lZ290aWF0ZUNvbnRleHRDb3VudCA9IGNwdV90b19sZTE2KDMpOworCQly
ZXEtPk5lZ290aWF0ZUNvbnRleHRDb3VudCA9IGNwdV90b19sZTE2KDQpOworCisJY3R4dF9sZW4g
PSBidWlsZF9uZXRuYW1lX2N0eHQoKHN0cnVjdCBzbWIyX25ldG5hbWVfbmVnX2NvbnRleHQgKilw
bmVnX2N0eHQsCisJCQkJCXNlcnZlci0+aG9zdG5hbWUpOworCSp0b3RhbF9sZW4gKz0gY3R4dF9s
ZW47CisJcG5lZ19jdHh0ICs9IGN0eHRfbGVuOworCiAJYnVpbGRfcG9zaXhfY3R4dCgoc3RydWN0
IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQgKilwbmVnX2N0eHQpOwogCSp0b3RhbF9sZW4gKz0gc2l6
ZW9mKHN0cnVjdCBzbWIyX3Bvc2l4X25lZ19jb250ZXh0KTsKIH0KZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvc21iMnBkdS5oIGIvZnMvY2lmcy9zbWIycGR1LmgKaW5kZXggMjM1MjRmZTk0N2RlLi42NDI4
NTc0OTYzZGYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5oCisrKyBiL2ZzL2NpZnMvc21i
MnBkdS5oCkBAIC0zMTcsNiArMzE3LDEyIEBAIHN0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFi
aWxpdGllc19jb250ZXh0IHsKICAqIEZvciBzbWIyX25ldG5hbWVfbmVnb3RpYXRlX2NvbnRleHRf
aWQgU2VlIE1TLVNNQjIgMi4yLjMuMS40LgogICogSXRzIHN0cnVjdCBzaW1wbHkgY29udGFpbnMg
TmV0TmFtZSwgYW4gYXJyYXkgb2YgVW5pY29kZSBjaGFyYWN0ZXJzCiAgKi8KK3N0cnVjdCBzbWIy
X25ldG5hbWVfbmVnX2NvbnRleHQgeworCV9fbGUxNglDb250ZXh0VHlwZTsgLyogMHgxMDAgKi8K
KwlfX2xlMTYJRGF0YUxlbmd0aDsKKwlfX2xlMzIJUmVzZXJ2ZWQ7CisJX19sZTE2CU5ldE5hbWVb
MF07IC8qIGhvc3RuYW1lIG9mIHRhcmdldCBjb252ZXJ0ZWQgdG8gVUNTLTIgKi8KK30gX19wYWNr
ZWQ7CiAKICNkZWZpbmUgUE9TSVhfQ1RYVF9EQVRBX0xFTgkxNgogc3RydWN0IHNtYjJfcG9zaXhf
bmVnX2NvbnRleHQgewotLSAKMi4yMC4xCgo=
--000000000000951045058c22c7c9--
