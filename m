Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64ED18BC36
	for <linux-cifs@vger.kernel.org>; Fri, 15 Nov 2024 08:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731659570; cv=none; b=HMu+XjcgmpmAlT8HHJeDTBlu7jrvjhdVHio58ybULMZQ7AboBCbPr1mgDJRpUNmg7THx141N8hlaYwHUQ6Ucu2FFY8LDyGm8haYybRlwPateDqTj/Xe+Uod54mVIhV//xL1TzubSFShnzuDR/NgdFsLc8glKsTbrLwlLFnm2zh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731659570; c=relaxed/simple;
	bh=bwKXMZ/CqyKVXHRWjad7VNJ99PRPhanXO2k0v/9eehs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ocFthOY2tBHzCt5LmQeUamIAi/BWhChB0xGbxfRy4ZbN7ojhGfNybg0awDJhf6UHMBQmL2ygolqno8Z4oB4e/mbHP0RxUNM3JMez3Ppf0+/NfojkEmDEkM7gOCqNbVphnaznVJ9M5y4h6D3jtbtUS+g7LkCrwR9m52ENonUHNXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GTtEJuxQ; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GTtEJuxQ"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4609d8874b1so3448821cf.3
        for <linux-cifs@vger.kernel.org>; Fri, 15 Nov 2024 00:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731659567; x=1732264367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+oyM45fO7kqXMoRRUsCsV2dgNjzQvpxBqm/zmpiRHXg=;
        b=GTtEJuxQtRSaBvciE0/O4V34pZ7STyPdVt2dMCpwWrN1Bp+jAL6Dm048ct+xkbpfB+
         1XDNUdpqYfz4eS6KwONDWy2BhpftlINR4rF1NLU7vnKuFWydHUZ0UYh6Yk20CAhcRSmO
         L3XpjPMfAI39c9Y+JI34YvXxEpzPU3/A9TnfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731659567; x=1732264367;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+oyM45fO7kqXMoRRUsCsV2dgNjzQvpxBqm/zmpiRHXg=;
        b=EMkQDnYl1ceTPPzYu1KuQKZyxDgMLsWHPi4r/JapdjPYTiVvd8xaTKL2Ka5abMREjv
         Qlui4bvoc8o8kyY5LYk8q72tfa9GdaIry/5SPsMIFswyrMr0jw1z9/WZW4NC+2XmcrsG
         I2JOut4IicL+s1CVAuHGCtc+eW+3F/xxwy+f0XvpDhQqreYOEED/IM2evpOGZzUQnHB1
         MRQ5aHzHzNrNYlRUCUSVLuE9vAvlSPhL1FpjjFB4EJQQ41Poh8Z2uhVIdFR6bjjMO+2R
         gfZYh4Tm+RT91ZvzhKxbUSCuMMLVFbI8qXcNifOa4gnRgIEgiX56oInet1bpXYRMGFYq
         5TCg==
X-Forwarded-Encrypted: i=1; AJvYcCUW/PYhRUXm5IYKrD6/+Vi7n0OPPpofrHxDs6lpq+EfOvHrbBnRnc0ZgAr9+sLw0/VBQQRUmGmv/H0D@vger.kernel.org
X-Gm-Message-State: AOJu0YwMfEpgxD82h0mlWzb5Hca6zXfe336crTGYUilmEue4gsm80NCA
	TdqXufYpc0nzH3Azw9dZIYxPsx8e2sOfvy1FHOQ82uvarA88B0NSIB4ykxOnF7QAbxR4UvvDHc1
	s8A==
X-Google-Smtp-Source: AGHT+IEIC73NXLt7bHwh/TMQ6UkI0zrz/RHhFfkxb8RIMOzTdzyOAiIAIfCgAfuhcrXgqjJXvnY2dQ==
X-Received: by 2002:a05:622a:5187:b0:460:9ac7:8fcd with SMTP id d75a77b69052e-46363de864bmr26095761cf.1.1731659567548;
        Fri, 15 Nov 2024 00:32:47 -0800 (PST)
Received: from vb004028-vm1.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4635aa37c54sm16584231cf.53.2024.11.15.00.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 00:32:47 -0800 (PST)
From: Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: yuxuanzhe@outlook.com,
	linkinjeon@kernel.org,
	stfrench@microsoft.com,
	sashal@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vasavi.sirnapalli@broadcom.com,
	Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
Subject: [PATCH v6.1 0/2] ksmbd: fix potencial out-of-bounds when buffer offset is invalid
Date: Fri, 15 Nov 2024 08:32:38 +0000
Message-Id: <20241115083240.230361-1-vamsi-krishna.brahmajosyula@broadcom.com>
X-Mailer: git-send-email 2.39.4
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dependent patch (slab-out-of-bounds) is backported from 6.7 instead of 6.6.
In the 6.6 commit (9e4937cbc150f), the upstream commit id points to an incorrect one.

Namjae Jeon (2):
  ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
  ksmbd: fix potencial out-of-bounds when buffer offset is invalid

 fs/smb/server/smb2misc.c | 26 ++++++++++++++++------
 fs/smb/server/smb2pdu.c  | 48 ++++++++++++++++++++++------------------
 2 files changed, 45 insertions(+), 29 deletions(-)

-- 
2.39.4

