Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BF6C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Feb 2022 22:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbiBPWtY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Feb 2022 17:49:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiBPWtX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Feb 2022 17:49:23 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE4B136EC9
        for <linux-cifs@vger.kernel.org>; Wed, 16 Feb 2022 14:49:10 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id u16so5621135ljk.2
        for <linux-cifs@vger.kernel.org>; Wed, 16 Feb 2022 14:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Q31rtfyaobui8qJN/QBLDC17+V6SvrQaLFnkshht8bc=;
        b=gy1dG/U9u7gHNTpXyBaHktkpEUFM1MQ5OpzzQjET1ac9IPXilZLjMcGGaQAQ7wwGM8
         5wQlZXKYUVxUXqOS+q/1AbBCelf+7pyXLMSnnSof2E//Eqxbz1nQ0qMDl0SU3n2YOXGk
         Hap8+R/kKrwdJO8q1wcuFy2vzzteOhwApggcdtYpetK+0uf04W7gp8rnTFmXBaL5fDZi
         ERSTymV6kj4Uv8o1T/zIfw4dlyIV/+Jqwa1gwo3DuKjcrWP0rJs6Myy6I42y3wIqXgHN
         p9pxah9Hvc1Ner+QdPV+uh8MKmnyd3lym0XUKcSrznrrnHGGK2IeSzrv2jBfxu7cFaT7
         Bmcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Q31rtfyaobui8qJN/QBLDC17+V6SvrQaLFnkshht8bc=;
        b=PQl1LB6i4RLU/4ZC1FMCVyRZSPrfI/fDK+d3M/XLxcp+p8XYqpL8K9NMKZyJ6tdjuT
         2fy7HhYnxBuGSHAIec8ffdm69gpc7Oc8UqCAlpoLxp5xnJfAXj/O3o9SPVvQCP+/VG7Y
         dTyZWCtjWQsHfiG96m7H8m5s6YxXHzx7njRmS+kpDispaBgW5CGgYlr2WzQn0yO8sjLR
         Yy1qKHhtH9Fd8Qg0+AXk6anLKygPerntfrg2caU8VOA2NM/v8NfaDTP0topjQWdfbR0q
         26X8P1yG484/YNA8yylmvMMlZxnetwvP7txl/Q5t5yjUNW6hac45xQDU58P8u16KlCXu
         YNMw==
X-Gm-Message-State: AOAM530JR3wA1o6d9vaOG+hwVWbxld7EDcSs8YzDRHUVARE8v/73YpTA
        t+vEahRcA2qsmuridkVvFWNMtyiDfik3h06G/AC9GjUxHjZyXg==
X-Google-Smtp-Source: ABdhPJwgtnVtP7CBAlKDp2NXhW7FBV6hIrvguOjYNN1pepe4QMa3c3Z+MV/s/gmuNhSO665hXuSaiY5uAqs7O/32NgA=
X-Received: by 2002:a2e:9ad5:0:b0:246:853:1826 with SMTP id
 p21-20020a2e9ad5000000b0024608531826mr170279ljj.398.1645051748569; Wed, 16
 Feb 2022 14:49:08 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 16 Feb 2022 16:48:57 -0600
Message-ID: <CAH2r5msWKHzDMgXZkifGYgM5ueQA4X613zM4KFGXEZbXyw8ZiA@mail.gmail.com>
Subject: [PATCH][CIFS] fix confusing unneeded warning message on smb2.1 and earlier
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000001c6e6905d82a7593"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001c6e6905d82a7593
Content-Type: text/plain; charset="UTF-8"

    When mounting with SMB2.1 or earlier, even with nomultichannel, we
    log the confusing warning message:
      "CIFS: VFS: multichannel is not supported on this protocol
version, use 3.0 or above"

    Fix this so that we don't log this unless they really are trying
    to mount with multichannel.

    Cc: stable@vger.kernel.org # 5.11+
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 5723d50340e5..32f478c7a66d 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -127,11 +127,6 @@ int cifs_try_adding_channels(struct cifs_sb_info
*cifs_sb, struct cifs_ses *ses)
        struct cifs_server_iface *ifaces = NULL;
        size_t iface_count;

-       if (ses->server->dialect < SMB30_PROT_ID) {
-               cifs_dbg(VFS, "multichannel is not supported on this
protocol version, use 3.0 or above\n");
-               return 0;
-       }
-
        spin_lock(&ses->chan_lock);

        new_chan_count = old_chan_count = ses->chan_count;
@@ -145,6 +140,12 @@ int cifs_try_adding_channels(struct cifs_sb_info
*cifs_sb, struct cifs_ses *ses)
                return 0;
        }

