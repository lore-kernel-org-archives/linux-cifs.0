Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0832F27E1A1;
	Tue, 22 Jul 2025 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753201559; cv=none; b=Nh5nqTa3haG5hYrgOv3PwEIS8qDhf0L7YY8sIakNBYUakTmEPDViuv+xiEkhXf/wySvDXZgqtb5aGQ48Uy/Vq2R9rlw2WgY2izs5BnTZzbIpNlGi1uop7zp54mliwiYZTF4zvVE6wL9L/Bk22mlXi5jaqCKjTXP8SkZiZ7lWiVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753201559; c=relaxed/simple;
	bh=YpKLA+nBH4J1MvAE5euoNtZCQrgsDB4bL62q9o3f6W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfFp/aVwibN87/rtUhxQ84qFH0CqztA3UO2DgmGMNnlsXE7qAg1p7X2E75UFR4Y9WLb3zwIjRmMHKma9PgZ3SGlpcpYs4Y9k/FnRM2mNTltC8iEf9dnn73mBNDIqgtWncqzIti6sbt2R95G1zOqBXMwwIkdpWIHrInotrXeYW88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: gregkh@linuxfoundation.org
Cc: dhowells@redhat.com,
	linux-cifs@vger.kernel.org,
	metze@samba.org,
	msetiya@microsoft.com,
	patches@lists.linux.dev,
	stable+noautosel@kernel.org,
	stable@vger.kernel.org,
	stfrench@microsoft.com,
	tom@talpey.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
Date: Tue, 22 Jul 2025 16:25:43 +0000
Message-ID: <20250722162543.25134-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250722134352.730381369@linuxfoundation.org>
References: <20250722134352.730381369@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.15.8-rc1-g81bcc8b99854 #30 SMP PREEMPT_DYNAMIC Tue Jul 22 15:58:43 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
