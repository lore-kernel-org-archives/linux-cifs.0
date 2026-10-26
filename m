Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793019395;
	b=4r+3+1xFvOpeW/ADt5SD4xa0JaGoNTIqCiI6J8xbzlrQCBcHAVAPFSKkOlA5fNvObwUZ
	 GLU2M9Tg4y3wXECA5CF+xrKAwFBHVRUmH9WMpj5AOVzxAN5wAmpUIzJSrnROTsQIdbbsH
	 0ewGUt1f7d2NmCQ1BUIsrsrIhu99OuEVirOUYAwh+1b1148VXrQG2hn68c4UZdM87nf+S
	 j/MIjRt2Rh7OTIrwtPz2uTetu6kCrs4CzBOh2XWGWRoUsGKW+x7jgYv7yzntLENvFJ7Nu
	 L4a3pfpjrt1heWFYScmuCwc56FVce/9FleaQEdl6kyQgHTv9iUGZzRlCuWyCgGcDcmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793019395;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6SBcn9jDTTFVGSgjb+hg+o69q85XjfukBj226MovYXA=;
	b=qjsf/cl2otIxhBLBFJeDMsxL9hxpmRHYxt5YO1pkD6yygMcNlNQbauDN2Kz2NlUsqMzn
	 X5HzbHzcwu2NxCGYqZIgTGT7ZX37LF9ZXzpvFB+66kb44htPUHGjq5KkYFiXjXscOFfXq
	 RwrFjYJhaX+XeAfiT4RDgXCSVr/2LcT/RqiD1PXJqCpNVHPdJW7LU+BR0zkwDRTMqL++3
	 ZO6Si0KlbZHhiq7YYkGLUQ8DMVfioTLvPM6QKwhgyVQd+DKBFCMTjEgVAtKijY36fxKZc
	 o8vlWFux1m3tcUzACei3BPQiX+id3vTy58BRTR9m91sYUMNPAobhy/FNejqpG6dH8gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=c+OEEaEk;
	arc=none smtp.remote-ip=209.85.208.176
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8451C606A31A
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 12:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8451C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=c+OEEaEk
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3a75f960be3so25464561fa.2
        for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 05:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793019393; x=1793624193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6SBcn9jDTTFVGSgjb+hg+o69q85XjfukBj226MovYXA=;
        b=c+OEEaEkqr9qOvD/m9ypNhPHIFw5AfdXQ4uaFDPyIMSgH6Bzden/lrGRId1QIhBPua
         XUuhAcNdjI45c3xfNSsTsrVQFe68pm/u8nqooFRipSh/2xjY04LosuJ36a5WScDaO4Ql
         +rJxx+MhopTRc8EpK2BQ5E5iup/K2P7B8JhGbycBKq8Bsoy1Nc61dPdHCjB1qCp5y4aS
         lrxAZ8tgQp+Ieak86C1CJ+0dASNRa0idAtNKgRhOhgj3nX7rrqyFrpBNODyBNbUZylJP
         r5ib1jQt6rqZQFM4kOViulwMwR3cGDPbLr4tzUGO4lEK/ELVDNrWPQD8hPbCTXbIrroV
         csSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793019393; x=1793624193;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6SBcn9jDTTFVGSgjb+hg+o69q85XjfukBj226MovYXA=;
        b=lqNgdLL3kduyNvnNTvTYYNZPpntc8gvpU1pfWdNv+EHNgCcXjOdjorzoS0copkSdoN
         u+z5MCr7agFTnAJETR1sv60x6Lh/F8aLos6tsonCx8lCAAlZPO35w3T0NnejnkqovJM/
         dP7p80uWppKaTlVuoYpdY/LQ1v8mdsjlGAatLIj4USdjA8+KLW55PVfWROuo72F66k3S
         DxIOUgM+XOwqYlh1rolhXCzcKIgXwySX+aNe6q3TQKsAuH7MxsTtkJOu979CpTyClun1
         S2Vc7aprsa4hjpBMVuMAbZSf3s3oy6b9hgnF90QgjA4Z4ewYISu/Pk0GpGdswcXcFbDv
         d6aA==
