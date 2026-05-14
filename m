Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA33F33B6F1
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782129; cv=none; b=DpLXGOHUUJdbfr6tG/sIZuzIpfJuhcs8L8MVkkpbUYgzG5PWnzmTT6f0lQEtn+Tu+ADt+RNzfcy/+B5Hl2qdjvWsCq0GxfY8kfsT4ZeBX0V3gseUvc/pSTHyLaEJPPTwsSOo+405QJBAEwy7sD7NGNtbefkqOrEVJjQXitM3BcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782129; c=relaxed/simple;
	bh=VNvZ7Hb+r8aSyTRGj+1WaTlv2ufoAoQdRZgA6smQqa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDDOU0n3SnL+a4BZ+NM88cyMZi3nUnDsoOrxsUJUUIeuwF6I45a0z/7WL3QkT4+BkPWnTiINedCMVGcebkWlBa5JA1kpZcxB6hk9wsOVRkkrjnC+Ec8mLjAeNIzdtHsUn6XAze1aBZHKMOTsmGw5UP0wTJljxQQxQNSo1D7E1xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AP098oKv; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AP098oKv"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so3718895a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778782128; x=1779386928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ITpp/rLhBKKhDr21OhkvseyR4CwdLGNXGddV0BN01qU=;
        b=AP098oKvkE/9uBR836iQL80O9P/tU/bJKSovD+ddvKyxlEdiKSE13pLgYIAICOmJOE
         zz4Dloc52q0pmvc6o9ZfTigOwyFrl6kWKO38XARKHoh2sGKhlWoyW4EXWc3PQipRNt37
         9+zCT3Q1uk5PyuoLwDiGGhbD73UVavSTdnqyp6xzkEMQnoMDP+1VY9vmdR2gpbO5lK6e
         QR4vFIc4A1p/311EU3cQifel0dIK7jzO8EGWh7ege8UHQ3ejw2c1nF86wOJgf6xNqGWC
         aUZEipHA/KExrfCm9oZoLVxQrg0TjevF6lMvXHaB5KypVt8TB3LgHIoc0ScGsOOTmKX7
         1P/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778782128; x=1779386928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ITpp/rLhBKKhDr21OhkvseyR4CwdLGNXGddV0BN01qU=;
        b=IN9LgF4AoGh76nFWsyqv90BoIx0tIumFOIIMxIPmMeKZnZcJotlWbVS8bz4mGfFOD5
         T4LpFHhbTVyiceSYnCJ+qrzLDwY5ND0ipiXd4xzSCehum1Hn3AxuXeuPg8IzqoWiZlvV
         Xl02SCgBTv8cD9ZQrZyCPOkgO13ezf9jhJspkjFjqE05bYc0HCrv/EwQ8I/4QK3toQvD
         SbdN65VGAhg5j6RMdRnYzHSD+vhTPjDOVwietDFvgcoAPa12oWtsv9CHZsKkxE//MEBj
         VunOGni9hlJlVLhfxzFtzoLkm8pn1PUcIfhbvA85trhxZnnvieFDrgPx+uuw6AVTFSXm
         iPRQ==
X-Gm-Message-State: AOJu0YzJT83wCF7mlmjpaBYQWjYlbuZ7ASj6ORf/RKRcSsK3QZbKeDxs
	0ymEV5N/QyOkA7KixrI8BEKb+05I6avnvmkqvsjYc25kwt8n/61Yt7lVPmNeU+D0qgs=
X-Gm-Gg: Acq92OFG8jxfGSe1hXhHfHHAtpnajlhAL7a42TLKSOx2pk3Dn5GYPgKPz1fYIMkJh+6
	ltLHgBHvPW/0GgTBixgdX97NxgGIyC0cZmrHAKK+xMsN4K97SD7rZpyYmG4HcqD/wKtq3LQ+O4/
	Ei4KDi3m1LS3QOW3IUVrBDK693avZlq6c9rNSxPc5ujQCkzqfh/aB2vPaPr7qrrsRf91VCLX3kr
	acfnCPM+3t2fIcsmeQ1zgR7jAgScGGfWPFQUW5k5U9nOShqNHJWxk+Tk1qhGkGGd4K8HBiP09Bo
	7OSldrVyJPtC1zLTCWy8kMtz1CV2IlgsZNxjHm2/hPl21kkabbEkqt5Q+LLAHoQBtcZ5KsbT4X6
	7pL+5IoaW2mTf7yCQTEsdop+hPFHG+2WAWvUMiYOrra7Qsf3hwU9/ovvl0ywMV8fnEySuppdvdM
	r4iT7RRAac+YtdwGyJ6quYAW0Dw7clE/BM1EsEQ3XJV2O1bLVEkBbtw6ByMthcrMRl
X-Received: by 2002:a05:6a20:244f:b0:3a3:1071:89f0 with SMTP id adf61e73a8af0-3b22e65c034mr392242637.2.1778782127781;
        Thu, 14 May 2026 11:08:47 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm3134589a12.30.2026.05.14.11.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:08:47 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v5 15/17] cifs: discard functions to ensure that mid callbacks get called
Date: Thu, 14 May 2026 23:38:21 +0530
Message-ID: <20260514180823.497293-15-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260514180823.497293-1-sprasad@microsoft.com>
References: <20260514180823.497293-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

If discard functions for readv and query_dir return error, the
callback functions can be skipped. This can end up with hung
syscalls due to the completion functions not getting called.

This change ensures that both these discard functions call
the callback function when discard from socket returned error.
This ensures that at least after the mid for the response is found,
the callback doesn't get skipped, and we do not leave syscalls
waiting.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index eb3dce4449963..7812cb5b543b1 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1143,6 +1143,11 @@ __cifs_discard_and_dequeue(struct TCP_Server_Info *server, struct mid_q_entry *m
 	dequeue_mid(server, mid, malformed);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
+
+	/* Once the mid is dequeued, the callback must run to terminate the subreq */
+	if (length < 0)
+		mid_execute_callback(server, mid);
+
 	return length;
 }
 
-- 
2.43.0

