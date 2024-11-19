Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5856C2C9
	for <linux-cifs@vger.kernel.org>; Tue, 19 Nov 2024 02:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731983378; cv=none; b=io7Hx9Yl3eH5/xTpKvFr4l2NzbLVqRKpVV5JnrO7dZbpzMLXkcFgBtDONfFs8gaK/Q51bpdJYkPBv3l4cs7xXvoMjmSKCMvq2N+2wF4+jbvezhff9DBo7N8n6AZklTIMo9CyACRFJfbH3uGYP4N8J9rfdd2QOCN4+q5hDAc6mvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731983378; c=relaxed/simple;
	bh=dP9h4yI17n6JF4wN1AXEDm75lZRloo0SEgFyNfCS3yU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TNcLFQ5mZCbE2gYG7vgh2HAGaVqs2Uio5hGm8HveEKHogBsfuBhMNdzTT4/jRJAUiAcqf6vsaBxHBCSU14SGvl77ZJqTA0u4s7Z4O+d8AdbPmEApoM98qnc2XTNaTXmXMaRBoghKLt1Ke1BAdJcgXyiUgtnkzqOxUtbQmW0iU0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=wIwKaWea; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=c6Q1QI/v; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="wIwKaWea";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="c6Q1QI/v"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1731983376; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : content-transfer-encoding :
 in-reply-to : from; bh=BT8AtMEOmLT/3StiIE5y0K4yO4g3AvehHq0UsEiJ9U4=;
 b=wIwKaWeaxYo4/yudRlvPJw92CP5MkuhQrSF9TLytJo2fQYhny4a5VPJTziZ+k4jJuH/vc
 Ph3UEuMK0yzR848Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1731983376; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : content-transfer-encoding : in-reply-to : from;
 bh=BT8AtMEOmLT/3StiIE5y0K4yO4g3AvehHq0UsEiJ9U4=;
 b=c6Q1QI/v4crvqPnz6xS+fCMJ4BVQYk6WOtPYaXjaYbRNtiv0VKw6G0uC6xh+gQb+ysMPI
 b2+lQLX3lqalCZMSI6ZbK4noFX3CW+LI5Af7oVzzZVwtsdMR1xmK7PuB/2WBTQ01KPIVOWU
 VBMtA9/DBZ77ix7c4mftdKh4JrIL+E/GrV+iXpViBErspDnXsBPcZ3qcnzKmoVZph7e1Ptt
 41r12XYyyGzuu7177VuS0s6HHncKl8mIWzZH4Eq1aK5WH3W6qKzCd674MYaI9lr1M5UiovK
 /7nRacLwsJnYW4g7eMjG3aUVitmwXSLJXrWOz/lyOcF3NqB6xJgFr7RS4oyw==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id 0116B8379;
	Mon, 18 Nov 2024 18:29:35 -0800 (PST)
Received: by vaarsuvius.home.arpa (Postfix, from userid 1000)
	id 912CB8C1479; Mon, 18 Nov 2024 18:29:35 -0800 (PST)
Date: Mon, 18 Nov 2024 18:29:35 -0800
From: Paul Aurich <paul@darkrain42.org>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH v2 0/4] SMB cached directory fixes around
 reconnection/unmounting
Message-ID: <Zzv4DyaTrdQLgtIE@vaarsuvius.home.arpa>
Mail-Followup-To: Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
References: <20241118215028.1066662-1-paul@darkrain42.org>
 <CAH2r5msFodKYc5EMtvQF-hC94qH=GrMhSixmwB7RbkGP-Q48UQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5msFodKYc5EMtvQF-hC94qH=GrMhSixmwB7RbkGP-Q48UQ@mail.gmail.com>

