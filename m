Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C353D1DF963
	for <linux-cifs@vger.kernel.org>; Tue, 27 Jan 2026 16:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769529718; cv=none; b=YVsHGMZQpMSjxvZdrfbSZzMdDzN04jxIsLREg2qyxeOn9SAUUU39Bp5zdkYSORZaD/H0uGM/2t34Pn8c/IgtlArCxmyuYXYGa0wjGAvH8rpkSRaS6YymGJKzTDwxYDA9Cs4uMsHBAe+LeZCBM5qnWFeZ8pEWy6J/V71RwyJEsXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769529718; c=relaxed/simple;
	bh=aRNTtmrFXwwdWTzUJgx4njg+qH3SbOpxZOX4dCM0ONk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VdJsh8jY0TPDI5kRcgrlD30T/ZsBjQjJTG/RodUGlgCbnaGNnUM030LBqoXwNDsp6CIcoR37/640MTsezOgBJBON4T3dOfdsVwUmNglp7FiYrptBUQD4XNHif4dfzhD7XVY8aOu4CSyo5H4KNNY1e7y8QVW67U8bh4jejnFZQ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V6NWrQ30; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V6NWrQ30"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4805ef35864so21340885e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jan 2026 08:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769529715; x=1770134515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NZGd8/NahD7S+WRP+/5ujNkkhDXmmqtDAZ/rLlzezOY=;
        b=V6NWrQ309gQkvOzk/WvTp0CYOSbaAZfrTqe7gXFLvfkEyKfEwUaLwbGp5nXe/9mHMg
         vrQPUTOFLekh2UkPbaFqaltcBIAtskQLFQ5w1T3DIKCM/3rY8dAWH5pLgyWUiPQTNgJJ
         akWF8g0jsBXK9xbwe+/z51NlKyws73ihnsgrITINBL9+4qR56+xCAvnlMYy5O9mKidFG
         hRoo2ly0e26OW5cwK8oevLQCjuYwHuB4WKHEv0t5dGxvkQMPr4G1aDz13HzqD06uWNoW
         bqNCwlm022Kute4fx6RBIZ9wvks6cYwIEUIE/ldhdbqwsuzlUduM00Oinj+JJ2lw0ZCr
         xVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769529715; x=1770134515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NZGd8/NahD7S+WRP+/5ujNkkhDXmmqtDAZ/rLlzezOY=;
        b=Rq5EC25o+UEDb+qOZiJiDEsXtnKlP+LHphKPq+em+sR4+ZCsymg64wZAqJXsWGnnT0
         HCdwKqMuo9eI9oPKc3kUkehfxF+W3V2Fq/8lNFiOG759oN1ihznFL1FQLCCf9c2e4ZaS
         glnGAOJBLfMzew383KdPOKaojajP2iy72l/XS+xjUavS+X54Xi1djwwrNZHKgiroWJmb
         vgYPEJTgvj+EYYg4VumP/tGPMarlzl1a9ZFoF4ktYUAZRTFl8nvIz0MCvVfz85Th+xbr
         xI8tLfxaFpYRyw2vkpxScZ+0VJ6i34JVlyougOg1/zBRI5HkV9OrSjU+rLAeseVQmuDv
         nfzw==
X-Forwarded-Encrypted: i=1; AJvYcCUQAVMaGFc/zjehSjbk4KfDz8T93HG2rho3rTltTxZMpDIdXFt+3aOX0iilHRB43AZ6GXiFQWgULdN3@vger.kernel.org
X-Gm-Message-State: AOJu0YwhNwk2sk0p6ze884xplYNdTg6H2DLYKfR9BzMUcL6MAJJPmJHQ
	s2SNpwXWQEGTe061t82IU5zgI60566xgAzGGqH4cE7Ie3eQA7dwyjbQHswwTgUhP/2M=
X-Gm-Gg: AZuq6aJp56nk1xsvOZXTJG3SC3kY7DI+S2ixz7ZAimmf8jyyfInNuf50iDNJe0HLVJd
	gCdw+aO5o+mRN27g8NnElRlNQD9RQXqYttIowZpD4K0COlaRTHYGDW3+toPSevxUWpJXBWd5opf
	RkusgELXSSEzsvSZfx4Xak/uxkn4DG9WJ3pqDnQ1pWknnsqNfqD7KCT2pnF/LXApLMc0zMtAlL7
	bBN40MDsuMHntVmqOYav6uylzQD/LzKnxa6jCTHvCi1vPI1qDxo6ETLcnrF8QDfZbhWdWH/0QF+
	cxA8CD9LLDLJGUTzKvvK45TrA++E42Jou620I++CqTdkCS26x8WPthMl5jCXVwl43/LZf4WjevX
	hrnkqR36dUlyKARdNPqMZvQDrOHVZfmbdSZkRqSRTHTYlZV7cgEGhfDNb+8ppLLTpQQQsd3FjMA
	mig8ZYMrSGGYRbGrrW6noFSldtg0hskXF51S/aw1r6gWZf/6g=
X-Received: by 2002:a05:600c:8b03:b0:480:1f6b:d495 with SMTP id 5b1f17b1804b1-48069c5fb04mr27151185e9.32.1769529714991;
        Tue, 27 Jan 2026 08:01:54 -0800 (PST)
Received: from precision (189-69-94-41.dsl.telesp.net.br. [189.69.94.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73a9e1c52sm17470958eec.16.2026.01.27.08.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 08:01:54 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2] smb: client: split cached_fid bitfields to avoid shared-byte RMW races
Date: Tue, 27 Jan 2026 13:01:28 -0300
Message-ID: <20260127160128.243441-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

is_open, has_lease and on_list are stored in the same bitfield byte in
struct cached_fid but are updated in different code paths that may run
concurrently. Bitfield assignments generate byte read–modify–write
operations (e.g. `orb $mask, addr` on x86_64), so updating one flag can
restore stale values of the others.

A possible interleaving is:
    CPU1: load old byte (has_lease=1, on_list=1)
    CPU2: clear both flags (store 0)
    CPU1: RMW store (old | IS_OPEN) -> reintroduces cleared bits

To avoid this class of races, convert these flags to separate bool
fields.

Cc: stable@vger.kernel.org
Fixes: ebe98f1447bbc ("cifs: enable caching of directories for which a lease is held")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
v1 -> v2: Add Fixes: and Cc: stable tags

 fs/smb/client/cached_dir.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 1e383db7c3374..5091bf45345e8 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -36,10 +36,10 @@ struct cached_fid {
 	struct list_head entry;
 	struct cached_fids *cfids;
 	const char *path;
-	bool has_lease:1;
-	bool is_open:1;
-	bool on_list:1;
-	bool file_all_info_is_valid:1;
+	bool has_lease;
+	bool is_open;
+	bool on_list;
+	bool file_all_info_is_valid;
 	unsigned long time; /* jiffies of when lease was taken */
 	unsigned long last_access_time; /* jiffies of when last accessed */
 	struct kref refcount;
-- 
2.52.0

