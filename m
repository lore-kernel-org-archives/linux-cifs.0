Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D99C199D8
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 23:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776641757; cv=none; b=BrkBuo2tfyQVkeEIXndh4XcJcdiWCXJMqX/nSLBCcY/dDCBbmzu+bruMLcTuDi5OuVhMYpWT5MH5fyKJkzFzwJbnw1u/MNwYycAf2ScmYqfAej6rYnhW55VI45/ablRDop30VS1l3I1FR4NtP5dSzDNXcuGkyBd1ssEGKZW1+l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776641757; c=relaxed/simple;
	bh=n+/9oE8TaB93W1IqyEWeYZPZfGQ+zJkX0tDzr2hV0CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwB4kdMyBnff6rYKC5mIuZRbK9kR5OM4RdDzUE/Or42UXzwhhy7xJHHAUHdqlXEwFWqZQBND9xumU00d8hUqZ4o9dAkZb1gZAuj76CQraATHdjs+4Q0umKpLAcxcJHKVVg/rxEYgM5lwaLvsN9quXGGC3zRw1sT659rGewpHoUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ak8EB9YW; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ak8EB9YW"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-506a7bbe9d0so21337811cf.0
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 16:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776641755; x=1777246555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vOx1KMOCIDqbwM807GVLF8N7abkefceoi6Jbuerw0w=;
        b=ak8EB9YW6n10p8HH/GaaQWjn91f6vcyynGVLv1mESkHC7ar93gHnbtOGDlf6Dmp6Yj
         b0jDDKCZy1s4QGQg9l590jRCMuRUJ3o1w9VemWH1gCb64JK/qAsAw4QBHRjArjrOO5tG
         1KgX69s8iTYYm8iz/0GjKEEcU/P5747eMi9mQzL3Ms8v3EkrO2SRdAGChCP4TEhilm5x
         2uJEKJbDuevErxfnvFk/TSDbvTA2BM0jvmwRFTGL1ioXgKsqVfGWqZsdTPQvZI0fpOOC
         t0NJtMm8ssOB2XZZambyy8YsucY04Ldc5Mrz6z+VEAJWKVMpeu21K1Mm5oICxa+3+k2s
         CepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776641755; x=1777246555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0vOx1KMOCIDqbwM807GVLF8N7abkefceoi6Jbuerw0w=;
        b=qDXbQ7Eb+w7YHmDjiRM2VtwMV/y9NYXH+BpHDm+LVi4JEMmEJ5XBQP/lL/Mtht609r
         9qVymJZKztE5r/CNm6N1M6/kyWcEfRYj6XChDjtl5no4UpZZHr8cpRI7kZ6ltCi1TofU
         McH5GjIoCyadn7fRIhASaWLs7HudAF2BAeK61871etnvF7fiQ380d74RftRuCLBof9xn
         8F6AltdImrsl+MmFMU6XsNm4434SmEbm0VmxW0Bm1odBv3//dLdVoWdZAABj4hhqJH7N
         7taXN+fNaGmE8sIoB41vRqfb/o3hSgaKAIxzpX/fFPiD4fnUtBE2F1Eo6iMLF+U+tJnf
         h2gw==
X-Forwarded-Encrypted: i=1; AFNElJ+Dfz5wyPmfLdH9xKuXkJCyDO29d/hJJ/gwkC7t/cGk7+Vk2lOxikGfp+OqTii+qgZWnipH82VIu+1I@vger.kernel.org
X-Gm-Message-State: AOJu0YwQHxGBeQ1Hhrp/UZ6DTKRUX8RLGmQhnNGe1MsbotN0ZTMmav96
	KWLebWXdspP+zbp3K2TBVU48rrTcCCMEBOfYKgvgOcfLUv3/RA+XYRDP
