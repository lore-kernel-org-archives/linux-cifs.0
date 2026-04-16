Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A543735BDB2
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 21:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776375455; cv=none; b=K6PafQyLjPgybn7h22lGw/HW3svqA63khAQEs9+vxO3UheZiexPIBnBhW6bON37XDiSfN94mcjX+PB6B588qMTWgFychcwoOAjKjd2ViyMbSAkWiMpsLTpHCDJYZ80iN0l96p9LE+Nq0vp59QHVvWmOY/wjKh3nIKwS3gf5JPBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776375455; c=relaxed/simple;
	bh=SnJvrHty8riZtWpxkx6xz7jX8W81q+Yde+8ssBb8Yyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C6O97oay0fxlJ2RERzyTXzYJAk7nPB74p01GbA8tmT1YsW/YzmgFvEihd7kKRyuAUP1WlE0tBKP/f4GcsHEghgRGgzR4k6m8AbcYnZdMuwaRwiRPQ+n5eAaKWbSmZkfLypliztZt+nJlbhiiajI2nX9t2lotRdwIz0Vt8MkHDjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DQ3WhE1F; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DQ3WhE1F"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8aca6bd57cfso34506d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 14:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776375452; x=1776980252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=huo/l1LVhl1kS5YAYBF6Ffd0gihdNIPyirAcpm8PYyY=;
        b=DQ3WhE1FW8oCZhNMiUEXPKyHXJC+mjC0AEBe8XBcCSi95GVWb/qzZHyiDArldp7uhZ
         wELm4JJ7ZCOzzdXoRPlHB0a/HfyCxngleZtDS51R9nnOz3H5TM/nd+rvLsVvO9e4sG52
         voXAgo33dMr1DfnorR3OV5350WJbWoz8qlGhL7LyU8MlVW6eKeN3o5WWdmjtCpLruJi4
         no6EOfSGqu5rzh7j6NVA3GS8iFay5i3EskCJP7Fw5nJAgJoLpAqgnY2MRYvV1aSzNURU
         5WyVKS5uoZpRk+eeD3VaTA4xOvRuzEVU7DAwijH9c8vxuhPJVZ88mJtBBJRKBtWBz5G+
         78ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776375452; x=1776980252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=huo/l1LVhl1kS5YAYBF6Ffd0gihdNIPyirAcpm8PYyY=;
        b=IU2xLs8nqiQgNORVMCcJWQ2WjMLIyLXhHPrQpvrJhHd7p/jfqkcYoU767/AO/UCeMC
         jkDfgNqnmp7mKFopV0w13nIgZ+YgocBqEvfbnYxG5GEWMP1Kqp+j/9t8sfK4x0iBwL69
         ObNzgr8DNnHKgXgVwRFFHc69iaAseDZQQXyPWnv9DnqQo+5ZA9gxwV4eJwlLbqN6MjxK
         RY4fp943b+4iRnnogbhB82RoBoG9q95HBfST/qx0UMG8BH11PThZEU+Z118BhS93ml60
         98VDQytqEoI658deiSGdVCJ7uAF6HjNLl8DA19wooCXIn+W1Jx4bQiRIFEwnoTw7sIn+
         Q1qA==
X-Forwarded-Encrypted: i=1; AFNElJ/N9W+OWllkuVfLBvvtmYsUj103HUIbHHqRCv1Ef0SaVXneZmO8FE8o3o1NriAJWsLY2J9WF6hgdnWM@vger.kernel.org
X-Gm-Message-State: AOJu0YxVfyx218wj0MjKryabB0e5nAQAbxOYsrBAyLlXjHOxQDkWaBW3
	FLf2urdNwZ0fAt1/xh4t1Eljc9Saavl5ljzJGw9ASksddfradbG+H8tq
