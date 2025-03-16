Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133A11DE2A0;
	Sun, 16 Mar 2025 18:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742150089; cv=none; b=ZYjZ/Ntht3g9V5B68p10M85JnUy90JeQmo7VH/vf29rKzPjlMEgJ7lEVOuZyUD06e3i8SDrGnemY7MjoFxIAN5CWs2WcuVHGuWxUQMEalf/zMd9O4kb6wc+dDjcSZFQOQOEcZ7GUy+6/C0X1TUsJRmxts5Lg9ZiTsCt3zRQ6CJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742150089; c=relaxed/simple;
	bh=5gGRj5oFO64lNZKO+ctqbVUkSB8bG76eTNsYltJ639g=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pf9WKycq+Tp7RRFsLgL7KimTwalJr3ywNGJ6fMm/CvhNHKbwQyjCUhjFmLKaegvOUR2vzVjc2w4OX135yytcdn5TQEz2qIQJHNF2P6xBwp8HcBqI4llY1sfgEQ9ltJa/O6MNbHKVfv+Yq91irSu/QsTbHcYJYZfIYfPENpWii6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=baj287sC; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="baj287sC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1742150087; x=1773686087;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GBZMIjlnZQxh6SgQG+JOIr8NIE0q5Sku+Hu1KHvSdkw=;
  b=baj287sCNITHVpLe/BLEFQAOwYaEM/aecvtX+vA1zTlWxkwTqLYXva+Y
   SmY6d5UhyyZtYj+ITpv4ZIzhSSnYczC8jyp8/2rtEDprCU1UbTG9+foFK
   DLZ+sfI/5hLYHiTK/YDeaLcfMj6W1k38Ues1BexxA7ELbrxOLn15/NEju
   g=;
X-IronPort-AV: E=Sophos;i="6.14,252,1736812800"; 
   d="scan'208";a="74826352"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2025 18:34:44 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.43.254:13954]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.37.123:2525] with esmtp (Farcaster)
 id cba89039-cfd3-4521-b756-8bb64d4d1989; Sun, 16 Mar 2025 18:34:42 +0000 (UTC)
X-Farcaster-Flow-ID: cba89039-cfd3-4521-b756-8bb64d4d1989
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sun, 16 Mar 2025 18:34:40 +0000
Received: from 3c06303d853a.ant.amazon.com (10.119.230.233) by
 EX19D026EUB004.ant.amazon.com (10.252.61.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sun, 16 Mar 2025 18:34:37 +0000
Date: Sun, 16 Mar 2025 11:34:32 -0700
From: Andrew Paniakin <apanyaki@amazon.com>
To: Linux regressions mailing list <regressions@lists.linux.dev>
CC: Christian Heusel <christian@heusel.eu>, <pc@cjr.nz>,
	<stfrench@microsoft.com>, <sashal@kernel.org>, <pc@manguebit.com>,
	<stable@vger.kernel.org>, <linux-cifs@vger.kernel.org>,
	<abuehaze@amazon.com>, <simbarb@amazon.com>, <benh@amazon.com>,
	<gregkh@linuxfoundation.org>
Subject: Re: [REGRESSION][BISECTED][STABLE] Commit 60e3318e3e900 in
 stable/linux-6.1.y breaks cifs client failover to another server in DFS
 namespace
Message-ID: <Z9cZuBxOscqybcMy@3c06303d853a.ant.amazon.com>
References: <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
 <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
 <ZnyRlEUqgZ_m_pu-@3c06303d853a>
 <a58625e7-8245-4963-b589-ad69621cb48a@heusel.eu>
 <7c8d1ec1-7913-45ff-b7e2-ea58d2f04857@leemhuis.info>
 <ZpHy4V6P-pawTG2f@3c06303d853a.ant.amazon.com>
 <Zp7-gl5mMFCb4UWa@3c06303d853a.ant.amazon.com>
 <fb4c481d-91ba-46b8-b11a-534597a2b467@leemhuis.info>
 <ZxAm4rvmWp2MMt4b@3c06303d853a.ant.amazon.com>
 <ZzD0cW4gbQnbI9Gm@3c06303d853a>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZzD0cW4gbQnbI9Gm@3c06303d853a>
X-ClientProxiedBy: EX19D035UWB003.ant.amazon.com (10.13.138.85) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)

