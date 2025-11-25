Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EEC2E174B
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 20:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764104318; cv=none; b=gvmLGPOBudqb8z7M0CMLjcfjsoC58TPd09h4LOLwxMEtg/7mq68L9vzfuU1CXQml76IE6GR+tsgJ8SLvxUEBQsh7ywfC6dp5aueIOoGjitGBPqBF3SLr6pmbgnLhVBIvIfxx5V8LrbO4Iey8NWRXZphO3fVwuejO9f3cr1Ru2Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764104318; c=relaxed/simple;
	bh=qUZC62UhjVGj6LhVaeT/i3UPJRQdXrciIBlede3gKqc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fpkFwvvXIx50vtRVDL5z29U56tByp24jyGdz+rafnZtgJIQoy0NoUtPmGdWcXLaLZJvM4QfTwSuoCeqA8vlYUdQuY65IR+uGHNc/G8J0oDJF1glDmzPPcPX/yXYdZu1L4ctRHjlYdhz/VdZX+5oCBT4J1H5sM3gYyWQutss/eEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=RnhFON+k; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="RnhFON+k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Jzxm+b9jn4bqIdzT6ylxeX1sZxOAc92rnbBzcGu4ShY=; b=RnhFON+kaGSXlHa3WCJkIkn05s
	gZJf9TwhQsgHh6FPZRP81swa7Uzz9hle7ZzBdmTVcUKJQ/Q1I6xyxNyasqblQHgDY/G1Duntzny5g
	ai3bD3ZDATmPteXesB7XOe0KEsjD9JYkwYQ+Yajb+rpHiHcuTr1+MV1Fo9kQ4jjS3AVQvUgGele7h
	6Jk2NSpyXk05n4A4wVOlxL1ITZI4dNWY9iUTBORiXj+riQgsNxqtT69WhUoZG+t/79rbj3cnUBS6G
	nKLQZxszKglZq34AXPLBgsnogpFmsKuOz/UBnOKjjYF+DrAGk3mdpu6IJFFJ/1RMBesKn+jO3Q1OK
	zn6lA7gg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vO07I-00000000V4q-1JJI;
	Tue, 25 Nov 2025 17:58:29 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: piastryyy@gmail.com
Cc: Alexandros Panagiotou <apanagio@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] docs: update echo_interval description
Date: Tue, 25 Nov 2025 17:58:29 -0300
Message-ID: <20251125205829.1709717-1-pc@manguebit.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is '3 * echo_interval' since upstream commit f2caf901c1b7 ("cifs:
Fix a race condition with cifs_echo_request").

Reported-by: Alexandros Panagiotou <apanagio@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
---
 mount.cifs.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.rst b/mount.cifs.rst
index d4890706a0fe..4b6d47447c0e 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -483,8 +483,8 @@ echo_interval=n
   sets the interval at which echo requests are sent to the server on an
   idling connection. This setting also affects the time required for a
   connection to an unresponsive server to timeout. Here n is the echo
-  interval in seconds. The reconnection happens at twice the value of the
-  echo_interval set for an unresponsive server.
+  interval in seconds. The reconnection happens at three times the
+  value of the echo_interval set for an unresponsive server.
   If this option is not given then the default value of 60 seconds is used.
   The minimum tunable value is 1 second and maximum can go up to 600 seconds.
 
-- 
2.51.1

