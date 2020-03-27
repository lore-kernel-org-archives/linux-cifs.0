Return-Path: <SRS0=a8IY=5M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C41C2D0ED
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 17:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D28A5206F1
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 17:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IcWfscxA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgC0R4E (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:56:04 -0400
Received: from mail-yb1-f174.google.com ([209.85.219.174]:34551 "EHLO
        mail-yb1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgC0R4E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Mar 2020 13:56:04 -0400
Received: by mail-yb1-f174.google.com with SMTP id l84so5044852ybb.1
        for <linux-cifs@vger.kernel.org>; Fri, 27 Mar 2020 10:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DcQ56eQ3xph6rwCXdlBzwae2vmFFWbbLkVbh6e5P3Bs=;
        b=IcWfscxAS2JFR/xkpfHQZSg5VpzcZVM0JU196yRFCOY0bEIs29iwKMu85KEQ7b1QvM
         50ApcJlx6YwWOXD2/JPAhT9U6cC2AatQ4TbyGHnfos04xo1eFK6ijjyNWfHs+4X9/q7H
         ECsmw96zlgNodfwqzHyIevjF7bZwzzf0Kwwz6Fe6ozam9bqsY2LfI2LQlz35EzJ5Kxp5
         hJKWR95vbUlbVfydsPXH8iF1u7GKrECVxr0LrDPiyfEEF1yjsbUaNq6rQ1l0RsBsGh3j
         wLe+iB3aa9WoKRa32K6zEHJXb3pHak8ErZNEdUHJUwouQuxXLA4p8/aORedkEPOmx1Qk
         0ATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DcQ56eQ3xph6rwCXdlBzwae2vmFFWbbLkVbh6e5P3Bs=;
        b=YMiHbd7+ni5qVZAXzgEM5yb98iW+0NomPyVoW3xApRR+b0YsbahweIrZAs8zdcALDt
         LkFHfGNAH7/fFNj8xmQDZ8tO/Uza5VJoXnBumCenyUu9WGU9OvZkrX3NSg2dc7vxfL0p
         eDf2I1ov3VRMdXINosu5ygHyWebraOYhCNcp1keaozFjhngGITTfBkJhwO6MssM9ZQcu
         rXEs1lSsBK1NProQvIuLVKCIdxdvsAnPTPtsDMhMKwabZAzZ9V9CwnUyJgkYQtn4/wqG
         6/OF75wgSfpUd6s9apCAqlfJO12l6ng9wbCoL2rOMvy07/ZIz4+5nGj7eebbZe2s5YFH
         AJ+A==
X-Gm-Message-State: ANhLgQ1OmRKzv2m0a6x7SA461oaLwhTUQ7L5KMOmuvAQN5DwAwbedIk2
        dHnPBCPc8a5acZD0UtPkAX5BNG69gJpytUq0Lno1BrOR
X-Google-Smtp-Source: ADFU+vux7wF6HJ2uUv48bsUmMeV9Gb5OGezYktNeINetSZZz1GQKTD5wCTKvdXGu7FwFIblhRyUn47g6hIG16N8Nr4M=
X-Received: by 2002:a25:aa69:: with SMTP id s96mr7092361ybi.85.1585331762892;
 Fri, 27 Mar 2020 10:56:02 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 27 Mar 2020 12:55:52 -0500
Message-ID: <CAH2r5muYwx1TvdmJo5H2aXfzDXc2VP4u-=UeFA53cwiO3ZB+EQ@mail.gmail.com>
Subject: [PATCH] smb3: use SMB2_SIGNATURE_SIZE define
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     henning.schild@siemens.com
Content-Type: multipart/mixed; boundary="000000000000943e3d05a1d9d073"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000943e3d05a1d9d073
Content-Type: text/plain; charset="UTF-8"

-- 
Thanks,

Steve

--000000000000943e3d05a1d9d073
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-use-SMB2_SIGNATURE_SIZE-define.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-use-SMB2_SIGNATURE_SIZE-define.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k8ahkidq0>
X-Attachment-Id: f_k8ahkidq0

RnJvbSBlZGFkNzM0Yzc0YTRhYjZiYTg1MzExODYwNTQ3NzliMjM4MmRmM2ZkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjcgTWFyIDIwMjAgMTI6NDc6NDEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiB1c2UgU01CMl9TSUdOQVRVUkVfU0laRSBkZWZpbmUKCkl0IGNsYXJpZmllcyB0aGUgY29k
ZSBzbGlnaHRseSB0byB1c2UgU01CMl9TSUdOQVRVUkVfU0laRQpkZWZpbmUgcmF0aGVyIHRoYW4g
MTYuCgpTdWdnZXN0ZWQtYnk6IEhlbm5pbmcgU2NoaWxkIDxoZW5uaW5nLnNjaGlsZEBzaWVtZW5z
LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29t
PgotLS0KIGZzL2NpZnMvc21iMnRyYW5zcG9ydC5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIydHJh
bnNwb3J0LmMgYi9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYwppbmRleCAwOGI3MDNiN2ExNWUuLjJi
NjdhNzc2OWQ3NCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIydHJhbnNwb3J0LmMKKysrIGIvZnMv
Y2lmcy9zbWIydHJhbnNwb3J0LmMKQEAgLTYwMiw3ICs2MDIsNyBAQCBpbnQKIHNtYjJfdmVyaWZ5
X3NpZ25hdHVyZShzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8g
KnNlcnZlcikKIHsKIAl1bnNpZ25lZCBpbnQgcmM7Ci0JY2hhciBzZXJ2ZXJfcmVzcG9uc2Vfc2ln
WzE2XTsKKwljaGFyIHNlcnZlcl9yZXNwb25zZV9zaWdbU01CMl9TSUdOQVRVUkVfU0laRV07CiAJ
c3RydWN0IHNtYjJfc3luY19oZHIgKnNoZHIgPQogCQkJKHN0cnVjdCBzbWIyX3N5bmNfaGRyICop
cnFzdC0+cnFfaW92WzBdLmlvdl9iYXNlOwogCi0tIAoyLjIwLjEKCg==
--000000000000943e3d05a1d9d073--
