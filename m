Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745D837755D
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 07:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607130; cv=none; b=pWj8gnLsMXjRPlLx5CPLODw6JEuBTDp8IyaTY1dmOW/r3m/LJNyHGDAe2L75jmrzhsCBG4PR40wGgPe/ydUexCE/qEVRZ3DtYXOIr5Y0u91k8koj9rNSwG3jneJvOZCNTJJbzpRm+f8p9BrGkpqXdqmOjDJckm6RyVTqFnyHodk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607130; c=relaxed/simple;
	bh=CZ/7PoVdvaOK9lQitiXRsiEv5bEd75+It/qPwprmSpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYXpAGx0ktjdh2r4P+MSwHvLtkEuaehZ0cHITIOrZI2Y0IA41Q4sZU2G8ciiuvydrzDxFT2D1hReKKEFs8hKUMmfwSvm0W3jLYJIaPVKJzJBJKAXLugG1kfVsTbMBC2l6WQK6swNuq65f18pwB96wxd6pNTY7QQxtABExvKVKoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VkzXG3nb; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VkzXG3nb"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so1428595a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 00:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607128; x=1787211928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MT3Q/qLYuwioohnzErhi7X2vaCnV2zpJGa9m05yP8hk=;
        b=VkzXG3nbYXsuVmvs4vH80pBp/m8mK+WLnlh8QaSynXrf9CEq46EJfYm+IFkdxVCH8M
         US5kiCE+jKGCblVia30PhHGptHz8miAJPdUpjM53AlQfEAzTb7v5gu/Vvvdpwj8vVpew
         JBURvPrBGnMvGmN974AydvEg4sCFYg2IOyd11xJve0hnti2+WvwtlQJr0hTb/pNF6nvD
         nwgFL/kX1Jl2Pdd25/AvY402hMzGWyWxTwPcfwTJGG392x2F7u85zFEWwga+DrWePpsh
         yanA83FJCi6KPFCpEtfTDVsfXgqBZF4i4L1wsPfF/Rvl+ZFoog1O6wqgeV2msy9fflvl
         XbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607128; x=1787211928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MT3Q/qLYuwioohnzErhi7X2vaCnV2zpJGa9m05yP8hk=;
        b=TTts3miSWn1d5UBOPUvg+sgjBgpZA/Dg4vzxFV5o88v1n4um9NVeCPUUMKogtJnNTA
         5D7gtHmKsoTLco3RiNS7ET+CJRSLnv6G7FDMdbQ9tAcSgHDeJpU6VAgse9d/ukyiX3CL
         i/JdRCrzr/fm86kXbmNcU8kP4AwmFy+6wF+UZvVHuO72FAugpbXU273HNt3pVpxU2ORB
         3GeOFbl86i5YxbapLrybNh3QHbPQdOANMHHkeojYtrJ+wUJ7SYqMBbVrC3PreHGiHm3d
         +ijhuuxbIdj6PHJMG2M3+SgG17ynYBBYU6WZ1ywLVMs6Q8HMlQVBhyfLMlrZcgpkeL5x
         V55A==
X-Forwarded-Encrypted: i=1; AHgh+Rp2eX9EkOBDRzpbbgACcs/MWL8GYOqwMCTfEfSxIYpNErkl8Sgeo3W4IiwB1xvkezOlZo+QTcrfMFSU@vger.kernel.org
X-Gm-Message-State: AOJu0YyR9cM8I7KXa9O49MscFVgNdTLX06tIggTqSZ3yXGDDZcFhbgsE
	TjzXjHpruNVedhs/kArf5USUIZJCzz5dIz5g0Ic2Oqe9Hcgv4zFbEBT6Ilb4Nw==
