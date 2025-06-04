Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E3D25E82D
	for <linux-cifs@vger.kernel.org>; Wed,  4 Jun 2025 03:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008642; cv=none; b=GSvaSQcQm9ZK35U6V68fDW1Lzx/jBKogVEgePgbuBFwa3h6h3J/NatE8AFda9e9OR4pq2OJLv8h0rVKVjJ14SophwJsyjmE+74vJHQsQvGO1JcRiIm5jfH+Hp1CecqCAlI8OFMuowFCef+HgKQiDKKnH3rqkno3YuXcnxkI7k00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008642; c=relaxed/simple;
	bh=JaIgk1XkjHmjFb8YOvhs5UtUbJaFTu7ac7t5nJnML9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgKY0q90LFt4TnomD3mwU44lTq15BrvTNBHwTRvTeNiZzZQA4ENJdCK3txQvI3giHSaSFv5itNz4CDiF7e8fZcMlNNAc6b0VL717IboeZcwNe5TMT3hz1TxNXYjgBhVsA4uFuxxQ945MwlNsWGsqU9dumDu9JjF35/eqd6sn5kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IdI3orkR; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IdI3orkR"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-74264d1832eso7066659b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Jun 2025 20:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749008639; x=1749613439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zfrF/OpubEc6sXhdgOlGR8JNuqqW5Z6XON9XjCu13q0=;
        b=IdI3orkROGhKxDppl93ALydMsM4LovhTErNCX/O4yEOZgsY2unJycb1ECtY0PlDhhp
         A1wtBTpz1bok4A/Ad+AmYUeG1fuMz8PBdmlC8TaVpBw7XHkHerj2N5iMt7+37jh40QYM
         L3MecG72UNYhZYdjk8gM/tCZ+Ef5/trIvLEOYOP1xKPpdh2PKgEKnMDWE+1MAM5Pd7+7
         TsxlvMaPu1JXBf+fcZMZLUe4wQJwEJJBXSKOpGxmvFxbSSp8QRRMN1VmSLSc/rTAcYQu
         edYnac5MtKjexJKOp4t1X1IiqYWWrxXR9t0G9l6ZPvOa1x4Rx8XfR39QQ4YYISIe0IH9
         H3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749008639; x=1749613439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zfrF/OpubEc6sXhdgOlGR8JNuqqW5Z6XON9XjCu13q0=;
        b=DBiNew8LUv2MxCTulBD1NaEsZUyQI7zm1/JoziI+GDo1w+ZgknNJbdQE7NmVbD7zMy
         tdunCXPUbOW3IE8exjj38+pW10W2qL6zdM80Z3BzyW6YweJTs19+wLyZnSxbmP7FrPGg
         0hM43PVD5UcTQNWS0xlMVC9587ab78lqroMtsc/fnKnk/zsg23w5ixL3GgCf2588WXiW
         z0p5pFO4MV23tO6tW0JCJAbOD0MWvR/VBLRkqhu89rz9HByqU7ChVa4T6jqkOT2/AwpB
         IEq9O2MP9eWF1SM8PyS4kL6eSiRPqUkbLuFpO/ECQ+FLVXJm5Oz7D1X3FaEtbKSajpCC
         /B8w==
X-Gm-Message-State: AOJu0Yz+kD9ddvx5xn81PSiTG4KkgiajZxmpSbe8iZ3Rgg5beaqeI8JI
	6yEGStVud4rlR8uuk9t3ssiHAPzYMulE4H3y/EdEDiJyakE0y4SZafg1qvYqrap9
X-Gm-Gg: ASbGnctCSkMYDCx1j10a7unQ5GoAH27AwHlY0htTh3d/CE0oSppjh7U9LYO9MDMep2g
	9Z018LVrKCaslrCt5wlwmRccuLIIxwM0N5W4f2X00v+yRH5m9yCX89G/tvo8O2CaWFVZKgyPFP3
	8vwHYKUee3n9mVBRsYMiqXQSw/PEZyzcqtDBfwire9G7M5XzKfmwlLbkRKp3KTiWcMb0AsIidNT
	9UFiayPdHhkncJPxZS4wpGCHIJRV3FgDxCFHsG1hkp08GAinqr5Z0gzkrqu120DPg2EUDdbK9W7
	1NzIO8zEMvPnz5ZWkY3g6ZGvguzE9bpJq2GsKnDjLIXo0+mAeY/NvntvFffPg1vXo8O7LISPLRC
	uaA==
X-Google-Smtp-Source: AGHT+IG8EPiSMhHlOTbOIKRkGqJPkC06XyyO6VAgrDJfYIyFwbUDFt3M2LsJyrOMsXQKX2YnKhkmkg==
X-Received: by 2002:a05:6a20:1583:b0:215:d565:3026 with SMTP id adf61e73a8af0-21d22bcb05cmr1923155637.20.1749008638930;
        Tue, 03 Jun 2025 20:43:58 -0700 (PDT)
