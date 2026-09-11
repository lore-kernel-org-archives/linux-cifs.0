Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D96360EF7
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138726; cv=none; b=AfKU/ZZ92j4ByW1ZeryeVaE6F/ohSWfEZltzcXR9257bVbaeNljDr4iZ6yuqkKz+oR0iDe4fS9YfDw0NcP6wytcBygNKMmJK3K2VUAX0ZxQ7u+CWkGmHV+H7A0YQPi0LqY1Xhbb7DXXk8unxHHCUT+pAC0F2oUhmg4ZC8eIzPIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138726; c=relaxed/simple;
	bh=6U2KyYESRummjrFiAB7QS+VzeYDYkDkZ1bo7japatKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=apZWCKfL4h7w7+t2OZAKTdW6L7TiT7QtC47rIDucJ28KstwjN93qDUO7V7k78XEAfb0GFa5M0thEDHzwrEFjATMJDQn5F/3OcWZIo5a5iyLIc8vnYgMHiWovjAzihTeatlFf8jhuCNywXit3HiKQSxtjNM7Vc1djDhSNJmZH2aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=FrDbkANP; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="FrDbkANP"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso12014635e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 07:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1789138719; x=1789743519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QJDLLy3mcgmNCllNfuwiuaOIAc//JDOWE+yHQCqzUAQ=;
        b=FrDbkANP9Qg8oSbW+WZDxccE5+J/bhYgR/69T65UIPo62HSvAPD4t4MiP6YiCRcbxj
         CWqmNPBcqelM4IfqdbYw6BksGk+bw89lJecmM8tOlJt/RBvVadZdkpf5cRqlHZHIyeTY
         gQefWPH8Zpr9Er+iZC2gZjK/Ib3q9dyw6KFDGKR1ymG9athpbeMn5ICkE8gYyi24x/iD
         3/JBykkCl2jUu6CsEM81MBjWdBXE8hpbwKa14fZP+zluhfmeORDMREwLp2cohSfbzn8d
         cm8cZ9jDbm3Scv1K+uYBcPdYrPhFTIbUIsZQIUOLU9F3aQdG1rbFom3692Cl+h1ZMvVg
         Fqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138719; x=1789743519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QJDLLy3mcgmNCllNfuwiuaOIAc//JDOWE+yHQCqzUAQ=;
        b=oqDbAcKfzG5TYNUcky0a2uIgA67W/sMhxDB4GnbbRo85x0OS65DuvypqctopcsYB0G
         ULLXwtuIJ2yyVT6wCK/tQryDg+XeVyT1vsa+ZZimWx4RJoA2up8loU147CY7molzMLwY
         W/QGFNC2/VkaRiEZMjJ9WI1lq2P6mTb2NVnFTp1yTJx6Bu173U4uSy7MyvnQhi8IdDzq
         HJ/OZxNGGAgNXIIVwC+vDck+HqhDfMaOoofxIEMAZfjUfY4sjkNXNxJWuq3HwqmGoPun
         ANpW6llTpS58aSyG09Gwix5kiBN2oLFhGXCvd3DZSs3AA/iBarc79qpbq1Ra7lZLq9+Z
         VafQ==
X-Forwarded-Encrypted: i=1; AKwUvBwVwBqfcos60YbEfWbnHqQilqXSe64b4NXTewV6r1f4lBQHD91XHG8Uu3MRfW7fEgpgWB6lr9E4MLsG@vger.kernel.org
X-Gm-Message-State: AFuF++mkB4ZcMzV2vQsWPjsdIP5TmRpfmCm6PdgAc+0nhoSGzaKmSBf6
	zJIl4HJfIXKXFVbhEhQhcxOIEh3G5jhp4766kbkZMRnPCLkYWMpD5+xpq5SQDNb6cdEu
X-Gm-Gg: AYBFou3D4r28l54tW8GDVhlPjd8PFbWByhOtazTrRo/bgBee2X0C8ipNj5QIWZ+FjDd
	E6xZVx2ma4V5XTiO7IiSglWcHpqIwwX3T7MUgchpBNLYex9QZu2taFs5tlhENPdWxuX4W1X1Ohg
	3WWxLo6Dm/FrKvZvpyBTD6QGs1Q7lQpeUEE7bTsjCdCJqjNlWhOvWyRpomIV3HzWJ+VXIp4O4q+
	xtXvy6iFJkPafUnUzY7peXxGmfFOBMjZjV0871ur7UMWhQGztJSrgzg7f+tggtcmdhVbI3MNit1
	7hzP7ri5ZAR4AyWRjBz31KV/1tBygWV6G6PlnRsP+p2vf23lryAS5xffebG+gUps/by1vNI3+Rh
	bUUl/SveH1EEaQvQlcR5A31zksbFrRXfw9lCJWnUi+Pxm4mxjiNtJQqmty8OqrktHrTFvvbJOQM
	NhJJdHxdhoIjwhwmGmrMtomFogQ4lfRdc2xzemXjHlVx+ES6jb6MUDm8zMB97FDgEUl8fNiNzJp
	G2bJvLH0jL/Xk7wF9c91euL5rZ4
