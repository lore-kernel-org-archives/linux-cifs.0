Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0C3373C00
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 08:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786610827; cv=pass; b=LxZkEUNjpiDESyU9PLxjpfp3VcVndkqH8B5m/E7iiIgLcJoszmZWHaiL2jUfpke50PsgrsJyIy3uf2I3k4S6SHd1BALyWB6zupdLVotEEtgmTrHb9WQNpm13k/uirS+kR2JQvEAsJds9XSwmt5WJiZEbCzTwNxkXwq+RGzCh7U8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786610827; c=relaxed/simple;
	bh=X3BLJXbmL+DafFUzN2gc//kxX+aGg9drTeyh3hL1FOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OTpHjzSAD2F/dygLXrrPM48BcMSVfrWhibYfDivpBQMPbHhofpQ2AtVK664ixNACbJVEYw3Dn8da3Qzn1Y5gc5t+aDc7CAKQVxGB8ikEwQu1x6bEpRGcuTkm6zENma12LCFoVW53676j1b3x7SrkDK5mSqEXc7+gU+ynMKASg9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tsr71Uyu; arc=pass smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tsr71Uyu"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e55b62640so19244185a.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 01:47:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786610824; cv=none;
        d=google.com; s=arc-20260327;
        b=H/9fWW/heGxuoy4h0VeETIFolpsl5Cmjj+AmhHi9V7j9WNvgUmKmWDPGTlXw9bKVP0
         HRRuxO5ufugbIQAkvDRj3g/JKXZ3zKoOW5tkCoeg5Zv6siHuGkwkPy8TTtADGVSt+B+6
         dxfT4Y/h/Q1om2/nMQX08OevpCkvHGkcZMo2GXzEV5Z1e4BSlZUB4ylTait+qG+aOovE
         aZ5lf1RjCUBtditNu0hVs/j0F5Sm+h4b0/DXMXNKUcxnJ/ISpfgQsN+40Oe59jI5cO/f
         yDeXhmScOpQRAUOFuMmb3ZaJztOiDnNK5gpW0KkuaoPfWTvgdgUVFr4X361FcQc38Mtt
         PPiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SuqzaSE1KwiInG4M+19/CLE+JrHzlvd1Ld+pj5MFykw=;
        fh=1AVKUDyrozeEgOH7mFsyj9vOHVSrMuYFODS55kEpDb8=;
        b=MZylLrqCw7bKtOSL1uLvuOb1jLIUXsR5BCKmU1pLaHS5aK1FfqtLXDEMVc8ZkJk7Ng
         XapMLRFM4sn+bw4oYn8U5k7FyTn3sY3AhEEtEldB7Lrbz/ngqjauAOwaO03WOAAGm5a3
         uwjGr9v6r3X05lFI+OLTmjUmPAouBIJovPoRgSO7iDyJRxxGyyirvKKsi2EO0CjC+MQp
         7HOawtQlRtz8ldgY4UTpa4vyq1wg+nT1zg2NNxmOFJCEKq5GAQ+lXYddBJVMYW4urSu3
         HpQsrwgOebT5mX0HUqcZ0j2dIwvuRRHKOuZIQcY4Hl1QCMUTbDgr3voto51Cq6NH41l2
         OezQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786610824; x=1787215624; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SuqzaSE1KwiInG4M+19/CLE+JrHzlvd1Ld+pj5MFykw=;
        b=Tsr71UyuBMKOQmH51EnqmeJs3H1MDOLWSwpIjwVVYUBoNF+zshX2qEVedujneNHlnw
         LKUF1OE6PdMF0iORNxN8qgGj/ovjA7XWMy2gU0YxSzpYFuk8k+aitp2BJE0IGhhWC8Mo
         A1MxUkv4TYzYiCyGWb5er0rwuJ0BWv33z0D96Pjbm0t2TVUhu6tbE4Si8Q7zh9ITM7Og
         5tNec/IT0ucLEWan+OoN7P3LvJ88rq6khRRfz6xoqnKdoWl09Jg7xO0a6qyvmI5KIFJ6
         8GvTFPvT5Hok028qhFvriQ8XXv8zWEXdbNTMm/3OtZrA2Zenb52IxIHMxdm0tXUBBBhs
         kThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786610824; x=1787215624;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SuqzaSE1KwiInG4M+19/CLE+JrHzlvd1Ld+pj5MFykw=;
        b=G5dfUNwjAfDCJINU8l+Y6/Iml8y93jIjHU1fPx373IPVlc01ZPKDbhDusqz/qFoy8G
         OcBTzEcWFYrvQJR0+itM/iw5NbShyOXw4N00U+YwQlyLXdXSFlOxiUJF6FNxFTAzdNi7
         XI4WRuJkVsde2DW9RP75b6OPBVFolzCfojYJygiAAWo+djl+Dy/MBj2BjC2XMLRNnTQJ
         h3BWrisX1J6MhSxOxDduFq42rl307YE3rb7OsHtorLOQ17K/pTz3XBqAIxrY8G0Zh3bM
         vgvXOlfHmRToJFA1gHroJzeW2HvqDXTjDfmCCUPdq10yb1P5n+BVvpwniCaY2sw20v0p
         SiGg==
