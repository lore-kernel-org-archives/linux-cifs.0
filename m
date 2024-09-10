Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAE016F282;
	Tue, 10 Sep 2024 02:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725935514; cv=none; b=AF3w6XwRSeDoQdYQlA9JgONRuHiujAMg0AR6wTpWcE+rR/WLekxNP8QYusJWHxbPZR7zFD27sYgUxW8+efTiV9a6u2pk6NWnQYClYVCFyg8xwJrpCH0uu8OFOn6SAznrDaMLNiTShGvcbE0hCpRzPiZgL0qMASPe30T/ZR2IoLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725935514; c=relaxed/simple;
	bh=whdQSjZneoPJNZAGMkzH4Ot3vxOcc8FUgllwm3sy+G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTPiRkPrv2tvYV9idZe2D/zeCiHPYLXY14Am36GiyA+5i48xKno6ItkplETrUt7UVUfdrRRbGEYJw4/npM8cV1cXWAcVb+TsC3OKFhwKnic7i9BuhdE74rdkPqBtnFfrJrC/fvBzhzp5JZkadzR2ryah0Yo5gRx99vUyli0oW38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jsm8Lcd5; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jsm8Lcd5"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7a9ac0092d9so192635685a.1;
        Mon, 09 Sep 2024 19:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725935511; x=1726540311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lCv8AVDIqwg8TKHkrL3M4Scd4I7xNNdeDOFxfgf/ie0=;
        b=jsm8Lcd5ZbJpX2+mc/xRfcZ0bdkvqJexPwZpTE1GwTHhva0T2LtnL0/BKf5dndJQfj
         9HKEWlUcBMOPd+I5vlTzChJoApyx0UsELdYmwcGoKlWkt8VWNClIPY0xPYxBLNKTm/rI
         jddSgQHJnRc9dfxLzp6Ic3NcBn1ldIlx2dDXlBGe4OhQuWciXJrDOw2VzDr7cGMeADkf
         SwKqW30CBD0CBaSH7cOXsuJPPRzdAE2RnwmQFBj97bTsOcdBm4naMZl74brVx4lQXMvd
         IukbAzg2AKTo78dIjcvQJvWp2BjiQAUKHXjHuYHLGsbRiNO3jFYbC9xy2Q6GdNVcGFkY
         FYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725935511; x=1726540311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lCv8AVDIqwg8TKHkrL3M4Scd4I7xNNdeDOFxfgf/ie0=;
        b=U2l7FIuwfuS2ncAP1syjVwCIpIjUfauKOZDf5huAdg2TdjuPxd25AwIj+TKiMb+zws
         rQsQQNjhsX9hX0y3inKMikdF62a2+mp1chTpggLYqtwgZIwTGqKpNvMHcjj7HXy0A01A
         nRKT4ebhAyezxpncEYECEC86qkRPGkIXmsMzIOOA2z0ZZb5SLzQ1Kw8/EhCCvBKY20Ku
         5tznj4eJ32fThJbDtQ8SvoSwipaP00JvPZUPkAH45OS2sOpvZBSYV61eC/kxu88n6ufF
         JSX+6di4EPY7yAxR02/lKQb1utk6M0fBSR5bAjcaA2XR/L2gbcXpztGaHlLNaWwhmNMz
         01HQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4JJTaHXRieIVw7YS0TDHPMdveux32GWw1gg1IqAc2CgYXSi6XNVJsDGe29MGWyqBq3DYfxEp+ehb4@vger.kernel.org
X-Gm-Message-State: AOJu0YzikvJzoquAN9p7ckPCcdCAJc2e5Zt5d+j+zjLhOXuX9C3onFOI
	/IMQb0sVp4xgWLzTW7gwgugvMTyjGlLpVk2UsZaKn9Blokx11f1FBhhORlWp
X-Google-Smtp-Source: AGHT+IGjoeZGZj/rB8b5OrvL0VAMQm0rGpQR+O3EGn/f30y8nqU0upAsIO4wxffd1KC9eQeL26LPIA==
X-Received: by 2002:a05:620a:4304:b0:79f:41b:aaa8 with SMTP id af79cd13be357-7a997340b37mr1549104485a.29.1725935511337;
        Mon, 09 Sep 2024 19:31:51 -0700 (PDT)
Received: from wsfd-netdev15.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a7a1f594sm270429885a.121.2024.09.09.19.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 19:31:51 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next 4/5] net: integrate QUIC build configuration into Kconfig and Makefile
Date: Mon,  9 Sep 2024 22:30:19 -0400
Message-ID: <887eb7c776b63c613c6ac270442031be95de62f8.1725935420.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1725935420.git.lucien.xin@gmail.com>
References: <cover.1725935420.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit introduces build configurations for QUIC within the networking
subsystem. The Kconfig and Makefile files in the net directory are updated
to include options and rules necessary for building QUIC protocol support.

To enable building the QUIC module, include the following configurations
in your .config file:

  CONFIG_IP_QUIC=m
  CONFIG_IP_QUIC_TEST=m

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Moritz Buhl <mbuhl@openbsd.org>
Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
---
 net/Kconfig  | 1 +
 net/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/Kconfig b/net/Kconfig
index d27d0deac0bf..3bbea4138c58 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -238,6 +238,7 @@ endif
 
 source "net/dccp/Kconfig"
 source "net/sctp/Kconfig"
+source "net/quic/Kconfig"
 source "net/rds/Kconfig"
 source "net/tipc/Kconfig"
 source "net/atm/Kconfig"
diff --git a/net/Makefile b/net/Makefile
index 65bb8c72a35e..0562e72482b9 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -44,6 +44,7 @@ obj-y				+= 8021q/
 endif
 obj-$(CONFIG_IP_DCCP)		+= dccp/
 obj-$(CONFIG_IP_SCTP)		+= sctp/
+obj-$(CONFIG_IP_QUIC)		+= quic/
 obj-$(CONFIG_RDS)		+= rds/
 obj-$(CONFIG_WIRELESS)		+= wireless/
 obj-$(CONFIG_MAC80211)		+= mac80211/
-- 
2.43.0

