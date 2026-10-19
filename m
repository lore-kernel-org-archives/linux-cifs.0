Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792437081;
	b=EmxDtsN88VkgJzkwp4BsCfOkv0EqeAoiLky0lzNIvK+MwLy0ilUldAMM5oprvEOi4uum
	 H/fz1ZyRwvSkZ2Rq1aPV1fyOCW7BjzZianc13D01vI2aJ5sC6pY6cBySrFUNHp4XevfXU
	 MOh6fL/rfeAOXQ6wK7ncs05u/SteIJSo9dzm/wNC6BcavVXR8cHu0pNzldlH6gA423mCJ
	 5w91YfXnYmyVW7FxVhI9z3obzrZ/NDzDZPcyBJe6wNRxeU5xX4m0NYibzttvYwy0GrPrs
	 V80cSOlhej3CrAoZugPznEiOTXCeZ2XhkunAl36MCsjdSjs1qPVXieTg24NbUOayrvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792437081;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xu+NpaofIcN+A5gy42F4xAEqWNUCxA2rO9+p7TSllso=;
	b=KVTybKwRIHbp/pHfJVUVvCKFXEo2+WrAACjgnva3kaQfHsbvUcxxbCI/48Su0zx/P8ah
	 9jlw1N9YWJhk1me5geFNUAk8DhYBhq9dsFq6vZMNucj4sb+c+QX8wfGEf8PpsWONxGcMZ
	 oYDjAsCf0TncgYDCjYmqQNaU0fhCYS+dEi7pgp1Br/EG21hYz1A83BxvV0VpBqTiLSBut
	 sUPhES0TJAYVkKhfOBaIqrQgHh1Ewd20s25prkwHA4O/awKAatica6jrH3ACBdDVhcvR+
	 4O30nHn8N0vwVU9URKVxd2HpdaxjOtd6LOKVTgH5WC8sJzOm9g3UezbV9qnNJf+wioA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=R0MFGAlv;
	arc=none smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D330606A319
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 19:11:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D330606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=R0MFGAlv
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b203527bceso2958012a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 12:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792437080; x=1793041880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xu+NpaofIcN+A5gy42F4xAEqWNUCxA2rO9+p7TSllso=;
        b=R0MFGAlvryqL/A5EjTzKCxn6pLcLyqx8O4ghtU4WQYS8HyL87Mp65nitNmm7x/0R2V
         QsFZGb2NsBQU92H4UQm/YaPoalKMdIHw1rsvYJA6N3ybe1U4NGc+moNn4XAhXr65TLZS
         G7WNzJYftIMKOTkfXim0+2GBrjFk69PKAM8UcGXkxggnju8cEBLZ9D3ayGw6pZT5uYKy
         F3fCwLgPEQYSAZ96mGN4JpUZgbg4VjmkbWBsHtHQ0jmwJbrkr4Akiyggwijf5yJ1dT1s
         DZn+9P58qY7rSMTRBCbMzM6ci5/YnXYJJK9LLQbOVtL5P7Bf6KClQ9PK29Q4zCJKpGXm
         vocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792437080; x=1793041880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xu+NpaofIcN+A5gy42F4xAEqWNUCxA2rO9+p7TSllso=;
        b=waRAtzObgPd2q3/jkN8bisdj9HVYn0GCl5FPxLWmDQZVsfhM/b1uN6rnuX11+f67Uv
         er1hwlVyyfhMcs4hhmWAaIhrEHEZOepkyyT42HAhtXTB+z7P+w4Bvxxy0/oqeI/2ajrs
         MEH7/YabA/hs01xZDgQnJ+64rVJMWjT2/p1C0KkbhlzHq1KNJ90P312CLcSYpxor3wIU
         0yFLC+UHSCHKsUyyTw6Ffvq3pjgjE3v7Go+MbcNdGIZIOIfRtJLNzD37K9+MJTfI/brL
         YRKVSZmrqA8X/HLlW7J0DtOH/n8wovGwsIs7Rd07fKJhmc9Lhii9LxWnpHTI8lQFhckj
         y/kg==
