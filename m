Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A380649F116
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 12:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788353549; cv=none; b=t22Wn6G+3KlZpllAq7eYoR/vrH9+KppC3LvZ5eh44B0RiLirJ7YIn0X88rlP8QQwUXzdDC9mDVnd4BhZCEN7KoYhML5rfWcZaHzmNeOU7mZWS9BmPjmLCZRqQVEiqf785G2NfvMI1l7yzEe5bLo6uACf58Mdot4T4TGaxILGRNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788353549; c=relaxed/simple;
	bh=tI3rVoJWW5Y/q2jj7nEVvV+2mIlTZ1Y6Mz75ZeDzwUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hz1f1w333IfYyFzUDYBqPheJv2zfDH9w+FCBPwnCsyMcp2YImwNcGJZx6ZYGxQN016KlKA9uy8v/DjI0hGWoF68OCDLNs7o9o2IW/fGzFpyjGzkGTFj01Uks1QvnhFeOCkNR4W0ar/ovW8Q2vuIuI8lYQ/py+Wa4qsgp5b7nooE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1akQW0j; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1akQW0j"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-854f8068301so608160b3a.0
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 05:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788353547; x=1788958347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vmkiwz6phO9IootCvbhHu4vPBafMAzZ/9jFbgheGL9c=;
        b=F1akQW0j0e+rYbXXUOPh2F5SDRYNsmgKwG7q4PAj1XLlpti41qnQcL+qcetOr+dXf+
         rqpLfhZL5O+zR7zuyZvl37iith/eaMx+jtVTzAMlwQmRLVl8VJgLzKcqd40Nqp5lXZvW
         oJfy+VqmzC+ybaC6dNxNsnu3gGdQlAPO4A2HjjHe2JHBb0D7y01a4nrf1gThIupVNeyg
         Di+n2fTq258vxqw59zpe7VSk21riPvrGCpwGhc8khPN1VvYIVKAuk5TT/2hk0jIvvQgw
         Dqf1KD0wcAKj5edEF8kf2effOvk+zN7fImr2s8JW8MlUJREijo2dJ/PiSP4awz3k1xRo
         0CFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788353547; x=1788958347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vmkiwz6phO9IootCvbhHu4vPBafMAzZ/9jFbgheGL9c=;
        b=bRi601vBhTVxH5F/bGeQOS5ZK7TTZWaBzV7BcHpgWlF8GgM+gDCaXs9liq2Vj0ihx2
         andzyWdUfU3UqFHS1rAq6T8b7s3oCq30uwFTByuNHwIreLpLWH+4XPcmoptk3IeBvcCK
         ktlNXz9d0kQsLwMlvj+RAIqqB0YzFy3XKtbSI+05sGFJWOeqYlnaz2CRRX6CNlMWll6+
         9YTYueSCgc8fhgMaicAt27weMkNlOAomEnd3S3xkL7SwIW/mtuElmS4Qi/2SRZssNhGA
         3nfp4IOb/ZOrHQe8awi8ICrtWc4i1V3IYLxoxm4T000bXFSKe9g0VT0AOn2nNbq/bKmy
         Jfig==
X-Forwarded-Encrypted: i=1; AKwUvBzriDBIaWo887U3yi80KDy7egzDd5SrLlSrqkOLz7eLyC4OxRqucF99th46xJ7hymRYtR9VXj8PCL9I@vger.kernel.org
X-Gm-Message-State: AFuF++koxjyjnjukdrMl7UKhZC4Znki4gKSxUfbpCLq3fZLdqpvx0sU1
	jjOM67jyhgvQeACZHvoEQHWqPTuUgwe0wN/Vas8YjOHnKMUWLw6r+Fkz
