Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5166E34F259
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 02:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786070537; cv=none; b=E+H2VfXsB25TCUxgGK4jguesYvzKsjwwmrz4WvOJd3ClZf5HaY2uREu58ktQP/tU1Mxoy0Z29it2z4gpAIrJJJbNIm7xvFldcUK3vdzT/Am47JzuX2uHgS/av2tsM10GvlqPXH4xUnkFytk27RY/L7qIf/XZqh7GFvqo+sbZt+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786070537; c=relaxed/simple;
	bh=ihYmXYag+Qm06J02IphUYEH6cOHEmnNInaqD255GJ2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvs6iqweBqEmZaO0mhMQuhErARtdnTK69VfNDw1PXsYJo92eD8N4bph5n4oG7MtDgUJWqGCtaiPu3cp32aJt1lgQ6ivPIakCX2COmnfXLT3GubfjAmxy5to7z4vNUNjE0jeGQEZfKBCwt0LVkH/rE0zPYZ8Is+rxVhl0U/ZaFl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aWs85NGg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=L3TnJEOr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aWs85NGg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="L3TnJEOr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786070535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jUGoHbVISmT8U/yGzpSVUfjvQqCD4a7LjQIBARuhqwU=;
	b=aWs85NGg4LmxJeuZRxEMm4vzcltZHDrm81wzIQaFnqVRfcS2u4fBhfh/Z5QtuzkVMiXSaS
	kdvG4EYPsc7l0LYH2T0S0I5kkCnnqBiUIzzMs1ft5l274dpGPBeM6VZnSLfS1cduP63ZI6
	iuEO/JlaG9de3Z5kV0lfwfuc/zTeCCg=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-gU8-SV58NXa9n3UVg8sTWQ-1; Thu, 06 Aug 2026 22:42:03 -0400
X-MC-Unique: gU8-SV58NXa9n3UVg8sTWQ-1
X-Mimecast-MFC-AGG-ID: gU8-SV58NXa9n3UVg8sTWQ_1786070523
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab4ca7ce3fso2575698b6e.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 19:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786070523; x=1786675323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jUGoHbVISmT8U/yGzpSVUfjvQqCD4a7LjQIBARuhqwU=;
        b=L3TnJEOrPXssV2tV41LPFsS5lI4Xl5ZHYNXxUv24as20EANuKLrV6bV0qIlbtvpXxP
         L/ay7jQn5lj6I4fHCSEMWL2nn0VZWwltixo3vrNj3YLBdF6FmgyLYhe2CzdbPsvUjwpM
         6dfCcwhencABwHDAi5Bw/iIE1QAL+k9u4bBCDjTQ/HdUM8WChnjrFDPbcfdp5FMU8AGY
         0xMpyOgYUnfwb4WQR7MVVdXqRQAHsLQbl0Eg1Wus72PKhGJJ5K66Rf0muPXcEyfCDVJj
         Vs/TSA1svLQVRcZyBgQQc7EcZxL4hluD/AU7BlmAHRnltsoHWzkPlbIcrbPsGc37UEBT
         mkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786070523; x=1786675323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jUGoHbVISmT8U/yGzpSVUfjvQqCD4a7LjQIBARuhqwU=;
        b=T/SAfYlw7K62gn8iNXRxVpgv1sU7oDfFMoyD/i+gm9yQA53UU1+maMI1CeSI7O6HZD
         7Wwd11rWibbsBCVGeLDg1uWbE6YcUhlNRp0zg5xTFnMAaulf6Tmn71jn6wBIEMeeLmEc
         OoRL112SiT6Wo5XPGQBnsiLYGmVM1djp/7yUS4/fm5au84dC64ZR5H38A26WsL33q1fb
         ziE2AiEN0CbLhm0iHwp+V/5c0IUZBt6+Y/abLpNPakHrJV+6Q0Sex1qtcRwGKRkETYb1
         7SmqF3c+T1M5/wnpgWjW7XWbivC7P8MbI5tNdSxgCxvbjFht19Z9I5SlKqQwva7bpJQi
         lwSA==
