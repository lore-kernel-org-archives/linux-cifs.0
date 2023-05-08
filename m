Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5841AC77B75
	for <linux-cifs@archiver.kernel.org>; Mon,  8 May 2023 05:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjEHFzU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 May 2023 01:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbjEHFzO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 May 2023 01:55:14 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546BE19928
        for <linux-cifs@vger.kernel.org>; Sun,  7 May 2023 22:54:39 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2ac7f53ae44so45416221fa.2
        for <linux-cifs@vger.kernel.org>; Sun, 07 May 2023 22:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683525277; x=1686117277;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n5Wlr942xG6CSd7qeermfDWDJpBeBmtqBNdlbqseiHQ=;
        b=KfOhrb6TYL5AqNyij/DNYL/LpxlnxVk79i+vGEjdNhEQAESQfmOcAhiZk+QCVv8u2v
         +0/gwyi6aMIct//fu2Co/wYts9SfsyssRZHKd6/H/ZwXjG2Fk0IP27R9BB+MFMtDaJNG
         YCXVv7iRmIRulQKiE7yApmq+rSQgq6rJ5naKCLzLDruXCVAsWMt3Qi/fpTAmYNcgq4G4
         zb4D2/3qfhBVhwkD7u0HjheiiBQIygKXQkztcYU0kq31AAadPiKwtCSOomhl+htmWOCF
         5RjP2OJ0DR2AOzKEBkgTb/WZ4dI0Lgwjb5QshxpNF+UJY4DjcFoBP1qx6IFoqkv6pMvq
         fF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683525277; x=1686117277;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n5Wlr942xG6CSd7qeermfDWDJpBeBmtqBNdlbqseiHQ=;
        b=aWPf7TyAeiNrfYPYlK7p1LM0JgrYZl2I+m4Ca9u1luzTAqOh8qknxqKI5DJ4PDaqg4
         CXzK7i4REy/2/NVJpbTi/dUC5A0gvQ29jllu01lIU8ZKfef9LecOwUlNlGR75GlJTVJS
         EU/9ZtRO6rIkjhbMVcukHidskthycqG2KLYUUwxoSmHFRQJbF3pfzZZdEL7sdfGI0aPJ
         97lMyKTrdrjRJ7R7tWw3Bp2H9JjGLbWfaF5lBYVAcmUFMTbH0tjTp9kMaqnq/hBcPWEO
         W8X98RaBzrblhq3m1ldBtLC6ocFXKGfnBPCgIMO5s/aUzb5zM7wgFek53AfffD3+Cqll
         YKLg==
X-Gm-Message-State: AC+VfDzxulIGk2TcKwLEWbO8SxmYSrDVtn+d5ipvbyIND0br9dvI0qFy
        idUj0n+VqsxqHDx+PHmo1VHBSWXnF5jlsTEj6uCl0+5e2YIzog==
X-Google-Smtp-Source: ACHHUZ6lAJT9X6v6h9G1L0ruYoBpBWFO2XSwfjKwyLwtVPbZX9IBZnfditGYvRCM4QCJactRqXDs25fOgKOO1GYa7YM=
X-Received: by 2002:a2e:9c13:0:b0:2ad:814c:6ad5 with SMTP id
 s19-20020a2e9c13000000b002ad814c6ad5mr1296808lji.46.1683525277026; Sun, 07
 May 2023 22:54:37 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 8 May 2023 00:54:25 -0500
Message-ID: <CAH2r5mug_RmfmdBJqpzofB36wAHx4MVC0kO2G80ft7m13tx_Zg@mail.gmail.com>
Subject: [PATCH][CIFS] smb3: improve parallel reads of large files
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000001bf2f105fb2846af"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001bf2f105fb2846af
Content-Type: text/plain; charset="UTF-8"

rasize (ra_pages) should be set higher than read size by default
to allow parallel reads when reading large files in order to
improve performance (otherwise there is much dead time on the
network when doing readahead of large files).  Default rasize
to twice readsize.  See attached patch

This improved performance for me (although there may be cases where
setting it more than 2*read_size still could help).  ceph IIRC sets
ra_pages even higher (to 8MB by default).   Any thoughts?



-- 
Thanks,

Steve

--0000000000001bf2f105fb2846af
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-improve-parallel-reads-of-large-files.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-improve-parallel-reads-of-large-files.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lhefdbw30>
X-Attachment-Id: f_lhefdbw30

RnJvbSA2OGFhYzg1YjliNjk3Y2ZjMWRjMTI4NmY1OTZlYmJkZGI5YWUzYzU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgOCBNYXkgMjAyMyAwMDo0NTo0NSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGltcHJvdmUgcGFyYWxsZWwgcmVhZHMgb2YgbGFyZ2UgZmlsZXMKCnJhc2l6ZSAocmFfcGFn
ZXMpIHNob3VsZCBiZSBzZXQgaGlnaGVyIHRoYW4gcmVhZCBzaXplIGJ5IGRlZmF1bHQKdG8gYWxs
b3cgcGFyYWxsZWwgcmVhZHMgd2hlbiByZWFkaW5nIGxhcmdlIGZpbGVzIGluIG9yZGVyIHRvCmlt
cHJvdmUgcGVyZm9ybWFuY2UgKG90aGVyd2lzZSB0aGVyZSBpcyBtdWNoIGRlYWQgdGltZSBvbiB0
aGUKbmV0d29yayB3aGVuIGRvaW5nIHJlYWRhaGVhZCBvZiBsYXJnZSBmaWxlcykuICBEZWZhdWx0
IHJhc2l6ZQp0byB0d2ljZSByZWFkc2l6ZS4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8
c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNmcy5jIHwgMiArLQogMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9jaWZzZnMuYyBiL2ZzL2NpZnMvY2lmc2ZzLmMKaW5kZXggMzJmN2M4MWE3Yjg5Li44
MTQzMGFiYWNmOTMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lmcy9j
aWZzZnMuYwpAQCAtMjQ2LDcgKzI0Niw3IEBAIGNpZnNfcmVhZF9zdXBlcihzdHJ1Y3Qgc3VwZXJf
YmxvY2sgKnNiKQogCWlmIChjaWZzX3NiLT5jdHgtPnJhc2l6ZSkKIAkJc2ItPnNfYmRpLT5yYV9w
YWdlcyA9IGNpZnNfc2ItPmN0eC0+cmFzaXplIC8gUEFHRV9TSVpFOwogCWVsc2UKLQkJc2ItPnNf
YmRpLT5yYV9wYWdlcyA9IGNpZnNfc2ItPmN0eC0+cnNpemUgLyBQQUdFX1NJWkU7CisJCXNiLT5z
X2JkaS0+cmFfcGFnZXMgPSAyICogKGNpZnNfc2ItPmN0eC0+cnNpemUgLyBQQUdFX1NJWkUpOwog
CiAJc2ItPnNfYmxvY2tzaXplID0gQ0lGU19NQVhfTVNHU0laRTsKIAlzYi0+c19ibG9ja3NpemVf
Yml0cyA9IDE0OwkvKiBkZWZhdWx0IDIqKjE0ID0gQ0lGU19NQVhfTVNHU0laRSAqLwotLSAKMi4z
NC4xCgo=
--0000000000001bf2f105fb2846af--