X-Forwarded-Encrypted: i=1; AKwUvBzpxpiHxHbd41VVmOT9g5QNBwQYD/WSLpKG++SO0E1q2Wcm7XpyeIbec19YR7jzG3riDkxKBiEs5Wkr@vger.kernel.org
X-Gm-Message-State: AFq9FYLnlo7vGPAdiITx+GJhnDayn3sAiSwrEJHHWkGcoW0Qys3IKr/8
	dETTW75Wgyd79Er0EzV+D5KOkRb8+q9ieDkhtnoB4rxzu9bmNzhxCW1u
X-Gm-Gg: AYBFou3Tw5Gl4ntbOJl187V0E7ddAiIOR+h2Eiqv0IYk64T63PAabWWqhtxXoMzYOBu
	HYJPVlipQjMCTPWPY/3zhAqFHuwbSA0YhLDctSioEnPN8kzVOx58hrhfGxtfD4EcKdpj+0/e5v6
	BNC7rt5g4+Gyv6v162G7dwiC9zOjG4IxWiwJZJzWFv2K5IRDM39cpZAaMDFddMIyV8H9Y5H7I7R
	1RS/5fS+RYUb05qMwtOb42Q+KNc5ozAxqcOT2AXvQONSMPxhWGxbMYeHj3Tx9bVmVEVu1CMMIYO
	vl5jGx94E2olYB54+HJNHzF65RCvFhKXD7Wt3r+2HCgzV6X0WdoLOKsw2fVMY4KSZBDJo6Ehj23
	VZqvblEcWGRABF1nLapk8sBvhoH79a2CDrizsIZb7p0P4nR1URDBohJqTjG0zhTsJLvXWLlEcGD
	ay1aoXlKqdaWHv4CreBsbLZ4mKKnJ3Oq3KigWRFmEOdzIXIM9XJWm9SZIg6Ur6mUdAkgqaqKkAX
	Gir4yljWUQNHL/kZf+SOTyCH/fvsePH3gTNBdtWdP7YtoXGfbD+h/Sr1qFfrOqNhsxlVu/no/Un
	csZsUDqtMw==
X-Received: by 2002:a05:6402:a203:20b0:6af:dccb:acbe with SMTP id 4fb4d7f45d1cf-6b3a8102132mr4036341a12.5.1792437079322;
        Mon, 19 Oct 2026 12:11:19 -0700 (PDT)
Received: from wlan-199066.nbw.tue.nl (wlan-199066.nbw.tue.nl. [131.155.199.66])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b38a1d5262sm4341114a12.22.2026.10.19.12.11.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Oct 2026 12:11:18 -0700 (PDT)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: linkinjeon@kernel.org
Cc: farhad.alemi@berkeley.edu,
	smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Subject: [PATCH] ksmbd: accept share config responses from ksmbd-tools before 3.5.3
Date: Mon, 19 Oct 2026 21:11:16 +0200
Message-ID: <20261019191116.31291-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <CAKYAXd-Z_H2O3W=_KrUifR44yisJJhR=-bQQp1mML7vHgfcdDw@mail.gmail.com>
References: <CAKYAXd-Z_H2O3W=_KrUifR44yisJJhR=-bQQp1mML7vHgfcdDw@mail.gmail.com>
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

ksmbd-tools releases before 3.5.2 do not have the payload_sz field in
struct ksmbd_share_config_response; the field occupies the last word of
their reserved[] area, so the kernel always sees payload_sz == 0 from
them.  ipc_validate_msg() and share_config_request() used to treat
payload_sz == 0 as "legacy userspace" and skip the payload size checks.

