Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF412414A34
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 10:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786616272; cv=pass; b=uSQA4nDcCXiCeVwmTx/aCqgXsG5XfIS91CesVP15htJaNhQjaG6qTMqM9sO6KyQz1YdUoiwKWdNMN8SlLVo2BaMVbKEuGpp9bfqF2HYWeqP5QsaMfFQKkAuicbR+PSrYI5d/fLJyE0FPW3SMzsU3aIFprdd2HDVYjwqIT1AY4nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786616272; c=relaxed/simple;
	bh=7XSXDn+0Pwh059TeqHNUpVhzBQv4GFFg9bYXVQZDZm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Oa4q5vYEFKcEMH/+YJBRyvYbi9d9yv6jFuoI2Y8kQUnjb5pBijYiNSInwxX08C0GVaP+0/vIc8dezOszMZ1nYLp7p5xX4DhNR9c/kn3pud0nfPY4A8MrugDSlmN7ZjXW0Kxwm9s6REVKE3PTEm8z9OOrcvYrEuERe8RvlXdO3wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rlLw+kFi; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rlLw+kFi"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-9061a795d76so20363896d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 03:17:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786616266; cv=none;
        d=google.com; s=arc-20260327;
        b=BjODID1aMTXaVpL9CCeUJFDa9/fISYarx6CJa+qkb/pITFkvcUip3+8hD0KUi+KQrL
         tpoMibkhBzt5DPm7Eg88xxqgxPeHNNzrHpPSWR5l8a2MUgPlP3H+a5lOPRJQX5DJysbf
         KQawxac+nfLV0w+ePnb92MPXRoL07n3gNrpsCVX+M35JIT+oBpFKG13lP6r9OrYxeXh9
         SJO4LtA3N6ueuFbt9W4tdZWdI0krZhsqV15hk82CPGDIgpdUUWGmdxDmNlJIna9gA4xZ
         Co6gurdNWtoBsg5l0r3zgxY7Cub4bxN8Ce03XInKBcxJ2ANO0oazAX4YQ1gVQmkyvNrf
         Q/sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dDgypi/y2/r1xHJhlLJmJF7xRtVli8FMszyYnt4wzlc=;
        fh=Wk97psktPWQOJkMNe1HBVz9gGqqotOm9Gr+6YC1TiYA=;
        b=Ryx7WcBKSextYcPc81gk/5mfTSkN0QEUIosuYj0EYCRLibhU4RONF4t5cB+aHQNtgS
         Ude6lvRjEfL5VNWBGHjiRQYJOpMUJjrG3KdY+gslCMU3q6Wg0EXH0qPWkUkjbLeArBRX
         ClkRlpjVtIFV3R7BjwvpSoIhizy9zSDQi7GV7H8D8Sx9m11NT210rAj2HEToPoAvQewc
         kJtSqOmDt2PcNRO+aqK76WVGGGeP8RauY0E7Rw0mUWz6+aMw7B6Ae85H+C+Qp6mq25do
         Pj/8MBaBP5UUXdwwgpNB1fpk5Ifjfr/UuezAbaiLyqN50PbeW6+VChK/JaypfkQTLjaC
         hDmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786616266; x=1787221066; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dDgypi/y2/r1xHJhlLJmJF7xRtVli8FMszyYnt4wzlc=;
        b=rlLw+kFipYPvJHgRJ9H4wlmdwOqJetg9W3alc8WcoEVhQVOWK9g94px7S7anXh2MZX
         ivUczBFJeBPA296WzkL/m0JWBxE/ds1pzQBscKQ+ZMMrwOh67oKH8iKIyNqV5+5sY8EB
         B9y3LnnzIU6hmnFXLC10TpVkGEfoVkyzu4od/3UMFw+x8/atrnrM3DYjS65Q0kZdc5jm
         rDft1fYm4xY+1Pg8uHVxJRogVnYSSvViQlDhriZwSQCWd+xPRvIRx2F6q5Gg9wKzF4OD
         1jCnVW4R+nUjs4pSHLronYDy9Vf7hK6H/cY+ppx4itqJgVVDo+fUTRjF0+PW4DukYLZm
         DrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786616266; x=1787221066;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dDgypi/y2/r1xHJhlLJmJF7xRtVli8FMszyYnt4wzlc=;
        b=WDVQtAHFGawqSm1a08Bl9tOhTDgRxQf7vm2IR18tI+JLotCV+dRBMhid9hm6ublKap
         BTmgY9bNy75uyi4frx93nS/b2XziKN+5nxgp8KzzESzu8FVJiyizQPE3NC4qj7B3p+B8
         L08Rg6EWa41shRRdfTQgbo9gi6PGpSZhcs/LX1/sBMgJPpl93fmTKaxbAhvu/Gw4YtRZ
         MP4kN+dgqFCtAjLI5inNtHDwPevgoG9RpleW4Bla3M5887sqVT3RoZSBzww2s1GVSFxt
         UnnuwTcNaVDmMkwpoSW0217GsvNK617K+AaIuzB8vhPmzr1ZdjxPE0GaWjk2WyIBsL/6
         dvDw==