Received: from met-Virtual-Machine.. ([167.220.110.169])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2eceb02a7csm7809400a12.10.2025.06.03.20.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 20:43:58 -0700 (PDT)
From: meetakshisetiyaoss@gmail.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	nspmangalore@gmail.com,
	bharathsm.hsk@gmail.com,
	pc@manguebit.com,
	lsahlber@redhat.com,
	tom@talpey.com,
	sfrench@samba.org,
	linkinjeon@kernel.org,
	metze@samba.org
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v2] cifs: add documentation for smbdirect setup
Date: Tue,  3 Jun 2025 23:43:52 -0400
Message-ID: <20250604034355.15875-1-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.46.0.46.g406f326d27
In-Reply-To: <CAFTVevUpjG0uQXs4Stj2OggqfGoc8X_6iLgzaVf2V6oTa8eqTA@mail.gmail.com>
References: <CAFTVevUpjG0uQXs4Stj2OggqfGoc8X_6iLgzaVf2V6oTa8eqTA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Meetakshi Setiya <msetiya@microsoft.com>

Document steps to use SMB over RDMA using the linux SMB client and
KSMBD server

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 Documentation/filesystems/smb/smbdirect.rst | 103 ++++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100644 Documentation/filesystems/smb/smbdirect.rst

diff --git a/Documentation/filesystems/smb/smbdirect.rst b/Documentation/filesystems/smb/smbdirect.rst
new file mode 100644
index 000000000000..ca6927c0b2c0
--- /dev/null
+++ b/Documentation/filesystems/smb/smbdirect.rst
@@ -0,0 +1,103 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================
+SMB Direct - SMB3 over RDMA
+===========================
+
+This document describes how to set up the Linux SMB client and server to
+use RDMA.
+
+Overview
+========
+The Linux SMB kernel client supports SMB Direct, which is a transport
+scheme for SMB3 that uses RDMA (Remote Direct Memory Access) to provide
+high throughput and low latencies by bypassing the traditional TCP/IP
+stack.
+SMB Direct on the Linux SMB client can be tested against KSMBD - a
+kernel-space SMB server.
+
+Installation
+=============
+- Install an RDMA device. As long as the RDMA device driver is supported
+  by the kernel, it should work. This includes both software emulators (soft
+  RoCE, soft iWARP) and hardware devices (InfiniBand, RoCE, iWARP).
+
+- Install a kernel with SMB Direct support. The first kernel release to
+  support SMB Direct on both the client and server side is 5.15. Therefore,
+  a distribution compatible with kernel 5.15 or later is required.
+
+- Install cifs-utils, which provides the `mount.cifs` command to mount SMB
+  shares.
+
+- Configure the RDMA stack
+
+  Make sure that your kernel configuration has RDMA support enabled. Under
+  Device Drivers -> Infiniband support, update the kernel configuration to
+  enable Infiniband support.
+
+  Enable the appropriate IB HCA support or iWARP adapter support,
+  depending on your hardware.
+
+  If you are using InfiniBand, enable IP-over-InfiniBand support.
+
+  For soft RDMA, enable either the soft iWARP (`RDMA _SIW`) or soft RoCE
+  (`RDMA_RXE`) module. Install the `iproute2` package and use the
+  `rdma link add` command to load the module and create an
+  RDMA interface.
+
+  e.g. if your local ethernet interface is `eth0`, you can use:
+
+    .. code-block:: bash
+
+        sudo rdma link add siw0 type siw netdev eth0
+
+- Enable SMB Direct support for both the server and the client in the kernel
+  configuration.
+
+    Server Setup
+
+    .. code-block:: text
+
+        Network File Systems  --->
+            <M> SMB3 server support
+                [*] Support for SMB Direct protocol
+
+    Client Setup
+
+    .. code-block:: text
+
+        Network File Systems  --->
+            <M> SMB3 and CIFS support (advanced network filesystem)
+                [*] SMB Direct support
+
+- Build and install the kernel. SMB Direct support will be enabled in the
+  cifs.ko and ksmbd.ko modules.
+
+Setup and Usage
+================
+
+- Set up and start a KSMBD server as described in the `KSMBD documentation
+  <https://www.kernel.org/doc/Documentation/filesystems/smb/ksmbd.rst>`_.
+  Also add the "server multi channel support = yes" parameter to ksmbd.conf.
+
+- On the client, mount the share with `rdma` mount option to use SMB Direct
+  (specify a SMB version 3.0 or higher using `vers`).
+
+  For example:
+
+    .. code-block:: bash
+
+        mount -t cifs //server/share /mnt/point -o vers=3.1.1,rdma
+
+- To verify that the mount is using SMB Direct, you can check dmesg for the
+  following log line after mounting:
+
+    .. code-block:: text
+
+        CIFS: VFS: RDMA transport established
+
+  Or, verify `rdma` mount option for the share in `/proc/mounts`:
+
+    .. code-block:: bash
+
+        cat /proc/mounts | grep cifs
-- 
2.46.0.46.g406f326d27

