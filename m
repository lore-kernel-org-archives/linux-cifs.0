Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECF83382EC
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 21:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594471; cv=none; b=jJCN+tvi7gHPcULCGLTHBF2vnk0V+mMn2r6ClMP1mE9wx3zq6hi5JMJheVOrmHgMZoKVY0VXQs/802RNMNwVZMpd5l5dM12CceCThWJL+0mra17GpwPIlQJnHrGyC7WKXoTktkguDK6YjymVmUFQASA4rQBKqRrTg1oArrtd1mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594471; c=relaxed/simple;
	bh=qqqqhAcoTazT3zDcG36T/OFmfZ0W7gsqaDYv/oilvnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3xfU7OgIR4qyyszVRfhRLeZWqK5INkmMmvV0LP52HwFQZWPdtk0yFWKWtMNfd+L/tQYaKQGlhFAswqZZqAtJj6DRhcPWswyVcWSjCmPZkTN6jvzcx8QUKAnRsLC7D4a2yehe2NUFVtN4ROgumDqyOo0Dwt6o8hK4zIe2Z8tsos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=etPhuWKG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lv9Wy7SH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="etPhuWKG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lv9Wy7SH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789594457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jDQ6J6doFiv43Hl1XC1fv6A2Y0AiG/CVhsbe9ThB2Cs=;
	b=etPhuWKGR+h8luh7MB5fgPROaF+7dJjcDzcOpfVDMZsF+ydhXJRjP5EveD9imdiGnaVlrf
	4NkE3jE3k6TiUD0yP+QUILpScZXaDYhyLGssh3VAF321jX32kgrrcxHHAm36JSVX5BISqf
	Ye/oEHtCGopf65DR6IqUrPTdtX4YxC0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-_SeuqbfsP6mKA1l5MRY12g-1; Wed, 16 Sep 2026 17:34:14 -0400
X-MC-Unique: _SeuqbfsP6mKA1l5MRY12g-1
X-Mimecast-MFC-AGG-ID: _SeuqbfsP6mKA1l5MRY12g_1789594454
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530e89b584cso1325171cf.3
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789594454; x=1790199254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jDQ6J6doFiv43Hl1XC1fv6A2Y0AiG/CVhsbe9ThB2Cs=;
        b=lv9Wy7SHZYWBr6XOH5gDlLsvIxVDC9a7lbqsN1/8ryBzfarUrbRJXTeaaiOoI0851S
         5FUUjqLAZxK9ISNOtrz0WZuIiIbSae5eNvW47kAhmmCJ/uvN/sxttgWjiCNTMoGznYnm
         7vALCFwzD7iFLQYyWpf2X1/7/8PlrP5P5E+KbJw7N86pCQGJ+z+tb/2YULQ6cA3c7mno
         XF6PeZKyyiIoyN6Vcl7e13NuEWdwdVPYfRSygx2MsTYVmBt1cPC7vwl++ZND8f6wp1m7
         /KBMyzwLgSnhNd6fCZk493JCWrYqajQynzNv+JPJWZCbwxB0jJxrWbOuEofL/irwA5Mj
         T5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594454; x=1790199254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jDQ6J6doFiv43Hl1XC1fv6A2Y0AiG/CVhsbe9ThB2Cs=;
        b=duKio88b1l18wrVOXlyXegEY/eYBfk6Ir76x+9ja6abJ3zYm6SLgIKjOUsIrgQraXm
         3SzdLWWWdea8P53clx6j0nZHhJiav63cFnp8DWcSzAuWKXRvFqpUD97PMTyYvyNNM2DG
         InSEv/q8Pl4VDfgEQ18ljjyjvxqKnYnw+8O9ZL48GXn9Z6ivgZPIkbSFvc+v6yzkboTw
         Hmn3ZcrIpwVPgMJ/9qu6m4hda+ZWRiFP1NGiWuD4Z9d6bCIpj2d2tB2JL4RgXpb1C3it
         nlW8ao9zLJeqSKqjw7/g6bMgpprMEaWL0dAwU9ea0ASmrg8gpFBRG58y6zSLhXSkBNDv
         JYqQ==
X-Gm-Message-State: AFuF++no23maDSawieEa3RuE2Gn47XDbBN8gmNwjDahSqNghVWWxboG3
	V5l6AnLJKSPbOeOHCKr9ZfNFNuH//qPUzKPZOdzfkCX+4RJfgxRXjuQKtZKQj+zqFHeGfQ331iU
	pWU5ul/Iu7zvPPvo2qFODduY9GceATCARvT1S6yaBAeur9YYXBNofc64FSFI2pgik/T5/fxu49T
	68zog2jMlID8kKM8Rp24KheWj+rdC9vo9OK0mAnpTtgOaOmBcQ6w==
X-Gm-Gg: AYBFou1GJ5WiJi1T8rNqw58dqQ028KJWW7LJTWoqwMeeq/AISaV56HuzR9X2W3C58Ad
	MumlG/viS5H0cdjAzzVntvd3lM3PU0xy7T9M7bDWF/rZz9y/F348wPvZMoFUgyLe4AMC4+G3KGs
	8iaTPL9dd3bsLUsuKhgRTb1JCFt+UHQ2dmnHiRrPG6O6ck2uZZRZvWGyewvQiHC+J2elGgMcZ3F
	MMlzOeyvPejO6sTcRzngEH88BfTIeLC5dtro58gSixapHGOpVwJauRijmGFbsXNEC1UweV87ZPT
	/rpDx8RAZjE3+lPZDVB0hSkVv3SQmktFJuNhIVhsczULoSalh4do5eC8ItEkyd+bfOYaVc/2uRa
	ZbUmolki9PiVnzQBs6ivQ+1Oh2Yj5ESpRbqsKE14Ft0D3YvAAhw2HBmPS4jrl5lnoKQ==
X-Received: by 2002:ac8:7f04:0:b0:530:d1d6:792d with SMTP id d75a77b69052e-5327f232ea6mr71106121cf.15.1789594454120;
        Wed, 16 Sep 2026 14:34:14 -0700 (PDT)
X-Received: by 2002:ac8:7f04:0:b0:530:d1d6:792d with SMTP id d75a77b69052e-5327f232ea6mr71105551cf.15.1789594453652;
        Wed, 16 Sep 2026 14:34:13 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm32447431cf.28.2026.09.16.14.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:34:12 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v5 3/9] smb: client: fix server->total_read for compound encrypted PDUs
Date: Wed, 16 Sep 2026 16:33:54 -0500
Message-ID: <20260916213406.1496960-4-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916213406.1496960-1-sorenson@redhat.com>
References: <20260916213406.1496960-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In receive_encrypted_standard(), server->total_read is left at the
full decrypted frame size when walking sub-PDUs of a compound encrypted
frame. As a result, cifs_handle_standard() passes this full size
to smb2_check_message(), causing the PDU length guards to incorrectly
validate the entire compound frame instead of the current sub-PDU.

This allows truncated non-last sub-PDUs to bypass length validation,
leading to out-of-bounds reads in smb2_get_data_area_len().

Fix this by setting server->total_read to the true length of the
current sub-PDU: next_cmd for non-last sub-PDUs, and the remaining
pdu_length for the last one.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index fcf7033889c7..7f2177f6fc01 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5371,6 +5371,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 one_more:
 	shdr = (struct smb2_hdr *)buf;
 	next_cmd = le32_to_cpu(shdr->NextCommand);
+	server->total_read = next_cmd ? next_cmd : pdu_length;
 
 	if (*num_mids >= MAX_COMPOUND) {
 		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-- 
2.55.0

