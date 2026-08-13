Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890F63C8728
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 09:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614184; cv=none; b=AFE6jeJbhw0B+ukfAaYnvs46uBnpV2UMDkUTDyJVy0gin/1VUcMKzHvyvJE1j8eBTALs+w8STUElP080MAln+QHcGzg9uQD4awbkWeBu+pwMV2lxAjqzb3Vzn0DCluA52EQOgGa+CdhxhoOaajFEBh2QRB7IClc+DD/Q3a3bp0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614184; c=relaxed/simple;
	bh=CZ/7PoVdvaOK9lQitiXRsiEv5bEd75+It/qPwprmSpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ly2FT8UQgbaZ90+zSVXKp8wfxgdBxjEA0Y0BXSvkukB1n0RjkNaey+cKqNVpWMbZMc+PSePTwqCdbJZ2GdGPGIQMR9jkP6SnVF1Ca+DNnyWf7NqQCR7Ujgq6LAtaimthAizfWRWstOw/5Ca43pDqCDHZ8oSx6nx8wIa/f1z2eeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BXp7GdSA; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BXp7GdSA"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e041ea211so2257859a91.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 02:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786614182; x=1787218982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MT3Q/qLYuwioohnzErhi7X2vaCnV2zpJGa9m05yP8hk=;
        b=BXp7GdSAg8fPWDkMmW8hwD32dJLn+cK5Oc7dzzxvY6AUXOlSKkS35ipwzx8d7WS9OJ
         8xQeh3XrFYNPgryICLJBkAfUP4H4gBZt1Iy5Owgb5cG39rexWQBa0eN4h5QcGJOW4IEN
         5z5R1uwM/TphJXGzz8DdVm5a2y7GItUBymvegRlND1/hFKljoply+QSBtFV443/Z75QB
         tJjmKIkPFd0+gnqAQgKzWbsmAFWXHtSxK6oYyuRVAYAP6iIDccDOtG81kmVyc2LqqOHH
         wCTN4nOLXCdZ9tt4kL47NeRBB2yYF2qWyAKT77YFZNBVkldAIZOf70fvGO18DaerT/ZQ
         cQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786614182; x=1787218982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MT3Q/qLYuwioohnzErhi7X2vaCnV2zpJGa9m05yP8hk=;
        b=Pl3uPDMDA4TJuwgfO8yw4tTrSkWgwfSY0Tc9S+ufgZawiUr/b2CyrHSjLvdfS68PcJ
         KWiVy86uVZw37MHKb+c3jkcqa/ua9NZU08g6asRM826MMRsKqVHM3eSISXssBxSXYjlN
         q+5NAPdqfLMxnWheKBQ7pn/gj5/Xq+pD0/7XQttVlpQkxzNf4qA7vrm1mbWzWeQgXNf6
         esa8URn5XyDp9PnGcZyx3BT5s+Q8qfZClnOTSOV9ivz/Yy76LBjtAu9LPODbK175ClvT
         gW7CPXDlxuojNjQ3ApXTODHoE7flmq98sKFk5XQmhcZVQpBl4fbgTwwQ48zN4swax/AA
         Kl2Q==
X-Forwarded-Encrypted: i=1; AHgh+RrcoLmGMeGvPhn4xe++SX0XOr3fCaQJzUVb6Rn1kM7qC9dLh2V4LrRLgSEuWRCTqdmImuJ2H4+cMF8q@vger.kernel.org
X-Gm-Message-State: AOJu0YxIeEpvUmKIrkd2BM8kv/XrRAWG3tHo8vRFB8p92w3RrwwPVlPM
	Y9Dx0jgrRZWcVO9oe9z0YtD6a9C9GhlvK+MerYgIvG1uX94TuKeHmHxP
X-Gm-Gg: AR+sD10h+/a1wMZld0PUN8Ops34NkVY6zXfZ6nsqvSj84RIsj+4kRBREmPHaJlDweNF
	wCtvDHKa9GOXo0CChhW3Z6nhUPrQ1pM3f4f1QJ1+b3yzE3mo9rPQvmpWlEnU8Zyri0u4e3Uksrz
	E2GdtG9mkaUGSETAcJlalcHX3uXR4hEi8eXdfa+jVBlVRJbmG7NCi9fB1mL64OGouLimepXnjp+
	y47ZLOWcaOBHbtqK3BimumAb1iJc6hI9PP88xdVLNj6GiQSFk8duidSRDaohMCIuUq6CdxXhqu0
	PyDmbiHHJnSwj1hjKfds5dXJXSx1rcPOfs65p7KifT/5K3fpaw0FOUkyjIeQKaEL71do4aQBoDu
	q5Hy+DrVE2HoFii28cipWt+aqDyPISNMGWtSL8aegn+wZFgQTv/3QyfAJSLNW9hrD62Yhl3dKEU
	0ROIrYEHbsNeuN7t7BvO3MP2CM9JTHaZAd3tMm13x7KJ4IvkBXCnaQ64A/tbVoQzu7HHLhuuj9Q
	dxUQM3uG71lVdvyBeVja8UOCeS6IxB1ctyl3lq1D0uqRqVgS85uEDP7B0jZOon5GpvJYPurMFoc
	hyqqHiT2K0qgUXFg
X-Received: by 2002:a17:90b:1d4c:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-3931de23128mr5327430a91.0.1786614181776;
        Thu, 13 Aug 2026 02:43:01 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc760524sm6409135eec.1.2026.08.13.02.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 02:43:01 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v2 2/8] smb: client: block non-reconfigurable option changes on remount
Date: Thu, 13 Aug 2026 09:42:45 +0000
Message-ID: <20260813094251.666373-3-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813094251.666373-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
 <20260813094251.666373-1-rajasimandalos@gmail.com>
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