X-Forwarded-Encrypted: i=1; AHgh+RqxA1gaTcsJPYij8X0U6+gk1L4pNChDWn4lI9WFTfc3nJqPd9Dnt02bmbUT1kEGPGu8Oa18AycZWow9@vger.kernel.org
X-Gm-Message-State: AOJu0YzKkl524lSnq+vIErX5yn+bigY02oBUwN+JA/RfWRWur/kCWZEA
	VismUSQ0fQrejajOTB1oKcAnjMJgQoATZdElC9ZoyUpdVP2uIFdK2nMH+PUEsuGJ54PXjgFPFRD
	qkZX1RE9zgxHBPxKLfReg7daDLz7DS1E=
X-Gm-Gg: AR+sD1122WldRBufzo95dZ7i+aSO/8xkCBAbSCCbt9vUwf/xhd/3mt5Ltnw+83X33/Q
	eLPYYZs3dxRL0QxJErd56odjUS+5+8NchgxzWSnuyix2p1kFqaXiUT3rBBK9qCVLK1IrfgnzVYD
	o2GECYaOtU3vUcFcxmc+2AZ8Vy7wwZ9z56yP3eae7fVXE8sg/t9z4PtobXvZliPjDqU2ABi2d7u
	hFIDPe88trVJuuZdJ7ZpDTWfh7969X2dcQz1DUIsYZdbwJ1WF7dsBLXK7etks+vqxDSAmnZjNft
	uE8hbrJUE8NDVOOkWk5lQ/9zBP/K6hfvo2+JJpQye5il/zWB1ncNjrwDvmgq8R9efDpokI1hQyx
	8Jy7+x+fTSs4MDmCqLxF/8ascQW6u
X-Received: by 2002:a05:622a:2506:b0:51c:52a:8e70 with SMTP id
 d75a77b69052e-52d73c274b6mr43157931cf.2.1786610823987; Thu, 13 Aug 2026
 01:47:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com> <CALT=-86Z47htBZ6QjUZquDSMoeMYE1dswXVDSfAntg22p0ox2A@mail.gmail.com>
In-Reply-To: <CALT=-86Z47htBZ6QjUZquDSMoeMYE1dswXVDSfAntg22p0ox2A@mail.gmail.com>
From: Blue bird <obnred@gmail.com>
Date: Thu, 13 Aug 2026 17:46:52 +0900
X-Gm-Features: AUfX_myridsXsk6EI9qmJWoBEL66oM_tTdW7Wn25nLwGEnC46LQf7HvcqSXVpeM
Message-ID: <CALT=-84VBgbtAbRTDO7o8+8NJrNJ3tTBG512_N7KOodpmi_ErA@mail.gmail.com>
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry about that -- it is not a package, it is a local helper module of min=
e
that I failed to include. It only needs impacket (pip install impacket); pu=
t it
next to lockfuzz2.py. I am inlining it at the end of this mail so it is in =
the
archive.

While re-testing I found that my original mail was wrong in two places. Bot=
h
corrections matter, so please do not apply the patch I sent as-is.


1. The proposed fix is incomplete
---------------------------------

With the vfs_cache.c hunk applied, the same BUG_ON still reproduces in abou=
t
5 seconds. The __ksmbd_close_fd() path really is closed -- the trace no lon=
ger
goes through it -- but it simply moves to:

  locks_release_private+0x214/0x2c8
  locks_free_lock+0x20/0x40
  smb2_lock+0x23ac/0x3c34 [ksmbd]
  handle_ksmbd_work+0x4f8/0x1594 [ksmbd]

