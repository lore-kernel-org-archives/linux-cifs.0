Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792641218;
	b=jOj/kipPSFYcERTF7WCjF8SoZU31FqTxfp7PNaPAAk3xGxg+2xTNYmX0Oj7uEyj6Guyy
	 S5oQwtAUCH1+kfq7Un/KsCxajrLj0WUUjB0sKVO4RYSHrdcr4Vvs3ylBhL+JyOraHcdMi
	 PS1QjlHfXva21w6sF2sWRh2fn1iVUKdsnpbKHDCXpnguPthesQOFMqSQo7i1YuZtzVpq4
	 r9U2tRiHk9JsoJcq9fuaixIUHuJVMlsi/ESZf/Tqx812YXGkxse5qq5rHgxz9CgHVWFvs
	 4gJ+l3u+9dXCPwloMFxWZEkaBQjjT9gcdo3CCyU1yj12tCDl8MyKTPOH4V+8cdqgdHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792641218;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=81J3smnygA2s3kCWaWEydJPIgP+ALOjjSzDrlRy5GOM=;
	b=X4lxtCi7PJo8j1QICCGnrYlHyqU9aY2G9ZEDVPLqq1lqRzydeyXR9I3BnT3OqhZLgssi
	 Djiz04UtY21EGvdJZ2LGhBDOurCxw4TCWhsQSUfrFBHA4kHInZb7IRJXOn01OXI5C20Ev
	 21FcjvdiTUG4owE0jtE4g/zpUDHaaEl8FTGxsyt+BdTCrqwkbYizkEanuJdY2IgSiZemx
	 DhpxI++MjQLSaEWcYgfZGUGM8nOrb5J/h0e5o4K0PMyvF8CGC4Gsc6dXGP9RIuPx8p2RY
	 zhZi1XiVztpNQ2tEZPvEN9zs903sl/Zz3GUxRShmqXBbdf74+NQ6sjVfqZ1MpE762Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=h5dPeZ+P;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A41606A320
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 03:53:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36A41606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=h5dPeZ+P
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49d05d51553so9795545e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 20:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792641217; x=1793246017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=81J3smnygA2s3kCWaWEydJPIgP+ALOjjSzDrlRy5GOM=;
        b=h5dPeZ+PhvVJ8IkAxiRIc1zrTHCrLKeJW357TN6gvuntRyx0ZT/+C1AcDCauXQtabp
         WhNMS7vkHg090RJHV7vJwxdspfaISi+2t3JlViBluJldeYQTRTqQdT9duypTfFQXrnWs
         4w1KFEEPD63yxsjx3m9hvXrthhDen3863XVvyLrVsxYUaCXIlMoJzVXj86wV3oPkjqVS
         o5t6+90xP9/B5yiWbIyLw0yaHgvkqJaJ0vEHq3sUrri7/bZJmUM9l8DFCFvZYDtTNucb
         rrTSqQEeiFDAWyQpnerEJfZUYvKdk9uZSaY5BU2mh0a0XDTY5tjQCOCBCkuu9Mnw48Xp
         tbFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792641217; x=1793246017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=81J3smnygA2s3kCWaWEydJPIgP+ALOjjSzDrlRy5GOM=;
        b=eHqjs8mQnJhi/YCaVtdwcb5n6OqeY8TVVvjekzhMV9eLU8EOURH3i5BxuY78dlrhX9
         bwUhIViZUfzhCxcfABjgHjjbu6SDNo7c/K/Qq2BYtc3SJdwnqSi18O3R+cfhygNmDSIV
         b25s+tyZZnNHfGiLO3udg6jH80qmyVBL4wdSrEGlIj8UvxtjxGHo5/plHn5J9BtEs/6x
         DXK53uJk/fk1PrLhjAMy05MdXACCW8SIN81Pjbcwmx0ZIYqqMlAfIkxspvEUvi6VF0Gm
         yC6ierK7MpdyJBAFqQeD2DIHonRrGlR7JyUeTfuSfYtcULLEk+ljHP6y1QFUYNFhkoCu
         bBOg==
X-Gm-Message-State: AFq9FYKuIf9EG5HZsfg0Uob6ymLbZjwXu+TPkGuFJ7HQIkq9QLHVIhOz
	SY6vRQgy0wO7R1+p1f5Lg372k1u+hyOR82bnjy74CVIPNMHcfEhSC3mcthyvkA==