X-Gm-Gg: AeBDieso4hTZjzdPTKI+Jp6uAs0ZRJhrQFgZPILtmnnQWGByfwumDCUwMuDRI3H3O3j
	aGF5VVPPICzBDCX0YnbL4BvFsNXkMz95gfT3TqCwDkqDHXqBbQDf8p7mvdk0W2f8DtAjs0TZBBr
	VA1dH9OG+qrmb+Vq45P/ERJNEImLclHy8tjmaXXWxM8kfeSVjYzyy9nM+TcWdn0cDU9FoI6cJba
	hfH7Q3oYibwA8EforX4414k+ZO2DA2pi0zLsP3gyxOmkhF1DrU0qPctanothm5IhL0J27yntgrK
	9fJ9CUhN0RgRuazkmAL3tmISx6skB9m0u6LHIn7UToXNgk3t/zkVxZayzMvY+OUrSzOJwZDbzah
	CbkUVbGmfg0rQvITDLHLVi2xImNChxP5mNsOu9NNh3d/xNkRqunKlJZmAKCXm1KNlj022p2UWqg
	wov2Fmy3hMdfzxwlGYUyPxxHi+WwTECtqwLdkg0d+sLDsR/kRHTd8+zhlqyPdJJDGi8vEt9HgRs
	qusZMRISHhIVjT9L3PrydSxa9NIBp8=
X-Received: by 2002:a05:622a:120d:b0:50d:8b40:d97b with SMTP id d75a77b69052e-50e36bd318cmr180439941cf.17.1776641755202;
        Sun, 19 Apr 2026 16:35:55 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e3945ae5bsm70011581cf.23.2026.04.19.16.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 16:35:54 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] smb: client: fix OOB read in smb2_ioctl_query_info QUERY_INFO path
Date: Sun, 19 Apr 2026 19:35:19 -0400
Message-ID: <20260419233519.2777046-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260416213716.3118443-1-michael.bommarito@gmail.com>
References: <20260416213716.3118443-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_ioctl_query_info() has two response-copy branches: PASSTHRU_FSCTL
and the default QUERY_INFO path.  The QUERY_INFO branch clamps
qi.input_buffer_length to the server-reported OutputBufferLength and then
copies qi.input_buffer_length bytes from qi_rsp->Buffer to userspace, but
it never verifies that the flexible-array payload actually fits within
rsp_iov[1].iov_len.

A malicious server can return OutputBufferLength larger than the actual
QUERY_INFO response, causing copy_to_user() to walk past the response
buffer and expose adjacent kernel heap to userspace.

Guard the QUERY_INFO copy with a bounds check on the actual Buffer
payload.  Use struct_size(qi_rsp, Buffer, qi.input_buffer_length)
rather than an open-coded addition so the guard cannot overflow on
32-bit builds.

Fixes: f5778c398713 ("SMB3: Allow SMB3 FSCTL queries to be sent to server from tools")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
---
Changes in v2:
Use struct_size() for the new QUERY_INFO bound so the guard cannot wrap
on 32-bit builds.
Keep the check anchored to qi_rsp->Buffer, since that is what the
current copy_to_user() actually reads; OutputBufferOffset would only
matter if the copy site changed too.
Also reran the synthetic 73-byte post-fix case under UML and confirmed
the new guard still rejects it cleanly.

 fs/smb/client/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 509fcea28a42..3600705255f8 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1783,6 +1783,12 @@ smb2_ioctl_query_info(const unsigned int xid,
 		qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 		if (le32_to_cpu(qi_rsp->OutputBufferLength) < qi.input_buffer_length)
 			qi.input_buffer_length = le32_to_cpu(qi_rsp->OutputBufferLength);
+		if (qi.input_buffer_length > 0 &&
+		    struct_size(qi_rsp, Buffer, qi.input_buffer_length) >
+		    rsp_iov[1].iov_len) {
+			rc = -EFAULT;
+			goto out;
+		}
 		if (copy_to_user(&pqi->input_buffer_length,
 				 &qi.input_buffer_length,
 				 sizeof(qi.input_buffer_length))) {
-- 
2.53.0
