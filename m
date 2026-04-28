Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B272439005
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392033; cv=none; b=LWXcmPQhEEmMk1TYzDKunALrnDDFSrkEdSUFhFOawo4l5rVSYaIVURADa5hj0JaaW5aEO7gbXrZDAPcUOqldSrMsQignM4+3R8D9z0Y2hfoZb1g9gFWdqSfbmpvve33M78qdB+O2CObfKsuSbDJtck+GZJVdNvX7YBakVHG0bwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392033; c=relaxed/simple;
	bh=9l6Zn4WQCZSZfbxZtAvKLch/4uMIOw9Dd0LhEB1yBb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DIZFFvBVwtJjuJ8+iNVLKNNzFhdTIZsBvgb4im20UfdfgzEfTtrEVwZmYKDwuP0UoZpeM4BJr/d5EtRZY5iICq25QKLQ67CJZaDVh62IwBqvAUcfAumlDTJxBMaeRPDez2yLdwrm2ttL4DrfMFvwzOjNmT1Eex3kEhCT3L0N0pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Epl9Kqyt; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Epl9Kqyt"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so142472905e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777392031; x=1777996831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NJULVraPYnaUtno+Mw7BPPXxWq+DJtTZsScFGIZf28I=;
        b=Epl9Kqytdc9aUOumvYPp66hgi711q1hgERYZfX8JYY/UvLYBxHxtYuE+BGxo+Oy1fi
         p4V1JU2Xra0wdZQkOVwRiqwCfdLExNYZYglzG2IzVc6xqVsRGHsrYxNdvrkGCCjPl1us
         lDM45w7nOYcXb2Y2nh4pVT+kyBYpQI/Y06dJtYtEeYoVqzXUfnWym9HlkxJ0WDbCk4gu
         ESSYWWcfN5o1vFicK9Yb45ayGHMSLSLBf8cnbD3xrbjNb5hVsm22iGeYK60sowhtNopG
         uU6lJI6ZxAp2FfhPH2MmiUHS3mYQotIsMbR+DXfd8h9v0Dyje1LxBl1r4PC+38JjChVy
         CGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392031; x=1777996831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJULVraPYnaUtno+Mw7BPPXxWq+DJtTZsScFGIZf28I=;
        b=Gjv3IPPTai9fhHdaQQBAiWIbqzJlymIpB4wODuRMeHNUS35VjmSLRN/KaTLFHQsc14
         IJFWI+1CEczW8FhvXyu4eSPw3UZstWP7GbSDRnAcSXbUEpUJH+tg7ZokMeurZHN7aEau
         dZk2iiCJRosotDI4hzIMW8Ucs8QI54tfZKn+eHDbGj5BoeMef594cvHY5ruGJyH5AAG4
         PwJC4CzfB8csauRv8jtw9cngKElQHiF5TBPUduh13S2ZzfsR+pvYzbwym4i15L9VQbOS
         NzXHQkGtHJKo3J+c7qEavbQv4CJ7nRvwN5dcp+QLYjtCiiyJRpqswAZilm6LZg8bA0Wd
         mOUg==
X-Forwarded-Encrypted: i=1; AFNElJ8Vd8wNyU4tjOlNOPSMS7ACGDMCMWnOStfnCzzzd9oO1gAiE7O3+gF/f8+cUSJomX1XedKJlzxRYqit@vger.kernel.org
X-Gm-Message-State: AOJu0YzTsSqViFu1IyNS/pozovMor/IbjFM9DB6E/85BurBxqIE6DYNp
	UNDIdILwmG138FgWWMQwdDSXQiYRcls9Am5YLOSnVa2+AIyJgOnrUNrGcoUrCZCHZlpyb3Z2Xtw
	ZOaQJxMfcNw==
