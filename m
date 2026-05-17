Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA14535A3B9
	for <linux-cifs@vger.kernel.org>; Sun, 17 May 2026 09:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779010888; cv=none; b=MJMbvfoJQ2WKToSAybeWbBFSCv2ecsdGxc7MtKDLwGus4TwHeHRFXlePFTKQHt/l3+CML53ybwtqx93kfXAFgd3rjbyYAWhPlYxqT2RicbyBNpu6djTvOW8dWVTvAtRTox0Xj1Atqp1vnLF+4KX9ogZlp0Ve9C7l9LuU2CPYQOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779010888; c=relaxed/simple;
	bh=60ThQo2chhN8cl8i+//ks2sLsBiyv79/41sISBZMEs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMFVSqFhQFzVAdlJh141JMfRr0Uz3oHiO9/SLsIsRlPfpWv44dpovueN73xz0HTo1CWyrEAIO970wOfqO0GQxfmV43atlpHq5vAEVaXX0dloBL9ZsqAt0zoE9XjKxR27DhL/AehCaLRrp8JMVF51uZXdcuHerJGkeNUgp21Y4+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QlmpuwwC; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QlmpuwwC"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8acb856a674so21809036d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 17 May 2026 02:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779010886; x=1779615686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSTgTHR41wLkI2CjlFelTDkSH/MO48fL3eCw+FSeqXM=;
        b=QlmpuwwCGuApU9v8BUl8Vr64G9uGNqnGDfMf0wYuQsTwlbCuCZETzLlKS9034rfihQ
         EZ3OVKKyAugwUp5jo+AJn1lLBxvWUQLPGYi8iiLujzUfBwLrx60bQ2ucD8eNVSEKe71s
         im3V/8P7B7hqNZkqsqlga5MEpNyciinV3ZTclI/VZ/AqmmXxmKhBFHAZ+d7GkUItzEjd
         2U0FR260VE5B/PJ/H9N/7kzh8gnihxFo1N9N0PsjjaFlxahmP08U8Fy/UaK2valS11S1
         ye7JFx00qSKpbrDrNabxCpaDa59+Pht4qFu98ZbdUTie4fJThvNBbxHQa6ZP+ijrAfXX
         Gwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779010886; x=1779615686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VSTgTHR41wLkI2CjlFelTDkSH/MO48fL3eCw+FSeqXM=;
        b=TjhJXqtv2lYs+d8zaE4kQEjk3ezzsPbeD96uOnJYMw68LM+Y09QbFQuCiCpjJDz9hQ
         cHgrNM19ER2Okvw08v5XWxFMe+sDFKnQsXtnXXLp8xyZyVtkwDtUis4Ny2iS5BBRtYbT
         jpP/aWLHrdm4L8hI1w18jtoULHsyXyWpvrSF2FfiCVv3PUjxpQqGrZml6ZpM9NPN/Qtw
         HPU5Kc+xot7ZoScuD/8zfqldl/IqAYPypk31QMKkKaDGwJ9/BtFkxazDGm1IIarfAbZW
         OrLzFoqXos4hu8zcZqb+KlUC+wwae8hlfmpnj28Vz22qK/PD6E4GM7PFbtzW6UmivaPg
         +Qig==
X-Forwarded-Encrypted: i=1; AFNElJ9factUmcVd4rKubNZ8As4vd8gu3eH91x9HQawaSmADwPhVx8LD95B4Xc0NEy5pDVPuq1e3o3WxeQmc@vger.kernel.org
X-Gm-Message-State: AOJu0YzTGFLAzYtXd8VT5q5aiBWMu38UY2PSGMZ2XGme2h0NU7KN+YBo
	8HkR925I8DSiAHInU+7XixcWV/Pk6Hu9ZmwD2I/Xtb+iaYcbrdhKLVlM
X-Gm-Gg: Acq92OH0Z+qzU54FOK0UPoE7d4Z/gjZ7S6+kqljBHwqwsDEKimORf588JbKGFWVt7ko
	2IEAaBcx6n6EpRZr5HxGdQZ5lnFl+AUT2d/x1LXxmn/lM+rKvfremJN+FI7DfMkBbvzxf2h+a17
	j4/l3LzzN1I2nkL849AaHwkofIdVy/ZLHZrPkcmJxFyqBZIGq8aII6LnRbWy18bWlst0/j7SPJf
	Mse6edpcUKByCuurpODTumOdTV9JeEMhOU61kpBdaKDRXONJjZwb0MwVihDRRYW+u06yPU9jKHJ
	VeZjqO5qPgvs5cMl1CKL79uDwYFLhu2sukU206ROpeupAt+gRNDnYX9UZEV1vKn4RHuDRg27bkQ
	eLsOWGTnlJpLSrsLby5IzLpykvxYKObMlc/I/sRCHkRcTyBILrmomN10anF5a0QP3HCJG4Nfg+j
	Aos9ppJiZbrhSli6KdkeOntEVAcs2xkZ3Ieue8Wbvl5cddw2fQeoMvxmHQfOwS8Oo7P5gmsf6j+
	SxhRzuHRBTu/RGrI2iU0ROeTOKnwYYrJLEv6o/trCQ=
X-Received: by 2002:a05:6214:5985:b0:89c:8353:1fa0 with SMTP id 6a1803df08f44-8c8fae7774emr225623046d6.4.1779010885871;
        Sun, 17 May 2026 02:41:25 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca3619c703sm17168806d6.33.2026.05.17.02.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 02:41:25 -0700 (PDT)
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
Subject: [PATCH 2/2] smb: client: require GENL_ADMIN_PERM on CIFS_GENL_CMD_SWN_NOTIFY
Date: Sun, 17 May 2026 05:41:04 -0400
Message-ID: <20260517094104.2954731-3-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517094104.2954731-1-michael.bommarito@gmail.com>
References: <20260517094104.2954731-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The witness-notify generic-netlink command callback dereferences a
struct cifs_swn_reg looked up by an attacker-supplied registration id,
and the operation entry in cifs_genl_ops[] has no .flags set.
Generic netlink only enforces a capability check when GENL_ADMIN_PERM,
GENL_UNS_ADMIN_PERM, or GENL_OWNER_PERM_CHECK is present on the
operation (net/netlink/genetlink.c).  As written, any local
unprivileged process can send CIFS_SWN_NOTIFICATION_RESOURCE_CHANGE
or CIFS_SWN_NOTIFICATION_CLIENT_MOVE to the in-kernel cifs witness
handler.

The intended sender is the cifs.witness userspace helper, which
runs as root via its systemd unit, so requiring CAP_NET_ADMIN in the
initial user namespace does not break any in-tree consumer.

This patch closes the unprivileged attack surface itself.  The
companion patch ("smb: client: pin tcon across cifs_swn_notify()
mutex drop") closes the lifetime bug exposed by that surface; the
two are independent and both unconditionally beneficial.

Fixes: fed979a7e082 ("cifs: Set witness notification handler for messages from userspace daemon")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 fs/smb/client/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/netlink.c b/fs/smb/client/netlink.c
index 147d9409252cd..acd0cd44a3038 100644
--- a/fs/smb/client/netlink.c
+++ b/fs/smb/client/netlink.c
@@ -33,6 +33,7 @@ static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
 static const struct genl_ops cifs_genl_ops[] = {
 	{
 		.cmd = CIFS_GENL_CMD_SWN_NOTIFY,
+		.flags = GENL_ADMIN_PERM,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = cifs_swn_notify,
 	},
-- 
2.53.0

