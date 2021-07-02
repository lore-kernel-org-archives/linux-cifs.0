Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266D3C11F67
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Jul 2021 01:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F144A6140C
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Jul 2021 01:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhGBBve (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Jul 2021 21:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbhGBBvd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Jul 2021 21:51:33 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148A7C061762
        for <linux-cifs@vger.kernel.org>; Thu,  1 Jul 2021 18:49:02 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f30so15332005lfj.1
        for <linux-cifs@vger.kernel.org>; Thu, 01 Jul 2021 18:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=dqMaZ6CpBoFaSF9qL4tP+aQr7ula1dlmAgUQSMZKQBU=;
        b=IODcgKfoju5KmIQpKl3GRICh6kA3rc/z5gqjnnmP/9NdFo6aqoMpkI7lnO0rsfVcx/
         14Qs5Dpf0ysHEN3bwva3jqIYebVA2+oBsaP/uiKokUjbOsEkt8CumPLNp0g6ALK4EAdk
         6XMGNyqTsogpbC9L69Q/ZTF/rO5TSY+Q+M4uP1+GoaaIfA2bNPEDqr2x2iW9RY1Wtl7W
         POh6MD+NxVPjphEPM32lvOp3/kZ+XzfEvM38P+jThe5dLa+hiLbBDLhQATJnu9Kx6SeJ
         SxhgHLZXP6/2mW015EW57yUkQz9D/Yj7IiDoYz9mklu7N17bBdDwm1lNzPz/k9opFi0z
         ow3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=dqMaZ6CpBoFaSF9qL4tP+aQr7ula1dlmAgUQSMZKQBU=;
        b=VOiaXmdqnyE7sTuQ1YIe85f2EikArDW/kL4ogQf3BzG4FaO97f272zStXQ7HVRt46J
         CcLHeg2EnKmbpAV7bKZgpZSPG5qR5glbkic8C3tLWW0tByxY/HpHZfLuiw0v7U4XRxhb
         idRk/eEgthA7+uSSeI8tcWStzBmO0EIUTqieGtGYwV1NxxPGHEP1jWaxbuNWwaq2aHRf
         iGBnMbPROtTW3DIr3vq2HZPODbD1lfBG8jpDv7/gNRU19+YVu7Lh2oPfq+2+ElAeKut7
         APDOsLUieOplfoHMZNRFZoTRhxAkaPozIW4qHJ7s0Z1XAKBNBxwqnUnJNHfWXtbXlE6W
         XvWw==
X-Gm-Message-State: AOAM532cCLKaub3wz5fQIStjXMidR9DyaeO1u+2GPTKB7xIoJ+3IGcuA
        9TaQR9iHGtAyY+k7nPkiqCyUg+oKGfkZ9s78+cCB6gdmLIIwHw==
X-Google-Smtp-Source: ABdhPJypiPPO9i7ZzfDJwg9YvE8Ct5ESLV5CVZqpZLhJtTuFru3qZC/Ry98fQWD3NDqyygmXAj+1yh8qKkav4mpSvRI=
X-Received: by 2002:a19:cc6:: with SMTP id 189mr1952951lfm.175.1625190540067;
 Thu, 01 Jul 2021 18:49:00 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Jul 2021 20:48:49 -0500
Message-ID: <CAH2r5muwZikVYiE7J+mwBxFLRe4yP4YsA-=vBJQ56KGfRabNKw@mail.gmail.com>
Subject: [PATCH] CIFS: Clarify SMB1 code for UnixCreateSymLink
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d55bde05c61a2872"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d55bde05c61a2872
Content-Type: text/plain; charset="UTF-8"

Coverity also complains about the way we calculate the offset
(starting from the address of a 4 byte array within the
header structure rather than from the beginning of the struct
plus 4 bytes) for creating SMB1 symlinks when using the Unix
extensions.  This doesn't change the address but
makes it slightly clearer.

Addresses-Coverity: 711530 ("Out of bounds read")
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifssmb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index ea12fa6eacb6..a14d3f533301 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2925,7 +2925,8 @@ CIFSUnixCreateSymLink(const unsigned int xid,
struct cifs_tcon *tcon,
  InformationLevel) - 4;
  offset = param_offset + params;

- data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
+ /* SMB offsets are from the beginning of SMB which is 4 bytes in,
after RFC1001 field */
+ data_offset = (char *)pSMB + offset + 4;
  if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
  name_len_target =
      cifsConvertToUTF16((__le16 *) data_offset, toName,

-- 
Thanks,

Steve

--000000000000d55bde05c61a2872
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Clarify-SMB1-code-for-UnixCreateSymLink.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Clarify-SMB1-code-for-UnixCreateSymLink.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqlofsi80>
X-Attachment-Id: f_kqlofsi80

RnJvbSBlNzE5OGRiZjhiNjIyOTYzMTk2OTBkYTU5MWMzOTZjZjA1ZDkxYzY1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMSBKdWwgMjAyMSAyMDo0NDoyNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIENJ
RlM6IENsYXJpZnkgU01CMSBjb2RlIGZvciBVbml4Q3JlYXRlU3ltTGluawoKQ292ZXJpdHkgYWxz
byBjb21wbGFpbnMgYWJvdXQgdGhlIHdheSB3ZSBjYWxjdWxhdGUgdGhlIG9mZnNldAooc3RhcnRp
bmcgZnJvbSB0aGUgYWRkcmVzcyBvZiBhIDQgYnl0ZSBhcnJheSB3aXRoaW4gdGhlCmhlYWRlciBz
dHJ1Y3R1cmUgcmF0aGVyIHRoYW4gZnJvbSB0aGUgYmVnaW5uaW5nIG9mIHRoZSBzdHJ1Y3QKcGx1
cyA0IGJ5dGVzKSBmb3IgY3JlYXRpbmcgU01CMSBzeW1saW5rcyB3aGVuIHVzaW5nIHRoZSBVbml4
CmV4dGVuc2lvbnMuICBUaGlzIGRvZXNuJ3QgY2hhbmdlIHRoZSBhZGRyZXNzIGJ1dAptYWtlcyBp
dCBzbGlnaHRseSBjbGVhcmVyLgoKQWRkcmVzc2VzLUNvdmVyaXR5OiA3MTE1MjkgKCJPdXQgb2Yg
Ym91bmRzIHJlYWQiKQpSZXZpZXdlZC1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRo
YXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvY2lmcy9jaWZzc21iLmMgfCAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3NtYi5j
IGIvZnMvY2lmcy9jaWZzc21iLmMKaW5kZXggZWExMmZhNmVhY2I2Li5hMTRkM2Y1MzMzMDEgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3NtYi5jCisrKyBiL2ZzL2NpZnMvY2lmc3NtYi5jCkBAIC0y
OTI1LDcgKzI5MjUsOCBAQCBDSUZTVW5peENyZWF0ZVN5bUxpbmsoY29uc3QgdW5zaWduZWQgaW50
IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQlJbmZvcm1hdGlvbkxldmVsKSAtIDQ7
CiAJb2Zmc2V0ID0gcGFyYW1fb2Zmc2V0ICsgcGFyYW1zOwogCi0JZGF0YV9vZmZzZXQgPSAoY2hh
ciAqKSAoJnBTTUItPmhkci5Qcm90b2NvbCkgKyBvZmZzZXQ7CisJLyogU01CIG9mZnNldHMgYXJl
IGZyb20gdGhlIGJlZ2lubmluZyBvZiBTTUIgd2hpY2ggaXMgNCBieXRlcyBpbiwgYWZ0ZXIgUkZD
MTAwMSBmaWVsZCAqLworCWRhdGFfb2Zmc2V0ID0gKGNoYXIgKilwU01CICsgb2Zmc2V0ICsgNDsK
IAlpZiAocFNNQi0+aGRyLkZsYWdzMiAmIFNNQkZMRzJfVU5JQ09ERSkgewogCQluYW1lX2xlbl90
YXJnZXQgPQogCQkgICAgY2lmc0NvbnZlcnRUb1VURjE2KChfX2xlMTYgKikgZGF0YV9vZmZzZXQs
IHRvTmFtZSwKLS0gCjIuMzAuMgoK
--000000000000d55bde05c61a2872--
