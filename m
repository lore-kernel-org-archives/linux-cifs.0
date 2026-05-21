Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472343D905B
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 13:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369824; cv=none; b=rR+4SxQLVVSYNqVgS93lADML9w552NiZSjOmJpqZx+va8hKxe1qudCoqoxSvN+7P9cV9CyoAFJo9iZ/j32W2B712KuLT7lcq6exqt8ccyMKaz/meVHoZ8ZdytmDw+niw2IiqgSo/JIGgTMXCnjmYgdQbORoaijO1C5oHqJ3d/Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369824; c=relaxed/simple;
	bh=KSsRs9vXxax/kRFrbrYBNmU+8v/TfOdKVwpeAj70JgE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=E7VPGA6goG1irdGjQlnIvqCtls55FvzNbYS8wogWwrUWUmzJc+94JO5EHvyo1IpfaA8afTsOWhm8xjY/yOHqNPm/JRsAC+9vTZF9seDr6oD2qTr8BQNr9ppOTi3gTCBYKCFMZVNxKBfvkUHmt7Zjr6F7D0gRzTE2X1cdI8FoZ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=J2ZeRqNZ; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="J2ZeRqNZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uNtqi/2D+qoheoHrfIQqnAVQ9rX1zkTwlHnUMBclAUE=; b=J2ZeRqNZ2/Vu9ycLZqWjNqTIAr
	f8Jc2MEZJx/o43dYFnvpigwmGoK69N/RvKjR1wVsSU7uK79T2jLkg4GINm2+i1sAAHI6v+jBFxRUs
	qih5AgzPb0zPx3PjXmsKVFVk1XXHk93CJlIJ89czrxymj2YBsEasKgcYTCmp4WunxEjKmmYmHKhrN
	fNqbzK/wtZe4PEu8kg5xxc1AMk5KLnwfGzC+YqQjyi+fUAfOE6MVWOcL2p4M/B43ZcuS0/ni/7ne3
	TjHzYGd9xNM4AEJgNDMpqy87A2uo+dk3KhF6IDgmBkztdP+0rpOcUPZbCoXVXNdmg5j9BeY80HsTS
	QCh73laA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.2)
	id 1wQ3N8-00000000CyE-2OTs;
	Thu, 21 May 2026 10:23:34 -0300
Message-ID: <2890c040da473576ba622c579c64b3c0@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Steve French <smfrench@gmail.com>
Cc: Vaibhav Nagare <vnagare@redhat.com>, David Howells
 <dhowells@redhat.com>, Jay Shin <jaeshin@redhat.com>,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix double free in cached_dir_offload_close()
In-Reply-To: <20260519233934.684906-1-pc@manguebit.org>
References: <20260519233934.684906-1-pc@manguebit.org>
Date: Thu, 21 May 2026 10:23:33 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Please ignore this.  Will post v2 after sashiko's reviews when time
allows it.
