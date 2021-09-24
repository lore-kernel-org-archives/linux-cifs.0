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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11E7C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 01:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B006E604E9
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 01:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbhIXBb3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243687AbhIXBb1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 21:31:27 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EFFC061574
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 18:29:55 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id i25so33959519lfg.6
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 18:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MQB1T3OI4It7OQOitVxT9q/vfN0GZXtleHPC+c0MnjQ=;
        b=gjVSGOMWO38OOmxjWTVllfpjuScLCkXJgZ4K8c7Gt8a5Mz5uMb40bQM9EYJtXuCjWG
         NUQj0J2beyfkC3dskf9+HHoRDV0+zCnK4plfzxNFjwiao6TMcDse+/Ci1Erp9RMkF5tf
         r6mzh+kL7fkuDyz1GzMURXjtKDurFdccEbQgeGfIe5s9jGV1fEcnrtrDye+6OunYafTt
         j7w2walhmvdaso1xHjswKXljdhpFMP+zuMdCl9h1p6YPHHrgUaFUCyVY4Ky26xdC9u4q
         wzoJW0D7GcrQbRyxlBl75ROBG2NhRQdHJ++ocylAX56ytaEamWr1UIyO3ubw3wk++ISZ
         7Qug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MQB1T3OI4It7OQOitVxT9q/vfN0GZXtleHPC+c0MnjQ=;
        b=uVl13UJSk0BHFFwXxENa1YCHXQ06aQceMFRc8WoBfzvJSzDch4y1rKEXyFMQKTv8Kf
         9zz244eY1e2RU736hjSKFE9b4AnE9ebXY0DFgjFRsfntHKO95aVUMxv+c3h3IIaSkhsi
         Rt8M9eW7vxYcQqhdDdHrjMac4q5Q0dY8ZtXqEAKEWxH3ruHdfi8TyAo+vKZNoZvwJV1M
         u6KoyVBhc2ktMRhkBL1op3CY2ZfsBDIwv8kBVCpC9CC/cmMhW6rYH3ldmrifVDgicx53
         4MuFlqbRlY/05L/2s9cDP8PGkIXW0STEkw78gHJlHnrxP/SB5pYUCbiKatAbquqQ7PGr
         KLqQ==
X-Gm-Message-State: AOAM532t26HQQUNEjfHcRuFXH58Dab/UW1EePLAjGS+j88N+5ly9Rr5W
        mls4BhbdC4qnpShO7Q4Aru0jzfVz1K+ZrFVgCNt2uETz
X-Google-Smtp-Source: ABdhPJwDNOFLXAuP4l6KiT4pBwJhVllYTINo+Do5acNVOcav4BwYsPHBaDzOxbbxuQ9xgDT2XD+tMvjszNnm8gBQYqw=
X-Received: by 2002:a2e:1652:: with SMTP id 18mr8395927ljw.23.1632446992430;
 Thu, 23 Sep 2021 18:29:52 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 23 Sep 2021 20:29:41 -0500
Message-ID: <CAH2r5mt6whs+-2LKYCZ_jHpFY27mK84gAJZqqOLCx4ReB62fEw@mail.gmail.com>
Subject: Two more CIFS patches pointed out by Dan Carpenter using smatch
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: multipart/mixed; boundary="00000000000019578105ccb3afdb"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000019578105ccb3afdb
Content-Type: text/plain; charset="UTF-8"

Marked one of them for stable.  Both small and seem like low risk fixes.

See attached.

-- 
Thanks,

Steve

--00000000000019578105ccb3afdb
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-correct-server-pointer-dereferencing-check-to-b.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-correct-server-pointer-dereferencing-check-to-b.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ktxormr40>
X-Attachment-Id: f_ktxormr40

