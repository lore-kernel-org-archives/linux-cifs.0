Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2F3C07E95
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 00:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 724746136E
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 00:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbhGNAvj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Jul 2021 20:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbhGNAvj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Jul 2021 20:51:39 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87090C0613DD
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 17:48:48 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id y42so528057lfa.3
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 17:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=42KWca6eNuXtcoPPSYzkMkreLs0lgHPNn4GnIBPajs8=;
        b=ALpE/hH5ypXs2f5mXTtkKA86IamdKkIAySl7J5fYOrRdBgi3Roqn80WPhlczymS/5b
         9UYFw8Xqn60EZ4tA3W8KnhBrMqbwbzRQphUgcKYn2gNvYqLl+qR9muQ+bnwl+c84bYKc
         nkHO022t5jQgLedWo+JmilAjabwtrjdshLwplr0HXrtQXQvpa6E9ABkcUhdxxHr1DeqE
         8sr7yBIbp6hqj+khYY2bxeQ4K/lfe6mj2cTx4tsN3thEolTOscvu3wkBXh+1o9+MMpTN
         ks7dVfFYtip9KV09nG04yfDzUAbAfQTQoHQPqFgddbaBeWyHdvYYX2WdymIrQxa7miUP
         eD+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=42KWca6eNuXtcoPPSYzkMkreLs0lgHPNn4GnIBPajs8=;
        b=n8ZDOQ/98qaDnRfWyVwJ8g2z67PPsx3rosxnH8Xq2yIh1x8SK9Xiu6/R9JGykR/6Gr
         9GiZahNQrCL8+Q9asZDVsVlaqdRu9gpQ2oCUxBYUpRwG3JnrP+R4KWNZdqj3LdIPuyLy
         zSJzvO1aq7miRIcVjPkUVj7m4VoUkVCvvA7f62uOhksd1TmGTjTnnGT+Ieox76VyfJxP
         oEa8P/+2jjUy0FNB9uvhjdXhJCrtSMAsaaFKiFow0wHYYfKLcWtX3DaTucQkB3gKbwds
         hKo45ZNVLXfoXDngQi1HnUFrZPzEKcvRvqKfOY2LLX82VBKCHbR3D7+x8ceXgPaypeMO
         uyzA==
X-Gm-Message-State: AOAM531GorZkhT7TI51EyK+vUwjNoTrMynnETfdwZoXoNBUGwkY1P3RK
        EcllmoMyd2r2rN8x79PUn7SY5qifsVjWD12FJBOr6Eu48RZgww==
X-Google-Smtp-Source: ABdhPJzjI2CerCpGlOJ9x5Swl5JZsMWjilPjXswTxYMCSrfR7bkIcyAFNbTP9/PhRvWm/b6i0nX4DHezib0mpqKLVps=
X-Received: by 2002:a05:6512:604:: with SMTP id b4mr5733591lfe.184.1626223725600;
 Tue, 13 Jul 2021 17:48:45 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 13 Jul 2021 19:48:34 -0500
Message-ID: <CAH2r5mtHpjjVVKFYKEkAZHG5U=-_umHwMhF2KDJjDSNgoa=Fxw@mail.gmail.com>
Subject: [PATCH] cifs: fix missing null session check in mount
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="0000000000007d7ad905c70ab747"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007d7ad905c70ab747
Content-Type: text/plain; charset="UTF-8"

Although it is unlikely to be have ended up with a null
session pointer calling cifs_try_adding_channels in cifs_mount.
Coverity correctly notes that we are already checking for
it earlier (when we return from do_dfs_failover), so at
a minimum to clarify the code we should make sure we also
check for it when we exit the loop so we don't end up calling
cifs_try_adding_channels or mount_setup_tlink with a null
ses pointer.

Addresses-Coverity: 1505608 ("Derefernce after null check")
Reviewed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index db6c607269f5..463cae116c12 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3577,7 +3577,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb,
struct smb3_fs_context *ctx)
  rc = -ELOOP;
  } while (rc == -EREMOTE);

- if (rc || !tcon)
+ if (rc || !tcon || !ses)
  goto error;

  kfree(ref_path);

-- 
Thanks,

Steve

--0000000000007d7ad905c70ab747
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-missing-null-session-check-in-mount.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-missing-null-session-check-in-mount.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kr2rlz010>
X-Attachment-Id: f_kr2rlz010

RnJvbSA4Yjc1NWFkMzhjNzJkMmRjMzlmZDZlOTExMGQwM2FhMTMyNDk4NTcxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTMgSnVsIDIwMjEgMTk6NDA6MzMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggbWlzc2luZyBudWxsIHNlc3Npb24gY2hlY2sgaW4gbW91bnQKCkFsdGhvdWdoIGl0
IGlzIHVubGlrZWx5IHRvIGJlIGhhdmUgZW5kZWQgdXAgd2l0aCBhIG51bGwKc2Vzc2lvbiBwb2lu
dGVyIGNhbGxpbmcgY2lmc190cnlfYWRkaW5nX2NoYW5uZWxzIGluIGNpZnNfbW91bnQuCkNvdmVy
aXR5IGNvcnJlY3RseSBub3RlcyB0aGF0IHdlIGFyZSBhbHJlYWR5IGNoZWNraW5nIGZvcgppdCBl
YXJsaWVyICh3aGVuIHdlIHJldHVybiBmcm9tIGRvX2Rmc19mYWlsb3ZlciksIHNvIGF0CmEgbWlu
aW11bSB0byBjbGFyaWZ5IHRoZSBjb2RlIHdlIHNob3VsZCBtYWtlIHN1cmUgd2UgYWxzbwpjaGVj
ayBmb3IgaXQgd2hlbiB3ZSBleGl0IHRoZSBsb29wIHNvIHdlIGRvbid0IGVuZCB1cCBjYWxsaW5n
CmNpZnNfdHJ5X2FkZGluZ19jaGFubmVscyBvciBtb3VudF9zZXR1cF90bGluayB3aXRoIGEgbnVs
bApzZXMgcG9pbnRlci4KCkFkZHJlc3Nlcy1Db3Zlcml0eTogMTUwNTYwOCAoIkRlcmVmZXJuY2Ug
YWZ0ZXIgbnVsbCBjaGVjayIpClJldmlld2VkLWJ5OiBQYXVsbyBBbGNhbnRhcmEgKFNVU0UpIDxw
Y0BjanIubno+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5j
IGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggZGI2YzYwNzI2OWY1Li40NjNjYWUxMTZjMTIgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0z
NTc3LDcgKzM1NzcsNyBAQCBpbnQgY2lmc19tb3VudChzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZz
X3NiLCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpCiAJCQlyYyA9IC1FTE9PUDsKIAl9IHdo
aWxlIChyYyA9PSAtRVJFTU9URSk7CiAKLQlpZiAocmMgfHwgIXRjb24pCisJaWYgKHJjIHx8ICF0
Y29uIHx8ICFzZXMpCiAJCWdvdG8gZXJyb3I7CiAKIAlrZnJlZShyZWZfcGF0aCk7Ci0tIAoyLjMw
LjIKCg==
--0000000000007d7ad905c70ab747--
