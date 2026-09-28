Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFA8478851
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 08:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790584277; cv=none; b=OJkSpumfPynvnH8+M/uYTdsqOh3d4uPePdQBJKSrTqHhWPK/GXCMSDYEXrG3CKDiVW3kwBh1ZFW8xcfTmS3vo7VFDvCcKKjg8o9UMPY36rdXTvE7SWaQi8bfLRiUTeEeZAYdSur98k60ytKfkrYEV/tfX+XgKsHrf5QM1Yoeucc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790584277; c=relaxed/simple;
	bh=pqz92F3ABU+ctP/jHfNv5yxJ+b0ipXikUkGD9+woI74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XFreXt6hto7e9DVrDWK/Ui+rL6VkpUVkLUNSSPZBvOI1/hUPBAC3SIlQUAavpgu7rZnifMTS+Czp91+DVpi349QWMMenntWl7XH14cNV5412b4Sd0B8mMIlMrwWzXlBck8DmPJlkEN+xPIkrc4BCuHnLoMD7K17rfDFOW2naAgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bPXoHSCr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bPXoHSCr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790584271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D6axXkipxQGqzsk98AcSmRo1RDlRujd80D+J6A9Y3/Y=;
	b=bPXoHSCrfrCjwtWQRaWCFH6ThZ72MudFsyeEUFrXwBhGXwpbthE3Ig+MPgf7lKRTG+x+r/
	FzpBRHMoKLTjAlpE8wIgjSQVe5smNFGvs212gZ7pvN6cl6sxmLLgsbjlVn9/kPdSkZr9p7
	d9GhrxldmRQdMPSueBuX5lV+fNPxcWM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-3e3v-QgPNqm_-CeaG9DGJg-1; Mon,
 28 Sep 2026 04:31:06 -0400
X-MC-Unique: 3e3v-QgPNqm_-CeaG9DGJg-1
X-Mimecast-MFC-AGG-ID: 3e3v-QgPNqm_-CeaG9DGJg_1790584263
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3864E1954B07;
	Mon, 28 Sep 2026 08:31:03 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.32.43])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C70501956086;
	Mon, 28 Sep 2026 08:30:56 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 0/3] lib/crypto: Provide functions for zeroizing SHA2 hmac_sha* structures
Date: Mon, 28 Sep 2026 10:30:52 +0200
Message-ID: <20260928083055.104266-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This patch series has been split of my earlier zeroization patch
series since there were some troubles left with the purgatory patch:

 https://lore.kernel.org/all/20260924145806.GA1949494@ax162/

As I've confirmed now, the fix for the problem is indeed to set
-D__DISABLE_EXPORTS for the other files in the x86 purgatory, too,
so the first patch here has now been changed accordingly.

Thomas Huth (3):
  x86/purgatory: Compile purgatory with -D__NO_FORTIFY and
    -D__DISABLE_EXPORTS
  lib/crypto: sha2: Provide functions for zeroizing SHA2 hmac_sha*
    structures
  smb: client: Use hmac_sha256_zeroize_ctx function to clear
    hmac_sha256_ctx

 arch/x86/purgatory/Makefile   |  3 +-
 fs/smb/client/smb2transport.c |  3 +-
 include/crypto/sha2.h         | 73 +++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 4 deletions(-)

-- 
2.55.0

