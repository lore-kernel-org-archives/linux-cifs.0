Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBCE34F24A
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 21:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335928; cv=none; b=FhTSiUVlwrm4kxk9FlLM+2rNyjM7VUxhJzUnzVFWxZnvziCi5q9kaSWJ+y43u3U8ursuqNrIdjzcJjTy4w5suVoPksHYwMcDZ4pbteN4aEh4L0I3LmbCK/uA1ZgUsX/+i9kB0ElxDQppveS4XXhVIcP1jUgdD6Bv+9v4s7TeZNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335928; c=relaxed/simple;
	bh=OFmUR5n12qboMmyBDS8aJ5gQxbHGee425Wkk4EjiRoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFZy7rKIRUxIrim6Rx96hrXKOfGmYnd5ld4nm8Ryv6Vg9vWwF1k2GJYzB+fAI4mq9t6xbePrTbjXut7yDpVT06jcAsGlWoVIL4jnj7G66T2Rq1sKEzZcpnIMh/mgfOOxz/HsDjRY4TgObCu+Uf1Y9zlJG5DNxFu5mvfPzbFtlps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqL9E29d; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MxV+27v/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqL9E29d";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MxV+27v/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789335926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6OnhzbABUYbzzJKN8af0lhPKwu8S8OBp+evSnROGSRk=;
	b=eqL9E29djmv34nt5xVMLFrWe/lagJOcpmv3U1f/ARSWjuoE38g9R0gjtsDjQk1KhFYWtYr
	8RjUXXU+tI/9O39PEwjUxjIPVp22EARAoGxSbsS5MIrzy8xLCkxpwBauAKv894plFFKf4G
	S1TQ+fKcB6qvqWO9Xk7bxnFluu/4ZsE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-Ma43eaITNaW-03uBmfCPcw-1; Sun, 13 Sep 2026 17:45:24 -0400
X-MC-Unique: Ma43eaITNaW-03uBmfCPcw-1
X-Mimecast-MFC-AGG-ID: Ma43eaITNaW-03uBmfCPcw_1789335924
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9102f07f2fdso72534046d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 14:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789335924; x=1789940724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6OnhzbABUYbzzJKN8af0lhPKwu8S8OBp+evSnROGSRk=;
        b=MxV+27v/EUnswzVAZG903qygAgW93OpvmlGD6zJP1uXjXa9vsernjQOi8nt6zzTRoe
         9wyKQHwyGA1bio0yF5RLx2jmSIJTe+EGoY6gfr7Ypl8+EDCr/om8SQ91ZFL6zO91cakV
         oy8lrTe0XGP4AimqJIA4z8S7ga0gEhmda/gI6YPj7EsWjRvF34wFDWMUqkX7lqPFD9C2
         gi+PwvD2ypVWnNDIs1+Ii6Ih2rrvYqbAMLqUW92zV2T+4cCmmh6CduOBsrRLpnWIX+CP
         38ptcPSyB0sIQDX+3b9KoGBXmlGCrcEH/Yd5KrYkIiobnpoBaUDoLB4OSI1drF81O5vb
         shnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789335924; x=1789940724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6OnhzbABUYbzzJKN8af0lhPKwu8S8OBp+evSnROGSRk=;
        b=d2toSArf3kN+gTgFg7ri1ZK4ttaXl+xU6DbGQPlOjNmsNbQ0ipatfQ74jUmYKWcBR7
         /UUaNhWDK2oJbTv/Kl5TW4Y8zn1B5IbSGBfT+t3W9xI7+tjUc44OG4AsT9Yn8KvqMuSf
         MpAnyJMUjJBEeaZlhzMLpEuAXoLMZVB2+ziivyXmmtGZjKnMhU3re9LbOSiR+ZhJF65t
         JKpH3LJlbvVXhrehDesqtOg/EzCongg8YnTCXtY3pojlUFDXYDDuyUtJ8lDqRnXb5Ues
         att0/9+GFi67eOhtidy2vSy1GIIgA8eBNMCnq/Y0GjNv43EZTv3fp/cmMxixQFtlwy31
         yGug==
