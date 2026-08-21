Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACEA3BE16C
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 18:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787337689; cv=none; b=QdLUI/D2q7GFWfroIZniSO3NI8BiaTlVM+Yy8OIAVJpjvOSyVpuJqq3KspKjYmcilT9Yx9Gg++V3grVCqyTMWUIdXyzdpbWsIuiQonZsAfdD4VPX7YKH7GMlQ6f/KUPl7CRKiJU1EteR5lc1ZvvIqblEX7/fEinDQ47vow0He+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787337689; c=relaxed/simple;
	bh=VEtB8Ah6ZUnQoHBmv9KYP1wCthpDTt3Ro7V4Xp57/1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjF8lYOl75JOqvaIyHmOwj2DqV5BPxHo3QwZB7+iqiPCn5uFbqhj7Yk93vRjjPd1Pg3DHkELDhu+j08lXPF4OSeRwyrtLDsIPIUFO4fVTyovO2pOPPSjrI6QA5bZ5MAx4Msej0v/aXccwEv80BloleWmgFAE/1gtsS+gODJM7vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W818JKD7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KmLwbm5V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W818JKD7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KmLwbm5V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787337683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=heEDdHkafbRutO9HRgBGIvgZBLa13kRZzKt4emv50QY=;
	b=W818JKD7371y53cwRIB6b18/bsu0QAuPoObGgwFm2WkqKSt1Cy3N6nFkYzIGgpbPGLZJC7
	H41sskf9P/XoSTH/tBSgeMueZVuyEnNU87uf7Mwk9w2S8i5gsARiSvbii+8POJewMA4UeH
	ms/p2pixCH/RUU3suTQiQ1PcXzXW+Ck=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-UPZ_IRupMAWfS6p6DRRwQw-1; Fri, 21 Aug 2026 14:41:15 -0400
X-MC-Unique: UPZ_IRupMAWfS6p6DRRwQw-1
X-Mimecast-MFC-AGG-ID: UPZ_IRupMAWfS6p6DRRwQw_1787337675
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-836cda1b76bso60170307b3.2
        for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 11:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787337675; x=1787942475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=heEDdHkafbRutO9HRgBGIvgZBLa13kRZzKt4emv50QY=;
        b=KmLwbm5V49PGevnzsXGH23G3hlkCq99D2Tn9a/OXi2m8EySMnwwNgdZf1zr5p3hR0P
         QHowBpj3wYxK5holEaF5ygI9zFGKyAikFDyMrXncwPqy6joT2kBLDJkBhbGSPqn10OwD
         SMAFpy8XJwGk1vleGoF7UkNb0U8UdUvrz+MbbWrQX5J46nBrCiRneC93cmhr4z8WznX1
         OkoBo9v2Gy1fzn4unnj2NNAP7bLySt3S43cO8WHFZXFLA6NwsWh83YPZ/JyHE3wu5hxa
         9gLUNK4iQz4sTaSklSDjC1xSAeNXbVaSHQ8oHAqjW+EifiznjLXgcMvnU/vmiDZc/yn7
         Qong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787337675; x=1787942475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=heEDdHkafbRutO9HRgBGIvgZBLa13kRZzKt4emv50QY=;
        b=BcGnM5mU9FgjwRbZWAKhO1KfTPqJGRnaMZBSbcvm4AbQJF1x5TMM9PnWZkM6b+ep4Y
         8jiiBPLD6aXByd63/GwWJSV/5pJoS77dH7trfnXFrGP3YosKvgYfstlkw6UNPvIbiFT1
         ++L8AtYeU7vCl29M1N32FTZrJvQ32MaIQcq/740/3sRJFhr/wmOcde4ne6AQCFFoZ1Sj
         /KQS+R76s5dTejxj4oJASSFeZqu4VFJsWdAYOFq66QdYePw8hPE7AdRYy5lFMnevKcVB
         C6LGlZPWOHSq7kAAVPbLZG5grolN9Koc49XcomhfUkOdCFCMesHY7cijXI2YHlbnt0VB
         u+HA==