X-Gm-Gg: AR+sD11GLg40TJszP1p0ddibOWTSH9jMwFVloHcTOC99Gzf6FGjS+G7i+EWM4X+FDZd
	DGropVZP+rjsC6VhDIIF/PFMLBFhTRDwmYPj3TnPanpegueHv3yq1dwB2RKxrjmem/NiIRoKs9I
	L/mqw971f6yx2DJLiS1eXFvlyisuvpmHdWst++8U8kokdP+ae/WB810fTj01wantk80cbcrz0cd
	lspZKyQLLAypl3St1J4RjpsLoN2PqP2LxKz/OodCKoMHZHgl0ZGNTpNx/GW417sFFdYTZv7NHJH
	H7X5gHAwKi3kuqWQYq/8jVQg3P51w06ShxXRqcTwS5EXtitJoNTG2h/cBrd67FPcpeDC0slkt6c
	Uxsq25GMmWYaPG5Eu3G11rKoRTZyTffyU+KGNSX21dJvmNQTdaBWcYn55uOjhmWR+CyBE0J8j1l
	kVOfeiEGnH12fgN6EGLM+9hRXxspzOC+4M6lsEQOpgigCEWr8AS/nersbPAVxBuuMxXdn+hphox
	nRFdsclzzoy8fBihe1KShu488ZNdnjKoY3k0glv9wq33F90cQObtXui9yKpEtEoNhdAsK36nY07
	3TODF0Stq/vs+LPD
X-Received: by 2002:a17:90b:384d:b0:382:1a6f:ba3b with SMTP id 98e67ed59e1d1-3931e023f57mr4652628a91.5.1786607127369;
        Thu, 13 Aug 2026 00:45:27 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ec022acabsm4587594eec.27.2026.08.13.00.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:45:26 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 2/7] smb: client: block non-reconfigurable option changes on remount
Date: Thu, 13 Aug 2026 07:45:12 +0000
Message-ID: <20260813074517.607275-3-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813074517.607275-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Several mount options (seal, sign, vers, ip, rdma, nosharesock,
persistent/resilient handles, etc.) require tearing down the
connection to take effect, but smb3_verify_reconfigure_ctx() does
not reject them.  A remount that changes any of these silently
ignores the new value, confusing users.

Now that smb3_init_fs_context() duplicates the live context (with
runtime state synced in) on reconfigure, simple != checks in
smb3_verify_reconfigure_ctx() are sound -- a difference between
new_ctx and old_ctx represents a real, intentional change by the
user rather than a spurious mismatch against init defaults.

Add comprehensive checks for connection-tied options with clear
error messages so the user sees why the remount failed.  The
server-shared options this rejects (noblocksnd, tcpnodelay,
max_credits, min_enc_offload, echo_interval, ...) are compared
against a baseline that the previous patch synced from the live
server, so a bare remount that merely replays the values already
shown in /proc/mounts is accepted; only a genuine change is rejected.

Not addressed here: 'port'.  When a share is mounted without an
explicit port, old_ctx->port stays 0 even though the connection uses
445, so an explicit 'mount -o remount,port=445' is rejected.  This is
not reachable through tooling -- port is not printed by
cifs_show_options(), so 'mount -a'/libmount never replays it -- and a
clean fix collides with the port==0 "use default" sentinel; the only
effect is that a user who redundantly re-specifies the active default
port on remount gets -EINVAL with a clear message.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/fs_context.c | 141 +++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 1a68ae058166..d81bdc875580 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1110,6 +1110,147 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change nbsessinit during remount\n");
 		return -EINVAL;
 	}