X-Gm-Gg: AYBFou1zWA2gx/POHAuNZQyTCaOXqoXWnhepPaRIMMaXHqExQjek7Vq5SLUS6pBpn2/
	GMvL2FzIi2bC8r2Zb9k8SGNgja7XIDG2j24Vs4/K+rE2TPqIlYBf4d2Ouz4Dhb6OWHPbE2i18fp
	ye2UXA5Z4k1KqPfGv+SBriGUx/ixMTzzyR6DxLWaPXm62LzwB2bn05bGha1xI5hgvaEGVeiPZd8
	mgAy1akXih1FKe3w7jQ7ElQuvpFF/pFolo4sTwbin/6B9yQoSzDlEVyo+ZlUpVMKfpRQMycascL
	VoFiwCFbFGL3xOmEKpoPplEoigxkcw/cZrGOz1Po3MlsJm4HoGBvJ/Ll83nAPH7bATCet7FX01n
	oIqVHEwoYGZWB8LRpxeE4g9s+EyE9dwMDXe29CJ9IyHvU2QYX6wQhSE755J7ggXNVVrdX+aWvCc
	k6W06Xy0W4mD26tRH3MurhLlazua95VvRZc5my1SQNNHjjUooj456SByAI3T/QZUh0jYQWpN0hY
	Fasfzy9VpiwGMvuo5Qt8do=
X-Received: by 2002:a05:6a00:2183:b0:857:727c:a1f5 with SMTP id d2e1a72fcca58-85ed4640011mr6382696b3a.23.1788353546711;
        Wed, 02 Sep 2026 05:52:26 -0700 (PDT)
Received: from localhost.localdomain ([180.101.244.66])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85dc11fae5bsm1299104b3a.61.2026.09.02.05.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 05:52:26 -0700 (PDT)
From: henrymei <ljp1205831794@gmail.com>
X-Google-Original-From: henrymei <henrymei@tencent.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: reject userspace cifs.idmap descriptions
Date: Wed,  2 Sep 2026 20:52:13 +0800
Message-ID: <20260902125217.3951486-1-henrymei@tencent.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aohan Mei <henrymei@tencent.com>

cifs.idmap key descriptions carry authority-bearing fields (owner and
group SIDs and uid/gid values in "os:"/"gs:"/"oi:"/"gi:" form) that the
cifs.idmap upcall helper treats as kernel-originating inputs.  Unlike
its sibling cifs.spnego, the cifs.idmap key type has no vet_description
hook, so userspace can create keys of this type through
request_key(2)/add_key(2) and supply those fields without CIFS origin.
A request_key(2) call with a non-NULL callout then drives a root
usermodehelper upcall (/sbin/request-key -> cifs.idmap) that consumes
the unvetted description in root context.

Only accept cifs.idmap descriptions while CIFS is using its private
root_cred to request the key.  id_to_sid()/sid_to_id() already run
under override_creds(root_cred), so the kernel-originated path is
unaffected.

This mirrors commit 3da1fdf4efbc ("smb: client: reject userspace
cifs.spnego descriptions"), which applied the same restriction to
cifs.spnego.

Fixes: 4d79dba0e007 ("cifs: Add idmap key and related data structures and functions (try #17 repost)")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
---
 fs/smb/client/cifsacl.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 12005f46307d..213a421bf8e9 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -100,8 +100,23 @@ cifs_idmap_key_destroy(struct key *key)
 		kfree(key->payload.data[0]);
 }
 
+static int
+cifs_idmap_key_vet_description(const char *description)
+{
+	/*
+	 * cifs.idmap descriptions are authority-bearing inputs to the
+	 * cifs.idmap upcall helper.  Only allow the kernel to create this
+	 * type of key using the private root_cred installed in
+	 * init_cifs_idmap; reject userspace request_key(2)/add_key(2).
+	 */
+	if (current_cred() != root_cred)
+		return -EPERM;
+	return 0;
+}
+
 static struct key_type cifs_idmap_key_type = {
 	.name        = "cifs.idmap",
+	.vet_description = cifs_idmap_key_vet_description,
 	.instantiate = cifs_idmap_key_instantiate,
 	.destroy     = cifs_idmap_key_destroy,
 	.describe    = user_describe,
-- 
2.43.7

