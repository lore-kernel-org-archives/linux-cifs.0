Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C193E638C
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 22:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930959; cv=none; b=efLsJrQoQMs35tYoOsrIVABBJHVnVfSDNjpinT/FFKqzGWfT36aSc0QaYsiXSjOuf2RIM+STobmupGrB9NOZbiMDfWVsvzKu7bvmn8mMni7pn4GGqTDuZcLZekpTSGPM3NfQEVd0RkWebdI78qQ30nkpzgAAgS6LyjJcniHLxYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930959; c=relaxed/simple;
	bh=8WvLjYpM6TPNS4CR3uFnJDjx3DY2gUkTQcAv0tECm4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UtqM/7VefJlZ3Ui/65AhnkT7bjm7181ngG2Tl+0XTmlAdm7inRaQoPDC+Cjzs4VruvOPTNJ3AJvvKkemeF5lc+aq3DGdvREBeR/I4SUUEqSGMVvqYfiTSY2HNA8itdmfcEkahLnnL+1XL2AWoMvCfzatYP/PpJiocypT0Fg5eW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KsJqvX/p; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UZNDMC22; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KsJqvX/p";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UZNDMC22"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784930956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Izpr9B1qppiKBJVcAyeQ89xsJQDGwcYRScqxrkF+iXg=;
	b=KsJqvX/pmo6+ZdspCeSbLwhNRIWM3/Us62GqzL5fWUaRl8oZQU5CyqrI+BmE8QWmwzjmTT
	qo4DeR+s5yf/RbLfB9up1OGROSL8pyVyFD6kKpu4mCfe8oDmotgYnyuSTQTkzo5TUWsHZV
	56PBMjGxSn7qDlOWNCMu+oP/sGNH9tg=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-SvX1wD0gO-6elhptFIxW6w-1; Fri, 24 Jul 2026 18:09:13 -0400
X-MC-Unique: SvX1wD0gO-6elhptFIxW6w-1
X-Mimecast-MFC-AGG-ID: SvX1wD0gO-6elhptFIxW6w_1784930952
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7ebeeb51976so1178017a34.1
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 15:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784930952; x=1785535752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Izpr9B1qppiKBJVcAyeQ89xsJQDGwcYRScqxrkF+iXg=;
        b=UZNDMC22D2Eq+t7wwtUypCmoIN5cn2qHgKNhAML0axAYAfP11J/mXLPUxgWt/wTgN6
         tTpZMNqycEiDfo1yk3nsadPawFd4xuHAuh6jl+7jh7dLTJckgpycsY9fUS0vHO5cE+a8
         M9A6cSekMbehOMoWf1uPcPEp5KVMYLzsXRHd7CaO+vd+Q1b/qOdxT+1TFsPYC9/A+kir
         yODt1JXjhfF9A+eKrmn5Fkw5DLFMTYs1LENmfIQ8QL3rYU2/AGMVBn0DeoJMU/Th/yXV
         hTwPAl8IDCf27AEtFhQXU3wDVJFN9zSuf0lsHg/hSCzgUV8XLyYXxzRPjcHHc+sRGaqY
         B02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930952; x=1785535752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Izpr9B1qppiKBJVcAyeQ89xsJQDGwcYRScqxrkF+iXg=;
        b=geyVWl7bBFO0tOoTLEbhvEGr9GxuWwuPxcVka0Xh/Zg/4eUpP2FUixKxOihmmxFKlH
         h1N7I+ccugZopgCM+b6oWiWp+rtS2X6u/iago9aq6ZaYMSqGpMz3W2EMmr8iXq7JBgmp
         UWdDXlTFKsGglazhaLf7t1soJylYHSFmGOUasxYTNzFFB98QyEcbkWHCHAaZekVeSFjf
         JZvcwWXNqJyYnT62cTlfJ2gXum+ko6/3/dY/z9FpqV9/M2SEPe1X4JssaurHio/T6c6w
         +dWo5HbABO23OU8Mw1suqr4U6C6K3eL4QVHMIypqf97//5Dv+j0ErRVk/Tx4fnKctwrW
         rlCQ==
X-Gm-Message-State: AOJu0YwKAV1lDquvKcPHlEwMtnWRtpOMCiMuMTyTdEu4uMpG5Ckzo19P
	SrQUrXpjrmXmdR/1Tz7KejVHZKceiVcPi69dCgECw016RoLlRb0o5u83m5Ni0L+PjaaifdWj+y+
	KOFIqKhNrgDtvqdY5DWjzSSFbKr7CXSanpIJ2YTInCmIcDifn+sEC0nO9X5spoeQQVSMStLLlSO
	qVsKVv0iFGxvOQhYWkfDmXs4wcHPI+PYZ/Zp0fiIKh3fBIL0th1Q==
