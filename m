Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795060850;
	b=tELQ7CX3Y2+nrb0Gk7QKJ7t4K1p11o8DTt49Jcae+M0w+riQ/KmHEnK8b/ruR3Ej+9oa
	 GGTnCvgsp+t8HZqsDWiOLZKD9LigCxHJk8Deq/PMMvt2jscqKCMtN1xwXORZkUc5asoSH
	 ubFC03oLRNL8aZKLxbshl6qd609XBwUCrLoJG9w+KXytypqikhaa89z0TvcnrcVjXPYFm
	 HJfUpe4eFQL/x8MC8eiwr6gEGYkOpM2eBeLtNICtVUzDTUqPW9ZeiFdwjbX3u0pfDBp5u
	 NJNGPyb9kcIlvAG63vLNuyPAbIvKi9mtzXfuz7x7mmWNu9ptpIsUYVFpanef0cZb5cw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060850;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=Im5v2fF7YtKUxT7J9p7R9r8ZrcGXgzH8zW16FBqarqA=;
	b=tvum9C+dd/cmO7ML7ga+wTSOkCvpnma6En2lcchSeRwSw2OdVAJ2fAEAszdG9MdNog8y
	 id3LK3s5+aPGrmQqDgpjJ8VAiMz2EVd257Rrhk4BRowZ9fQdUH4Q436esYKaRLvs/dUzq
	 6KFzoyGriS7o/Uc+V3PTnviufAjAn9Ty2AaGScxqVwNsWWAS8BE44CYuZ8luP3rZj7BZK
	 rLXjBEp2iSR2JxYbLeiSGoNrHbdbwNlkzdBi4TNGRr647evqnTsYV4m9bH7VMu7G9M4/n
	 e0oeBni3vShFHebH0VLqP2CJ5igYuqbyopl80LZ/TNVvn4P+XzfR8w8j1cVGnekUnjA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b73oZRFs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B16F606A32F;
	Thu, 19 Nov 2026 04:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b73oZRFs
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795060849;
	b=K3ohRk/Tpg9/qMKUNtdwJo8BVqFj5rdiT4ulqsyHFBMw0pPdn9vdCBhlhhPVb6Enooni
	 14q/qjJjjqEgB8VQEgI9hasAvhoiODaYKu1VNyCkCYsm7pzvC/iNhF4Aq6EyRIZDbABcB
	 YKCBlsMZIkw2A3HIQjyDfHjPOZiU1zA+RnuhCezW0tpIMXk/RYUsm/iZGbK6lZSseu10/
	 kUI5LJkZguPNpPWYc5JVuaPvPxBn3Icj03me1NvwGPBwSOEUgDTTAhXhf+j8hqcMevTP9
	 r/B2FFg3mUF8gz30wPLheyVIrbp6e3qQ7gaG/VBr8slr5QsSwGz/NmOD1PqRTNBGicA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795060849;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=Im5v2fF7YtKUxT7J9p7R9r8ZrcGXgzH8zW16FBqarqA=;
	b=rAzV7ae47ddz5Es4eejr9JmYgLBN2T6BGubQxMInGXOZBMzzHUcfoEji8IB+1+GlJLkQ
	 MPBPT8zXSbrQYFbGfdQAF77oleXdtWHQOXEU5xGFvapRO2LQfaAmRA7rupCiWyHljEcrR
	 w2iZRi0L4142KjyV0rYvaE5dugc3zdutmB1o4LZcSeV7i6HL6lZovVz/mi916KdqhzL+1
	 GvgkF6L1CWDh7g/AoAPvbTgpll5r+HC7QRD4I2M1sUbSXuZDLVH1gU0Rtaar8fYa23kiy
	 GbhgFIw2I+4Ebx9acHH1hQDjL3kW+GngSMnzfz1F7nVV/FLufQB3UTt95VwvdCGnwpw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 408481F000C5;
	Thu, 19 Nov 2026 04:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795060849;
	bh=Im5v2fF7YtKUxT7J9p7R9r8ZrcGXgzH8zW16FBqarqA=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=b73oZRFs+cz1dhW2BT0UvltvZbO8v2GQZXFwwEPCXd60VEjCQw7TKl9dPB6YcVAC/
	 C0TMRTrkb1csxzI9gEi97RnqfP36JZ3Iq7t7RM12rcWNk5e8S3QAzAXUmtpLsTw+gq
	 eJ3gSpSHpQLmvARp1XqdrMiINF7q6rlwbZr7R6d4WE46mxEx6NgVp8TPvHcuqL2Z0b
	 q/k8LpAf5jaGwobbg+DfWajdqwwFwDrlRz7UzyT//dEvBgtxNMSx86asmeeppXouug
	 c6DjMjTS36zzZpWPY8AAxjBGAi7mfeIM+hU8UzI745isbhxv7mOSo92vfEnpOH7Ho6
	 2sQoQO2Xb7Njg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 95A5D4B0BC;
	Thu, 19 Nov 2026 04:00:48 +0000 (UTC)