X-Gm-Message-State: AOJu0YxjK2YolFs3AZHbEF2aJQnHDRgLXfmojVaM8v/IRXjpaVdJTz5x
	z0CzIO7/KzspAMXGk2s0Rp/8cCSAvfEs8N40eqE+iryOilBgBipKb29Ms6mS8qDmRHBFOACFcdD
	ZnPjFAnDWAn7BH0qDsf2a2o8QIsSPF6rZAkZexKhDi7VAFEA6dK6OPChRIXwt7VLEuGheIOcvwj
	uUXg+MYKrMuN2TAIVUVVJjK0jk8S0OBwEo+d386cgxYXLb9TE=
X-Gm-Gg: AR+sD12oErqmIqHdlN07A+7x9j0/VrMACswvH33n38EJ/wps8mSiWF4QmTr6YtMPNcl
	GrFU2Zteyx25KB5WS60/Ser7L71VHZ8MZKLfiHtcgPRu/7iRZNDfIjnRGLmXS8F/84GrTz99/ek
	yh6bGbn4ZPjieTDoLcXcNmhZegmQxt7Fm8+dbTFSak8eryDE0Apn9LYvNWG+ZGFNm7fcvzEk/Lz
	vjqJAPVn/oerDYjwBcLwKarlq5Gyx/HQPGtSoG3Zh6BvG2UekCvcflSGvrE81r+YGIHm1erm4ZD
	ny0CAmta/vJ3Xq8rzuoQEgVvhsLtGhhGyULkenRN0jks28F5JI8aqn9MNYgDH6cDlcut2QeKiLO
	oPaC2q5CDgxVmaGEgZnwm8Ucx3DGc7H44ffRt12QYEUlyCJWwQLF8UQy1mg2YMUAJVA==
X-Received: by 2002:a05:6808:1646:b0:496:559d:5474 with SMTP id 5614622812f47-4afadfb0140mr9833099b6e.8.1786070523066;
        Thu, 06 Aug 2026 19:42:03 -0700 (PDT)
X-Received: by 2002:a05:6808:1646:b0:496:559d:5474 with SMTP id 5614622812f47-4afadfb0140mr9833068b6e.8.1786070522531;
        Thu, 06 Aug 2026 19:42:02 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f35b563887sm356182a34.3.2026.08.06.19.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 19:42:01 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com,
	pc@manguebit.org
Cc: stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 1/3] cifs: clear tcon after cifsFileInfo_put() in cifs_file_set_size()
Date: Thu,  6 Aug 2026 21:41:56 -0500
Message-ID: <20260807024158.3707995-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807024158.3707995-1-sorenson@redhat.com>
References: <20260807024158.3707995-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the else branch of cifs_file_set_size() finds a writable file handle
via find_writable_file(), it borrows tcon and server from the handle's
tlink, attempts the handle-based set_file_size() RPC, and then releases
the handle with cifsFileInfo_put().

If set_file_size() fails, execution falls through to the path-based
fallback, which reuses the borrowed tcon and server under the
"if (tcon == NULL)" guard.  Since tcon is not NULL at that point, the
guard is skipped.  If cifsFileInfo_put() dropped the last reference on a
tlink that was already removed from the tlink tree (TCON_LINK_IN_TREE
cleared, as happens during reconnection or session teardown),
cifs_put_tlink() will have freed tcon; the subsequent set_path_size()
call is then a use-after-free.

Setting tcon = NULL after cifsFileInfo_put() causes the existing guard
to take the cifs_sb_tlink() path, which acquires a fresh reference for
the path-based operation or fails cleanly if the session is gone.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0afff761aab9..5a4916259a04 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3100,6 +3100,7 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 							size, false);
 			cifs_dbg(FYI, "%s: set_file_size: rc = %d\n", __func__, rc);
 			cifsFileInfo_put(open_file);
+			tcon = NULL;
 		}
 	}
 
-- 
2.55.0

