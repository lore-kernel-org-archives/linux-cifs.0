Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341D236C9EC
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 19:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791229378; cv=none; b=Cc4TVeSj79HpxGpPK7sJ3SOvSDZGkU+ARKmTrIOPqPT8bnpfUSJPhBEkm0L2Q/o09WQnGz4tE0VkFbJrYDCCqCFcdrOG6jVPAD/CmSQ9gmPeMsE6qJ8sbqP8rzlOMkOB2yM/wTTmFx3NpDZAWfPDnrLEDwG7r3rcMoxOX41n5hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791229378; c=relaxed/simple;
	bh=0jAezZlStre8goBCk7vK5Y5CmGR7Q3bXvCe9ZbyNfA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MKSoC0IAlTRQfmidxeXc2pRGfQ1TKM9vsCKF6H/CVDlh6Y+MXJXWEn3Ttpf3eNe8w7MsdC+TN5TMhXT2H8+upp+F2s8QoA3xZ6W1Jz2BaTwImx+SvQofg3zam8i0S8npZeKZpJu6BZqhI468LAP4bmSA2dJYEuswwECmIJ0z+u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YulUwyIm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YulUwyIm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=S1vkoLoEJ0HfUOhp9wwFkhM0ijUaTayoqg7kZiditjI=; b=YulUwyIm3yvNijfBQ3Qf4JQLnA
	1ckjfvCnbtQQ42NzO855TuK+Bharh7zKBHI3RullfgdzzB4ryCn86YdqPPUce1F+TzUwQVi5uVxKy
	OCUXJKJmxjKZ40SDNWJt697SuMMqZC21rGy/z4WWnCZcQSdhG9Z+fmNP0VccXkCLpkpiDrvxyM5ou
	QONYYEJI/AySF9s8nwqqoeTlpGltM5akXsnwFon6WxCeq5VsKW2fzVRPsJF4tu2x5ORFQ9CBKz8z7
	3Cl64Ab5VZgVSatHELgTCxLKHYojOiloO2XhROe2ulaDyZBGbPicTHaY6tAPNGW6ESHbU3aVBEDEH
	1sBS2f4/NHcQhAos/fbMjgfOgS+fu0NMsG/J9Muy06LZT8WxVjtT2kKfcKRBb2TVxpSnEZVHcNO4T
	c5JStsOpbxVV7dbQAp1uFNjl4V3ixDbLXYqM9kV2sAI0aqsiOl6XLEWt34Z/G/d+/JNtKZYQjNjoL
	3TITko0uPujdFqZEzPtRqG3R;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDoaN-00000005gD0-0QAW;
	Mon, 05 Oct 2026 19:42:55 +0000
Message-ID: <1111a3da-3eb7-44e0-8c68-4a09bb4615a1@samba.org>
Date: Mon, 5 Oct 2026 21:42:54 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] smb: client: don't use server->smbd_conn without a
 reference or lock
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>
References: <cover.1791225453.git.metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <cover.1791225453.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Paulo/Namjae,

I'll address these https://sashiko.dev/#/patchset/cover.1791225453.git.metze%40samba.org
and resubmit v2 later...

metze

> The SMB Direct client keeps the transport in server->smbd_conn and
> accesses it from several places without any locking:
> 
>    - smbd_get_parameters()
>    - smbd_register_mr()
>    - smbd_debug_proc_show()
> 
> At the same time cifs_abort_connection() (and the reconnect path) can
> call smbd_destroy() at any time, which frees the smbd_connection and
> releases the underlying smbdirect socket. So the readers above can race
> with the teardown and end up using a freed connection/socket, a
> use-after-free.
> 
> While looking at this, smbd_get_parameters() also turned out to
> dereference server->smbd_conn without checking it, which is a NULL
> pointer dereference in smb2_negotiate_wsize()/smb2_negotiate_rsize()
> when it is called during a reconnect window.
> 
> This series closes the races:
> 
>    - server->smbd_conn is only ever changed under server->srv_lock, so
>      readers can safely look at it while holding that lock.
> 
>    - smbdirect gets smbdirect_socket_get()/smbdirect_socket_put(), which
>      take and drop a reference that keeps the socket memory alive (but
>      does not keep it connected). smbd_register_mr() uses them to hold
>      the socket across smbdirect_connection_register_mr_io(); once the
>      connection is gone the socket is no longer connected and the call
>      fails gracefully. A registered MR has its own reference counting.
> 
>    - smbd_get_parameters() no longer returns a pointer into the socket
>      (which cannot be kept valid for the callers). It copies the current
>      parameters into the new server->smbd_params under server->srv_lock
>      and returns a pointer to that; with no connection it returns zeros.
> 
>    - smbd_debug_proc_show() runs with cifs_tcp_ses_lock held, so it takes
>      server->srv_lock instead of a socket reference.
> 
> The two "pass server to ..." patches are mechanical prototype changes
> with no behaviour change, split out so the final fix stays small and
> each step builds on its own.
> 
> All of this is a use-after-free that goes back to the switch to the
> smbdirect socket API, so the whole series is tagged for stable via
> 
>    Fixes: b8aef8c8808c ("smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()")
> 
> which is in mainline since v7.1-rc1.
> 
> I run various xfstests with this.
> 
> I'm unsure if this should go via cifs-next or ksmbd-for-next,
> for consistency with the series I just send I guess both
> could go via ksmbd-for-next?
> 
> Stefan Metzmacher (5):
>    smb: client: change server->smbd_conn only under server->srv_lock
>    smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()
>    smb: client: pass server to smbd_get_parameters()
>    smb: client: pass server to smbd_register_mr()
>    smb: client: don't use server->smbd_conn without a reference or lock
> 
>   fs/smb/client/cifsglob.h  |  12 ++++
>   fs/smb/client/connect.c   |  12 +++-
>   fs/smb/client/file.c      |   4 +-
>   fs/smb/client/smb2ops.c   |   4 +-
>   fs/smb/client/smb2pdu.c   |   4 +-
>   fs/smb/client/smbdirect.c | 124 +++++++++++++++++++++++++++++++++-----
>   fs/smb/client/smbdirect.h |   8 ++-
>   fs/smb/smbdirect/socket.c |  27 +++++++++
>   include/linux/smbdirect.h |   3 +
>   9 files changed, 171 insertions(+), 27 deletions(-)
> 

