Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AD8433CE
	for <linux-cifs@vger.kernel.org>; Sun,  1 Sep 2024 18:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725214606; cv=pass; b=XpqyynLmH7c7g7+iuneKXcG3B4VOVmv4Pd0c1cbHDNXCliFIyNELbFMk4m05TQ4Y32cfnChgQdUp2b9ccoL6a2wayoxw7DeWPmdstC+8Na//HsZWv0OhvF5cdADFJt2nD5DeMHE0E9/S4VpHEV1ny2NamzASF+z61VKfTeUy/f0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725214606; c=relaxed/simple;
	bh=aYuOm9V2lcofP2AaSNm2TWTDO1ulpHJSZX3wyuL1Y8c=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=SM9HCY7tY99dTtR4CLuA5XteO/a7Z07ta/jC/QQhhoyWz0xenu+Q0xcOm8WjG2YorZ5ytKmazWTw7TjrQos1FLefxzJvAixkvdVnR9z8pZ6S4Z9BxeXj9kamvg76HARAFIoa0FlnhmSjzjd0v/ohjml+xVvKw8Qxa4SaQZJ7Z6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=j9qoFf85; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="j9qoFf85"
Message-ID: <f45ce275e79ec4722ea440af071f93e6@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1725214601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OIQ1iBo5fVfYzusxi2HNUTNKIMXz910dRnl0erjvu2I=;
	b=j9qoFf85M5XKrrR7zdC9Vgc7SpdKwvTHJoW5sGDHpMkSA57bgDpWBKu9xoBGweOlI6tO6u
	CKydf5MwgBnHv2uILUdJ3xkMBxv8qUhL2XKvZ4h9Ns0eCrBxbZg2HfplX7KgJv7p6n21is
	UdHd38j4tJm+Hai5Mm/nZZnWJtPDTqM1BGdZzUC9cF7CiRgrQTnDaeJkZNLNlnsYtmOTRk
	0hZjP8QZm3e5nyNR1kMvbiUTeAEYhGxrqpqFHMbnW/NY3fEBfOlvDuSm+FnW1Sc9WHQMtk
	izUEBmzFUpNTnNmai6xXApud1aEImorcjA+AEBHvRx0Q7XRpKuyP3fFh+iHjOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1725214601; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OIQ1iBo5fVfYzusxi2HNUTNKIMXz910dRnl0erjvu2I=;
	b=eLr+oOgVdcLSdPShH7iFrGqfldpJCwQV2eol7u30dlQNsSdWU9K1bVfeecVXY7DuvA9zwF
	I3HqQplt0zZ0XKTLK/WRUEJmZoxE2NrIeZYYGAyfTSsh+4a+07dv2OPDuVM6CsqmEvWWB2
	GiaaOu0797+HQUab6QTwENrA6atxUHTS7a8ixJFEWUi3FbPCuJ3jKWf5luCjzxYSl89hhz
	kVPHELrmfEYRSLmyfIro/QaSNSu8ITIv9Y3Bc2IwXKk+QxomkGQ4RZm7lzrusIw0vfXIqF
	5FqTEbPkznPFiyGwUtqHS3br5qByb2NavZnXObukLbD074b9wi1kl/kpjle5JQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1725214601; a=rsa-sha256;
	cv=none;
	b=BEUvqVNLu2FM5VzbYPkEhUZbQKpRFFhO9e/U1LPTunUCo4fjyJYbC4qbAIcz5M3FFyhzwo
	YrwWX7OVyVhHJNPYet3ZUdASZKshYIjf4LPat4qkDNK/RyIpkEzSCNDd7n6DqRREfIRWW8
	ptJe6zKsk4X+JS5RcCmNAWOJw9uMaqOU3cQfyApT3puUcq+2A5Y5ms7tb+fhlhp2wlXFR5
	SvozwvW1u+NoAERv5qh6ZryQq56whkuYWQnZ1MKcFHYOXsk6FhMLf4eK4oUF3IFu1Lp7Zq
	LVk9W7Vz8Zuf7aW6wcLUtXcPrTz4lTHxKaLnxeyDgx+qd7x/9xfPlusTCIeCOg==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Rickard Andersson <rickaran@axis.com>
Subject: Re: [PATCH] smb: client: fix hang in wait_for_response() for negproto
In-Reply-To: <CAH2r5mtKKphsebo9Qy4FmOXzAbx=zXdx0otMYE_T5ijqq5KuMg@mail.gmail.com>
References: <20240901014734.141366-1-pc@manguebit.com>
 <CAH2r5mtKKphsebo9Qy4FmOXzAbx=zXdx0otMYE_T5ijqq5KuMg@mail.gmail.com>
Date: Sun, 01 Sep 2024 15:16:38 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> when I tried this - it took much longer than expected to time out.

For me the mount process never returns as the server is no longer
responding to any requests and demultiplex thread is unable to detect
server's unresponsiviness, therefore leaving the process stuck in
wait_for_response() by not marking the mid for retry and waking it up.

# ps -e -o stat,pid,comm,cmd |grep ^D
D+       726 mount.cifs      mount.cifs //192.168.2.100/scratch /mnt/1 -o vers=3.1.1,username=testuser,password=xyz,echo_interval=5
# cat /proc/726/stack
[<0>] wait_for_response+0x147/0x1a0 [cifs]
[<0>] compound_send_recv+0x6b4/0x1150 [cifs]
[<0>] cifs_send_recv+0x23/0x30 [cifs]
[<0>] SMB2_negotiate+0x8b0/0x1c10 [cifs]
[<0>] smb2_negotiate+0x52/0x70 [cifs]
[<0>] cifs_negotiate_protocol+0x129/0x1c0 [cifs]
[<0>] cifs_get_smb_ses+0x807/0x1150 [cifs]
[<0>] cifs_mount_get_session+0x8a/0x210 [cifs]
[<0>] dfs_mount_share+0x281/0x1040 [cifs]
[<0>] cifs_mount+0xbd/0x3d0 [cifs]
[<0>] cifs_smb3_do_mount+0x1e2/0xc80 [cifs]
[<0>] smb3_get_tree+0x1bf/0x330 [cifs]
[<0>] vfs_get_tree+0x4a/0x160
[<0>] path_mount+0x3c1/0xfb0
[<0>] __x64_sys_mount+0x1a6/0x1e0
[<0>] do_syscall_64+0xbb/0x1d0
[<0>] entry_SYSCALL_64_after_hwframe+0x77/0x7f

If this happens after mounting the share, either smb2_reconnect_server()
or any subsequent I/O will end up stuck in smb2_reconnect() under
cifs_ses::session_mutex attempting to reconnect the session.  Next I/O
will block indefinitely under cifs_ses::session_mutex as it will need to
reconnect the session as well.

> How long do you expect mount to hang with your patch?

@echo_interval seconds.
