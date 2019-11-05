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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54234C5DF60
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 21:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AD6021882
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 21:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="RsCkRYNG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbfKEVod (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Nov 2019 16:44:33 -0500
Received: from mout.web.de ([212.227.15.4]:55075 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbfKEVod (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Nov 2019 16:44:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1572990264;
        bh=0qnYFMDMyA7y0OfkTj2iUOaga/IHqw5JPmaH5tNvbVc=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=RsCkRYNGty3MLOh/R5H+mNg+y+22YJ+B9dOaEjQ8oEKUZD/L81gzcIRTRKiNWpNdz
         W9PBuc1lLzH35TzQFUaW5aM5Yo8nwFBJTPmvmAk0lhuQHGh70DD52WRW9xr7UgIx6X
         +rQsPm41ulaGneHj6Im0lh19it1OmxXF7z3Ya530=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.164.204]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MYejS-1iOAkP3zEo-00VLq5; Tue, 05
 Nov 2019 22:44:24 +0100
Subject: [PATCH 2/2] CIFS: Use common error handling code in
 smb2_ioctl_query_info()
From:   Markus Elfring <Markus.Elfring@web.de>
To:     linux-cifs@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>
References: <b797b2fc-1a33-7311-70d7-dd258d721a03@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <bfd1b925-7190-ba05-aeaf-f5f3a3e3d124@web.de>
Date:   Tue, 5 Nov 2019 22:44:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <b797b2fc-1a33-7311-70d7-dd258d721a03@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SWfNy9wh8i4ZLQM/dRU5mV9Gqh6cS80cu7li+ZwtkhaMVDhmFaJ
 jhoHLnRIQGbEIRvZl6e/gEw1sPEV2EIcNc180nUQxpZQefZacnKGxDepdtl0V2ODkK5j2Pc
 x4oJYPKidLpAFjEhM/w5zbxaqGsnoKk6N2apLdNFGcjz5dqbYKca9piQRk4A8MwJuuL6lsV
 PMuoTmVpdGCiXBrIPD1aw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:99U6//HAIGA=:KvydFjGSVqPmdvUTEq06zE
 X6krgbJP8pFsAnFnEVYGdsvcSRfwGCfPg+RQ7uXDmomAC7+ZX2ePIntvswvJ03Y2UIdK9vecu
 MkUScc708ERkzK05DCiDTk996z102+T2SChJzQGo4RFEp2UpL+poh5VeFzjbg1TVgehgLswIQ
 Ztm9c2Te8JLwnDtBGSVoxz7u/eiKAS4NNao8MpXkWv43yRYzT8sLfmjOJvd2uRCRQmJ0HH8RQ
 GTTqQFKr4HkKvKvPtcJx8e4PU4FkjC1ORMxSpqIKcR7ALkdh+nqPFcQHCpSc3s6IfeQPNeypK
 iOOajOVxVA3qogYPD74CN9qq1zsM/gHFAGf96RRTQDME18A6t1cmIQ7nFDOP4WGn9vvt8eqYn
 Qd+iXrFx+tKGXj3s23UjKvUyQW9B6kU23Ak4tZJrdGiP3L58Biu8DjeBgrWGsDF0hJoDqkX6U
 WESIFhMofWDn/G+rmiuyaEbVumIvX9R9VegTtQW6M8zGHNyFTV6jzvzNUndYXtFAVY+Xgd9NQ
 pNvTpV8zlz8kr/mRlykSXZTidx4DxPJq01QWtkUktxiOR1A0OkzsW1KulSJtcuijlMhVbnY31
 XPqEcxFywpUXtysc9n4CVyUsKcDZpbPJ/mdnCfYhxQTwB5Or/m3vIwSGCO/VCFNBo6X80oovf
 jqm/dtHChf9WYtzWDMeYnz59Yyz8sHfTv7g/MY0ji/wKHbvRewErBtKmZRG8htm7ehueg03Xy
 nuJ+Jr9dRCh1kgiEN2WtEs95BKwBxQ2tJJgyut/DGPtE170KidiVFvgyC5eQDhjqJhjVSufTK
 eZWdNANwobXMoGsm6M4lJVDRUW3RB4HDdg4/w0F8Q+Jcq5Qj6MStcZnisQrlxz62E6Ecwpueh
 CwlnRjOo/Z0YejacZCytZg7lboH4q6stbg43o68RuVObPgCHDSEZr+NIcv6ILt4NgupBeoA0+
 Pr54EW4sJS7Bl6tRAOMEFPrwYyxI1fomfko2o755GH8vM59v1y/QTdK+gFHvNOELG/en8r+MG
 edcCrtv74rYF4RXEJTcdEcY2Q7ltQNSOAwJrR7DbjG9pCMi/qdYK/jm7QvxpdNsKQvXz/yEiU
 qGsaSLH7W7SI5ClEaCEO2iUZPj6GcDNEnDL5oSXjYfQkQXW2loAmhxt7KCI0imVj3Ct0K6Cis
 223qqdTT8hN0I1bmSEWVMsdhGbdrD3/jwNh4jGi+RKaqH5SYOf4QPeSr9Y6Zl0IemaR8V/+Sv
 KtG/27/gICttr4g0c2di1agNtBoNiN4wLM3GQnocHtyQkKgw726duXJ2+bmE=
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 5 Nov 2019 22:26:53 +0100

Move the same error code assignments so that such exception handling
can be better reused at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/cifs/smb2ops.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index fde2e6d241a8..fde912aabb20 100644
=2D-- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1535,35 +1535,32 @@ smb2_ioctl_query_info(const unsigned int xid,
 		if (le32_to_cpu(io_rsp->OutputCount) < qi.input_buffer_length)
 			qi.input_buffer_length =3D le32_to_cpu(io_rsp->OutputCount);
 		if (qi.input_buffer_length > 0 &&
-		    le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length > rsp_io=
v[1].iov_len) {
-			rc =3D -EFAULT;
-			goto iqinf_exit;
-		}
-		if (copy_to_user(&pqi->input_buffer_length, &qi.input_buffer_length,
-				 sizeof(qi.input_buffer_length))) {
-			rc =3D -EFAULT;
-			goto iqinf_exit;
-		}
+		    le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length
+		    > rsp_iov[1].iov_len)
+			goto e_fault;
+
+		if (copy_to_user(&pqi->input_buffer_length,
+				 &qi.input_buffer_length,
+				 sizeof(qi.input_buffer_length)))
+			goto e_fault;
+
 		if (copy_to_user((void __user *)pqi + sizeof(struct smb_query_info),
 				 (const void *)io_rsp + le32_to_cpu(io_rsp->OutputOffset),
-				 qi.input_buffer_length)) {
-			rc =3D -EFAULT;
-			goto iqinf_exit;
-		}
+				 qi.input_buffer_length))
+			goto e_fault;
 	} else {
 		pqi =3D (struct smb_query_info __user *)arg;
 		qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 		if (le32_to_cpu(qi_rsp->OutputBufferLength) < qi.input_buffer_length)
 			qi.input_buffer_length =3D le32_to_cpu(qi_rsp->OutputBufferLength);
-		if (copy_to_user(&pqi->input_buffer_length, &qi.input_buffer_length,
-				 sizeof(qi.input_buffer_length))) {
-			rc =3D -EFAULT;
-			goto iqinf_exit;
-		}
-		if (copy_to_user(pqi + 1, qi_rsp->Buffer, qi.input_buffer_length)) {
-			rc =3D -EFAULT;
-			goto iqinf_exit;
-		}
+		if (copy_to_user(&pqi->input_buffer_length,
+				 &qi.input_buffer_length,
+				 sizeof(qi.input_buffer_length)))
+			goto e_fault;
+
+		if (copy_to_user(pqi + 1, qi_rsp->Buffer,
+				 qi.input_buffer_length))
+			goto e_fault;
 	}

  iqinf_exit:
@@ -1579,6 +1576,10 @@ smb2_ioctl_query_info(const unsigned int xid,
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
 	return rc;
+
+e_fault:
+	rc =3D -EFAULT;
+	goto iqinf_exit;
 }

 static ssize_t
=2D-
2.24.0

