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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6AAC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 20:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A17561211
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 20:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243078AbhIWUqn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 16:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhIWUqn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 16:46:43 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D073C061574
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 13:45:11 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id y28so30865114lfb.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 13:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=eYqxMGBzLMPUFkc/XnV3n4Wo1Y/eFNpHTDl68ugcuKI=;
        b=nXFcR4YDtzkTLrt80Z2skbcF3domDdUOefPWslpwyIucgwhhmnujn353+k1Z+oVzj8
         Sx6chGl4EDR2JnN/P66X4Ux/ugTVp7UypJy4nhowU6L0FPx9O4+OcQIDODgP4llaCP1x
         DHBuCVAEjXBcoEWWwcuCysEPf4fXFQgfIHW2AjtraqsKijJf2L/1fX9q9zBfVLhSFFqA
         lM9jqcd4v9e/2pGzDU/ebeOaW8EO/xj2DH0P6bV7NWJ+rD9F3rkNMqBq3re+G8fjyGd7
         vNSvvKciECM1ZQwf/V2cdJx2YhI/GEij40IIdeJCe4aNn97T4dI12wnKKP8DC0jlNzL/
         Nf8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=eYqxMGBzLMPUFkc/XnV3n4Wo1Y/eFNpHTDl68ugcuKI=;
        b=mM7C41gTzxy6fwUMgwSo3sL1wAdJnCkMlyQWs4jhfzswhIvxgcqAfY8HaWdhleQGhl
         gZijeZqJWAPP6jtXPjPTsRXImU3gYdBJamu0EKI/1p8SA2MeHJtWwH/O9HcgVClPCmLR
         Ni04P6ieJ5+iVObf2jIQyapTyAPtvFxkE3QsbwTmE3RmH63Di2N99rMgiQPQNmH9mVec
         /XhWFhBkJVNl4CQsX+tzHdpYiYtAs77QmWNep5YikH/LGDnj4GUo92wkbEhz5RNAeYbc
         TxEinJj+wIVCXxLPg5zl8k5zvz2/H2/w53Jkw8+CZMgXacqkK3Kki/50cQIWZATTLTPL
         3LdA==
X-Gm-Message-State: AOAM531jgPArnsJfXOV8GQZkDBe84zFJA0FX3SpyLEYIRHr1P26Jx/yT
        6UNGvb58lURhkZpErg4v15i+s4G+gJkPGMYuonw7NPCk8+U=
X-Google-Smtp-Source: ABdhPJwGv1aKCTtkLppoI0GF6+p0vLUh+vL2t8oHrkEfy7st+tWdB8icrjPkE7RzFTgqybkRthJAX4vLGbx0EQFN3L4=
X-Received: by 2002:a2e:a78d:: with SMTP id c13mr7322160ljf.314.1632429909132;
 Thu, 23 Sep 2021 13:45:09 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 23 Sep 2021 15:44:58 -0500
Message-ID: <CAH2r5mtJMSL39-19t_s8znmRC3UaCnhv1MRGdWJrLrDJqOU+JA@mail.gmail.com>
Subject: [PATCH][CIFS] Clear modified attribute bit from inode flags
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     rohiths msft <rohiths.msft@gmail.com>, Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="000000000000dae09105ccafb48d"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000dae09105ccafb48d
Content-Type: text/plain; charset="UTF-8"

Added Cc: stable@vger.kernel.org # 5.13+ since it fixes a problem with
git regression tests and deferred close (which went in 5.13).and
merged into cifs-2.6.git for-next pending testing

See attached.

    Clear CIFS_INO_MODIFIED_ATTR bit from inode flags after
    updating mtime and ctime




-- 
Thanks,

Steve

--000000000000dae09105ccafb48d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Clear-modified-attribute-bit-from-inode-flags.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Clear-modified-attribute-bit-from-inode-flags.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ktxeljdq0>
X-Attachment-Id: f_ktxeljdq0

RnJvbSAyMzNjYTE2NmEyMTYyOWIzYzg4NGY1ZDc2NGFmOTM0NTVmZGI4NjM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjMgU2VwIDIwMjEgMTI6NDI6MzUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBDbGVhciBtb2RpZmllZCBhdHRyaWJ1dGUgYml0IGZyb20gaW5vZGUgZmxhZ3MKCkNsZWFy
IENJRlNfSU5PX01PRElGSUVEX0FUVFIgYml0IGZyb20gaW5vZGUgZmxhZ3MgYWZ0ZXIKdXBkYXRp
bmcgbXRpbWUgYW5kIGN0aW1lCgpTaWduZWQtb2ZmLWJ5OiBSb2hpdGggU3VyYWJhdHR1bGEgPHJv
aGl0aHNAbWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFBhdWxvIEFsY2FudGFyYSAoU1VTRSkg
PHBjQGNqci5uej4KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyA1LjEzKwpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9m
aWxlLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5jCmluZGV4IDBh
YjViYjI0YjhjYS4uMTNmMzE4MmNmNzk2IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUuYworKysg
Yi9mcy9jaWZzL2ZpbGUuYwpAQCAtODg0LDcgKzg4NCw3IEBAIGludCBjaWZzX2Nsb3NlKHN0cnVj
dCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogCQkgICAgY2lub2RlLT5sZWFzZV9n
cmFudGVkICYmCiAJCSAgICAhdGVzdF9iaXQoQ0lGU19JTk9fQ0xPU0VfT05fTE9DSywgJmNpbm9k
ZS0+ZmxhZ3MpICYmCiAJCSAgICBkY2xvc2UpIHsKLQkJCWlmICh0ZXN0X2JpdChDSUZTX0lOT19N
T0RJRklFRF9BVFRSLCAmY2lub2RlLT5mbGFncykpIHsKKwkJCWlmICh0ZXN0X2FuZF9jbGVhcl9i
aXQoQ0lGU19JTk9fTU9ESUZJRURfQVRUUiwgJmNpbm9kZS0+ZmxhZ3MpKSB7CiAJCQkJaW5vZGUt
PmlfY3RpbWUgPSBpbm9kZS0+aV9tdGltZSA9IGN1cnJlbnRfdGltZShpbm9kZSk7CiAJCQkJY2lm
c19mc2NhY2hlX3VwZGF0ZV9pbm9kZV9jb29raWUoaW5vZGUpOwogCQkJfQotLSAKMi4zMC4yCgo=
--000000000000dae09105ccafb48d--
