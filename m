Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2623A4510
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511524; cv=none; b=GGB9N6aFF6LfGmZYRG80o80enacROK0gvrbeZjZECZZVlxZ/82vhPtllnG3v9DUBfDy23FkC64IhJyLpc4w1LPJs5HijMUASrc7hBuz5vGTt2i4OtGnYfTQiuTIJ2Ab7u/4/GV9G39if6PRaLymlh2Ox0js9HzdyTl5Fy+VKV6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511524; c=relaxed/simple;
	bh=cz//MR6BCZ92O7ntoCM5s9znOTvSVl5Y2EGxYEP/01o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVStcoljThr6SlG5iHoYPyoU9E3uDCg6wrbFOD4/GLA7AGnTsc/2FbtpHcyqteS152pym3xO9q0sFXHvinjNN/LgOnseM8TPPFMjpJZ7vimWeB+OJIJcG5rUk9Ex+l7lTj6lrhipxoebvfFg6qQhSVVuEO5/UDI2KdkRXsRjp2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WbAcedoa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WGDn49wU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WbAcedoa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WGDn49wU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i+4uO3I8DglwSkcrqXQh9lvjjvP5CVMo2VnfzN++ifA=;
	b=WbAcedoaixlsBoU9dojkw5onK6agnn8Y2o8LnlT5tdVDlmXzBLXR32EPL3xeHquOkVEeB4
	BtAhTMaomhKP3ryEdHmWs6BkIJFYiHmZtq/dlgVUsqnGbTHMKq/eckfZBLe/fiv5R4jKaK
	Y0W6GHb5aNMgPhpEcV0QZQHHTl+WAL4=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368--yZ-1vJsML6gO3O8SuXrpQ-1; Sun, 23 Aug 2026 14:58:37 -0400
X-MC-Unique: -yZ-1vJsML6gO3O8SuXrpQ-1
X-Mimecast-MFC-AGG-ID: -yZ-1vJsML6gO3O8SuXrpQ_1787511517
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7ee59eeb8c1so2209243a34.0
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511517; x=1788116317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i+4uO3I8DglwSkcrqXQh9lvjjvP5CVMo2VnfzN++ifA=;
        b=WGDn49wUVAEapCiYneNwFWSXhtq4Kj5X5Gb8O/7wRjsvafspWKwwd3hUBEbyNOK34t
         E+fanHUKujVTgXBxY+TafBcX/KFny6757MDZ9AgG7bCq+2NgxeOmtavE5PWMhY/84k7F
         jVBOBcxfkWPek74wtlCoPyYFbsdmowLTF2suoxMD6b0IK3D+/DFIEdhQoZBTVbqyjNou
         NL+//D3uqWjvYiHEJKVwqMG/ACGG3arh991JzPlFwfjDWFmK4ypd5KZHng+FgSONky7v
         rxCkrslG0BW6nqb0gQV6w1Rul0jVW5iSMXe8jAAjOoi3BmcJZHhh1VAQGhwwGmTfEnGU
         M5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511517; x=1788116317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i+4uO3I8DglwSkcrqXQh9lvjjvP5CVMo2VnfzN++ifA=;
        b=DoKlo5UlZdti37fSlqIzDL6yJ4WsFBqM0GRqlZlhb9rWFnIyoHQdtuPD09FC6HOhhN
         aWYRZezN9uiWD4HwTG+zMr1ppsXxVOaRJuxupMDbXH9NHLsswi3hs2SL7LF6+ZHoTLZJ
         afWBNjKpHYRLNf8YuYK3RIygwHWJnlQP5ykdIDUPZBwJg25YDV5qRzoJu+MQ2Uuqn9r3
         Pdm9FQBD7G3WVps5y5FlW7ZxZsaSzDcj/xSgvFsmnKGAV+edHIP2kA4txzXeEV68M8rd
         MxvkfWxOs6AqlK8ivnAbRoH4Cvvac+m8dzAY4pB+aGKe7NkhDND6/40tJ5mKNZ6xqJU3
         PjLQ==
