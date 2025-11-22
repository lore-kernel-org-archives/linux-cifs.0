Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991312AD25
	for <linux-cifs@vger.kernel.org>; Sat, 22 Nov 2025 16:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763830108; cv=none; b=PwTsjv872yBvYu+QpTD8HluzfIZ052YuS+K1/8DIoYzDTS+IZ7e7uErEQVRUSiv3kbs1DSUeVWn1HSgy9nXmxLHBmCwEfb9mNfYxhN+WBTNzgCmnhMj/Ze0oFf34x0OR+FwbHiX65QyNPFJfBEwmttPt1MFAZHEVuXYPPMjVXmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763830108; c=relaxed/simple;
	bh=yI/nu+W6kHplB4GYsOkawXJZlQUB15owJZY2I/z5kzI=;
	h=Message-ID:From:To:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=J5Na+VNtnCyAuqczk7yzaTWJap7SjktN71dUZBMC4T+GL/qEBjbK3o2sEErq8sNfnlxiN/e+/TEErMrQknyQ+8wysxUkp8NxbYbIa283UV1XHKbtBMoseA24F/cr5tIf0vSQtsd6Yg0O2+9D+Yct5gikyRoT5uTz9m0u3fdE8q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=QHsez6fK; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="QHsez6fK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:To:From:Message-ID:Sender:Cc:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qrXyB1VSOmMQZL6XDb72nLnrKsC8187JlAo/8kVZo2c=; b=QHsez6fKnu+LgHdujJ4c9TsjdC
	h0TW7WOH8YLqv2nlqRIZOeC5W0sj2RPneyfY0gPB1ILSDgfP5aucbYQWY8fv6tQueSjbjgAacx8r8
	2TaQyPPmFLNPZA+DX6NGA7lXVnPs/iGqb2r9z0uv4WwDK/CDyGy5Qb3K6ZX6OEfPBElsROgJc3XBE
	fw3SZ+ilqjJy28NOVVZbBbsz/6CrgUXp4nBs2aLbzRo+kyuznE5BfAVnRWTtWZ7DATWkimp0pmdAu
	WJb47JH4dwMZ6B0r7zmFLSVO96QY5WXiehzpuxkiHBSK232tTPKTvhp6eOK9AD4HMQC731wIDX226
	cCFzD2CQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vMqmV-00000000Ke1-0bpu;
	Sat, 22 Nov 2025 13:48:16 -0300
Message-ID: <93ca9dca25a97e1a3a2c32d22939b69e@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Alexander Yashkin <alex.aspirine@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Inquiry on DFS Connection Aggregation and Future Plans
In-Reply-To: <CADBtHDBL3Z7KdkFbCYyOfjdjCBfDsnc_i1sGHyLewpqk7hPhMg@mail.gmail.com>
References: <CADBtHDBL3Z7KdkFbCYyOfjdjCBfDsnc_i1sGHyLewpqk7hPhMg@mail.gmail.com>
Date: Sat, 22 Nov 2025 13:48:16 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Alexander Yashkin <alex.aspirine@gmail.com> writes:

> We would be grateful if you could provide insight on the following:
> - Is there a current method or configuration parameter (e.g., in
> mount.cifs or via sysfs) to encourage connection aggregation?
> Specifically, is it possible to reuse existing SMB connections to the
> same server for accessing different DFS targets, rather than
> establishing new ones for each?

Nope.  Reusing existing SMB connections will only work with non-DFS
mounts if 'nosharesock' isn't specified.

The current implementation will always create new DFS connections when
mounting/automounting DFS shares.  Yeah, the lack of shared connections
really sucks but it was easiest path to prevent it from reusing SMB
connections from non-DFS mounts and then potentially performing failover
on such shares.

> - Are there any active plans or ongoing development efforts to
> implement more efficient connection aggregation for single-server DFS
> scenarios, similar to the behavior found in other operating systems?

That's in my TODO list but I haven't had any free time to start working
on it.

For your specific case, those connections could definitely be reused.
More specifically, when automounting the DFS links Shared01 or Shared02,
instead of creating new connections all the way from namespace server to
DFS link target, just grab a reference count of parent mount's
connections and then reuse them to create new connection to target
share.
