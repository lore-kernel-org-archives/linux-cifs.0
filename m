Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792961332;
	b=rm69FTa+6b2NVKmRNcGmgOxDA7YFZL+JydjGH6LRohwJsyu/Jxd/aQmuXEBXLQ2lNeC6
	 LWpvoqw+h9MkvbgFE1oIbXoDj3M0pvzRRLpp32KUe58jbxfHexpj3zifyZGWyfT9TVJZz
	 PDV9GtWugeFpmmL3Z8NTH8F+GN3RqWqwER3yLHJaWTDS+aRInR6uXkyH6VBQpZZUaysOp
	 ABZS3JAnIynDqUJvFcaUGY6bdwejasFYXJWc4QFij5ywDUFb7jjyhlozahwlURmCI4uEx
	 VR5SY9kvPzxk4YqbtnXupYg9Fqf0P5d0yARi40WybTzS4YyeS/VKE6E0HFNx4rsMPlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792961332;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DKKJWXRaN48DqAvnitKjc0DJPZ4nTqQ0vSM/0vYkAjs=;
	b=OIzu6heXtwYqCZEvOAqyV0OTydy+mr7JCxE2XAB7Y9q1Da0sww+9/rmZQYULzjfCow7z
	 nCMp7FNGgKZg7QapW5xveV7IBBLYAB8YkKW0ny6YwIB8i3ZwKSZv2+oo0Q/kCd+e9l0bY
	 sm/TMqa8GN4nZ6zlSmtCflciQY2efKDOcogfSarYJUiIF9miS3eYdm1G09PQenH6NSvIk
	 WcCSvwRtt0PF2v3xYbjDpP9XhcYb+FwLG83vXxYpgMJvEdySaddZUTi9yArCWTBUdv2MW
	 dDdiwm8e1ROxhOiHKmSEM6u7lVjLPOX3gPiCQ9MZlzXY83CoDGp0+3Sc9qjd8gxR3fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MeNSOFZ0;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=pq9BF4wr;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1636D606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 20:48:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1636D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MeNSOFZ0;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=pq9BF4wr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792961331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DKKJWXRaN48DqAvnitKjc0DJPZ4nTqQ0vSM/0vYkAjs=;
	b=MeNSOFZ0r2UMAbJnILSLNAfpyeanyUObo3w5fkZRFNXGrgppP+0W5thF4TUVbuJqXOOsbC
	saij6qgNseZitWOjEVReoVsseM/EMPkaKPGlvzvKXVWX3duIRxUo0grdwVyvX50k+gt7rj
	5zMM/hvrEAglPK8PVD7DKIatGFLJKzo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-ZJ6WvjjwNliN4o8z2kZEJg-1; Sun, 25 Oct 2026 16:48:49 -0400
X-MC-Unique: ZJ6WvjjwNliN4o8z2kZEJg-1
X-Mimecast-MFC-AGG-ID: ZJ6WvjjwNliN4o8z2kZEJg_1792961329
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93cb6391e89so502027785a.1
        for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 13:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792961329; x=1793566129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DKKJWXRaN48DqAvnitKjc0DJPZ4nTqQ0vSM/0vYkAjs=;
        b=pq9BF4wrKUJ6jnvhMw+1hOgv/XXWmN4RXgM/WgHGYZqjUj+qkYXd/0WzSS8pckUTs/
         nhhv927PTEdxZHK9fggJpBwx7QBZqaVCwP4aM4JE0Hmfy5ZFK89BV9T2GvCF0k9A5lYU
         a0bh7P5YWRs23zzla/MkpEZqZE6lxomRsR4jEY83mMYHggX3Wh4Ml1b8avRDEt/xX3s0
         KX0nBIRkYaz56xLUecaF4dl7s0eNQoFByrlrjJo1TssgDLv4G9nJKSDngzqy68IW6Zlw
         hD3OU71UhQZ+F48XzcRow49illIKzsXdxFcbb+sviO0tg5Oe1ufQoXLGrcdteUtRO4WH
         ytng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792961329; x=1793566129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DKKJWXRaN48DqAvnitKjc0DJPZ4nTqQ0vSM/0vYkAjs=;
        b=hNxI3OzUj/6oS+r5/wSVAM8pJwJGWh+SoayNtjeLQM4PONPQkB/i4U8AyF+/cPrwY2
         2orNX0UT1GsPSg9r67a5VUjt0cUn9hXgvk+Qx8wUb/FPnoD9maXU25CaR8D6ZKv4qWJs
         YOFbz+W+BVqkqMpEjutgd3pPo2UduC3OB552+iwSD79jnOlNL+j5n/qifHVf3kqpkNJw
         ofdM6HReEx1/WM8Ofvkesm3+frfDY7puXomENxmDsDKuEqeb0sLXMsZjoJBkFWI3lhcZ
         gyiDa1thyTFqMYlvTSq+uL8n7kMk4J+/TbX3yad4+UZUEl6xds3vX6T59lbeGNFd65Ct
         MUkQ==