X-Received: by 2002:a05:600c:4fc8:b0:49c:cedc:3c36 with SMTP id 5b1f17b1804b1-49e619bd0femr54492545e9.16.1789138719577;
        Fri, 11 Sep 2026 07:58:39 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e61a81943sm50432915e9.1.2026.09.11.07.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:58:39 -0700 (PDT)
From: Diego Oliva <diego@bynar.io>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] smb: client: reject short WRITE responses in the SMB1 write paths
Date: Fri, 11 Sep 2026 15:57:56 +0100
Message-Id: <20260911145758.3833254-2-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260911145758.3833254-1-diego@bynar.io>
References: <20260911145758.3833254-1-diego@bynar.io>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_writev_callback(), CIFSSMBWrite() and CIFSSMBWrite2() all read
Count and CountHigh out of the WRITE_RSP returned by the server
without first checking that a whole WRITE_RSP was actually received.
The length of the response is available to each of them, in
mid->response_pdu_len, bytes_returned and rsp_iov.iov_len
respectively, but none of them constrains it to be at least
sizeof(WRITE_RSP) before those fields are dereferenced. In the
asynchronous case cifs_check_receive() has run first, but it only
verifies the signature and maps the SMB error; it performs no length
validation.

A malicious or compromised SMB1 server can therefore return a response
shorter than the WRITE_RSP header and still have it parsed. In
CIFSSMBWrite() the response buffer is the request buffer, since
smb_init() hands out a single allocation for both, so the count is
read back out of the request that was just sent; in the other two the
reply lives in the demultiplex thread's buffer, so it comes from
recycled slab memory. Either way the client reports a number of bytes
written that the server never sent. SMB1 is not negotiated by default;
reaching this code requires an explicit vers=1.0 mount.

Reject the response unless it is at least sizeof(WRITE_RSP) bytes
long. This cannot reject a conforming server: WRITE_RSP is documented
as wct = 6, so the smallest valid reply is
sizeof(struct smb_hdr) + 2 * 6 + 2, which is sizeof(WRITE_RSP).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: c28c89fc43e3 ("cifs: add cifs_async_writev")
Cc: <stable@vger.kernel.org> # 6.19.x
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
 fs/smb/client/cifssmb.c | 21 +++++++++++++++++++++
 fs/smb/client/trace.h   |  1 +
 2 files changed, 22 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f9aff0712794..b1525d491ce5 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1880,6 +1880,12 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 	if (rc) {
 		cifs_dbg(FYI, "Send error in write = %d\n", rc);
+	} else if (bytes_returned < (int)sizeof(WRITE_RSP)) {
+		/* check that the received response can hold a whole WRITE_RSP */
+		cifs_dbg(FYI, "%s: server returned short header. got=%d expected=%zu\n",
+			 __func__, bytes_returned, sizeof(WRITE_RSP));
+		rc = smb_EIO2(smb_eio_trace_write_rsp_short,
+			      bytes_returned, sizeof(WRITE_RSP));
 	} else {
 		*nbytes = le16_to_cpu(pSMBr->CountHigh);
 		*nbytes = (*nbytes) << 16;
@@ -1927,6 +1933,15 @@ cifs_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		if (result != 0)
 			break;
 
+		if (mid->response_pdu_len < sizeof(WRITE_RSP)) {
+			/* check that the received response can hold a whole WRITE_RSP */
+			cifs_dbg(FYI, "%s: server returned short header. got=%u expected=%zu\n",
+				 __func__, mid->response_pdu_len, sizeof(WRITE_RSP));
+			result = smb_EIO2(smb_eio_trace_write_rsp_short,
+					  mid->response_pdu_len, sizeof(WRITE_RSP));
+			break;
+		}
+
 		written = le16_to_cpu(smb->CountHigh);
 		written <<= 16;
 		written += le16_to_cpu(smb->Count);
@@ -2150,6 +2165,12 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 	} else if (resp_buf_type == 0) {
 		/* presumably this can not happen, but best to be safe */
 		rc = smb_EIO1(smb_eio_trace_write_bad_buf_type, resp_buf_type);
+	} else if (rsp_iov.iov_len < sizeof(WRITE_RSP)) {
+		/* check that the received response can hold a whole WRITE_RSP */
+		cifs_dbg(FYI, "%s: server returned short header. got=%zu expected=%zu\n",
+			 __func__, rsp_iov.iov_len, sizeof(WRITE_RSP));
+		rc = smb_EIO2(smb_eio_trace_write_rsp_short,
+			      rsp_iov.iov_len, sizeof(WRITE_RSP));
 	} else {
 		WRITE_RSP *pSMBr = (WRITE_RSP *)rsp_iov.iov_base;
 		*nbytes = le16_to_cpu(pSMBr->CountHigh);
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index b442cccd1530..a0ad8068425e 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -150,6 +150,7 @@
 	EM(smb_eio_trace_write_bad_buf_type,		"write_bad_buf_type") \
 	EM(smb_eio_trace_write_mid_state_unknown,	"write_mid_state_unknown") \
 	EM(smb_eio_trace_write_rsp_malformed,		"write_rsp_malformed") \
+	EM(smb_eio_trace_write_rsp_short,		"write_rsp_short") \
 	E_(smb_eio_trace_write_too_far,			"write_too_far")
 
 #define smb3_rw_credits_traces \
-- 
2.39.5

