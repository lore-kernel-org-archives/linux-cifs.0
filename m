Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CFE35A3B1
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 06:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790405463; cv=none; b=Q2ifcLnH+nwO+CMsCkRydh3W7bGHy4SiRl5b7Py2PjARl02ZyVe8BtiwAGwiAxrOQTSN3Vk3K5dNEzo6ppei4EhojPIhLzwXmfcABQnkRntKLAbzUvgYjU/a7ZLX/MigyyGzYXiQs6XRe3HkS782+Hh8GgmeDnsRIjzKIh4dI1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790405463; c=relaxed/simple;
	bh=JV+17s1GlPD3D2eJMRcu0HMLhAqdoXENHWYjZ9jS8EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pyg2GpbjG1fRVJWaC/IQZOic3nP2E+egxNSXda/dDswskkNYIWcqsHy4LZvJTCwcc0Wi6QVr12rJDWEIQ4Z1KhK9vRt3dw+1ex+VbApO0IU/P0Vq4GEd0x1l3GkQCz4OB0o9TUG8hmscSHhQ5M2vPNKkiQgMYGa8hOlmLWb+mKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=mpC6hBfH; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="mpC6hBfH"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so844445a91.3
        for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 23:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790405460; x=1791010260; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rxWlpEawRxbGdbb7uamGxHpnCZdOPTti2on2yW0rLRM=;
        b=mpC6hBfHoXLcLvr03Sj9oiz5ufxcJtyL5GSBzXBecfOE9kH+g9Q4011FYfJ8NPR/cz
         SzR9TTuajhs0lAZp/nSSymx4EUkVAIqPqX61+PIQ3Gc+3NWcJ/V1T+NjMmy2eOpCB218
         /fggIyQVgySPduwDcNpz9QmsDH5bfszbJHGLkWenTUJBv0y5AGSDW8trMnBu6r4C9r/g
         FziVGC4NIv1xIMiwhWHj4SoOGyLquek/xIlJOCjkUBlzVPAB+Y/bEWxTJpxXJbKbcPhM
         FyfU/HlgPIALpMTxKwQJbciLWPJq/DJyXnXPNUQybMPg0na7hoRKscVZUrMy52UPGkLS
         Ct+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790405460; x=1791010260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rxWlpEawRxbGdbb7uamGxHpnCZdOPTti2on2yW0rLRM=;
        b=e7j/I60YAa8vEa4JTKvEl6bC19Jq52ghlP1iZpZeniWVJoHmmx+x1fcw2XSB3dsLA8
         +ZSRnc+s0TUM1Hb5Qy+lG5SiDiLVKkBrmVytxGFidZKo4P0F8uTz5WQKZObDIPgtWshg
         Q8i4pn/WNGftVSGjusTkkp+39IOj6+3Qp+hHZmWSl38eVGZNXM7s8x0bOGl8rI8MmUkU
         vbgtanSy+jMAMQPn6QBkJ2PFNG6V1OMUurvwjpx7efgo8ERCSYxrNudlIy7AoHFbw309
         9GqBLcyY1SUBnRi3jSgWfotUScQ/OQ61mMHF0a0emurWVH25vjgRj4VpzjR+zkMsxGlc
         b8Zw==
X-Forwarded-Encrypted: i=1; AKwUvBx1IegMTiur9WhSINvqhlXV7DZAyYKutGP6lrbGqxEn/q5ZvweOQaAuLOo7nFY0ZfbP2gYPmG6bojSy@vger.kernel.org
X-Gm-Message-State: AFq9FYLykZNkA7ER4ldXeN0o22AFtqdqIWyGgoSFjWvBd7iOOnNzfsLG
	l0wPKJOFWJTlk6xTQpKkHXYZa60HfpzYp9UpbuLkOlDS4u4wuW8TEHS2rJxfLQCpAUHSXYTE4Mh
	hXptA6t9C
