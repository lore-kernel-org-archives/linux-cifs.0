Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42A3C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Nov 2021 19:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B476D60FE7
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Nov 2021 19:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhKLTQN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Nov 2021 14:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbhKLTQM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Nov 2021 14:16:12 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624E6C061766
        for <linux-cifs@vger.kernel.org>; Fri, 12 Nov 2021 11:13:21 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id m27so343073lfj.12
        for <linux-cifs@vger.kernel.org>; Fri, 12 Nov 2021 11:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=2ME2XxSedMtGMH3gWRIcGR0XC5Xt7Rmzvk2hCvjwdz8=;
        b=pomQorS5cfLvCOLmjPYTBuUMUC1GjDR9S+gf9l6pAXQeVwTgsuktOQjKwesoDRGxSJ
         RmzVb3TMHBhQWPzCfPMjrPT1I19OCnjaR1FU+bulK6vmy7tA4iEEuSN7ZV+DSpivKqyz
         rwTq+nFxpm4fkDnr4f9wg5Ki6V/aZtB7GhC/0sLTFPv49ypJ0DEGdbtIcNEjuxG+eLs2
         vmUkZKj0CAsd2wKutzfTRxhzrsxXxogeaZj1FfsRi0GCFCq9FqyG1NvneJLsANLMqZ5n
         rVvLOa7g0zbCGCaHAQlTLh0184wh+stphHB1eGgtlarWc+S0EoFznUPy5f4ZgueC2lR6
         3+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=2ME2XxSedMtGMH3gWRIcGR0XC5Xt7Rmzvk2hCvjwdz8=;
        b=cGP+AgM7ViIM0SZZrxkMJWPjh8GqLNJtnWoefIghA1ea7x55A64qE0CBxNfdWZ00tR
         yOp4XXng9ot050tXzm0p6zkvbRD4qB9o2b1F9W1iORj7Kk/xUU4M96PkocRtvJMPtdLr
         TPpkueFDUWol2/5pDRdZy6Gqf907J7EkWzDxahGa/0dygFeGq57t2vn/owk++Vw147Uh
         bpc+yR0pnG/iDAbLf+VNUWHT231aZCxCOde3PAg6kYpYxCoqxucVmzzekgG8ZCR1stbc
         YUr88+1/UU/EzKk9/O0YwA1Cl5WSaRMEbKXTN5TKH8SQjQsv+rhZknU9HMgL1iNJmmhB
         Qy8g==
X-Gm-Message-State: AOAM531ui+ejDYxUI4yoknh+PXQfVwm1HnVKMfkO4qYCMCUVgdAz95C/
        3qfeQ0Ea0OVlEiLvjX+PKLF6ViNeJeU2VQi5EmNmfPsj
X-Google-Smtp-Source: ABdhPJyvQAZjSvt6cHYzTI7MOfHi+dyrO5FwoAXd2K289vDpQgoUHwWnNY7t1OhWHgE+FpZGskUHjbAi3zg8t0KgNtU=
X-Received: by 2002:a05:6512:3991:: with SMTP id j17mr15841937lfu.545.1636744399529;
 Fri, 12 Nov 2021 11:13:19 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 12 Nov 2021 13:13:08 -0600
Message-ID: <CAH2r5mvxEjaOjn7RFdi4uXR4kO-ts-8xVMg7+D5m60G0NR_cWg@mail.gmail.com>
Subject: [PATCH] updated version of the get_fscache_super_cookie fix
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="00000000000085c34305d09c40c0"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000085c34305d09c40c0
Content-Type: text/plain; charset="UTF-8"

Had a build issue when DFS was disabled in the build - fixed in attached.



-- 
Thanks,

Steve

--00000000000085c34305d09c40c0
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-do-not-setup-the-fscache_super_cookie-until-fsi.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-do-not-setup-the-fscache_super_cookie-until-fsi.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvwrcj8n0>
X-Attachment-Id: f_kvwrcj8n0

