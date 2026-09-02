Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6D340D594
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 10:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788345753; cv=none; b=E6SNJLvbDXCvRzNntEnFxKjdAfdg9of/lvViB2o0L2MzxCq8Nk5N8okXWVhWgnnPq3rZPxT5HwafUZ1ojcSINNW+LkuEqCnw+3AESF9xk7WWEtWmUuaZKxGBunUDhWqSf52EZO/fvYkloE5Qp10IJj1Ug+C48iJOWwgt0+zPkWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788345753; c=relaxed/simple;
	bh=hQh6a2ifXWFj4QrRqHhl9zv3nNrLH7SulfxH91w9/cY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L75sz0z2Aeyo436mcB0EOCyTTVIxhOfGR4lI1g3AQUkUmgac5qhAxBaW9dWtrAO3LL2jK8hY57c61ZRH8X6Os/67U787dwgPSOPIOyu8nd90/bp+VPVuupy+EjlEyE1SG4R0f9nop3UInq1K6SQh7wqpRnHIGDckvx9ekaC/Xi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=KCjtG5Wx; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="KCjtG5Wx"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so7709185e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 03:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1788345747; x=1788950547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iDiKnKsyrZcQ8QtZ7xdNlsZaf5L7qYJwEj5GZjqkmII=;
        b=KCjtG5Wxv3PGPS2RbuJHNuqTI1AV5ZZ1kaSa0hPf4fvUCW4dXMPfGSZcnjpkH7x90U
         f4HHg4Vb6riuIIZmUoLD8XnQACEsz71CULnlRrMV3N5DVKtB5a+5bujLiliioij0C6zi
         dmrmaFHtzQtOUa1ojdqNbmdCozZYbA5jtBuBWlGkJGGC6MtqFhT94O/jk39d0Gfg1KQi
         thX6KNelfxbzTdCYcngT3het98KAZhS0L4c0iNP6ADVxg4R0sdcPb0slD+SqpAFAsdth
         rizcXip0gXJw0U9gbAARP1QZFZWjPqqZ2psFtFDB87gPXk/+yOMKNcD09VqvpyRaHEj4
         BSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788345747; x=1788950547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iDiKnKsyrZcQ8QtZ7xdNlsZaf5L7qYJwEj5GZjqkmII=;
        b=jhfoYOXAcGieyHZN+aj2UH6gnWibBrxix7gQeeU3FI4sjDHihWqSmyadzLkGUZUrOm
         O0IbF3zLJka4Ub/3/8T7xRiokmbZTHp6ITDtbgv+g/bFj74VafLOcRGZwT2mGvb+thMQ
         Z0VTPW2edS3ePb9PKJCBMRrrMo5JK+KMszr06H8Uf8slvVIjW+ha7tXmupT6x4PLpRWZ
         nj49mk2hI5Z0dOpdubuzo34UmhMjWxRFo80Hm9J1o+fQXc6/yJk2Gvn5EBlSmg7Tt2P7
         xqArTlwKFQDvQg6Ca0oLIpiLxnrQ1FCI3VoqeNCx7jqDqSIj85yBdlXDH5n74W8Shisv
         8VxQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp71VRHDbEuGuNQlf331Gg+b8nUrv45OdHXbUhNEcyErBRT5BqBqtqGHB6iuGfWpgfjUW+44dy9iQ8H@vger.kernel.org
X-Gm-Message-State: AFuF++nLSnKCrOvsktu5rzezqwDKhlfgzL1dYvOvfE00eoYtgi2U6BHT
	8muBp02E/N17eBnN1Kh98/xxDLqJ8SqYX2La5wpyKkDvF/0LWF/rjna9t7KiBg6Jxz11BFT29CQ
	Yo4oyVBfSSuk=
X-Gm-Gg: AR+sD13Iv9fbJMHSxmrcJyMyq2HkOo2gUllAISt66SAcBn+idZTZKAzyiWGWtxEArDF
	mZcKbGXLuyH+CGZsgVZ3azqinEMg1hTwX+8BLnR9UI+mZpaqDk0E8dxlbbHb85snVS9FX+e2lsP
	7pVIzmnOK/lEe+3qkr107+CsHsmBxE80MT8Yjp5dxlM4TtTd0DMsGRg65HnrazQv8kzpxZCHYtw
	CXPbj+iatd6q/Z7ZdwDgzD4BawQEMQNO0mbieAUrZOr/p2kmXSiBMXk+vEQixNJCkUG4Qu5rVpc
	c6PR8ZN9MhMWsMuLv5k82W96JUl/Y1gpnYHFRJJBlH78AZuQymAeddwVVcmRkVU9MehBw3qQb+Q
	+3okcS9PPUMS8wWuB1HojGgJajNjELX5MQLYjW5jqlodkTfnkR7gi5NDPJIs0K150Bc3FEHfHhL
	pr/fedwBFZIpFFgVwq2IaFYiHpY1k9Uj7V5/279aoMgmoCo7eDUq8usc5143uxO5Uol6aklIMju
	xJWvekonieMaOs8vw==
X-Received: by 2002:a05:600c:1d89:b0:49c:ed8f:d094 with SMTP id 5b1f17b1804b1-49ced8fd250mr2291155e9.10.1788345746644;
        Wed, 02 Sep 2026 03:42:26 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-484492ce5e5sm5197521f8f.36.2026.09.02.03.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 03:42:26 -0700 (PDT)
From: Diego Oliva <diego@bynar.io>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] smb: client: reject short READ responses in CIFSSMBRead()
Date: Wed,  2 Sep 2026 11:42:06 +0100
Message-Id: <20260902104207.1820332-2-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260902104207.1820332-1-diego@bynar.io>
References: <20260902104207.1820332-1-diego@bynar.io>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CIFSSMBRead() reads DataLengthHigh, DataLength and DataOffset out of
the READ_RSP returned by the server without first checking that a
whole READ_RSP was actually received. The length of the response is
recorded in rsp_iov.iov_len, but nothing constrains it to be at least
read_rsp_size before those fields are dereferenced.

A malicious or compromised SMB1 server can return a response shorter
than the READ_RSP header, so that parsing the header itself reads past
the end of the receive buffer. SMB1 is not negotiated by default;
reaching this code requires an explicit vers=1.0 mount.

Reject the response unless it is at least read_rsp_size bytes long.

smb_EIO2() was introduced in v6.19, so this does not apply to older
stable trees without returning plain -EIO instead.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Paulo Alcantara <pc@manguebit.org>
Cc: <stable@vger.kernel.org> # 6.19.x
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
 fs/smb/client/cifssmb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..aa6b904ad866 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1719,6 +1719,14 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMBr = (READ_RSP *)rsp_iov.iov_base;
 	if (rc) {
 		cifs_dbg(VFS, "Send error in read = %d\n", rc);
+	} else if (rsp_iov.iov_len < tcon->ses->server->vals->read_rsp_size) {
+		/* check that the received response can hold a whole READ_RSP */
+		cifs_dbg(FYI, "%s: server returned short header. got=%zu expected=%zu\n",
+			 __func__, rsp_iov.iov_len,
+			 tcon->ses->server->vals->read_rsp_size);
+		rc = smb_EIO2(smb_eio_trace_read_rsp_short,
+			      rsp_iov.iov_len, tcon->ses->server->vals->read_rsp_size);
+		*nbytes = 0;
 	} else {
 		int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
 		data_length = data_length << 16;
-- 
2.39.5

