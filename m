Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762A8448CF9
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 17:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517999; cv=none; b=Z7e8Uc1YG9d/oQVVCfaF6PSG5LQNYTo2ytovkzzogq4ZjLPTQASb7PugRU3hX9ui3PYoKafwCBaZjy6GQwx3v9u+wTICGLC3tp+Zf9TB/pKJvRtM0A0wFt3qckJ0BijdGVAmWHJr47cmAXYCY0zJD76LxTmwuEbEYlmMCSN2sm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517999; c=relaxed/simple;
	bh=6lbmqocsMKN3XO79Tz/hx2TslmNVKUuJ2uV/wnIMDP0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=EYDmdphJBI6FWIOQ4gmenau62BetHMArOF5C+MXDQgjbTElmoxmcbJATiWixOm+22r1wplDUshm4dLgAcUfkJ2NaIhDWbtipQlG+eB9vPosfVsZoR+StRVUyh2PUFI18USftP+QuJnupshnotFfg2+1gFqdlWOveOB8Ugjj2Zas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ckd9oYAe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rZHKkyT4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ckd9oYAe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rZHKkyT4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785517997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aJHqzRxmIUvYDAUtSyG73o0CSN46mCfrvkOUPJKfDXg=;
	b=Ckd9oYAeV8KFU0cWa3SOcQllkKcsV0s6HTpib/njLLKVCWBi5+ZkkBm8I4hPIxLFsR/lmA
	eFMnrix1vLcvH4UQKCLziRUrfr15qAPoeo74urf14Te/k9PLBNjPKBuwiKLedAHjIfe3D1
	SMiAckin/BLutphRt5zPDtP73ffBwg8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-AsZB6laGNF6xZ3gKf25Fqg-1; Fri, 31 Jul 2026 13:13:13 -0400
X-MC-Unique: AsZB6laGNF6xZ3gKf25Fqg-1
X-Mimecast-MFC-AGG-ID: AsZB6laGNF6xZ3gKf25Fqg_1785517993
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c21c01cf3so20432011cf.2
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 10:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785517993; x=1786122793; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aJHqzRxmIUvYDAUtSyG73o0CSN46mCfrvkOUPJKfDXg=;
        b=rZHKkyT4JxqMkm81m3+A/wAnFceTXp+UE6/s8vfLYuSDdMX0IeOzOqEOcH6Jhwm92+
         8BGKxy3PiOQBOsKJe792aeOqRSdyxLQO88CyAbLbQbnej0npLrFOhpPH4oko2PosFzi6
         npqEwT5+1q9t1h/JtAf1skEq4XYEpTns0wJDuXk5PzSw9Q27PAFdj2QlG3A3qFbEr5zI
         JGXcuMPvkP9njydb57sC6XxMZYDPQQpQutgLvu8v3QfK5GjDXJxUNEn2dRSHtG9wrwyq
         rUscGq8kl+8Rs2p8ufbE0fRLsTP9LfWv0mogxQ35AkIAbKgnfCs8TVTowqjb7TtF0y2Y
         R8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517993; x=1786122793;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aJHqzRxmIUvYDAUtSyG73o0CSN46mCfrvkOUPJKfDXg=;
        b=fwPcO0qH9ejbllJ0FouB7AsOh11cuCCyzJCR9yOPTPuYYbrzTVvkSPX6PiR5uyYDKt
         KaETvqU2g2G3DhmF6nv2mJmqiIm3urjeNEUE954XkLN0KONBa/lShoe4dnpsfg8G+key
         qx7o910lr0N8m726b2sYF5KO/Fm2se9jsvvN2eAqmYm0loqh2y+XhYjWK+uz60TB76ye
         jy3GCvBatioMAcU+hid+iuNBu8vCZIthChN97Ttvb7wYA2two1BwjBA/7mXjpIJ6W7ez
         ZMbJCygMZr4oIpawFrLczSOQHvsow4ZbSAtRMPKfiYtQ0XA50MwGFvpuNZNYhPbWeAez
         /tJQ==
X-Gm-Message-State: AOJu0YyDysoErJcLnNzb09SSLgm+2Y5zP1WmLjUkMSTIqrOn0+rOntuG
	MDH9vFxmO/O2RqkXJGlZ0bFb5IlbubihxH2Njn48INKzZCw1ByQ61AmF1tg8Bl/trOsXwwRiGp0
	LGrIdQJr+VyhaU8QOUAv84kQx+713Z9wupaq/XC7vc2M5J64ZGqpm8b0RdSEmuIDVKpxbkDh0uj
	7FEgI9xLQI+6wSWnfkZK6TuW8If/QZniukDELALNM/Dbk2Ruk=
