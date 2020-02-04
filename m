Return-Path: <SRS0=sow2=3Y=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679EEC35247
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Feb 2020 20:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ADF720674
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Feb 2020 20:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZZaz/qVk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgBDUmd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Feb 2020 15:42:33 -0500
Received: from mail-il1-f181.google.com ([209.85.166.181]:34791 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgBDUmd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Feb 2020 15:42:33 -0500
Received: by mail-il1-f181.google.com with SMTP id l4so17141465ilj.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Feb 2020 12:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mUIXdFyk3++G++8LPtXJxWo6V4BrxAMF2HVFUuE3Ass=;
        b=ZZaz/qVkav0pe3mtyw3ADjjd3UOlyFxcDIyJadRx+84m/DDIlmWHSxLF/xDLNeXiVc
         NJTSz6uukqXjpXFQxvNkTbX2A/+u8mtONigKghZdiIqF3nOaxlpLxZOUQIpTARSfitWD
         ddhq7pEZo3pwdpyBDK+CyO5Bw/3bNWK7qXeCJpmuF2gMG8quCR/cmIe4Z5IAwBJPak+L
         lPNx5Ri7PF5cLI+cmomqWNdbDP3jahtQZhnUPw1Q+uTaqdfl8ZOOEaOpwg7nNNzlba3n
         CUdVmNeu96HWOQO5ChtvqrmPKZXPsxb+Qehzps8/+gMXwqomkYdOcir6ojr9OPr6faw0
         MRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mUIXdFyk3++G++8LPtXJxWo6V4BrxAMF2HVFUuE3Ass=;
        b=IBcHjbvwK5x4f6DOXsLrHTdUkbBVdQMYuPo/HMMEIRZVNi9DaMQHMdFetN+jUJBWxe
         UfFZszGQyPpCLNyGJvsSnjNU9CrOyTbrFT25+XvaZEHptw3urDJVfD92Hs1rJIfbEAu7
         eVot9vqEnyQMeZQPuuJmalYlQ4m5QPgTOMnnXTxkqT42k10Zb6xVoWh6ZsTfAXL4fqke
         QJ08DTyQqoJ5vT/5hv7FFYoP5lFO4fzM/3x66bz/E30ZOvkDpd46cmRUqwcc43Avop4+
         yzII9kTvIYzsMmJUwuNYgtIRhvBXd0AXB0D/sQADQnzmBU9+TKAUHwMq0nccw5E/eGtM
         QjhA==
X-Gm-Message-State: APjAAAVBQWFwhEMxfh2n8fglYpYgp5+d/uobCErCfNfOkTL2CAqyex9X
        jnN8pA1MmDRpKQcTzEz2qA6Ys/rX6I0VzOiYTwdw+B7l
X-Google-Smtp-Source: APXvYqwD/VxQqS9yx/yMgF9oKnSRXwt9fRqk9LidfWkekDyJw7YQ54GQqPbHCv13A8rTd671reP3O1+ch3etQQ6oaTI=
X-Received: by 2002:a92:7301:: with SMTP id o1mr4162075ilc.272.1580848952536;
 Tue, 04 Feb 2020 12:42:32 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 4 Feb 2020 14:42:21 -0600
Message-ID: <CAH2r5mtu69KEWU94qZK32H_8cvyhVU8GyOKrZqbdjH0ZLd95Zg@mail.gmail.com>
Subject: [SMB3][PATCH] Fix oops in cifs_create_options()
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000043e738059dc61438"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000043e738059dc61438
Content-Type: text/plain; charset="UTF-8"

-- 
Thanks,

Steve

--00000000000043e738059dc61438
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-problem-with-null-cifs-super-block-with-pre.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-problem-with-null-cifs-super-block-with-pre.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k68cm7kf0>
X-Attachment-Id: f_k68cm7kf0

RnJvbSA2NzI5OWM0NjliNzE4MjAwY2E4OGJmNzRhZDYxMDZlZjJiOGVkN2I0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgNCBGZWIgMjAyMCAxMzowMjo1OSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCBwcm9ibGVtIHdpdGggbnVsbCBjaWZzIHN1cGVyIGJsb2NrIHdpdGggcHJldmlvdXMK
IHBhdGNoCgpBZGQgY2hlY2sgZm9yIG51bGwgY2lmc19zYiB0byBjcmVhdGVfb3B0aW9ucyBoZWxw
ZXIKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
Q0M6IEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEBnbWFpbC5jb20+Ci0tLQogZnMvY2lmcy9jaWZz
cHJvdG8uaCB8IDIgKy0KIGZzL2NpZnMvc21iMm9wcy5jICAgfCAyICstCiAyIGZpbGVzIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZz
L2NpZnNwcm90by5oIGIvZnMvY2lmcy9jaWZzcHJvdG8uaAppbmRleCA3NDhiZDAwY2I1ZjEuLjg5
ZWFhZjQ2ZDFjYSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzcHJvdG8uaAorKysgYi9mcy9jaWZz
L2NpZnNwcm90by5oCkBAIC02MTQsNyArNjE0LDcgQEAgc3RhdGljIGlubGluZSBpbnQgZ2V0X2Rm
c19wYXRoKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2VzLAogCiBz
dGF0aWMgaW5saW5lIGludCBjaWZzX2NyZWF0ZV9vcHRpb25zKHN0cnVjdCBjaWZzX3NiX2luZm8g
KmNpZnNfc2IsIGludCBvcHRpb25zKQogewotCWlmIChiYWNrdXBfY3JlZChjaWZzX3NiKSkKKwlp
ZiAoY2lmc19zYiAmJiAoYmFja3VwX2NyZWQoY2lmc19zYikpKQogCQlyZXR1cm4gb3B0aW9ucyB8
IENSRUFURV9PUEVOX0JBQ0tVUF9JTlRFTlQ7CiAJZWxzZQogCQlyZXR1cm4gb3B0aW9uczsKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggMzNi
Yjg2Y2FlMzY5Li5hYzY2MjhlMjhiMTIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisr
KyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC0yNDA3LDcgKzI0MDcsNyBAQCBzbWIyX3F1ZXJ5ZnMo
Y29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQkgICAg
ICBGU19GVUxMX1NJWkVfSU5GT1JNQVRJT04sCiAJCQkJICAgICAgU01CMl9PX0lORk9fRklMRVNZ
U1RFTSwKIAkJCQkgICAgICBzaXplb2Yoc3RydWN0IHNtYjJfZnNfZnVsbF9zaXplX2luZm8pLAot
CQkJCSAgICAgICZyc3BfaW92LCAmYnVmdHlwZSwgTlVMTCk7CisJCQkJICAgICAgJnJzcF9pb3Ys
ICZidWZ0eXBlLCBjaWZzX3NiKTsKIAlpZiAocmMpCiAJCWdvdG8gcWZzX2V4aXQ7CiAKLS0gCjIu
MjAuMQoK
--00000000000043e738059dc61438--
