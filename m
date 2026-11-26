Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795695360;
	b=aaToN7OCOf/AMrIqTKbsAJdnYWtQwQmCkQBYKrbzuhB6VmxT4bnavanT/RL3leMcQq41
	 QRrdp8CVvSzdJHRhDAGlrczDykCGNhdKliNSWC/hXou6Tr4intWygPbkZ7dJtltPUUwzU
	 2/mZIQ09Y3Dndg8+n+waRfvxWGz5smqW9WHJ+cXnJv/8qpBdiZTPQaoNgWHansuG00Zne
	 KAqDyxTMRJPy+34GcHiB9xtNrJeNx7/S3fNz8u9W4LHY1aNTAiNE+uNThkLWhocMPUqNW
	 PjLwFftBhUWzPLU8UbxNceSTJhtgoizEDvVYVJ/NlgdECU+m6rTZQ/tixIhcD7KkKrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795695360;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=esLUzNLZ8YfwumW0p3uzWJnNmuwhFqgqkVnKoCY1xH8=;
	b=MiV/KUv0TJko38pBOQDy9HrZ9DDyFnmvFfdQRZ4Yp2IeuLIhuo3J3+nDTzWovJ3Jv+H0
	 uK8p42xRKZmpa/w8GiXs0FPyJKI3GPcwdN5f15Hm46tj73SFhhmc4z2g5fNDWnEv3P05c
	 rF8QGcd4lTsdXJZpud0ByCXT4vg2p9rFcEypOS//8vk1rwtF2c1/derN3H/savhqg98b4
	 o2rIJ62ZSQYw3A+Iavi6lBB07yAFgGez/+sSFivCEgf6+A3DEHlEUKxy1L0q9LtiamSAW
	 YbEbmu4Ng/pn3nzFjGZC5SllAAFCLgk6duMwUWY7tkKJFZ6TkxKEww0gqjHBzY6BNsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=aN4uyNZc;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5D8606A327
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 12:16:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B5D8606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=aN4uyNZc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=esLUzNLZ8YfwumW0p3uzWJnNmuwhFqgqkVnKoCY1xH8=; b=aN4uyNZcWZGJAG5Gcyr5MS5kXj
	iyVW3NznplNTBbrfjsteT1B/BtTU68t2cyOrPVXinKfav6DcU8vNIe6VL5AvjoXySeDfXf8RMIICV
	2IvnDRPG8CgBbOi1+6IC0ovmyHgvfOcnKUEoNAsDl2IJpjCKzkNjQv3whEFP26lpOqIGbdeOUbJwe
	FFArxknGkWVOAVqiarAXb+EoGzVglUKBXZeHwoVr22z4Nf72pxA1qeKrG55NB6Fqtgp5AVPfrG/Ch
	S0U5PpENbNkKhpBPIMI28ARREvwoyas22qfd4Fv92xeGzI1ZDD7yxbw0UYCrOHA2ByH4Y6uA/EOQb
	toVNOSlA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xWYOM-00000000zpu-1gpP;
	Thu, 26 Nov 2026 09:15:58 -0300
Message-ID: <f992a3a76733536fe5458110a5f9bdaf@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ZhangGuoDong <zhang.guodong@linux.dev>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, metze@samba.org
Cc: linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>
Subject: Re: [PATCH 0/2] smb/client: fix byte order issues on big-endian
 systems
In-Reply-To: <20261124075927.469470-1-zhang.guodong@linux.dev>
References: <20261124075927.469470-1-zhang.guodong@linux.dev>
Date: Thu, 26 Nov 2026 09:15:58 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

ZhangGuoDong <zhang.guodong@linux.dev> writes:

> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> ZhangGuoDong (2):
>   smb/client: fix little-endian values in diagnostic messages
>   smb/client: fix file name conversion on big-endian systems
>
>  fs/smb/client/cifs_unicode.c  | 6 +++---
>  fs/smb/client/cifsacl.c       | 3 ++-
>  fs/smb/client/sess.c          | 2 +-
>  fs/smb/client/smb1debug.c     | 5 +++--
>  fs/smb/client/smb1misc.c      | 4 ++--
>  fs/smb/client/smb2ops.c       | 5 +++--
>  fs/smb/client/smb2pdu.c       | 4 ++--
>  fs/smb/client/smb2transport.c | 6 +++---
>  fs/smb/client/transport.c     | 2 +-
>  9 files changed, 20 insertions(+), 17 deletions(-)

Applied.