X-Gm-Gg: AeBDieu9O3ww74gF0FXbM8GbnZxRBuyZhaSdlrHFBdQPkNbUi7sACTfB+75OoPlo+cR
	X8QFJFyhxUk7kCAYX1VxpFtdZd8RKspcEMKhul205h8N+MK6siPur8A6bf1NTXU0NYcUgdm0c3t
	OSjO34J4ca++k17ejkff3E8JtsOQQHvwjp+W9n26wuFLmZtW8hTUpWTbtm6Y50r/l5/Mnx/5QQr
	/VTpE9VqwSmLkg3fxnDaiF2FHBAuvJ8K4qynvjFfg7LfYbYQcxbxmMPovdcnE91+S2VbXUGD3ug
	IvaH9zcG+g3th45xtq0NeIFFh0vK4tD0NaA/F09Z/gIUjywlLC2CgmA68Y9s8VxhBRnADm+HXns
	glHWPFoAZ+HNqNiTVG9cHn8m8X7ZV1w8RoluZkqf6sFupleR21iVoRNFGNDAsqKLubuQsUWtrKL
	0H1Aoe9S6FPHe8XqL4BPWQdvC85dOhqu2tzmGw8j4uDXeZ
X-Received: by 2002:a05:6000:2c01:b0:43d:73de:abd2 with SMTP id ffacd0b85a97d-4464a168597mr6674016f8f.26.1777392030417;
        Tue, 28 Apr 2026 09:00:30 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4464004edc8sm7505041f8f.37.2026.04.28.09.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:00:29 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: corbet@lwn.net
Cc: linux-doc@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	sfrench@samba.org,
	linkinjeon@kernel.org,
	metze@samba.org,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 11/11] docs: smb: document SMB3 over QUIC setup for cifs.ko and ksmbd.ko
Date: Tue, 28 Apr 2026 13:00:20 -0300
Message-ID: <20260428160020.226512-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add quic.rst covering setup for SMB over QUIC between the kernel SMB
server (ksmbd.ko) and client (cifs.ko).

Update index.rst to include quic.rst in the SMB documentation tree.

Update ksmbd.rst feature table: SMB3.1.1 over QUIC is now Experimental
(previously listed as Planned for future).

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 Documentation/filesystems/smb/index.rst |   1 +
 Documentation/filesystems/smb/ksmbd.rst |   2 +-
 Documentation/filesystems/smb/quic.rst  | 332 ++++++++++++++++++++++++
 3 files changed, 334 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/filesystems/smb/quic.rst

diff --git a/Documentation/filesystems/smb/index.rst b/Documentation/filesystems/smb/index.rst
index 6df23b0e45c8..e75ebba0e739 100644
--- a/Documentation/filesystems/smb/index.rst
+++ b/Documentation/filesystems/smb/index.rst
@@ -9,3 +9,4 @@ CIFS
    ksmbd
    cifsroot
    smbdirect
