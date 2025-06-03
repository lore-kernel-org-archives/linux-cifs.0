Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B581F2BB5
	for <linux-cifs@vger.kernel.org>; Tue,  3 Jun 2025 04:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748925005; cv=none; b=c8mJsB9Q2SPlBGzO/tt2AjxIssENBBwxI3pJBn1U64ahp027oszVbsDR/6kD67Seg/HkpdmDLESmEHoltLt63ydAflMAB+5ktPd9WAAeCa/H8DfyqCFSO7L/dDjUNktqGESrC/8f7SsG1Hd8uwMVazh8kslgYdFGNFfK1Jp3vbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748925005; c=relaxed/simple;
	bh=nxdIuJCvNRRuEPgH/7HmKcifNVVjW01Q4K27XmjGZpI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YqCdh4Ha5fRWPPeI1fprb1X+ntNR5BGohdSC+7zhAYvGJb5P6AUz1HkJ08HRzolx0jz359v0vtTX/Io4lSXsI6QiFKWcwYQhDY9z0tS2vrWf8iDhru2C2GOVcOEJwtGP2QTVQ2ZQ8EHyLCF1ICsXEVGWRcEg8bAFsszIhJjgeaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RZB8cfOo; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RZB8cfOo"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-311e993f49aso4113359a91.0
        for <linux-cifs@vger.kernel.org>; Mon, 02 Jun 2025 21:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748925002; x=1749529802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rCDgWXlvmxZDlerlL1CWxb6hsIlPdbVVDmLKsgDq81s=;
        b=RZB8cfOoAB0FBKX5r12tDY9dByePcLU+38ptzp9VbAmEMfgGfIZ7lrAr4oKv5IR/gD
         jvN+4PtTyUWfjOdpkSbY8xc8MTIeq8uDO9gmmDw+tleUsqpMBVlTueDbC0Vb4/E9BPMU
         Tg1p5he65rwmvfUuEW4QZ0/yl7FIAVUd/pBlFvvqo+epzJmVnfelghFZZzqa2fRCPNss
         cjdCS446j3ID5ncoLiZ157lDAiSUwinEhHZeDvmvT/CEkDLj2ZGEFEnEN8EszDa7ZzRT
         Rdgk4TQLBeXOtuyQY+LfiaX0izkR54v+HozC3REWqv+bRrkdt08Io+7F/JrCzrOjgzI0
         XXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748925002; x=1749529802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rCDgWXlvmxZDlerlL1CWxb6hsIlPdbVVDmLKsgDq81s=;
        b=AqY6kDcD3YGbA/zXk+lmmkc4go8gElstIcTtUo+i4vKa4ZAvKVe+Ddn1D5IsjT38gZ
         WUmmiSt5LO0GHUUe++hmvJshh1jSs4PaJu6tNgQT1cvbYvaldvzqSaGZiU78mPg1p5+B
         /FmGx3uGl8f3WuwzY36VCu2/bgCODFfisw/2T3qwLn71lJjwArsrgXAonqIAh5VFB+wG
         yuoiordDkin854y/59JBKvFRJLSkzZ/VMJ4C6NdZeIp/pmYShpRKit3/NskoQAoDQFqr
         ygNs2YJOdN3GQP3stu7QNC+wvCv/YDl+wh5/dSfqU9sGLlACAHRdovTT5JW6lIdd4RKS
         8m9w==
X-Gm-Message-State: AOJu0YxnzU6Aha2x0mmrVsfC8WXUwHrWipR/uIUlEi7e0gg5ION/ET+A
	z30mrAbp7d3htds4DHYpVmOuXoLqTW7qaHnZol70nF8E8wo4IMdQNzdA0RRFXDRRP5o=
X-Gm-Gg: ASbGncsJCAaiHWsSxyg24/mhr+fna6ohkxLSnCRi3z5dWvSrNIv/0MDDLsKFp+O6X3F
	x3eaZ+/5daZtX6D9hnYIcDg+g24KB8HncblEmnW0vsL+SCE38Ioyzw0wOwfg0FDIQ7HVTYaAv7G
	MuKfZib1vN4biwPR/QzJxh7ta4IZ8IP0yk966xKggvqJjhvF3MmqEYWz7chy88q88DowgZLDF39
	GwH61RNZTpNvaWo4otlF+YV3FIJCcwyxwmLANG5iSpOZwD5aRpCcOwH0qqzZbcOcPROBE/SRvma
	3ofTdFn3nmjyUf4YoVQ3yLmLaSR9xgyOWgsLCfo1R7m+0byy1xRTu46dCF7bq8qQ+JIjgZ/FUtH
	y/mADelfu7z4=
X-Google-Smtp-Source: AGHT+IFZ0gz0+nuNavkceNMiamtTWdCqlwfwnviIPJO6+EfnZRROp+S6N803m9m0XCx81Yhsfvy5Pg==
X-Received: by 2002:a17:90b:5288:b0:312:ec:4128 with SMTP id 98e67ed59e1d1-31250476af1mr19990463a91.34.1748925002386;
        Mon, 02 Jun 2025 21:30:02 -0700 (PDT)
Received: from met-Virtual-Machine.. ([167.220.110.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3124e3d2834sm6421739a91.43.2025.06.02.21.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 21:30:01 -0700 (PDT)
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
Subject: [PATCH] cifs: add documentation for smbdirect setup
Date: Tue,  3 Jun 2025 00:29:55 -0400
Message-ID: <20250603042958.9862-1-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.46.0.46.g406f326d27
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
 Documentation/filesystems/smb/smbdirect.rst | 91 +++++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 Documentation/filesystems/smb/smbdirect.rst

diff --git a/Documentation/filesystems/smb/smbdirect.rst b/Documentation/filesystems/smb/smbdirect.rst
new file mode 100644
index 000000000000..98dec004a058
--- /dev/null
+++ b/Documentation/filesystems/smb/smbdirect.rst
@@ -0,0 +1,91 @@
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
+  depending on your setup.
+
+  If you are using InfiniBand, enable IP-over-InfiniBand support.
+
+- Enable SMB Direct support for both the server and the client in the
+  kernel configuration.
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