smb2_lock+0x23ac is fs/smb/server/smb2pdu.c:8213, i.e. the cross-request un=
lock
path -- the same one I described as having an incomplete guard, and which m=
y
patch did not touch.

I also have to withdraw the "A/B tested" claim from that mail. The patched =
run
survived 150 s only because it never reached the second site in that window=
; it
was not a clean result and I should not have presented it as one.

Making the same call there as well:

list_del(&cmp_lock->flist);
list_del(&cmp_lock->clist);
cmp_lock->conn =3D NULL;
spin_unlock(&conn->llist_lock);
up_read(&conn_list_lock);

ksmbd_conn_put(conn);
+ ksmbd_vfs_posix_lock_unblock(cmp_lock->fl);
locks_free_lock(cmp_lock->fl);
kfree(cmp_lock);

survives 803 lock requests where the partial fix died at 194. My harness st=
alls
partway through that run, though, so I am explicitly not calling it verifie=
d.


2. The use-after-free -- I can now diagnose it
----------------------------------------------

My original mail said the KASAN splat was seen "only under heavy parallel l=
oad",
reported it as a "Read of size 8", and said the ->llist explanation was a
hypothesis I could not confirm. All three were wrong.

The reason I could not see it before is mundane: ksmbd's own pr_err output
(the "Try to unlock nolocked range" / "Not allow lock operation on exclusiv=
e
lock range" stream) overflows the kernel ring buffer under this load and
silently drops the earlier faults, so dmesg afterwards only shows whatever
happened last. Capturing continuously instead --

  sudo dmesg -w > /tmp/dmesg-stream.txt

-- gives the real ordering. From a freshly booted guest, Tainted: [O]=3DOOT=
_MODULE
only, no prior corruption of any kind:

  [284.826] BUG: KASAN: slab-use-after-free in smb2_lock+0x33b4/0x3c34 [ksm=
bd]
            Write of size 8 at addr ffff0000d69b9738 by task kworker/3:8/19=
84
            Allocated by task 1984: smb2_lock+0xa90/0x3c34
            Freed by task 2119:     smb2_lock+0x23b4/0x3c34
  [285.088] same task 1984, _raw_spin_lock+0x100/0x1a0, faulting on
            00d20212000009c3 -- "address between user and kernel address ra=
nges"
  [287.598] kernel BUG at fs/locks.c:312!

So the use-after-free is the *first* fault, it is a *write*, and the BUG_ON=
 I
originally reported happens 2.8 s later. It is not fallout from the BUG_ON,=
 and
it is not on the __ksmbd_close_fd() path, so the vfs_cache.c hunk does not
address it at all.

Symbolized against the same build:

  +0xa90  -> smb2pdu.c:8156   smb2_lock_init()
  +0x23b4 -> smb2pdu.c:8213   the cross-request unlock kfree(cmp_lock)
  +0x33b4 -> smb2pdu.c:8323   list_del(&smb_lock->llist)
                              inlined list.h:226/249/260, i.e. the
                              "next->prev =3D prev" store in __list_del()

which gives the mechanism:

struct ksmbd_lock is threaded onto three lists -- clist (conn->lock_list),
flist (fp->lock_list), and llist, which is the *request-local, on-stack*
lock_list / rollback_list of whichever request created it.

The cross-request unlock path unlinks flist and clist and then frees the ob=
ject,
but never unlinks llist. If the owning request is concurrently parked in
ksmbd_vfs_posix_lock_wait() on a later lock element, it wakes up and runs

list_del(&smb_lock->llist); /* smb2pdu.c:8323 */

whose __list_del() writes next->prev through the freed neighbour. That is t=
he
8-byte write above. The garbage address dereferenced 262 ms later in
_raw_spin_lock() looks like data rather than a pointer, which suggests the =
slot
had already been reallocated by then.

One caveat on severity: on kernels built with CONFIG_LIST_HARDENED or
CONFIG_DEBUG_LIST, __list_del_entry_valid() catches next->prev !=3D entry a=
nd
skips the store, so the write does not land there -- but the fs/locks.c BUG=
_ON
is unconditional either way.

I have not tried to take the write any further than the crash.


Reproducing the use-after-free
------------------------------

Unlike the BUG_ON, a lock-only harness does not produce it -- I spent a whi=
le
failing to, which is what led me to the wrong conclusion in the first mail.=
 It
needs the mixed workload: two instances of a general SMB2 command fuzzer an=
d
three of a create-context fuzzer running alongside lockfuzz2.py against the=
 same
share. On a freshly booted guest that reaches the KASAN write in roughly 28=
5 s.

lockfuzz2.py on its own still reproduces the fs/locks.c:312 BUG_ON in ~5 s.

Happy to test any patch.


kfuzz2.py
---------

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

2026=EB=85=84 8=EC=9B=94 13=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 5:23, B=
lue bird <obnred@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Thanks for confirming it on mainline.
>
> One thing about the for-next-next run: the output shows locks_sent=3D0,
> which means the harness never managed to send a single lock request, so
> that run did not exercise the path at all. It is not evidence that the
> branch is unaffected. The harness silently retries on connection errors,
> which makes a failed setup look like a clean run -- sorry about that.
>
> kfuzz2.py defaults to:
>
>     KFUZZ_HOST=3D127.0.0.1  KFUZZ_USER=3Dfuzzuser
>     KFUZZ_PASS=3Dfuzzpass   KFUZZ_SHARE=3Dfuzz
>
> so it needs a share named "fuzz" and that user to exist. Please set those
> to match your setup and check that locks_sent climbs before drawing a
> conclusion.
>
> On the UAF you hit: I think it may be the same one I have now root-caused=
.
> Captured on a clean untainted mainline boot with continuous logging
> (ksmbd's own log spam overflows the ring buffer and hides the earlier
> faults, which is why I missed the ordering at first):
>
>   [284.826] BUG: KASAN: slab-use-after-free in smb2_lock+0x33b4
>             Write of size 8 by task 1984
>             Allocated by task 1984: smb2_lock+0xa90
>             Freed by task 2119:     smb2_lock+0x23b4
>   [285.088] same task -> _raw_spin_lock on garbage -> Oops
>   [287.598] kernel BUG at fs/locks.c:312
>
> Symbolized:
>   alloc +0xa90  -> smb2pdu.c:8156  smb2_lock_init()
>   free  +0x23b4 -> smb2pdu.c:8213  the cross-request unlock kfree(cmp_loc=
k)
>   write +0x33b4 -> smb2pdu.c:8323  list_del(&smb_lock->llist),
>                    inlined list.h:260 =3D=3D next->prev =3D prev
>
> struct ksmbd_lock is on three lists: clist (conn->lock_list), flist
> (fp->lock_list) and llist (the *on-stack* lock_list / rollback_list of th=
e
> request that created it). The cross-request unlock path removes flist and
> clist but not llist, so one worker frees an object that another worker
> still has threaded onto its stack-resident list; that worker then wakes
> from ksmbd_vfs_posix_lock_wait() and list_del() writes through the freed
> neighbour.
>
> Note this UAF is the *first* fault, on an untainted kernel -- it precedes
> the BUG_ON rather than being fallout from it, and it is a write, not a re=
ad.
>
> Also, please do not treat my earlier vfs_cache.c hunk as a fix. With it
> applied the BUG_ON still reproduces in ~5 s; the trace just moves from
> __ksmbd_close_fd() to smb2_lock+0x23ac, i.e. smb2pdu.c:8213 -- the same
> cross-request unlock path above, which that patch does not touch.
>
> 2026=EB=85=84 8=EC=9B=94 13=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 4:59,=
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=
=EC=84=B1:
> >
> > On 8/13/26 00:09, Blue bird wrote:
> > >
> > > Call trace
> > > ----------
> > >
> > >    kernel BUG at fs/locks.c:312!
> > >    Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> > >    CPU: 4 UID: 0 PID: 1509 Comm: ksmbd:::ffff:12 Not tainted 7.2.0-rc=
7-
> > > gf5bbbfec59b4
> > >    pc : locks_release_private+0x214/0x2c8
> > >    Call trace:
> > >     locks_release_private+0x214/0x2c8 (P)
> > >     locks_free_lock+0x20/0x40
> > >     __ksmbd_close_fd+0x67c/0xc28          [ksmbd]
> > >     __close_file_table_ids+0x430/0x780    [ksmbd]
> > >     ksmbd_destroy_file_table+0x5c/0xf4    [ksmbd]
> > >     ksmbd_session_destroy+0xbc/0x38c      [ksmbd]
> > >     ksmbd_sessions_deregister+0x3fc/0x5c8 [ksmbd]
> > >     ksmbd_server_terminate_conn+0x20/0x40 [ksmbd]
> > >     ksmbd_conn_handler_loop+0x4b4/0xd10   [ksmbd]
> > >
> > > fs/locks.c:312 is BUG_ON(!list_empty(&flc->flc_blocked_requests));
> >
> > Hi Blue,
> >
> > Thank you for reporting this issue and providing the poc.
> >
> > I reproduced the same BUG_ON on mainline. However, it could not be
> > reproduced on the ksmbd-for-next-next branch, but another UAF issue was
> > found, I will continue debugging it.
> >
> > ```
> > LF_SECONDS=3D10 python3 -u lockfuzz2.py
> > t=3D5s locks_sent=3D0 faults=3D0
> > t=3D10s locks_sent=3D0 faults=3D0
> >
> > lsmod | grep ksmbd
> > ksmbd                1236992  0
> >
> > modprobe -r ksmbd # slab-use-after-free
> > ```
> >
> > [  170.722187]
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [  170.724724] BUG: KASAN: slab-use-after-free in proc_remove+0x3e/0x80
> > [  170.726934] Read of size 8 at addr ffff8881044eff98 by task modprobe=
/1019
> >
> > [  170.729907] CPU: 5 UID: 0 PID: 1019 Comm: modprobe Not tainted
> > 7.2.0-rc7+ #5 PREEMPT(full)
> > [  170.729917] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> > BIOS 1.17.0-9.fc43 06/10/2025
> > [  170.729922] Call Trace:
> > [  170.729926]  <TASK>
> > [  170.729930]  __dump_stack+0x19/0x30
> > [  170.729939]  dump_stack_lvl+0x49/0x60
> > [  170.729945]  print_address_description+0x7b/0x200
> > [  170.729952]  ? proc_remove+0x3e/0x80
> > [  170.729958]  print_report+0x5b/0x70
> > [  170.729980]  kasan_report+0xed/0x130
> > [  170.729987]  ? proc_remove+0x3e/0x80
> > [  170.729996]  __asan_report_load8_noabort+0x18/0x20
> > [  170.730001]  proc_remove+0x3e/0x80
> > [  170.730006]  ksmbd_conn_transport_destroy+0x2b/0x320 [ksmbd]
> > [  170.730073]  cleanup_module+0x33/0xe00 [ksmbd]
> > [  170.730126]  __se_sys_delete_module+0x276/0x400
> > [  170.730133]  ? fput_close_sync+0x9a/0x110
> > [  170.730138]  __x64_sys_delete_module+0x5f/0x70
> > [  170.730143]  x64_sys_call+0x2675/0x3030
> > [  170.730147]  do_syscall_64+0xf0/0x3b0
> > [  170.730153]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [  170.730157] RIP: 0033:0x7f81a592b02b
> > [  170.730162] Code: 73 01 c3 48 8b 0d ed ad 0c 00 f7 d8 64 89 01 48 83
> > c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f
> > 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d bd ad 0c 00 f7 d8 64 89 01 48
> > [  170.730166] RSP: 002b:00007fff84d9cdb8 EFLAGS: 00000206 ORIG_RAX:
> > 00000000000000b0
> > [  170.730172] RAX: ffffffffffffffda RBX: 000055993a2f5ca0 RCX:
> > 00007f81a592b02b
> > [  170.730176] RDX: 0000000000000000 RSI: 0000000000000800 RDI:
> > 000055993a2f5d08
> > [  170.730178] RBP: 00007fff84d9cde0 R08: 1999999999999999 R09:
> > 0000000000000000
> > [  170.730181] R10: 00007f81a59a5fe0 R11: 0000000000000206 R12:
> > 0000000000000000
> > [  170.730184] R13: 00007fff84d9ce10 R14: 0000000000000000 R15:
> > 0000000000000000
> > [  170.730188]  </TASK>
> >
> > [  170.778338] Allocated by task 141:
> > [  170.779443]  kasan_save_track+0x2f/0x70
> > [  170.780675]  kasan_save_alloc_info+0x40/0x50
> > [  170.782044]  __kasan_slab_alloc+0x52/0x70
> > [  170.783312]  kmem_cache_alloc_noprof+0x168/0x3e0
> > [  170.784715]  __proc_create+0x20b/0x710
> > [  170.785846]  proc_create_single_data+0x78/0x150
> > [  170.786703]  ksmbd_proc_create+0x24/0x30 [ksmbd]
> > [  170.787525]  ksmbd_conn_transport_init+0x4f/0x80 [ksmbd]
> > [  170.788525]  server_ctrl_handle_work+0x64/0x2c0 [ksmbd]
> > [  170.789471]  process_scheduled_works+0x788/0xec0
> > [  170.790295]  worker_thread+0x894/0xc10
> > [  170.790986]  kthread+0x2e5/0x3c0
> > [  170.791548]  ret_from_fork+0x168/0x4f0
> > [  170.792256]  ret_from_fork_asm+0x1a/0x30
> >
> > [  170.793241] Freed by task 1019:
> > [  170.793802]  kasan_save_track+0x2f/0x70
> > [  170.794411]  kasan_save_free_info+0x4a/0x60
> > [  170.795155]  __kasan_slab_free+0x47/0x70
> > [  170.795878]  kmem_cache_free+0x122/0x410
> > [  170.796556]  pde_put+0xfd/0x160
> > [  170.797156]  remove_proc_subtree+0x365/0x540
> > [  170.797910]  proc_remove+0x6a/0x80
> > [  170.798500]  ksmbd_proc_cleanup+0x1f/0x60 [ksmbd]
> > [  170.799389]  cleanup_module+0x18/0xe00 [ksmbd]
> > [  170.800243]  __se_sys_delete_module+0x276/0x400
> > [  170.801046]  __x64_sys_delete_module+0x5f/0x70
> > [  170.801827]  x64_sys_call+0x2675/0x3030
> > [  170.802498]  do_syscall_64+0xf0/0x3b0
> > [  170.803155]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> > [  170.804362] The buggy address belongs to the object at ffff8881044ef=
f00
> >                  which belongs to the cache proc_dir_entry of size 192
> > [  170.806657] The buggy address is located 152 bytes inside of
> >                  freed 192-byte region [ffff8881044eff00, ffff8881044ef=
fc0)
> >
> > [  170.809083] The buggy address belongs to the physical page:
> > [  170.810057] page: refcount:0 mapcount:0 mapping:0000000000000000
> > index:0x0 pfn:0x1044ee
> > [  170.811450] head: order:1 mapcount:0 entire_mapcount:0
> > nr_pages_mapped:0 pincount:0
> > [  170.812749] flags:
> > 0x17ffffc0000040(head|node=3D0|zone=3D2|lastcpupid=3D0x1fffff)
> > [  170.813918] page_type: f5(slab)
> > [  170.814464] raw: 0017ffffc0000040 ffff888100a252c0 dead000000000100
> > dead000000000122
> > [  170.815773] raw: 0000000000000000 0000000800200020 00000000f5000000
> > 0000000000000000
> > [  170.817065] head: 0017ffffc0000040 ffff888100a252c0 dead000000000100
> > dead000000000122
> > [  170.818361] head: 0000000000000000 0000000800200020 00000000f5000000
> > 0000000000000000
> > [  170.819656] head: 0017ffffc0000001 ffffffffffffff81 00000000ffffffff
> > 00000000ffffffff
> > [  170.820991] head: ffffffffffffffff 0000000000000000 00000000ffffffff
> > 0000000000000002
> > [  170.822282] page dumped because: kasan: bad access detected
> >
> > [  170.823477] Memory state around the buggy address:
> > [  170.824297]  ffff8881044efe80: 00 00 00 00 00 00 00 00 fc fc fc fc f=
c
> > fc fc fc
> > [  170.825501]  ffff8881044eff00: fa fb fb fb fb fb fb fb fb fb fb fb f=
b
> > fb fb fb
> > [  170.826698] >ffff8881044eff80: fb fb fb fb fb fb fb fb fc fc fc fc f=
c
> > fc fc fc
> > [  170.827971]                             ^
> > [  170.828634]  ffff8881044f0000: 00 00 00 00 00 00 00 00 00 00 00 00 0=
0
> > 00 00 00
> > [  170.829862]  ffff8881044f0080: 00 fc fc fc fc fc fc fc fc 00 00 00 0=
0
> > 00 00 00
> > [  170.831072]
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > --
> > ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> > Chinese Homepage: https://chenxiaosong.com
> > English Homepage: https://chenxiaosong.com/en
> >
