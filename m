Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962201;
	b=dqr23HE7GuPWWyCxJAHD0klsLl2PD5st9rymNCAG+GupgRVXrfs529jIddOGK3JouGA/
	 0QaDSwv/E5PODgC39Qdp1yuRHEEKlt+IzbpMWtvCge1BgifxtrUOSqTND7bqupGFSI6vp
	 ZzFJTh9CZAI4RiAZTbPKJN1oZLb6SSMopKnSeA4HlBGNkiFizpqK39N86s35r/hP38zbT
	 GQ2Hc4LjX0ySIOqfm4b99KnCsib0wN6Bh/TVMLpOV3HB5pZB7g8IXq6OjmppXVYAF9XLM
	 QPGzbct5K4r5aN63ZlA8elqW2zzx4vhnVmdX6Tjf1O5nJ4XOSgxlMiq3UFLzBlKArbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962201;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WDLZPh7PUmv3CPLyOhpFsyhjmlQuKfntG555/rG5jRU=;
	b=TeDcGuEpb/wEYqT7mZ1OiOnboWPQZppOK+sR7WJMUskva3obozeB8cqabG+IoEACrku3
	 NH80ZGhwpguQDScMYqMb6Ed/qTWhJci/8EAOoxYMug3aY4ygwSzd7W3kuVArzAOuiyKPk
	 voa5Q8HZwzgbD+6UdglKWPH9IsK8VjTIDXQJmGNOXIZ3eo5D+D0dRCWzHOuh3CeCkFYW6
	 ScKSm2B6uFDZeLXknedf+ktpPrB5Gz4Q540fpbqHn6S8lkqZTwRaEFKW2kZwBC4XbdonA
	 I98IFswXmGXUa3RFhamSNW3xuPAsdx4gDWUcIf3mypVDwYs9htlhL5leC0BaWgUgzlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gmQUgS2v;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41AE606A326
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 10:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F41AE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gmQUgS2v
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ac6794fe45so416589a91.0
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 02:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793962200; x=1794567000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WDLZPh7PUmv3CPLyOhpFsyhjmlQuKfntG555/rG5jRU=;
        b=gmQUgS2v5vNPYtHdSWaMGw2CYsaHiBn53zVtNJXMW7DGq08KNxmyovakHCy1VOGctZ
         1MgDuQm97ZEyLvuwHHpcEk2w+mta/EuGYmYWODLbr7uylZPV9x3ObF7NVg3lqxAMNrbC
         EPjsGpa/wkp2nyRNTVatQlQFzEybNs6fZEZAZwfv5Rj5BOzEfvDkVFDLuKPO9/sxcown
         YDIRh4ze4WaystuR0MXpzSDaGhEyd4wZyf6IAnBVwil4Kw4RkpOkmWNY+9JUz5KTm7nS
         EqkcFHasdvolN/F35OQpPrr2wV6S6Ul230YPQb8uF57bWhy0AeGQuJ+3EYEQybidCfYS
         QGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793962200; x=1794567000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WDLZPh7PUmv3CPLyOhpFsyhjmlQuKfntG555/rG5jRU=;
        b=ghWUVAG6fyXGxtBKPw8i8Szu81kvLMYj+drojdz872RB7+Jb+4irM6ISy1Lnj5oxOX
         DHiYM7zIjOdXmtfU/lFJg8wtfLiemJZSjOiuk40vrAQyZ+VtcVE8Y41VWVfwi2kLSYIp
         gd7ZIEGhqjz1asERecGrIJrcBG1HdHE30xv5vW68nxW/JkW5yChzv2FpqCsm4GGgJ1lz
         ZfkKysq7mUPrtSVmc5sz9bDtv3PRFPNq8Hp3AumOpY4ylgM/CR+9mDBtUdAw47Ax+juS
         waFYPbXMXdqCIe6LMWogBTJzhNSq+fh/fn9GYtXE4VxfAZD1HR+YXrblE081xGPreDXH
         ZFQQ==
X-Gm-Message-State: APuU4Z88KUuhoHwHYWmC6rz+HmmdFwM/Nr4G0D+HpW8N0eF5RQO+YaS+
	AgJsgDmPJnUq5IqhxSpBQMkCvROTBvllguC2N9+qEJOM8W+8XO5YfQk6
