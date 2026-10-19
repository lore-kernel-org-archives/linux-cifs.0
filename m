Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D3149A3BA
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 10:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404998; cv=pass; b=eUZn2+ItR0W9nFinOyJgGISJm6RK/ysJk/WyupiXbnNPde9+CLCIoM7X2cCSoPQShGLGVU6eahyPe5BnpPIVY70GpHPOPbOGahxH7nDj89J45zegWnaX/XLtH4+9Z0Qj1UgcUoGwlTzO/0vWQyNoE1UaCQLl4BnDRSdXj1tnhsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404998; c=relaxed/simple;
	bh=G4P5DiCaepBBmkM6SKxCxPCgFUV2Fc53Vf9I3vwmIvE=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=B62s1Co4jEQlgXZsfazptmm4Vy3uy2TG0lutnEtSoLap0BtwvPyezXtvP8sh6BTtFR2u7pi+BYBF6M+twefSooI2zBaBZDuzZ3pVIeKUKwOkXqDO9kduVuwxYoPlM0K3KqUq5XwsUkrPuRclrSo8+AamQjdqfDdcvIfcTGXXM/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CGo0P9As; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CGo0P9As"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-535f598d126so323901cf.1
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 03:16:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792404996; cv=none;
        d=google.com; s=arc-20260327;
        b=ghir3JtYMZSUvICOctyVnGmiCMeSUWMCR3FjFp7/fbn8EamOut2DhaWErvxtB1imdc
         h7sDygsDP60xdDu6uPqV1tGVWwCrZmHjWNIdaCgPXguQSXfsACJJFvPviXvN9V6Ms8Cd
         aDfchmjA4RU3kcTqj7iiiaigQ1a8gsIJXh7V8tEu4iAyM/y9NROn+udPxz9JxhnDwtai
         vfJIPgcUl7elpWc8tSb9opsIolzuDeJkcQOxfM8gyPyrYqBsfFJ/9zYUlE5T3rjm+1Em
         yACCSDXqb7jvG48L2fKGXseYLXMRGbjpNQUTAWVCP//gOnFZjkb/XuwE1wyjlBl6TKGZ
         t+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=mcsn42Lhkb8Ku2tF+hMSF6j2gRSuMGyz6+whGpcvxAI=;
        fh=t+1v03sPehsmpmWnOGMeVD8iSyn8gxsLZc+9SIasI9c=;
        b=D7suqrOhFj5ZrJBrN/ZSQ8RoysZG9MJar/1yo+RElA3wGrJ6CKCt1MY9Pv34CrCM/5
         5Le7Vjg6vYhaUCo58DJ+V7jhSuoSPK2TWhNNrj4nOynxfixDhFPTd+QwQIHjd0fc70RO
         cqQ9ewArMWSO9ayU5iOX1rTvbctpRm3boO5v7UajrSAeGoAtoVC89H5gIC54L0+qz4YP
         XyLn4ddLBSXpKBKLTM7xz+loysGH3EPlWTw28vXfqw7tFIsqQaC3q27UPd/klWsRFag1
         vxvTvDj8QLeRxWFBr1R7E8pXgo6IkwD3wQph1BCJkMuO0wnTVDgmeaqa2PCfnleoQ9nG
         a6uA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792404996; x=1793009796; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mcsn42Lhkb8Ku2tF+hMSF6j2gRSuMGyz6+whGpcvxAI=;
        b=CGo0P9Asm4QK3OdbpB8j3cpahBovwfBgu8UrxCGIQbd6QRn4rX8BpBtaND3N6bloT/
         vK7zcI2vws1ILNxTRS8kGpuAJ1Nmh5nTtZWp8UgOmW2vG48zzt/3X8R2aBLh76EbWKdI
         s38D03G7droa3Rgd3AIyS++yvsRP2a50EoaErwW0l6fK0xhi7tQj8oQRebuXMB+Jkzg4
         G8hiEBLufUG8g+D26sYlTQtnCslG2pxE1vG9eBf/7R8q8nqU05378nKFfQsW7pW/BBlT
         WkX9EHri2JuOq8S8sCDLx5F8dhle1xSKBD+oJv/aAEkrFF+WX6NVuZRJZKAHhFYrv7Ck
         i3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792404996; x=1793009796;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mcsn42Lhkb8Ku2tF+hMSF6j2gRSuMGyz6+whGpcvxAI=;
        b=q1SmtTK3wva6ufe79ijthxlDwKKL0TrR8OKlC5vHTGWS9pciuZAB+ABl5aX0SAoZ4f
         Fv+Z5lrkF5HMukkKS2HeH5yyTv+vO6qR7DZPYBt9xn+JTQdUBjvN5GStDPze1wM1jVbF
         BZTOYE5O9IA8Y0vuCZqYaoHfFGNll6IefT68p318j6iUi54suIxeP3ichzQoFinVi+kC
         9Y24EJEEoptTiWm2djecMj1D4HLG73PHEOLYzXtVB5VF786AvDDwS31f7JRBR8oAWeZ5
         Ld2UzTTF6JK0qxl70cc3oPZDATBMwiOuD4CVi/9gUbCblHUV97lwaxHCp7IhKq7t1xjj
         hjsQ==
