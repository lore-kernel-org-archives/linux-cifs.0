Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DFC28690
	for <linux-cifs@vger.kernel.org>; Fri,  2 Oct 2026 00:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790901559; cv=pass; b=SlnY3AoMMPrbQiTOzQe3UAgubfVT3GlHftaL+i/xCXotvS4ncpETa9zmioUP62NkCru8NaBlf6SLiULQT+kUG3teyRHfBtJY4BNcAOiOXL2SuktunfC1JF2WU22fsWCo6dC3fzwRBfNUpwb2cgtuq1A6xYaVGnMTDnFTtv7z50A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790901559; c=relaxed/simple;
	bh=q+6JmjXoqXFzk75kbs4iOwFjPyx29ZsIRuPUTrNRfaw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=DyWRTlXRjyv9aY8uklJZAKvrq1j3QYNOicGT6Abc9dtgYj3h8OegkbAoPozL2wR8hHq7PNQoCvz/3g1qZ+T1CniPZsMWz8oaoq0IYMFrHh5o5uZghLwrZhjw70syGKz5RApl3hsEBoaK4OjPK7u0P0L5ErCh6PWEIfwugAD6Wwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bsUDFJne; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bsUDFJne"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469d249c6so4255996b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 01 Oct 2026 17:39:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790901558; cv=none;
        d=google.com; s=arc-20260327;
        b=fRFzdkM+CDq/pIBg3Q8+aOx8BAWOzmuttO0U3o4EtW2KLx3mDxr7aZ4ZvF62kJSUjp
         94T08RcIZ+nu+yNIHprQwJinezP7BAPYHd3edzaFiuYAkvNjbeOj7uT9T+8XV68cJvHK
         28lSojZmgEWiuxuYi25Jz2Kz+0lNkem3yjs7+SbctCfSlTKUtkzmCsq8rNFAaXDt9xPF
         4PlIAdE0w4HqbA8SgDSZK0o2KyzNDmHA/67urvLsynm0t3fYWze45Dbf/DDQxSOWUusj
         GPv6tsI6u8HNNcaMixeftfcQoDUTibUSPBg7bT6Ur7HrmxQq0zb2GWLbCkWbxN6ijkXF
         VeGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=L/QbTye19jxpIlXh5TM8jjJsFiN71Nkr83E5stflnG0=;
        fh=qPdn3nxQgygyQjJTDEl9+ZhpBtTWrqIbsZA12qELXjI=;
        b=Ggi+tEzOMEaoVkR+JDQYzQCKQ6qFBOeXSuQMKerucu8Kxi0e7rlt48pG37myIGnUQ8
         MeIDNgPtaj3ckhWVZmQ6was1ri8dMmhNXJT/wDsR47ytE1RoHuDGZoaqpy/VUDNn2isN
         gzEbVZ/5SOijdvT1FM27ar5Etqe2M/t6HO4hMoi+JV7rGM8bW9ckvFXgngmpYq24/Kkr
         nez7Bi+OkHOVzBvsJZrWuJ2EZsHekXca+6Q/w+s8PqvmrN6mYF46JrWh9MosDncO28Bj
         NeJPn4aMZbcQAVpDU3P642zOqiYU7LpfQavsmDzRVM2isZvlHjcDCrl4cQwQ5HxvLh3U
         8kVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790901558; x=1791506358; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=L/QbTye19jxpIlXh5TM8jjJsFiN71Nkr83E5stflnG0=;
        b=bsUDFJnew7aeVIDhmid1rh1aTNav0khFaZpFVJLD1r5WmHaouYkfPhCbD1j/50i1fK
         KX4oKAV++PoLGIGA9A+GiQmoTjyp4wa5BQ66XlO9Cc6HYsqLM2hFVUlO9TZJSlTOidxa
         iCXsgFdMY2hR1i1njwQG0Wj5+uv5UhGmfP3e7metSpLHVXnGMDeey6fENapjXeWZ1e3q
         vwcUAr6AV63yNJEgx0MWZUBsxuZhCI4yaKHav1GL0+GLQhLWyUOPqNdquqVKeqSoubhx
         ypyfaIR+oYJPF9owNlxpN2EarmFoLcq0MvdxIOkPbusLzaDvtraWy7+ipH3cjOAhA621
         4Yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790901558; x=1791506358;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L/QbTye19jxpIlXh5TM8jjJsFiN71Nkr83E5stflnG0=;
        b=fbr4GBNmBeKICxQ1QSPJgWQNrO3JYJ4hJe5YVLlB3z612PwCmP9zgCSyrzY/1JapLO
         ls9lXg7WgyodKMMMno/jpD3rg4RBXjtB5SpYgNrXzifm6kEBjadT6aCh0uG/d4Fo7vo0
         UN3+6Y7sqor5YqDOS1b5to8l+s6nZWuXII+PjA/T0nOkQdrh6UTN6KysMdW1gSij3TNK
         HZOicVi8PUT/8PnUtwwPL9cosvAsZ+wuZhEbAVHs9n7//KLDCkPSvM30iz8E6XeDy4Ml
         KatI6qC7xBEiTOtkgR8DFuvQjKPi53kTiY+RUO2tLIelP7V6ytdyfWW0ly5VmCjAz3ao
         s46w==
