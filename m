Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B801A1514DA;
	Tue, 10 Sep 2024 02:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725935510; cv=none; b=o5qV1hl+Jp6SOHBUVs1HvBaNW+RshZvQsfsq8ZFR5q0ccS75+45zp256ix09ZQgztkUtm03/02vDu/HhHPknJIbH/+CL/48DC5JdrmQsOPZZqOvfTsZHgF7LVZegK5jEDjylOc5cBybUAZ2RUJSXVQkQ/sm7x7cC62OJQfyGaok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725935510; c=relaxed/simple;
	bh=yuhv+daYX0sTENkYeN8XdnHG9WZM/tGrhwPqPME8rik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9KStnHLzIRNVXlG/26ab3+hRn8I1UF6bvirNG35NbjxzX9Fvr3zOt6pXome66hlrwEU5Zj+K/DC0h+WwtE07mUkjAWuCGeVmeYLDVfR8GBrQ4lpm3A0RTvW3mrTa+fy1YBWniIrf7bUSqMhAGiukQk4H0Ja3I9AdqyJvfoZGu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LhVhCfeZ; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhVhCfeZ"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7a9a30a045cso284089585a.2;
        Mon, 09 Sep 2024 19:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725935507; x=1726540307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IR2Pv0JoJhDQe2s8gdX0zvBxLNnnOcCJUHnKDmcFCmM=;
        b=LhVhCfeZLfMMjNhiqmOkSLvszabfwvlQE3T3S2hm8huI08bM/KT5oVzdDF+IlRZ4bE
         BTIK6tCxMWUiHebeDaAbxAG4lB/BrxTFP/CVjtKgQHFiymqDBcFLIPbzt04XTL9j2e+L
         FkFYeAr3G3fN1vFLstYpcD1mOANcXNzfP+Iqeuu5bWSSnQonjGIkvcQgxUOSpueHkBoz
         TTbO2kPPwtWfPPFt9mJ7l1TBO0/ZmFmAJFnO1aVPFcQsdHc68TXjZve1H1IdaDxJ6V+X
         3nlM5o2zoXf2jyCVorLH0vWOGWLBgPg2IKQGvpSPtZN0VOfDFOmYl/LlNC+8K4PfL6yE
         TtRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725935507; x=1726540307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IR2Pv0JoJhDQe2s8gdX0zvBxLNnnOcCJUHnKDmcFCmM=;
        b=sgZhwFVAKhxGpPseIuC4zwsYlD6QloTejMGAbuUmeWfP+LILXYCVhWlK8o8mEecxWr
         ZNF3+QPtosMGc4uCRgyGZpHtrLY5tJMDd+O9ffC0rtDudJvtNVgWobA9dvqzy18a697E
         xknZxeHaowMs2LGIFTG0CXfL2Ssm7ifN8jAOhPPP2nkkuwFvXC8aOWuQmuTVh4r0bFyQ
         +M3p2P3HownROEljC3IaijPdMvESamuJO9OWDy5PYmkTsPVlS6duhboEh6wxnmXs1D5G
         iNBA3BQTvKhQEM2LgFmEgPruFXteDD2utHFizz9LcVEvyPsifP1wPFqL1zT6PIjNS1pm
         /Qag==
X-Forwarded-Encrypted: i=1; AJvYcCXOlbd0r48fLt75zHDRClHI5NsEy6yjJoWu/xZPnFlo92Nipl1M8yQMfNVvz58i8l0PJsyuryT7ihLX@vger.kernel.org
X-Gm-Message-State: AOJu0YyaF4b7QCspQCaDsCr6A0MKyF4QOW9hJWJ3zq6Pe788Y6DuLGs4
	mwT4/9+iC8ZjXq6vApt0ahCFPzinF4h5ohjnz2vXPu3isDkj6ETKTPOLvBDJ
X-Google-Smtp-Source: AGHT+IHpSZssheK/GdMVdH9AflImVGjWBbi2SrtQ7SvOVl08ehAscgn7raFhP79R2ZmLofI9QyoVSw==
X-Received: by 2002:a05:620a:2982:b0:7a9:b618:16bb with SMTP id af79cd13be357-7a9b6181b40mr966153585a.19.1725935507427;
        Mon, 09 Sep 2024 19:31:47 -0700 (PDT)
Received: from wsfd-netdev15.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a7a1f594sm270429885a.121.2024.09.09.19.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 19:31:47 -0700 (PDT)
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
Subject: [PATCH net-next 1/5] net: define IPPROTO_QUIC and SOL_QUIC constants for QUIC protocol
Date: Mon,  9 Sep 2024 22:30:16 -0400
Message-ID: <04be849a69b445f8d3d9f6582248fb462211d626.1725935420.git.lucien.xin@gmail.com>
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

This patch adds IPPROTO_QUIC and SOL_QUIC constants to the networking
subsystem. These definitions are essential for applications to set
socket options and protocol identifiers related to the QUIC protocol.

QUIC does not possess a protocol number allocated from IANA, and like
IPPROTO_MPTCP, IPPROTO_QUIC is merely a value used when opening a QUIC
socket with:

  socket(AF_INET, SOCK_STREAM, IPPROTO_QUIC);

Note we did not opt for UDP ULP for QUIC implementation due to several
considerations:

- QUIC's connection Migration requires at least 2 UDP sockets for one
  QUIC connection at the same time, not to mention the multipath
  feature in one of its draft RFCs.

- In-Kernel QUIC, as a Transport Protocol, wants to provide users with
  the TCP or SCTP like Socket APIs, like connect()/listen()/accept()...
  Note that a single UDP socket might even be used for multiple QUIC
  connections.

The use of IPPROTO_QUIC type sockets over UDP tunnel will effectively
address these challenges and provides a more flexible and scalable
solution.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Moritz Buhl <mbuhl@openbsd.org>
Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
---
 include/linux/socket.h  | 1 +
 include/uapi/linux/in.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index df9cdb8bbfb8..e9db28c55a37 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -385,6 +385,7 @@ struct ucred {
 #define SOL_MCTP	285
 #define SOL_SMC		286
 #define SOL_VSOCK	287
+#define SOL_QUIC	288
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 5d32d53508d9..63f900290b96 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -83,6 +83,8 @@ enum {
 #define IPPROTO_RAW		IPPROTO_RAW
   IPPROTO_SMC = 256,		/* Shared Memory Communications		*/
 #define IPPROTO_SMC		IPPROTO_SMC
+  IPPROTO_QUIC = 261,		/* A UDP-Based Multiplexed and Secure Transport	*/
+#define IPPROTO_QUIC		IPPROTO_QUIC
   IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
 #define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
-- 
2.43.0