X-Gm-Message-State: AFuF++kygQa081YVnsPOUwUQLG8YveE8WsjerSVVxWEFq3EvAY0kvDuL
	Frx5AAnmp3FDK/wdBCDa7vz5qn7AakRyVo4Eu01/lW5xu9c+ySUznMwG8LP0G44wpZrvnayUkAt
	iyYue0jAMU1beTpX5wgvC3loHVObcD8VFgH9B2GS+X7+2s3JcF0oRKYXQIwDpF1RaJl1wJAUJld
	8aSRBBwbGqeu39ROGBQM/KoNEuIpK183GSH7wMS86q02zlbhk=
X-Gm-Gg: AR+sD12g+ZIbI14GyWAEpoEYkM9zseWPminsg07ZMvo8issKTcdxEtIg0VwMRR+9xL7
	NjErUQ7FlI2o94mZIX+UCIhUxZxd4QM4L+kJvYun21dsUadNpxNb8Qe54hqVZxPrLTblD3kY7bg
	YFn442sNyZ7LTh41mB+lhPJMAG7wuE+YJGTRZJkUOdfvjv+pnJrXQnQzG5AAO9tUyoKOrSItwAa
	U4B0gv4sDidXQarC9QC8QyJMwpa9GbEM+vrdPuSyKNCUGMHj+C6DGkwI7mkvkJQqYznFiEOE2rC
	XEPHc7Dpr7V2j5TARQQceDHaTXns1inIFMgZgSF7r1G7RaAkL0W7UjwXNmAH6RrYHXEtnCsH0AD
	b0alyfstmpaDfsQFsM/2E5BL6IRniEtLQbKI/cfVF0JlOdEhrc1s1rdd1ZXzUQ1c6KQ==
X-Received: by 2002:a05:690c:6004:b0:822:854d:4563 with SMTP id 00721157ae682-84c9682009cmr2516307b3.8.1787337674710;
        Fri, 21 Aug 2026 11:41:14 -0700 (PDT)
X-Received: by 2002:a05:690c:6004:b0:822:854d:4563 with SMTP id 00721157ae682-84c9682009cmr2516037b3.8.1787337674123;
        Fri, 21 Aug 2026 11:41:14 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cabd2861esm539707b3.37.2026.08.21.11.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:41:13 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v4 1/2] cifs: don't update i_size in cifs_do_truncate() without a cached handle
Date: Fri, 21 Aug 2026 13:41:08 -0500
Message-ID: <20260821184109.1834871-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821184109.1834871-1-sorenson@redhat.com>
References: <20260821184109.1834871-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If find_writable_file() returns NULL, cifs_file_flush() returns 0
without issuing set_file_size, and the outer if (!rc) block sets i_size
to 0 before the server is told to truncate.  If the subsequent
cifs_open() fails, the inode is stranded at size 0 while the server
file is unchanged.

Move netfs_resize_file() and cifs_setsize() inside the if (cfile) arm
so they only run after a successful set_file_size().  In the no-handle
else branch, call truncate_inode_pages() to evict stale pages before
the O_TRUNC open: cifs_invalidate_cache() is fscache-only and does not
touch the VFS page cache, so without it old pages persist and may be
served as stale data after a later file extension.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/file.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 389083f9ce00..05aeb9d94ffe 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1012,10 +1012,20 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 			server = tcon->ses->server;
 			rc = server->ops->set_file_size(xid, tcon,
 							cfile, 0, false);
-		}
-		if (!rc) {
-			netfs_resize_file(&cinode->netfs, 0, true);
-			cifs_setsize(inode, 0);
+			if (!rc) {
+				netfs_resize_file(&cinode->netfs, 0, true);
+				cifs_setsize(inode, 0);
+				cifs_invalidate_cache(inode, 0);
+			}
+		} else {
+			/*
+			 * No cached handle; the server truncates as part of the
+			 * O_TRUNC open request that follows.  Evict stale pages
+			 * from the page cache now so they cannot be served as
+			 * stale data after the file is later extended; i_size is
+			 * updated from the server's open response.
+			 */
+			truncate_inode_pages(inode->i_mapping, 0);
 			cifs_invalidate_cache(inode, 0);
 		}
 	}
-- 
2.55.0

