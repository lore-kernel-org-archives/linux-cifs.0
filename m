Return-Path: <SRS0=BWmz=5Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD69C2D0EA
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Apr 2020 06:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2121F20757
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Apr 2020 06:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d1hb3SEn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgDIGKM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Apr 2020 02:10:12 -0400
Received: from mail-yb1-f182.google.com ([209.85.219.182]:46262 "EHLO
        mail-yb1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIGKL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Apr 2020 02:10:11 -0400
Received: by mail-yb1-f182.google.com with SMTP id f14so5080293ybr.13
        for <linux-cifs@vger.kernel.org>; Wed, 08 Apr 2020 23:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=zzRXsJ8b57aKFfe8JdBAqB9CboOpyW2XmPg+dxM7tU4=;
        b=d1hb3SEnh+Zq4k7wYs0JGiBSM3DpMXbDIpm3JLFjWg9jn6apvZuu3nwwhLRBwWSJlk
         z4t7xpuX3BTk3jnqsmGhZpNRf87Otk8BxyaGe9dQ2mbgD7Db74h79kulAH+8XvDQz3nH
         hU7SvlQSkFXLjULTSoCt8i7ZlM87GiRIajTR/w1s0u8L7QjyxTcVi2UL3sEWHE70V86u
         8H3TrvzxDGfRSYTZ2IaGBPxcxipebulymZWQijFlbAVuoqwyUB6zFX49wcxEyh0TetWt
         wGOxr/7PHGH1g37elLALfTFi0i8x8YZvXOwRn9+p7Domf8rwFkQjAZkp1ozcciqnrKq+
         /qbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zzRXsJ8b57aKFfe8JdBAqB9CboOpyW2XmPg+dxM7tU4=;
        b=Xiu+1cmuav7tZtLi7R8qOm9SgcjhpAeZ7jqP81eFm2Vk8iXHUHpQzkYxrkdeqMqdC8
         xnQXmMChadzc/y6hkhoF1btzbyKras6qqNEkAOo2Yh3wcISO4HNw2WfdNKWLH772Linf
         t7z4QFnYXEoT+l7WvADh/8RwyxxzurxRy+3oyBSKpLiEB5OwSfa8pywaLg3gZoLdEVRu
         2IvqiwQm23UoN6tdV6qN6kV9HG8xva8CvIVE7sUD2ZSX1lZBFjggz8PARKiruRE6qMBC
         WUbal4OKjMRrntvAQ/zEXAmnmH68bWjI7G2sx+MfxsM8esUAfaVzhbXc8WEWpuPMW2zG
         0I2Q==
X-Gm-Message-State: AGi0PuaO+hho38X49HlY29u2rj+aFQKPUKFgHZqhXZ+rlomDhw/jIyzB
        NMofQt+WU/9UyVbFeLTfnYKnSM/G2zL28Issn6N45a8SxSc=
X-Google-Smtp-Source: APiQypKF2EhQ4hw51G/EytT38hjh8PIR5h5j2eCWCVJWmaqIaMVEoyBbghTWgDqc0QQXlfkBJiFqFRSI3rt4S2OifYw=
X-Received: by 2002:a5b:443:: with SMTP id s3mr17921124ybp.14.1586412610492;
 Wed, 08 Apr 2020 23:10:10 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Apr 2020 01:09:59 -0500
Message-ID: <CAH2r5mta--YFUVWWf89bCBvdjrDh_vaC4ty8Qphsy5W1fDuOYw@mail.gmail.com>
Subject: [PATCH][SMB3.1.1 POSIX] Change noisy debug message to an FYI
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001dba3e05a2d5789e"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001dba3e05a2d5789e
Content-Type: text/plain; charset="UTF-8"

    The noisy posix error message in readdir was supposed
    to be an FYI (not enabled by default)
      CIFS VFS: XXX dev 66306, reparse 0, mode 755


-- 
Thanks,

Steve

--0000000000001dba3e05a2d5789e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-change-noisy-error-message-to-FYI.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-change-noisy-error-message-to-FYI.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k8sd39l00>
X-Attachment-Id: f_k8sd39l00

RnJvbSAyMzI3MzI3MjI3MWZlMjdiN2NmZjliYTlmOTYyYzk4MDRiMTdhYmNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgOSBBcHIgMjAyMCAwMTowNzozOCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGNoYW5nZSBub2lzeSBlcnJvciBtZXNzYWdlIHRvIEZZSQoKVGhlIG5vaXN5IHBvc2l4IGVy
cm9yIG1lc3NhZ2UgaW4gcmVhZGRpciB3YXMgc3VwcG9zZWQKdG8gYmUgYW4gRllJIChub3QgZW5h
YmxlZCBieSBkZWZhdWx0KQogIENJRlMgVkZTOiBYWFggZGV2IDY2MzA2LCByZXBhcnNlIDAsIG1v
ZGUgNzU1CgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvY2lmcy9yZWFkZGlyLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3JlYWRkaXIuYyBi
L2ZzL2NpZnMvcmVhZGRpci5jCmluZGV4IDE5ZTRhNWQzYjRjYS4uNDIzZDg1YzFiYTZmIDEwMDY0
NAotLS0gYS9mcy9jaWZzL3JlYWRkaXIuYworKysgYi9mcy9jaWZzL3JlYWRkaXIuYwpAQCAtMjQ2
LDcgKzI0Niw3IEBAIGNpZnNfcG9zaXhfdG9fZmF0dHIoc3RydWN0IGNpZnNfZmF0dHIgKmZhdHRy
LCBzdHJ1Y3Qgc21iMl9wb3NpeF9pbmZvICppbmZvLAogCSAqLwogCWZhdHRyLT5jZl9tb2RlID0g
bGUzMl90b19jcHUoaW5mby0+TW9kZSkgJiB+U19JRk1UOwogCi0JY2lmc19kYmcoVkZTLCAiWFhY
IGRldiAlZCwgcmVwYXJzZSAlZCwgbW9kZSAlbyIsCisJY2lmc19kYmcoRllJLCAiWFhYIGRldiAl
ZCwgcmVwYXJzZSAlZCwgbW9kZSAlbyIsCiAJCSBsZTMyX3RvX2NwdShpbmZvLT5EZXZpY2VJZCks
CiAJCSBsZTMyX3RvX2NwdShpbmZvLT5SZXBhcnNlVGFnKSwKIAkJIGxlMzJfdG9fY3B1KGluZm8t
Pk1vZGUpKTsKLS0gCjIuMjAuMQoK
--0000000000001dba3e05a2d5789e--
