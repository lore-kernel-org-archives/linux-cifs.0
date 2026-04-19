Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AD12032D
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 11:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776596582; cv=none; b=qD4IvKnJeYxv4WL+jwV/5Wus/lAbURIPcaVaLP3c6RYoIM++KFkQJAB9HLhR9Tf16l4a/INJH697vpxz6ZPG3iB9GDDNg+UuPv9Y15TrBsSbrziveaTuczArNutn1arAkxb4UFPDs3Wczk4heo3xNq8LdW9bdv8NL66ZV4Otpvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776596582; c=relaxed/simple;
	bh=ijj/N4N9O/ac6EUfDf/gAEdbFUx8EN8wOGtiExOehyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UmSNfG7/hAyIz9E8ZG1O4DPkuULCkhJThvyKS+3jB1VsvYSKQeAKqID/GR6EI4iED/M+LGaGOHyxfJO6IG7rkxjW48UEhw6XQ5y707zanUNYjIjve7xP9uPC1AwJkoZvo6cVoz/02FvmAB74IT/S0GqNiT3hAlbXH9mH5aGbRLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Na1LfKDD; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Na1LfKDD"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35e4617924eso345764a91.1
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 04:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776596581; x=1777201381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rBKKtrGOZEceLaJ96OZS5seFZGwhn2z6dS1FO47hYVk=;
        b=Na1LfKDDNHwr5c3qhsjUbKzBEyOPJ+DTeFbQn2ACfg/l7nRoePPfdB4Tpg6hXDfJWi
         P8l6bpAsChk0Ry2SFWsywM0Le/uDQosF4mBfJ0dOwQy5nYwUWNcaSC/SJWBelg5btkgt
         mWu8A1WVQIRkaMarC0YFHY7HkUpSOXUGyVWO+mctoRvn1gq/xNn/pp34UHipMfV0MCIk
         tiyyWyFdWB2dAyy5sHucKOHiHwako7f3gF7t0pc8l+t+SFxSnxCEGP9/5YlA0Ai45xFu
         D7OsEv2lJkdDZDAoQA9+QnhKrpaBkGcEw0q1fSjKBcH9jSAdGCiAn8SP74v2Gvu+FlIH
         v/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776596581; x=1777201381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBKKtrGOZEceLaJ96OZS5seFZGwhn2z6dS1FO47hYVk=;
        b=GcWzOlEtJjruyXGleEqYsQGR1DIYUWAh1G93sALCckc8SQ//wSV+DAzvh3VOhuH0HO
         d7i90pzJQrVp+H5PEvnY8qSOpXABOskNbJGti/ktE5ifuHMJ/+lJpTLpUlp9Og9JxrSA
         QMIJL3y9YRB9MD5pOiy790Bkr5qKsH5jDdkGj/nbPEm67Wnf0rbwF3QTNZwePzdvnrEI
         onUPjDzGXCJqeMZqxkf1Wt/GgYwkguF9ImON6Lx1weLuYEWypswWVmIC77L72VmAztUh
         ngCjwJQFBtCWW1JDcbKeGoez0xjm1KCdytxnbT8gAuY0lSLtHXTK+Lmb9wBNMoSRdrXw
         Z5SA==
X-Forwarded-Encrypted: i=1; AFNElJ9lBB7MR03zUaX3ETHvyAONhCn2qyDww3QiLXE0Wkhr/nGS/agtopuOqnD7cuzi5ScDh49pqdrOUKu/@vger.kernel.org
X-Gm-Message-State: AOJu0YyaKckNF1/1eTnv7SsuX7+XSSADK82CnNv6MoRu4cb6lBKLHCQt
	fmwtDS4OO992wlflqMXLbkc6Q9jP9A9+yqZxdZAHMqHW+go6aYG2p19P
