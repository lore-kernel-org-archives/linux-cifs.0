Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284993E44FD;
	Tue, 28 Jul 2026 07:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785224620; cv=none; b=cbnvO0HAmLrIRlYJPDrJ9O90vBIGedBwA5YabZV5+P2NrJcduVlXxWrmnTv/t1LFaq++IWmHTKyLwHSt7fwRFrGIQVbvCwdd1aBQKOjsCJxMqPP5uYDsncRDl+cifyKhZ46WoTFlKet2xw8zptvjRbwcp6MghvK2dQy2NmAf3Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785224620; c=relaxed/simple;
	bh=WSXMM9n2o7qNRnWVPkxUOAvK6NpoutUPaZ/kNOinSME=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=dpgKZJ+dz2wXONlGJzXMvCvpdefJkHPdQHTZWhdWjcWDPdeH2ej9mLAAp/FwfNyJdeiuevw7+5MURXJLXnp1/s0t4yH9og7Cew1AUW/XU01Md81ohrTZVHTV9cjwx2zE0Q9MYhyz+pdWZn7ZBMJhdRXMpV9dzmmVj5tutp6YW5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljryeN6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljryeN6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262791F000E9;
	Tue, 28 Jul 2026 07:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785224618;
	bh=WSXMM9n2o7qNRnWVPkxUOAvK6NpoutUPaZ/kNOinSME=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ljryeN6d7G2H9v88YTh79X2FkZ1grZ7PXcAOWqk+F/AhneAJaZaG2YiiUFb7CcwEH
	 47GN8E6IOJ77tWOt2MMgMzNGBs87GstISvJYS/PAtSg8scvLSFeOS5OdmFVUnmjMdq
	 ZAc4DaJayUHZp4ykfCtK2hhLENJ9BbDaVpSwPL+Ri+3XEieDoa3+6BzXkM3gf5agDA
	 2hx/HgwrtqrqvbpFIa8vuapbC9rIAGQ6URIcqe3M3egn4StkEeGaI2koVlmf+O9h2g
	 waStER5J2ByKlUDScSU0hRCUoKAtZ9M4ffzOiZQgpL5AYUEr2eada76sLCpa5YnGkP
	 eOj+yETS9GaTw==
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 7/8] vfs: Allow filesystems with foreign owner IDs to
 override UID checks
From: Christian Brauner <brauner@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, 
 Marc Dionne <marc.dionne@auristor.com>, linux-afs@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Etienne Champetier <champetier.etienne@gmail.com>, 
 Jeffrey Altman <jaltman@auristor.com>, Chet Ramey <chet.ramey@case.edu>, 
 Cheyenne Wills <cwills@sinenomine.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Steve French <sfrench@samba.org>, 
 Mimi Zohar <zohar@linux.ibm.com>, openafs-devel@openafs.org, 
 linux-cifs@vger.kernel.org, linux-integrity@vger.kernel.org
In-Reply-To: <20260727130827.1100080-8-dhowells@redhat.com>
References: <20260727130827.1100080-1-dhowells@redhat.com>
 <20260727130827.1100080-8-dhowells@redhat.com>
Date: Tue, 28 Jul 2026 09:43:32 +0200
Message-Id: <20260728-dehnung-fluten-kriterien-ddcda5f53a96@brauner>
X-Mailer: b4 0.16-dev-cca4b
X-Developer-Signature: v=1; a=openpgp-sha256; l=272; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WSXMM9n2o7qNRnWVPkxUOAvK6NpoutUPaZ/kNOinSME=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlxC7bc+Kk2XvVFUY16uHXz3AuERN5Hvl5+tS5/FXn/
 1XWrUx53FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRb8cZGb5cnPnsJ+/quWaK
 kW9zW7IKyo73PZ0R8FrKUtv8dNniM1kM/wNK2YS+nVZenrsz9X5trOrOT8XSjww65TntDVYqsji
 Z8wMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-27 14:08 +0100, David Howells wrote:
> A number of ownership checks made by the VFS make a number of assumptions:

Significant internal api changes such as this should please be sent in a
separate series. This seems to be sent alongside afs fixes instead.