RnJvbSA4ZDFlOWI4YjFhMzgzZWQ3NzQxN2I1YTA3YmEzNzg5NDEzZjhiN2Y3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjMgU2VwIDIwMjEgMTg6NTI6NDAgLTA1MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gc21iMzogY29ycmVjdCBzZXJ2ZXIgcG9pbnRlciBkZXJlZmVyZW5jaW5nIGNoZWNrIHRvIGJl
CiBtb3JlIGNvbnNpc3RlbnQKCkFkZHJlc3Mgd2FybmluZzoKCiAgICBmcy9zbWJmc19jbGllbnQv
bWlzYy5jOjI3MyBoZWFkZXJfYXNzZW1ibGUoKQogICAgd2FybjogdmFyaWFibGUgZGVyZWZlcmVu
Y2VkIGJlZm9yZSBjaGVjayAndHJlZUNvbi0+c2VzLT5zZXJ2ZXInCgpQb2ludGVkIG91dCBieSBE
YW4gQ2FycGVudGVyIHZpYSBzbWF0Y2ggY29kZSBhbmFseXNpcyB0b29sCgpBbHRob3VnaCB0aGUg
Y2hlY2sgaXMgbGlrZWx5IHVubmVlZGVkLCBhZGRpbmcgaXQgbWFrZXMgdGhlIGNvZGUKbW9yZSBj
b25zaXN0ZW50IGFuZCBlYXNpZXIgdG8gcmVhZCwgYXMgdGhlIHNhbWUgY2hlY2sgaXMKZG9uZSBl
bHNld2hlcmUgaW4gdGhlIGZ1bmN0aW9uLgoKUmVwb3J0ZWQtYnk6IERhbiBDYXJwZW50ZXIgPGRh
bi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZy
ZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvbWlzYy5jIHwgMyArKy0KIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9j
aWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5jCmluZGV4IGYyOTE2YjUxNjUyYS4uYmIxMTg1ZmZm
OGNjIDEwMDY0NAotLS0gYS9mcy9jaWZzL21pc2MuYworKysgYi9mcy9jaWZzL21pc2MuYwpAQCAt
MjY0LDcgKzI2NCw4IEBAIGhlYWRlcl9hc3NlbWJsZShzdHJ1Y3Qgc21iX2hkciAqYnVmZmVyLCBj
aGFyIHNtYl9jb21tYW5kIC8qIGNvbW1hbmQgKi8gLAogCiAJCQkvKiBVaWQgaXMgbm90IGNvbnZl
cnRlZCAqLwogCQkJYnVmZmVyLT5VaWQgPSB0cmVlQ29uLT5zZXMtPlN1aWQ7Ci0JCQlidWZmZXIt
Pk1pZCA9IGdldF9uZXh0X21pZCh0cmVlQ29uLT5zZXMtPnNlcnZlcik7CisJCQlpZiAodHJlZUNv
bi0+c2VzLT5zZXJ2ZXIpCisJCQkJYnVmZmVyLT5NaWQgPSBnZXRfbmV4dF9taWQodHJlZUNvbi0+
c2VzLT5zZXJ2ZXIpOwogCQl9CiAJCWlmICh0cmVlQ29uLT5GbGFncyAmIFNNQl9TSEFSRV9JU19J
Tl9ERlMpCiAJCQlidWZmZXItPkZsYWdzMiB8PSBTTUJGTEcyX0RGUzsKLS0gCjIuMzAuMgoK
--00000000000019578105ccb3afdb
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-cifs-fix-incorrect-check-for-null-pointer-in-header_.patch"
Content-Disposition: attachment; 
	filename="0002-cifs-fix-incorrect-check-for-null-pointer-in-header_.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ktxormt51>
X-Attachment-Id: f_ktxormt51

RnJvbSA1NjEzNGEwNDMyNzEwYWYxZWM0OGU0YmQxY2VkNWVjZDExMjYwY2I0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjMgU2VwIDIwMjEgMTk6MTg6MzcgLTA1MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gY2lmczogZml4IGluY29ycmVjdCBjaGVjayBmb3IgbnVsbCBwb2ludGVyIGluCiBoZWFkZXJf
YXNzZW1ibGUKCkFsdGhvdWdoIHZlcnkgdW5saWtlbHkgdGhhdCB0aGUgdGxpbmsgcG9pbnRlciB3
b3VsZCBiZSBudWxsIGluIHRoaXMgY2FzZSwKZ2V0X25leHRfbWlkIGZ1bmN0aW9uIGNhbiBpbiB0
aGVvcnkgcmV0dXJuIG51bGwgKGJ1dCBub3QgYW4gZXJyb3IpCnNvIG5lZWQgdG8gY2hlY2sgZm9y
IG51bGwgKG5vdCBmb3IgSVNfRVJSLCB3aGljaCBjYW4gbm90IGJlIHJldHVybmVkCmhlcmUpLgoK
QWRkcmVzcyB3YXJuaW5nOgoKICAgICAgICBmcy9zbWJmc19jbGllbnQvY29ubmVjdC5jOjIzOTIg
Y2lmc19tYXRjaF9zdXBlcigpCiAgICAgICAgd2FybjogJ3RsaW5rJyBpc24ndCBhbiBFUlJfUFRS
CgpQb2ludGVkIG91dCBieSBEYW4gQ2FycGVudGVyIHZpYSBzbWF0Y2ggY29kZSBhbmFseXNpcyB0
b29sCgpDQzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpSZXBvcnRlZC1ieTogRGFuIENhcnBlbnRl
ciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0LmMgfCA1ICsrKy0t
CiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggNzg4MTEx
NWNmYmVlLi5jM2I5NGMxZTQ1OTEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBi
L2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0yMzg5LDkgKzIzODksMTAgQEAgY2lmc19tYXRjaF9zdXBl
cihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCB2b2lkICpkYXRhKQogCXNwaW5fbG9jaygmY2lmc190
Y3Bfc2VzX2xvY2spOwogCWNpZnNfc2IgPSBDSUZTX1NCKHNiKTsKIAl0bGluayA9IGNpZnNfZ2V0
X3RsaW5rKGNpZnNfc2JfbWFzdGVyX3RsaW5rKGNpZnNfc2IpKTsKLQlpZiAoSVNfRVJSKHRsaW5r
KSkgeworCWlmICh0bGluayA9PSBOVUxMKSB7CisJCS8qIGNhbiBub3QgbWF0Y2ggc3VwZXJibG9j
ayBpZiB0bGluayB3ZXJlIGV2ZXIgbnVsbCAqLwogCQlzcGluX3VubG9jaygmY2lmc190Y3Bfc2Vz
X2xvY2spOwotCQlyZXR1cm4gcmM7CisJCXJldHVybiAwOwogCX0KIAl0Y29uID0gdGxpbmtfdGNv
bih0bGluayk7CiAJc2VzID0gdGNvbi0+c2VzOwotLSAKMi4zMC4yCgo=
--00000000000019578105ccb3afdb--