X-Gm-Gg: AeBDiestEjpEkkbtGCPcfptesIm6kLkKIwFDa4tofi48NhAU62sf1qJHhS5gseTVpLW
	7iS7z2jSJIbC/e3zujP+0BV8SnPeR7RfHgUYdIopvu/NfmIlOhJxku+xiVtq+3hlgZ7vHAV3e8D
	ch+SA7vMuv5VdsypNYUrb45Elb7DnWkh/7mHOQsP+jHjFJh9TnGsht8QZ6eEaNb8mCIUZ5NxSFw
	ni1wHO1cN7hWn5iQbqK3dJTtp9McMtn0ReYL97HHp8cj2NzljlrEBYaNEMCI5KVPLyAoXKn0UOb
	AvK/SzXwl5HvN/tlyS16YlqdH6zczrQm8WygX/x4jQg/fW+jBVBipZF1e15PbhtudN/wg8GOysQ
	kUsCdhitvJLGxSv5labSOwJyT9LgdYLUcDEKDRMtPVTwfvLpkT1TuyDj9lVeqg3wlFqhUqvCfOc
	j6scv1ghHcSXEj9fZlPZ2tCD9Z6uzjTIjOQxdX1w==
X-Received: by 2002:a17:90b:2cc6:b0:35a:329:73c7 with SMTP id 98e67ed59e1d1-361403a6824mr5269791a91.2.1776596580557;
        Sun, 19 Apr 2026 04:03:00 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797703059fsm5527972a12.24.2026.04.19.04.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 04:03:00 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 0/2] ksmbd: pair ida_init() with ida_destroy() in cleanup paths
Date: Sun, 19 Apr 2026 20:02:53 +0900
Message-ID: <20260419110255.2477785-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two small IDA cleanup fixes.  Both instances share the same history:
when the per-object IDA was converted from a dynamically allocated
ksmbd_ida (which had ksmbd_ida_free() called at destruction) to an
embedded struct ida initialised with ida_init(), the matching
ida_destroy() was not added to the teardown path.  The enclosing
object is freed with the IDA's backing xarray still intact.

  1/2  ksmbd_session_destroy() frees the session without destroying
       sess->tree_conn_ida.  This patch also moves ida_init() to
       right after the session allocation so that the init/destroy
       pairing holds on the early error paths of __session_create()
       as well.

  2/2  ksmbd_conn_free() frees the connection without destroying
       conn->async_ida.  ksmbd_conn_alloc() has no failure path
       after ida_init(), so no init-site move is required.  The
       destroy is placed inside the final refcount branch (next to
       kfree(conn)) rather than with the unconditional field teardown
       because async_ida is embedded in struct ksmbd_conn and its
       storage must stay valid while other refcount holders
       (oplock / vfs durable handles) still reference the struct.

No leak has been observed in testing; both are pairing fixes to match
IDA lifetime rules, not responses to reproduced regressions.  Cc:
stable is intentionally omitted for the same reason.

Tested on top of current linux-next inside virtme-ng with
CONFIG_PROVE_LOCKING, CONFIG_DEBUG_OBJECTS, CONFIG_DEBUG_KMEMLEAK,
CONFIG_DEBUG_ATOMIC_SLEEP and CONFIG_FAILSLAB enabled.  Exercises:

 * 25x mount / umount via loopback cifs client with 3% failslab
   injection to cover ksmbd_init_file_table() and
   __init_smb2_session() failures on the __session_create() error
   path (which now reaches ksmbd_session_destroy() with an
   already-initialised tree_conn_ida).
 * Concurrent 32 MiB SMB2 reads followed by ksmbd.control
   --shutdown to drive async request teardown.
 * rmmod ksmbd afterwards.

No splats (BUG:, WARNING:, UBSAN, ODEBUG, task hung, inconsistent
lock, suspicious RCU) and no kmemleak unreferenced objects.

DaeMyung Kang (2):
  ksmbd: destroy tree_conn_ida in ksmbd_session_destroy()
  ksmbd: destroy async_ida in ksmbd_conn_free()

 fs/smb/server/connection.c        | 9 +++++++++
 fs/smb/server/mgmt/user_session.c | 5 +++--
 2 files changed, 12 insertions(+), 2 deletions(-)

--
2.43.0