X-Gm-Message-State: AFq9FYI8HX+BDLcIANiSONQyCP2743hXr+uMbaxVY9+Try7goHqIRDtd
	sRyO+XJ5Tqn5JtaPTZGkK1iL7x7rSCfDI3PtKr4wbBYJlhs//boNZWOtZlmHbJXW3W6aJYrL4AQ
	R4vVvMeuV6zTcioLSxqX+XNaDf69ewtKL/nRye5VE
X-Gm-Gg: AYBFou0rxB+B7AqQcUCvRovY0K2xtW4GzpZzb2XxPVyyn/ZOkd8dLiBeGyIvN4kOkpb
	xMIOrryvj41nmI9nD4U2xX1oe9MGE0kcaU+YN641d5k/MQTxHGr92rPY6f1Au0UdpltVhrZ4G8n
	95yj+Qeg2CFDTo3F926MO4nDk7xECApj2c+nd43r63gRiEGiIzGkcQHsgvNKnFTP3To8cVq0Jy4
	bnLna02oNqn/D0JrpNq22UIdr+CsKQJ5Nrkhh7eVCbznfTNsn0HGiI2+8L1ctnHfA8NDHAShYgx
	2IeeIU2Ajl+8jAXufAVP4dmeChejq3dDczeGGVB1sPYL1DFE1vTMSDdpoZhjsTBwyQf9i9WbpPh
	v8eShMWDLgFoiA2dBfdPd3IPPIzHulwiqBv0HOaCGZsLx8o/qyyV1aOh3Ewtj0RTtudZAfVZMJr
	OJfriinps9+GTCq35hJ8zFF1PjbLeoA58g5k950a652FPepCerGoCm1IAfByrn/Bk=
X-Received: by 2002:ac8:5ace:0:b0:534:b7b2:634f with SMTP id
 d75a77b69052e-53646227b1amr31868371cf.8.1792404994740; Mon, 19 Oct 2026
 03:16:34 -0700 (PDT)
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Oct 2026 03:16:33 -0700
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Oct 2026 03:16:33 -0700
From: Dominik Maier <dmnk@google.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 19 Oct 2026 03:16:33 -0700
X-Gm-Features: AclHuK-ZKmiSJW_z3Mc51F2sfWWX6kiNMdx3qzJOoENGtxIr-zUkcyVIhH5JI3o
Message-ID: <CAE7N4SrkzmJ2_3ZDq84+6cmVOYe0huz4uHhg8RcHq9h936OfaA@mail.gmail.com>
Subject: [BUG] smb: client: slab-out-of-bounds read in CIFSSMBPosixLock()
To: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, dmnk+artist@google.com
Content-Type: text/plain; charset="UTF-8"

In Linux 7.3.0 (commit c03c1a14507d), CIFSSMBPosixLock() in
fs/smb/client/cifssmb.c (lines 2365-2420) validates data_count against
sizeof(struct cifs_posix_lock) when handling a
TRANS2_QUERY_FILE_INFORMATION response, but does not verify that
data_offset + sizeof(struct cifs_posix_lock) lies within the received
SMB packet.

SendReceive2() allocates the response in a 448-byte cifs_small_rq slab
buffer, and validate_t2() only checks DataOffset <= 1024 and
DataCount <= ByteCount. When an SMB1 POSIX share is mounted with
-o vers=1.0 (with CONFIG_CIFS=y and CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y)
and the server returns a short response with ByteCount = 24,
DataCount = 24, and DataOffset = 300 (or 480),
parm_data = (char *)&pSMBr->hdr.Protocol + data_offset points past the
end of the received packet (or past the end of the 448-byte
cifs_small_rq slab object). Calling fcntl(fd, F_GETLK, &fl) then copies
20 bytes of out-of-bounds kernel slab memory (fl_start, fl_end, flc_pid)
into the struct flock returned to userspace.

We reproduced this in QEMU with a local loopback SMB1 POSIX server that
replies to TRANS2_QUERY_FILE_INFORMATION with DataOffset = 300 and a
client that mounts //127.0.0.1/share with -o vers=1.0 and calls
fcntl(fd, F_GETLK, &fl), reading 20 bytes of out-of-bounds slab memory
into struct flock. The reproducer is available upon request.

Below is a proposed fix (also tested in QEMU) verifying that data_offset
points at or after ByteCount and that
data_offset + sizeof(struct cifs_posix_lock) does not exceed the
received SMB message size.

Fixes: 92d198a3a208 ("[CIFS] Add POSIX lock support")
Assisted-by: ARTIST LLM
---
 fs/smb/client/cifssmb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f329ddfd2ca9..62f8c7a38c5e 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2391,7 +2391,12 @@ CIFSSMBPosixLock(const unsigned int xid, struct
cifs_tcon *tcon,
 		}
 		data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 		data_count  = le16_to_cpu(pSMBr->t2.DataCount);
-		if (data_count < sizeof(struct cifs_posix_lock)) {
+		if (data_count < sizeof(struct cifs_posix_lock) ||
+		    data_offset <
+		    offsetof(typeof(*pSMBr), ByteCount) -
+		    offsetof(struct smb_hdr, Protocol) ||
+		    data_offset + sizeof(struct cifs_posix_lock) >
+		    smbCalcSize(pSMBr) - offsetof(struct smb_hdr, Protocol)) {
 			rc = smb_EIO2(smb_eio_trace_lock_data_too_small,
 				      data_count, sizeof(struct cifs_posix_lock));
 			goto plk_err_exit;
