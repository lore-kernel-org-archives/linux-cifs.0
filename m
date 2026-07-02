Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4F6533D6;
	Thu,  2 Jul 2026 02:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782958279; cv=none; b=tm2UDJhB1hSHGvnzHFmE27hX2ERhSati0VcVBmEdHBpAcCK+aALvPfvoLqg+1EHgnJGpvWM0eObKYSGwLkj/4hBye0bqCIheuqPv4wMeLZmhJenU0zbuuFl5qt3jq6u8gWO19bM035n4Nscz0b91XE8by0beK8rJAUZz39BEo+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782958279; c=relaxed/simple;
	bh=Dhbh7gjceadtrqFDlWZ7DeZ2KaA97vTQ+3uekH0PMQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FARt/zfJTriFwn7PXAxzM8Hh2vypxiH6AYXN6OsAo8DYL2kzQvbwN/dFW0NRZRE+FzdagLGDznugBCtUt8wY20+xfU0wXvB4ZbqFqEAIAS/v38V97Fd2COzZheQam/ZwqlmYwg0r1eVqAAGUP1x6APRPgckVNQbi0Q8Vzpfz8Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=eTU4CbX8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eJVwUu3Y; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="eTU4CbX8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eJVwUu3Y"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 18878EC019D;
	Wed,  1 Jul 2026 22:11:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 01 Jul 2026 22:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to; s=fm1; t=1782958277; x=1783044677; bh=FizzRwBYPO
	PSLI2oH11RtoDSpM0zjUEBWMFtCoMin0k=; b=eTU4CbX8L0CtgpKqghEZPhGkMn
	7KtP43SRn5os33ZmVW/xcx3f18DNhbYBydyk8LYONruwK4t8yVJASD+LUOAzRXna
	692wABT/hlGJ5QX8eJmzvTNjnSGNx81gML6hHJzmxD7X3KNSXC0IaiqwrwVsiucW
	hwtW9/xBCPzm/TZOKB3PdPefGWZu+wQNgHTMZX9vaydfUw8GMRl+MFPMXofibnzZ
	8WhlxLMxJBVA6yxI/39rBcEXDjfvz75uiw9RLtTCHDgQmJ7Q9N2L22lK9uBaygcx
	tI+36llhSszeOCtLutGrw1OrPZPETUsqf/SoERFi3+/FyqUt3y7avVF9FUGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1782958277; x=1783044677; bh=FizzRwBYPOPSLI2oH11RtoDSpM0z
	jUEBWMFtCoMin0k=; b=eJVwUu3YzCXoYHzKbcpIKLPOjos1oP4FeWrFsA2by/KL
	eV5Dn3QLl3Wm/DBQ+8evM8o2nJQI83ZmvbGMY/LTxmhc8fZ0BeqIgKK+gRdGpF4Z
	aZ3d5F2s8He9E06jiw/QdCpiuPF+zNkuycVI1b/P3oOYTtr+3KHh5BksC4yGbmJv
	vTLD54NSAnrLIW1k4le3o9hR+QiK5/bWNZJU+m7u8TWDsphpB5H7ZqrEJwLdEGZw
	p0oNidYPf49cvGpOsqIB41kVTFpQBJ+nODaT9GpdNDGiQCJAqiSYx2FUzg3ifxbA
	r9MBnDR3CfXx5Fv264IDSfNoWFL0h/EWYTNyehiXQQ==
X-ME-Sender: <xms:xMhFagD1iUCv51bgNaD7lUWyxzHIn7R8X304bWJhP7Mw6wijatBrrA>
    <xme:xMhFakB7fM6Dk0tSjTHegXZ6V4kF3LN-LpxrlxCqiZwuaaruKDPJ7jYIXI2ujXOVF
    eCKC6oDTSEaUhW3QGBomwMjkXI4bXVxA89ciFaCYyKpaPVvxQ>