X-Forwarded-Encrypted: i=1; AHgh+Rq0f0x5US2mzwr4iygHC+dck8WgNDx555GNLU5xyYmhyQByA4dCu1O7/bc1WqErLXmrpiociGRTC5fP@vger.kernel.org
X-Gm-Message-State: AOJu0YytJQoMTT443OMAydNvA+PlC4TQyjLXAOrAoJhp0+xbHQYD7qpR
	9XCQRniuoI3qgiPgcWfB8Odq4rARrkmWWiAX26dSTVNjHTdFPYnvg1IHh4D+e4nTZqRKMiEDDb4
	hk/hjeQ2Uj6TkNt77Ols61YaJREJmSgg=
X-Gm-Gg: AR+sD10URHcldqVzn5ZzrZ2f1Pmw8DJxQ9vkSnqc46Vthd/FcJ1FniU9VCpyQ+KGr4z
	dPfvA6BQ+dKyQBtXkKVBGZtn9w0hLe9Ot/BYe/PKbV82kzLLaaOufkWx4ANhJq+Nx2xf7wpRLrQ
	TMr3e5dyliWppAaaNV3ukeuul1KgF0uUZ8LZm6E/f836AP7iwzFhDJBJ0JRpSOPogxN4IpuoD1d
	OJ22dVELmqalI8fVRlqm9RCHnhmZT3rDThyHwWph013NzJkdx79vzAGLw2EI6EXVyaSqO3c6fVK
	JJZsRHAZUqCCVmNQX6/inRfcEI03hbEpDmiC0ec6sFpXGQgouq2BkA3TqTg9vMQsxc0ryve+2D9
	ScvbNEMwYkCXvzT4+WnoMPfHHwzGNzvEiBQWS+iY=
X-Received: by 2002:ad4:5ca1:0:b0:8f0:a849:f392 with SMTP id
 6a1803df08f44-90a809becccmr39005066d6.14.1786616266075; Thu, 13 Aug 2026
 03:17:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com> <CALT=-86Z47htBZ6QjUZquDSMoeMYE1dswXVDSfAntg22p0ox2A@mail.gmail.com>
 <9ad355b5-5ae9-4dc3-98d9-cf46795d877b@chenxiaosong.com>
In-Reply-To: <9ad355b5-5ae9-4dc3-98d9-cf46795d877b@chenxiaosong.com>
From: Blue bird <obnred@gmail.com>
Date: Thu, 13 Aug 2026 19:17:35 +0900
X-Gm-Features: AUfX_mzoDnc3Qw3Hk8HVAi3KdaGG_7ykWIvoKY7Wwcf5Y39UibR2-PFSGvF3A8E
Message-ID: <CALT=-87Ziq01X+GLYXpOMThBMC6gcFLV3uaP1qy+k_vM6G+-AQ@mail.gmail.com>
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Could you confirm whether you can reproduce it on `ksmbd-for-next-next`
> branch?
> https://github.com/smfrench/smb3-kernel/commits/ksmbd-for-next-next

Yes for the BUG_ON, no for the use-after-free. Details below, and I am inli=
ning
kfuzz2.py at the end since it never made it to the list.


1. fs/locks.c:312 still reproduces on ksmbd-for-next-next
---------------------------------------------------------

