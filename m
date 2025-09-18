Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0DF185B67
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 00:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758155086; cv=none; b=jlNEjGU8eKXtyuG3iZCQAMWi93L7S0rFhfolQ8I9r17NaSmawzz5FSqN5KU8/3jiidE4JOL8rsPvZ0HUGun+ANUuBEK8VXhd8kNsx2CpyNHGpkBLh3QPS0q4P/yzpGzVqpIm7XG/AO5OSsWNLIkku+Cp2H8PfV8hiJa4so84B94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758155086; c=relaxed/simple;
	bh=aqa3HyW4izEedzN2M7rAgsR/LkZTNRFE/QQpCiqhopE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dzSGidP6q60aVI4blS6tJ6RCWQF0VaBbMz8lv6JajcTI7AbGJm/z84z+APdzJEYpnezCqrZYPtNAivnyuQRDheVITfvuUrEH/VZta++wwTGXrv+soTFg0yL1VRQ57Vgs/YutjnmUvOytB/WxZ9WZ+lj/rIjgSx5O+SPuVWXpVQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H3l+CyN0; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H3l+CyN0"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-791875a9071so3871746d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 17 Sep 2025 17:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758155084; x=1758759884; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AAXfVbKrj81Yrvk5S99ka61ApJPAF5+mvHdEE3dMmkE=;
        b=H3l+CyN0+X4DRDmDvIeMO8W26J1phrmYxGauoc3V//ih0oCsyVw3aDQbq9kWcDBVh5
         so8lJ8kSahN+2Rgi7WzTK5lQfJtlHcbnMwGylb3iMQnj9iQ2YlxaIK8/qEa2Ye155UAM
         U0TPIS2V5I9fl8njAXsty7esJQsX0+MP6vOg1M4cmbeBFbxWg39LzxRq2Jh5ClRV8VYV
         QjTMnfArEMVnH4ou1NWEvksvUJ3gAOht1XUhl+gArp26uC2vb7BpwReK787MkNmz7iSq
         XQTM+hIYl/8n/QbC/aAvdikoWdDEMisAPF6oyTaMCAppeHQfdIdGuneePbw/vjgL3WmN
         IEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758155084; x=1758759884;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AAXfVbKrj81Yrvk5S99ka61ApJPAF5+mvHdEE3dMmkE=;
        b=WSVCntnvGb2WMErq6wS/Uj10sy0VQm/IU9MoLvjt3Rt7pOK2ilx2NmGN3PunKtQE5x
         uS740yvzY7xILalmhazDhDNa3zmeS/NBEPYW6H5SkUhZ2qCBZnwQcq2rxTlF+CMblrou
         FQroNJX25Awv3L5eiJZCTBDzr7Kv6klbNk//PGH/8uVxIP5p9w5zysaE1QvALXIxMdAc
         TMYfJqC0KOL+sE/kYcDZVJd7FRosVBdOBd0XWfo6OWa3DqPhJV7h0gtSL4x+/W322Ya9
         AzWlNmxdD1Sc+FH1d9jTB36CGWhR8r4SV5A+MVlGDopYA9E3sWeklXP1k+6VqmJ8TzNk
         ZURg==
X-Forwarded-Encrypted: i=1; AJvYcCXhV+LblkLTyFMKb0vzs76YUsIP4d6By5wMyPFEISeh/nV/Otmkue5dp6noLqZe1krZ6H/knGqTHLxb@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8Yc2ny/QW0Ykci6SUJhzHskMEx++1rUG0xYZuj5EWNMREmylK
	Wj5zy2jo5dxVjHgZsvdbBcLVhUwK/l8XxEMd8Q1sVuInIBm9/egXLBmLtLoyLgq0qlqhtq6H1ge
	VPGkFWxmH6nYyWpb11jH8yIn0YJ2Q2rs=
X-Gm-Gg: ASbGncvPh/oLVIWm4EGnGGocEA/GGx4aTL+2VwijbEi1JtE7ylHO0plYkG6fZYMmZWJ
	xvniHBPGzUZjzRoUs7+6pC6tr53e2AmAORW2UnGc5ZkZp+EHkcFp0r9RvOZkNX/i9WRiPNIyF30
	A7nGI5bTTqG/L+hn+JKm4fC8qZqA+f5ybqW99AIZa1PY6YHNcdZngHXyAgzDR9VCMdaQ6nbwGof
	jmolLqkNZmw3d2HlyT4kXyINFF+qnHiwcwnL1/5TN40bvUTLoQm8aucx+lZuJabElRRgCU2763T
	PFIzZ5RV6pQtDD0dqDiCdCyepw+dMW+xKYlv0kRKjr8POs/kHeecQwt1lw==
X-Google-Smtp-Source: AGHT+IGUH+Vo5ah/BOcidk5QhkanPaPPGQuYC3QJ2qzogXag5pL1GyIB63O7MImSt5xi0DjpoDoPL0PfcM83Oi+Oc3w=
X-Received: by 2002:a05:6214:412:b0:782:9454:ac8a with SMTP id
 6a1803df08f44-78ecf4fdc10mr43901236d6.57.1758155083710; Wed, 17 Sep 2025
 17:24:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 17 Sep 2025 19:24:31 -0500
X-Gm-Features: AS18NWBPu6sGfW3hnPreMxF2wFj2Jem45fHu6Sahx8yNzeyFoZ-xTePQClKaY-I
Message-ID: <CAH2r5mveqnRsJ4Fi8pQjTY2WrtDbys1f3JPR+OR=w-eskUoiyw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>, 
	CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
f83ec76bf285bea5727f478a68b894f5543ca76e:

  Linux 6.17-rc6 (2025-09-14 14:21:14 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.17-rc6-ksmbd-fixes

for you to fetch changes up to e1868ba37fd27c6a68e31565402b154beaa65df0:

  ksmbd: smbdirect: verify remaining_data_length respects
max_fragmented_recv_size (2025-09-14 22:17:10 -0500)

----------------------------------------------------------------
Three ksmbd fixes, all for stable
- Two fixes for remaining_data_length and offset checks in receive path
- Don't go over max SGEs which caused smbdirect send to fail (and
trigger disconnect)
----------------------------------------------------------------
Namjae Jeon (1):
      ksmbd: smbdirect: validate data_offset and data_length field of
smb_direct_data_transfer

Stefan Metzmacher (2):
      smb: server: let smb_direct_writev() respect SMB_DIRECT_MAX_SEND_SGES
      ksmbd: smbdirect: verify remaining_data_length respects
max_fragmented_recv_size

 fs/smb/server/transport_rdma.c | 183 ++++++++++++++++++++++++++-------------
 1 file changed, 125 insertions(+), 58 deletions(-)

-- 
Thanks,

Steve