X-Gm-Message-State: AFq9FYKjw3P4J98OlCNC64RFSRA2t7Cl8js8PHiv30tC5lvQ+TC5jTVL
	DeL1TAv7DxX5xpGF2wKnPjq8g5EG6k6s3CbyBXAc19iEsrV4ZSZKX1reXNAL4QNdbK7ZhO9bEfe
	RipM0l8SQ5dztHP2aFDB4yCMN/sMdKh9bqVES
X-Gm-Gg: AYBFou3zxreac3bclB+cosNsgG+MUtnqjygFOjs+kqWy6AMr4jgncfNONyA8YewbzsK
	mfvV2U3y7YJU5IDSbKn4ZmpM4QpGgwdHpYtHw8bkycnp3IVXPYF3TlA9m1D+g7QqKxk7Mn7kz6h
	IdUFZZ8CyLSuaysuZXMumizAPTiv91wjWOD9clFWPxz3zD06AOIXBawb1ZKcXJa9ceNL/RfxrNA
	AbmM4sh8pqWtlMBLS4VF9aILgOrMiLJoiB1At2fxWX3CzFxRkEhqBJIxAVUnCld3tPpN/HqkZwp
	L55mMVi+N2DAsrs173VqQabsf1fmIPmAMU4P4IY7bmBeIT3HOKNFdwY=
X-Received: by 2002:a05:6a00:300b:b0:881:bc81:e8f6 with SMTP id
 d2e1a72fcca58-88af7aada78mr896079b3a.23.1790901557632; Thu, 01 Oct 2026
 17:39:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Asim Siddiqui <riksha.driver@gmail.com>
Date: Fri, 2 Oct 2026 10:39:05 +1000
X-Gm-Features: AclHuK_5wf2Gdb9GTJNXSbaLzO8K0lha-oVXfVU39JNF0CT30oAa80Y3RW5x8SM
Message-ID: <CAKhvyj1zeEmhp_vJWuPHcUFGJp=tZxqG3oAgfc7qSwmSmU0tMg@mail.gmail.com>
Subject: BUG] ksmbd: in-tree SMB2 wire format does not match MS-SMB2 -
 non-Linux clients cannot complete NEGOTIATE
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

In-tree ksmbd cannot complete an SMB2/3 NEGOTIATE with any client that
implements the MS-SMB2 wire format (Windows, macOS, Samba clients). It
only interoperates with the in-kernel cifs.ko client, which uses the same
internal struct layout.

Environment
-----------
- Kernel: v7.0 (tag 3131ff5a117498bb4b9db3a238bb311cbf8383ce ->
  028ef9c96e96197026887c0f092424679298aae8), clean mainline tree
  (verified: the only local patch is an unrelated PCI p2pdma whitelist
  entry; the running ksmbd.ko srcversion matches a build from the v7.0
  tag).
- The 64-byte struct smb2_hdr layout is present at least back to v6.6
  (checked fs/smb/common/smb2pdu.h at v6.6, v6.10, v6.12, v6.14, v6.16 -
  identical).

