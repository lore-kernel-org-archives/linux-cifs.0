Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062ED34F247;
	Fri, 21 Aug 2026 02:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787279121; cv=none; b=fkedYeLFA2GUlyKpjV+we3Hy3YsZaOJS5xVmT+/WTg+HGrFaj6nKDzeokx3+b0N6+QSZYwY+vaUDQDwL9FVodwJ/IasntMjeAt3Fo70znKaiytJUC0wCTN67RfIZ1y7nI2FsVMxPUEHAqM/z3y3pGSOhjMuyHNazvjeyd4d3N6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787279121; c=relaxed/simple;
	bh=wQTM6beaK6PTxgrOPVSSdl6QtDIKyA9idoqJI7R6R4g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qtrPs3I6ho8NbmDKoTYN7M3mQYSabCt56dugXGiPgWNYBGTnxvhNsyrwY5hImGwYOab2px7jUzLbdRlkl90lw1gQ8cGfV37RQFLfyNgoX47PrchJ2rqu8dVO7FGkDJytyFlxO9Jc39Hp/PAE4+UJFilBOa+onBWZZ181vQ1dFwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvKsjhqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvKsjhqN"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A460DC2BCF7;
	Fri, 21 Aug 2026 02:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787279120;
	bh=wQTM6beaK6PTxgrOPVSSdl6QtDIKyA9idoqJI7R6R4g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jvKsjhqNo+xFLn/OcSDK5zfuFcaKB/GorN8tn63DubckDEaqDeKnr5uVp+hyQJbK+
	 sts+NavWdWysQchAnLrKWi9G1MkP3EaJM/Lud/D45lXZe4X3uQ4HsqOwZtwmy60hob
	 E9xkGm2v+VuZTEE+f8COaYEpBvTps0Cr3SVR2SiLCvafdDBm9cTIhWqRiXoyBjcSVQ
	 UxD2OUd2ar/h2mE36Y9ju39ZPg3vo9IYKIldWTw57hNv3ks7Q0iOFvNyR3Y/y6cp+L
	 qcov6MGTJ48t3PrE03xTSwF3gj146FJcWqCjft1wjb9ZfEf60nzIqLVlip7lOvjNtc
	 b+PY+YEJTIBSw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81888C5DF87;
	Fri, 21 Aug 2026 02:25:20 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 20 Aug 2026 21:25:20 -0500
Subject: [PATCH v2 1/2] smb: client: let enum smb_eio_trace grow past 128
 entries
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-b4-disp-58f78a28-v2-1-1fb7a6cb1533@proton.me>
References: <20260820-b4-disp-58f78a28-v2-0-1fb7a6cb1533@proton.me>
In-Reply-To: <20260820-b4-disp-58f78a28-v2-0-1fb7a6cb1533@proton.me>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 David Howells <dhowells@redhat.com>, Nathan Chancellor <nathan@kernel.org>, 
 Tom Talpey <tom@talpey.com>, llvm@lists.linux.dev, 
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, samba-technical@lists.samba.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787279119; l=1542;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=YvTTyIT31HzfaHafhvdDaEF4Yp7y/hBcBtCYI66qIN0=;
 b=+fmSYrkWQ/ibMuxZoOEsck2vdKIXuyZrUtH2QNbeuIaeo7CHWxQxBW9qmG8ba92a7DP3Tr4SH
 3PbT331+1oSB7oS4CDzWfHe/C2Sws3RnNq5YPIL9LM/2qg9AQXVMsby
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

enum smb_eio_trace is __mode(byte) and the list has held exactly 128
entries since it was added, so the last sits at index 127 and a 129th has
no representable value.  clang gives the enum a signed underlying type and
converts the overflowing value to -128; x86_64 defconfig turns that into a
build failure because it sets CONFIG_WERROR=y, and where it does not, the
value stops matching the __print_symbolic() table and those events print a
raw number.  gcc picks an unsigned underlying type and reports nothing.

Drop the attribute.  On x86_64 the record does not grow: the field
precedes an unsigned long at offset 8 of struct trace_event_raw_smb3_eio,
so sizeof() stays 32 either way.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607290344.fvDmgRPA-lkp@intel.com/
Fixes: f80ac7eda1cf ("cifs: Add a tracepoint to log EIO errors")
Cc: stable@kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 fs/smb/client/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 5b21ad3c15fb..0a91d3aaa079 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -213,7 +213,7 @@
 #define EM(a, b) a,
 #define E_(a, b) a
 
-enum smb_eio_trace		{ smb_eio_traces } __mode(byte);
+enum smb_eio_trace		{ smb_eio_traces };
 enum smb3_rw_credits_trace	{ smb3_rw_credits_traces } __mode(byte);
 enum smb3_tcon_ref_trace	{ smb3_tcon_ref_traces } __mode(byte);
 

-- 
2.55.0


