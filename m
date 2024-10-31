Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDD21C9B6F
	for <linux-cifs@vger.kernel.org>; Thu, 31 Oct 2024 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730397445; cv=none; b=PTyjcOmkXKe6foQCOWcpyElUcehWWMv6dGytP9M6TS9O7GXvzlv19EyXR1s3ftgik+RRISGE2QMnol7Lz6NLvF5uMtCn/+uC2dt8K9QR3nObQyAWZ789IRBAaHgY/P8lv0jDz2WVlmuOwI8W1shH9MNAWbCQCxfNw7A/kVa9DWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730397445; c=relaxed/simple;
	bh=KKFeAnGYDMo0MMUl9WzHwycdnBHyv6gGmrSkPXlfSPY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V8U86Gpo/cddUpcwbj8YRa1z6hj+bpMAaNKIEePlSgjU+nNPv00cNGKhMcTzTgf9EOUlEYElWD5xEwihTKgJhdi1e2G4qM46lws9jmpn5sLXI2Aioh74yQcBrWKC4hHavGAzW14LMXef1zYCMbF1lWffNWU6z0cgKQLjDSvE1os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=lcT9sG/V; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="lcT9sG/V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730397442; x=1761933442;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZKQUq+eYE1Wd+pT+uX6uEfVSsWey4JvdojuKIDHaAME=;
  b=lcT9sG/VdofLM9SiIgVwYwheo8zLS2pxGejACIQlXf68MdFeSXamdoGW
   gNDMzr1sudkaTD9NEezklNXID4zGHyexgb5yP8p43DSrty3rMbpnP7k06
   V0FkmbNrzyRMPsg9VpGTmTR/7qBz+zqq5jkQRWzCS4i/lWJDonxYRLL3g
   c=;
X-IronPort-AV: E=Sophos;i="6.11,247,1725321600"; 
   d="scan'208";a="37984751"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 17:57:18 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:27400]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.121:2525] with esmtp (Farcaster)
 id b53434b5-a547-49c2-9371-9f71de40b485; Thu, 31 Oct 2024 17:57:17 +0000 (UTC)
X-Farcaster-Flow-ID: b53434b5-a547-49c2-9371-9f71de40b485
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 31 Oct 2024 17:57:17 +0000
Received: from 6c7e67c6786f.amazon.com (10.106.101.30) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Thu, 31 Oct 2024 17:57:14 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
	<sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
	<bharathsm@microsoft.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>
Subject: [PATCH v1] smb: client: Fix use-after-free of network namespace.
Date: Thu, 31 Oct 2024 10:57:09 -0700
Message-ID: <20241031175709.20111-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWB001.ant.amazon.com (10.13.139.132) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

Recently, we got a customer report that CIFS triggers oops while
reconnecting to a server.  [0]

The workload runs on Kubernetes, and some pods mount CIFS servers
in non-root network namespaces.  The problem rarely happened, but
it was always while the pod was dying.

The root cause is wrong reference counting for network namespace.

CIFS uses kernel sockets, which do not hold refcnt of the netns that
the socket belongs to.  That means CIFS must ensure the socket is
always freed before its netns; otherwise, use-after-free happens.

The repro steps are roughly:

  1. mount CIFS in a non-root netns
  2. drop packets from the netns
  3. destroy the netns
  4. unmount CIFS

We can reproduce the issue quickly with the script [1] below and see
the splat [2] if CONFIG_NET_NS_REFCNT_TRACKER is enabled.

When the socket is TCP, it is hard to guarantee the netns lifetime
without holding refcnt due to async timers.

Let's hold netns refcnt for each socket by passing @kern=0 to
__sock_create().

Note that we need to move put_net() from cifs_put_tcp_session() to
clean_demultiplex_info(); otherwise, __sock_create() still could touch a
freed netns while cifsd tries to reconnect from cifs_demultiplex_thread().

Also, maybe_get_net() cannot be put just before __sock_create() because
the code is not under RCU and there is a small chance that the same
address happened to be reallocated to another netns.

