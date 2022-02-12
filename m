Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2425AC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Feb 2022 08:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiBLIGU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Feb 2022 03:06:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiBLIGU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Feb 2022 03:06:20 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E40126AEA
        for <linux-cifs@vger.kernel.org>; Sat, 12 Feb 2022 00:06:17 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id k18so15295189lji.12
        for <linux-cifs@vger.kernel.org>; Sat, 12 Feb 2022 00:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DxjhyWmbMb41JhBCJjCN6QotBeIjnVIxWgX/N57EoMk=;
        b=mZVtVm94hviMPj5c1//e63G7+mf/IKXM8h8TGFzUYAFZ1qHGFViMORSXj0v8L1OYwG
         ivTuKS0kjmlTCgKb15z05bkOcaQ65fg5Kz21NczDqcDPjEoW9tjF5pAVcNdblcnSOUV9
         QMrRvVm6qd3iJoiwBspp5BbKE1leLD8kHGUAJdHcQfVJKUnIe8QAgBwtyeny7ouioQ2e
         M9MBebRr2f7Dv0+3fJGbotmEj5DqZaw0lIZP/Q9WsNorJ8yN53qJy4/m/A0BO/W9v3DA
         lJfeibOOp/YZbaIhC4YGvspTsWJmxAf+2tFoUoAEnArA0MHN2FiRgxWcauQFzvCwlY1j
         nwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DxjhyWmbMb41JhBCJjCN6QotBeIjnVIxWgX/N57EoMk=;
        b=fc6XZbEa1i28NdZgsmSmt0PuCwe/x6bJo6Sj/QSQEYZmvDn46bgTLunFB8JxGsixio
         gqczsdiy4dWxKqc7+NBOrn47gm3dINJ8qhlzdIfpVqqOd2gN0ytuXp48oKK3ePT0Ssdl
         yHIZV/qO32pl1/4LsOtQwIbkzqh01vtbG+R0Jvkh+ep4J1iKDWoIRVyY3lqTFy0z31tz
         6yYgvlml2pWN1fEUPRs7nTEKprIwdY5dB0ghFgHPo3nmC6Y4lbBz/oCB/+NNzrrAM416
         etNv5d+0oxI98AeIQeBkV8Nwhe6QFYNc9acwqUgeg/ROmYewaTfujGMKwNsu3wTztg1T
         tpuQ==
X-Gm-Message-State: AOAM531SK32JDUY0uLMYVNJAvVc0xc0CSeK01N+9LvinITjzvECf1RZU
        9CuahsxwU73gQeuewtiriyPL5q5AMMp52ZZn4hfB8ZungJg=
X-Google-Smtp-Source: ABdhPJzKUx156JwOGq/GIRbL/knYktIrvXl/p/xYCScsmYvHG29zlXJu+zQ5+aT8CPxOB32rasS6ZyTnwhPKGguD+nQ=
X-Received: by 2002:a2e:9c04:: with SMTP id s4mr3116218lji.229.1644653175285;
 Sat, 12 Feb 2022 00:06:15 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 12 Feb 2022 02:06:04 -0600
Message-ID: <CAH2r5mtB05z7j45H4LRYGE8LUcyTL-17bacB=zm9LO5nZcvPgQ@mail.gmail.com>
Subject: [PATCH] smb3: fix snapshot mount option
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     ruckajan10@gmail.com
Content-Type: multipart/mixed; boundary="0000000000004b5ecd05d7cda810"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004b5ecd05d7cda810
Content-Type: text/plain; charset="UTF-8"

    The conversion to the new API broke the snapshot mount option
    due to 32 vs. 64 bit type mismatch

    Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
    Cc: stable@vger.kernel.org # 5.11+
    Reported-by: <ruckajan10@gmail.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 7ec35f3f0a5f..a92e9eec521f 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -149,7 +149,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
        fsparam_u32("echo_interval", Opt_echo_interval),
        fsparam_u32("max_credits", Opt_max_credits),
        fsparam_u32("handletimeout", Opt_handletimeout),
-       fsparam_u32("snapshot", Opt_snapshot),
+       fsparam_u64("snapshot", Opt_snapshot),
        fsparam_u32("max_channels", Opt_max_channels),

        /* Mount options which take string value */
