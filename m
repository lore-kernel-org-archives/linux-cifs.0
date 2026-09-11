Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE5B2868AB
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138724; cv=none; b=ge2iAcPWCBw38+yQx7HQkOSo4tLWLHcdVL71ol7NPP6aVsP7r7Slk2jHWRiwBXFqsLluPldYNEo1279IYAcZwlnkJIwBfk/4BFD5PS1Fz/VsHqovQvb/+uibgG//KUMYpwdkZIOndc3itm5ridi/IX3S0in2waPm8pXdV+CBWSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138724; c=relaxed/simple;
	bh=6jxEmCc9BbzZCj2ZjVAnnfuYinsXrMRzEkJk2RpGm5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rCz8jGfoMlAC+iv95L2d/06swzCxY4s5+yjCVpU50zkb6TTcEKFYkL6UAQDEYePoS9GafB5IsgSO+nT1tZrKs+5guXKUxfjFiQOVQdyxVE7vIkW4kgqhdlLKmpt4rnV4e0RjK8k66hDExNUu96PpalHF3kr5reKIBgx5lGfESoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=To4NoGSr; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="To4NoGSr"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49ccfbe062eso11761305e9.3
        for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 07:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1789138720; x=1789743520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gO79o8tBFz05lhoujECcqggmTdIRnVTc3ftGgS6FHds=;
        b=To4NoGSramyZn2rPg4LhsWi+XDAMsW/zmb90hWzICmYqNHTGHCdRRXEquznrDXxvkw
         3mM4UBNdsIhYU9BNDHfqn6xSs0ACAnofSY8HRb+Nye16hbYv0+VQPa18LLzr4GCVcImz
         2Qek7sMRwY+iC/3TaC+nurWYgBxj7q+rzQ01q1vHi/e4mNy1gZepxSQagUJZ/YpoCv5Y
         mXVEAflYDYo3wYDEdK+MdPXTD3dl89CJYOUVILNXubVNdGaYQany1p4qK5g4OtTWX2Vl
         GtLKbVfgrsdFT58gAkHD88uZsFQLAGAOHsbGUImTpCSiWyhC8JpXERjihzL2q2ZZITIS
         XYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138720; x=1789743520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gO79o8tBFz05lhoujECcqggmTdIRnVTc3ftGgS6FHds=;
        b=JRDMzy1dY/XlHpoXeovKfPjBcj/DYWa/YHTc9RbXlYsgEyTiUcoE9FB+A8dyUyiT1l
         4eekoTUxBD34KtkJ14qWOq7FRlXy4nCLMZRIgQ1DH8/y4B2C7rHHw3oE0j54aTciT6FD
         ZFDmU+XMgecLhTaSBGX+3OYYK98EJLCcIc7UTGwWJic4e4n+nKYzS0zhQ1BS3LrV7Ub4
         REyJJFqpXYFbtfYdwNjTC+VXx8Vb09sivDjYdMTMsvZjcb17H1R+Mvpz91SbUHfGdL0K
         AyrEQFacCEUlX+nxCo3vXx8IjCYCJ/7vbKnh5xW3jTng14pC4rjkOunbvM2g5U6tc1v/
         FVtw==
X-Forwarded-Encrypted: i=1; AKwUvBxiptkvmrnCW5fi8bAscCwc4A2vkVbG3tS7uMfd8ZSFhF9I/07Cr4T/BciQfrph/Ks8ryK/j14JAOnH@vger.kernel.org
X-Gm-Message-State: AFuF++l0VbzoMQsF6nX2bnnSiezQK7pcoa/5vKVTDRdqeSIiscFrk4l2
	0rojPQyRT3DCKucfzmKbhY7EOhPhkOwxyAeCEXSlIxmHbfI6Wx4uYTm42lWEBsND0RvJ
X-Gm-Gg: AYBFou0x8Ak8//8nswwZx5P4P4Z+Yr3AZbuZu6o9u71Qft/iK0R06HWT3oOSXhgQBom
	WwktN8AChz0jadrJS2P85JiNy6vh7MZGBv3qJljVjkt+tSCWODaV48aWhnkFOW0RErO9nq/9D7c
	kaJQJJ9wYWezzgJ4zYTUsZZ9zJQB4nZE1jJpE2kQqdZ9lZoFMPM+LM6IRoiwvFMEGR+nTD0N2U1
	h86koQXwqF3Jl7FQWtO1uqtKkSwUzzT5nMAxFVRBDiH7GtKNp3Kxd1URUCSg1OzXx6uBiDx62Kg
	rxUxUcH05mE2mGu51rKCryYEK2KISPxv8UwaGHeMKhbrj8PqhnYU+laefJWq3/x/5SGDhkuCXUi
	LyKjioPalVVD+qnPpwNGKxwEAIB2uao6h0L51EoVtuyGX/6OLWYiO9CvazgX3dGXufNOALDQOe6
	/WoZFvuEgKLxk11Agk3fAGRO3x0Rqaqb0/qEGfdUfRBd/UjQmyvdgW66trwvyq6PKZdlQX2SfBX
	g4utV9zdK+AgTpoPxiwKcAOfYbhxo7TW3+G7rU=
