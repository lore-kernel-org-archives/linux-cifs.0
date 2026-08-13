Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E113913E02A
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 07:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786604681; cv=pass; b=fRsz4fTdTsmBN1lZdN6xw92rYDRi4AY/jKT98zCX2+J5TlKEsud/BgUiiH+TzYyQVe3mwr5dFGTSiqHxPMgFf2yhjZgjcQOGchLez1AC0duvnS3ewstdNvUt2wd5frIS2OTOPtavibt5CSW7f/mDptNDbqbPMMUCTTnTESeLeRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786604681; c=relaxed/simple;
	bh=X1EDllTI6D0/sJpi2HTiI2XNiHOoWp0QNvZxu8mJE94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BxiMl4hh9gWnfSQZZOzsttXpnrMk6cU7OMTRDkDAVbjQhTqJ0rXaP0K5bnE0j6n1PzrbSWf86sv1qN+e7HeHfBBP1nz4GEDJF90UrF6dZDYjW1xNgxPZelItltRW52EWCYNM8/vjg3mPQlbhEOtFOQBidyZgOUelUxT+JSWb4K0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tCW7o0ya; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tCW7o0ya"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-9088fa81abbso8279746d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 00:04:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786604679; cv=none;
        d=google.com; s=arc-20260327;
        b=NVfeKwH3m0JPHVHhi5TgPEqVZQYgTAEeKmod/t5/+CSZVjcVKwmHHmoIA78rJohAR8
         gEL4+tkIbXRjEcuWSekPWh1ccmL2yVuuGhTkhASWFKXdRAeUT6B2HdoywGKCYDFmU8J4
         DLmkbDA/7JIA3WaAlOqi6/9NN73DrxIeG5uSulQ76btiM5ImH7RLOMVpskz2k80c0iHG
         8UdDmY9BHNy8KJ3OVJZXZ+KIA21XPYQgWQgSYpm9W2hs/IKmhwGor8L+mjMM1VJpnoEN
         AaZTp600yYqPPSDt6icsQUFm7hHIM+KPjCMSEh+Kw4S+ICf7GOTyJVhF3qwhH8Y/w4yH
         7f1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b3PnwhW/3mUmS7oO9l3grczCvBTHHhadGK4fECKCH3w=;
        fh=e/0Se303X+KejLpUhuarzPAQHPKEHa/klnfVqpxClJc=;
        b=l+VjCWh6GvL8aHBJBAEp2duA+GbDt3I8xkWkgAS1UXyB1Z1RopOTaG8+TjXOAl2ZJg
         T9MINMC+pNsa++whgTeJweIbf1LvFPHujO3gXSnLnhILdm/Re2UFqEtmvEOPiLftF86Q
         eG7JbamXomT5cD1HZkTwCYs6btILorMoG7BzVAB8lRwamlkXXSdfPHVj20f4MDfiQhfk
         jKy4UknkjM9U0jDcK0Qsd4Rf07C39lmajdDBQh08VlzJVB5Mjzvb9ixhEJAVBtl3Eft8
         7MM8fpJfo4SonuWZFmRUTfOrS6cceWvsI8iY9GXkWzWAF/xDjwMuEMYtzh6qU+CK8jVE
         5jsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786604679; x=1787209479; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b3PnwhW/3mUmS7oO9l3grczCvBTHHhadGK4fECKCH3w=;
        b=tCW7o0ya8iZOwrlQrLW9zLgJCivDMlurX5aJ1dwNfAhOxzrY4mXj6FNRAg0uCr3f0Z
         pUlmhiFjlIPuz/HRxAwptgHkuDv0AZEvRpprMvZZmcMwz1R98vW6IWx56kFh+kP2+1GQ
         KdCL4Wzj/GfrqyjiHCj/Zk+aX0BZ30hc+lc74XgeASYnujr2RcRW8KvpgK9X1MKAJkSI
         pN1Gg9mbp422uMMWPhFqqRDk5neQn1WAEu3hI57tg1Ioui8U/egHhYdA3aA3z03FOhYI
         joSUge8He4pdWoErQbmBxu9LYt8/GXQNHsChXDqrALy6PQ353RHbg0Ziqp1ZSHuK4YP0
         7fvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786604679; x=1787209479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b3PnwhW/3mUmS7oO9l3grczCvBTHHhadGK4fECKCH3w=;
        b=AQdBV158Taq2Rq5FCUJZb5eiFMAPufRNkY2pJStlBkQ4i0iCdTfPY+MO8UsHicvnrc
         RW1phFWXNwaElNgfE3HEZGpfdH9K8sk7/2jnXh1//vMKL51w5mbjW+dJxuy3dVEWlXVk
         to6C9oGDubWpXdloaaDMAlNpjOvv1kaaoDW/xRwg6ZY4G6CGu1nCU0ZD0AiMXpk9LTtM
         EqjQkqKm/LZeelBUxBeMptn5YbIIJiowJjOI3iAxCaIiA4o/t94ejgJ5YHM7/QEiSZma
         AZXt5Itg4FPTJtNWNKVY/3z36Ppxo4rTBxVq6s+nXAQW9HX8TK/UqLxyhsno5/WkevHK
         llRA==
