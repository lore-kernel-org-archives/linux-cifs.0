Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90222D5935
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 20:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764016925; cv=none; b=UthZZ8SC5N5J0Pm4OEchO5MNHHIR5wQoxN54+DNyfw8zPAvJoxojWwMO9OWgjeKpwQEUMxGURfo/i/SRD3RVNqsMQOCzDyf22ejpANug1ddawwzOdV+6PWD7J3JqcUpYXPql4qxe7TiJyB5+c+IlhDQLHCTbSkKDxQMbhJfNN7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764016925; c=relaxed/simple;
	bh=guy9MKanM/TSQle9o9IReW0hQRTRWvd84yEz1BUALaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rx5pt2lM3l6uuHwLAikWGdr1FgBuxEN7JxxccbX9ukkx7ver3LP9CzFea3aEheBsuaUZSh2xsbJcZ9JFsuKSUDZV/NhLKf4iQkXD1KTJBhjod56RPZqH/UuygGgCgEx20lzJ3NrroqV4YVmdwh4e+K2AH2Sb46136hPEOG2afOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YsYGjB5n; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YsYGjB5n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=RCiY/tsuKelbe+ksfCqr7LjnKhvZHxR1ZCZRdK+dzJs=; b=YsYGjB5nHI4TTHV52xZobkd0RU
	sPl/BsyEkqFU1Rpjikh51rTqD8n+pFvmYX5Yj1jMkO7g5l2hnoprFkmPFZuYnRwJbuOKh4uROCH6Z
	WpLRs9exP4axfz8CbJuQCj5WNZhkrw6zyWQ2bCkudsXF6M0zfvF6EOXxaklOu+aFHKNRL+Eb+CufO
	Jv1IxbQW9JwmAvPTq8J0KGHOo6dmQahQHekrtSQakOutl+0B4XeSGg4YRE23fQauCTmMGF0REfKqd
	3ktK8/+EKmGu7ywfLZ6jYxCiAW/2FJdj0RL/u/O8UzuaJrD5h4WO6jmuRgsbFergftB3+YeY7izAh
	kCB0xzyss07vtdN/aG/L8lPpLIcjPT7aJq+U0wz76GFDGvgs3s+2w5cRosgqHZM/pa/j5UJY9w5P8
	NIQ141RWduSPEQfhFedgjXT/sphrCuiDk/8x4JBsMhgkzzJ/FJ8Hn727Ao3RTNmTpksNPEuXfDH8J
	7xkCSHSJ9hKMuFZ/RVgsnUnF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNdNn-00FSVp-27;
	Mon, 24 Nov 2025 20:41:59 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 0/4] smb: smbdirect/client/server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
Date: Mon, 24 Nov 2025 21:41:43 +0100
Message-ID: <cover.1764016346.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

here are some small cleanups for a problem Nanjae reported,
where two WARN_ON_ONCE(sc->status != ...) checks where triggered
by a Windows 11 client.

The patches should relax the checks if an error happened before,
they are intended for 6.18 final, as far as I can see the
problem was introduced during the 6.18 cycle only.

Before the first two were part of my smbdirect.ko patchset
and I'll post that patchset hopefully tomorrow as this patchset
should have one round via linux-next without the other patches
first.

I've done my typical testing between cifs.ko and ksmbd.ko using
siw and rxe. Namjae, please also test with your Windows 11 client.

Thanks!
metze

Stefan Metzmacher (4):
  smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
  smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
  smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
    recv_done() and smb_direct_cm_handler()
  smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
    recv_done() and smbd_conn_upcall()

 fs/smb/client/smbdirect.c                  | 28 ++++++------
 fs/smb/common/smbdirect/smbdirect_socket.h | 51 ++++++++++++++++++++++
 fs/smb/server/transport_rdma.c             | 22 ++++++----
 3 files changed, 80 insertions(+), 21 deletions(-)

-- 
2.43.0

