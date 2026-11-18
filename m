Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961323;
	b=Z0/qcz9jMM/PwdvYWmb9z7/4kbNL++gB2xC+O5D9qAbr4JfZ4vBcJhFMLUfcsiRbENU9
	 MmnhqS85k4tTDgLY+AkdIMX88f+roT/+MNP7vS7WLVUdluEMFau0UDiH1+5yq1wyAEsZK
	 OhrpWuWqG3BPOQiNEumMS9m9loY8HTqj6JFu6ME/b23/OQZDRa9UyXUn54D/EqpJWCYpt
	 PwMSqVsWauof0m2JYetdhku94ZJ0IizhWz9P8H/SWgot8SPSe0PgFTIL2BddYZmbb57u5
	 KC5BCCMZXmmUgxBk3wW7tHUxY3KE3uxMThBWGgTk/MWmtE7aociWnh7IyeC1s1CIfYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961323;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3pL4qI55xeS4q74Qd8OgYkkf11qD+6PkbWN1emyH6OE=;
	b=TCnZ8IMgN/FNe2I3j1ojI6kLougTPoKjAgLL/5t3HvcvaBu5imU/ilrQ87U+yBlnrv3V
	 FrnnDD1slBMGdk8cH4QsWYppmlWRO2tPudgRFQFuVPw/WVBPMvgEcr/wK2PDH8ig+KGcf
	 7PVdXljomadUjCjl5kKSyKYP5F2/cx1Jt3Dn5QCPS3rETah3aN+hgv14LZEnaFU3RDlWz
	 A2BiLvOk4AcwhJdIB24pkoxkLtua+2mrr63muDRrQ5ous6ZqhoveygCMSrDgpMMZt/uG1
	 KI1DlV9Sp4ZDGCQiN1dhUg0sMIWfdz59FhhvDjRqUX4FIALDi/yTHzuH+bafaueiRJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q3jfxspY;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20343606A32C
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 00:22:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20343606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q3jfxspY
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-380b40312e2so1307051eec.1
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 16:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794961322; x=1795566122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3pL4qI55xeS4q74Qd8OgYkkf11qD+6PkbWN1emyH6OE=;
        b=q3jfxspYnnmIioOhnT9WDmbOP6gFnX+nkFOI7kWL1h+Kp911buehA+yTYCfvblGRh9
         ZWOHch3rQHqhIQAEPJa+Z+5kYNRUDvzeYEBOJ3nqxL/yy22hememUcsYbz3N8pV3IjiH
         D50KILEjYQhXC/K4+xfniLhGz1AePT5EA/NeXlau5vctxZJUG69xtxJSfsA+t7GuGvmK
         iTrtetAa/lEwdJWbVKP1+tJWNMbmqqcU0mPe4S1kLIXZjvAdzN4ZzZ9ij/ydQCcs0t8O
         Vckp+QP5ajZG3pihMPwv190bAIvIOaZw6Fl+skcA56hsR23mHhdQX2hLjYhGQzoSDBuP
         VXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794961322; x=1795566122;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3pL4qI55xeS4q74Qd8OgYkkf11qD+6PkbWN1emyH6OE=;
        b=aw5qqepJmo2jP/g9dlGkoXZ1hQ7KoTeb6ZIqajQ0go0bQeT94SSUlwoFQdZHoJXfwM
         6nJr6yOgNhnpRdKvcuKxFQQItAhLt0D6G19D7cMuJDjpXDjLArpLLrprQdP9ANrXc1H6
         OKMDabfnWQ4tYHXYj+FsfJUrFS1NRlMMDv+FGmtwSDNrQFQDy/BY8tYViL5isdaESUNE
         mwCN5/4n1XxSTXFxhOpouE+G97IIcirWAkrDkjumV8meH5qfucTiiqzhNGCgPbuuMC7M
         vu6RDoqVx/q1MEQoenD5A44mSdE/9nuUoSe4enhfxiOiVEVIDD7/8dn3S1cu4HtkPNgO
         TXSQ==
X-Forwarded-Encrypted: i=1; AL+hErFeMlO4mAi7HiGWBc4hWrbd+3hj5Iq9UKDJBBuMUK3V3CzzbWGhS7aEEPjvGUx297CJf2h5S0INGUzW@vger.kernel.org
X-Gm-Message-State: APuU4Z+puz2unijvwJgfx+ZKA1T4CYI0WHmMbvN/bjEebovn4cQWc8fX
	kJFXwVScrAqvYN36qlLkEgUNG8sbLVdLAlpDY5qKWTibm2oNZIDT3Zq6