X-Received: by 2002:a05:600c:3145:b0:49c:eb04:1c49 with SMTP id 5b1f17b1804b1-49e619906e4mr58147405e9.13.1789138720372;
        Fri, 11 Sep 2026 07:58:40 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e61a81943sm50432915e9.1.2026.09.11.07.58.39
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
Subject: [PATCH 2/3] smb: client: reject over-long write counts in cifs_writev_callback()
Date: Fri, 11 Sep 2026 15:57:57 +0100
Message-Id: <20260911145758.3833254-3-diego@bynar.io>
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

cifs_writev_callback() builds the number of bytes written from the
CountHigh and Count fields of the WRITE_RSP. Some servers are known to
set CountHigh incorrectly, so the value is masked with 0xFFFF when it
exceeds the requested length, but that only clears the high 16 bits: a
Count that is on its own larger than the requested length survives the
mask unchanged. written > wdata->subreq.len then still holds, the
"written < wdata->subreq.len" test is false, and the inflated count is
passed on as the result of the subrequest.

netfs_write_subrequest_terminated() rejects that with a WARN(). A
server answering a two-byte write with Count = 0xFFFF gives:

 ------------[ cut here ]------------
 Subreq excess write: R=7[1] 65535 > 2 - 0
 WARNING: fs/netfs/write_collect.c:508 at netfs_write_subrequest_terminated+0x425/0x720, CPU#0: cifsd/79
 CPU: 0 UID: 0 PID: 79 Comm: cifsd Not tainted 7.3.0-rc2-00131-g0a96d0d726cd #45 PREEMPT(lazy)
 RIP: 0010:netfs_write_subrequest_terminated+0x43a/0x720
 Call Trace:
  <TASK>
  cifs_writev_callback+0x4af/0x900
  cifs_demultiplex_thread+0xd35/0x2280
  kthread+0x315/0x410
  ret_from_fork+0x647/0x920
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 ---[ end trace 0000000000000000 ]---

so such a server triggers a kernel warning on every write, and a panic
on a kernel built with panic_on_warn. Before netfs clamps the value,
cifs_write_subrequest_terminated() has already used it to compute
wrend, which feeds netfs_resize_file() and
cifs_update_i_blocks_for_write(), so the size the client believes the
file has also grows past what was actually written. SMB1 is not
negotiated by default; reaching this code requires an explicit
vers=1.0 mount.

The missing upper bound dates from the introduction of
cifs_writev_callback(). It became a WARN, and began inflating the
client's idea of the file size, only once the write result was handed
to netfs.

Reject the response instead. A server reporting more written than it
was asked to write is violating the protocol, and CIFSSMBRead()
already treats the symmetric case on the read side as an error.

Fixes: c28c89fc43e3 ("cifs: add cifs_async_writev")
Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Cc: <stable@vger.kernel.org> # 6.19.x
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
 fs/smb/client/cifssmb.c | 9 +++++++++
 fs/smb/client/trace.h   | 1 +
 2 files changed, 10 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index b1525d491ce5..30b9621664e8 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1954,6 +1954,15 @@ cifs_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		if (written > wdata->subreq.len)
 			written &= 0xFFFF;
 
+		if (written > wdata->subreq.len) {
+			/* check that the server did not write more than requested */
+			cifs_dbg(FYI, "%s: bad count %zu for length %zu\n",
+				 __func__, written, wdata->subreq.len);
+			result = smb_EIO2(smb_eio_trace_write_overlarge,
+					  written, wdata->subreq.len);
+			break;
+		}
+
 		if (written < wdata->subreq.len) {
 			result = -ENOSPC;
 		} else {
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index a0ad8068425e..a1c0cb1a5833 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -149,6 +149,7 @@
 	EM(smb_eio_trace_user_iter,			"user_iter") \
 	EM(smb_eio_trace_write_bad_buf_type,		"write_bad_buf_type") \
 	EM(smb_eio_trace_write_mid_state_unknown,	"write_mid_state_unknown") \
+	EM(smb_eio_trace_write_overlarge,		"write_overlarge") \
 	EM(smb_eio_trace_write_rsp_malformed,		"write_rsp_malformed") \
 	EM(smb_eio_trace_write_rsp_short,		"write_rsp_short") \
 	E_(smb_eio_trace_write_too_far,			"write_too_far")
-- 
2.39.5

