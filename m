Received: from mail-wr2-f42.google.com (mail-wr2-f42.google.com [74.125.225.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEEA3AEF4A
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 09:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673509; cv=none; b=Czock1X9l+XFuK8jrLSw79h04C2GjMjlDmJgik6R7DQg5fv+KmVE3afmofL6KNgMQeog7ZDkKY+KOhzUlfwrALG1YluUt8aD+B07d+kIInig/wxhsxVTCjN+ntmdpNg8VoEaLMD2U3LU3zJ1pvwI6S7CNhRQDtmZqtJWvbUk2XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673509; c=relaxed/simple;
	bh=fjiiQ7LA0S7RXPrgY3FJlekVz55rKmd/+xO/QtpP1O0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rckEFPoQcDElQVseyKmT4azOaE2PlEibGlUxNM3MwEfZrgW/nedzizOUVo15KRED4rdDc1/Rkm/3zI9CoCM02ELY3A80/Ef4nmEi6Vq/rb4H4qYONUMgDAQft7qzXKlBL+15V9ed7tECltDgelMsiV14IHzCv7DmPpKOq2Un1Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=YVGDuPLX; arc=none smtp.client-ip=74.125.225.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="YVGDuPLX"
Received: by mail-wr2-f42.google.com with SMTP id ffacd0b85a97d-4888598e4f9so2534621f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 02:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1790673495; x=1791278295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+i37X05YOrrrsDgR8gYA21Y+/dcyavCXFAZHJfMa4iE=;
        b=YVGDuPLXnPOBIORxcNv2PPZQ649JbGFuEksuftqRdwNSVqMktPWPBeNAnDhmwavINF
         c6iRWNFBuPYLzXBv1QduJYWFKQ52uh5AebbRQqRc3WjUNLfpUZHHSB/dxhHqoGKzKX1u
         j4YJi7Jtbgq9dsgGlpnx4HPNCurN8rzwTX0+E2APifVfCpjFjSoNkplcn7XHWh+TPzYY
         aP0iQF6lQoP+JUCBaAqziF8Lg9IJt86QhwCNBGm5vLmZ9sA6HApP30SVOLOWJQo7VHF5
         fl6JtxoFVODk21LG7gTVgk4oj2t1Q935QbSQBcQVHtqRPQPLU2U5THnJnCr32m1iJMJK
         3Y4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790673495; x=1791278295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+i37X05YOrrrsDgR8gYA21Y+/dcyavCXFAZHJfMa4iE=;
        b=UHeDIUSA9tXKdkkfdHs937FVO6tsyOo0LoBwiHWOSUcgTNzkBbndjt4FS9805/sSxn
         BswGop2gc7ip6hmlEXlUCwQutrOTXmCNohq01I/pADh6Tm6SZ+ylKYJGanO0rzRWTP5L
         /u7CA4AtrPtIrYkiBtW9efrWUp3/+3g8gaOcD3r+ptBoO54Jab7FQTa9RodJ/ScSxTfW
         P6f1aipfQr3QZ7UWHQcPOBRoFSLG42QCdwjrQ5nQj1qBmiauMndodYTwh75QhUvGGtRr
         OxlxCry3ENu6lKzQ8uOoUfIR+v8kpPrnQGmJaxKJ6np8fWvVaxNFsKmBtH+ClMGd412b
         LgRA==
X-Forwarded-Encrypted: i=1; AKwUvBwFdqGf/n6PJ3TmICoxi0pMq+a1H6r+vY8UU0TKk05DsEP4KMy175GDCvEgJhOOLDrSZ3QzunhjjQep@vger.kernel.org
X-Gm-Message-State: AFq9FYKGlxNfAlE21gflgFy3wAcuKh5cMJndsNNItHfvT/WDIcT2j4Dk
	LnJTh0ZH/QVGa7HTv+RF8u+ZPA8i5PaUaGnzz5y8M1YNAQfcQRSt3qe19fkLpmcsBJq3
X-Gm-Gg: AYBFou32+CMA5iKJ4fIZxJ/xDjGORR5gGX+Y4Y99zB/YPCb2Yrnz8xW9GSixiuqDPaM
	C1JkIEPtE8sW3Kdzw7uo6TrllaLYWqhtObSvOMq/MSABGMjHx3yuh055HyN8+feWGinKlSeISKf
	iiU6c4FqHQmoekKznlUqvAWbywASxyNpwEn4rApJXvdzrwHCirRdYuDQqWegvJ5FibvKc70VH2p
	qw61gVU4TDKfQL+L9yfOr1dLL3YAB8M9xR/Pip6RDqR4renljLipv36dW94GIaW5v0vuZ96e1H4
	sbHh7YppCkn+O3XpXd8yFxLNCbo9wNdiQJFEhuSTg99bGefgBtUZt8Wda4R5VFPXTCNloFH2W4h
	vdY1RY0xcdo1xFzWfxFaTzBzD2OodMbfvisHrB4WhCwJdm3XLVYKt+FCEORtzg1qa7Kzvkoozj8
	u7yoPKQLlL49qmOMmUR9Y/r03wGA9cFwuc8IWIblC7714Rg8fIBwtkc1mtJa8f1LdtLhKfJI9Fm
	I20i2YIGdVh4edV9CGq7aWDNn7nuLjXdvDjZQ==
X-Received: by 2002:adf:e18d:0:b0:48a:f8dc:ae14 with SMTP id ffacd0b85a97d-48af8dcaea8mr384644f8f.2.1790673495246;
        Tue, 29 Sep 2026 02:18:15 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af51c57a0sm2155723f8f.15.2026.09.29.02.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 02:18:14 -0700 (PDT)
From: Diego Oliva <diego@bynar.io>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Jeff Layton <jlayton@kernel.org>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] smb: client: reject short or out-of-range FIND response parameters
Date: Tue, 29 Sep 2026 10:16:35 +0100
Message-Id: <20260929091636.2618227-7-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260929091636.2618227-1-diego@bynar.io>
References: <20260929091636.2618227-1-diego@bynar.io>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CIFSFindFirst() and CIFSFindNext() read the SearchHandle, SearchCount,
EndofSearch and LastNameOffset of a TRANS2_FIND_FIRST2 or
TRANS2_FIND_NEXT2 response at ParameterOffset. validate_t2() bounds
the offset at 1024 and ParameterCount below 512, and nothing compares
them with the number of bytes SendReceive() copied into the buffer or
with the size of the response parameters. smb_init() places the
request and the response in the same cifs_request allocation and
cifs_buf_get() clears only the start of it, so a short response with a
ParameterOffset past its end has the search handle, the entry count,
the end-of-search flag and the last-entry offset read out of the
request that was just sent, or out of whatever the allocation held
before, and a ParameterCount smaller than the parameters has them read
past the end of the parameter block. The reads stay inside the
allocation, but what they return is not part of the response, and
CIFSFindFirst() then hands back a search handle the server never sent.
That handle is sent back to the server in the next FIND_NEXT2 or
FIND_CLOSE2, so two bytes of the buffer leak at an offset the server
picks.

SMB1 is not negotiated by default; reaching this code requires an
explicit vers=1.0 mount.

Reject a response whose parameter area is smaller than the response
parameters or extends past the received length, returning smb_EIO2()
with a new smb_eio_traces value for each of the two responses, like
the other response checks this file gained since v6.19. Backports to
trees before v6.19 need smb_EIO2() replaced with -EINVAL and the
trace.h hunk dropped.

A conforming server is not affected. The parameter block of a
transaction response is part of the SMB, so ParameterOffset +
ParameterCount cannot exceed the smbCalcSize() bytes that
SendReceive() copies, and the response parameters are 10 bytes for
FIND_FIRST2 and 8 bytes for FIND_NEXT2, which is what
T2_FFIRST_RSP_PARMS and T2_FNEXT_RSP_PARMS hold.

This patch depends on "smb: client: reject FIND data areas that run
past the received response", whose declarations it extends.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org> # 6.19.x
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
 fs/smb/client/cifssmb.c | 32 ++++++++++++++++++++++++++------
 fs/smb/client/trace.h   |  2 ++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 107ca76e53d1..962877450eca 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4412,7 +4412,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	TRANSACTION2_FFIRST_RSP *pSMBr = NULL;
 	T2_FFIRST_RSP_PARMS *parms;
 	struct nls_table *nls_codepage;
-	unsigned int data_off, data_count;
+	unsigned int parm_off, parm_count, data_off, data_count;
 	unsigned int in_len, lnoff;
 	__u16 params, byte_count;
 	int bytes_returned = 0;
@@ -4531,6 +4531,17 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
+	parm_off = le16_to_cpu(pSMBr->t2.ParameterOffset);
+	parm_count = le16_to_cpu(pSMBr->t2.ParameterCount);
+	if (parm_count < sizeof(*parms) ||
+	    parm_off + parm_count > (unsigned int)bytes_returned) {
+		cifs_dbg(FYI, "%s: bad parameter area offset %u count %u for response of %d\n",
+			 __func__, parm_off, parm_count, bytes_returned);
+		rc = smb_EIO2(smb_eio_trace_ffirst_param_area, parm_off, parm_count);
+		cifs_buf_release(pSMB);
+		return rc;
+	}
+
 	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
 	data_count = le16_to_cpu(pSMBr->t2.DataCount);
 	if (data_off + data_count > (unsigned int)bytes_returned) {
@@ -4545,8 +4556,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->smallBuf = false;
 	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol + data_off;
 
-	parms = (T2_FFIRST_RSP_PARMS *)((char *)&pSMBr->hdr.Protocol +
-					le16_to_cpu(pSMBr->t2.ParameterOffset));
+	parms = (T2_FFIRST_RSP_PARMS *)((char *)&pSMBr->hdr.Protocol + parm_off);
 	psrch_inf->endOfSearch = !!parms->EndofSearch;
 
 	psrch_inf->entries_in_buffer = le16_to_cpu(parms->SearchCount);
@@ -4577,7 +4587,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	TRANSACTION2_FNEXT_REQ *pSMB = NULL;
 	TRANSACTION2_FNEXT_RSP *pSMBr = NULL;
 	T2_FNEXT_RSP_PARMS *parms;
-	unsigned int data_off, data_count;
+	unsigned int parm_off, parm_count, data_off, data_count;
 	unsigned int name_len, in_len;
 	unsigned int lnoff;
 	__u16 params, byte_count;
@@ -4661,6 +4671,17 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
+	parm_off = le16_to_cpu(pSMBr->t2.ParameterOffset);
+	parm_count = le16_to_cpu(pSMBr->t2.ParameterCount);
+	if (parm_count < sizeof(*parms) ||
+	    parm_off + parm_count > (unsigned int)bytes_returned) {
+		cifs_dbg(FYI, "%s: bad parameter area offset %u count %u for response of %d\n",
+			 __func__, parm_off, parm_count, bytes_returned);
+		rc = smb_EIO2(smb_eio_trace_fnext_param_area, parm_off, parm_count);
+		cifs_buf_release(pSMB);
+		return rc;
+	}
+
 	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
 	data_count = le16_to_cpu(pSMBr->t2.DataCount);
 	if (data_off + data_count > (unsigned int)bytes_returned) {
@@ -4672,8 +4693,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* BB fixme add lock for file (srch_info) struct here */
 	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
-	response_data = (char *)&pSMBr->hdr.Protocol +
-		le16_to_cpu(pSMBr->t2.ParameterOffset);
+	response_data = (char *)&pSMBr->hdr.Protocol + parm_off;
 	parms = (T2_FNEXT_RSP_PARMS *)response_data;
 	response_data = (char *)&pSMBr->hdr.Protocol + data_off;
 
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index bb8d0197cb54..2708bedb49ab 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -30,6 +30,8 @@
 	EM(smb_eio_trace_ea_next_offset,		"ea_next_offset") \
 	EM(smb_eio_trace_ea_overrun,			"ea_overrun") \
 	EM(smb_eio_trace_extract_will_pin,		"extract_will_pin") \
+	EM(smb_eio_trace_ffirst_param_area,		"ffirst_param_area") \
+	EM(smb_eio_trace_fnext_param_area,		"fnext_param_area") \
 	EM(smb_eio_trace_forced_shutdown,		"forced_shutdown") \
 	EM(smb_eio_trace_getacl_bcc_too_small,		"getacl_bcc_too_small") \
 	EM(smb_eio_trace_getcifsacl_param_count,	"getcifsacl_param_count") \
-- 
2.39.5