X-Forwarded-Encrypted: i=1; AHgh+RrW8Wfbqni1ubIOluh9TvaRbA4jzf8mOceeBvBL3Z+xvx/4WB5NaEzNvL7wu4NzENCHZW/0oVm1GQbv@vger.kernel.org
X-Gm-Message-State: AOJu0YxoYoydQDwdh8TBi5dhdyVbPXNLl31MP3T6ShYS76ZVqG/ejpvX
	M1w8VCITMH9qBcZialgXuf/iJ+lxFsyOe/pifGz+FQzwG04RXTO88OLd0TqkI3aDo7Og0YiHaTi
	dO7nEC+ir/97YqO51IsPJnlZbBpLofSI=
X-Gm-Gg: AR+sD11Ex6eE/BhJ18qOENV0/BSPbYN1/LoeQNQ2NaUvGeLR+T10cZlAfLOmMujVwq/
	3HxQPhJp38MuJOZFD5ZH9sqw/fEPZgpY10g4+rTo6WwEUNVe7hIlPW6/QCulSzJoXKXZLVx0Zqu
	q/eaFj7dA9+t0UXvPpOf8VwISNOvpbO89TQ8WB8P3N/BmeBcGWkL3H3BaLRdHBXRRKW8K8hD2XA
	h9ItqudyoUPw7EbsrLBTsxlH16L2V+96P7bSinIBOp2790qjl5ZZJnW2sFSEfMtW64xbNRumZO9
	TPuJEtZjIE4HJUv9TLxKZsfyZWyi10bWL8Wq8wmHEUMngwKIT0D48AA0k6ZDhLNPY8+Pi/TVxDD
	LjoSNLV1N9ABaJQm6soy2YHeP1QXb
X-Received: by 2002:a05:6214:3204:b0:907:bf2a:4825 with SMTP id
 6a1803df08f44-90a80c4cba1mr37265446d6.19.1786604678624; Thu, 13 Aug 2026
 00:04:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <437c9227-f0a2-4690-a2f3-e73faec909b4@chenxiaosong.com> <CALT=-87htFw_cgxFspNYgdhzhDVtcLU86AM7iG0eCB0aq5iH3w@mail.gmail.com>
 <bcf4c8dc-1e99-4223-ab47-9111fef30c3b@chenxiaosong.com>
In-Reply-To: <bcf4c8dc-1e99-4223-ab47-9111fef30c3b@chenxiaosong.com>
From: Blue bird <obnred@gmail.com>
Date: Thu, 13 Aug 2026 16:04:27 +0900
X-Gm-Features: AUfX_mwoUIJ2XlNM1vWGABNspvCNS8RDAFUEXFab6PJgTekAB1k1qb1OQKqGjb0
Message-ID: <CALT=-86bgP2fNX-cBH8BYP2V6=oZa1yt7nYw6GFuZemiK_=Nrw@mail.gmail.com>
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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


2026=EB=85=84 8=EC=9B=94 13=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 3:36, C=
henXiaoSong <chenxiaosong@chenxiaosong.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> Got it, thanks. Could this script be sent to the mailing list?
>
> On 8/13/26 14:32, Blue bird wrote:
> > I=E2=80=99m sending you the |kfuzz2.py| file.
> >
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