I built fs/smb/ from smb3/ksmbd-for-next-next against the same 7.2.0-rc7 th=
e
branch is based on, verified the branch module was the one loaded, and ran
lockfuzz2.py from a freshly booted guest:

  t=3D5s locks_sent=3D208 faults=3D1

  kernel BUG at fs/locks.c:312!
  Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
  CPU: 0 UID: 0 PID: 6955 Comm: ksmbd:::ffff:12 Tainted: G           O
  Tainted: [O]=3DOOT_MODULE
  pc : locks_release_private+0x214/0x2c8
  Call trace:
   locks_release_private+0x214/0x2c8 (P)
   locks_free_lock+0x20/0x40
   __ksmbd_close_fd+0x4d8/0xd28          [ksmbd]
   __close_file_table_ids+0x3bc/0x704    [ksmbd]
   ksmbd_destroy_file_table+0x5c/0xf4    [ksmbd]
   ksmbd_session_destroy+0xbc/0x38c      [ksmbd]
   ksmbd_sessions_deregister+0x450/0x540 [ksmbd]
   ksmbd_server_terminate_conn+0x20/0x40 [ksmbd]
   ksmbd_conn_handler_loop+0x66c/0xf9c   [ksmbd]

The taint word is OOT_MODULE only, so this is the first fault on an otherwi=
se
clean kernel. Same connection-teardown path as in my first mail:
__ksmbd_close_fd() destroying a file_lock that the VFS still has blocked
requests chained onto.


2. The use-after-free is already fixed there -- please disregard it
-------------------------------------------------------------------

The KASAN use-after-free I reported is a duplicate of

  c120970353 ksmbd: defer publishing granted locks to prevent
UAF/double-free race

which describes exactly the mechanism I eventually diagnosed: a granted loc=
k
published to conn->lock_list while still tracked on the stack-local
rollback_list, freed by a concurrent UNLOCK on the same connection, then us=
ed by
the granting thread.

I confirmed it on the branch rather than assuming. Running the mixed load t=
hat
produces it on mainline (roughly 285 s there) for 500 s on the branch:

  smb2_lock use-after-free:  0
  fs/locks.c:312 BUG_ON:     1   (at t=3D688 s, first fault)
  KASAN in rwsem_down_write_slowpath: 1  (at t=3D839 s, 150 s *after* the B=
UG_ON,
                                          on an already D-tainted kernel, s=
o
                                          fallout rather than the original =
bug)

So that half of my report is withdrawn. I should have checked the -next bra=
nches
before sending, and I am sorry for the noise.


3. Correction to the patch I proposed
--------------------------------------

I also need to withdraw the "A/B tested" claim I made for the vfs_cache.c h=
unk.
On mainline it does close the __ksmbd_close_fd() path, but the BUG_ON then
simply reappears via smb2_lock+0x23ac (smb2pdu.c:8213), the cross-request u=
nlock
path. The patched run that looked clean for 150 s had just not reached the
second site; that was not a clean result and I should not have presented it=
 as
one.

On this branch that second site is the one c120970353 reworks, so the hunk =
may
well be sufficient here -- but I have not tested that combination yet and d=
id
not want to claim it twice. I can test it and report back if that is useful=
.


4. Two things needed to make the reproducer run on this branch
---------------------------------------------------------------

Neither is a bug, but both make the harness silently do nothing, which look=
s
identical to "the bug is fixed". They cost me two wasted runs:

a) max ip connections. The harness churns connections from a single address=
 and
   immediately hits

     ksmbd: Maximum IP connections exceeded (32/32)

   after which no further sessions can be established. Adding

     [global]
             max ip connections =3D 0

   to ksmbd.conf avoids it. There is a global cap too, which logs
   "Limit the maximum number of connections(257)" under heavier load.

