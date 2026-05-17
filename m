Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F3035A381
	for <linux-cifs@vger.kernel.org>; Sun, 17 May 2026 09:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779010882; cv=none; b=QT52UuZ2FQroOvVbYiINYqqw1hNyaYQ/tQ8UlG6opHjfA0YsVtnaHQZ/+Ln6iwkyrjwR7uWvDl267rRd3uXiHg7RfMsobXWLmTxLxE/8zjqZbc0Sl5DMsYdzX/2JNxP1jExrZJ+iqUQacC2Z9M28Jonp1mKZ99c0QKym21JUy2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779010882; c=relaxed/simple;
	bh=4sIcR2B8+4inCCvSH8vTPAyaIG0QS5KbGtxvrWCTtDs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bl3FGiYjexjB1o9dBroZfpIhxfQkdLcZ++ON5qTpAcRdCs3YcwdBigpGI/zUA8GWdc4g171DYcZf+2fRwqpZAmpdx3yGrfXrpgOCxEQ1AukVxO4RKeGpcVY313iHtmNtPDWVY2FXknjFccLDf3sP6JdjhMPV9gbOrx3JQtL+J3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lD3tEGqa; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lD3tEGqa"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-913cc4d7c71so52394885a.2
        for <linux-cifs@vger.kernel.org>; Sun, 17 May 2026 02:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779010880; x=1779615680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6ocUGdh5t5pe1L9NXuPFQhdnmVPRtREhAgeiLdvlERI=;
        b=lD3tEGqaoygg0uaxg/mE7Qbl9E3MP21nRe4T6sbWe+PENA9nq9eQqiOsay3KwG4oQz
         9A2EBuiBKx6CGRguzA5GPT725lkP6XgFkSZGvO0PZtfTTK9vhhP7PkdAnumb5JEdmhMo
         WlGndFxIJh3KOwU8+8l0u2Zgnfte3a7X6U+67blVXA/nCoYpKRlNePQftPlOKjfx2ud5
         NKVRZbYSyFY/Pn/TDSCFdzfXQnYYLl33MPSQse4XitO2vJ22GZQlEmwmGMoYgBtTDjmH
         ctwCY5+EsJOoOAB2birn4hCulP5LeKZq85Ooh14jXLk4UugrDl60lZ3pR8Bp7UyZQDw8
         ZaUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779010880; x=1779615680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ocUGdh5t5pe1L9NXuPFQhdnmVPRtREhAgeiLdvlERI=;
        b=HfkT6r/RxFJsHEN6u0qX6uatnEJvEzsIX3SEBp1Bw/S3x2OYIEQMSR1HXqvCkiaacE
         tX/L9lDMadErkNpdmOeIHju1D9MDKzsnkMg2uDjZe64BtmH60fHWT6vy8yNuG1m9JyGl
         NMmrRYVqDw8smLYeo6SbhCpAB3qqMCtJEToUmhc2s3AQJ05VGn3LZOAaQWg72UJxTMdw
         MfUTtHs4rFCTHlXkTOXphYB32AJz9nT9429iY18SZQpBe6lwSV+ZhmSMtWDsRqDKf+qP
         ennVrxX7sTavsbtj9vXLueYCmFdXFW3QIo8j+GfnsHdiRz22Wwmve0S2h5/FG/RB42rK
         V8yA==
X-Forwarded-Encrypted: i=1; AFNElJ8I3VaMh25spXT1LUh2O6XHM4/qrix1WW4pFI0sBxYWAhJQjdIOTroT/7b7SFyVqjiWBItLPEaHkxZe@vger.kernel.org
X-Gm-Message-State: AOJu0YxjpxFlu2bJnJslMNiQrspnh0cEz9dtvqAJkNRYnd0UkxKhgmwA
	tTu6nXWnDNeRDOCiu9Q9Es3NaS0z6I0NilUV+SFTs3rkSl8E8zUVbVYF
X-Gm-Gg: Acq92OFf8iTIM2OToj+8G6rR7dW9P6myTlIouN7sUHrQyWTruII82FuvquqmyC1mE4N
	H4lpIT8pPpp2Lu7Zl56itvj+TQYE6iJsDgWVwKrvZmat1c3CyjlfmltO/nLFLOWyCcehRrGqIKQ
	7c9paD/He6XkLX9/qExfgkHOigX2lDRMmdqlPisWMs1+dhkBYUjLSQk6TRpDjU5bsh4hrbRyhfD
	zWXnEawIQ7U1b8h+Mf2uQwYrSV19tH70o7I/qXl3YyD8OLADemfcl01EANL3XMOYixD70bDWuqc
	H+iEdyUyu9dOGsYZ8lgtVZQTJjPxCKffvk/XpQnLYFebMgHyy4ZFyo+CnLzznHrLx+l3L3G+CR4
	Ufn12vP/3DdG+BwHHZ1Jw8z2c6VYYHp3HtRMhdpG52WGe4qtUdNOf+YTSF/hkQMrUePjyVn5Qdz
	Y/dNUP5PWruKGSRkyCsVfdL+X2CDhEip7q/ddQ6IxVFr+MK+bXX5QHJDbcjP7HJUkmwlbQXA0Yz
	YpMHTAvF6HVhHcrWc+ZSMaKn01caKjzbZE0bYDsxVs=
X-Received: by 2002:a05:620a:2403:10b0:912:5d2a:4bb5 with SMTP id af79cd13be357-9125d2a4f48mr917025585a.46.1779010880095;
        Sun, 17 May 2026 02:41:20 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca3619c703sm17168806d6.33.2026.05.17.02.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 02:41:19 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Samuel Cabrero <scabrero@suse.de>,
	Aurelien Aptel <aaptel@suse.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] smb: client: fix unprivileged-local UAF in cifs_swn_notify