[0]:
CIFS: VFS: \\XXXXXXXXXXX has not responded in 15 seconds. Reconnecting...
CIFS: Serverclose failed 4 times, giving up
Unable to handle kernel paging request at virtual address 14de99e461f84a07
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
[14de99e461f84a07] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1] SMP
Modules linked in: cls_bpf sch_ingress nls_utf8 cifs cifs_arc4 cifs_md4 dns_resolver tcp_diag inet_diag veth xt_state xt_connmark nf_conntrack_netlink xt_nat xt_statistic xt_MASQUERADE xt_mark xt_addrtype ipt_REJECT nf_reject_ipv4 nft_chain_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_comment nft_compat nf_tables nfnetlink overlay nls_ascii nls_cp437 sunrpc vfat fat aes_ce_blk aes_ce_cipher ghash_ce sm4_ce_cipher sm4 sm3_ce sm3 sha3_ce sha512_ce sha512_arm64 sha1_ce ena button sch_fq_codel loop fuse configfs dmi_sysfs sha2_ce sha256_arm64 dm_mirror dm_region_hash dm_log dm_mod dax efivarfs
CPU: 5 PID: 2690970 Comm: cifsd Not tainted 6.1.103-109.184.amzn2023.aarch64 #1
Hardware name: Amazon EC2 r7g.4xlarge/, BIOS 1.0 11/1/2018
pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : fib_rules_lookup+0x44/0x238
lr : __fib_lookup+0x64/0xbc
sp : ffff8000265db790
x29: ffff8000265db790 x28: 0000000000000000 x27: 000000000000bd01
x26: 0000000000000000 x25: ffff000b4baf8000 x24: ffff00047b5e4580
x23: ffff8000265db7e0 x22: 0000000000000000 x21: ffff00047b5e4500
x20: ffff0010e3f694f8 x19: 14de99e461f849f7 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000000 x12: 3f92800abd010002
x11: 0000000000000001 x10: ffff0010e3f69420 x9 : ffff800008a6f294
x8 : 0000000000000000 x7 : 0000000000000006 x6 : 0000000000000000
x5 : 0000000000000001 x4 : ffff001924354280 x3 : ffff8000265db7e0
x2 : 0000000000000000 x1 : ffff0010e3f694f8 x0 : ffff00047b5e4500
Call trace:
 fib_rules_lookup+0x44/0x238
 __fib_lookup+0x64/0xbc
 ip_route_output_key_hash_rcu+0x2c4/0x398
 ip_route_output_key_hash+0x60/0x8c
 tcp_v4_connect+0x290/0x488
 __inet_stream_connect+0x108/0x3d0
 inet_stream_connect+0x50/0x78
 kernel_connect+0x6c/0xac
 generic_ip_connect+0x10c/0x6c8 [cifs]
 __reconnect_target_unlocked+0xa0/0x214 [cifs]
 reconnect_dfs_server+0x144/0x460 [cifs]
 cifs_reconnect+0x88/0x148 [cifs]
 cifs_readv_from_socket+0x230/0x430 [cifs]
 cifs_read_from_socket+0x74/0xa8 [cifs]
 cifs_demultiplex_thread+0xf8/0x704 [cifs]
 kthread+0xd0/0xd4
Code: aa0003f8 f8480f13 eb18027f 540006c0 (b9401264)

[1]:
CIFS_CRED="/root/cred.cifs"
CIFS_USER="Administrator"
CIFS_PASS="Password"
CIFS_IP="X.X.X.X"
CIFS_PATH="//${CIFS_IP}/Users/Administrator/Desktop/CIFS_TEST"
CIFS_MNT="/mnt/smb"
DEV="enp0s3"

cat <<EOF > ${CIFS_CRED}
username=${CIFS_USER}
password=${CIFS_PASS}
domain=EXAMPLE.COM
EOF

unshare -n bash -c "
mkdir -p ${CIFS_MNT}
ip netns attach root 1
ip link add eth0 type veth peer veth0 netns root
ip link set eth0 up
ip -n root link set veth0 up
ip addr add 192.168.0.2/24 dev eth0
ip -n root addr add 192.168.0.1/24 dev veth0
ip route add default via 192.168.0.1 dev eth0
ip netns exec root sysctl net.ipv4.ip_forward=1
ip netns exec root iptables -t nat -A POSTROUTING -s 192.168.0.2 -o ${DEV} -j MASQUERADE
mount -t cifs ${CIFS_PATH} ${CIFS_MNT} -o vers=3.0,sec=ntlmssp,credentials=${CIFS_CRED},rsize=65536,wsize=65536,cache=none,echo_interval=1
touch ${CIFS_MNT}/a.txt
ip netns exec root iptables -t nat -D POSTROUTING -s 192.168.0.2 -o ${DEV} -j MASQUERADE
"

umount ${CIFS_MNT}

[2]:
ref_tracker: net notrefcnt@000000004bbc008d has 1/1 users at
     sk_alloc (./include/net/net_namespace.h:339 net/core/sock.c:2227)
     inet_create (net/ipv4/af_inet.c:326 net/ipv4/af_inet.c:252)
     __sock_create (net/socket.c:1576)
     generic_ip_connect (fs/smb/client/connect.c:3075)
     cifs_get_tcp_session.part.0 (fs/smb/client/connect.c:3160 fs/smb/client/connect.c:1798)
     cifs_mount_get_session (fs/smb/client/trace.h:959 fs/smb/client/connect.c:3366)
     dfs_mount_share (fs/smb/client/dfs.c:63 fs/smb/client/dfs.c:285)
     cifs_mount (fs/smb/client/connect.c:3622)
     cifs_smb3_do_mount (fs/smb/client/cifsfs.c:949)
     smb3_get_tree (fs/smb/client/fs_context.c:784 fs/smb/client/fs_context.c:802 fs/smb/client/fs_context.c:794)
     vfs_get_tree (fs/super.c:1800)
     path_mount (fs/namespace.c:3508 fs/namespace.c:3834)
     __x64_sys_mount (fs/namespace.c:3848 fs/namespace.c:4057 fs/namespace.c:4034 fs/namespace.c:4034)
     do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
     entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Fixes: 26abe14379f8 ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 fs/smb/client/connect.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 15d94ac4095e..355d25b99839 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1037,6 +1037,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		 */
 	}
 
+	put_net(cifs_net_ns(server));
 	kfree(server->leaf_fullpath);
 	kfree(server);
 
@@ -1635,8 +1636,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	/* srv_count can never go negative */
 	WARN_ON(server->srv_count < 0);
 
-	put_net(cifs_net_ns(server));
-
 	list_del_init(&server->tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -3071,7 +3070,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		socket = server->ssocket;
 	} else {
 		rc = __sock_create(cifs_net_ns(server), sfamily, SOCK_STREAM,
-				   IPPROTO_TCP, &server->ssocket, 1);
+				   IPPROTO_TCP, &server->ssocket, 0);
 		if (rc < 0) {
 			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
 			return rc;
-- 
2.39.5 (Apple Git-154)