+	if (new_ctx->compress != old_ctx->compress) {
+		cifs_errorf(fc, "can not change compress during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->noblocksnd != old_ctx->noblocksnd) {
+		cifs_errorf(fc, "can not change noblocksend during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->noautotune != old_ctx->noautotune) {
+		cifs_errorf(fc, "can not change noautotune during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->no_sparse != old_ctx->no_sparse) {
+		cifs_errorf(fc, "can not change nosparse during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->nodelete != old_ctx->nodelete) {
+		cifs_errorf(fc, "can not change nodelete during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->cruid_specified &&
+	    !uid_eq(new_ctx->cred_uid, old_ctx->cred_uid)) {
+		cifs_errorf(fc, "can not change cruid during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->port != old_ctx->port) {
+		cifs_errorf(fc, "can not change port during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->min_offload != old_ctx->min_offload) {
+		cifs_errorf(fc, "can not change min_enc_offload during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->echo_interval != old_ctx->echo_interval) {
+		cifs_errorf(fc, "can not change echo_interval during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->snapshot_time != old_ctx->snapshot_time) {
+		cifs_errorf(fc, "can not change snapshot during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->max_credits != old_ctx->max_credits) {
+		cifs_errorf(fc, "can not change max_credits during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->handle_timeout != old_ctx->handle_timeout) {
+		cifs_errorf(fc, "can not change handletimeout during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->got_ip &&
+	    !cifs_match_ipaddr((struct sockaddr *)&new_ctx->dstaddr,
+			       (struct sockaddr *)&old_ctx->dstaddr)) {
+		cifs_errorf(fc, "can not change ip during remount\n");
+		return -EINVAL;
+	}
+	if (!cifs_match_ipaddr((struct sockaddr *)&new_ctx->srcaddr,
+			       (struct sockaddr *)&old_ctx->srcaddr)) {
+		cifs_errorf(fc, "can not change srcaddr during remount\n");
+		return -EINVAL;
+	}
+	if (memcmp(new_ctx->source_rfc1001_name, old_ctx->source_rfc1001_name,
+		   RFC1001_NAME_LEN)) {
+		cifs_errorf(fc, "can not change netbiosname during remount\n");
+		return -EINVAL;
+	}
+	if (memcmp(new_ctx->target_rfc1001_name, old_ctx->target_rfc1001_name,
+		   RFC1001_NAME_LEN)) {
+		cifs_errorf(fc, "can not change servern during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->got_version &&
+	    (new_ctx->ops != old_ctx->ops || new_ctx->vals != old_ctx->vals)) {
+		cifs_errorf(fc, "can not change vers during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->witness != old_ctx->witness) {
+		cifs_errorf(fc, "can not change witness during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->rootfs != old_ctx->rootfs) {
+		cifs_errorf(fc, "can not change rootfs during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->linux_ext != old_ctx->linux_ext ||
+	    new_ctx->no_linux_ext != old_ctx->no_linux_ext) {
+		cifs_errorf(fc, "can not change unix during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->nocase != old_ctx->nocase) {
+		cifs_errorf(fc, "can not change nocase during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->intr != old_ctx->intr) {
+		cifs_errorf(fc, "can not change intr during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->no_psx_acl != old_ctx->no_psx_acl) {
+		cifs_errorf(fc, "can not change acl during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->local_lease != old_ctx->local_lease) {
+		cifs_errorf(fc, "can not change locallease during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->sign != old_ctx->sign) {
+		cifs_errorf(fc, "can not change sign during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->ignore_signature != old_ctx->ignore_signature) {
+		cifs_errorf(fc, "can not change ignore_signature (signloosely) during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->seal != old_ctx->seal) {
+		cifs_errorf(fc, "can not change seal during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->nosharesock != old_ctx->nosharesock) {
+		cifs_errorf(fc, "can not change nosharesock during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->persistent != old_ctx->persistent ||
+	    new_ctx->nopersistent != old_ctx->nopersistent) {
+		cifs_errorf(fc, "can not change persistenthandles during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->resilient != old_ctx->resilient) {
+		cifs_errorf(fc, "can not change resilienthandles during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->sockopt_tcp_nodelay != old_ctx->sockopt_tcp_nodelay) {
+		cifs_errorf(fc, "can not change tcpnodelay during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->domainauto != old_ctx->domainauto) {
+		cifs_errorf(fc, "can not change domainauto during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->rdma != old_ctx->rdma) {
+		cifs_errorf(fc, "can not change rdma during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.43.0

