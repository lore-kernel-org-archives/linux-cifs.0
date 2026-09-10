Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC65318EF6
	for <linux-cifs@vger.kernel.org>; Thu, 10 Sep 2026 05:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789017467; cv=none; b=NndrGCecyPXwhY+LS3RVVFcpwEDlPeR+/QbwK7A4VzfbPZCa8mOSvXsaafO7oqvDBEmobzlHae9Ntf/BMKFj+sF7ma0IKf7q7rm285dJYhZV6Q1uvOxPg8MP0Y/ueR+OYD0Zl7Lp977e7eoSrpac76XQoAyUjO9+URUcb135qFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789017467; c=relaxed/simple;
	bh=+uttU9LoNQl5UcNsiobpMhUgBKqCGf0qXMslcE3NoOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dFBdHSA50+GCZBZD/+DMVh5UpF2cRDN1VFN8Q6OtxL3MLwPi0RkIJ73Kid1eiMUxOKBXxbxIxkv07kPje6KnOqp06YxFBqNHiiRUuGmM33xQgnT+FhyJjP7FkCwXN5EXaUGJuzKxQI8zDuxosOiZ47MJbdMXlR5TWHUbe6YDMt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=L5a43ra3; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="L5a43ra3"
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com [74.125.224.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id CC4B53FCF4
	for <linux-cifs@vger.kernel.org>; Thu, 10 Sep 2026 05:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1789017455;
	bh=lnp4DkMY9rmqEKCqdg1i483FpRZlyfK5ov9pABziNG4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=L5a43ra3Q1NBdNjr/53rcCuKnVezL8f9Z+32FhxiecSRKZ/9MFHpeQC237GilLQkr
	 /yyUCu79GXfNwfDYHWnIIf+FUlr951YEvib0mbf7MDvc0mzMzQ8o9RuQ+umq453+qI
	 UIZtqVH2V/eC8EvlQuMWpg9vzAsnk5b3PpmKiVcfrSbGKgHvnXHty9MFEDiEUv1bzY
	 9t8hVkiGyCaG+PFBocG/7QQ4gXvDeLUFHN4SsJMQadBw/rDnsY/vkqDqcPiQXquoJL
	 BbXOmPEz93BJihf6UYNqnnan14JjEsnsJNqnvjvaKue3YRxT2M3vLE5LxTnn6uY/m/
	 T75H64Km860TPApa80M+lMeo25VseusavKnCo88F76EPDfyU7kLoK1LGGBUZw+pzAG
	 oZdxbuuc8BcrjVB8PAdBmtRoCJOshvJYcTrnWVqjHmbiIjn5kS7d2iLOD7QV8mjmJK
	 PabeuCNxl+cbdzPSX0BSTSFAsfTfvMJv7ycOkxyiS0ir6Cf+3Hb4lR5KWvmEW2gG7j
	 NPwyzSaLbnKzPtgNYsY4Fl3Rxjryskm4jZcgvFnrelNGt7wYGJHsaqZUURno/Ejv4E
	 kUegXJbxPK49P2r9CBVKeMvUSqwTuNvJ7UZWDtpUKAIJSJ/j01iUoMGgP1z1xTqPRP
	 4yxgNcTpV7IqjEQyauyK172g=
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-66cdb701595so8768629d50.1
        for <linux-cifs@vger.kernel.org>; Wed, 09 Sep 2026 22:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789017455; x=1789622255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lnp4DkMY9rmqEKCqdg1i483FpRZlyfK5ov9pABziNG4=;
        b=Out4e49VWoQFPd5QNKmc133ZkSJuHMQ64R8kGaG5caSHGc/z34GLltsRZjt1uSJXap
         3W8SdTbtA77x/FYbrxuo42fbO1+mAjE4sXvtBqZRUXIQJfq7TZYxr9Ac2yUkPl9vUlzp
         N8Sy+1M4xH7oX9PNQJTP56XSO4uRv4MH8r2+gVyXxMfRGTMVTXcj4Grt5vvjwIu/Q4hS
         TlHw/77Q17vhuWbHaGU/rHAiXLH63LoOPDUwefy4N7dC7BqE2kDyJmzercgA3KjkfPg0
         tmwAMpzw0bwLiVE+RBpkhYaINFMV3NiW2wvWmS+Mx/eHEsF09mdJ9PVMlrTtmTjNMpKI
         bYKQ==
X-Gm-Message-State: AFuF++mYTA8JpVB/fbD8fAiUWF8NoaZiIdHaMnaxtM1fsb1SDDdvDlvz
	Oz3llMDZmS+H3SgdnwVJ+HugZ42ue16PS/Qecs/aHgWtqMMELITdA88pwwGHupc3mHnAveZFYyW
	vnfzvjaKiAqWVxCWCaQHQ+qTMNtLAkwwcaWacJbbFOLgqaKFy/wCeCe+tfrO4L1N+fmW/3yQmml
	dZVWKcwvvz4/ld9A==
X-Gm-Gg: AYBFou1mjnHtCWUleh6A3LoTB6aDfFZBxC8nvD9qWw5jirq1NoqVtSHtqyCrxSpiU98
	iOxnPsdW8KEie9gm9AXLjmPiHpTFFSKYQ44u8pfRVdnV9gVPCg5F+EYEpqYztBdIblGIHHX1CBd
	9du0w76GwR8Wu7gU/DQi7/IJ7x6A+NNO1UDzXVwcPA0XfJ6Wz642376g24ZhwudcIHLcaF4eA6h
	hR/Z4lv0IZ1daEc2q4r9nVxYGV01A//m3eeRu7pWhLXv1+FRKg+pkrSzyR77i0olIGVMqbO7Nd6
	zyBpfLrxYTo3jiBN5jE/HLrShSi9cf4MCXXELGPOrVDflo996skeO59sKibWPy5gyiZ84Fia0yw
	Zlm5dGm2UvQoLWwbyD+t4omSqnGjTddsTNNRDWqT75yA11q2sGGY3YVbkrSizYHZntCiVMp0are
	TBGS/Fj92ZKXJKgTWDj/Litn00bg==
X-Received: by 2002:a05:690e:4381:b0:66f:c1be:84d1 with SMTP id 956f58d0204a3-66fc1be86e7mr8345894d50.63.1789017454687;
        Wed, 09 Sep 2026 22:17:34 -0700 (PDT)
X-Received: by 2002:a05:690e:4381:b0:66f:c1be:84d1 with SMTP id 956f58d0204a3-66fc1be86e7mr8345887d50.63.1789017454357;
        Wed, 09 Sep 2026 22:17:34 -0700 (PDT)
Received: from april-canonical.lan (24-148-58-139.s4745.c3-0.lem-ubr1.chi-lem.il.cable.rcncustomer.com. [24.148.58.139])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb49763bfsm13441030d50.19.2026.09.09.22.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 22:17:33 -0700 (PDT)
From: April Cardenas <april.cardenas@canonical.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	April Cardenas <april.cardenas@canonical.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb/client: send lease break ACKs thru correct session for multiuser mounts
Date: Thu, 10 Sep 2026 00:16:49 -0500
Message-ID: <20260910051649.3806214-1-april.cardenas@canonical.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when cifs_oplock_break handles a break request from the server
it searches for the appropriate tlink to handle the request
but incorrectly uses the current fsuid as the search key, eventually
causing read errors for users with multiuser mounts on NetApp.
Fix this by using the tlink from the cfile struct instead to respond
through the correct session.

As breaks are handled in a worker thread, the current fsuid
isn't guaranteed to match the session that the break is intended for.
This means that cifs_sb_tlink may search the rbtree using the wrong fsuid,
and return a tlink with an incorrect session than 
the lease break was intended for. As a result, the breaks 
may be ACKed through an incorrect session.

While it seems that Samba/Windows Servers 2016-2025 ignore this as long as 
the lease key is correct, we ran into a case where if you're using 
NetApp ONTAP or Azure NetApp Files they will reject the ACK 
and return `STATUS_LOCK_NOT_GRANTED` errors on any future read requests
a user may initiate through their still held open file handle, 
and the server will eventually close the file.

In the dmesg logs, the user may see errors like these:

CIFS: Status code returned 0xc0000128 STATUS_FILE_CLOSED
CIFS: VFS: Send error in read = -9

With a multiuser mount using NetApp, this issue is really easy 
for users to hit on a wide variety of kernel versions 
by attempting to copy a file from the share 
to the local machine through GNOME Files/Nautilus.
This copy will always result in Nautilus throwing 
a `Bad File Descriptor` error to the user and fail.
With this fix, you can copy files through Nautilus without issue.

From looking at the traces, it seems that glib will 
open the file first, and call listxattr before actually attempting 
to copy the file data. The listxattr call always triggers a break,
causing the copy to fail.

The proposed fix returns to the way the client grabbed the tlink before 
commit e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break").

The bulk of that commit (checking for list empty) remains untouched, and
I think the change to using cifs_sb_tlink was intended to avoid a
NULL/ERR deference on the tlink as well as update the reference count.

I believe this fix should preserve those safety properties, but of course
I'd appreciate any corrections here.

Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
Cc: stable@vger.kernel.org
Signed-off-by: April Cardenas <april.cardenas@canonical.com>
---
 fs/smb/client/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1aa4844f8b8a..0d428517f454 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3354,8 +3354,8 @@ void cifs_oplock_break(struct work_struct *work)
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink)) {
+	tlink = cifs_get_tlink(cfile->tlink);
+	if (IS_ERR_OR_NULL(tlink)) {
 		/* drop the reference taken when the break was queued */
 		_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 		goto out;

base-commit: cb26524ef4ac28fcfa554c0656e8dc412c38a8ff
-- 
2.53.0

