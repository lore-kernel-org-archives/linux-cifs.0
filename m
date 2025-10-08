Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2B11E834B;
	Wed,  8 Oct 2025 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759949226; cv=none; b=bBGTEU7vXVRILP53j3lfj6YK5mRKrMbgUeNLS6MuYcg97R/nYz15uklS2aJbNf/061Mf+EhrFXSeb5YbHDC23fd9ne77VM417PQYyeNpWV2GqyvkAPq5y+H9tCHaDUPR2DciDSYIswTSUSMXKSyxhh+T+RHhJBQDuh72XPSR4aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759949226; c=relaxed/simple;
	bh=Y2XSeqIhNa/YIk2gDJTSPzf57qMlHCjrIWfsylWhh7I=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=FzqVFRoxOzUaKlraU/9XzU/ElOiy/GZagor77w41PcBiyN4GQLEKHOtlCEra9zMDGsqF4XXk37Co/IK+txow+jnk+c1nJwDAaV0Ql2jKM9Neo10oo8Be5if5V5jIThSW9qn/Z+dzZCoyQCtQfhtUpIbSOWEhM6U6OPCIcSdMMH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=mtpi2Yde; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="mtpi2Yde"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759949202; x=1760554002; i=markus.elfring@web.de;
	bh=cwVCckyft0z+7jd8Jr8TiniDE7AcKyu+yBXvWNMfYDo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mtpi2YdeMEwPqx11/eErEefAEYC+EosCIelJ94BHgNUNSgaud0miUEaGh5LoiB0L
	 1ipCwVAnYZ/tPWkCGPpK5cHGsIQea8ysSEURTrk1CCEu4EtIK5ggoCRIzoCihP0zI
	 /YoTj980Rrk/ToGNH4GL89/a9HSNg5bKWNmkJ+p57dFaSxKIc8C01n72Me/IG3++E
	 LlDcly4bwi9YeMBs91cko2/RQKy0iFoaSUZmKxdvsXDfISgGQ1CZuFuwv4TCmF1C/
	 HVzQgjRmCCa14L1O0T1dqDXCIXq/JLtFFO8bD68xB+E9V2B4j//yigRHE+RQRWj3D
	 gB2kY8GPor60cIgQsw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.249]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MsaW1-1uHdST1HEh-013xVk; Wed, 08
 Oct 2025 20:46:42 +0200
Message-ID: <8a91cb2c-4353-496e-8f16-2e700df692bd@web.de>
Date: Wed, 8 Oct 2025 20:46:40 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 1/2] smb: client: Return directly after a failed SMB2_ioctl()
 in smb3_simple_fallocate_range()
From: Markus Elfring <Markus.Elfring@web.de>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Aurelien Aptel <aaptel@suse.com>, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <98b5e2a8-4bc4-4282-987e-01cd6fcd8f00@web.de>
Content-Language: en-GB, de-DE
In-Reply-To: <98b5e2a8-4bc4-4282-987e-01cd6fcd8f00@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uEufg/KBUDlqB3e+C8ql5SQ3k4qH1FVdQaumxmUDYB22p60D1v4
 Ky8ALQigrPLQQNbbjNWHOrLSe5SU/1YW73ogQenRKXNrdQwZq13KadYbJ/VZpCoewoNShIf
 re67OadaXJsn3gu4kdnoqBEg94uK3eJ3+WlDT5SSOCe28l18pKXilDz9Cgx+z5NzEbFmwdC
 MQ2c7jWiHe+hhe7Z1q9jw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:MT3TO3LHG+4=;VBujONVVwdNHg0Q3jl332XIqV6V
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Oct 2025 20:02:00 +0200

* Return directly after a call of the function =E2=80=9CSMB2_ioctl=E2=80=
=9D failed
  at the beginning.

* Delete an initialisation for the local variable =E2=80=9Cout_data=E2=80=
=9D
  which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7c3e96260fd4..ec188dedbf97 100644
=2D-- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3537,7 +3537,7 @@ static int smb3_simple_fallocate_range(unsigned int =
xid,
 				       struct cifsFileInfo *cfile,
 				       loff_t off, loff_t len)
 {
-	struct file_allocated_range_buffer in_data, *out_data =3D NULL, *tmp_dat=
a;
+	struct file_allocated_range_buffer in_data, *out_data, *tmp_data;
 	u32 out_data_len;
 	char *buf =3D NULL;
 	loff_t l;
@@ -3552,7 +3552,7 @@ static int smb3_simple_fallocate_range(unsigned int =
xid,
 			1024 * sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
 	if (rc)
-		goto out;
+		return rc;
=20
 	buf =3D kzalloc(1024 * 1024, GFP_KERNEL);
 	if (buf =3D=3D NULL) {
=2D-=20
2.51.0


