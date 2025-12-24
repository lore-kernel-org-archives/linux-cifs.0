Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E9F433A0
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766588687; cv=none; b=Z+hIkKy2NIbD62iad3mKCF0fzcoJ1+oWMaDrVSLLzUjj+sgDrIF8JFpuRyTzsucy/TcmfXaeendAzf3gF2eIjw6j5hn3emJzD4C3BBie+FgfwMJJinwUkPRibaj79UITRFsWxXbc7fdU5iqwexI3oJNhc/JS2Nhz0Yo0jOhlFqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766588687; c=relaxed/simple;
	bh=dhYniTyfF5zPEtno14k0k0PUzvH/ywUHihY2sN5J7Kw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWPN2NDiXLiuvgeTv+afsYA6X0HXa13CRwg45hdfjhpnFmr+LMLH/4PikOfNcmPKK93qzd4u+YEzSjHQxFLlwFyQJnfWYqZmcJinrGxbVsyfCNP0acCrlm/P4Q63btNwXfJgImwE/A9/2Mh70Sz0GcIFWlQBe/ZVbZlGeL9qCzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y88WSZWF; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y88WSZWF"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4779cb0a33fso61075625e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 07:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766588684; x=1767193484; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x6vgQ2WvDlQ03BdD9ZHV1BpDmU6apfAemm6SW7GoYSA=;
        b=Y88WSZWFxPWrbwcfyKNMKNsyFt2lCWxxw8G+cyUQ8Ho0QbQvvgy63cJ2kZ7+55PJKe
         hfva/ZjFnuhUBwV6G2oK2YAj57MHTV5JLZMG5rN5BtVY2wWinZtkqa6PIekKJ1x9KFGB
         lzzKtqYcTr8A61er8ux15//SpsKpKFkFBLDDfrJucJzaIJiA9ljIRTJyJ9ERYCL03mJQ
         tHUQfGtxz7xxjmwy0o+nc7DHBBGQYNnMGxgUSaa+35H5+Tvhucj372c7pcJyuFNQnhjd
         6Z8+nbWkbfeXv/PvotYGF8r5/+80zqC3R+k4BDiJITjbQkFWKP8rHanBpd4MALTePQXM
         HSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766588684; x=1767193484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6vgQ2WvDlQ03BdD9ZHV1BpDmU6apfAemm6SW7GoYSA=;
        b=cn9IOOGcOh7zNhvGS4UjA+jvUHONgq8aHS6Rug/ZcNbenQ6/AnwwmcrirLuhi44p+x
         jIA/C8OjxJLKXImZaWNIuT9y33qYlm0XbG+/oXr/gi8/zD6j2cUl7GqD/p3BW4FnWooy
         AiBAGzfCvmCBi+2YcNz+nntT1uRr0k+1YRs40fUN7grMhag1DMqInYd+n+88NUDX27c2
         whJtRhG0uuobESz72QPbcQufkHHMGdd6yrauntFo5v8j8WJ3EkwhC7eqVB4wN5Ck3K8X
         D8njskkWqcv++HI1ptM8nLgxY6b8k01znN3ZsSKQAc7C4WV8PxTtvczMuR8uAyVrKoUK
         gDYQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/hp5Tlly8pNNNIcGIOEIL8M+gi9uh3861pw8Gb2PwpHfTi0C2vIoactWDN4C9165Xlj6uKPINsz33@vger.kernel.org
X-Gm-Message-State: AOJu0YydKkq/+hBaG+DnZ5svJvYfsX46wgChdnhY/O+hxO7rlWXD2Kf4
	NWbpcSOYe3tGrJt/Vyhvs/mHqySmEdt34veTCu8AjRawhrawjXt6nRirwjrQo0THOWQ=