X-Forwarded-Encrypted: i=1; AKwUvByeG7K4hUsNylBOpGm2r9WcqIFtpv4XlRIwLG4aqrQVU4A9V039wrXDUhD0b33H+3NLkPvgEDqxxxvr@vger.kernel.org
X-Gm-Message-State: AFq9FYLhJp/JL/zOL90uIvAGjG8RsFbJD69BKfJpKDh6WjABSDACI74u
	8fIRsVBQCYc7BEXkWVSVsSE8m/P357Zzc8ds9H/gFGrMbJCmIiMWdN5Y
X-Gm-Gg: AYBFou1XTrB085sOqzLnX7hMFfd4KCRaTLLmxTppIrBKYkQbyMWuk1XkblnupmFAMaT
	6pEFbUMJcCi6Z60h0PIgYwekRnuKxOVehyVWSzO0riDSfWmrm9sFKBm0KD/Sctods55h50YanaI
	IVdmCjaxLH+FZ9msEcli6Bzi5y6jOzstg3cE65VSQ2IBoI0hZ/AjFFC2MdR1OdXe2h6qzNL7NHM
	xW8zUEX9pAHkz7/AkrHA8NH9wXa5MU1eLy1gt7nfwENvkfJQZE3cJubepa3ADTgznVaneJvPRrU
	Olx1HSNAq4K/+ICegdPo9BP0lGKRUuQHUuj1QxSTFdCq/porQxFENKpF8wyaXBWC8mguOPkqa3j
	4sVHmYGg03SJO4TFP6gzc4LJPSPs4bZKrz1LbaDKYIZd4LgG9MSxrO0Lxah6Q9Yj5qEiq+HR2st
	9xTV6R2kLzCWppC6yHtYLoAZqDBqUW63781+aD+DqbZch/L3jtHN7wzyosr6VBmTE5EsL1eI/Cu
	sscd9kDi6AYmRRJGz1jHOAYmRUwwzbu7Oa0pFlyOZqjM5aTO+E4QI47
X-Received: by 2002:a05:651c:31c6:b0:3ab:2517:6a6c with SMTP id 38308e7fff4ca-3ac6fcbf299mr15992611fa.7.1793019392658;
        Mon, 26 Oct 2026 05:56:32 -0700 (PDT)
Received: from arch-pc.lan ([185.141.180.16])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ac70993e89sm18258191fa.9.2026.10.26.05.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 05:56:32 -0700 (PDT)
From: Denis Kulikov <dar1knessx@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Denis Kulikov <dar1knessx@gmail.com>
Subject: [PATCH] ksmbd: use the resolved share path for the share root
Date: Mon, 26 Oct 2026 15:55:41 +0300
Message-ID: <20261026125541.87507-1-dar1knessx@gmail.com>
X-Mailer: git-send-email 2.56.0
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

If the share path is a mount point and crossmnt is not set (crossmnt = no,
or ksmbd-tools that predate the option), the share root looks empty to
clients: QUERY_DIRECTORY on it returns only "." and "..". Files created
in the root go to the mounted filesystem, but a directory query cannot
find them afterwards, so e.g. "rm" of a file that was just uploaded
fails with STATUS_NO_SUCH_FILE.

An empty name refers to the share root. For it, ksmbd_vfs_path_lookup()
looks up share_conf->path again starting from its parent, and the mount
on the last component is not followed, which gives the directory covered
by the mount. All other names are looked up relative to
share_conf->vfs_path, which was resolved through the mount when the
share was set up.

share_conf->vfs_path already refers to the share root, so return a
reference to it instead of looking the path up again.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Signed-off-by: Denis Kulikov <dar1knessx@gmail.com>
---
Tested on x86_64 hardware running v7.3 with this change applied to the
ksmbd module: share on a loop-mounted ext4, crossmnt = no, smbclient.
Without the patch the root lists only "." and ".."; with it all files
are listed and put/ls/rm work. Also tested on current mainline in QEMU.

 fs/smb/server/vfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 4ee72eda9bc0..1f2bc76f0d09 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -66,12 +66,13 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
 		if (for_remove)
 			return -EINVAL;
 
-		pathname = share_conf->path;
-		root_share_path = NULL;
-	} else {
-		flags |= LOOKUP_BENEATH;
+		*path = share_conf->vfs_path;
+		path_get(path);
+		return 0;
 	}
 
+	flags |= LOOKUP_BENEATH;
+
 	CLASS(filename_kernel, filename)(pathname);
 	scoped_with_init_fs()
 		err = vfs_path_parent_lookup(filename, flags, path, &last,
-- 
2.56.0

