Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A793542F8
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 14:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138728; cv=none; b=oORcCn+fNQzhxnGKC/KSMazB7KRjSmcJD8dz1kwzPdM1+AWNPps/lkYv1kjcb9cVTLsDY3iQCOcLzk/ML5H7O7OD7VUj6CRB5jLgmnVdOQIOPj2DtlhWiodBmZAiq/BcKbljhKQpPazLhGAlRF+E8MGeakZlNblQ74LXD6Dm528=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138728; c=relaxed/simple;
	bh=tXun5SzxalV9Hzmv86f5QD4391irUID86zoYreFOlLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tC2oTvYXuBXzZ+fC6J9P0C6YA1SC3mR2fZc67wx3Qm7J/us+BPQNXm7LjGea9NJWbkZUbWMgXMgaPknxWCd7odXKYKDGPUtB4aAgKwbysYR4Y2j/YlTJRlajMXcWMEtsGE2Ay0r5XWwQaeD3SsBMBn2Ym5azBWEeXwYujwzkCkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=aT8XxGWa; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="aT8XxGWa"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49cca4ffdcfso8876825e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 07:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1789138723; x=1789743523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RlzncFxui7IWSYNS6TVWMZnw5flt5qN9CiLy90tWUhs=;
        b=aT8XxGWaA1H4lwsjLIrOGR34L1TRsXsLwfDZPfjDZsCnAhxvtAmXoCuQYKhj0O7oKG
         Der4jnrnt9qzb7URDLOLQMJjhVVJPQnFpBkECBaxaa93JxgMceitSOjfyH5+vZdwLtCg
         jOt8oKSoB8PkXcms94QCwyzKqUCgIbifnbpsGlRMQgkIUTSTCclYPRveDUWttSgfPz1B
         j/rUEO+obIEETotNHBuJRqU470D3LQquybYKTdJ4XOijs3CPcbrkNVhMxFUsXFOPExjB
         /qjVWVHgeKyo4Q8M/koMNwQ/4wnKUsmPdfGSmh7knKGJaO9M5NAyFGzXdzThtoNZsPxW
         hq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138723; x=1789743523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RlzncFxui7IWSYNS6TVWMZnw5flt5qN9CiLy90tWUhs=;
        b=FdpPbOcyFhbRcU3JDZbZgz00WxfPF5jjhKQ/gKoi8RJxSUzrzhwfu1giXSJziEB0UP
         XF7Hzrf+kfe5GZOroWnrjW6Ap3gcMJEDnfYS6D59UM78tjhwUVnZqDnZtJvnDDIpVhA5
         7axDQt645sWyS5t91ryec/j83TIXOzlccou/hS2apTWLkTXgKx/k7AnN2AduS+WYZlZ6
         XtVdhAUJ8pilkACDxlU7/EywtVRbj3PlAHwIIBvKw2w1OTKKX7Glh6MpXbVa+iu26kAF
         hw4f3uEO8Dp5C/w7o+kAvRC+9l+2VruSHCIZN49mSYWfi4uTc807HkCsJoCPacLr5fDg
         aIdA==
X-Forwarded-Encrypted: i=1; AKwUvBy1pethauAY12pp3NRAkfOWUOpeOgZ/oQevzryoonBYDd+UCWoOfMR7eI+W5aVuln+SL0w21WQcLMfR@vger.kernel.org
X-Gm-Message-State: AFuF++kTOnCXlRaZbd2EekUOWLCzriKiOOzTLU0h96kC/Pe9SiGygiqG
	1ztNrA+yWgRbAvQwO7t08wPOqMfPDHbiPSI2b0iTo4jelThF2prawsSIH8jMrdcwXwxs
X-Gm-Gg: AYBFou31GNlUxG8BreiLLCbYfwIIXP0br7RPrw+q+mpfU5yl/1WYOuirtzg7qMEW88E
	h+WZeABSksPGQBKWSFw2D4f34sYJj7zSHTZrgWH+6jOYTkCbd9pZa0bW2ek6Gko8KnbCOUBSyl5
	Vt3l9VWKzijlBFA/J5j3kTwelYnDsDKmv9P/sCC37Vi3TfROQPLKMxUdckYnbcEH7ShxucHN9+1
	AHbRHxL/nUoF5ZDtWkjxYKFi4ZUDwY2+0y+rHFXD0choI3uuKbZkhi4qWyMA5CgL8RVZMknpoex
	fKhSNcbxrWYxD8ZGTFiubEqHQ5Y56ioknyhoLB/EwU3Xxw7IX47LHskrFpekEbBJtvWA91iwHgo
	frAxg3wyqvFVQf7iS6MOW2u7tG+dOio0dThg3BpRvtzk9edW9eS/t52Sfhr76fHS9cKDd8AYSAW
	Wi9jutChhHRPinvaEkQCur6eclYbiW7Q1xvmhp2nflR5L+AM/TBdXqLFQ+v3vWYGDD13y7eK8Ls
	tkgBRlDyEij1exnR7O1uCVxuMhG