Date: Sun, 17 May 2026 05:41:02 -0400
Message-ID: <20260517094104.2954731-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes an unprivileged-local use-after-free in the cifs
witness notify path (fs/smb/client/cifs_swn.c +
fs/smb/client/netlink.c).  On any kernel built with
CONFIG_CIFS_SWN_UPCALL=y that has an active witness mount, a local
process of any uid can race cifs_swn_notify() against the reconnect
or umount path and trigger a slab-use-after-free on struct
cifs_tcon.  Patch 1 is the lifetime fix; patch 2 separately closes
the unprivileged-reach surface, because CIFS_GENL_CMD_SWN_NOTIFY
currently admits any uid.  Applies to v7.1-rc2 mainline.

Impact
======

Patch 1 fixes a use-after-free.  cifs_swn_notify() does an
idr_find() under cifs_swnreg_idr_mutex, drops the mutex, and then
dereferences both the returned cifs_swn_reg and swnreg->tcon.
Neither object is pinned across the mutex drop.  A concurrent
cifs_put_tcon() reaching tc_count == 0 calls cifs_swn_unregister()
which frees the swnreg, and tconInfoFree() which frees the tcon
itself.  The race fires both on unmount and from the
smb2_reconnect_server worker on any reconnect cycle.

KASAN under a SMP=4 KVM build with CONFIG_KASAN=y and
kasan.fault=panic_on_write reports a slab-use-after-free in
cifs_swn_notify -> cifs_swn_resource_state_changed (or
cifs_swn_client_move -> cifs_swn_reconnect) on the freed cifs_tcon
under a 400-iteration mount-with-witness/umount loop plus a
4-thread NETLINK_GENERIC notify spammer.  First splat appears in
40-51 seconds on natural timing without any artificial widener.
The freed object is reported as struct cifs_tcon (kmalloc-4k slab),
freed via cifs_put_tcon() from the smb2_reconnect_server worker.

Patch 2 closes the unprivileged surface itself.  The
CIFS_GENL_CMD_SWN_NOTIFY operation in cifs_genl_ops[] currently has
no .flags set, so generic netlink admits it from any uid.  The
intended sender is the cifs.witness userspace helper, which runs
as root via its systemd unit, so requiring CAP_NET_ADMIN in the
initial user namespace does not break any in-tree consumer.

The two patches are orthogonal and both unconditionally beneficial.
Patch 1 fixes the lifetime defect even for an attacker with
CAP_NET_ADMIN; patch 2 prevents reaching the lifetime defect at
all from unprivileged userspace, even before patch 1 lands.

Reach surface
=============

Witness registrations are created when a CIFS client mounts an SMB3
share with the "witness" option against a server advertising
SMB2_SHARE_CAP_CLUSTER on tree-connect (clustered Samba+CTDB,
clustered ONTAP, Windows Scale-Out File Server, Azure SOFS, etc.).
Trigger on the bug is then: any local process able to send a
NETLINK_GENERIC message, raced against the reconnect or umount
path.  Kernels without an active witness mount are not affected.

Validation
==========

On stock the same workload reproduces the splat in 40-51 s of
natural timing from an unprivileged sender (uid 65534).  The
patched kernel runs that workload clean across multiple
multi-minute campaigns:

  - 4 unprivileged-sender instances (200/50/500/100 iter x
    50/500/10/100 ms hold), ~185 s aggregate KASAN-clean.  These
    show patch 2 rejects the send at the genl layer before
    cifs_swn_notify() runs.
  - 4 root-sender instances (1000 iter x 20 ms hold each, the
    densest config tested), ~470 s aggregate KASAN-clean.  These
    deliberately bypass patch 2 and drive cifs_swn_notify()
    directly to validate that patch 1 closes the underlying
    lifetime defect on its own, independent of the genl gate.

A behavioural trace of CIFS_SWN_NOTIFICATION_CLIENT_MOVE confirms
that the cifs.witness daemon still observes the documented wire
sequence after patch 1:

  cifs_swn_client_move -> cifs_swn_reconnect ->
    cifs_swn_unregister -> cifs_swn_send_unregister_message
                           (for old IP, +6.009813s) ->
    cifs_swn_register -> cifs_swn_send_register_message
                         (for new IP, +6.011462s)

Unregister precedes register, matching stock behaviour.  A
narrower fix that also pinned the swnreg across the handler
(rather than only the tcon) would have deferred
cifs_swn_reg_release() past the end of cifs_swn_notify(), and
the daemon would have observed the new-IP register before the
old-IP unregister.  Pinning only the tcon (which is all the
post-mutex code actually dereferences) avoids that ordering trap.

A separate single-process probe confirms patch 2 takes effect:
an unprivileged sendto(NETLINK_GENERIC) of CIFS_GENL_CMD_SWN_NOTIFY
receives -EPERM on the patched kernel and -EINVAL (the cifs handler
ran, no matching registration) on stock.

A reproducer harness (race driver + initramfs glue + QEMU runner)
is available on request.

Patch 1 has a Fixes: tag pointing at fed979a7e082 ("cifs: Set
witness notification handler for messages from userspace daemon");
patch 2 references the same commit since that is where the genl_op
entry was added.

Michael Bommarito (2):
  smb: client: pin tcon across cifs_swn_notify() mutex drop
  smb: client: require GENL_ADMIN_PERM on CIFS_GENL_CMD_SWN_NOTIFY

 fs/smb/client/cifs_swn.c | 64 ++++++++++++++++++++++++++++++++--------
 fs/smb/client/netlink.c  |  1 +
 fs/smb/client/trace.h    |  2 ++
 3 files changed, 54 insertions(+), 13 deletions(-)

--
2.53.0