Symptom (reproducible)
----------------------
1. TCP connect to :445 succeeds; ksmbd accepts and ACKs.
2. Client sends a spec-conformant RFC1002-framed SMB2 NEGOTIATE
   (MS-SMB2 2.2.1 40-byte header, dialects 3.1.1/3.0.2).
3. Server ACKs the PDU, then sends FIN with no SMB response. No log
   output (dmesg/journal clean).
4. Reproduced with macOS smbutil/mount_smbfs and with a hand-crafted
   raw client.
5. Control test: mount -t cifs -o guest //<lan-ip>/share (cifs.ko
   client, same kernel) passes NEGOTIATE and reaches authentication
   (rejected at auth, as configured) - i.e. kernel<->kernel interop
   works, kernel<->MS-wire does not.

Root cause
----------
struct smb2_hdr (fs/smb/common/smb2pdu.h:142) is a 64-byte layout that
is NOT the MS-SMB2 wire format:

  field                    MS-SMB2 wire (2.2.1)     in-tree struct smb2_hdr
  total                    40 bytes                 64 bytes
  StructureSize            40                       64
  Flags                    offset 0x08              offset 0x10
  Command                  offset 0x1C, 4 bytes     offset 0x0C, 2 bytes
  CreditCount              offset 0x20, 4 bytes     offset 0x0E, 2 bytes
  Status/Id/SessionId/Sig  separate                 embedded 0x08/0x20/0x28/0x30

The server applies this struct directly to the raw wire buffer - there is
no wire<->internal conversion:

- smb_get_msg() is just "buf + 4" (fs/smb/server/smb_common.h:213).
- ksmbd_negotiate_smb_dialect() (fs/smb/server/smb_common.c:283) casts
  the request buffer to struct smb2_hdr * / struct smb2_negotiate_req *.
- smb2_handle_negotiate() (fs/smb/server/smb2pdu.c:1103) computes
  smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects) = 100
  (64-byte hdr + 36-byte fixed body). A genuine MS-SMB2 NEGOTIATE PDU is
  50-76 bytes, so "smb2_neg_size > smb2_buf_len" ->
  STATUS_INVALID_PARAMETER / -EINVAL -> the connection is closed and the
  prepared error response is not sent (hence the silent FIN).
- cifs.ko builds its requests from the same structs, so its PDUs are
  >=100 bytes and parse cleanly server-side - which is exactly why the
  Linux<->Linux control test works while every MS-wire client fails.

Evidence
--------
- tcpdump (server-side, port 445):

    09:54:18.170184 IP <client>.49454 > server.microsoft-ds: Flags [S]
    09:54:18.170206 IP server.microsoft-ds > <client>.49454: Flags [S.]
    09:54:18.173925 IP <client>.49454 > server.microsoft-ds: Flags [.], ack 1
    (client then sends 66-byte framed SMB2 NEGOTIATE, dialects 0x0311/0x0302)
    IP <client>.49496 > server.microsoft-ds: Flags [P.], seq 1:67, length 66
    IP server.microsoft-ds > <client>.49496: Flags [.], ack 67
    IP server.microsoft-ds > <client>.49496: Flags [F.], seq 1, ack 67
    (no data from server; connection closed)

- dmesg: no entries for the framed NEGOTIATE. (Unframed probes do log
  "ksmbd: PDU length(%u) exceeded maximum allowed pdu size(16384)" -
  the RFC1002 length check at the 4-byte boundary works; the failure is
  in header field offsets.)
- mount -t cifs (cifs.ko client) -> "mount error(13): Permission denied"
  (reached authentication stage); macOS smbutil view -> "server
  connection failed: No such file or directory" (no data exchanged).

Impact
------
In-tree ksmbd cannot serve standard SMB clients - its primary use case.
Any distro shipping in-tree ksmbd (e.g. Ubuntu 26.04 ksmbd-tools) is
affected; users are silently steered to the out-of-tree cifsd module or
to Samba.

Suggested direction
-------------------
Keep the 64-byte layout (if it is the preferred internal representation)
but restore the MS-SMB2 40-byte layout for the on-wire structs, or add an
explicit wire<->internal conversion at the transport boundary
(tcp_recv_data / smb2_handle_negotiate). The in-kernel client must be
kept in sync so Linux<->Linux interop is preserved.