X-Gm-Message-State: AFq9FYIdHdIcMrMOMTlGCWUvcemzYIdUUgct1nIUyUF1jqmG7B5QsJPW
	8FTJuYRgWhQFN2HioKr+3GyNRXMW3wqRdckUfo61Bc4KqHZwriD4tim/IPUrTvC7oHmyf4ktJFe
	hPqwwsU5tXDizri94Ad8EdveDMn/ezct1TMjOEJbZOhCq0OI8KiIhWNUzcHZpkj7as0GGwM/AMM
	ROwijQpUANAYIgNQSFVa3oUVk+jBfkOg62oqWOK/GhpTOD6jg=
X-Gm-Gg: AYBFou1O7o88R0QywG8Ifwa1/gBPdRa8PONbfjgqWeiE0jOEEnriJ9fWBngdTn0yQ46
	X82P5BuiYTYqcpCn4za8BzBkza4918U1gJG8xcAN6g9pciOKRENz/Dj8AFOiNTnLhJylpl5PhYJ
	3xymVl/9LtsIITbzemGY/FPI9FZmF4GKFSF2rf2/Pep4BkwkLyhmncn6s7xBhKpsQfNJqu6GxRD
	u5BOEyLOvcWTMrbb4ogC8+GVMcdX3xQNoxm5cMeRE1e34QQru1FLyxgRultJ/hffvGUi9o3MB99
	kx4ptsfqDse82QkpCQRG5nW5v9ep2/ORyUMpBCB8NNEj6jTiaNL0psYbom/Wr9aUzInh8uYj2cC
	jX86O75S1g/21YVZevub0RoYIfOTUlY5uuVQhBrpKiJEJfsJGSqEjYr+meicQ1QrV
X-Received: by 2002:a05:620a:684a:b0:93f:1d71:41d5 with SMTP id af79cd13be357-940ef97fdc2mr688416585a.52.1792961329008;
        Sun, 25 Oct 2026 13:48:49 -0700 (PDT)
X-Received: by 2002:a05:620a:684a:b0:93f:1d71:41d5 with SMTP id af79cd13be357-940ef97fdc2mr688415185a.52.1792961328498;
        Sun, 25 Oct 2026 13:48:48 -0700 (PDT)
Received: from bearskin.echidna-sunfish.ts.net (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a78c06sm503300885a.35.2026.10.25.13.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 13:48:47 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org
Subject: [PATCH] smb: client: fix OOB read due to invalid data_offset in CIFSSMBQAllEAs
Date: Sun, 25 Oct 2026 15:48:39 -0500
Message-ID: <20261025204845.3427727-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Due to insufficient validation of the server-supplied DataOffset,
an invalid DataOffset could lead to OOB read of kernel memory.

Fix this by verifying that the DataOffset is at least long enough
to cover the mandatory portion of the response header, but also
leaves sufficient bytes to contain the response data.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifssmb.c | 21 ++++++++++++++++++++-
 fs/smb/client/trace.h   |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index b8c53627f194..35a1c3b614cc 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -6286,9 +6286,28 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 	/* check that each element of each entry does not
 	   go beyond end of list */
 	/* validate_trans2_offsets() */
-	/* BB check if start of smb + data_offset > &bcc+ bcc */
 
 	data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
+	if (data_offset < offsetofend(TRANSACTION2_QPI_RSP, t2.DataOffset)) {
+		cifs_dbg(VFS, "data_offset %u out of range [%zu, %zu]\n",
+			 data_offset,
+			 offsetofend(TRANSACTION2_QPI_RSP, t2.DataOffset),
+			 (size_t)bytes_returned - sizeof(struct fealist));
+		rc = smb_EIO2(smb_eio_trace_qalleas_invalid_data_offset,
+			      data_offset,
+			      offsetofend(TRANSACTION2_QPI_RSP, t2.DataOffset));
+		goto QAllEAsOut;
+	} else if ((size_t)data_offset + sizeof(struct fealist) >
+		   (size_t)bytes_returned) {
+		cifs_dbg(VFS, "data_offset %u out of range [%zu, %zu]\n",
+			 data_offset,
+			 offsetofend(TRANSACTION2_QPI_RSP, t2.DataOffset),
+			 (size_t)bytes_returned - sizeof(struct fealist));
+		rc = smb_EIO2(smb_eio_trace_qalleas_invalid_data_offset,
+			      (size_t)data_offset + sizeof(struct fealist),
+			      bytes_returned);
+		goto QAllEAsOut;
+	}
 	ea_response_data = (struct fealist *)
 				(((char *) &pSMBr->hdr.Protocol) + data_offset);
 
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 5331ce6dc8b3..5c9a3db05f75 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -67,6 +67,7 @@
 	EM(smb_eio_trace_pend_del_fail,			"pend_del_fail") \
 	EM(smb_eio_trace_qalleas_bcc_too_small,		"qalleas_bcc_too_small") \
 	EM(smb_eio_trace_qalleas_ea_overlong,		"qalleas_ea_overlong") \
+	EM(smb_eio_trace_qalleas_invalid_data_offset,	"qalleas_invalid_data_offset") \
 	EM(smb_eio_trace_qalleas_overlong,		"qalleas_overlong") \
 	EM(smb_eio_trace_qfileinfo_bcc_too_small,	"qfileinfo_bcc_too_small") \
 	EM(smb_eio_trace_qfileinfo_invalid,		"qfileinfo_invalid") \
-- 
2.55.0

