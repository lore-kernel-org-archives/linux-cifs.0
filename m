Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458836;
	b=43MiUMSLtFsuC3hSpFnBcVoW8kpD88rsUUEnGAQYTsssDcYM8YwIeifjilDTy0458FTx
	 WywjGHK5BB+R904TOdE5XGOIJauvgUw1tgzSP4yyXvrC00ZixDysOoTf6McmCBhqhQ+JU
	 Fr5e4/Lp3x0+1eu5QycBcb+X9pLgZAYR21MnzYh8WiyyUEAQ+X1xoLNVooLRPcKwZOou3
	 ArbnupZlN1p6nwqhJzhgr065DYnosKt/USLvJVMD6ZShSM2LUWRoTY1cK9yTytRLLjais
	 KYY9UmRBn4kEzsqMH0DIRz4M8553xD12oCpVffnPD5JlMqnu3dGxOnFC+cH/+tokkKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458836;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WdHqz9JYcfNaHiavdCpKMF9dVXTFBJuVfJ5Q3LygRzA=;
	b=FoCpB8B8qPJttIlyyMfGmCbRQPzf9dy2enfULYsUjGjYK350NxoWdARb+WCR8dKAtpwJ
	 e8umDtnFz2KZa8DisJZWG0XfyMFZLUSKBleenaFo5UJ7BpIS9G//+4TrArvTPeC1rSqoQ
	 pF3F9zFvgn3U+c609r17XmR2lPrn2Aaof3qzGSn2e5efMBM1RvccSm/YttdNqtwaYLdrH
	 bKcB3pq1/eXziDP4ig2i25JR5XgsKSFSnJfkZXAXAiGC1J7yB6YQ7jmVrKOP1dEE41cX2
	 qHjaSPN21kRRi1R6+IPVHQzpw+t58a3KDvmKkyNXrflqIAbhNQsi2kh9eyTIUPHFYrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WnsALIc7;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E44F606A89B
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 04:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E44F606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WnsALIc7
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-37628596783so3644615eec.1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 20:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794458836; x=1795063636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WdHqz9JYcfNaHiavdCpKMF9dVXTFBJuVfJ5Q3LygRzA=;
        b=WnsALIc7uEHaLv/PaKieu8CMijvWhaitGQ2AgB5sBvfanVDHj4xdf43QgjfchJzE+I
         2JJTDh1bIDM3gJjTjJxead0gcZcAVdqF8NyauXiS/qWVXYPD//llfdxfd203vFtSD2D4
         Ezojii0AhCYD01c3lteiuUgJejOF3hG0OFRfA1xi2REm6NASrAtY/13WOorO05N9X5bJ
         X4ASlM0ylb5jsbZmPtRcE83ws7eI7ETSkNX8YdjnZyWf9hXqVePll4FiiwCeMnSnAKsL
         yqGyHFFWsvheQeqhwkuYkJbtxckTBy2HlLvZaPR0rTpj/+JrNJA8kPRTrzcsaMb+RlIu
         QyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794458836; x=1795063636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WdHqz9JYcfNaHiavdCpKMF9dVXTFBJuVfJ5Q3LygRzA=;
        b=1vqGeP1cwNTP8ziDmmtFuy46FWxLUXYvnh0snL3dy/HF7pN++tcQnntWPKuO5c1OHX
         UdUnFwGo9o6VaG5BTsvVjyATz6TCxC2oF1l9oIW900/fXAFLzKAGdpnhZYYRWI5Jx+es
         wUPxMCGeUv/1+fyHsnP7f3Yv7tPUoiOK0tDgM2uKl9ivl/t4N5xuoc1pfKhkGJgoEGsZ
         i5qVwA93MXT4y1yMil2NkpJiXXYkNlWVV/bD+wVVbSpEGBPh5DcHQXhKGqlq8z9sA0cy
         Ly/JsD5RPk6Qt3TBnvdvNameA49z6ze2ZGkqpxyosebt3shI+XL3rfhFyK3522gr3/kf
         yILw==