@@ -1078,7 +1078,7 @@ static int smb3_fs_context_parse_param(struct
fs_context *fc,
                ctx->echo_interval = result.uint_32;
                break;
        case Opt_snapshot:
-               ctx->snapshot_time = result.uint_32;
+               ctx->snapshot_time = result.uint_64;
                break;
        case Opt_max_credits:
                if (result.uint_32 < 20 || result.uint_32 > 60000) {
cifs

-- 
Thanks,

Steve

--0000000000004b5ecd05d7cda810
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-snapshot-mount-option.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-snapshot-mount-option.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kzjk0yph0>
X-Attachment-Id: f_kzjk0yph0

RnJvbSBiMmE4ZGNmMGZlNzYwNDdjNDgyYmM5NjJhNmEzMjkyMmY3NThlYjdhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTIgRmViIDIwMjIgMDE6NTQ6MTQgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggc25hcHNob3QgbW91bnQgb3B0aW9uCgpUaGUgY29udmVyc2lvbiB0byB0aGUgbmV3
IEFQSSBicm9rZSB0aGUgc25hcHNob3QgbW91bnQgb3B0aW9uCmR1ZSB0byAzMiB2cy4gNjQgYml0
IHR5cGUgbWlzbWF0Y2gKCkZpeGVzOiAyNGUwYTFlZmY5ZTIgKCJjaWZzOiBzd2l0Y2ggdG8gbmV3
IG1vdW50IGFwaSIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgNS4xMSsKUmVwb3J0ZWQt
Ynk6IDxydWNrYWphbjEwQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvZnNfY29udGV4dC5jIHwgNCArKy0t
CiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvZnNfY29udGV4dC5jIGIvZnMvY2lmcy9mc19jb250ZXh0LmMKaW5kZXgg
N2VjMzVmM2YwYTVmLi5hOTJlOWVlYzUyMWYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZnNfY29udGV4
dC5jCisrKyBiL2ZzL2NpZnMvZnNfY29udGV4dC5jCkBAIC0xNDksNyArMTQ5LDcgQEAgY29uc3Qg
c3RydWN0IGZzX3BhcmFtZXRlcl9zcGVjIHNtYjNfZnNfcGFyYW1ldGVyc1tdID0gewogCWZzcGFy
YW1fdTMyKCJlY2hvX2ludGVydmFsIiwgT3B0X2VjaG9faW50ZXJ2YWwpLAogCWZzcGFyYW1fdTMy
KCJtYXhfY3JlZGl0cyIsIE9wdF9tYXhfY3JlZGl0cyksCiAJZnNwYXJhbV91MzIoImhhbmRsZXRp
bWVvdXQiLCBPcHRfaGFuZGxldGltZW91dCksCi0JZnNwYXJhbV91MzIoInNuYXBzaG90IiwgT3B0
X3NuYXBzaG90KSwKKwlmc3BhcmFtX3U2NCgic25hcHNob3QiLCBPcHRfc25hcHNob3QpLAogCWZz
cGFyYW1fdTMyKCJtYXhfY2hhbm5lbHMiLCBPcHRfbWF4X2NoYW5uZWxzKSwKIAogCS8qIE1vdW50
IG9wdGlvbnMgd2hpY2ggdGFrZSBzdHJpbmcgdmFsdWUgKi8KQEAgLTEwNzgsNyArMTA3OCw3IEBA
IHN0YXRpYyBpbnQgc21iM19mc19jb250ZXh0X3BhcnNlX3BhcmFtKHN0cnVjdCBmc19jb250ZXh0
ICpmYywKIAkJY3R4LT5lY2hvX2ludGVydmFsID0gcmVzdWx0LnVpbnRfMzI7CiAJCWJyZWFrOwog
CWNhc2UgT3B0X3NuYXBzaG90OgotCQljdHgtPnNuYXBzaG90X3RpbWUgPSByZXN1bHQudWludF8z
MjsKKwkJY3R4LT5zbmFwc2hvdF90aW1lID0gcmVzdWx0LnVpbnRfNjQ7CiAJCWJyZWFrOwogCWNh
c2UgT3B0X21heF9jcmVkaXRzOgogCQlpZiAocmVzdWx0LnVpbnRfMzIgPCAyMCB8fCByZXN1bHQu
dWludF8zMiA+IDYwMDAwKSB7Ci0tIAoyLjMyLjAKCg==
--0000000000004b5ecd05d7cda810--
