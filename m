Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE62282F25
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 19:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776194139; cv=none; b=ohk2vR0oPsfSsaT5yJ69Qo99uyy8A+00nOa7ie2lAMgwaLx0J0lPTs2lLbskmX1QGkClp1Kh00NwCl2dZzS+3lX4F+jWKZuXVpcg4Ql+CUOOVwBkUb8itd1RieBhHx+hihj70SsNEqimmn+lnn1nTEkk8sY0ZIbJIyBCPuz04EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776194139; c=relaxed/simple;
	bh=OP+X7N1cl7Z1dU4RmWLJlo1ZnQ+9ylvjg9Rirta7jeA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kueT/xM+EaHRL9jja63Bc1vwrcSthq27G15D2Oav0GMaHc/9go680kS5Hvs1jEaXHLfJzNvsanN5o8UY3eDvNfwMOeD0n3dT/VXTI22pyeSGEm+z0XXwSxozD2wn87zE3TpCm7dT3t+pZG3+bvtU/FZD5vm8xaFbRGo4zsBwEac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=scTvEk2p; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="scTvEk2p"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-899a9f445cbso67115936d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 12:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776194136; x=1776798936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PMAOyE6FGPQM6cNvFV9IHH4uR3bD/7YSN/uFIDfWSw0=;
        b=scTvEk2psCGOW5h0gXFD5MCUvasgzC5B73AkuRoMlZnTwKEMFScUUspwNj+jY26HPy
         wuwCSpDSLj44tKQiHYwV5M0slmZ9nSSpyOpm8Wn/x8xR6+A8HTqhHQNFFn9SUKj6woE1
         D+hWO4SOaZnUtpiXZa0JDw77rd6RXDBe6gjBMC0gGpqzn2blKyyKl4AsTghHP8VTIf19
         SoegTVAm6eKjABnhI8pRsttswReRpLB4tizaRw2ib9XKbt7OOaGUO4iFecxpc9iHLfJ1
         3mpS9+x1eIEwaR2GzrhGIiSYN1ju/GOEvKLbaXBKjUOuOwyh7JT7S9dk0F2b86sbAkeu
         yySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776194136; x=1776798936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PMAOyE6FGPQM6cNvFV9IHH4uR3bD/7YSN/uFIDfWSw0=;
        b=deNu4GhTVG6DhkCf8hzalnpFCwMdb6sQOWQtmKKn+r1qYUGZU8y0+YRvofowMqXgqW
         1KugjMG6WU/l7CxBMv2IrnMToIzGO46sxgQkeKk9pAUHd0XvxHE4drrGJ4YYdf9DYNWI
         A5E1+1lfHjM2vNOzJ4lfvL4LLHkhZse3VcsGp8IsLpSVSLHEi53Q7RWhqmbzNddY+DOc
         3zGvU4MRHBNak9KpT/tTVLkztt28WUG/36hCu+/KdWGn1wOs3MzolRkH/hc0i6qN4rkK
         T6SEalUxAw8+V1qLa6kCfar8A/yxuh5foILDm9hhvi47sHtuUzsFNUkVt2CpDBFy8pld
         Ni9g==
X-Gm-Message-State: AOJu0YxTtPcac3JGnTCHB3yeaFX6vIC3n7Ab2ZEzwrqJUU98Q4cBkw76
	JmpPe5BceKqvnFhgmb5GmNdX0mPwCSqaj14/wfzIaYS6GXfPnpVpMxljpdBs3QPu
X-Gm-Gg: AeBDieunIgDN3BG0ZnrRtTrB8nQmiFZEZz5hHKZ5goHtRuEV2Sn39K7/pmZfKItz19b
	SMwOUPRcYw2Ujkpni1oVk+R+uSm7eEZdZ0Hh6DCCFrL4vQzx9WBI9vFux3Gu3Pluo/ky7UF9RmS
	hI4FDFvgKdtD3xzr1qy5JLFBWYcw5WjqCfbspPjh3w/zngcmHZXxb62oKiaaJZ9x7Hc9zyHfswd
	ey6kQ2/xLjnJqnrh4VPeZJy17Fjek6b9y0W1D5x+5W4OTJN0x2OSfYV9EfZqcwDHMds6A6mq5tg
	HqEQHQOG8uodvSAeb7tdkqOyS/YgWI2a+k7bKluqDTDx9ioIE80hHkFdne4iPoVeXk2IwMtl3Ar
	+PTZG9YAvi1y2UJvM6Pq/NijIxHWZs8tMR9C9gzj/5Is6jX5uOX4Ajc5pAnN1D6wnFKaSR3uQ6/
	0x4vybT5A2xLrm7EsZhdejednOzTVFGe8bikFMxkfd+h79lIQLr0te7dlyelSUfRFV9i8Orlija
	pBdgVLTWSNsLSRcvuc8Hmic2GeqKWloe+6toFp37g==
X-Received: by 2002:a05:6214:2024:b0:8a3:7d76:6a6f with SMTP id 6a1803df08f44-8ac8616001dmr308462016d6.5.1776194135984;
        Tue, 14 Apr 2026 12:15:35 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca478a70csm77229126d6.27.2026.04.14.12.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 12:15:35 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: [PATCH 0/3] ksmbd: harden IPC response arithmetic and ACE walk
