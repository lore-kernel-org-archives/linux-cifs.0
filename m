Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDEB1C3F10
	for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 19:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723836494; cv=none; b=lFR+Bm7r7y3LwHMvbXsSAw1LClnbi2iMJe9zmNaA6MKdaKrDjlI7gki5J1i0Ynr3A2M4LFLQMfsGPhKVQ+shRvE4JTXnJpCW2lgGM60ct56Qr4tvmD8N/jv1NzzNReduppbO30rytjxF6f+3WRPyxy0J16oSq2o7YfaxqPCXIas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723836494; c=relaxed/simple;
	bh=O6mzyL7xKu1MY9cqmZeVStxQtxMoAMbvocNe+lKzux0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WcMEe3gI2mYeFCnv5s06qMf9M0gOJsLYUZ9NB7+Lh3IZTlkSuDJwsu6W2EbU/vG9HetsGYPT95EqI/jO4FmsBrRm8toY5qcsRqJFi8pPV+uU9+CItAr/nrHeAF1i4+IC3wchEQ33caSoQqdzh7FNuZS88cI/sDUaFKXLBz4Q8+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vtimothy.com; spf=pass smtp.mailfrom=vtimothy.com; dkim=pass (2048-bit key) header.d=vtimothy.com header.i=@vtimothy.com header.b=jb917UCN; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vtimothy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vtimothy.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vtimothy.com header.i=@vtimothy.com header.b="jb917UCN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vtimothy.com;
	s=protonmail; t=1723836476; x=1724095676;
	bh=tTkOD+tbanlBDXETUZCRAs2rYgp1pBquWtd/axPjhUo=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=jb917UCNFzje5oThUt77wlPGq9iHVDNzeHKjINZy31HhBrHVEq8Sh2TCdMJ2EmPro
	 77u+xVjkKKQjUkE2jXqVSk7RqNXKiCCq/hsjBdlaycHzPnlCtEP9ReWD2wV171gaZA
	 eURz45Jt8HsfiPwdxHgS3elXlVGgWN8yHF5TqtcurvdDAjq5gZjHoQYEIhkXDSRPzl
	 Dg6U5j3uFo+eNJ3/c4rc/JM1PrYiXuqTKNwa5pVsQFFmC/DXVweCrjSyjHOWNoD9sg
	 mF1UXSeY060RHXETS/W0AOZnQ9kxggWXPGH3SbxVE7MFK/hNa2Z3yZP7j6SAn9eS1k
	 RjnCbuMxbQLpw==
X-Pm-Submission-Id: 4WlsTH3R6Lz4wwdW
From: Victor Timofei <victor@vtimothy.com>
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	corbet@lwn.net
Cc: linux-cifs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org,
	skhan@linuxfoundation.org,
	Victor Timofei <victor@vtimothy.com>
Subject: [PATCH] ksmdb: fix spelling mistakes in documentation
Date: Fri, 16 Aug 2024 22:24:52 +0300
Message-ID: <20240816192452.38211-1-victor@vtimothy.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are a couple of spelling mistakes in the documentation. This patch
fixes them.

Signed-off-by: Victor Timofei <victor@vtimothy.com>
---
 Documentation/filesystems/smb/ksmbd.rst | 26 ++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/smb/ksmbd.rst b/Documentation/filesystems/smb/ksmbd.rst
index 6b30e43a0d11..8f00b2f3da31 100644
--- a/Documentation/filesystems/smb/ksmbd.rst
+++ b/Documentation/filesystems/smb/ksmbd.rst
@@ -13,7 +13,7 @@ KSMBD architecture
 The subset of performance related operations belong in kernelspace and
 the other subset which belong to operations which are not really related with
 performance in userspace. So, DCE/RPC management that has historically resulted
-into number of buffer overflow issues and dangerous security bugs and user
+into a number of buffer overflow issues and dangerous security bugs and user
 account management are implemented in user space as ksmbd.mountd.
 File operations that are related with performance (open/read/write/close etc.)
 in kernel space (ksmbd). This also allows for easier integration with VFS