That case was removed by
commit f25e93768fcc ("ksmbd: prevent out-of-bounds reads in share config responses").
With payload_sz == 0:

 - the IPC$ (pipe) response fails the final message size comparison:
   these tools always send a one-byte payload, so msg_sz is
   sizeof(*resp) + 1, but the expected size is now computed as
   sizeof(*resp) + 0;
 - every other share fails "payload_sz <= veto_list_sz".

In addition, ksmbd-tools before 3.5.3 copy a global "veto files" setting
into the IPC$ response, so with such a configuration IPC$ also fails the
now unconditional "veto_list_sz > payload_sz" check, even though pipe
shares never use a veto list.

ksmbd_ipc_share_config_request() then returns NULL and every tree
connect fails with STATUS_BAD_NETWORK_NAME, so ksmbd cannot serve any
share when used with these ksmbd-tools releases, for example the 3.5.1
package shipped by Ubuntu 24.04.  Login still works, which makes the
failure look like a configuration problem:

  CIFS: VFS: BAD_NETWORK_NAME: \\127.0.0.1\IPC$
  CIFS: VFS: \\127.0.0.1 failed to connect to IPC (rc=-2)

When payload_sz is zero, derive it from the size of the message actually
received and store it back in the response, so that the checks in
ipc_validate_msg() and the path and veto list parsing in
share_config_request() all use the same bound.  The response is the
kernel's own copy made by handle_response(), and msg_sz has already been
checked to be at least sizeof(*resp), so this cannot underflow.  All
checks added by that commit then apply unchanged, bounded by the bytes
that really arrived, and newer ksmbd-tools that fill in payload_sz are
unaffected.  Also skip the veto list size check for pipe shares:
share_config_request() reads neither the path nor the veto list for
them.

Tested in QEMU with ksmbd-tools 3.5.1 and 3.5.7 and the in-kernel SMB
client over loopback, with and without a global "veto files" setting.

Fixes: f25e93768fcc ("ksmbd: prevent out-of-bounds reads in share config responses")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
Found with AI assistance.

f25e93768fcc was also backported to 5.15.222, 6.1.189, 6.6.158,
6.12.111, 6.18.53 and 7.2.6, so those stable lines are affected too;
this patch applies to all of them (5.15 with the older fs/ksmbd/
paths) and to ksmbd-for-next.

It keeps that commit's OOB fix: the payload size is taken from the bytes
actually received, so a short response like the one in Farhad's report
is still rejected.

Tested in QEMU (KASAN) on 7.3 and on ksmbd-for-next (1db57ad99d46) with
the in-kernel SMB client over loopback, using ksmbd-tools 3.5.1 and
3.5.7, with and without "veto files" in [global]. Unpatched, 3.5.1
fails to connect to every share; patched, all combinations mount, IPC$
connects, reads/writes work and veto files are still enforced.

 fs/smb/server/transport_ipc.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index e550aa41ad..f5cfc32050 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -532,11 +532,25 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 		if (entry->msg_sz < sizeof(struct ksmbd_share_config_response))
 			return -EINVAL;
 
+		/*
+		 * ksmbd-tools releases before 3.5.2 leave payload_sz zero.
+		 * Derive it from the size of the message actually received so
+		 * the checks below bound the payload for those releases too.
+		 */
+		if (!resp->payload_sz)
+			resp->payload_sz = entry->msg_sz -
+				sizeof(struct ksmbd_share_config_response);
+
 		if (strnlen(resp->share_name, sizeof(resp->share_name)) ==
 		    sizeof(resp->share_name))
 			return -EINVAL;
 
-		if (resp->veto_list_sz > resp->payload_sz)
+		/*
+		 * Pipe shares carry no veto list, but ksmbd-tools before 3.5.3
+		 * copy a global "veto files" setting into the IPC$ response.
+		 */
+		if (!(resp->flags & KSMBD_SHARE_FLAG_PIPE) &&
+		    resp->veto_list_sz > resp->payload_sz)
 			return -EINVAL;
 
 		if (resp->flags != KSMBD_SHARE_FLAG_INVALID &&
-- 
2.43.0

