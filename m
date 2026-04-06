Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73043019AA;
	Mon,  6 Apr 2026 13:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775483384; cv=none; b=XFT6LVztKrSP8snCDn052b2tjFKB38xj3lLP/VN3MLzMHeKu+k4CbdGi05XiMkqvwP5uxx3X3ZfixcMjitumYONC+DQvS4LXWQR1sYhONPWn5yYxcMfqbe2ZB1lx3VlYcYVZMS6zutn3Ys1qraDhPILw5toILbTYAZy4nHOi3xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775483384; c=relaxed/simple;
	bh=TzAblbXjxx/LrehRO37AvhdYEIzQgYRkm313jS7aXDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o3dikX8N06sxHLUISD2lk91Hoy/nHDj1BkrFeNJRHSjgtkPdI7zAlCp1Birrl7/szScNLLCUnWwICywfDqQRBo+wZ9YifYE/w8SBcun8NZ4xKT/U0RddgpHNRiS/yXmtf2mZm/WDvqThi04fVwoZJMtzNr9uL+tFBLBmUDTGqmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+0RV4pG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+0RV4pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3221DC4CEF7;
	Mon,  6 Apr 2026 13:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775483384;
	bh=TzAblbXjxx/LrehRO37AvhdYEIzQgYRkm313jS7aXDA=;
	h=From:To:Cc:Subject:Date:From;
	b=W+0RV4pG9LJ0oLmBkeXnbnxXvZznZTlADwEGXF8pDfXnuyjXAFHtyIGfS4W3mLuJ3
	 K8Wx2zcjlWLMhybjtNxkIEDModVQp7YYC2Ht6cQQfp0X7oAOCmznnhjY4p8yoqaVXX
	 3kSwec00Yf+ytiyuunBnl3zRZM9oBpaB8Yy6Re8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 0/2] smb: some potential bugfixes
Date: Mon,  6 Apr 2026 15:49:36 +0200
Message-ID: <2026040635-banking-unsoiled-3250@gregkh>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=804; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=TzAblbXjxx/LrehRO37AvhdYEIzQgYRkm313jS7aXDA=; b=owGbwMvMwCRo6H6F97bub03G02pJDJmXd34w89Kd+Uv6hid3XpORQ/8Mzh0Lt/VPNHu/9mUoi +GyQmeOjlgWBkEmBlkxRZYv23iO7q84pOhlaHsaZg4rE8gQBi5OAZiIYQHDPNO9EWfVbzB/abaO eMfU73jUantgDMOCvrc3hEt1zy15tz6l+Nqn0zX+50LXAwA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit

I spent the time exercising some new fuzzing tools on the ksmbd and smb
code purely because it's something that is simple to set up and test
locally with virtual machines, and in doing so, potentially found some
minor problems for when you have an "untrusted" client.

Here's some fixes for what I happened to notice.  They pass my very
limited testing here, but please don't trust them at all and verify that
I'm not just making this all up before accepting them.

thanks!

greg k-h

Greg Kroah-Hartman (2):
  smb: client: fix off-by-8 bounds check in check_wsl_eas()
  smb: client: fix OOB reads parsing symlink error response

 fs/smb/client/smb2file.c  | 20 ++++++++++++--------
 fs/smb/client/smb2inode.c |  2 +-
 2 files changed, 13 insertions(+), 9 deletions(-)

-- 
2.53.0