X-Forwarded-Encrypted: i=1; AL+hErFGpO8Av9x5BKfQs4WGs11DKD3NDt50Nj1TdvB84xatDiGdB6k8NhjKNYqkWbmvf2vhLSFwdHKa9RWu@vger.kernel.org
X-Gm-Message-State: APuU4Z8G1BEhaq0LOm6gu1EoKrVogI7xEnIzRENBbhlMWshMV/9nY5rg
	s7/cblAZbeGyr6X3OqoEekRZ/0ipZPdnjTLTaE6NE0zVwSKBpQnaUP89
X-Gm-Gg: AYBFou3bQkIPhkkSX4cE3b9YXD2LB2fGJG96NHQSIKDdxwtR8IxSEM898W/bL2sOwEr
	kIn0gQx5fhBLbxqfuxA34szfC61xA2HSWSX4MMFEJw3JrlboUvYjVeh+wU65/Itk3/SV8hpLTPL
	r8nimeJP6No2DK7dG6lV4SiE8pyeEE13EP8mT2qIgoUyztDmvOqG+5N0Oeaavwv7b9R1avDQ1+x
	/jJ3/aRuPt1Ef/omHAJdiJTgfHKtJ/YcyXncIMm6rmTLAM88Td/+f50AkbanjUwrfx4mNGINhPX
	Wun475U2xFiRkMU2flM9nh7/r7k/TC8S6Y4dvoVDMncmp1MOzsdlh8qkPHEBePyeGPgDu4vBoHp
	Ls757kiK8li1shrRpQefP9hKFhsstsGxsJrU3Sw4BR6jT2Rfs0+pa90JJmasagJUNnih/uJ7rC8
	FrFAhzTmYynQDEo7rFxxrJ386tnOq95y86uzpqruVWFh/TSTeQcheovV2J1IKzSKDOskHZjADI9
	Mc+y/Kdscgq6ZNXrk5oQFMCiDUrxxL5RSdPnTx3kCRE3SmfF8MKgEqGm58A59IA7mRe5Rs8coi2
	PlSZGQsn4CS1weMW7+uY7UO2oaPln+vZgzKfMB0FqslibTUhSz5HgF3uWWdjty26XW2zKrbkSet
	mcOkqgExUASDoSV3xdkrkrBUS
X-Received: by 2002:a05:7022:1409:b0:1b3:a89c:c456 with SMTP id a92af1059eb24-1b3c024a7e9mr3414920c88.6.1794458835535;
        Wed, 11 Nov 2026 20:47:15 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:5d51:6f:e2db:335d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc14sm21024827c88.12.2026.11.11.20.47.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 20:47:15 -0800 (PST)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: linkinjeon@kernel.org,
	stfrench@microsoft.com
Cc: icb@fastmail.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	ematsumiya@suse.de,
	lsahlber@redhat.com,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v5 4/8] ksmbd: refuse a binding request on a connection that is already a channel
Date: Thu, 12 Nov 2026 11:46:41 +0700
Message-ID: <20261112044645.4074-5-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112044645.4074-1-mike.michalo@gmail.com>
References: <20261112044645.4074-1-mike.michalo@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_sess_setup() refuses a binding request for a session that the
connection already uses, but is_ksmbd_session_in_connection() only
knows the sessions created on the connection, not the ones it was bound
to as a channel. A connection that is already a channel of a session
can therefore bind to it again. The new binding legs are verified and
signed with the session key at that connection's MessageIds, and on
completion generate_signingkey() replaces the channel's signing key,
while register_session_channel() keeps the old channel entry.

Refuse such a request with STATUS_REQUEST_NOT_ACCEPTED, as MS-SMB2
3.3.5.5 does for a session that is already in Connection.SessionTable,
which a binding adds the session to (3.3.5.5.3).

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7b07108a48c15..0271ee4753236 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2722,7 +2722,9 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (is_ksmbd_session_in_connection(conn, sess_id)) {
+		/* This connection must not already be using the session */
+		if (is_ksmbd_session_in_connection(conn, sess_id) ||
+		    lookup_chann_list(sess, conn)) {
 			rc = -EACCES;
 			goto out_err;
 		}
-- 
2.43.0