X-Gm-Gg: AYBFou10+HGU426csgc5k659qCY7Isnjgy6Vir2FuKj0c5f+ITY6VwIsA1keppQr/GG
	Fi0WG12V/k7EXHv8HbKpX9wRszmHimEYF4AnFA1s1byynOp0Q6GaKvefz0Ym9fGj05FfTPcerkZ
	1if72Lrv1tcSWRLAnA6KygqcEfFIPPV+0Ld6rU8dvWsIVY/eqOwZUHrO9IZEqsyfvfjJYxgXjEZ
	GDK7+JoSskkBJ95gxVNerbRHIyc9fGQ1Q3Ds2jG4WC2YFXWoTPehBhy4raGDIAg5ac+HfSrlkqp
	bzAPM4L6dEoc3m7cWbNSj2mHeuVgJaWIZHIrFdC3qUV++8oSIIkAx87T/wd4/4c1D385IRh77qj
	gKzavzwwN33shcTzqXS6tClJa+GN+r2foMU6puxWR/mwMgf2WuejFFV4W4v71cEjRgdm3SdVU4m
	haxT77VxD7UCH8ZcO0yn/0xa8RB3/hTk8cRIf/I+wkV6jbeD6SQ9jdrVg0Z6Yg7/FyxFFXpuXJs
	B7V/vhtqj5K7hJzyki4ToX/dacnRzvPsR9b1UqGHmjEz3zPAhpG3dWGkLL+c2DpsVP/8WBFDSo3
	V8vzDWsIG+bL/rj7BCAXgcV0mLg+B2PcmG1/B/zSuKxE2IKquDEtAvR1Dtm6MUJ3ePqLigHSSBZ
	9fqeS9tMvQg/6gLVDvI0/4GxP9e1e8KJsdj74urw5cmckFqIrEA==
X-Received: by 2002:a05:701b:2806:b0:1a4:c892:b130 with SMTP id a92af1059eb24-1b543beb5bemr978760c88.15.1794961322120;
        Tue, 17 Nov 2026 16:22:02 -0800 (PST)
Received: from localhost.localdomain ([2601:646:4300:d042:b1a7:bebf:2fc7:37b1])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5446f954dsm1665354c88.2.2026.11.17.16.22.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 16:22:01 -0800 (PST)
From: ozgun kultekin <ozgunkultekin@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	netfs@lists.linux.dev,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: do not let the server grow a write subrequest
Date: Tue, 17 Nov 2026 16:21:59 -0800
Message-ID: <20261118002159.20576-1-ozgunkultekin@gmail.com>
X-Mailer: git-send-email 2.56.0
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

smb2_writev_callback() takes the byte count from the SMB2 WRITE
response, masks it with 0xFFFF if it is larger than the request (for
old OS/2 servers), and then copies it into wdata->subreq.len.  A server
can return a count that is still larger than the request after the
mask, for example 0x8002 for a 5-byte write or 0xFFFF for a 4 KiB
write, and the subrequest then covers data that was never sent.

netfs uses the subrequest length to decide how far the write collector
may advance.  With a grown subrequest the collector moves collected_to
past the data that was issued: netfs_writeback_unlock_folios() walks
folio_queue slots that were never filled, and
rolling_buffer_delete_spent() frees folio_queue segments that later
in-flight subrequests still use.  This is a use-after-free that a
malicious or broken server triggers from an ordinary write:

  BUG: KASAN: slab-use-after-free in netfs_limit_iter+0xed4/0x1040
  Read of size 1 at addr ff11000010561511 by task kworker/u8:4/63
  Workqueue: events_unbound netfs_write_collection_worker
   netfs_limit_iter+0xed4/0x1040
   netfs_retry_writes+0x1410/0x1e90
   netfs_write_collection+0x2647/0x3880
   netfs_write_collection_worker+0x1cd/0x3e0
  Allocated by task 141:
   netfs_folioq_alloc+0x39a/0x470
   rolling_buffer_init+0x29/0xc0
   netfs_create_write_req+0x12f/0x840
  Freed by task 42:
   rolling_buffer_delete_spent+0xb1/0x220
   netfs_write_collection+0x1f62/0x3880

Never change the subrequest length from the response.  If the count is
still larger than the request after the mask, fail the write with -EIO
and record it with a new write_overlarge trace point, like the read
path does with read_overlarge.  A short count still returns -ENOSPC as
before.

The folio_queue form of the use-after-free exists since
commit cd0277ed0c18 ("netfs: Use new folio_queue data type and
iterator instead of xarray iter").

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Cc: stable@vger.kernel.org
Signed-off-by: ozgun kultekin <ozgunkultekin@gmail.com>
---
 fs/smb/client/smb2pdu.c | 17 +++++++++++++----
 fs/smb/client/trace.h   |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b26bfb4bd..2f05ba613 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5181,14 +5181,23 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		if (written > wdata->subreq.len)
 			written &= 0xFFFF;
 
+		/*
+		 * The server must not report more bytes than were sent.  netfs
+		 * uses the subrequest length to work out which folios this
+		 * write has finished with, so it must not be changed here.
+		 */
+		if (written > wdata->subreq.len) {
+			result = smb_EIO2(smb_eio_trace_write_overlarge,
+					  written, wdata->subreq.len);
+			break;
+		}
+
 		cifs_stats_bytes_written(tcon, written);
 
-		if (written < wdata->subreq.len) {
+		if (written < wdata->subreq.len)
 			result = -ENOSPC;
-		} else if (written > 0) {
-			wdata->subreq.len = written;
+		else if (written > 0)
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &wdata->subreq.flags);
-		}
 		break;
 	case MID_REQUEST_SUBMITTED:
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_req_submitted);
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 5331ce6dc..18760a819 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -153,6 +153,7 @@
 	EM(smb_eio_trace_user_iter,			"user_iter") \
 	EM(smb_eio_trace_write_bad_buf_type,		"write_bad_buf_type") \
 	EM(smb_eio_trace_write_mid_state_unknown,	"write_mid_state_unknown") \
+	EM(smb_eio_trace_write_overlarge,		"write_overlarge") \
 	EM(smb_eio_trace_write_rsp_malformed,		"write_rsp_malformed") \
 	E_(smb_eio_trace_write_too_far,			"write_too_far")
 
-- 
2.39.5