X-Gm-Gg: AYBFou3j4MJtuHgJoi1nC70g1LiqF0gHeE7nYOSPcd/Sz7xX+OmhoSxXdjuEX8cNHnA
	d0kqyjzP7LkN3/88b4S+Hc///B822lzzn+5VPFSLffoxULTUawf9rKPX1A3VoqXGlIc95//9Nt2
	4L3DccJtZvluA2wRmrn6TA2RM+OmUgym/GM5skHnEdaj7mFEXrS2N+/LpH7KK+t3Qs4CZgOBJxQ
	1+RNOeHUDBkGL0SPyohWMkt6lKz4HgI6y0MMMnp7BCmEFOUIFfj4o6iz5KaBp7JzqjDCeaINXzz
	HAwDv6QNE2Tl58WSrd+QQ0yBMUREv+pUCAf6aMXzEmbKZw8t6+ggK+W8BKuaQrNBDygbFR3RnGy
	Bal9TMIr19fNApSccbQDqwxXRp+nd3O1yRDisWT2VnNUMCBqEv4pHwAarzYHyHkQHPb8h6L6QxI
	NWUPMgwd5Eg2Yx1/hfxCUkdIYvtsEM7X5itXRsC73KAYJTRYC3X5yapk/optId2QFgLPOlYPSP0
	d+vRWIgauJclhoKMmPTRaF1xio7oQ==
X-Received: by 2002:a17:90b:224b:b0:39e:6a81:f34f with SMTP id 98e67ed59e1d1-3a098bb63femr6356045a91.41.1790405459792;
        Fri, 25 Sep 2026 23:50:59 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b498fb12sm3447327a91.0.2026.09.25.23.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 23:50:59 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: sfrench@samba.org
Cc: zihanx@nebusec.ai,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	pshilovsky@samba.org,
	aaptel@suse.com,
	pali@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v5 6/6] smb: client: preserve create-context parsing errors
Date: Sat, 26 Sep 2026 06:49:26 +0000
Message-ID: <e7071cc3388033276b5012ecd0407f29401d867b.1790398755.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1790398755.git.zihanx@nebusec.ai>
References: <cover.1790398755.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_compound_op() saves the result from compound_send_recv() in
tmp_rc. For SMB2_OP_OPEN_QUERY it then parses the CREATE contexts, but
the final assignment of rc from tmp_rc discards a parsing error. A
malformed create-context response can therefore be reported as
successful to smb2_query_path_info().

Keep a create-context parsing error in tmp_rc so it survives per-command
response processing and is returned to the caller.

Fixes: b07687edee99 ("cifs: Improve SMB2+ stat() to work also without FILE_READ_ATTRIBUTES")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v5:
  - Rerolled the series after fixing a NULL dereference reported by the
    kernel test robot Smatch analysis in patch 5:
    https://lore.kernel.org/r/202609241449.HlHmnZFZ-lkp@intel.com/
  - v4 Link: https://lore.kernel.org/all/cover.1789478666.git.zihanx@nebusec.ai/
changes in v4:
  - Keep a create-context parsing error in tmp_rc while processing later
    compound responses.
  - v3 Link: https://lore.kernel.org/all/cover.1788516372.git.zihanx@nebusec.ai/
changes in v3:
  - No counterpart; this patch is added in the v4 reroll.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
changes in v2:
  - No counterpart in v2.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/

---
 fs/smb/client/smb2inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 6971496dfe8c2..cedad9daeb220 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -582,8 +582,10 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		/* smb2_parse_contexts() fills idata->fi.IndexNumber */
 		rc = smb2_parse_contexts(server, &rsp_iov[0], &oparms->fid->epoch,
 					 oparms->fid->lease_key, &oplock, &idata->fi, NULL);
-		if (rc)
+		if (rc) {
 			cifs_dbg(VFS, "rc: %d parsing context of compound op\n", rc);
+			tmp_rc = rc;
+		}
 	}
 
 	for (i = 0; i < num_cmds; i++) {
-- 
2.43.0