X-Gm-Gg: AR+sD13aO6oUTI2x/cFw/zRG7rKNsX049+jDz6VZN7UKDA/0ULa9W0kl/2XCXENDfWS
	xwFBbDDGocl6dXSnwSE+lpPZX29vUYpA/g51DxXx8ZY+Ywob8uX5cVhWqZC/IiolljIUOMadR2Z
	3x38G+peVR5jFLjHoZcCU0Jb/tZ4PZKQ6MBRsKRLiyIXLXB/O1lfGopB4ugT1DxmS3YZUe3Bpb+
	M16/PO3YeesJUav2xXrmobuvWQRf0KNX84OngERvAkSbL1nSeuGc5CatdiybmPZyLls7zwnusUy
	utXTZUQOMc+LusVKiH3XAq1mQs0HVkXuo/RD7xxECDc4RY+UhC0YHcWx2VVv1zwGLPLQXKI3xiu
	Ur1w8157CkgH6TYZaanoCcTxN9qQLOvaEG4qPzDlfJFU4t95f9HhWcTVuQro7
X-Received: by 2002:a05:622a:1cca:b0:528:3b5a:67c2 with SMTP id d75a77b69052e-52b5666d931mr21098591cf.1.1785517993092;
        Fri, 31 Jul 2026 10:13:13 -0700 (PDT)
X-Received: by 2002:a05:622a:1cca:b0:528:3b5a:67c2 with SMTP id d75a77b69052e-52b5666d931mr21097721cf.1.1785517992458;
        Fri, 31 Jul 2026 10:13:12 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908434a250csm14676316d6.13.2026.07.31.10.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 10:13:03 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com,
	hehuiwen@kylinos.cn
Subject: [PATCH v3 0/4] cifs: follow-on fixes after fscache_resize_cookie() consolidation
Date: Fri, 31 Jul 2026 12:12:27 -0500
Message-ID: <20260731171231.686427-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit fa724e235cfd ("cifs: add fscache_resize_cookie() to
cifs_setsize()") consolidated fscache cookie resizing into cifs_setsize(),
two further fixes are needed and two dead-code blocks became removable.

Patch 1 fixes cifs_do_truncate() (O_TRUNC via cifs_open()).  That path
runs without i_rwsem, so it cannot use the locked resize path.
cifs_invalidate_cache() is the correct alternative: it works without the
lock and ensures stale cached data is not served once the cookie is later
activated.

Patch 2 addresses a race identified during review: cifs_setsize() calls
fscache_resize_cookie() without i_rwsem, but another concurrent open may
already have the cookie active (IS_CACHING set), making fscache_resize_cookie()
a real operation requiring the lock.  The fix strips fscache_resize_cookie()
from cifs_setsize() and introduces cifs_resize_file_locked(), which
temporarily activates the cookie with fscache_use_cookie(), performs the
resize under i_rwsem, then deactivates it.  Callers that already hold
i_rwsem (cifs_file_set_size, smb2_duplicate_extents, smb3_simple_falloc)
switch to the wrapper; cifs_do_truncate() continues to use cifs_setsize()
followed by cifs_invalidate_cache() as established in patch 1.

Patches 3 and 4 remove dead code.  Patch 3 removes a caller-side
truncate_setsize() + fscache_resize_cookie() block from
cifs_remap_file_range() that became redundant once smb2_duplicate_extents()
started performing the full size update via cifs_setsize() under the
i_rwsem held by lock_two_nondirectories().  Patch 4 removes equivalent
dead blocks from cifs_setattr_unix() and cifs_setattr_nounix(): since
cifs_file_set_size() calls cifs_setsize() on success, i_size always equals
attrs->ia_size on the success path, making the subsequent size-inequality
blocks unreachable.

v3: Fixed broken patch
v2:
  - Added patch 2 (cifs_resize_file_locked): based on review feedback
    (Huiwen He) that the fscache cookie is not guaranteed to be quiescent
    in cifs_do_truncate() - another concurrent open may already have it
    active.  The fix strips fscache_resize_cookie() from cifs_setsize() and
    adds a locked wrapper for callers that hold i_rwsem.
  - Patch 1 commit message updated: the original rationale (cookie is
    always quiescent in cifs_do_truncate) was incorrect; the correct reason
    is that i_rwsem cannot be held in that path.
  - Patches 2-3 from v1 renumbered to 3-4 to place fixes before cleanups.
  - Patches 3-4: add Reviewed-by from Huiwen He; otherwise unchanged from v1.
  - All patches: add Reviewed-by from Paulo Alcantara.

Frank Sorenson (4):
  cifs: use cifs_invalidate_cache() in cifs_do_truncate() for O_TRUNC
  cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie()
    under i_rwsem
  cifs: remove redundant size-update block in cifs_remap_file_range()
  cifs: remove dead size-update blocks in cifs_setattr_unix/nounix

 fs/smb/client/cifsfs.c  |  6 +-----
 fs/smb/client/cifsfs.h  |  1 +
 fs/smb/client/file.c    |  1 +
 fs/smb/client/inode.c   | 41 ++++++++++++++++++++++-------------------
 fs/smb/client/smb2ops.c |  9 +++------
 5 files changed, 28 insertions(+), 30 deletions(-)

-- 
2.55.0