X-Gm-Gg: AYBFou13Qq2vIho4EbIzezsTSQO+3TARsIgWw8oFKRLat2X3vHJfJml59X7jxA6AULW
	GPRfvZWk8bbUOvhUTsxuYyc4dPRDJ9oz4mP6m/AyjOy7GNDSTyUM2zSKb9JLAvqmg25bW/ypvzQ
	mhR/sodVT5l0JTDVpSykLjn0KaNSc9v5V+ClR/bFFLdKsp+wTz203T2KQwf8vWOnK7I5cpWuziG
	Pf6fvQJqrWTWBhfZNgCZvvoNZFhKBrsBhfgCXA5gmCrMXPqtPtq3Djy/kY7OUm0sR1Py4msMWLV
	yytr5/Na/mAAhuTz5cHx6sajNPzVy6XjzZc2F+WRTcwmEoZE0ApH+ylUB0ypSUqXF6H1MJJw5An
	1dQs1F05S6tSUqjrhPIagSjiy3TbUCNE0qtDb3H+z+6vcWexY3jWeWYe4IlaWtBMbXxNwbuTeHw
	uJStzwU94zQW4TBAhUIOa09Qg2MOsvAGjutUh87P+rZ8WDXyqHxNAvI3BSTqtDSlhauL+bHo7IU
	dj1W/sHs/Btp35V9uMulmiJfpl/HdWTaJKBfsEurst9w37Pez8MCDl66FB/0WYsZCxNz5wQAY7E
	so8UFVE9AKddeE2+byAHxbCDNS3ZjglRVzQKMr1H5Q==
X-Received: by 2002:a17:90b:2d47:b0:3ad:ce24:acfa with SMTP id 98e67ed59e1d1-3b0db6b0d42mr2120526a91.20.1793962200200;
        Fri, 06 Nov 2026 02:50:00 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0d7c8a3d9sm3747364a91.10.2026.11.06.02.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 02:49:59 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH 1/2] smb: client: validate descriptor headers before query result allocation
Date: Fri,  6 Nov 2026 18:48:35 +0800
Message-ID: <20261106104842.441067-2-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261106104842.441067-1-pkfxxxing@gmail.com>
References: <20261106104842.441067-1-pkfxxxing@gmail.com>
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

query_info() uses the server's returned length instead of the caller's
minimum when a dynamic result is requested. A zero-length ACL response
can therefore return ZERO_SIZE_PTR to id_mode_to_cifs_acl(), whose
ownership-change path reads dacloffset before checking the header size.
A KASAN-enabled test shows a read at address 0x20 and a kernel Oops.

Validate the returned range and the caller's minimum before allocating
the dynamic result. Keep the reported length zero if validation fails.

Use the security descriptor header size as the minimum in SMB2_query_acl().
DACL-only and SACL-only xattr queries do not require owner and group SIDs,
so enforcing MIN_SEC_DESC_LEN would reject short descriptors that these
queries could previously return. The rewrite paths validate the required
owner/group SIDs and DACL separately before using their contents.

These issues were discovered and fixed by Qihoo 360's Tulongfeng
multi-agent system.

Fixes: 9ee2afe5207b ("cifs: prevent copying past input buffer boundaries")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
---
 fs/smb/client/smb2pdu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f85595136..72166d49f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4023,6 +4023,14 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 				ses->Suid, info_class, (__u32)info_type);
 
 	if (dlen) {
+		rc = smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
+				       le32_to_cpu(rsp->OutputBufferLength),
+				       &rsp_iov, min_len);
+		if (rc) {
+			*dlen = 0;
+			goto qinf_exit;
+		}
+
 		*dlen = le32_to_cpu(rsp->OutputBufferLength);
 		if (!*data) {
 			*data = kmalloc(*dlen, GFP_KERNEL);
@@ -4077,7 +4085,7 @@ SMB2_query_acl(const unsigned int xid, struct cifs_tcon *tcon,
 
 	return query_info(xid, tcon, persistent_fid, volatile_fid,
 			  0, SMB2_O_INFO_SECURITY, extra_info,
-			  SMB2_MAX_BUFFER_SIZE, MIN_SEC_DESC_LEN, data, plen);
+			  SMB2_MAX_BUFFER_SIZE, sizeof(struct smb_ntsd), data, plen);
 }
 
 int
