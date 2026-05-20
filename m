Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F822F5A36
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 03:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779247198; cv=none; b=tIqfnI5MEvWYLsfHxRRaTQ9krimK6kUSe+sSUkvgLBMd8/EqBhuFnROk5Ge0gI1lVsDRtsum0OXoZXGlWntXYV/EF+8qtz+Nslx8iZ5vRhbsBUYZzLSoEHPdzZ3NUv7h1jGNUfEftBDCgq8HUBOvNuFXYqJWANH3/9RDbWUtvA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779247198; c=relaxed/simple;
	bh=17nxfRsu/mmBWYVlL9OzSO4HeHZxjgfU0eC2ctFuVPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pPyRSfKixED43vR1CTEY1ZATup9e5mbb7pOUHF2Kwa42qOAQSX/BSB14bmdvhqItG1y/mZsf7NC3Wf8JnfWhUt88XeIQpH8ilbTb6VOzt0HEJBftQGAlplKMgkFhnQUYkTbmQel5Gh5N0HF/HV7MWt+VdJ/i6/6cXeMpyasRdlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DZb14AXJ; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZb14AXJ"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50d75bfb259so27312181cf.1
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 20:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779247195; x=1779851995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ExOjUKx730L5h/Y9Isojqzag32vFvnt6fAHuWyYmv/Q=;
        b=DZb14AXJqszT86bDu9VMgV8k7nfVfjE+J6OGk+Qr2YXZ7udsz0esLIeozpLOPTZy/K
         3+/aNFrrglILIKu3FRO+GDoTPBgd9uTq/dFV9xvgmZG4bKLXm5V8G4IEuW2OyDo/cPfR
         6clJOzDK58LPl8RBYcaHIPFcUU/ch8FZ9vGQr/8Z0Cj8riJ5HQdkxU365sWmhNQGLqzn
         O3NT///o25Pm97FU4mEFca5gbBhaXMg7W9v7ypMMpAxVYguJKdcrwn6OtMnEK2ofyBs2
         hMjs5h5Cr0dmuF5g2OUs+L54VDAqimGr1IPUdavST6sQ5vKzzKgos5Bxo1YUBu10XFBl
         YK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779247195; x=1779851995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ExOjUKx730L5h/Y9Isojqzag32vFvnt6fAHuWyYmv/Q=;
        b=A07WQAjnR+UtJp/LEwu44eTjf4VeXE/Ra1N4uvuInL1DOYMv4lgLl/CrJ7Jo60JnQj
         vwp1neKFQJq5creCXex5MWyS1nz6UrbNBX68G+p7XwRwvDRG4ggajicATPnR1lq6+cl9
         XoX5anexeXrOyWB4Es+ZBPmlKi0l9PLWKcQG2ktwyJOhs/i471pKd1LNR1AAAhXwEI80
         G9fzhVueWdXsBns6308bu7+jF3z0YWEhen8QtbB6nUdnLVlVfI4Vy+hbIiM+zHfAohRj
         77Hmlpt1ndpcpqLbCl599vJz1Y6cppHn++QyS/eaoJ3cv9tZLa3r8xm/sEt2LQm8bF3H
         0+OA==
X-Forwarded-Encrypted: i=1; AFNElJ+s8PtB2H/NC6zpXpaCd5xZhHqpkaDf3ldIXF6ZlVZVTtmphf8i6eRpjgY0aUq+xXJ2xQzU+1yuIjiU@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6gh/PNSiGLWVceZRlPlzluDC7o1RoqGxvmLeFkFwPB6sqJ7s9
	MZJehEWbKFGSWPWgTBfLm7gCl1BQiTq1uxan3kp/kLV98MT2S8dns0+p
X-Gm-Gg: Acq92OGW4uE3huU241JYEsw8gVlK5L4K6+wZv+tmTL0eP2FZq6T1DkvO64mRR+i3lmA
	PwFQBXAiW7iGjjJm4gHkSmkWtg1NAl1fV1qgOKa2Fu0p3ShHBUP2tZARcQoeP5wFDHxa2Sg50fn
	uj+c673Owa1ut7EqxDV+Wicnu5ydteH9e/TRLfKYIwpP/owvTyqgs3+qqTI6L8DxNExHEDCGt8p
	Vt3fH41bYZ31+ztIv6miBXr/j3caxnKo2SR7cqejMgy44/NdXKJRQLnrn3uFka0TB7nkkJ/X/iS
	X9mGvMmeqnCY+T3oR7hjRXy6fftCmZY7/mmA5q7g1DLFYMb2J7yJUUNXMmlgGLKEZdd+7afnGgR
	kpkpYTuAFcoqQIk/8/2IBGP28/4rOAmHuU1EL/cnkR3Y6FgjrSkMCDyBQgdPU4tYCG0B70+z0yw
	dVbD2O5IJeep4TxYQ4pgH7HUR2YRXH2fjUteslI9nb1wQ31WXA0JmwkEaeDNJ/pg9xjtfkCq5U+
	s3g+MBqCWIEqTolgRQw
X-Received: by 2002:a05:622a:8584:b0:50d:a8f5:1bf8 with SMTP id d75a77b69052e-5165a1dc9f7mr251865621cf.37.1779247195399;
        Tue, 19 May 2026 20:19:55 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456c0a42sm189710571cf.10.2026.05.19.20.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 20:19:54 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Marios Makassikis <mmakassikis@freebox.fr>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: reject unsigned non-exempt requests when session requires signing
