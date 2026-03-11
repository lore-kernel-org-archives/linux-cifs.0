Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFEF3DF007
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 16:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773245351; cv=none; b=IRkgzHXqESs4eZbsL+QDDGJc6QWbaEBweFh4yt/TanUf1mvold0VFXK3SSatJ6oN87s5vmM+bApleSXFFhNpJEqsUnQ7GrUCRKRDIqBe3tT/vIx+YjqGWMG9YRiMIuZOZxeKVm/vMUXwF5P8Hp4wpjIlhKmFd49ryh1bszK6KVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773245351; c=relaxed/simple;
	bh=8jYcDGodtpSwJhTwixQOKf3vIBHR6G9gy3RXw+RNRP8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tu27fK/O9GBh6Lw4B9FL0om0pSp/NCHpBD5ZjLwGD5EZQjeXepSCSofmWVXV5H91Z/6WKEsvZy2qu8gloJmUJ3gG1oiuKySUvG3i6nC3sKhwdB7POGl7dHXC42EVIGW77wzK6xkoRdwAtNSEvXcoY4AMGwF8A9KifPkD6pj0ezA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SQx0nyZ9; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SQx0nyZ9"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4853510b4f3so372395e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 09:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773245344; x=1773850144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7gVSVuZCY4DN/AOXDxmYSHDACnTa9Rrny+DZImbC8pA=;
        b=SQx0nyZ9ApcSnLKUYIGoFFGVKTOnUPdX/xf3qAGS0wDHR9BgMWWFkelLdv5091S94q
         HcjAk8kgytxwBtU0CqPwffzTb3abtXtYkJ+Z/m6nvaMCqbk6xhfYRitgdZ4ju69u+CYS
         CL+oGTT6y1D7rD6q6pzWl2j1TIwKGFtIIzKL/asuLbIVbzq2H6mFUrTqF2IVRqPCL5vG
         YJGjUBmFtMsjNo7JIPEVfQmSlQNWjCgL/HQBYqbtDUpdvIguSHYxSLbAlWhMaaGF/xZb
         9M5CmPedneoAc9NfeTsL4jtb3eHSk3UiXqTftCUysb17wrCVy8GL68Q6QTlyunMtzYzK
         G6WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773245344; x=1773850144;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7gVSVuZCY4DN/AOXDxmYSHDACnTa9Rrny+DZImbC8pA=;
        b=Iit0M/dxG+UMtsueibEmrOMq1e/CnwS6Rs7UVxxoPNxkaKgAIKzq1vD34Dmv/u9VmZ
         ezKU8DTdOOJm3+z0jgk33mRotQjR3tF7oo6ANFA35Ag9QTgK1q5hM2OzSRi+thX8ocEY
         7hAnvxVG8iCMpNGjE4FjnUoObAYAyr/OKAkKWpmyTqVWfNYUMWr92ASS5y+xluc0DoJ6
         O1TPlKciOJxfQafn1e7rtPYI/JpF6u5G3ZO/1aRk1nMeRzYGPdD3SJkf5ad9qGFCNXlE
         Ao2jKcfFpUx5rIbBc8OkVfIT3zTaQuWvvwiWVsDhcorn32/XVadvMBDDCYWhHLY0scAI
         x6Lg==
X-Forwarded-Encrypted: i=1; AJvYcCWAzRGbWXuxJ9vb/JOoTbDVaeitdC5N7Co2uaPaeF22xsKFs0Uz2H4Shofnwl87+kH1wMl8yyhab/ad@vger.kernel.org
X-Gm-Message-State: AOJu0YxJNL/+yb9hJicVEhlSsWK9WBlrGWCld187aOjrgta9mP3CebHp
	+cPog5T2YvqTzPJbmUAXeqUP6Nt5oWUrHYOpL5ZVY7Uypk7y2E8Kc5UyKHs+kGJdENk=