X-Gm-Gg: AYBFou1BoJWXbHjl41bmw+Y5C1TKTE/Ao48Z1vBKhD4JMishSoeV4U0QPYaKcXr1X6x
	2vsqv2quGNEX2JqRQWsZUSrfNpGtdgrShD0C6j2TXLOUv/uCA8w+FFBRVtCMNtCbI8nWDusP8g8
	QQ3q3o7EqYabsNkltPbuN9nLB/bOhQsKlFfVAyx3C/cZWJALzmRlsEfZ7guzzzvx5f4gdrS4M25
	XJZE81AM3V6+ky5eNwhs9xd7okzUWtopWRFDvmox/lY4z/pSZnDYYxAIH0ZRpNTmVDuq9BtF5Vc
	s2zPJYqJsgYAslVByxCvW3r0FxAsO6YkkfM3xXE30rAaPq5lJ4mvcUPpwAYyPjw0Qp7MnRj3WQE
	ukDFhAy1HYbgSJr/hsYFovdmxYFbmeL860WQfoNaXFzp7DMuXY0JrtCI/P/+3x+ZShEiUThMwW5
	syE60aZWGsjIkbbTqiVqRFb1NuXPaoy0G68syF2wBp1yzYFgHtLVTSlifypMHSXvKR+jocGKGiw
	rKfr2W1mugZO3CMlALsbG4UIjCdUVhUNjNPhFevFI459goB71pWyRBsqVDQYkhh8tAHPvF84uzI
	C87czLOEKBpYd9udDj8SN4ybPSIWgNs=
X-Received: by 2002:a05:600d:4:b0:4a1:825a:56fd with SMTP id 5b1f17b1804b1-4a1fdd39eddmr63730625e9.32.1792641216572;
        Wed, 21 Oct 2026 20:53:36 -0700 (PDT)
Received: from SurHub.localdomain ([102.213.69.52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fcd70027sm44020925e9.0.2026.10.21.20.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 20:53:35 -0700 (PDT)
From: Abdifatah Suruur <suruurism@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: validate the data area in SMB2_read()
Date: Thu, 22 Oct 2026 06:53:29 +0300
Message-ID: <20261022035329.17871-1-suruurism@gmail.com>
X-Mailer: git-send-email 2.53.0
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

SMB2_read() copies le32_to_cpu(rsp->DataLength) bytes from
(char *)rsp + rsp->DataOffset without checking that the range lies
within the response actually received. A READ response with
DataOffset == 0 makes smb2_get_data_area_len() zero the data length, so
smb2_check_message() accepts a frame as short as the fixed response,
while SMB2_read() still uses the server-supplied DataLength, capped only
by CIFS_MAX_MSGSIZE and the caller's length.

A malicious server can answer the synchronous read used by the
mfsymlinks (or SFU) symlink parser with an 81-byte READ response
carrying DataOffset 0 and DataLength 1067, making the client copy 1067
bytes from a 448-byte receive object (KASAN slab-out-of-bounds; up to
16 KiB in the general case).

Clamp a zero (or header-overlapping) DataOffset to read_rsp_size, as
handle_read_data() does for the asynchronous path, and reject the
response unless DataOffset + DataLength fits within rsp_iov.iov_len.
The SMB1 helper was fixed the same way in 5be5bdda5863.

Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/smb2pdu.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f276acf7b..8291eadd7 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4947,6 +4947,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	unsigned int total_len;
+	u16 data_offset;
 	int flags = CIFS_LOG_ERROR;
 	struct cifs_ses *ses = io_parms->tcon->ses;
 
@@ -5006,8 +5007,29 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 		*nbytes = 0;
 	}
 
+	data_offset = rsp->DataOffset;
+	if (data_offset < io_parms->server->vals->read_rsp_size) {
+		/*
+		 * win2k8 sometimes sends an offset of 0 when the read is
+		 * beyond the EOF. Treat it as if the data starts just after
+		 * the header, as handle_read_data() does.
+		 */
+		cifs_dbg(FYI, "data offset %u inside read response header\n",
+			 data_offset);
+		data_offset = io_parms->server->vals->read_rsp_size;
+	}
+
+	/* The data area must lie within the response actually received. */
+	if (*nbytes && (size_t)data_offset + *nbytes > rsp_iov.iov_len) {
+		cifs_dbg(FYI, "bad data offset %u length %u for response of %zu\n",
+			 data_offset, *nbytes, rsp_iov.iov_len);
+		rc = smb_EIO2(smb_eio_trace_read_bad_offset,
+			      data_offset, *nbytes);
+		*nbytes = 0;
+	}
+
 	if (*buf) {
-		memcpy(*buf, (char *)rsp + rsp->DataOffset, *nbytes);
+		memcpy(*buf, (char *)rsp + data_offset, *nbytes);
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	} else if (resp_buftype != CIFS_NO_BUFFER) {
 		*buf = rsp_iov.iov_base;
-- 
2.53.0