+   quic
diff --git a/Documentation/filesystems/smb/ksmbd.rst b/Documentation/filesystems/smb/ksmbd.rst
index 67cb68ea6e68..de00adc73a8f 100644
--- a/Documentation/filesystems/smb/ksmbd.rst
+++ b/Documentation/filesystems/smb/ksmbd.rst
@@ -112,7 +112,7 @@ DCE/RPC support                Partially Supported. a few calls(NetShareEnumAll,
 ksmbd/nfsd interoperability    Planned for future. The features that ksmbd
                                support are Leases, Notify, ACLs and Share modes.
 SMB3.1.1 Compression           Planned for future.
-SMB3.1.1 over QUIC             Planned for future.
+SMB3.1.1 over QUIC             Experimental. See quic.rst.
 Signing/Encryption over RDMA   Planned for future.
 SMB3.1.1 GMAC signing support  Planned for future.
 ============================== =================================================
diff --git a/Documentation/filesystems/smb/quic.rst b/Documentation/filesystems/smb/quic.rst
new file mode 100644
index 000000000000..016a29e7bb27
--- /dev/null
+++ b/Documentation/filesystems/smb/quic.rst
@@ -0,0 +1,332 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========================================
+SMB3 over QUIC with ksmbd.ko and cifs.ko
+========================================
+
+This is a setup note for testing SMB3 over QUIC between the Linux kernel SMB
+server (ksmbd.ko) and the Linux kernel SMB client (cifs.ko).
+
+Requirements
+============
+
+- Kernel options for QUIC and the in-kernel handshake path:
+
+  .. code-block:: text
+
+      CONFIG_IP_QUIC
+      CONFIG_NET_HANDSHAKE
+
+- Kernel options for key handling:
+
+  .. code-block:: text
+
+      CONFIG_KEYS
+      CONFIG_ASYMMETRIC_KEY_TYPE
+      CONFIG_X509_CERTIFICATE_PARSER
+      CONFIG_PKCS8_PRIVATE_KEY_PARSER
+
+- Kernel options for SMB:
+
+  .. code-block:: text
+
+      CONFIG_SMB_SERVER
+      CONFIG_CIFS
+
+- SMB version 3.1.1 or higher.
+
+- QUIC delegates the TLS handshake to a userspace component. Here we use
+  the userspace handshake agent tlshd. See Documentation/networking/quic.rst
+  and Documentation/networking/tls-handshake.rst.
+
+Configuring tlshd
+=================
+
+Load the certificate and key into tlshd by, either using a by using the
+pathnames or by using a keyring.
+
+Using Pathnames
+===============
+
+If mutual authentication is used, the same will have to be done in the client system.
+
+The second option is by using pathnames to the certificate and private key.
+
+Add the following to the configuration file inside the server machine:
+
+.. code-block:: txt
+
+        [authenticate.server]
+        x509.certificate=/path/to/smb-server-cert.pem
+        x509.private_key=/path/to/smb-server-key.pem
+
+If you are using mutual authentication, the following will have to be done in the client machine:
+
+.. code-block:: txt
+
+        [authenticate.client]
+        x509.certificate=/path/to/smb-client-cert.pem
+        x509.private_key=/path/to/smb-client-key.pem
+
+For more information about these fields, see `man tlshd.conf`
+
+Using Keyrings
+==============
+
+Instead of using file paths, certificates and private keys can be loaded
+from a kernel keyring. This avoids exposing key material via filesystem paths.
+
+Enable keyring usage in tlshd:
+
+.. code-block:: txt
+
+    keyrings=smb
+
+Keys must be added to the keyring named `smb`.
+
+On both client and server:
+
+.. code-block:: bash
+
+    keyctl newring smb @u
+
+    keyctl padd asymmetric "smb-ca" %keyring:smb < /etc/ssl/certs/ca-cert.pem
+
+On server:
+
+.. code-block:: bash
+
+    keyctl padd asymmetric "smb-server-cert" %keyring:smb < /etc/ssl/certs/smb-server-cert.pem
+
+    keyctl padd asymmetric "smb-server-key" %keyring:smb < /etc/ssl/private/smb-server-key.pem
+
+On client:
+
+.. code-block:: bash
+
+    keyctl padd asymmetric "smb-client-cert" %keyring:smb < /etc/ssl/certs/smb-client-cert.pem
+
+    keyctl padd asymmetric "smb-client-key" %keyring:smb < /etc/ssl/private/smb-client-key.pem
+
+When using keyrings, do not specify file paths.
+
+Server:
+
+.. code-block:: txt
+
+    [authenticate.server]
+    x509.certificate=smb-server-cert
+    x509.private_key=smb-server-key
+    x509.truststore=smb-ca
+
+Client:
+
+.. code-block:: txt
+
+    [authenticate.client]
+    x509.certificate=smb-client-cert
+    x509.private_key=smb-client-key
+    x509.truststore=smb-ca
+
+Restart tlshd service after modifying the configuration.
+
+Running CIFS with SMB QUIC
+==========================
+
+After tlshd is configured, mount the CIFS filesystem with the mount option
+`quic`. Example using mount.smb3 from cifs-utils package:
+
+.. code-block:: bash
+
+        mount.smb3 //server.example.com/share /mnt -o quic
+
+If mutual authentication is used, run with `mtls` mount option:
+
+.. code-block:: bash
+
+        mount.smb3 //server.example.com/share /mnt -o quic,mtls
+
+QUIC works on top of TLS 1.3, so it has its own transport layer
+encryption. It is possible, however, to mount CIFS with:
+
+.. code-block:: bash
+
+        mount.smb3 //server.example.com/share/mnt -o quic,seal
+
+Testing SMB QUIC Implementation
+===============================
+
+For proper TLS and mTLS testing, use a local Certificate Authority (CA)
+instead of self-signed leaf certificates.
+
+This avoids validation issues and matches real deployments.
+
+Certificate Layout
+==================
+
+- CA (created once, can be on a third machine or server)
+- Server certificate (signed by CA)
+- Client certificate (signed by CA)
+
+The CA certificate must be present on both client and server.
+
+Creating a CA
+=============
+
+Run on a trusted machine (server or separate host):
+
+.. code-block:: bash
+
+    mkdir -p /etc/ssl/smb-ca
+    cd /etc/ssl/smb-ca
+
+    openssl genpkey -algorithm RSA \
+        -pkeyopt rsa_keygen_bits:4096 \
+        -out ca-key.pem
+
+    openssl req -x509 -new \
+        -key ca-key.pem \
+        -sha256 -days 3650 \
+        -subj "/CN=SMB Test CA" \
+        -addext "basicConstraints=critical,CA:TRUE" \
+        -addext "keyUsage=critical,keyCertSign,cRLSign" \
+        -out ca-cert.pem
+
+Distribute:
+
+- Copy `ca-cert.pem` to both client and server:
+  - /etc/ssl/certs/ca-cert.pem
+
+Creating Server Certificate
+===========================
+
+Run on server:
+
+.. code-block:: bash
+
+    openssl genpkey -algorithm RSA \
+        -pkeyopt rsa_keygen_bits:2048 \
+        -out /etc/ssl/private/smb-server-key.pem
+
+    openssl req -new \
+        -key /etc/ssl/private/smb-server-key.pem \
+        -subj "/CN=server.example.com" \
+        -out smb-server.csr
+
+Copy `smb-server.csr` to CA machine and sign:
+
+.. code-block:: bash
+
+    openssl x509 -req \
+        -in smb-server.csr \
+        -CA ca-cert.pem \
+        -CAkey ca-key.pem \
+        -CAcreateserial \
+        -out smb-server-cert.pem \
+        -days 365 -sha256 \
+        -extfile <(cat <<EOF
+basicConstraints=critical,CA:FALSE
+keyUsage=critical,digitalSignature,keyEncipherment
+extendedKeyUsage=serverAuth
+subjectAltName=DNS:server.example.com
+EOF
+)
+
+Copy back to server:
+
+- /etc/ssl/certs/smb-server-cert.pem
+
+Creating Client Certificate (for mTLS)
+======================================
+
+Run on client:
+
+.. code-block:: bash
+
+    openssl genpkey -algorithm RSA \
+        -pkeyopt rsa_keygen_bits:2048 \
+        -out /etc/ssl/private/smb-client-key.pem
+
+    openssl req -new \
+        -key /etc/ssl/private/smb-client-key.pem \
+        -subj "/CN=client.example.com" \
+        -out smb-client.csr
+
+Copy `smb-client.csr` to CA machine and sign:
+
+.. code-block:: bash
+
+    openssl x509 -req \
+        -in smb-client.csr \
+        -CA ca-cert.pem \
+        -CAkey ca-key.pem \
+        -CAcreateserial \
+        -out smb-client-cert.pem \
+        -days 365 -sha256 \
+        -extfile <(cat <<EOF
+basicConstraints=critical,CA:FALSE
+keyUsage=critical,digitalSignature
+extendedKeyUsage=clientAuth
+subjectAltName=DNS:client.example.com
+EOF
+)
+
+Copy back to client:
+
+- /etc/ssl/certs/smb-client-cert.pem
+
+tlshd Configuration
+===================
+
+Server:
+
+.. code-block:: txt
+
+    [authenticate.server]
+    x509.certificate=/etc/ssl/certs/smb-server-cert.pem
+    x509.private_key=/etc/ssl/private/smb-server-key.pem
+    x509.truststore=/etc/ssl/certs/ca-cert.pem
+
+Client (mTLS):
+
+.. code-block:: txt
+
+    [authenticate.client]
+    x509.certificate=/etc/ssl/certs/smb-client-cert.pem
+    x509.private_key=/etc/ssl/private/smb-client-key.pem
+    x509.truststore=/etc/ssl/certs/ca-cert.pem
+
+Restart tlshd on both systems after changes.
+
+Testing ksmbd with smbtorture and smbclient
+===========================================
+
+[TODO: REVIEW && TEST]
+
+With smbclient or smbtorture:
+
+.. code-block:: bash
+
+    --option='client smb transports = quic'
+
+Avoid:
+
+.. code-block:: bash
+
+    --option='tls verify peer=no_check'
+
+unless debugging, as it disables certificate validation.
+
+Samba server config:
+
+.. code-block:: txt
+
+    server smb transports = +quic
+
+Optional:
+
+- force userspace QUIC:
+  --option='client smb transport:force_ngtcp2_quic=yes'
+
+- disable double encryption:
+  --option='client smb encryption over quic=no'
-- 
2.53.0