On 10/11/2024, Andrew Paniakin wrote:
> On 16/10/2024, Andrew Paniakin wrote:
> > On 27/09/2024, Linux regression tracking (Thorsten Leemhuis) wrote:
> > > On 23.07.24 02:51, Andrew Paniakin wrote:
> > > > On 12/07/2024, Andrew Paniakin wrote:
> > > >> On 11/07/2024, Linux regression tracking (Thorsten Leemhuis) wrote:
> > > >>> On 27.06.24 22:16, Christian Heusel wrote:
> > > >>>> On 24/06/26 03:09PM, Andrew Paniakin wrote:
> > > >>>>> On 25/06/2024, Christian Heusel wrote:
> > > >>>>>> On 24/06/24 10:59AM, Andrew Paniakin wrote:
> > > >>>>>>> On 19/06/2024, Andrew Paniakin wrote:
> > > >>>>>>>> Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was
> > > >>
> > > >>> Hmmm, unless I'm missing something it seems nobody did so. Andrew, could
> > > >>> you take care of that to get this properly fixed to prevent others from
> > > >>> running into the same problem?
> > > >>
> Hi Thorsten,
> Last weeks I had to work on few urgent internal issues, so this work got
> delayed. I got confirmation from the manager to make this task my
> priority until it's done. To progress faster I setup systemtap and was
> able find the reason why my reproducer didn't work.

Hi Thorsten,

