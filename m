Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF9E43140;
	Mon,  8 Jan 2024 14:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="KdPWUVIq"
Message-ID: <446860c571d0699ed664175262a9e84b@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1704725570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t+i5JdjKCVjgU6vgNmEIDAR0g7GR4mu/Bvs75gpMMnE=;
	b=KdPWUVIqX+Xh926sXVwSBYIO6gfEPBWlJ1qkNFoBRmZH4o4EY3ZvhF/GjDxh/FVHf8FNNX
	/UH9mFM39l8mH7m+jQFVE9OdvHxmwpmh7jaZzNjIeEXiICjxHGKV8GwJGi81NN9H7nm5Iq
	l8kOVX4qY7LggrbNhAW5JIA5qxsG6xjWGpsPZwIHxG8WsqprsqbHKSjk2BTF2v9QXUu2Z6
	XYf9SQM2ccltnN9+A2PiaCnjvC6fAcpHN1mxRlXqLcfX8xUq33VQ7SiQEs4ALAiQe50tnJ
	R5rt3xFuUFnmMFbTqjeLB6ufA64kY1f30tjyghe8oE5ZTKZGZjJ5Xj1R4iDqzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1704725570; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+i5JdjKCVjgU6vgNmEIDAR0g7GR4mu/Bvs75gpMMnE=;
	b=TccRxjs6rPyPYQjuZvktAOMRhZYCLWTGDuWV0AG+Ruz7rkpqmFPBQnGmDzZY73gQUqzIrL
	qlJ/uAJvU9sGoG6iyEc3Mk6fYjvZ2NOwOUHfhzRBxpM5LTLV6DdVU1y01uTf9Fr87XLvFG
	KILXHkADqkGWxfyHt8Xb2ru7PWvKCEsRYADziGh6g4tjNGf5irGvqDB6lrtQ8+9WqnQfoe
	pABEK8PRQcUdL/UupqNqGROZg1xN75Z6tzOwFh6YVKU2YsmfEEDzXjNKADtEMUE1oDMTTG
	ut9ysVPR4iXBFryPujnlwVqmgNiL6T0XCPSbWbbzIZbIc+sGDo++ACNjL+d0YA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1704725570; a=rsa-sha256;
	cv=none;
	b=r9kVvNpNv7obhsk1ANYiPmKIqp/nUSBKIpuxQWB4fpQ9ItzWBU12jCnWpoTn7g3DhqOJpo
	wi29P26fzH6D7cHIjb+Bg+oAxBsOA0+Nc/V7pXQtdw/Pb3OBr3z1OZGccUMA3rAifAVxYS
	SQsbbbcYqeGnX93/cyZ1WTqad/+YsWNn/z5WGAEYIzwN8TIDpG9Es1910MBWWSWkAJx4JG
	+P2nvdNq5TPobIHGRwLqXv8hjoPrjnIRUcSVw9czrPP3Ydf3PGLmkKHJeULeASOecWbJBd
	L7AC6t6JxVrPjt0Y7qENuBXE94bjobvMvq1st0cJPn0k9Y2T4OnlvXf8XirYDA==
From: Paulo Alcantara <pc@manguebit.com>
To: Jan =?utf-8?B?xIxlcm3DoWs=?= <sairon@sairon.cz>, Leonardo Brondani
 Schenkel
 <leonardo@schenkel.net>, stable@vger.kernel.org, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>
Cc: regressions@lists.linux.dev, linux-cifs@vger.kernel.org, Mathias
 =?utf-8?Q?Wei=C3=9Fbach?= <m.weissbach@info-gate.de>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
In-Reply-To: <7425b05a-d9a1-4c06-89a2-575504e132c3@sairon.cz>
References: <8ad7c20e-0645-40f3-96e6-75257b4bd31a@schenkel.net>
 <7425b05a-d9a1-4c06-89a2-575504e132c3@sairon.cz>
Date: Mon, 08 Jan 2024 11:52:45 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Jan,

Thanks for the report.

So this bug is related to an off-by-one in smb2_set_next_command() when
the client attempts to pad SMB2_QUERY_INFO request -- since it isn't 8 byte
aligned -- even though smb2_query_info_compound() doesn't provide an extra
iov for such padding.

v6.1.y doesn't have

        eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")

and the commit does

	+	if (unlikely(check_add_overflow(input_len, sizeof(*req), &len) ||
	+		     len > CIFSMaxBufSize))
	+		return -EINVAL;
	+

so sizeof(*req) will wrongly include the extra byte from
smb2_query_info_req::Buffer making @len unaligned and therefore causing
OOB in smb2_set_next_command().

A simple fix for that would be

	diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
	index 05ff8a457a3d..aed5067661de 100644
	--- a/fs/smb/client/smb2pdu.c
	+++ b/fs/smb/client/smb2pdu.c
	@@ -3556,7 +3556,7 @@ SMB2_query_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
	 
	 	iov[0].iov_base = (char *)req;
	 	/* 1 for Buffer */
	-	iov[0].iov_len = len;
	+	iov[0].iov_len = len - 1;
	 	return 0;
	 }
