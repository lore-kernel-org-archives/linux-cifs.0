Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DDC6EB79
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 22:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746226446; cv=none; b=UqGmB6hP6ArtpRQw3z1E5g8dBzFfyZ6UYlDCUrCtULckv36D64zDHjCYuHGCg0qWzmKlMMBuUvIQP55hpmfhiNFOJffdSfQJcuYcMUeayArmH7DSYEoNR+KI5AYLQPTcTr8KF5xa6KujVVXaJFgIJ57mBjJtWRBZ2DbIHD+hLI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746226446; c=relaxed/simple;
	bh=PqdS1eaMkQ/Nl9I/vcEhd0/rhiktllnhQ2akH+83Oxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyCxcct3aZxnmQGaXV9fEJLnA+zfwQ27MapXbhhspbWu74Stn77NUGUApqfiyo8ouh/RjYDKtgCmsc8pttuxguppLoX1UKh5jABxZn2fJTatiETNZ/ZCmdGD5jBIdsDYv8EwKqc0YUNxNeqe8AIoU7xEIR0AhhIyCUTvchF4R70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O0izzRp1; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O0izzRp1"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39ee5a5bb66so1488470f8f.3
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 15:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746226443; x=1746831243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yg1lyhz2WJgwf62tG81tIFmjc8Jp+j/IBDyhSvs+htA=;
        b=O0izzRp1AeHHiMM/OedZ/8/cf+oV/yapHGCzGwLewTrOmK1XvghG2Kd/YXzxUvH4+H
         8QJZjj/8sI43FgWe6Ulq+0IjDIbC/MtgB3ROx1DxQ5PbuEYsc7nLIQOfTMaELYId14ao
         r2Ior62eaVbIJMqkFTHbmExuvDnQDMYiBNVx57BJYWcjwxhKtgX+3Bv+KFUlQgiwzZKX
         IcMU/0fFcwup4auXtQPecQe+CcwL+a2V4/QKnscsP3/51g2sEs0Y3H3DzAe4f6n486pg
         wsNuZbBjalxj6rC5ipU9cozbC+RNBCaPNrFLYd7u5ekWnCY4Zi44QL3Ov2S8q5/ONdHT
         Ecug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746226443; x=1746831243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yg1lyhz2WJgwf62tG81tIFmjc8Jp+j/IBDyhSvs+htA=;
        b=fenM4wnUoEcMPUeE8FXGRPqBhdvEJ4FGd3QF+8cezob0xq3wJ8CEaiRNd0gcj6x0iG
         6Hkp23s6S8Zgj/0ado60AR20igcDbUHwEwgoK+2EjVH66b6bHXB7aL6iSP1i8eims6wf
         CF74q6ppiI8SMdVEyP690o9wnE7O44r1lKrnNZQBdKu1Q9cgl5a8GKPGnETPzO540/Ir
         LkdvMwV363pv3ZU4K4359C1mSHEBWpjBfBsQKv0WWPI4pSXQ2TxEJ+3LoyfgsqZQWnd6
         6ebDocRcQ/nWN6fbC80KumU1Q/g0fYYfq0VR+oZP+M6kkL7DczVXGAGvlX3mPQY5vvKG
         X++w==
X-Forwarded-Encrypted: i=1; AJvYcCWsnewarMkseysr0rOun3QqA7mnGfV7RQa6U9+iqT3VW3JrmpiSy0XOV6XS0iTCFL8NsJoHXH1LqiZh@vger.kernel.org
X-Gm-Message-State: AOJu0YxVvJDNBPgxUOa7chvNEjURw775O437JcI9lVMth+BZ0PAtSJPc
	qIrjFRFg2U5ta+sC57NEt3go4S0IAoc5NXaRvHxRMQ/CzktM4R6aFqZ37QqX5oQ=
X-Gm-Gg: ASbGncsK7ofu3tZ74oQDgon7gz09qi58JyceMIXQRKc/0emtnLDUqTIWiuh05WeuKE5
	UwPDqY8tjbhbD0iMcFb5GoUUFDvrpPEbHLRQ1kBGZcR787nopVHgj8z6mrbcZ9kDTwbQJ1LB0sD
	MPrFupU/W2cm2vOFBv+rPrzL+ybjHN9D3AAJq/GvNhF3gS8+gvig7/VAaMKj715V7nJ48//21LK
	T7hnBlUAkzY69aGPfZKf8JYb26eU6s4PugFTWA4b8GCMYhDTCewZ/hqY37L6q5cXq/teJRp4Izg
	Osr7EFbKn7U6G4CRoWDh5nle2gIGSyFbOACDXvVawY0yigX57K4M1sIsIvAD1LB4sj4=
X-Google-Smtp-Source: AGHT+IFbCUTYVF7YGfDspe9A98xyDnx9xYhWBarTexazk1k06uzW5JBp4SBGd/7T83fmTnlftcrlCQ==
X-Received: by 2002:a05:6000:1889:b0:39e:e3ef:5cbf with SMTP id ffacd0b85a97d-3a09ceba010mr578473f8f.24.1746226442792;
        Fri, 02 May 2025 15:54:02 -0700 (PDT)
Received: from precision.tendawifi.com ([138.121.131.123])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405905cfdfsm2149761b3a.123.2025.05.02.15.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 15:54:02 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: ematsumiya@suse.de,
	sfrench@samba.org,
	smfrench@gmail.com
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	paul@darkrain42.org,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 2/2] smb: cached_dir.c: rename smb2_close_cached_fid() to release_cached_dir()
Date: Fri,  2 May 2025 19:52:11 -0300
Message-ID: <20250502225213.330418-2-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250502225213.330418-1-henrique.carvalho@suse.com>
References: <20250502225213.330418-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_close_cached_fid() is a kref release callback.
Renaming it to release_cached_dir() makes its role immediately
obvious and aligns with the rest of the naming used in the file.

No functional change.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V1 -> V2: split into second patch and change only function private
to cached_dir.c to minimize the risk of backport failure

 fs/smb/client/cached_dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index fc19c26bb014..43228ec2424d 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -14,7 +14,7 @@
 
 static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
-static void smb2_close_cached_fid(struct kref *ref);
+static void release_cached_dir(struct kref *ref);
 static void cfids_laundromat_worker(struct work_struct *work);
 
 struct cached_dir_dentry {
@@ -420,7 +420,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 }
 
 static void
-smb2_close_cached_fid(struct kref *ref)
+release_cached_dir(struct kref *ref)
 __releases(&cfid->cfids->cfid_list_lock)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
@@ -478,7 +478,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 void close_cached_dir(struct cached_fid *cfid)
 {
 	kref_put_lock(&cfid->refcount, 
-		      smb2_close_cached_fid,
+		      release_cached_dir,
 		      &cfid->cfids->cfid_list_lock);
 }
 
-- 
2.47.0

