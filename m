Received: from mail2.galax.is (ns2.galax.is [185.101.96.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E954C98;
	Tue, 10 Dec 2024 00:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.101.96.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733790789; cv=none; b=ALFy+GhzeKtE+gAwPzruyjpIThv19zh5VTTNWR0LOx0OpLTIeQJ1JQRMlvYLLp6u47xaeqWKW35vOr0YdtLm3116Nm292w0G5fFSRnW9P/bnHWjlk2gegsTA0rtddccVeDumruUjjjFyuUAgCR5KwkiGIUwfVgi1GkIBg0MfILM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733790789; c=relaxed/simple;
	bh=qviual6NNq/LlGdkHdmHvcuPjFwLrFqDr/whkutBiZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p8lRtpgzgxsqIuk9oWLcbdJHx3e8mmAbsWErzrOHLYqAgcAhzpzXfJkmq3Pq6OJ1CTTFp8GjeUsbPdz7tF78I21s7EJooVF9MQkpFkGQEOMTitxCH0iw4crFAKxsq7IXIZJVHDU+ydPJ4FewNTTDydHNSutl9FQxaMwkJrWxoXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=galax.is; spf=pass smtp.mailfrom=galax.is; dkim=pass (2048-bit key) header.d=galax.is header.i=@galax.is header.b=yftcUK20; arc=none smtp.client-ip=185.101.96.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=galax.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=galax.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=galax.is header.i=@galax.is header.b="yftcUK20"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=galax.is; s=default;
	t=1733785501; bh=qviual6NNq/LlGdkHdmHvcuPjFwLrFqDr/whkutBiZQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=yftcUK20ffu2mgLLJV9lno8yglJZpyHpChM7/T1fFCAeXctrCGViT6qd7pZSfCLhn
	 ikrpPQeFscKxS/FQfzb8tffk1PhEadVTjKVHqvluKCw2yD0EhXmY4n5CxJ7LHjN8Xs
	 9CzkszWs8zgz769QXHw9h/v2TdW8OODd1gG52rJti6Uv/KbXPkC9EztF7r3n7RQGeg
	 3664XG5vq6fODD48vRVkYCk0PyzPiAfWYlBsCbBPadp1aZ0zsv5DsQl3MbpOFKjjCU
	 qD80aCZq8+LVBUjkd6qV1rFGYc6Ujflifj53aT+xRcMNPKLhLJXkeIR0pgNM2ROOom
	 HB/gc5hciUrWQ==
Received: from [IPV6:2001:4091:a245:803b:e9e2:b512:c62b:71a3] (unknown [IPv6:2001:4091:a245:803b:e9e2:b512:c62b:71a3])
	by mail2.galax.is (Postfix) with ESMTPSA id E154A1FF38;
	Tue, 10 Dec 2024 00:05:00 +0100 (CET)
Message-ID: <3441d88b-92e6-4f89-83a4-9230c8701d73@galax.is>
Date: Tue, 10 Dec 2024 00:05:00 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
To: Salvatore Bonaccorso <carnil@debian.org>,
 Paulo Alcantara <pc@manguebit.com>
Cc: Michael Krause <mk-debian@galax.is>, gregkh@linuxfoundation.org,
 Steve French <stfrench@microsoft.com>, stable@vger.kernel.org,
 regressions@lists.linux.dev, linux-cifs@vger.kernel.org
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
 <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
 <1037557ef401a66691a4b1e765eec2e2@manguebit.com>
 <Z08ZdhIQeqHDHvqu@eldamar.lan>
From: Michael Krause <mk@galax.is>
Content-Language: de-LU, en-US
Autocrypt: addr=mk@galax.is; keydata=
 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 4K4=
In-Reply-To: <Z08ZdhIQeqHDHvqu@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/24 3:45 PM, Salvatore Bonaccorso wrote:
> Paulo,
> 
> On Tue, Dec 03, 2024 at 10:18:25AM -0300, Paulo Alcantara wrote:
>> Michael Krause <mk-debian@galax.is> writes:
>>
>>> On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
>>>> Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
>>>> in smb2_reconnect_server()") which seems in fact to solve the issue.
>>>>
>>>> Michael, can you please post your backport here for review from Paulo
>>>> and Steve?
>>>
>>> Of course, attached.
>>>
>>> Now I really hope I didn't screw it up :)
>>
>> LGTM.  Thanks Michael for the backport.
> 
> Thanks a lot for the review. So to get it accepted it needs to be
> brough into the form which Greg can pick up. Michael can you do that
> and add your Signed-off line accordingly?
Happy to. Hope this is in the proper format:




 From 411fb6398fe3c3c08a000d717bff189f08d2041c Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@manguebit.com>
Date: Mon, 1 Apr 2024 14:13:10 -0300
Subject: [PATCH] smb: client: fix UAF in smb2_reconnect_server()

commit 24a9799aa8efecd0eb55a75e35f9d8e6400063aa upstream.

The UAF bug is due to smb2_reconnect_server() accessing a session that
is already being teared down by another thread that is executing
__cifs_put_smb_ses().  This can happen when (a) the client has
connection to the server but no session or (b) another thread ends up
setting @ses->ses_status again to something different than
SES_EXITING.

To fix this, we need to make sure to unconditionally set
@ses->ses_status to SES_EXITING and prevent any other threads from
setting a new status while we're still tearing it down.

The following can be reproduced by adding some delay to right after
the ipc is freed in __cifs_put_smb_ses() - which will give
smb2_reconnect_server() worker a chance to run and then accessing
@ses->ipc:

kinit ...
mount.cifs //srv/share /mnt/1 -o sec=krb5,nohandlecache,echo_interval=10
[disconnect srv]
ls /mnt/1 &>/dev/null
sleep 30
kdestroy
[reconnect srv]
sleep 10
umount /mnt/1
...
CIFS: VFS: Verify user has a krb5 ticket and keyutils is installed
CIFS: VFS: \\srv Send error in SessSetup = -126
CIFS: VFS: Verify user has a krb5 ticket and keyutils is installed
CIFS: VFS: \\srv Send error in SessSetup = -126
general protection fault, probably for non-canonical address
0x6b6b6b6b6b6b6b6b: 0000 [#1] PREEMPT SMP NOPTI
CPU: 3 PID: 50 Comm: kworker/3:1 Not tainted 6.9.0-rc2 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-1.fc39
04/01/2014
Workqueue: cifsiod smb2_reconnect_server [cifs]
RIP: 0010:__list_del_entry_valid_or_report+0x33/0xf0
Code: 4f 08 48 85 d2 74 42 48 85 c9 74 59 48 b8 00 01 00 00 00 00 ad
de 48 39 c2 74 61 48 b8 22 01 00 00 00 00 74 69 <48> 8b 01 48 39 f8 75
7b 48 8b 72 08 48 39 c6 0f 85 88 00 00 00 b8
RSP: 0018:ffffc900001bfd70 EFLAGS: 00010a83
RAX: dead000000000122 RBX: ffff88810da53838 RCX: 6b6b6b6b6b6b6b6b
RDX: 6b6b6b6b6b6b6b6b RSI: ffffffffc02f6878 RDI: ffff88810da53800
RBP: ffff88810da53800 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88810c064000
R13: 0000000000000001 R14: ffff88810c064000 R15: ffff8881039cc000
FS: 0000000000000000(0000) GS:ffff888157c00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe3728b1000 CR3: 000000010caa4000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
  <TASK>
  ? die_addr+0x36/0x90
  ? exc_general_protection+0x1c1/0x3f0
  ? asm_exc_general_protection+0x26/0x30
  ? __list_del_entry_valid_or_report+0x33/0xf0
  __cifs_put_smb_ses+0x1ae/0x500 [cifs]
  smb2_reconnect_server+0x4ed/0x710 [cifs]
  process_one_work+0x205/0x6b0
  worker_thread+0x191/0x360
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xe2/0x110
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x34/0x50
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[Michael Krause: Naive, manual merge because the 3rd hunk would not
                  apply]
Signed-off-by: Michael Krause <mk-debian@galax.is>
---
  fs/smb/client/connect.c | 80 ++++++++++++++++++-----------------------
  1 file changed, 35 insertions(+), 45 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 87ce71b39b77..20c50736456a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -259,7 +259,13 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
  
  	spin_lock(&cifs_tcp_ses_lock);
  	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
-		/* check if iface is still active */
+		spin_lock(&ses->ses_lock);
+		if (ses->ses_status == SES_EXITING) {
+			spin_unlock(&ses->ses_lock);
+			continue;
+		}
+		spin_unlock(&ses->ses_lock);
+
  		spin_lock(&ses->chan_lock);
  		if (!cifs_chan_is_iface_active(ses, server)) {
  			spin_unlock(&ses->chan_lock);
@@ -1977,31 +1983,6 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
  	return rc;
  }
  
-/**
- * cifs_free_ipc - helper to release the session IPC tcon
- * @ses: smb session to unmount the IPC from
- *
- * Needs to be called everytime a session is destroyed.
- *
- * On session close, the IPC is closed and the server must release all tcons of the session.
- * No need to send a tree disconnect here.
- *
- * Besides, it will make the server to not close durable and resilient files on session close, as
- * specified in MS-SMB2 3.3.5.6 Receiving an SMB2 LOGOFF Request.
- */
-static int
-cifs_free_ipc(struct cifs_ses *ses)
-{
-	struct cifs_tcon *tcon = ses->tcon_ipc;
-
-	if (tcon == NULL)
-		return 0;
-
-	tconInfoFree(tcon);
-	ses->tcon_ipc = NULL;
-	return 0;
-}
-
  static struct cifs_ses *
  cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
  {
@@ -2035,35 +2016,44 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
  {
  	unsigned int rc, xid;
  	unsigned int chan_count;
+	bool do_logoff;
+	struct cifs_tcon *tcon;
  	struct TCP_Server_Info *server = ses->server;
  
+	spin_lock(&cifs_tcp_ses_lock);
  	spin_lock(&ses->ses_lock);
-	if (ses->ses_status == SES_EXITING) {
	cifs_dbg(FYI, "%s: id=0x%llx ses_count=%d ses_status=%u ipc=%s\n",
+		 __func__, ses->Suid, ses->ses_count, ses->ses_status,
+		 ses->tcon_ipc ? ses->tcon_ipc->tree_name : "none");
+	if (ses->ses_status == SES_EXITING || --ses->ses_count > 0) {
  		spin_unlock(&ses->ses_lock);
+		spin_unlock(&cifs_tcp_ses_lock);
  		return;
  	}
-	spin_unlock(&ses->ses_lock);
+	/* ses_count can never go negative */
+	WARN_ON(ses->ses_count < 0);
  
-	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
-	cifs_dbg(FYI,
-		 "%s: ses ipc: %s\n", __func__, ses->tcon_ipc ? ses->tcon_ipc->tree_name : "NONE");
+	spin_lock(&ses->chan_lock);
+	cifs_chan_clear_need_reconnect(ses, server);
+	spin_unlock(&ses->chan_lock);
  
-	spin_lock(&cifs_tcp_ses_lock);
-	if (--ses->ses_count > 0) {
-		spin_unlock(&cifs_tcp_ses_lock);
-		return;
-	}
+	do_logoff = ses->ses_status == SES_GOOD && server->ops->logoff;
+	ses->ses_status = SES_EXITING;
+	tcon = ses->tcon_ipc;
+	ses->tcon_ipc = NULL;
+	spin_unlock(&ses->ses_lock);
  	spin_unlock(&cifs_tcp_ses_lock);
  
-	/* ses_count can never go negative */
-	WARN_ON(ses->ses_count < 0);
-
-	if (ses->ses_status == SES_GOOD)
-		ses->ses_status = SES_EXITING;
-
-	cifs_free_ipc(ses);
-
-	if (ses->ses_status == SES_EXITING && server->ops->logoff) {
+	/*
+	 * On session close, the IPC is closed and the server must release all
+	 * tcons of the session.  No need to send a tree disconnect here.
+	 *
+	 * Besides, it will make the server to not close durable and resilient
+	 * files on session close, as specified in MS-SMB2 3.3.5.6 Receiving an
+	 * SMB2 LOGOFF Request.
+	 */
+	tconInfoFree(tcon);
+	if (do_logoff) {
  		xid = get_xid();
  		rc = server->ops->logoff(xid, ses);
  		if (rc)
-- 
2.45.2