RnJvbSAwMjEwMjc0NGQzNjRjMWJjYTRhMGRhMTNjMmE3MjY1NjAzN2Y2NGViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTAgTm92IDIwMjEgMDM6MTU6MjkgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkbyBub3Qgc2V0dXAgdGhlIGZzY2FjaGVfc3VwZXJfY29va2llIHVudGlsIGZzaW5mbwog
aW5pdGlhbGl6ZWQKCldlIHdlcmUgY2FsbGluZyBjaWZzX2ZzY2FjaGVfZ2V0X3N1cGVyX2Nvb2tp
ZSBhZnRlciB0Y29uIGJ1dCBiZWZvcmUKd2UgcXVlcmllZCB0aGUgaW5mbyAoUUZTX0luZm8pIHdl
IG5lZWQgdG8gaW5pdGlhbGl6ZSB0aGUgY29va2llCnByb3Blcmx5LiAgQWxzbyBpbmNsdWRlcyBh
biBhZGRpdGlvbmFsIGNoZWNrIHN1Z2dlc3RlZCBieSBQYXVsbwp0byBtYWtlIHN1cmUgd2UgZG9u
J3QgaW5pdGlhbGl6ZSBzdXBlciBjb29raWUgdHdpY2UuCgpTdWdnZXN0ZWQtYnk6IERhdmlkIEhv
d2VsbHMgPGRob3dlbGxzQHJlZGhhdC5jb20+ClJldmlld2VkLWJ5OiBQYXVsbyBBbGNhbnRhcmEg
KFNVU0UpIDxwY0BjanIubno+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hA
bWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDggKysrKysrLS0KIGZzL2Np
ZnMvZnNjYWNoZS5jIHwgOCArKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMv
Y2lmcy9jb25uZWN0LmMKaW5kZXggNWM1MDZmNmVjZDY1Li4wODQ2MDVmN2NlOTYgMTAwNjQ0Ci0t
LSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0yMzUwLDgg
KzIzNTAsNiBAQCBjaWZzX2dldF90Y29uKHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBzdHJ1Y3Qgc21i
M19mc19jb250ZXh0ICpjdHgpCiAJbGlzdF9hZGQoJnRjb24tPnRjb25fbGlzdCwgJnNlcy0+dGNv
bl9saXN0KTsKIAlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCi0JY2lmc19mc2Nh
Y2hlX2dldF9zdXBlcl9jb29raWUodGNvbik7Ci0KIAlyZXR1cm4gdGNvbjsKIAogb3V0X2ZhaWw6
CkBAIC0zMDAzLDYgKzMwMDEsMTIgQEAgc3RhdGljIGludCBtb3VudF9nZXRfY29ubnMoc3RydWN0
IG1vdW50X2N0eCAqbW50X2N0eCkKIAkJCQljaWZzX2RiZyhWRlMsICJyZWFkIG9ubHkgbW91bnQg
b2YgUlcgc2hhcmVcbiIpOwogCQkJLyogbm8gbmVlZCB0byBsb2cgYSBSVyBtb3VudCBvZiBhIHR5
cGljYWwgUlcgc2hhcmUgKi8KIAkJfQorCQkvKgorCQkgKiBUaGUgY29va2llIGlzIGluaXRpYWxp
emVkIGZyb20gdm9sdW1lIGluZm8gcmV0dXJuZWQgYWJvdmUuCisJCSAqIEluc2lkZSBjaWZzX2Zz
Y2FjaGVfZ2V0X3N1cGVyX2Nvb2tpZSBpdCBjaGVja3MKKwkJICogdGhhdCB3ZSBkbyBub3QgZ2V0
IHN1cGVyIGNvb2tpZSB0d2ljZS4KKwkJICovCisJCWNpZnNfZnNjYWNoZV9nZXRfc3VwZXJfY29v
a2llKHRjb24pOwogCX0KIAogCS8qCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzY2FjaGUuYyBiL2Zz
L2NpZnMvZnNjYWNoZS5jCmluZGV4IDhlZWRkMjBjNDRhYi4uN2U0MDlhMzhhMmQ3IDEwMDY0NAot
LS0gYS9mcy9jaWZzL2ZzY2FjaGUuYworKysgYi9mcy9jaWZzL2ZzY2FjaGUuYwpAQCAtODcsNiAr
ODcsMTQgQEAgdm9pZCBjaWZzX2ZzY2FjaGVfZ2V0X3N1cGVyX2Nvb2tpZShzdHJ1Y3QgY2lmc190
Y29uICp0Y29uKQogCWNoYXIgKnNoYXJlbmFtZTsKIAlzdHJ1Y3QgY2lmc19mc2NhY2hlX3N1cGVy
X2F1eGRhdGEgYXV4ZGF0YTsKIAorCS8qCisJICogQ2hlY2sgaWYgY29va2llIHdhcyBhbHJlYWR5
IGluaXRpYWxpemVkIHNvIGRvbid0IHJlaW5pdGlhbGl6ZSBpdC4KKwkgKiBJbiB0aGUgZnV0dXJl
LCBhcyB3ZSBpbnRlZ3JhdGUgd2l0aCBuZXdlciBmc2NhY2hlIGZlYXR1cmVzLAorCSAqIHdlIG1h
eSB3YW50IHRvIGluc3RlYWQgYWRkIGEgY2hlY2sgaWYgY29va2llIGhhcyBjaGFuZ2VkCisJICov
CisJaWYgKHRjb24tPmZzY2FjaGUgPT0gTlVMTCkKKwkJcmV0dXJuOworCiAJc2hhcmVuYW1lID0g
ZXh0cmFjdF9zaGFyZW5hbWUodGNvbi0+dHJlZU5hbWUpOwogCWlmIChJU19FUlIoc2hhcmVuYW1l
KSkgewogCQljaWZzX2RiZyhGWUksICIlczogY291bGRuJ3QgZXh0cmFjdCBzaGFyZW5hbWVcbiIs
IF9fZnVuY19fKTsKLS0gCjIuMzIuMAoK
--00000000000085c34305d09c40c0--