X-Gm-Message-State: AFuF++lrSpEs9q3zhsAhM82xLrP5KfCLJ1Edz7goQpbSdPH2XAzWeH0R
	6F8mWsCqyUsiSpXUe+B5H5eYVpmEbQRlqcA8dekwJpqcWCo43fNRI2CkuKpOiJGSN5oI1Ez2kT9
	qUa9uLElZacyUtm0xJY/lad4FGCetmz0lB6smnIW13FWOVdy5eDH7arIZlBXi7O9EdEK64aU72W
	WSGvjO1gch5xg6uKHDoDWCUBEXxMfQOgpXM8c4yY9ECVRyFxFjqg==
X-Gm-Gg: AYBFou1P5oQdSoynJ/pUO7bbBzXLp3Z912ON4XqlnMx4aEeWfe8bXTgpGGf3fY38cJ3
	a5C/uJmK3PaHWjin/2UsjKEmHatHPbyzAc0D32+saPpM8PG85+VmzvyAuUgSzPGMVoUz/P9J8aG
	Js7cfnB7ii8jrSA/fTS0mV4UK92XudDm+pbZQHLx5MBkQHQuzx4xntaazvmNVLhzh1/62mOcX1l
	zra3c0hiXvn/eeJpJ0F0tk1jaUb2wWVm6DwSTfHrqQA5RsD3cu+ey660id2z2ez2MKTfpf/gXFs
	ni8YHhloA2Zxlb8d/O3WZCB2q8PZSOVSZUuSZtCwKnbjcqvZWsELHqscEvnjUMoJJeZ6lh0iIVC
	WlPJVzKqM1lnUhqVcnaBSZ8nqBdrPlGO2DcEghO6ra/C1htP8z5DdKlLH5hvvu9rCjA==
X-Received: by 2002:a05:622a:281:b0:52e:125b:9444 with SMTP id d75a77b69052e-530fb4983f7mr43674891cf.17.1789335924117;
        Sun, 13 Sep 2026 14:45:24 -0700 (PDT)
X-Received: by 2002:a05:622a:281:b0:52e:125b:9444 with SMTP id d75a77b69052e-530fb4983f7mr43674601cf.17.1789335923622;
        Sun, 13 Sep 2026 14:45:23 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f49444bsm78581126d6.29.2026.09.13.14.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:45:22 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v4 05/10] smb: client: reject short Next offsets in parse_server_interfaces()
Date: Sun, 13 Sep 2026 16:45:03 -0500
Message-ID: <20260913214510.3071370-6-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260913214510.3071370-1-sorenson@redhat.com>
References: <20260913214510.3071370-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In parse_server_interfaces(), the server-supplied Next offset is
validated against bytes_left, but not against the size of the interface
structure itself.

A small, non-zero Next value can pass the bounds check but advance the
pointer by less than sizeof(*p). This causes the next iteration of the
loop to read misaligned, overlapping structure fields.

Fix this by ensuring the Next offset is at least sizeof(*p).

Fixes: 7d34ec36abb8 ("smb3: fix for slab out of bounds on mount to ksmbd")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7f2177f6fc01..bda940cb3784 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -785,9 +785,9 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			break;
 		}
 		/* Validate that Next doesn't point beyond the buffer */
-		if (next > bytes_left) {
-			cifs_dbg(VFS, "%s: invalid Next pointer %zu > %zd\n",
-				 __func__, next, bytes_left);
+		if (next < sizeof(*p) || next > bytes_left) {
+			cifs_dbg(VFS, "%s: invalid Next pointer %zu out of range [%zu, %zd]\n",
+				 __func__, next, sizeof(*p), bytes_left);
 			rc = -EINVAL;
 			goto out;
 		}
-- 
2.55.0