X-Gm-Message-State: AFuF++lPF0EEgSdVtGG/KQ7MM4zYHRB5/iPtoxCLMO0agI51HDajDXNH
	8eNoeZUzbtfIFd2nG5t/sCuj7pp+AgqKlSSr8ula0iqai16qEQbA72XevWakGgN1nPTbr8lGUtg
	6U/pDRTV6AKYyCBEyB0zyvdw8zdEH11/BpLSeyrUAOPpoAJ9UPL0Np0Ni1pdHlH18cWxAvBxNAn
	nSZgOR/FdUXI8Vg9e0MNbEF5/nItNrPMck2eiT8gd5ZNFoA2U=
X-Gm-Gg: AR+sD11ULSh+jedn92pIC2I93aspJyHOasgV8zFAYgXYqdq7s4BSVPdk/U0EOjExVMD
	L8i4t85DHOx2cb6riXmTTvfRV3RPZYdOQKWqOpyVd7h7Hd18CElfSzdbK6RGxZjPaArk5Vd0w5g
	MDHpmuvHqFyZrm9oNM2W+IFo7M3s97zhTlgmVfW74kuzhzA9pqKSf7Y1rLbCGynBj6iH/P7h/6c
	V3r/6icOeiVyHz+l4OrE0Uwc3qi/xfCvjwl8lC2uGLg2B7UHoTGUZoV7mHMjkSpEqFHZ8Jmxqtq
	BufoU5Vz/AgTNOLjyEVWOwI6oexvXgCpy2pBDZgGya1Z2wFLjN9WfNPARzyZWClq0Mn4VbNr1hp
	M6jl0JXbi8a2BC553H0yo83EDjzm/CAUPR/X8yIPJRsjUjaRztzo26K0KhPPDkGlqsw==
X-Received: by 2002:a05:6820:2d4a:b0:6b0:fcdd:2da7 with SMTP id 006d021491bc7-6b16b1f9ba0mr13644589eaf.7.1787511516949;
        Sun, 23 Aug 2026 11:58:36 -0700 (PDT)
X-Received: by 2002:a05:6820:2d4a:b0:6b0:fcdd:2da7 with SMTP id 006d021491bc7-6b16b1f9ba0mr13644560eaf.7.1787511516494;
        Sun, 23 Aug 2026 11:58:36 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:35 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 03/11] smb: client: fix server->total_read not tracking sub-PDU size in receive_encrypted_standard()
Date: Sun, 23 Aug 2026 13:57:59 -0500
Message-ID: <20260823185807.3115901-4-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260823185807.3115901-1-sorenson@redhat.com>
References: <20260823185807.3115901-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

receive_encrypted_standard() processes compound encrypted frames by
iterating sub-PDUs, decrementing pdu_length by NextCommand on each
hop but leaving server->total_read at the original full-frame size.
cifs_handle_standard() passes server->total_read as len to
smb2_check_message(), so every length guard in smb2_check_message()
(smb2_rsp_struct_sizes[], smb2_min_pdu_len[]) operates on the
full-frame size rather than the current sub-PDU.

A malicious server can craft a compound encrypted frame where any
non-last sub-PDU is shorter than the fixed response struct it
declares.  The oversized len bypasses both guards, smb2_get_data_area_len()
reads struct fields at offsets past the received data, and the
data-area length arithmetic produces a spurious pointer into
uninitialized slab content or the next sub-PDU, which a rogue server
controls.

At the top of each iteration, pdu_length is the full remaining
compound tail (current sub-PDU + all subsequent ones), not the current
sub-PDU alone.  For a non-last sub-PDU, server->total_read must be
derived from next_cmd, not pdu_length.  Read next_cmd before assigning
server->total_read, then use `next_cmd ? next_cmd : pdu_length` so
that smb2_check_message() sees the actual per-sub-PDU extent on every
pass through the loop.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e75420dbe950..1bc3f8266eda 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5248,6 +5248,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 one_more:
 	shdr = (struct smb2_hdr *)buf;
 	next_cmd = le32_to_cpu(shdr->NextCommand);
+	server->total_read = next_cmd ? next_cmd : pdu_length;
 
 	if (*num_mids >= MAX_COMPOUND) {
 		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-- 
2.55.0

