Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1EC23AB8B;
	Sun, 12 Oct 2025 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760281896; cv=none; b=eoTjBpKhW0bNuQGRQ4FhVJCuwYXP5jhiVCELKQF4IVS9I9CdIV5y0nxncxfMwcLMi9jLP8rVcw5aa+I3lspedjGtbNpXIqVVaTJgyKShWnqs4ccoVkRoq2h5lU3ZDQ1/LhpuJMqZdex5Br/lb16qvi5NpAzPNfmHnXSeKRaGe9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760281896; c=relaxed/simple;
	bh=+Y1i4ZX5YAVz0aE+JKDU1tjQg9Po8/DgENzqiLN/5r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJbZ/xVjjw+465O686adm7xCQKzAHCLsHsoiZFd7zpX0FM6z1ybR8SngGdCv7jfa1F2Oo+itkFMaoHq2ws+4PQGnNdA5PR1mfH5kQBk6MF8QaSXAyDOORZRAI4nuYkncy3JhWRrs6rSavm6D5FM66rUbKrOgfKK6bilV5tcXXpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281807t75c4cc8e
X-QQ-Originating-IP: UyZ2o7bVvgbCJHD5CX4prJEMXtwN1vkYmAaq9IhCilQ=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:09:47 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 13205482269468112428
From: chenxiaosong@chenxiaosong.com
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 01/22] smb/server: fix possible memory leak in smb2_read()
Date: Sun, 12 Oct 2025 23:08:54 +0800
Message-ID: <029014EF18C9D322+20251012150915.2992220-2-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: ONZj3wp/10Pu4eHoya/pnCPKkj5kmSzPx/7CyjdBM5mBgAmfGlJmdeM0
	xh/HGLiN/oDtMwyKzxRbLRf8RY5ukzKQgDJz6mKS861eCcpszgXO3mLMJgswD95mPbGMnWr
	tSczahO7OWnmfAnXRtGXwmys1Wk4y+qCHYME3Z6fsy9kbuZJwoSIUA6B9OILuI9FmO/o4Pk
	epNhuWS/QM8A6M9c1BMj8iwBPlnaqduAIy+qMIFWg3WrhvhGnvQ/7R5z5YbYeWcnhLuU1vu
	K5t688WYBn1O9CG/4EZ1egdq5mNKuQJXskk2DVy2J0WcJhgi2iTgYG2TBOSYcLd91Hw1dp2
	goXlqO7NXTMb5/mhOiFSDaZqRfboQ7xuKqpUQD4qZJtlk5uISv6XnhwrawIfkmbpblLFWpb
	ErWKdU1VAuikOfWCepS5k8eNKMWizUPvW8/2jvv6scwnBYrhVpdYDq3e3TEVfcuyPMxC+TH
	/Ht+0C+4yzUWd3eTG2PMbtSvT2ohjUQrpJYtKSktPK4m2ZT9W0x4GkxrpGzufP1F9c5/heo
	pd9Vsh58R0BJrqNTh3ElIt9kgmBKtNY8PMfecVbZBaO3BaoAq7oc+41dwaTQlpGtZAj8NJP
	TQIQaw4kkYvFlSw1OViOap3x6QP3Lw/wvLlDgkV8Jlyd8fmX7eb+CvWxIwP132XZJVlKNl5
	pnoWRjJKGditgqG/TD1TAt1LMFVdfVScH0MW9Nb8Dgvt/Y4v7goOyvyO59xSPJ4QOLyI2s8
	njKQby61yBNinjPWUoQAQvpvLmnkdJ5YVByLgAKwpoEfGV9ObtwgkxSI6aeS85SyuHjnH71
	a4fYIceuOye2KgNKIZkbOzd+apVV8jXLRwpQtAhYDBA3Q2XwsPkpk/dPUsm6qU9e7x27fA6
	AH/3s7MhC8VwwEfBb+JygbDnrX7XW+JuNUYags8Dut75FZAHFoiqtQbSEXmtEN0/JGR6hvt
	Dd6WuKtehqBQ/JiUUa48a3dSWzXY10Q/TPGIovvwtdHYoWQEI0HKlIOYdc9s6xQgIoqRR7j
	wnSatv8Z1UESkjRJm7FgeOeYDyh7c=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Memory leak occurs when ksmbd_vfs_read() fails.
Fix this by adding the missing kvfree().

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ab1d45fcebde..e81e615f322a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6824,6 +6824,7 @@ int smb2_read(struct ksmbd_work *work)
 
 	nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
 	if (nbytes < 0) {
+		kvfree(aux_payload_buf);
 		err = nbytes;
 		goto out;
 	}
-- 
2.43.0