X-Gm-Gg: AR+sD13bTW7bZBJD8ZwUedluE6SoSFnhPyDTKi+Ggl/soqnp5nP/OARZ9ZwmGcqYMEL
	CoXVlfnqqvvsEkVBUYkgqVjEKDRGS7yPeVfy7QyfbAfLreAgVeWI7sXA/hGontLLC7mhPyX3Mkr
	u2h+uff3EN7yjCzWOZO+7RORcDOh3tVp3XkdvYPtadaMuwNvSAPs8vkNqCCtV72Lqq4jmZRMxGa
	bDZRQcR76btHb3cpJMci234g/XX60LGIlVkkDbumXSRx45FpPJWvifo7N+K3M8YJwNgHSPWKPSO
	9A46yjg0VH0FVJJosv/yqC+ZHc0VzbutrlwvS4f5MWOk+cbJrbq9yY59BzLHjwbZFhkuWFkLWbr
	DmCvdyOfJyJEgVIDShUW4bj0nNhy1TE5IrI7wJ6QGu+BNiNK8QmoLsNQ4WP+G
X-Received: by 2002:a05:6830:1183:b0:7e9:b2cb:26f9 with SMTP id 46e09a7af769-7ee6bf0df39mr1936906a34.3.1784930952356;
        Fri, 24 Jul 2026 15:09:12 -0700 (PDT)
X-Received: by 2002:a05:6830:1183:b0:7e9:b2cb:26f9 with SMTP id 46e09a7af769-7ee6bf0df39mr1936876a34.3.1784930951883;
        Fri, 24 Jul 2026 15:09:11 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee29e0ec5bsm6926859a34.10.2026.07.24.15.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:09:11 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Cc: stable@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH] cifs: fix missing fscache_resize_cookie() calls in size-changing paths
Date: Fri, 24 Jul 2026 17:09:09 -0500
Message-ID: <20260724220909.2755102-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several code paths that update the VFS inode size via netfs_resize_file()
and cifs_setsize() omit the corresponding fscache_resize_cookie() call,
leaving the fscache cookie out of sync with the actual file size:

  - cifs_do_truncate() in file.c: truncates to zero on O_TRUNC open
  - smb2_duplicate_extents() in smb2ops.c: file clone extending EOF
  - smb3_simple_falloc() in smb2ops.c: two branches that extend EOF
    via write-range and SMB2_set_eof respectively

Add the missing fscache_resize_cookie() calls immediately after
cifs_setsize() in each of these paths, consistent with the pattern
used in the existing smb3_zero_range() and smb3_collapse_range() paths.

Fixes: 70431bfd825d ("cifs: Support fscache indexing rewrite")
Fixes: 93a43155127f ("cifs: Fix missing set of remote_i_size")
Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Fixes: 7a06d3b816d7 ("smb/client: emulate small EOF-extending mode 0 fallocate ranges")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/file.c    | 1 +
 fs/smb/client/smb2ops.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index ac89c1ba56b1..e329d1d87ec6 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1016,6 +1016,7 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 		if (!rc) {
 			netfs_resize_file(&cinode->netfs, 0, true);
 			cifs_setsize(inode, 0);
+			fscache_resize_cookie(cifs_inode_cookie(inode), 0);
 		}
 	}
 	if (cfile)
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index cbd51a08e97e..bee51f776cd8 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2224,6 +2224,7 @@ smb2_duplicate_extents(const unsigned int xid,
 			goto duplicate_extents_out;
 		netfs_resize_file(netfs_inode(inode), dest_off + len, true);
 		cifs_setsize(inode, dest_off + len);
+		fscache_resize_cookie(cifs_inode_cookie(inode), dest_off + len);
 	}
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
@@ -3778,6 +3779,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 			new_eof = off + len;
 			netfs_resize_file(&cifsi->netfs, new_eof, true);
 			cifs_setsize(inode, new_eof);
+			fscache_resize_cookie(cifs_inode_cookie(inode), new_eof);
 
 			qrc = SMB2_query_info(xid, tcon,
 					      cfile->fid.persistent_fid,
@@ -3827,6 +3829,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 
 		netfs_resize_file(&cifsi->netfs, new_eof, true);
 		cifs_setsize(inode, new_eof);
+		fscache_resize_cookie(cifs_inode_cookie(inode), new_eof);
 
 		qrc = SMB2_query_info(xid, tcon,
 				      cfile->fid.persistent_fid,
-- 
2.55.0