On 2024-11-18 18:55:23 -0600, Steve French wrote:
>Looks like you dropped the patch:
>"smb: No need to wait for work when cleaning up cached directories"
>
>Otherwise for the four remaining patches, looks like the first patch
>stayed the same (trivial comment change).
>
>Can you remind me which of these three changed:
>
>  smb: Don't leak cfid when reconnect races with open_cached_dir
>  smb: prevent use-after-free due to open_cached_dir error paths
>  smb: During unmount, ensure all cached dir instances drop their dentry

All the substantive changes are in the last patch.  I should have clarified, 
but I just folded the changes from "smb: No need to wait for work when 
cleaning up cached directories" into that patch, as well.

>On Mon, Nov 18, 2024 at 3:53 PM Paul Aurich <paul@darkrain42.org> wrote:
>>
>> v2:
>> - Added locking in closed_all_cached_dirs()
>> - Replaced use of the cifsiod_wq with a new workqueue used for dropping cached
>>   dir dentries, and split out the "drop dentry" work from "potential
>>   SMB2_close + cleanup" work so that close_all_cached_dirs() doesn't block on
>>   server traffic, but can ensure all "drop dentry" work has run.
>> - Repurposed the (essentially unused) cfid->fid_lock to protect cfid->dentry
>>
>>
>> The SMB client cached directory functionality can either leak a cfid if
>> open_cached_dir() races with a reconnect, or can have races between the
>> unmount process and cached dir cleanup/lease breaks that all lead to
>> a cached_dir instance not dropping its dentry ref in close_all_cached_dirs().
>> These all manifest as a pair of BUGs when unmounting:
>>
>>     [18645.013550] BUG: Dentry ffff888140590ba0{i=1000000000080,n=/}  still in use (2) [unmount of cifs cifs]
>>     [18645.789274] VFS: Busy inodes after unmount of cifs (cifs)
>>
>> These issues started with the lease directory cache handling introduced in
>> commit ebe98f1447bb ("cifs: enable caching of directories for which a lease is
>> held"), and go away if I mount with 'nohandlecache'.
>>
>> I'm able to reproduce the "Dentry still in use" errors by connecting to an
>> actively-used SMB share (the server organically generates lease breaks) and
>> leaving these running for 'a while':
>>
>> - while true; do cd ~; sleep 1; for i in {1..3}; do cd /mnt/test/subdir; echo $PWD; sleep 1; cd ..; echo $PWD; sleep 1; done; echo ...; done
>> - while true; do iptables -F OUTPUT; mount -t cifs -a; for _ in {0..2}; do ls /mnt/test/subdir/ | wc -l; done; iptables -I OUTPUT -p tcp --dport 445 -j DROP; sleep 10; echo "unmounting"; umount -l -t cifs -a; echo "done unmounting"; sleep 20; echo "recovering"; iptables -F OUTPUT; sleep 10; done
>>
>> ('a while' is anywhere from 10 minutes to overnight. Also, it's not the
>> cleanest reproducer, but I stopped iterating once I had something that was
>> even remotely reliable for me...)
>>
>> This series attempts to fix these, as well as a use-after-free that could
>> occur because open_cached_dir() explicitly frees the cached_fid, rather than
>> relying on reference counting.
>> Paul Aurich (4):
>>   smb: cached directories can be more than root file handle
>>   smb: Don't leak cfid when reconnect races with open_cached_dir
>>   smb: prevent use-after-free due to open_cached_dir error paths
>>   smb: During unmount, ensure all cached dir instances drop their dentry
>>
>>  fs/smb/client/cached_dir.c | 228 +++++++++++++++++++++++++------------
>>  fs/smb/client/cached_dir.h |   6 +-
>>  fs/smb/client/cifsfs.c     |  14 ++-
>>  fs/smb/client/cifsglob.h   |   3 +-
>>  fs/smb/client/inode.c      |   3 -
>>  fs/smb/client/trace.h      |   3 +
>>  6 files changed, 179 insertions(+), 78 deletions(-)
>>
>> --
>> 2.45.2
>>
>>
>
>
>-- 
>Thanks,
>
>Steve

