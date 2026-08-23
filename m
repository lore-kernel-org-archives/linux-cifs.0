Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0F238C438
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787501251; cv=none; b=S6Bx/1pyx2lxrWwMIf+AZ3acF4qPmAHrPOs5kt/J1SaTQolLxktXCby93Mt1D3Y8T/vGdYQ3o+2Eg55MfPbLgJONuwXyFjWJnJR0q7918Q0rt6uYzzGahhwsf3/hkEmjd7uKt7DcLViKb8K5T8CsNhGLmLLwxsD7RTGEjhUxnNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787501251; c=relaxed/simple;
	bh=t47MXdoZVmA/0CIxHNFWECHyPwzjT/krdzHraaaG/vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFg/LWRAVBCXpFuNHc5+Uf+/dKe/3iYMOum5qz7IffKcT0WC6s/a5qrTFnZH6UVqVpw/Rc6kutVPi6YkXBE7akaZWWjlRdWUKLxPGB+E/oC41wTGdfrRIMUdKmSqM2GBY+jMs4/jTkJJuEeNz/wwZ8QtRY65PhfWF7VUiL+i51E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=mMIpExsD; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="mMIpExsD"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8486ac3f347so3155714b3a.1
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 09:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1787501249; x=1788106049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=09gcrrpoB/ZfazZRgqzNGcQ8HoDldlLl2juqlWH2ddQ=;
        b=mMIpExsDnugNZZRReCdte6GK0NPnEbAVKyxlthNRkP/U//bahUMZ1d2jaj8QHAIQ8t
         5OXL7n9VcjbK2HJI9SE2+bhovmPs5RTSfmncqqwVloNBFZfGCP4N+KnfJ8vGGGb/CxLP
         cKl7Nl3XEgRbIYaLaqthzNcVswPwYOqh7+DRHZ6ZSrdf1N3p2xDJ3k3oSQha+eIzb44z
         L+GYi8N9HpukrzgXGof9ivYdpFeElPulaiajNg4XC/K3Og++v9KNqms6uPMJOe8G4XBN
         hgutLTAVemu9/eYwjXVKcdF2kaRgCOonM4XACQ1srdhXseetATYJACsPJbNVWsJu/sqG
         BlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787501249; x=1788106049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=09gcrrpoB/ZfazZRgqzNGcQ8HoDldlLl2juqlWH2ddQ=;
        b=jMYVl3OAtnDc/fiu2oikYYyhjmEjmj2h9RYDvNyWERysaOoCxZvQ4RAwGEPk/DLFZT
         ibdSmEwm2oh96wgKLjR1gOtQaIUcmNAtmFC0LLaVsmSzWZDcxgw6nrT8JO40VlkKO71f
         oJ0i87AGUWDOvsccbs4R4T47nySSC8byDGGTN2VHhkHrnJAzzsce7F+JH3YgjWZoofJX
         TURmXtY3N2agrfpuaN4aEBAxGA5A1CpsYDzhe8ybkuFxQcZiTKO0arYq0cVuZdn2m79A
         FfDOsHhvyAT7WOEU3fnhd2xSsoXdaBoPzJGoUtrCLXpM0PcFGuUa/AjlRgNTom1LShp6
         NtEQ==
X-Gm-Message-State: AFuF++msIZQ5u6QyMPFWrSQiGkFtysy6fej9GgEmaz70gUBR9kzjh94H
	TD8C291K3fqySb6CzivhnhtmIlZSOhMyWWliysfRdqGsRUEBl0dGy6QbQ5lf6kT63RPn
X-Gm-Gg: AR+sD130Ny+co96a88BI3eWADkry03OjOyBumn6JYE7hjEYsM/2v4iLEyvvWYvdcGJD
	eiJSbyvIvgqJu6+Y6qyNNoR2AeI/c9pJmQxOzbJ56Xhed8/hvUSCTX3bStl59a9S1LrcsmFfcxx
	VZTNOgOoI7dzGitxc6mvLZxEgLlo+4ptAoz1Bou0XadWurMESMsAXATnio5pW14MykTlR8bS8hI
	s7s9185QnlGE8Ii6Aw4lBh3JkTM1u1Tkk4W4YovTzFNWy9kiWtXSSAmyjkX1yWlbEXSnLl3RXib
	lqSu3VY9zaUxmRC8o0QK+oOaFrCgembyobhfgoCwSIvJiOqAr/6fK+5ARrkItgY1VsYIr1x2d7h
	BR62mHCCbql1OHN1Ikuaj1MEdWQ4dX1glapfq3rUTC/PzvqyE/+CHwkhGxZ5DP9CK5skyCQfSqO
	ktWN+Ig4pQi/Ch1azR+oODp0VdPxvFA7XaioJc5YSdOZwSIP9KxQZiJ0tqaMeAHXdTt+GauNnd7
	oBXNZlzKQrjX8c6oP/VeYmrSGs=
X-Received: by 2002:a05:6a00:300f:b0:851:8bde:7861 with SMTP id d2e1a72fcca58-851f9fa5b0bmr21741628b3a.1.1787501249566;
        Sun, 23 Aug 2026 09:07:29 -0700 (PDT)
Received: from gmail.com ([115.199.218.100])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520f14a418sm1211724b3a.47.2026.08.23.09.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 09:07:29 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Pavel Shilovsky <pshilovsky@samba.org>,
	Aurelien Aptel <aaptel@suse.com>,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>
Subject: [PATCH v2 2/2] smb: client: validate POSIX create context length
Date: Sun, 23 Aug 2026 16:06:29 +0000
Message-ID: <20260823160638.12198-2-zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1787486936.git.zihanx@nebusec.ai>
References: <cover.1787486936.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_posix_ctxt() reads the fixed nlink, reparse-tag, and mode fields
before checking that the POSIX create context contains them.  A short
context can pass the generic create-context checks and still make these
fixed-width reads run past the declared data.

Require the POSIX context data to cover the three fixed fields before
reading them.  Keep the handler's existing soft-failure behavior for
malformed metadata so a bad optional context does not fail the open.

Fixes: 69dda3059e7a ("cifs: add SMB2_open() arg to return POSIX data")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v2:
  - Add a handler-level DataLength check before reading the three fixed POSIX fields.
  - Attribute the fixed-field read to the POSIX create-context introduction.
  - Preserve the existing soft-failure behavior for malformed optional metadata.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/
---
 fs/smb/client/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 95d862a1241b..e3973d331633 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2405,11 +2405,14 @@ parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
 		 struct create_posix_rsp *posix)
 {
 	int sid_len;
+	u32 dlen = le32_to_cpu(cc->DataLength);
 	u8 *beg = (u8 *)cc + le16_to_cpu(cc->DataOffset);
-	u8 *end = beg + le32_to_cpu(cc->DataLength);
+	u8 *end = beg + dlen;
 	u8 *sid;
 
 	memset(posix, 0, sizeof(*posix));
+	if (dlen < 3 * sizeof(__le32))
+		return;
 
 	posix->nlink = get_unaligned_le32(beg);
 	posix->reparse_tag = get_unaligned_le32(beg + 4);
