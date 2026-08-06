Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEF5443303
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 23:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786059801; cv=none; b=ECfYhtDn/ubo62Ehpg+0WRjJjLdCF1VsjcXHWYOd9Fp08JBNTM21btNfkJ+TGWD/p7+PIYmFaLnCeK+LsNSfkRXsJW98VyFNlsEp3jKeZz3yMTyFirAat8y7A/p3Y6oq12p0DMQsAeXkexcFKUc2WGDt7vFFGaCPV0JF8H5G8RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786059801; c=relaxed/simple;
	bh=vj/ZiibbgyOF245m8EE4XGt9LdWTvEP94G4b7Yqr+QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/t7d3MSk3Z23eHRvYMBF1M3CqMh4G41ODMhyKMaFcf9tEKuXpPpP797sciAhn8I3CLLfFIhXsVFMHUhejTC9wfK1JwJb7m1MZ+NXaE7QEkPRD40yWcgmmpGkwtKkYWnqCeQTADAeW7f4Muau5376LVRaWNY5mIRe7RJHjFwixI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PM+kNtmc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Iz301R19; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PM+kNtmc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Iz301R19"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786059798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PgQO6c8L3JLrPOSlWX6dvSno5AXv3uRrAtPYOdKDujM=;
	b=PM+kNtmcTSrAvhu0GOZzteg3Rdy2Oj1A4XcAk+JC+nq3XM7hAVHQMSMO5dIZ5RTeKcZxdt
	tI2iAm1VQNDy5MHZ5eALUWcuzH37noNvkk5ZlCbnlO/+twplXI/wCUW8Ji6+MCr15T+aQD
	P7y5TOCkUPwd/jT1kPCPK75+pXWHDS0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-mwZcN9ymPz2bqvO4KfcAhg-1; Thu, 06 Aug 2026 19:43:12 -0400
X-MC-Unique: mwZcN9ymPz2bqvO4KfcAhg-1
X-Mimecast-MFC-AGG-ID: mwZcN9ymPz2bqvO4KfcAhg_1786059791
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e62e3459fso285171485a.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 16:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786059791; x=1786664591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PgQO6c8L3JLrPOSlWX6dvSno5AXv3uRrAtPYOdKDujM=;
        b=Iz301R19ljH3kmkmFrVWUIythCuRcemRj1jQr+Eqqg7gxQ3kudW9cFg7PnIIERlDx1
         1T4XXajCat6dQMIgVp6yBfNbYnrCRGWbPRE4a2Yd7Wv9RclF2urdnbFt6oQ5gtFsJ0YZ
         0QWDgdumD7oPHM+UMFSF1GGUboXd9RUxZKX5ApbmxnNWw9bsaplAxjH23tGoiqylg1/c
         WZEBIWLl7vHMH1x0e+Ce5cP24AWvt++puxGtsgiSN/idBhgqa56XvJjwSfS1RgaWfkSz
         amSo1D3RxoyWsQEJf+O6a4xJxcvlrPYzW+hPJiDXgI7WS9AYNfZp2/xSLQx1wzOed4K3
         GL6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786059791; x=1786664591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PgQO6c8L3JLrPOSlWX6dvSno5AXv3uRrAtPYOdKDujM=;
        b=byDmY/MApy+LNCxUza8qbABbsMKER0pvwFDB7PkJG9arsvKQ9MAeo12rugzlHJ8xB9
         NJix43gwdO9y6KT7XQcgPEByNqe+Ac0X6smehNsbkBo+FeeOeglitckeRoKQrVxTV9o8
         lKcWseV8nveN9jRQBpLcIxliasYa72tE/WkjE0b/K72nJjZnAEJg8si5Uq6NlHKMXEXU
         tEZipDIrgTtjKh8bWiqUB1P2XDeahnb+2ujpI4FXS1uYCE0Zb7Z8F1VtVmI+uvZKh5dE
         FS7lQh4sq5RLv6GLpiOdMFzneqSwOFtblqoWv+WlMrG8Dh/+a6uzAaHm5R/hug/Vb3nt
         LE2g==
X-Gm-Message-State: AOJu0YyR+rJu+JLgseH+tkevDRtI2LO+GiV8hBbHJHCKq3BrOOao2Kyu
	3SYt22wMnhVF1/4fPKdtyB4h8fO45OL6GuPLwD+3gECao4ezWlvUXg0gd7jBsqMpgOsjNan9NJx
	0ZQ5jBFVPH5aRerqv/bTiSzhvxzXvA/p5N8MEGqucrZpSjMCAx9bQR+tmfhAlBgZLgMPUGQpF0f
	almm/35cMaKSSlyKmd5M5Xr9fe/hKxB0nf5Ot96iPKjT8V1E4=
X-Gm-Gg: AR+sD10dpGFkns5ie+QxL5yULI5uM55LFa6LBWtTGGtufpajghzqBTH/URTgEOrh0Ym
	h1P+33uyGqodTUpcgxBEqkGpM+COqm3S8FcXf7V0YjaRkpnGvDzqZb7Bk7hxuIsZgyMI0rgtfVn
	kP214kmCfbvKr+tEzWLRYxpngJ4BThtfVMSZnP3V6DaKZ6MamdB03Hpi3LcDrfkjoso4f5ft/gD
	0ThsbWc73EcoObKcMsgj6iEPuZifzt+25SfYYhbWD+viexCkGp/Tr8a25yqgh7xuQnHgpfYGVPD
	Bv+x3D1+3zwcM5zQBxH8TDtVdgZrUnIVnJkPrbYhcWiDF3S9Ea1FLibJ9tEPUCypj9SH6Hnla02
	p2RxgW+rAcWdxo145ljQE+k3eRidsmm0OvwrEwTBtH3gPYD1hcku02CJxQi/MKZjtxQ==
X-Received: by 2002:a05:620a:a003:b0:932:fd59:3e57 with SMTP id af79cd13be357-93649148855mr1850260885a.41.1786059791305;
        Thu, 06 Aug 2026 16:43:11 -0700 (PDT)
X-Received: by 2002:a05:620a:a003:b0:932:fd59:3e57 with SMTP id af79cd13be357-93649148855mr1850256785a.41.1786059790675;
        Thu, 06 Aug 2026 16:43:10 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e03f05bsm26891485a.2.2026.08.06.16.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 16:43:09 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com,
	pc@manguebit.org
Cc: stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/3] cifs: clear tcon after cifsFileInfo_put() in cifs_file_set_size()
Date: Thu,  6 Aug 2026 18:43:04 -0500
Message-ID: <20260806234306.3662175-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806234306.3662175-1-sorenson@redhat.com>
References: <20260806234306.3662175-1-sorenson@redhat.com>
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
index 2eab50dea774..d6caff2e29d9 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3121,6 +3121,7 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 							size, false);
 			cifs_dbg(FYI, "%s: set_file_size: rc = %d\n", __func__, rc);
 			cifsFileInfo_put(open_file);
+			tcon = NULL;
 		}
 	}
 
-- 
2.55.0