@@ -24,8 +24,8 @@ ksmbd (kernel daemon)
 
 When the server daemon is started, It starts up a forker thread
 (ksmbd/interface name) at initialization time and open a dedicated port 445
-for listening to SMB requests. Whenever new clients make request, Forker
-thread will accept the client connection and fork a new thread for dedicated
+for listening to SMB requests. Whenever new clients make a request, the Forker
+thread will accept the client connection and fork a new thread for a dedicated
 communication channel between the client and the server. It allows for parallel
 processing of SMB requests(commands) from clients as well as allowing for new
 clients to make new connections. Each instance is named ksmbd/1~n(port number)
@@ -34,12 +34,12 @@ thread can decide to pass through the commands to the user space (ksmbd.mountd),
 currently DCE/RPC commands are identified to be handled through the user space.
 To further utilize the linux kernel, it has been chosen to process the commands
 as workitems and to be executed in the handlers of the ksmbd-io kworker threads.
-It allows for multiplexing of the handlers as the kernel take care of initiating
+It allows for multiplexing of the handlers as the kernel takes care of initiating
 extra worker threads if the load is increased and vice versa, if the load is
-decreased it destroys the extra worker threads. So, after connection is
-established with client. Dedicated ksmbd/1..n(port number) takes complete
+decreased it destroys the extra worker threads. So, after the connection is
+established with the client. Dedicated ksmbd/1..n(port number) takes complete
 ownership of receiving/parsing of SMB commands. Each received command is worked
-in parallel i.e., There can be multiple clients commands which are worked in
+in parallel i.e., There can be multiple client commands which are worked in
 parallel. After receiving each command a separated kernel workitem is prepared
 for each command which is further queued to be handled by ksmbd-io kworkers.
 So, each SMB workitem is queued to the kworkers. This allows the benefit of load
@@ -49,9 +49,9 @@ performance by handling client commands in parallel.
 ksmbd.mountd (user space daemon)
 --------------------------------
 
-ksmbd.mountd is userspace process to, transfer user account and password that
+ksmbd.mountd is a userspace process to, transfer the user account and password that
 are registered using ksmbd.adduser (part of utils for user space). Further it
-allows sharing information parameters that parsed from smb.conf to ksmbd in
+allows sharing information parameters that are parsed from smb.conf to ksmbd in
 kernel. For the execution part it has a daemon which is continuously running
 and connected to the kernel interface using netlink socket, it waits for the
 requests (dcerpc and share/user info). It handles RPC calls (at a minimum few
@@ -124,7 +124,7 @@ How to run
 1. Download ksmbd-tools(https://github.com/cifsd-team/ksmbd-tools/releases) and
    compile them.
 
-   - Refer README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
+   - Refer to README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
      to know how to use ksmbd.mountd/adduser/addshare/control utils
 
      $ ./autogen.sh
@@ -133,7 +133,7 @@ How to run
 
 2. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in ksmbd.conf file.
 
-   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
+   - Refer to ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
      for details to configure shares.
 
         $ man ksmbd.conf
@@ -145,7 +145,7 @@ How to run
      $ man ksmbd.adduser
      $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
 
-4. Insert ksmbd.ko module after build your kernel. No need to load module
+4. Insert the ksmbd.ko module after you build your kernel. No need to load the module
    if ksmbd is built into the kernel.
 
    - Set ksmbd in menuconfig(e.g. $ make menuconfig)
@@ -175,7 +175,7 @@ Each layer
 1. Enable all component prints
 	# sudo ksmbd.control -d "all"
 
-2. Enable one of components (smb, auth, vfs, oplock, ipc, conn, rdma)
+2. Enable one of the components (smb, auth, vfs, oplock, ipc, conn, rdma)
 	# sudo ksmbd.control -d "smb"
 
 3. Show what prints are enabled.
-- 
2.46.0