I completed investigation of this issue and got the data showing that we should
not backport a follow-up fix d5a863a153e9 ("cifs: avoid dup prefix path in
dfs_get_automount_devname()") to linux-6.1. We planned to do it last time [1]
but it will break a mount of the share subdirectories.

Summary:
1. Main purpose of the 7ad54b98fc1f1 ("cifs: use origin fullpath for
automounts") is to use a better-cached TCP_Server_Info::origin_fullpath URL.
But what fixes the failover issue that we reported is a set_dest_addr() call at
the automount start. This fix would work even without switch to origin
fullpath.

2. It's not mentioned in a commit message of the fix d5a863a153e9 ("cifs: avoid
dup prefix path in dfs_get_automount_devname()"), but it only works when
7ad54b98fc1f1 ("cifs: use origin fullpath for automounts" and a1c0d00572fc
("cifs: share dfs connections and supers") applied both. Second patch changed
origin_fullpath contents from namespace root to a full mount path e.g. from
'//corp.fsxtest.local/namespace/' to
'//corp.fsxtest.local/namespace/folderA/fs1-folder/'. Since prefix path
'/folderA/' also stored in cifs superblock info, we need second fix to avoid
adding it twice. 

But the change a1c0d00572fc wasn't ported to linux-6.1, and probably shouldn't
because it's a part of big cifs driver rework made in linux-6.2, not just a bug
fix. So if we backport d5a863a153e9 ("cifs: avoid dup prefix path in
dfs_get_automount_devname()") to linux-6.1, path construction routine
__build_path_from_dentry_optional_prefix will not add prefix path from a
superblock info because it assumes origin_fullpath already has it.

My next step is to resend 7ad54b98fc1f1 ("cifs: use origin fullpath for
automounts") with required comments and send an update to this thread once it
merged.

Please find detailed explanation and test results below.

=== Root cause analysis of the DFS failover issue ===
Steps to trigger failover issue:
1. Create test environment:
* Active Directory domain //corp.fsxtest.local
* DFS namespace '//corp.fsxtest.local/namespace', root server at 172.31.25.164
* Two namespace servers (IP addresses will simplify logs reading):
  * EC2AMAZ-JF3R0PQ at 172.31.48.144
  * EC2AMAZ-T0UUIJ3 at 172.31.60.51
* Network file system fs1.corp.fsxtest.local
* DFS link //corp.fsxtest.local/namespace/fs1-folder refers to //fs1.corp.fsxtest.local/folder1

2. Mount DFS root:
mount -t cifs -o cred=/mnt/creds,noserverino,echo_interval=5 \
  //corp.fsxtest.local/namespace \
  /mnt/dfs-namespace

3. Identify selected root target from logs:
dmesg | grep connect_dfs_target
[635023.023630] CIFS: fs/smb/client/connect.c: connect_dfs_target:
  full_path=\\corp.fsxtest.local\namespace
  ref_path=\corp.fsxtest.local\namespace
  target=\EC2AMAZ-JF3R0PQ.corp.fsxtest.local\namespace

4. Stop target server server, wait for failover finish:
aws ec2 stop-instances --instance-ids $JF3R0PQ && sleep 60

5. Try to access DFS folder link, this fails:
[root@ip-172-31-55-195 ~]# sh -c 'ls /mnt/dfs-namespace/fs1-folder'
ls: cannot access '/mnt/dfs-namespace/fs1-folder': No route to host

Verbose logs show that cifs client uses stale IP after failover.

Initial logs from cifs_smb3_do_mount [2], mount_get_conns[3] and
cifs_get_tcp_session [4] show that client resolved DFS root server address
corp.fsxtest.local to 172.31.25.164 and connected to it, as expected:
```
[635022.848477] CIFS: fs/smb/client/cifsfs.c: Devname: \\corp.fsxtest.local\namespace flags: 0
[635022.850258] CIFS: fs/smb/client/connect.c: VFS: in mount_get_conns as Xid: 0 with uid: 0
[635022.850926] CIFS: fs/smb/client/connect.c: UNC: \\corp.fsxtest.local\namespace
[635022.851531] CIFS: fs/smb/client/connect.c: generic_ip_connect: connecting to 172.31.25.164:445
```

Then it asked root server for referrals and connected to a first one
EC2AMAZ-JF3R0PQ (172.31.48.144):
```
[635023.023630] CIFS: fs/smb/client/connect.c: connect_dfs_target: full_path=\\corp.fsxtest.local\namespace ref_path=\corp.fsxtest.local\namespace target=\EC2AMAZ-JF3R0PQ.corp.fsxtest.local\namespace
[635023.025029] CIFS: fs/smb/client/dfs_cache.c: dfs_cache_get_tgt_referral: path: \corp.fsxtest.local\namespace
[635023.025850] CIFS: fs/smb/client/dfs_cache.c: dfs_cache_get_tgt_referral: target name: \EC2AMAZ-JF3R0PQ.corp.fsxtest.local\namespace
[635023.026805] CIFS: fs/smb/client/dfs_cache.c: setup_referral: set up new ref
[635023.030202] CIFS: fs/smb/client/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: EC2AMAZ-JF3R0PQ.corp.fsxtest.local to 172.31.48.144 expiry 0
```

mount completed and I stopped EC2AMAZ-JF3R0PQ, logs from
__reconnect_target_unlocked [5] show that client resolved and connected to a
next option EC2AMAZ-T0UUIJ3 (172.31.60.51):
```
[635064.392246] CIFS: fs/smb/client/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: EC2AMAZ-T0UUIJ3.corp.fsxtest.local to 172.31.60.51 expiry 1741642209
[635064.393449] CIFS: fs/smb/client/connect.c: reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 121 seconds in the future
[635064.394497] CIFS: fs/smb/client/connect.c: __reconnect_target_unlocked: reconn_set_ipaddr_from_hostname: rc=0
[635064.395352] CIFS: fs/smb/client/connect.c: generic_ip_connect: connecting to 172.31.60.51:445
```

Then I accessed DFS link, this triggers automount, cifs_dfs_do_automount [6]
logs show that cifs client uses new address EC2AMAZ-T0UUIJ3 in a path, but
connects to an old IP 172.31.48.144 of EC2AMAZ-JF3R0PQ:
```
[635117.289268] CIFS: fs/smb/client/cifs_dfs_ref.c: cifs_dfs_d_automount: fs1-folder
[635117.289913] CIFS: fs/smb/client/cifs_dfs_ref.c: cifs_dfs_do_automount: full_path: //EC2AMAZ-T0UUIJ3.corp.fsxtest.local/namespace/fs1-folder
[635117.294269] CIFS: fs/smb/client/connect.c: generic_ip_connect: connecting to 172.31.48.144:445
[635120.386908] CIFS: fs/smb/client/connect.c: Error -113 connecting to server
```

This is because all steps of the reconnect flow update only TCP_Server_Info*
object, not the smb3_fs_context *smb3_fs_context:
- cifs_demultiplex_thread
  - cifs_read_from_socket
    - cifs_readv_from_socket
      - cifs_reconnect
        - reconnect_dfs_server
          - __reconnect_target_unlocked

smb3_fs_context is a cifs internal part of the generic VFS fs_context object.
It stores root target UNC and IP address from which you create TCP_Server_Info*
object later. During automount this context smb3_fs_context_dup()ed from the
parent super block private data. The target UNC is refreshed from new referral,
but the IP address in smb3_fs_context is never refreshed.

Patch 7ad54b98fc1f1 ("cifs: use origin fullpath for automounts") adds a
set_dest_addr() call at the automount start. This helper resolves root target
IP address and updates it in smb3_fs_context.

I built linux-6.1 with this fix and tested failover again.
This time first target was a EC2AMAZ-T0UUIJ3 (172.31.60.51):
```
[  264.651876] CIFS: fs/smb/client/connect.c: connect_dfs_target: full_path=\\corp.fsxtest.local\namespace ref_path=\corp.fsxtest.local\namespace target=\EC2AMAZ-T0UUIJ3.corp.fsxtest.local\namespace
[  264.653327] CIFS: fs/smb/client/dfs_cache.c: dfs_cache_get_tgt_referral: path: \corp.fsxtest.local\namespace
[  264.654157] CIFS: fs/smb/client/dfs_cache.c: dfs_cache_get_tgt_referral: target name: \EC2AMAZ-T0UUIJ3.corp.fsxtest.local\namespace
[  264.655154] CIFS: fs/smb/client/dfs_cache.c: setup_referral: set up new ref
[  264.665896] CIFS: fs/smb/client/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: EC2AMAZ-T0UUIJ3.corp.fsxtest.local to 172.31.60.51 expiry 0
```

When I stopped it client reconnected to EC2AMAZ-JF3R0PQ (172.31.48.144):
```
[  306.444808] CIFS: fs/smb/client/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: EC2AMAZ-JF3R0PQ.corp.fsxtest.local to 172.31.48.144 expiry 1742025040
[  306.446041] CIFS: fs/smb/client/connect.c: reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 121 seconds in the future
[  306.447067] CIFS: fs/smb/client/connect.c: __reconnect_target_unlocked: reconn_set_ipaddr_from_hostname: rc=0
[  306.447916] CIFS: fs/smb/client/connect.c: generic_ip_connect: connecting to 172.31.48.144:445
```

Then I accessed DFS link folder, triggered automount and cifs client used root
server address corp.fsxtest.local and IP 172.31.25.164, just as needed:
```
[  346.722178] CIFS: fs/smb/client/cifs_dfs_ref.c: cifs_dfs_d_automount: fs1-folder
[  346.722821] CIFS: fs/smb/client/cifs_dfs_ref.c: cifs_dfs_do_automount: full_path: //corp.fsxtest.local/namespace/fs1-folder
[  346.726676] CIFS: fs/smb/client/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: corp.fsxtest.local to 172.31.25.164 expiry 0
[  346.727694] CIFS: fs/smb/client/cifsfs.c: Devname: \\corp.fsxtest.local\namespace flags: 0
[  346.728400] CIFS: fs/smb/client/connect.c: Username: Admin
[  346.728881] CIFS: fs/smb/client/connect.c: file mode: 0755  dir mode: 0755
[  346.729476] CIFS: fs/smb/client/connect.c: VFS: in mount_get_conns as Xid: 15 with uid: 0
[  346.730185] CIFS: fs/smb/client/connect.c: UNC: \\corp.fsxtest.local\namespace
[  346.730811] CIFS: fs/smb/client/connect.c: generic_ip_connect: connecting to 172.31.25.164:445
[  346.731578] CIFS: fs/smb/client/connect.c: Socket created
```

=== RCA of the duplicated prefix path issue ===
To make sure the backport is correct, I tried to reproduce the described
problem first. I tried to trigger the issue by putting DFS links at different
places in the path or doing tricks with links to another namespace with their own links,
but with no luck. Then I spend lots of time reading cifs code and concluded
that linux-6.1 can't have prefix duplication issue in a path, so I tried the
build of d5a863a153e9^ and was able to reproduce the issue immediately.

Steps:
1. Move DFS link fs1-folder (access to basic folder will not trigger automount) inside folderA:
//corp.fsxtest.local/namespace/folderA/fs1-folder

2. Mount this subfolder:
[root@ip-172-31-55-195 ~]# mount -t cifs -o cred=/mnt/creds,noserverino,echo_interval=5 \
     //corp.fsxtest.local/namespace/folderA /mnt/dfs-namespace

3. Try to access link fs1-folder, this fails:
[root@ip-172-31-55-195 ~]# sh -c 'ls /mnt/dfs-namespace/fs1-folder'
ls: cannot access '/mnt/dfs-namespace/fs1-folder': No such file or directory

cifs_dfs_do_automount logs below print the reason:
- cifs_sb prepath, this is added to the path by dfs_get_automount_devname after
  DFS tree.
- full_path, constructed by dfs_get_automount_devname [7] using DFS tree UNC,
  cifs_sb prepath and origin_fullpath.
As we can see folderA appears there twice:
```
[ 2522.544482] CIFS: fs/cifs/cifs_dfs_ref.c: cifs_dfs_d_automount: fs1-folder
[ 2522.545072] CIFS: fs/cifs/dir.c: using cifs_sb prepath <folderA>
[ 2522.545593] CIFS: fs/cifs/cifs_dfs_ref.c: cifs_dfs_do_automount: full_path: //corp.fsxtest.local/namespace/folderA/folderA/fs1-folder
[SNIP]
[ 2522.686368] CIFS: fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_d_automount [automount failed]
```

Same build of linux-6.1 with my backport of 7ad54b98fc1f1 ("cifs: use origin
fullpath for automounts") handles prefix path mount correctly, no follow-up
needed:
```
[  152.901711] CIFS: fs/smb/client/cifs_dfs_ref.c: cifs_dfs_d_automount: fs1-folder
[  152.902356] CIFS: fs/smb/client/dir.c: using cifs_sb prepath <folderA>
[  152.902921] CIFS: fs/smb/client/cifs_dfs_ref.c: cifs_dfs_do_automount: full_path: //corp.fsxtest.local/namespace/folderA/fs1-folder
[SNIP]
[  153.224169] CIFS: fs/smb/client/cifs_dfs_ref.c: leaving cifs_dfs_d_automount [ok]
```

=== Verify that backport d5a863a153e9 ("cifs: avoid dup prefix path in dfs_get_automount_devname()") breaks prepath automount ===
It's pretty clear from code, but to double check I tested a build of v6.1.129 +
7ad54b98fc1f ("cifs: use origin fullpath for automounts") + d5a863a153e9
("cifs: avoid dup prefix path in dfs_get_automount_devname()").
As expected, I got '//corp.fsxtest.local/namespace/fs1-folder' instead
of '//corp.fsxtest.local/namespace/folderA/fs1-folder':
```
[  630.368406] CIFS: fs/smb/client/cifs_dfs_ref.c: cifs_dfs_d_automount: fs1-folder
[  630.369031] CIFS: fs/smb/client/cifs_dfs_ref.c: cifs_dfs_do_automount: full_path: //corp.fsxtest.local/namespace/fs1-folder
```

[1] https://lore.kernel.org/all/20240716152749.667492414@linuxfoundation.org/
[2] https://web.git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/smb/client/cifsfs.c?h=v6.1.129#n910
[3] https://web.git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/smb/client/connect.c?h=v6.1.129#n3317
[4] https://web.git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/smb/client/connect.c?h=v6.1.129#n1706 
[5] https://web.git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/smb/client/connect.c?h=v6.1.129#n486
[6] https://web.git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/smb/client/cifs_dfs_ref.c?h=v6.1.129#n306
[7] https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/cifs/dir.c?id=d5a863a153e9^#n110