X-Gm-Gg: ATEYQzyl8ZQssDUpfDpJszcmbSLF5nodxPwUuOcLM7+ksranFyoK/LV6WqFSgfxxVPd
	oUHIwtAccd5lYf6Xb5cUfqqSP70/OXFRSTmSxnnm1LhhYGH/ePGT+j3/EvuOVmWfKZiIfRyDUMm
	4d7esPS01He2h4nsjspI2qET7wFEsg5+TXQ6qspY6nq6TSvJ+/E8j2qihFc5tJo5RgfJ9N2AsW5
	9cvp9wOA0g/rxUJAINsuNTMDaergob7a67pwRK6aNlMCiyh2tgbubBay3f14bFhTHXTjbcSFDUn
	ZmnUyIJaij2orHcRLrGs9hFt8vpdElxB0YWZAbkgLx9FnQpdYKiodalFoRqYAKmTUqVtFL/NYyS
	w9jUPS+hC9LB9NhsXbFQwjVMHsIwKXGnKAOOzH6MpXJgSSuXJw0BfZi7PXvOvPq1Tj/LhV5TI8c
	5ACp2NA6iIwB+ZzDe53vmXgfymbPJOnc0iIUa63/AiqoK/xizl0VOJaAQ=
X-Received: by 2002:a05:600c:8b45:b0:47e:e57d:404 with SMTP id 5b1f17b1804b1-4854b1008famr45351985e9.16.1773245344207;
        Wed, 11 Mar 2026 09:09:04 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128e7cb558fsm4000846c88.10.2026.03.11.09.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 09:09:03 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: preserve destination port when parsing server interfaces
Date: Wed, 11 Mar 2026 13:08:56 -0300
Message-ID: <20260311160856.635916-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_server_interfaces() initializes interface socket addresses with
CIFS_PORT. When the mount uses a non-default port this overwrites the
configured destination port.

Later, cifs_chan_update_iface() copies this sockaddr into server->dstaddr,
causing reconnect attempts to use the wrong port after server interface
updates.

Use the existing port from server->dstaddr instead.

Cc: stable@vger.kernel.org
Fixes: c1846893991f ("cifs: update dstaddr whenever channel iface is updated")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2ops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7f2d3459cbf9..d3cbfb3fdfc9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -628,6 +628,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	struct smb_sockaddr_in6 *p6;
 	struct cifs_server_iface *info = NULL, *iface = NULL, *niface = NULL;
 	struct cifs_server_iface tmp_iface;
+	__be16 port;
 	ssize_t bytes_left;
 	size_t next = 0;
 	int nb_iface = 0;
@@ -676,18 +677,20 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 		 * conversion explicit in case either one changes.
 		 */
 		case INTERNETWORK:
+			port = ((struct sockaddr_in *)&ses->server->dstaddr)->sin_port;
 			addr4 = (struct sockaddr_in *)&tmp_iface.sockaddr;
 			p4 = (struct smb_sockaddr_in *)p->Buffer;
 			addr4->sin_family = AF_INET;
 			memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
 
 			/* [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these */
-			addr4->sin_port = cpu_to_be16(CIFS_PORT);
+			addr4->sin_port = port;
 
 			cifs_dbg(FYI, "%s: ipv4 %pI4\n", __func__,
 				 &addr4->sin_addr);
 			break;
 		case INTERNETWORKV6:
+			port = ((struct sockaddr_in6 *)&ses->server->dstaddr)->sin6_port;
 			addr6 =	(struct sockaddr_in6 *)&tmp_iface.sockaddr;
 			p6 = (struct smb_sockaddr_in6 *)p->Buffer;
 			addr6->sin6_family = AF_INET6;
@@ -696,7 +699,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			/* [MS-SMB2] 2.2.32.5.1.2 Clients MUST ignore these */
 			addr6->sin6_flowinfo = 0;
 			addr6->sin6_scope_id = 0;
-			addr6->sin6_port = cpu_to_be16(CIFS_PORT);
+			addr6->sin6_port = port;
 
 			cifs_dbg(FYI, "%s: ipv6 %pI6\n", __func__,
 				 &addr6->sin6_addr);
-- 
2.52.0