X-ME-Received: <xmr:xMhFajq30RVSOT3W5k4BEUDY20_Tt6txSkR3h9Jp6SvXYqIZAcMhbp7QgsGqOJhBjbs45Q-kTgt2BLmYM6jt_SvDsdZKj40>
X-ME-Proxy-Cause: dmFkZTFwu9aEd6rs81LwydTf6HdbwbDacYlHUcG90LgwQSIlDVzBWp7BMpp7ngplDIjnc8
    3Hb1rW4d3SFhxPjuUFtvzdQWF43Wnh6fpZohL0RD8kb3/KpB2xOQp2EI1B1d7+mjQ0W06f
    zzuMh75uQ5bOK/ws6vUcvYB+NTOLK+YHsPo8OG8Bfvg59C+tOWQrdy0MUXjVkZ4De0Nc/0
    CxvaVqNfgnLNFLKAEe05TT01jKvXUev7NOqYtIn1ABFEp59P55wXNWjDMcDtjksX5ortLQ
    qNKhVX3Q3C7bcHWp+f0ck4Tv+h8i3EuJG0CeMJwWeT8hl9obYKtIBXQUiLpkvIqQ6TLJKD
    YcKRbEZMEOZvIHwFm5dTEOJjjuoRZEP05RBAFHr+2ZXH7yzzdS+YCjFbN5bL+mRw4DsPEB
    BWMpHa3V5PhJcAvHQBDXLAmg+CN30rKaiJa5HxFA7JmEi4D+fOE2EA4fYVfmF0akEPQZxu
    brrQ4e03BoegbFTS+FizefAMbgcIEiO04dhbe2NoQz2itmgSL4dBBOWC1Ic7LVNfOvXzKQ
    jH97/SJ+dOwhWaTyt3GFGtzXSk+uaBlQW3WH7+nlSbJ/ODrpDi/5z5J2sgZf8fZQL5gh9t
    gD1/xC8yxyXzxis44w4Ssn6IasMyOc1KIV2ITzY8hN10azjCda9XnSei5urA
X-ME-Proxy: <xmx:xMhFaml5Xe7I2kJUbEBfgBP0fJ-Ndsm-AXJb9cSx6lPdWjpgrsQZIQ>
    <xmx:xMhFarxP5smsbg9TlxJrQ-piKvKh7MH6CqBzeL_9kFX-6P21dcS8sw>
    <xmx:xMhFam8cdGN-5wvk43mxTdJD5DYcRulKe4ea9OmJeFJPBJwyaG89Tw>
    <xmx:xMhFavIvE2vEEE2D5Ovl3wieeVTVdNKmLIF6Mo3fiBDVlGyZN-SBPQ>
    <xmx:xchFaiazUxJ0XWw81JaLp8nykF0Zzshttlqn0ynWoL8juvj0eAMtuBrA>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Jul 2026 22:11:14 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Steve French <sfrench@samba.org>,
	Steve French <smfrench@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: 
Date: Thu,  2 Jul 2026 12:07:36 +1000
Message-ID: <20260702021105.3406439-1-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neilb@ownmail.net>
To: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>
Cc: linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] afs: avoid unhash/rehash
Date: Thu,  2 Jul 2026 11:58:28 +1000
Message-ID: <20260702020350.3403907-1-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs (like nfs and afs) needs to block "open" requests while
processing an unlink or rename because if the target is to be unlinked
on the server, then the open must fail or create a new file, which needs
to wait for the unlink to complete.

It does this by unhashing the dentry and later rehashing it.  This will
cause problems for proposed changes to locking which will lock the
dentry rather than the parent directory.  Unhashing will effectively
unlock the name.

The second patch here addresses this by using ->d_fsdata to mark a
dentry as being busy in unlink/rename and waiting in d_revalidate for
that mark to be removed.  This is the same approach that NFS has used
for a while.

The first patch frees up ->d_fsdata which is currently otherwised used.
It is being used for a purpose that ->d_time is more suitable for so the
first patch switches to use d_time.

10 years ago cifs *did* use ->d_time but was changed to use ->d_fsdata
by Miklos with no justification (a00be0e31f8d).  Miklos: do you have any
memory of why that was done?

Thanks,
NeilBrown

 [PATCH 1/2] smb/client: use d_time to store a timestamp in dentry,
 [PATCH 2/2] smb/client: don't unhashed and rehash to prevent new
