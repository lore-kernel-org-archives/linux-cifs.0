Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564AE23B638;
	Fri,  7 Nov 2025 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762524117; cv=none; b=iIzI/oTaWaFUwcWVFgzR7uR7hOSFcO36cXeluCcVOmTquTGL4039XYlMyaM+gIY855YyBn6NcJcyjFhv7/8zGV8Da580Wwr5wxNYNbZoXkW+I1vbBPJ2mXin2Mnajd+O61Cg4NNRHTYYvgSpsjWRz/trA4rHypwtXHBeUdniioU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762524117; c=relaxed/simple;
	bh=scUDJhF4SHxD2LeiWfW3HwnUCLV+2kXA/sCsExXtlQk=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=Y2a5ibrGPtO11wtDqRp91LMzYsO8QLjxx1XOd6rDgdV+j5X1xI31ZYOJhfyc4/tV628M4WFgQH4Z6GOiaFnw04/oe8CfsogmDUx+vzQNbw4FPNmkGDlnoJfYzpqIPiMoWhPx1v4K/cTD7habbJN+f0+YemWCkNmBXHrJ+x3693I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=zqgispbW; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="zqgispbW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1762524103; bh=88CqQVoCZpXl6pSXFcKCKbx0xO7QSECEV3gJ41owLVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqgispbW0ScL2ZjE/E5kOHNOfXvA0DDHQHwAXf2rdpJOHZPAlfPiqdSZglw13HChc
	 ph8TB0ouvnReFHvjuPPWu752e6+zwEQ+a2cMGX9D/64abhBdgyhAltab7U0CCiz2cq
	 CKZNTZ8tAYtX1qLJK/5na0fPPflzh7KVi5k33nRg=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.201.7.117])
	by newxmesmtplogicsvrszb20-1.qq.com (NewEsmtp) with SMTP
	id 66A52E7; Fri, 07 Nov 2025 22:01:38 +0800
X-QQ-mid: xmsmtpt1762524098tieus4ud2
Message-ID: <tencent_5D8667DBC6ECD2FF464349ADEEFD2EE84C06@qq.com>
X-QQ-XMAILINFO: OATpkVjS499umwbUbosFTV8W9DlQ4fIB7LhH/l3DvwepTwAyzZSNNU1xNKNPVg
	 6ZM4X473+wmg/vPAaAHn6Zqux+UuRkfxGegVmtCIMYhx4voCCpZ04LOZAQ93mQswPEr7mZRY3jW4
	 JXgdo54IKJRy515P5fclUo1nw9CfemOwFtvGdE+yKiOx4fAofA0VEDhom5o75bVztVwtSLSs4y8s
	 YHzMoH+/zA7khfmXm4EtqJpLz831Ph1DT0sAUY+XQd8Bww/RfuQBm1nPtDwdwBCRXAIiYVBQpIUO
	 krRyMMG56uUvBEVHg5AwZBny3jSYBilY3WV8IQXUtsgVfrzKVrUQp1QZJ+bQ37/d2idoD5gmyR7j
	 fhJ7sO96oS3yf/hE/Hp2izo9VPwBRn8Ak4dhhtseid5IZ1ScE4i7OVbycH7yf5yZzXCuJWxczkM1
	 n4TrLKyoo0cBetKitcGCCeEPH4emY9c/t27TovpWYan+FMKoy7CioDrS3TfhDkHoFpZkkLTmGd0u
	 Wg8+r25iC4E+BThN5Xap//nhQwkO5RtzCUILw5dtp/LXFjOeHTvxOmsKCDsqy40+QoajawgiRTuN
	 SY75TayfIcuvfJe5bf+6HYPlP7rgyVddvBKdU933Ay1tjyU/czcWGD/Yq2RV1MovLSUX68VGdDYi
	 ktcrGZGdPXe8BXmOVSP6XYlE86MwYHwC8HfeGmiI6TJhfrK6BV+TM9pSPb8e2MtOVOaeu9Qccoqb
	 yzB+7DmEUgA53W8d/4VyoTgxxnbHf0gwy2wCdF/trKOfKrx68b6mdpoCqnvBkor6qGSQGsLhxvNW
	 pmALaNnN3OucFllBod8wEAglS27fLOws4p2VGh0qaya3CXQvTd3QFtZhbkPm7Tj1sKGnppJRJQf7
	 GZ+6axeNLbr4hplmP/ntSjVvV5JBarj7AUdEgFeCfHoGL8ovdRIkBIVPC1cvanbq5mevTCrc4Wmb
	 C7oIilLL+8gmxkWX5EGZxh59AE3UPw/NGqyvtOHZMrPtNr3rTiMz3pduP+nPTqbEnLx7ZTr2U=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com
Cc: bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	samba-technical@lists.samba.org,
	sfrench@samba.org,
	sprasad@microsoft.com,
	syzkaller-bugs@googlegroups.com,
	tom@talpey.com
Subject: [PATCH] cifs: client: fix memory leak in smb3_fs_context_parse_param
Date: Fri,  7 Nov 2025 22:01:39 +0800
X-OQ-MSGID: <20251107140138.3897816-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <690da014.a70a0220.22f260.0026.GAE@google.com>
References: <690da014.a70a0220.22f260.0026.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The user calls fsconfig twice, but when the program exits, free() only
frees ctx->source for the second fsconfig, not the first.
Regarding fc->source, there is no code in the fs context related to its
memory reclamation.

To fix this memory leak, release the source memory corresponding to ctx
or fc before each parsing.

syzbot reported:
BUG: memory leak
unreferenced object 0xffff888128afa360 (size 96):
  backtrace (crc 79c9c7ba):
    kstrdup+0x3c/0x80 mm/util.c:84
    smb3_fs_context_parse_param+0x229b/0x36c0 fs/smb/client/fs_context.c:1444

BUG: memory leak
unreferenced object 0xffff888112c7d900 (size 96):
  backtrace (crc 79c9c7ba):
    smb3_fs_context_fullpath+0x70/0x1b0 fs/smb/client/fs_context.c:629
    smb3_fs_context_parse_param+0x2266/0x36c0 fs/smb/client/fs_context.c:1438

Reported-by: syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=72afd4c236e6bc3f4bac
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/smb/client/fs_context.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index e60927b2a7c8..0e1949bcd6ea 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1435,12 +1435,14 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			cifs_errorf(fc, "Unknown error parsing devname\n");
 			goto cifs_parse_mount_err;
 		}
+		kfree(ctx->source);
 		ctx->source = smb3_fs_context_fullpath(ctx, '/');
 		if (IS_ERR(ctx->source)) {
 			ctx->source = NULL;
 			cifs_errorf(fc, "OOM when copying UNC string\n");
 			goto cifs_parse_mount_err;
 		}
+		kfree(fc->source);
 		fc->source = kstrdup(ctx->source, GFP_KERNEL);
 		if (fc->source == NULL) {
 			cifs_errorf(fc, "OOM when copying UNC string\n");
-- 
2.43.0