Date: Tue, 19 May 2026 23:19:23 -0400
Message-ID: <20260520031923.3679744-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This is the ksmbd SMB2 sibling of Samba CVE-2023-3347 ("SMB2
packet signing not enforced"): when the server-side policy requires
SMB2 signing, unsigned non-exempt requests must be rejected instead
of processed. CVE-2016-2114 is the older Samba SMB1 analogue for
mandatory server signing not being enforced.

When a ksmbd target is configured with "server signing = mandatory"
and a client completes a signed SESSION_SETUP, an attacker on the
network path of that connection can read the cleartext SessionId
from the SMB2 header and inject unsigned TREE_CONNECT, CREATE, and
WRITE requests on the victim's TCP flow. ksmbd processes the
unsigned PDUs and commits attacker-supplied content to the share
under the victim session's authority, without the attacker holding
the victim's credentials.

In fs/smb/server/server.c, __process_request() verifies signatures
only when conn->ops->is_sign_req() returns true. The predicate
(smb2_is_sign_req() at fs/smb/server/smb2pdu.c:8936-8947) reads
only the client-set SMB2_FLAGS_SIGNED and never work->sess->sign --
the per-session "signing required" state set during SESSION_SETUP
at smb2pdu.c:1546 and :1645. MS-SMB2 3.3.5.2.4 requires the server
to reject any unsigned non-exempt request when
Session.SigningRequired is TRUE.

Reject directly in __process_request() when work->sess->sign is
set and the inbound non-exempt request lacks SMB2_FLAGS_SIGNED,
bypassing check_sign_req() to avoid emitting
pr_err("bad smb2 signature") at KERN_ERR for each unsigned PDU.
The set of commands exempt from signing (NEGOTIATE, SESSION_SETUP,
OPLOCK_BREAK) is unchanged.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---

Reproduction
============

Tree: linux-mainline 2f448dd9ef4e, x86_64 QEMU+KVM,
CONFIG_SMB_SERVER=y, CONFIG_KASAN=y. Target ksmbd.conf has
"server signing = mandatory", "map to guest = Never",
"valid users = alice"; SMB user alice was added via
ksmbd.adduser.

Conditions: ksmbd configured with "server signing = mandatory"
or a client requesting SMB2_NEGOTIATE_SIGNING_REQUIRED, so
work->sess->sign is set to TRUE after SESSION_SETUP completes.
Encryption MUST NOT be negotiated on the session (smb2_sess_setup
clears sess->sign to FALSE at smb2pdu.c:1558/:1657 when
smb3_encryption_negotiated() is TRUE). The PoCs force SMB 2.1 to
keep the session in the signing-required state.

Harness: a wire-level Python client establishes a normal NTLMv2
SESSION_SETUP on a fresh TCP connection, then on the same
connection issues TREE_CONNECT, CREATE, and WRITE with
SMB2_FLAGS_SIGNED cleared and the Signature field zeroed. A
companion transparent TCP MITM proxy demonstrates the same
primitive without holding credentials: it observes SessionId from
the cleartext SESSION_SETUP response and injects an unsigned
TREE_CONNECT, CREATE, and WRITE into the victim's TCP flow using
that SessionId; the victim's own SMB session continues normally
and observes the attacker's file appear on the share.

Stock kernel: unsigned TREE_CONNECT returns STATUS_SUCCESS with a
tree_id; CREATE returns STATUS_SUCCESS with a file id; WRITE
returns STATUS_SUCCESS and the attacker payload lands on the
share path. The response header carries SMB2_FLAGS_SIGNED with a
non-zero MAC, confirming work->sess->sign was TRUE on this
session.

Patched kernel: same harness, the dispatcher returns
STATUS_ACCESS_DENIED on the first unsigned TREE_CONNECT and
nothing reaches the share. dmesg shows zero
"bad smb2 signature" entries; the rejection bypasses
check_sign_req() so the existing pr_err path is not exercised.
Regression: a legitimate smbclient session with
--client-protection=sign continues to read and write to the
share with no observable change.

Mitigations: until patched, deployments can leave
"server signing = mandatory" disabled in ksmbd.conf (the bypass
is meaningful only when the session sets work->sess->sign), or
configure clients to negotiate SMB3 encryption (sess->enc=TRUE
clears sess->sign and the session uses TRANSFORM_HEADER
encryption for the data path).

Selftests: grep over tools/testing/selftests/ on the patched tree
returns 0 references to ksmbd or smb2_is_sign_req; there is no
in-tree selftest binary that exercises fs/smb/server/server.c's
dispatch gate. The trigger Python client and the TCP MITM proxy
are available off-list on request.
---
 fs/smb/server/server.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 58ef02c423fce..5755f907f29f4 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -143,6 +143,15 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 			conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
 			return SERVER_HANDLER_ABORT;
 		}
+	} else if (work->sess && work->sess->sign &&
+		   command != SMB2_NEGOTIATE_HE &&
+		   command != SMB2_SESSION_SETUP_HE &&
+		   command != SMB2_OPLOCK_BREAK_HE) {
+		/* MS-SMB2 3.3.5.2.4: Session.SigningRequired==TRUE,
+		 * reject unsigned non-exempt request.
+		 */
+		conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
+		return SERVER_HANDLER_ABORT;
 	}
 
 	ret = cmds->proc(work);
-- 
2.53.0