From: Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
Date: Thu, 19 Nov 2026 04:00:48 +0000
Subject: [PATCH v3] smb: client: don't use read data that failed signature
 verification
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-smb2-readv-v3-1-f3a8a2eddb1c@gmail.com>
X-B4-Tracking: v=1; b=H4sIAG90/moC/yXMSQqAMAxA0atI1hZsBaeriAtrokZwoNEiiHe36
 vIt/r9AyDEJVNEFjjwLr0tAGkfQje0ykGIMBpOYTGtdKpmtUY5a9CopeouabJojQgg2Rz2f36x
 ufsthJ+r29wD3/QBx6SnEbgAAAA==
X-Change-ID: 20261119-smb2-readv-08fbd1eb37dd
To: linkinjeon@kernel.org, pc@manguebit.org
Cc: bharathsm@microsoft.com, samba-technical@lists.samba.org, 
 dhowells@redhat.com, smfrench@gmail.com, ematsumiya@suse.de, 
 sprasad@microsoft.com, linux-kernel@vger.kernel.org, 
 linux-cifs@vger.kernel.org, tom@talpey.com, ronniesahlberg@gmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795060847; l=3688;
 i=shyckless@gmail.com; s=default; h=from:subject:message-id;
 bh=URMORExrH4JCtRZ0Ue777N7D5BGWiuT3dVJfKgv73gg=;
 b=ToRXAkguD7E1PnuVkw51/9lK1qF1PYf3Rk+n99xdleliV9SoLKEY7e5xs8imihPGrzEB+6kj+
 aJi1hipwXl7Bd1HzcHJIpO8syyzqTqyfIx1U4Dnb0C+MVq46NX/0ChE
X-Developer-Key: i=shyckless@gmail.com; a=ed25519;
 pk=pMtccVGiWES3bV+7YBFuBclkvq2n2HBHQ5azaBrK2lY=
X-Endpoint-Received: by B4 Relay for shyckless@gmail.com/default with
 auth_id=1498
X-Original-From: Suyuan Wang <shyckless@gmail.com>
Reply-To: shyckless@gmail.com

From: Suyuan Wang <stevewong@hust.edu.cn>

When smb2_readv_callback() finds a bad signature, it sets the error in
rdata->result but leaves rdata->got_bytes alone. Further down, a short
read that reaches the remote EOF clears the error again:

    size_t trans = rdata->subreq.transferred + rdata->got_bytes;
    if (trans < rdata->subreq.len &&
        rdata->subreq.start + trans >= netfs_read_remote_i_size(inode)) {
            rdata->result = 0;

and got_bytes is then added to subreq.transferred. So the last part of a
file, or all of a small one, is returned even though its signature is
wrong.

Clearing got_bytes is not enough on its own. If the read starts at or
past the cached remote size, for example because the file has grown on
the server since the size was last fetched, the check above still
matches and the error turns into EOF, or into a zero-filled tail when
NETFS_SREQ_CLEAR_TAIL is set.

Clear got_bytes when the signature check fails, as the retry path in the
same function already does, and only treat a short read as hitting the
remote EOF when the read itself succeeded. That is what commit
1da29f2c39b6 ("netfs, cifs: Fix handling of short DIO read") describes:
"clear the error if a short read occurred without error and the read-to
file position is now at the remote inode size".

Found with a static analysis tool and checked by hand.

Fixes: 1da29f2c39b6 ("netfs, cifs: Fix handling of short DIO read")
Cc: stable@vger.kernel.org
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
---
v3:
- Only this patch is resent; 1/2 is in cifs-next.
- Also skip the remote-EOF check when the read has already failed (from
  sashiko's review). Clearing got_bytes alone still let a failed read
  that starts at or past the cached remote size come back as EOF.

Tested in QEMU against cifs-next, signed SMB 3.1.1 to Samba through a
proxy that changes READ data without re-signing it. A cache=none file
is opened (21 bytes), 23 bytes are appended through a second mount, and
the file is read from offset 21:
  v2:  pread returns 0 (EOF), the signature error is lost
  v3:  pread returns -EACCES
Without the proxy both versions read the 23 new bytes, and a read past
the real EOF returns 0.

One side effect: a short read that ends with a retryable error at the
remote EOF is now retried instead of being reported as EOF. I haven't
exercised that path.

v2: https://lore.kernel.org/linux-cifs/20261116-smb2-sign-v2-0-a823a90d0db4@gmail.com/
---
 fs/smb/client/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b26bfb4bd91a..f7cb08f5e34f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4819,6 +4819,8 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 					      rc);
 				rdata->subreq.error = rc;
 				rdata->result = rc;
+				/* the data can't be trusted, don't count it */
+				rdata->got_bytes = 0;
 
 				if (is_replayable_error(rc)) {
 					trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);
@@ -4898,7 +4900,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 			__set_bit(NETFS_SREQ_CLEAR_TAIL, &rdata->subreq.flags);
 	} else {
 		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
-		if (trans < rdata->subreq.len &&
+		if (!rdata->result && trans < rdata->subreq.len &&
 		    rdata->subreq.start + trans >= netfs_read_remote_i_size(inode)) {
 			rdata->result = 0;
 			if (rdata->subreq.start + trans >= i_size_read(inode))