Date: Tue, 14 Apr 2026 15:15:30 -0400
Message-ID: <20260414191533.1467353-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Three ksmbd patches: two hardening fixes for the kernel <-> mountd
IPC arithmetic, plus one authenticated OOB-read fix in the DACL
ACE walker.  All three reproduced under UML + KASAN on v7.0-rc7.
Patch 3 reproduces end-to-end over loopback SMB2 from a guest
client against UML ksmbd + ksmbd.mountd:

  pre-fix:
    BUG: KASAN: slab-out-of-bounds in compare_sids+0x2b1/0x440
     compare_sids
     smb_check_perm_dacl+0x4fe/0x11a0
     smb2_open+0x4eb2/0xad50
     handle_ksmbd_work+0x3d3/0x1140
    "The buggy address is located 4 bytes to the right of
    allocated 32-byte region" with the allocation trace pointing
    at ndr_decode_v4_ntacl() reading the stored xattr.
  post-fix:
    CREATE returns STATUS_ACCESS_DENIED; no KASAN splat; granted
    bits stay at 0 because the tightened bound rejects ace_size=4
    before compare_sids is called.

Patches 1 and 2 reproduced with in-kernel synthetic triggers that
hand ipc_validate_msg() a response with a wrap-matching size:

  patch 1 (RPC_REQUEST payload_sz):
    pre-fix  returns 0 (u32 wrap bypass)
    post-fix returns -EINVAL (payload_sz > KSMBD_IPC_MAX_PAYLOAD)

  patch 1 + 2 (LOGIN_REQUEST_EXT ngroups=-1):
    pre-fix  returns 0 (signed->size_t wrap matches msg_sz)
    post-fix returns -EINVAL (explicit ngroups<0 gate)

Same threat model as the earlier hardening commits aab98e2dbd64
("ksmbd: fix integer overflows on 32 bit systems") and 6f40e50ceb99
("ksmbd: transport_ipc: validate payload size before reading
handle"): the kernel should not trust arithmetic on attacker-
controlled fields even when those fields come from a cooperating
root daemon or an authenticated client writing an xattr.

Patch 1/3 caps the attacker-controlled fields in ipc_validate_msg()
against the existing KSMBD_IPC_MAX_PAYLOAD / NGROUPS_MAX bounds
before they feed the size-computation arithmetic.  Three cases:

  - KSMBD_EVENT_RPC_REQUEST: sizeof(struct) + resp->payload_sz
    (__u32) can wrap in unsigned int; downstream consumer at
    smb2pdu.c:6742 uses rpc_resp->payload_sz for a memcpy.  Cap
    payload_sz against KSMBD_IPC_MAX_PAYLOAD, matching the
    request-side cap in aab98e2dbd64.
  - KSMBD_EVENT_SHARE_CONFIG_REQUEST: sizeof(struct) +
    resp->payload_sz same class; same cap.
  - KSMBD_EVENT_LOGIN_REQUEST_EXT: resp->ngroups is __s32 signed,
    so the existing > NGROUPS_MAX comparison at user_config.c:59
    misses negative values, and the mul sizeof(gid_t) mixes signed
    and size_t in a surprising way.  Reject ngroups outside the
    signed [0, NGROUPS_MAX] range up front.

Patch 2/3 fixes user_config.c so ksmbd_alloc_user() also rejects
negative ngroups explicitly, independent of ipc_validate_msg.

Patch 3/3 tightens bounds checking in smb_check_perm_dacl()'s two
ACE-walk loops.  Today they only require the 4-byte ACE header to
fit in the remaining DACL buffer; an attacker-declared ace->size
of 4 passes both guards, after which the loop reads access_req
(offset 4) and ace->sid (offset 8+) past the real buffer.
parse_sec_desc() already performs an equivalent check; this patch
brings smb_check_perm_dacl() up to the same bar.

Practical exploitation of patches 1-2 is narrow: the wrap-bypass
requires ksmbd.mountd to send a response crafted around the wrapped
size while preserving consistent field values, and the downstream
kvmalloc almost always fails for u32-wrap sizes.  Patch 3 is
reachable post-auth by any client that can SET an ACL and then
OPEN the affected file.

The patch 3 exploit chain is authenticated but otherwise untrusted:
guest session -> TREE_CONNECT -> CREATE evil.dat -> SET_INFO with a
crafted security descriptor (one ACE with size=4) -> close -> re-open
the file, which triggers smb_check_perm_dacl() in smb2_open().  The
malformed SD is accepted by SET_INFO without validation on the write
side; parsing happens on the next open.

Instrumentation, triggers, client, and both console logs are
available on request.

Michael Bommarito (3):
  ksmbd: cap response sizes in ipc_validate_msg()
  ksmbd: reject negative ngroups in ksmbd_alloc_user()
  ksmbd: require minimum ACE size in smb_check_perm_dacl()

 fs/smb/server/mgmt/user_config.c |  2 +-
 fs/smb/server/smbacl.c           | 17 +++++++++++++----
 fs/smb/server/transport_ipc.c    | 42 +++++++++++++++++++++++++++++-----
 3 files changed, 49 insertions(+), 12 deletions(-)

--
2.53.0
