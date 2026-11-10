Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322383;
	b=WHufz2yJUeKAOA9GwY4Oxpy9IujtgGaJdNPLOyIxkEvkLF7gpUttI2inpnWK2r6dOw/D
	 wTeCUG79kG1+U9JNbBbn5NeI57Cve1XbqL2P6/jDpXffZtLxtOi8qPEcVIwC7LpqAk70Y
	 mek2MWT3Ccq7xj1xiXFYST8s5hnwQhUlboA6okxjh0oKgvpB9YtYL6OAMgIwa7lA2Wfvg
	 x+ceYLrHF/4X1qjn3//T4Jq3MVkeqP0KLsWBzwSz+V5l16VDxbt/FlGvk2yDlgzMlkaFR
	 ErSjWL5/beX6XTO1hyti0IZaVgjMLktXujkjXPHGhk3yMqgWI187wOg0fG6va6p2Sdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322383;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=igzsGYM2riHiB9kMz5te5OJWhyKS/vyukYoWrtQT28Q=;
	b=gJnJB7r3c1RQFXBdpGsxvTW1oF65Ejnq1Y71hozglKOqihEoySB/93RHVHOb1h6pG02j
	 Ph3wfNAEgIW7BYuCrKT09u7Cg53dNw5pRhi/U6FOMmfwAsKn4d3HdyNInkodnRhI972qH
	 DGlOpF85VY+mD/vtrgU0sdGEASYo9KVUp6mHhJhZwbL7S9MTcLhVi5LQ8hKE3aZes0rUF
	 bBoHc27mT260Vb7cMIaaJAOqpXryZ2Iqy3p4Afmg3PNq3ibdVbKVxl/rgB068a3py1Lo7
	 8vpP+G3GxCHL4I1q9xhJ9ComPuMM3o7CsJo2ieTcTmf89fHemJlQI9J8M9WA67By//w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zecagOqh;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E11D60A2613;
	Tue, 10 Nov 2026 14:53:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E11D60A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zecagOqh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=igzsGYM2riHiB9kMz5te5OJWhyKS/vyukYoWrtQT28Q=; b=zecagOqhontScvij8Oiwv5tRbV
	J2Ns2FrCnRRmdeY5glIfrWtDTbAbeWVKct3UsnFoXTtjFwJMfP7d8Z7uHX7YGzXeuAhezZ4vSBQsU
	xWpeKsxiYIssHYZoB0hImdZAZGB6dCqxt5xBQ2G7jrU2X3Py7D2HV4CaNZCqkRpb2ofm7shEr9dZn
	UCar/CR9banScJ56+87Sv8LgmSO/JGVHP7xaElCbpAiWknAGu8EHEIB+iVavthj5QNKKG5nehKiLW
	ZmDDTFg6DnIsLv1av4pObPYUS7U5ZhDfO3+p4e9Mr7QHTYdPVIIYEvyc83za5sCBuu3BA0DKMXcl/
	sE9r5ZIA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xQnDV-00000001MbM-1jwG;
	Tue, 10 Nov 2026 11:52:58 -0300
Message-ID: <5773ae99397b259efb80acd386e71fae@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Joseph Qi
 <joseph.qi@linux.alibaba.com>, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: hold the inode across cifs_oplock_break()
In-Reply-To: <20261110094829.2133495-1-joseph.qi@linux.alibaba.com>
References: <20261110094829.2133495-1-joseph.qi@linux.alibaba.com>
Date: Tue, 10 Nov 2026 11:52:58 -0300
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

Joseph Qi <joseph.qi@linux.alibaba.com> writes:

> cifs_oplock_break() drops the handle reference in the middle of the
> handler and keeps using cinode afterwards, to send the break
> acknowledgment and again in cifs_done_oplock_break().  The reference
> cifs_queue_oplock_break() takes is the only pin: the handle holds the
> dentry and the dentry is what keeps the inode alive.
>
> When that put is the last reference, the dput() in
> cifsFileInfo_put_final() kills an unhashed dentry, drops the last
> i_count and evicts the inode, so the rest of the handler runs on an
> object whose free is only RCU-deferred.  An unhashed dentry that a
> handle still references is an ordinary state: unlinking an open file
> leaves the dentry that way, and so does the dcache teardown at unmount.
>
> Take a reference on the inode for the lifetime of the handler and drop
> it once the break has been reported.  This also covers the
> cifs_get_tlink() failure path, where the put is followed directly by
> the out label.
> ...

Applied.