X-Received: by 2002:a05:600d:8648:10b0:49d:1f10:8b9f with SMTP id 5b1f17b1804b1-49e619836aemr42807155e9.7.1789138721935;
        Fri, 11 Sep 2026 07:58:41 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e61a81943sm50432915e9.1.2026.09.11.07.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:58:40 -0700 (PDT)
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
Subject: [PATCH 3/3] smb: client: reject short responses in SMBQueryInformation()
Date: Fri, 11 Sep 2026 15:57:58 +0100
Message-Id: <20260911145758.3833254-4-diego@bynar.io>
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

SMBQueryInformation() reads attr, last_write_time and size out of the
QUERY_INFORMATION_RSP returned by the server without first checking
that a whole QUERY_INFORMATION_RSP was actually received. The length
of the response is recorded in bytes_returned, but nothing constrains
it to be at least sizeof(QUERY_INFORMATION_RSP) before those fields
are dereferenced.

A malicious or compromised SMB1 server can return a reply as short as
35 bytes, a header carrying WordCount and ByteCount of zero, which
checkSMB() accepts because the calculated size matches the length
received. last_write_time and size then lie beyond the received data.
smb_init() hands out a single allocation for both the request and the
response, so those fields are read back out of the request that was
just sent, and a timestamp and file size synthesised from the path
name end up in the inode and are reported by stat(). SMB1 is not
negotiated by default; reaching this code requires an explicit
vers=1.0 mount.

Reject the response unless it is at least
sizeof(QUERY_INFORMATION_RSP) bytes long. This cannot reject a
conforming server: the response is documented as wct = 10, so the
smallest valid reply is sizeof(struct smb_hdr) + 2 * 10 + 2, which is
sizeof(QUERY_INFORMATION_RSP).

Fixes: 6b8edfe0f918 ("[CIFS] Support for mounting to older servers part 2.  Add support for legacy getattr (lookup).")
Cc: <stable@vger.kernel.org> # 6.19.x
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
 fs/smb/client/cifssmb.c | 6 ++++++
 fs/smb/client/trace.h   | 1 +
 2 files changed, 7 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 30b9621664e8..aad1c866d8e1 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4068,6 +4068,12 @@ SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
 		cifs_dbg(FYI, "Send error in QueryInfo = %d\n", rc);
+	} else if (bytes_returned < (int)sizeof(QUERY_INFORMATION_RSP)) {
+		/* check that the received response can hold a whole rsp */
+		cifs_dbg(FYI, "%s: server returned short header. got=%d expected=%zu\n",
+			 __func__, bytes_returned, sizeof(QUERY_INFORMATION_RSP));
+		rc = smb_EIO2(smb_eio_trace_qinfo_rsp_short,
+			      bytes_returned, sizeof(QUERY_INFORMATION_RSP));
 	} else if (data) {
 		struct timespec64 ts;
 		__u32 time = le32_to_cpu(pSMBr->last_write_time);
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index a1c0cb1a5833..6926a62ddb05 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -71,6 +71,7 @@
 	EM(smb_eio_trace_qfsinfo_bcc_too_small,		"qfsinfo_bcc_too_small") \
 	EM(smb_eio_trace_qfsposixinfo_bcc_too_small,	"qfsposixinfo_bcc_too_small") \
 	EM(smb_eio_trace_qfsunixinfo_bcc_too_small,	"qfsunixinfo_bcc_too_small") \
+	EM(smb_eio_trace_qinfo_rsp_short,		"qinfo_rsp_short") \
 	EM(smb_eio_trace_qpathinfo_bcc_too_small,	"qpathinfo_bcc_too_small") \
 	EM(smb_eio_trace_qpathinfo_invalid,		"qpathinfo_invalid") \
 	EM(smb_eio_trace_qreparse_data_area,		"qreparse_data_area") \
-- 
2.39.5

