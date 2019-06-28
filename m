Return-Path: <SRS0=z2/z=U3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59D1C4321A
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jun 2019 07:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46E0206E0
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jun 2019 07:39:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bc6HDdo0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfF1Hjx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jun 2019 03:39:53 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:39525 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfF1Hjx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jun 2019 03:39:53 -0400
Received: by mail-pf1-f174.google.com with SMTP id j2so2536856pfe.6
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jun 2019 00:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=GHWowgQohNvjpBGR0yDBBdpc8tIJ7QVVfm5jJHsNpBo=;
        b=Bc6HDdo0YqpKIRTWxtt/WQlr6HVR/MifMXuJaSFgDQhudMM6eIk87YSl6NFiZd849i
         sR/vgv7uICQfJKPcQsfv7y8FIm/PMhnhVK6u/ROfMpzYE2qvIeES6tLUZmfaQxp+GYtt
         u2iYc1ohw6Mg2REpSxXhkqtFwx8CwuQVuHtl8xK/+2Hf+1S3A5FpKvM4E0K/M5qR68xU
         O1xbx4Q6hAnKlW4ektAZQx43I0LiZkMuinOHTGKHVclD1Brm97OF1rS2G6k3p1KVb+88
         YrNWwEjjq2uLevUWzA5HDgqsjHbnAMFIwx4TEPFjyH4AJJGOcePxeJxZEgTcX023Yx6O
         hmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GHWowgQohNvjpBGR0yDBBdpc8tIJ7QVVfm5jJHsNpBo=;
        b=acPXYLcHJw7o74Mw3XQSmaIHTEMuYnd2oxEMT4/ukzX1u8tglbR4pqPMHqPi1N+jHK
         QgR5HBG5q70a0WFh1muBPg/Bt4OGEWCWDVgx4/lHS6ITGMEa3woyOMjxgZmUBM402A5I
         7X2anV3LMbg++Q3dKB7I0i5m9T6GuKSaFLrT925rIZYSC0ZjuQ398+kn7kfwJPQLoswc
         SrspDQymsIhu/G6OPIWHYt/SAKrs7jfoYlyU5lpUl+1eR2PXHkDmxpaflkmpes0Bk0mm
         1+YpthE43Bto5VqK8JX0sWloGXBm3MzRQZOKtxl/4OdbHWSio+GAGRfwJFvHO11sixwO
         Y/MQ==
X-Gm-Message-State: APjAAAUmqYFOExSNGPX2AE3Eh2UfHgEYN2JMNnCCsZDhmaxARf28N2fQ
        BMx/J3ZDqYVHbobartEXh71rTDqI4RMhP1ZBEYOxfA==
X-Google-Smtp-Source: APXvYqxqsBP71c3aWLz4F+s6A2css/KFns23sAAFzMFl3XXLqV3FHvbSfAVn6QTho4FoBab/gu8KCrYxFZP2M+jl+U4=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr11022781pjb.138.1561707592118;
 Fri, 28 Jun 2019 00:39:52 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 Jun 2019 02:39:41 -0500
Message-ID: <CAH2r5mtrzwAzGWKVj7Xkx2-x9JHso5rVo25bfhsbJor188J53Q@mail.gmail.com>
Subject: Add missing definitions for query_disk_id
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000458df5058c5d62ec"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000458df5058c5d62ec
Content-Type: text/plain; charset="UTF-8"

See MS-SMB2 2.2.13.2




-- 
Thanks,

Steve

--000000000000458df5058c5d62ec
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-some-missing-definitions.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-some-missing-definitions.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxfsd5nb0>
X-Attachment-Id: f_jxfsd5nb0

RnJvbSA2ZTJkYzgwMTA0N2I3MDgyOWI1ODdlODU1NWQ3M2QyM2EyZDg1YzhlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjggSnVuIDIwMTkgMDI6MzU6MTAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBb
c21iM10gYWRkIHNvbWUgbWlzc2luZyBkZWZpbml0aW9ucwoKcXVlcnkgb24gZGlzayBpZCBzdHJ1
Y3R1cmUgZGVmaW5pdGlvbiB3YXMgbWlzc2luZwoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNo
IDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5oIHwgOCArKysr
KysrKwogMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvc21iMnBkdS5oIGIvZnMvY2lmcy9zbWIycGR1LmgKaW5kZXggZDYxY2UyYjAxOWMyLi4wNTNl
YzYyMWU3YjkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5oCisrKyBiL2ZzL2NpZnMvc21i
MnBkdS5oCkBAIC02NDcsNiArNjQ3LDcgQEAgc3RydWN0IHNtYjJfdHJlZV9kaXNjb25uZWN0X3Jz
cCB7CiAjZGVmaW5lIFNNQjJfQ1JFQVRFX0RVUkFCTEVfSEFORExFX1JFUVVFU1RfVjIJIkRIMlEi
CiAjZGVmaW5lIFNNQjJfQ1JFQVRFX0RVUkFCTEVfSEFORExFX1JFQ09OTkVDVF9WMgkiREgyQyIK
ICNkZWZpbmUgU01CMl9DUkVBVEVfQVBQX0lOU1RBTkNFX0lECTB4NDVCQ0E2NkFFRkE3Rjc0QTkw
MDhGQTQ2MkUxNDRENzQKKyNkZWZpbmUgU01CMl9DUkVBVEVfQVBQX0lOU1RBTkNFX1ZFUlNJT04g
MHhCOTgyRDBCNzNCNTYwNzRGQTA3QjUyNEE4MTE2QTAxMAogI2RlZmluZSBTVkhEWF9PUEVOX0RF
VklDRV9DT05URVgJMHg5Q0NCQ0Y5RTA0QzFFNjQzOTgwRTE1OERBMUY2RUM4MwogI2RlZmluZSBT
TUIyX0NSRUFURV9UQUdfUE9TSVgJCTB4OTNBRDI1NTA5Q0I0MTFFN0I0MjM4M0RFOTY4QkNEN0MK
IApAQCAtODEzLDYgKzgxNCwxMyBAQCBzdHJ1Y3QgZHVyYWJsZV9yZWNvbm5lY3RfY29udGV4dF92
MiB7CiAJX19sZTMyIEZsYWdzOyAvKiBzZWUgYWJvdmUgREhBTkRMRV9GTEFHX1BFUlNJU1RFTlQg
Ki8KIH0gX19wYWNrZWQ7CiAKKy8qIFNlZSBNUy1TTUIyIDIuMi4xNC4yLjkgKi8KK3N0cnVjdCBv
bl9kaXNrX2lkIHsKKwlfX2xlNjQgRGlza0ZpbGVJZDsKKwlfX2xlNjQgVm9sdW1lSWQ7CisJX191
NjQgIFJlc2VydmVkWzRdOworfSBfX3BhY2tlZDsKKwogLyogU2VlIE1TLVNNQjIgMi4yLjE0LjIu
MTIgKi8KIHN0cnVjdCBkdXJhYmxlX3JlY29ubmVjdF9jb250ZXh0X3YyX3JzcCB7CiAJX19sZTMy
IFRpbWVvdXQ7Ci0tIAoyLjIwLjEKCg==
--000000000000458df5058c5d62ec--