+       if (ses->server->dialect < SMB30_PROT_ID) {
+               spin_unlock(&ses->chan_lock);
+               cifs_dbg(VFS, "multichannel is not supported on this
protocol version, use 3.0 or above\n");
+               return 0;
+       }
+
        if (!(ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
                ses->chan_max = 1;
                spin_unlock(&ses->chan_lock);


-- 
Thanks,

Steve

--0000000000001c6e6905d82a7593
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-confusing-unneeded-warning-message-on-smb2..patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-confusing-unneeded-warning-message-on-smb2..patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kzq5bt990>
X-Attachment-Id: f_kzq5bt990

RnJvbSBhYzNhZjZlNjg1NTI3NWE0MGJmMmU1NDRmMTBjODQwY2Y4NDUwNmY5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTYgRmViIDIwMjIgMTM6MjM6NTMgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggY29uZnVzaW5nIHVubmVlZGVkIHdhcm5pbmcgbWVzc2FnZSBvbiBzbWIyLjEgYW5k
CiBlYXJsaWVyCgpXaGVuIG1vdW50aW5nIHdpdGggU01CMi4xIG9yIGVhcmxpZXIsIGV2ZW4gd2l0
aCBub211bHRpY2hhbm5lbCwgd2UKbG9nIHRoZSBjb25mdXNpbmcgd2FybmluZyBtZXNzYWdlOgog
ICJDSUZTOiBWRlM6IG11bHRpY2hhbm5lbCBpcyBub3Qgc3VwcG9ydGVkIG9uIHRoaXMgcHJvdG9j
b2wgdmVyc2lvbiwgdXNlIDMuMCBvciBhYm92ZSIKCkZpeCB0aGlzIHNvIHRoYXQgd2UgZG9uJ3Qg
bG9nIHRoaXMgdW5sZXNzIHRoZXkgcmVhbGx5IGFyZSB0cnlpbmcKdG8gbW91bnQgd2l0aCBtdWx0
aWNoYW5uZWwuCgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIDUuMTErClNpZ25lZC1vZmYt
Ynk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3Nl
c3MuYyB8IDExICsrKysrKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA1
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc2Vzcy5jIGIvZnMvY2lmcy9zZXNz
LmMKaW5kZXggNTcyM2Q1MDM0MGU1Li4zMmY0NzhjN2E2NmQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c2Vzcy5jCisrKyBiL2ZzL2NpZnMvc2Vzcy5jCkBAIC0xMjcsMTEgKzEyNyw2IEBAIGludCBjaWZz
X3RyeV9hZGRpbmdfY2hhbm5lbHMoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0
IGNpZnNfc2VzICpzZXMpCiAJc3RydWN0IGNpZnNfc2VydmVyX2lmYWNlICppZmFjZXMgPSBOVUxM
OwogCXNpemVfdCBpZmFjZV9jb3VudDsKIAotCWlmIChzZXMtPnNlcnZlci0+ZGlhbGVjdCA8IFNN
QjMwX1BST1RfSUQpIHsKLQkJY2lmc19kYmcoVkZTLCAibXVsdGljaGFubmVsIGlzIG5vdCBzdXBw
b3J0ZWQgb24gdGhpcyBwcm90b2NvbCB2ZXJzaW9uLCB1c2UgMy4wIG9yIGFib3ZlXG4iKTsKLQkJ
cmV0dXJuIDA7Ci0JfQotCiAJc3Bpbl9sb2NrKCZzZXMtPmNoYW5fbG9jayk7CiAKIAluZXdfY2hh
bl9jb3VudCA9IG9sZF9jaGFuX2NvdW50ID0gc2VzLT5jaGFuX2NvdW50OwpAQCAtMTQ1LDYgKzE0
MCwxMiBAQCBpbnQgY2lmc190cnlfYWRkaW5nX2NoYW5uZWxzKHN0cnVjdCBjaWZzX3NiX2luZm8g
KmNpZnNfc2IsIHN0cnVjdCBjaWZzX3NlcyAqc2VzKQogCQlyZXR1cm4gMDsKIAl9CiAKKwlpZiAo
c2VzLT5zZXJ2ZXItPmRpYWxlY3QgPCBTTUIzMF9QUk9UX0lEKSB7CisJCXNwaW5fdW5sb2NrKCZz
ZXMtPmNoYW5fbG9jayk7CisJCWNpZnNfZGJnKFZGUywgIm11bHRpY2hhbm5lbCBpcyBub3Qgc3Vw
cG9ydGVkIG9uIHRoaXMgcHJvdG9jb2wgdmVyc2lvbiwgdXNlIDMuMCBvciBhYm92ZVxuIik7CisJ
CXJldHVybiAwOworCX0KKwogCWlmICghKHNlcy0+c2VydmVyLT5jYXBhYmlsaXRpZXMgJiBTTUIy
X0dMT0JBTF9DQVBfTVVMVElfQ0hBTk5FTCkpIHsKIAkJc2VzLT5jaGFuX21heCA9IDE7CiAJCXNw
aW5fdW5sb2NrKCZzZXMtPmNoYW5fbG9jayk7Ci0tIAoyLjMyLjAKCg==
--0000000000001c6e6905d82a7593--
