Return-Path: <SRS0=8LXX=Y5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840D7C5DF60
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 21:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3739521882
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 21:42:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="UXZ+gIvr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbfKEVm0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Nov 2019 16:42:26 -0500
Received: from mout.web.de ([212.227.15.3]:56159 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729747AbfKEVm0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Nov 2019 16:42:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1572990136;
        bh=eTKu9EhCet3dmCm5fMl3kzNcurmyEyUCoyJuLDVwWj4=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=UXZ+gIvrdgGTyGNrYsRuKAGrS3T1ztQ49s9NW8BbKMEr4sw7pNXCGAAPdWY6WTdEa
         ubRG5jfcdm9NqVXllqFhDokWcIICNXARCw/uh9rvKlW7JkCNwo17l1n4TbBF+P8M0U
         N2IXqB63JetNsyOgaJv+wcat1xf+SzSgrrF29BjQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.164.204]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MFcDF-1ig6o90KBx-00EaJb; Tue, 05
 Nov 2019 22:42:16 +0100
Subject: [PATCH 1/2] CIFS: Use memdup_user() rather than duplicating its
 implementation
From:   Markus Elfring <Markus.Elfring@web.de>
To:     linux-cifs@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>
References: <b797b2fc-1a33-7311-70d7-dd258d721a03@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <df3d1da0-a907-80f3-b8f1-6ec7615086d9@web.de>
Date:   Tue, 5 Nov 2019 22:42:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <b797b2fc-1a33-7311-70d7-dd258d721a03@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zVgHY/tLl0DgTUrHlaIsTs+ghIDoq/nAsyESs+m2Vvv6afj9lXY
 D8pEyCanIRHZkgoI9ZiGjmgl/tc2aHo+ZQtP3DwvsNrjr7OKiUV3+NNBIC9l7eeN9Ynsvjy
 R6J9RCzyRhpsMIRN7tb1EJ8ckx4KZy9v7sXv74RrKNAV3l0bzNL1DH7T8Hn9Qw24F4za4di
 FrfouKqwPyzdYR5bv9OiA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zmxHj2FgTwg=:WavkJNZsT5CIYITR1Am806
 qd76cDAfyzfuGRSwM9Xn7fLH97qgSZoUR4hNyGVtubpt8eAucb48N+DX8XkG8E9Xt2x09O5l5
 dfoWRLpPS07fcfGzbR2P7wvPYNdwRrchQIXkuHtNNl3jfFPjHHyZqGAzHlcyBVmVRpkkVCEct
 pXBCixMVdcri1lx+ecQUHDh1CS5IaOSlD8qxkhXSl9M5+zCh/XiftD+H9qr6EyBox8aUsiU8V
 tmichAyJ3QEvPROUSN5WYbmWNd9oiiYor5KHX+AhUJjZt06U+jh9tqlYLxPpkembegiwgbpNN
 BN72vTyrR+ilTramaL1k26YyLFuljYjpLPjCKn8+H8/IOyhTa5B2yhm5xtRLpU4zDB2zrdcIo
 IW6eHftD6hQtPF+qfGTcy6trd9rVJOg2ojhcStBUD1/8zyo+GlQ1S+uPftDaDj+NTbbwqzqQW
 r4z9N2tLGNVdSQY8oM9s/BH/+awRI5LdIpAlt+7pkh4jSi8TsoGe0dwyKsftkJ6qVSqJMXst4
 NCeQ/S7CNTQn3gBw538KMEisE8JvXCAxhf0PIXNaduTxGWKkB1oIaoTocI+RkGyF2h6RuIqLG
 C2g4je0cVz6AZUE5uia3pmdpQKmSr9ewgE2b3xP0jq0Yx5Sx2Icu4r2PZ+RZaQ1bkGm4eIxjm
 5qD9Wr4/0PPWzTGTJYU+54v8XgA+uYK3b5dbeC6FmPcp7IQbWO3IUW9NfNMIVjob28jpqzttz
 5nlwBeUwzhjZJKVhMlW46EXk5fp6hq4+s+5G5affEnGFhg3XxcxaCjj/uTfr+CDnZWgpwR1zh
 s5CPpCF6X6hk2JYZHPMZ75ERfWIa7xmgPgM/SJykh8FrKsGuf8a1j8K2ANEWf2YGZDk4Atls5
 8ER1tqJAOhyHwuxP6GHfz+JEzGkWJwrVeL2MZypVQLiMs2YqF6rqFaSQxgGsqmp8PwHjJnxHs
 eDfkm79CjqfxQjw4VmAInFgjowoWv6f2fKyDD/vmnZWx1f3yWMN9J96Q/j9CWjd8X56oZNOUv
 MN/Z7T685XrEcdV9cD7slwXkFOvak4V487uy9l6QJpNoFBLSMRUV55HsMNB/2CWcnz+8N4dpI
 LGsObt1+isxA5FTgysQ8NQ6FLPSUhfz3kUZwRcUFWkheP5P6q4hinwbe15e/0lQpXYJDEa+Ec
 S5X7Aeu1eoeDYwGX6BoeBlkSz7Y7C0i+gWcEHp+FtHZv/bXGosxc0IvM5fXUcwqud12SOn7Xr
 2Rpw33Dirrd74dImqnrWGRY/HIdtH7kZwfxMH1G0UmL7qM9dn6+dP20D7TLo=
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 5 Nov 2019 21:30:25 +0100

Reuse existing functionality from memdup_user() instead of keeping
duplicate source code.

Generated by: scripts/coccinelle/api/memdup_user.cocci

Fixes: f5b05d622a3e99e6a97a189fe500414be802a05c ("cifs: add IOCTL for QUER=
Y_INFO passthrough to userspace")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/cifs/smb2ops.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 9cbb0ae0e53e..fde2e6d241a8 100644
=2D-- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1413,15 +1413,10 @@ smb2_ioctl_query_info(const unsigned int xid,
 	if (smb3_encryption_required(tcon))
 		flags |=3D CIFS_TRANSFORM_REQ;

-	buffer =3D kmalloc(qi.output_buffer_length, GFP_KERNEL);
-	if (buffer =3D=3D NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(buffer, arg + sizeof(struct smb_query_info),
-			   qi.output_buffer_length)) {
-		rc =3D -EFAULT;
-		goto iqinf_exit;
-	}
+	buffer =3D memdup_user(arg + sizeof(struct smb_query_info),
+			     qi.output_buffer_length);
+	if (IS_ERR(buffer))
+		return PTR_ERR(buffer);

 	/* Open */
 	memset(&open_iov, 0, sizeof(open_iov));
=2D-
2.24.0