X-Gm-Gg: AeBDiev2a6Guc9utx1k1JkEi3Gor4Z50b6TSNbVnNLjp3V58IeQxWoB9rHhc4D9gyK3
	8aKpOjoFLJ5zg7V7Wu/HTzA8YvC8FcoAsnaRMUc2ToMWHZQjL5xjXhgyA74ZXdCQfDewGFgM5RF
	E3z6LpF47Za0jiIP+A43t9nBKMhwkHTClaZ1EyaWa7Yad0xXQPlkmvI9PWaQCnO4RuODJ5pv2yY
	+cxNBEHD5BDDj6TJwJotRZSw3bcunIlhMWPugBJAb82KyLY7cUGyXn/8Ou4Rz6ycFxcTrF8lFRI
	apb1LfC+rHuYs1Bv/XWDTuTUGp/ybC5p4pD8/L9eB/nDnpj08xb3gO931YTpiVmxgUuxrjKdEau
	YYh/nw8gWKhdV09bnq1n9cxDFxE3hX5HmhsO8nlESd1C4kPdHmJV3hsScbELPhk2T9Mv1OU3SGu
	jIXIHEgRsNjpryrucTkuw6P4+cMRZ9bAEE6/rH/VloexmtUvX7L9b8d486VeF7ua2Gt0PfOF4l8
	I6Nydi+MWTefMAkeF79Q7yGh1l1WGGTDppvwRVBSTG+7LdPXN4tVQ==
X-Received: by 2002:ad4:5d42:0:b0:8ac:a4f9:da7a with SMTP id 6a1803df08f44-8b0280f7e88mr4451406d6.32.1776375452536;
        Thu, 16 Apr 2026 14:37:32 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ae6cb9eb87sm44823896d6.32.2026.04.16.14.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 14:37:31 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix OOB read in smb2_ioctl_query_info QUERY_INFO path
Date: Thu, 16 Apr 2026 17:37:16 -0400
Message-ID: <20260416213716.3118443-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Another client side from my clanker. smb2_ioctl_query_info() has two
response-copy branches: PASSTHRU_FSCTL and the default QUERY_INFO path.
The FSCTL branch validates that the server-reported output length fits
within the response iov:

    if (qi.input_buffer_length > 0 &&
        le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length
        > rsp_iov[1].iov_len)

The QUERY_INFO branch has no equivalent check:

    qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
    if (le32_to_cpu(qi_rsp->OutputBufferLength) < qi.input_buffer_length)
        qi.input_buffer_length = le32_to_cpu(qi_rsp->OutputBufferLength);
    ...
    copy_to_user(pqi + 1, qi_rsp->Buffer, qi.input_buffer_length)

A malicious server can set OutputBufferLength larger than the actual
response, causing copy_to_user to read past the slab allocation into
adjacent kernel heap.

Reproduced under UML + KASAN by constructing a 73-byte response
(sizeof(struct smb2_query_info_rsp) + 1) with OutputBufferLength=2,
forcing a read 1 byte past the allocation:

  BUG: KASAN: slab-out-of-bounds in _nfs4_do_fsinfo
  Read of size 1 at addr ... by task mount.nfs4/219

Confirmed rejection without splat after patch applied.

Add the same bounds check used by the FSCTL branch.

Fixes: 5242fcb706cb ("cifs: fix bi-directional fsctl passthrough calls")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 fs/smb/client/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 509fcea28a42..de10077320e1 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1783,6 +1783,12 @@ smb2_ioctl_query_info(const unsigned int xid,
 		qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 		if (le32_to_cpu(qi_rsp->OutputBufferLength) < qi.input_buffer_length)
 			qi.input_buffer_length = le32_to_cpu(qi_rsp->OutputBufferLength);
+		if (qi.input_buffer_length > 0 &&
+		    sizeof(struct smb2_query_info_rsp) + qi.input_buffer_length
+		    > rsp_iov[1].iov_len) {
+			rc = -EFAULT;
+			goto out;
+		}
 		if (copy_to_user(&pqi->input_buffer_length,
 				 &qi.input_buffer_length,
 				 sizeof(qi.input_buffer_length))) {
-- 
2.53.0