b) smb2_check_sequence_number(), added by 9d597c4a23 ("ksmbd: recognize rep=
layed
   SMB2 lock sequences"). My harness authenticates with impacket and then e=
mits
   raw SMB2 PDUs, and it used to start MessageId at an arbitrary value. Tha=
t is
   now outside the connection's sequence window, so every such request is
   rejected with STATUS_INVALID_PARAMETER -- including the CREATE, so no fi=
le is
   ever opened and no lock is ever sent. Fixed on my side by continuing
   impacket's sequence:

     self.tid =3D self.c.connectTree(SHARE)
     self.mid =3D int(s3._Connection['SequenceWindow'])

   The version of kfuzz2.py below already has this.


kfuzz2.py
---------

Not a package, sorry -- a local helper module. It only needs impacket
(pip install impacket); put it next to lockfuzz2.py.

#!/usr/bin/env python3
"""
ksmbd post-authentication protocol fuzzer, v2.

Design lesson carried over from the SATOOL campaign: keep the envelope vali=
d so
we stay inside the deep parser instead of bouncing off the front-door valid=
ator.
ksmbd_smb2_check_message() recomputes an expected PDU length from each comm=
and's
data-area offset/length fields and drops the connection on mismatch, so v1 =
spent
nearly every iteration re-authenticating.  v2 keeps clc_len =3D=3D len by
construction and concentrates mutation on the *inner*, per-handler structur=
es:
create-context chains, FSCTL payload bodies, info-class buffers, lock array=
s.
The outer envelope is deliberately corrupted only occasionally.
"""
import os, sys, time, struct, random, socket, subprocess

from impacket.smbconnection import SMBConnection
from impacket.smb3structs import SMB2_DIALECT_311

HOST  =3D os.environ.get("KFUZZ_HOST", "127.0.0.1")
USER  =3D os.environ.get("KFUZZ_USER", "fuzzuser")
PASS  =3D os.environ.get("KFUZZ_PASS", "fuzzpass")
SHARE =3D os.environ.get("KFUZZ_SHARE", "fuzz")
SEED  =3D os.environ.get("KFUZZ_SEED", "")
OUTDIR =3D os.path.expanduser("~/ksmbd_crashes")

CREATE, CLOSE, FLUSH, READ, WRITE, LOCK, IOCTL =3D 5, 6, 7, 8, 9, 10, 11
ECHO, QUERY_DIRECTORY, CHANGE_NOTIFY, QUERY_INFO, SET_INFO, OPLOCK_BREAK =
=3D \
    13, 14, 15, 16, 17, 18

HDR =3D 64
# offsetof(struct smb2_*_req, Buffer) -- these ksmbd structs embed the head=
er
OFF_CREATE_BUF =3D HDR + 56
OFF_IOCTL_BUF  =3D HDR + 56
OFF_QINFO_BUF  =3D HDR + 40
OFF_SINFO_BUF  =3D HDR + 32
OFF_QDIR_BUF   =3D HDR + 32
OFF_WRITE_BUF  =3D HDR + 48
OFF_LOCK_ARR   =3D HDR + 24

FSCTL_SRV_COPYCHUNK        =3D 0x001440F2
FSCTL_SRV_COPYCHUNK_WRITE  =3D 0x001480F2
FSCTL_VALIDATE_NEG_INFO    =3D 0x00140204
FSCTL_SET_ZERO_DATA        =3D 0x000980C8
FSCTL_QUERY_ALLOCATED_RANGES =3D 0x000940CF
FSCTL_SET_SPARSE           =3D 0x000900C4
FSCTL_PIPE_TRANSCEIVE      =3D 0x0011C017
FSCTL_DFS_GET_REFERRALS    =3D 0x00060194
FSCTL_SET_COMPRESSION      =3D 0x0009C040
FSCTL_GET_COMPRESSION      =3D 0x0009003C
FSCTL_REQUEST_RESUME_KEY   =3D 0x00140078
FSCTL_QUERY_NETWORK_IFACE  =3D 0x001401FC
FSCTL_DUPLICATE_EXTENTS    =3D 0x00098344

ALL_FSCTLS =3D [FSCTL_SRV_COPYCHUNK, FSCTL_SRV_COPYCHUNK_WRITE,
              FSCTL_VALIDATE_NEG_INFO, FSCTL_SET_ZERO_DATA,
              FSCTL_QUERY_ALLOCATED_RANGES, FSCTL_SET_SPARSE,
              FSCTL_PIPE_TRANSCEIVE, FSCTL_DFS_GET_REFERRALS,
              FSCTL_SET_COMPRESSION, FSCTL_GET_COMPRESSION,
              FSCTL_REQUEST_RESUME_KEY, FSCTL_QUERY_NETWORK_IFACE,
              FSCTL_DUPLICATE_EXTENTS]

CTX_NAMES =3D [b"DHnQ", b"DHnC", b"DH2Q", b"DH2C", b"AlSi", b"MxAc", b"TWrp=
",
             b"QFid", b"RqLs", b"ExtA", b"SecD", b"RRQ ", b"NFSS", b"PSFX",
             b"AAPL", b"DrLs"]

I32 =3D [0, 1, 2, 3, 4, 7, 8, 15, 16, 31, 32, 63, 64, 127, 128, 255, 256, 5=
12,
       1023, 1024, 4095, 4096, 8192, 0xfffe, 0xffff, 0x10000, 0x7fffffff,
       0x80000000, 0xfffffffe, 0xffffffff]
I16 =3D [0, 1, 2, 3, 4, 7, 8, 15, 16, 31, 32, 63, 64, 127, 128, 255, 256, 5=
12,
       1024, 4095, 4096, 0x7fff, 0x8000, 0xfffe, 0xffff]

BAD =3D ("KASAN:", "BUG:", "general protection", "Unable to handle", "Oops"=
,
       "kernel NULL pointer", "slab-out-of-bounds", "use-after-free",
       "WARNING: CPU", "refcount_t", "UBSAN")


def log(m):
    sys.stdout.write("[%s] %s\n" % (time.strftime("%H:%M:%S"), m))
    sys.stdout.flush()


class Sess:
    def __init__(self):
        self.c =3D SMBConnection('KSMBDFUZZ', HOST, sess_port=3D445,
                               preferredDialect=3DSMB2_DIALECT_311)
        self.c.login(USER, PASS)
        s3 =3D self.c._SMBConnection
        self.sid =3D s3._Session['SessionID']
        nb =3D s3._NetBIOSSession
        self.sock =3D nb._sock if hasattr(nb, '_sock') else nb.get_socket()
        self.tid =3D self.c.connectTree(SHARE)
        # Continue impacket's MessageId sequence. ksmbd-for-next-next added
        # smb2_check_sequence_number() (commit 9d597c4a23), which rejects
        # MessageIds outside the connection's sequence window as replays, s=
o a
        # raw-PDU harness must not invent its own starting MID.
        try:
            self.mid =3D int(s3._Connection['SequenceWindow'])
        except Exception:
            self.mid =3D 4096

    def hdr(self, cmd, next_cmd=3D0, flags=3D0):
        self.mid +=3D 1
        return struct.pack('<4sHHIHHIIQIIQ16s', b'\xfeSMB', 64, 1, 0, cmd, =
64,
                           flags, next_cmd, self.mid, 0, self.tid, self.sid=
,
                           b'\x00' * 16)

    def xfer(self, pdu, timeout=3D3.0):
        self.sock.sendall(struct.pack('>I', len(pdu)) + pdu)
        self.sock.settimeout(timeout)
        h =3D self._rd(4)
        if h is None:
            return None
        n =3D struct.unpack('>I', h)[0]
        if n > 8 << 20:
            return None
        return self._rd(n)

    def _rd(self, n):
        b =3D b''
        while len(b) < n:
            try:
                c =3D self.sock.recv(n - len(b))
            except (socket.timeout, OSError):
                return None
            if not c:
                return None
            b +=3D c
        return b

    def close(self):
        try:
            self.c.close()
        except Exception:
            pass


class Fz:
    def __init__(self, rng):
        self.r =3D rng

    def v32(self):
        return self.r.choice(I32) if self.r.random() < .85 else
self.r.getrandbits(32)

    def v16(self):
        return self.r.choice(I16) if self.r.random() < .85 else
self.r.getrandbits(16)

    def blob(self, lo, hi):
        n =3D self.r.randint(lo, hi)
        if self.r.random() < .35:
            return bytes([self.r.choice([0, 0xff, 0x41, 0x5c, 0x2e])]) * n
        return bytes(self.r.getrandbits(8) for _ in range(n))

    # ---- create-context chain: the richest post-auth parser in ksmbd ----
    def ctx_chain(self):
        r, out, spans =3D self.r, b'', []
        for _ in range(r.randint(1, 5)):
            tag =3D r.choice(CTX_NAMES)
            data =3D self.blob(0, 160)
            nlen =3D len(tag)
            noff =3D 16
            doff =3D (16 + nlen + 7) & ~7
            pad =3D doff - (16 + nlen)
            body =3D tag + b'\x00' * pad + data
            dlen =3D len(data)
            # mutate the context's own self-describing fields
            if r.random() < .5: noff =3D self.v16()
            if r.random() < .5: nlen =3D self.v16()
            if r.random() < .5: doff =3D self.v16()
            if r.random() < .5: dlen =3D self.v32()
            spans.append(len(out))
            out +=3D struct.pack('<IHHHHI', 0, noff, nlen, 0, doff, dlen) +=
 body
            if len(out) % 8:
                out +=3D b'\x00' * (8 - len(out) % 8)
        buf =3D bytearray(out)
        for i, s in enumerate(spans):
            e =3D spans[i + 1] if i + 1 < len(spans) else len(out)
            nxt =3D (e - s) if i + 1 < len(spans) else 0
            if r.random() < .30:
                nxt =3D self.v32()
            struct.pack_into('<I', buf, s, nxt)
        return bytes(buf)

    # ---- FSCTL payloads, structured where the handler parses them ----
    def fsctl_payload(self, code, fid):
        r =3D self.r
        if code in (FSCTL_SRV_COPYCHUNK, FSCTL_SRV_COPYCHUNK_WRITE):
            n_real =3D r.randint(0, 6)
            declared =3D n_real if r.random() < .4 else r.choice(
                [0, 1, 255, 256, 0xffff, 0xffffffff, n_real + 1])
            chunks =3D b''
            for _ in range(n_real):
                chunks +=3D struct.pack('<QQII', self.v32(), self.v32(),
                                      self.v32(), 0)
            return struct.pack('<24sII', fid[:24].ljust(24, b'\x00'),
                               declared, 0) + chunks
        if code =3D=3D FSCTL_VALIDATE_NEG_INFO:
            dcount =3D r.choice([0, 1, 2, 255, 0xffff]) & 0xffff
            dial =3D b''.join(struct.pack('<H', r.choice(
                [0x0202, 0x0210, 0x0300, 0x0302, 0x0311, 0xffff]))
                for _ in range(r.randint(0, 4)))
            return struct.pack('<I16sHH', self.v32(), self.blob(16, 16),
                               r.choice([0, 1, 2]), dcount) + dial
        if code =3D=3D FSCTL_SET_ZERO_DATA:
            return struct.pack('<qq', r.choice([0, -1, 1 << 62, -(1 << 62)]=
),
                               r.choice([0, -1, 1 << 62, -(1 << 62)]))
        if code =3D=3D FSCTL_QUERY_ALLOCATED_RANGES:
            return struct.pack('<qq', r.choice([0, -1, 1 << 62]),
                               r.choice([0, -1, 1 << 62]))
        if code =3D=3D FSCTL_SET_SPARSE:
            return bytes([r.choice([0, 1, 0xff])])
        if code =3D=3D FSCTL_DUPLICATE_EXTENTS:
            return struct.pack('<16sqqq', fid[:16], self.v32(), self.v32(),
                               r.choice([0, -1, 1 << 62]))
        if code =3D=3D FSCTL_SET_COMPRESSION:
            return struct.pack('<H', r.choice([0, 1, 2, 0xffff]))
        return self.blob(0, 300)


def dmesg():
    try:
        return subprocess.run(['dmesg'], capture_output=3DTrue, text=3DTrue=
,
                              timeout=3D15).stdout
    except Exception:
        return ""


def main():
    os.makedirs(OUTDIR, exist_ok=3DTrue)
    rng =3D random.Random(int(SEED) if SEED else None)
    f =3D Fz(rng)
    log("kfuzz2 start seed=3D%s" % (SEED or "random"))
    base =3D len(dmesg())
    s =3D None
    fid =3D b'\x00' * 16
    it =3D 0
    drops =3D 0
    while True:
        it +=3D 1
        try:
            if s is None:
                s =3D Sess()
                # open a real file to get a usable FID
                name =3D b'w.txt'.decode().encode('utf-16le')
                body =3D struct.pack('<HBBIQQIIIIIHHII', 57, 0, 0, 2, 0, 0,
                                   0x0012019F, 0x80, 3, 3, 0x40,
                                   OFF_CREATE_BUF, len(name), 0, 0)
                r =3D s.xfer(s.hdr(CREATE) + body + name)
                if r and len(r) >=3D 144 and struct.unpack('<I', r[8:12])[0=
] =3D=3D 0:
                    fid =3D r[128:144]
                drops +=3D 1

            k =3D rng.random()
            if k < .30:
                ctx =3D f.ctx_chain()
                name =3D ("f%d.txt" % rng.randrange(48)).encode('utf-16le')
                noff, nlen =3D OFF_CREATE_BUF, len(name)
                pad =3D (-(noff + nlen)) % 8
                coff =3D noff + nlen + pad
                clen =3D len(ctx)
                if rng.random() < .12:      # occasionally break the envelo=
pe
                    coff =3D f.v32()
                body =3D struct.pack('<HBBIQQIIIIIHHII', 57, 0,
                                   rng.choice([0, 1, 2, 9]), 2, 0, 0,
                                   0x0012019F, 0x80, 3,
                                   rng.choice([1, 2, 3, 4, 5]),
                                   rng.choice([0x40, 0x20, 0x1000]),
                                   noff, nlen, coff, clen)
                pdu =3D s.hdr(CREATE) + body + name + b'\x00' * pad + ctx
            elif k < .55:
                code =3D rng.choice(ALL_FSCTLS)
                data =3D f.fsctl_payload(code, fid)
                ioff, icnt =3D OFF_IOCTL_BUF, len(data)
                if rng.random() < .12:
                    icnt =3D f.v32()
                body =3D struct.pack('<HHI16sIIIIIIII', 57, 0, code, fid,
                                   ioff, icnt, f.v32() if rng.random()
< .3 else 0,
                                   0, 0, rng.choice([0, 1024, 4096, 65536])=
,
                                   1, 0)
                pdu =3D s.hdr(IOCTL) + body + data
            elif k < .67:
                data =3D f.blob(0, 250)
                body =3D struct.pack('<HBBIHHIII16s', 41,
                                   rng.choice([1, 2, 3, 4]),
                                   rng.randrange(1, 64),
                                   rng.choice([0, 64, 4096, 65536]),
                                   OFF_QINFO_BUF, 0, len(data),
                                   f.v32() if rng.random() < .4 else 0,
                                   rng.choice([0, 1, 2, 3]), fid)
                pdu =3D s.hdr(QUERY_INFO) + body + data
            elif k < .79:
                data =3D f.blob(0, 350)
                body =3D struct.pack('<HBBIHHI16s', 33,
                                   rng.choice([1, 2, 3, 4]),
                                   rng.randrange(1, 64), len(data),
                                   OFF_SINFO_BUF, 0,
                                   f.v32() if rng.random() < .4 else 0, fid=
)
                pdu =3D s.hdr(SET_INFO) + body + data
            elif k < .87:
                pat =3D rng.choice(['*', '*.*', 'a*',
'f?.txt']).encode('utf-16le')
                body =3D struct.pack('<HBBI16sHHI', 33, rng.randrange(1, 64=
),
                                   rng.choice([0, 1, 2, 0x10]),
                                   f.v32() if rng.random() < .3 else 0, fid=
,
                                   OFF_QDIR_BUF, len(pat),
                                   rng.choice([0, 64, 4096, 65536]))
                pdu =3D s.hdr(QUERY_DIRECTORY) + body + pat
            elif k < .93:
                n =3D rng.randint(0, 6)
                locks =3D b''
                for _ in range(n):
                    locks +=3D struct.pack('<QQII', f.v32(), f.v32(),
                                         rng.choice([1, 2, 4, 8, 0x10,
0xffffffff]), 0)
                cnt =3D n if rng.random() < .6 else rng.choice([0, 1,
255, 0xffff])
                body =3D struct.pack('<HHI16s', 48, cnt, 0, fid)
                pdu =3D s.hdr(LOCK) + body + (locks or b'\x00' * 24)
            else:
                data =3D f.blob(0, 400)
                body =3D struct.pack('<HHIQ16sIIHHI', 49, OFF_WRITE_BUF,
                                   len(data), f.v32() if rng.random()
< .3 else 0,
                                   fid, rng.choice([0, 1, 2]), 0, 0, 0,
                                   rng.choice([0, 1]))
                pdu =3D s.hdr(WRITE) + body + data

            if s.xfer(pdu) is None:
                s.close(); s =3D None
        except Exception:
            if s:
                s.close()
            s =3D None

        if it % 500 =3D=3D 0:
            d =3D dmesg()
            if len(d) !=3D base:
                base =3D len(d)
                hits =3D [l for l in d.split("\n") if any(x in l for x in B=
AD)]
                if hits:
                    p =3D os.path.join(OUTDIR, "splat-%s-%d.txt" %
                                     (time.strftime("%Y%m%d-%H%M%S"), it))
                    open(p, "w").write(d)
                    log("!!! SPLAT iter=3D%d -> %s" % (it, p))
                    for h in hits[-6:]:
                        log("    " + h)
            log("iter=3D%d reconnects=3D%d" % (it, drops))


if __name__ =3D=3D '__main__':
    main()


2026=EB=85=84 8=EC=9B=94 13=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 5:56, C=
henXiaoSong <chenxiaosong@chenxiaosong.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> Could you confirm whether you can reproduce it on `ksmbd-for-next-next`
> branch?
> https://github.com/smfrench/smb3-kernel/commits/ksmbd-for-next-next
>
> On 8/13/26 16:23, Blue bird wrote:
> > Thanks for confirming it on mainline.
> >
> > One thing about the for-next-next run: the output shows locks_sent=3D0,
> > which means the harness never managed to send a single lock request, so
> > that run did not exercise the path at all. It is not evidence that the
> > branch is unaffected. The harness silently retries on connection errors=
,
> > which makes a failed setup look like a clean run -- sorry about that.
> >
> > kfuzz2.py defaults to:
> >
> >      KFUZZ_HOST=3D127.0.0.1  KFUZZ_USER=3Dfuzzuser
> >      KFUZZ_PASS=3Dfuzzpass   KFUZZ_SHARE=3Dfuzz
> >
> > so it needs a share named "fuzz" and that user to exist. Please set tho=
se
> > to match your setup and check that locks_sent climbs before drawing a
> > conclusion.
> >
> > On the UAF you hit: I think it may be the same one I have now root-caus=
ed.
> > Captured on a clean untainted mainline boot with continuous logging
> > (ksmbd's own log spam overflows the ring buffer and hides the earlier
> > faults, which is why I missed the ordering at first):
> >
> >    [284.826] BUG: KASAN: slab-use-after-free in smb2_lock+0x33b4
> >              Write of size 8 by task 1984
> >              Allocated by task 1984: smb2_lock+0xa90
> >              Freed by task 2119:     smb2_lock+0x23b4
> >    [285.088] same task -> _raw_spin_lock on garbage -> Oops
> >    [287.598] kernel BUG at fs/locks.c:312
> >
> > Symbolized:
> >    alloc +0xa90  ->smb2pdu.c:8156  smb2_lock_init()
> >    free  +0x23b4 ->smb2pdu.c:8213  the cross-request unlock kfree(cmp_l=
ock)
> >    write +0x33b4 ->smb2pdu.c:8323  list_del(&smb_lock->llist),
> >                     inlinedlist.h:260 =3D=3D next->prev =3D prev
> >
> > struct ksmbd_lock is on three lists: clist (conn->lock_list), flist
> > (fp->lock_list) and llist (the*on-stack* lock_list / rollback_list of t=
he
> > request that created it). The cross-request unlock path removes flist a=
nd
> > clist but not llist, so one worker frees an object that another worker
> > still has threaded onto its stack-resident list; that worker then wakes
> > from ksmbd_vfs_posix_lock_wait() and list_del() writes through the free=
d
> > neighbour.
> >
> > Note this UAF is the*first* fault, on an untainted kernel -- it precede=
s
> > the BUG_ON rather than being fallout from it, and it is a write, not a =
read.
> >
> > Also, please do not treat my earlier vfs_cache.c hunk as a fix. With it
> > applied the BUG_ON still reproduces in ~5 s; the trace just moves from
> > __ksmbd_close_fd() to smb2_lock+0x23ac, i.e.smb2pdu.c:8213 -- the same
> > cross-request unlock path above, which that patch does not touch.
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