X-Gm-Gg: AY/fxX6zitPL39cO9+FzyctrbcaOpzO5aliWuITMyYTKowbdf4qEQNEN8HlKHv2Rlse
	06GgV7qpc8UKG0lrUtKXTTmdrWOh47L34x2eBF5vBZ/OwnSHExS8OmEvWIu+sEJhqyBSKBD1m+3
	BUiQRAL7GmkLIMev8iwWr44TaKWCGB4/1adobOYZbHeJiyEkompmG+7CWeMrT0Jk/dWjisfbacW
	kB6IfOCwoGOgqhvGw4WR3rhNkeHJArZQPrlS/K8BeZEaNRPEGZVt7Lbvpzw2/XYRjoQLBbis42E
	ubb2q7YSqs4ttPC+xsynmB3jN80AdC+1YHgGIsEUtSrQRKZOqxYf83Q5NCeCqSDMBu9QUsthe5A
	P1R1ZdmkXHJ+hstgr5q4EAJDK77ZGY+Bi9NWKJGBsTRvdrSjalcN8SSlixoJ55gPc6UvEoEVfwa
	dKKGGJ2GfM2/Gc0mUIq3pUraTguBXcd4bFj2X8k4njgLj7lHLEA06OhCFQ
X-Google-Smtp-Source: AGHT+IG/p66b2dj0vMD73tyFmxJY2zl3v39m9f22zHgNV0pPa/PqpWnKNul/s5rpohGf4mM9W8CbIQ==
X-Received: by 2002:a05:600c:6812:b0:477:63b5:7148 with SMTP id 5b1f17b1804b1-47d1955b97cmr191212655e9.6.1766588683961;
        Wed, 24 Dec 2025 07:04:43 -0800 (PST)
Received: from precision (138-121-184-134.wiff.com.br. [138.121.184.134])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05fcfc1b7sm41280977eec.0.2025.12.24.07.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 07:04:43 -0800 (PST)
Date: Wed, 24 Dec 2025 12:02:22 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Steve French <smfrench@gmail.com>, gustavoars@kernel.org
Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Subject: Re: generic/013 failure to Samba
Message-ID: <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
References: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="i4pdk75fdtxvybxd"
Content-Disposition: inline
In-Reply-To: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>


--i4pdk75fdtxvybxd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This UBSAN report is consistent with struct copychunk_ioctl_req::Chunks[]
being annotated with __counted_by_le(ChunkCount) while ChunkCount is not
set to the allocated capacity before we start populating the array. This is
the same class of issue described in [1].

A fix would be to set ChunkCount to chunk_count (capacity) at the start
of each iteration before accessing Chunks[]. Proposed patch is attached.

However, if my interpretation is correct, I would expect the first
population to trip as well since ChunkCount starts at 0, which does not
happen.

@Gustavo do you have any insight into why the first access might not
trigger?

[1] https://people.kernel.org/gustavoars/how-to-use-the-new-counted_by-attribute-in-c-and-linux

-- 
Henrique
SUSE Labs

--i4pdk75fdtxvybxd
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-smb-client-fix-UBSAN-array-index-out-of-bounds-in-sm.patch"

From 9ebdd134dd01f19219b7f1634e2b577fe5778824 Mon Sep 17 00:00:00 2001
From: Henrique Carvalho <henrique.carvalho@suse.com>
Date: Wed, 24 Dec 2025 01:17:25 -0300
Subject: [PATCH] smb: client: fix UBSAN array-index-out-of-bounds in
 smb2_copychunk_range

struct copychunk_ioctl_req::ChunkCount is annotated with
__counted_by_le() as the number of elements in Chunks[].

smb2_copychunk_range reuses ChunkCount to store the number of chunks
sent in the current iteration. If a later iteration populates more
chunks than a previous one, the stale smaller value trips UBSAN.

Set ChunkCount to chunk_count (allocated capacity) before populating
Chunks[].

Fixes: cc26f593dc19 ("smb: move copychunk definitions to common/smb2pdu.h")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a16ded46b5a2..c1aaf77e187b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1905,6 +1905,12 @@ smb2_copychunk_range(const unsigned int xid,
 		src_off_prev = src_off;
 		dst_off_prev = dst_off;
 
+		/*
+		 * __counted_by_le(ChunkCount): set to allocated chunks before
+		 * populating Chunks[]
+		 */
+		cc_req->ChunkCount = cpu_to_le32(chunk_count);
+
 		chunks = 0;
 		copy_bytes = 0;
 		copy_bytes_left = umin(total_bytes_left, tcon->max_bytes_copy);
-- 
2.50.1


--i4pdk75fdtxvybxd--
