Received: from mail2.galax.is (ns2.galax.is [185.101.96.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428412F2F;
	Thu, 12 Dec 2024 21:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.101.96.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734040155; cv=none; b=tSvddo3o3GCbz1QMs/o59XhK7p9/SwgA+VYa0xHL7FkVg1Rl9e2XIFcup8YSBebVF7XrUYCsXDtzMyzxz3fCALro6/BDdNdnpbtb2spL4z0V1KVM1Kt9fYLdYCIQW3XVuQ8ljmQDsGGDsoKHajnOgdtBuDToz/reGVIuwkE1RrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734040155; c=relaxed/simple;
	bh=xP9T+H5GlGvFJugqpliS922vS07kjYPrWyReE9BojeU=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=LuAAU3m+ENT7UG1vCpB7aaE07gJkZhFhc2SRiYxAPQxjhzTWqlzCOhf0HR3sJBnQsIW/1OsTsh0VCtUhyYg33VtscOhj1hr8TTOR6HksWXLEmkOErYJsUx2lc325aD4Zv9bLaF2THvznr7/jvlnd18UrgwHAnSf9cQMJBDherPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=galax.is; spf=pass smtp.mailfrom=galax.is; dkim=pass (2048-bit key) header.d=galax.is header.i=@galax.is header.b=Vi34sEHB; arc=none smtp.client-ip=185.101.96.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=galax.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=galax.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=galax.is header.i=@galax.is header.b="Vi34sEHB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=galax.is; s=default;
	t=1734040136; bh=xP9T+H5GlGvFJugqpliS922vS07kjYPrWyReE9BojeU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Vi34sEHB3RIBvF+TM7t/1DM9XUIPc+23wSJz0ZPLaN2ao2GPXrkr0O78qcHdxz36x
	 zo1OyfFBB1nqYXhoSrNNovdeqTOJ8LPE4IyPwRhglMFCISdc17j3TqOlsSBd1E7RpV
	 VOu91CTjT20dtiTSWjLYpzlNThPtHRIOWo6GNjB7pC79Mn5Ju+GB1kUyaEJGm+DK/c
	 br93m2CfwhyECxLxDbsSfN7JcSi3MqlYii5GR2pFRiJEc9IRAeuPO4HC0725crUN3+
	 /WMYmNsL+aTA1UiDtNZtoI9c4iST/KJZppAPpa63TX8nBAVrHJRbLOuGGpJYklJff4
	 hN2hQpX53YVdA==
Received: from [IPV6:2001:4091:a245:803b:2c86:ca27:4c03:eab6] (unknown [IPv6:2001:4091:a245:803b:2c86:ca27:4c03:eab6])
	by mail2.galax.is (Postfix) with ESMTPSA id 094161FF38;
	Thu, 12 Dec 2024 22:48:55 +0100 (CET)
Content-Type: multipart/mixed; boundary="------------tn0XGAUH9758TAJ8z3vOiT6p"
Message-ID: <e9f36681-2d7e-4153-9cdf-cf556e290a53@galax.is>
Date: Thu, 12 Dec 2024 22:48:55 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>,
 Paulo Alcantara <pc@manguebit.com>, Michael Krause <mk-debian@galax.is>,
 Steve French <stfrench@microsoft.com>, stable@vger.kernel.org,
 regressions@lists.linux.dev, linux-cifs@vger.kernel.org
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
 <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
 <1037557ef401a66691a4b1e765eec2e2@manguebit.com>
 <Z08ZdhIQeqHDHvqu@eldamar.lan>
 <3441d88b-92e6-4f89-83a4-9230c8701d73@galax.is>
 <2024121243-perennial-coveting-b863@gregkh>
From: Michael Krause <mk@galax.is>
Content-Language: de-LU, en-US
Autocrypt: addr=mk@galax.is; keydata=
 xsFNBFHdwX8BEADRriJapj831U2CtETKWsnlzPwrA/FvUu9qA5Yao9w3ZBSDKjyItxhSrbTA
 IHoXVqYqw/1+B7QpsNP897LNtMUBplpHnXh7tMuLjXF7Q6mzptNpb5EKkeaTKidTZ/RA2Jtj
 alaj/lrxwuE4e0ZCo6TWLfaWAVyHgNQSj2XXxvx6WAH2lCdoevUn/ezhaMkpRd2TSQQImCKd
 nEHR4zuakgEvsnf1qi++H4gHEKTiQgzMhu/MkEJ460ZFwHB8q4/Gs9Hrql205kjhDqjvOJn0
 TPbRUoYmdnr5RpFlTwHzqgX//SjuA822sS0n2YqgpSnIF53Ou3DTVoCvPe62Fpz7ikm9t191
 qfx34N2l0UYvpnXsOl4yIltt2Tp0JXHDOxn8YNFA0vkfpycK02xwZSaBSNjLDU1PBV+n02XA
 LNW2Vsb1mgoqL5Isqxnb6zNaMKVQZijNxE0fFa0yHOKfyJCEq8FZSHGkfQ69/7tjlycW+3LM
 uYfSVZAi9nC8wCfbObt5tn3BjnFhi8jk6+5CJ5yE0slsNYwO0I7v5WZtTCxfH9wQ+kixgdvv
 y9HJJ4bYgEiv1Un3+80d+BwEd8Qxq+48wXIEyt9DNFl6uArHywRN0Fn/jIY9VikJCXzXRAVD
 5NauJ1xgdWjFE9bp2D+VGVWsZcDoNx8gpnGy/xK1+IAYhn+LbwARAQABzRxNaWNoYWVsIEty
 YXVzZSA8bWtAZ2FsYXguaXM+wsF/BBMBAgApAhsjBwsJCAcDAgEGFQgCCQoLBBYCAwECHgEC
 F4AFAmTInDcFCRauJeEACgkQShnNohZ3RnBMKRAAraIZ/2H1PqS9ys9E3YV88MfPLJuK0KWf
 ZaIFON9avdI43sl2co6m5DtH0qy7G79k9qlCsL/tR7YETdGING5+sArc7gtMSqBIrurcnog/
 jLgEURdA+9UBb+0FqKwkFXowxcTAEEMlhwQXWm6w0SYhIEw7tnOuWW6+ql6QkHv7qhfQXP4d
 W2kOns9jC7Zp8iBHQTCWU7xuJxWl7WXam2c5UHOZBiFGy+I2cWpP812AagU2iLCxC1ap+nzQ
 BKnI9jTJu0/9Vf+yyWJLf8SCoYeAJDWcEIiT3EuRnKYhCRBVg/c6+rDhPTrcBA8GrWeSMgGn
 qFZunwx9Acq+LeQPPG2XhweRxKQIjQGKw0nzCPNctz7TF8CVzBRNEgaMZxk0MbA7coC9DbLL
 uJEcq2MzQLHp76Rj7Bpy3gJYjR4SKpX6SGRyBYnXojsgESQPpT52KUX6omk19nMzUc+gqRZE
 sfzA40NtBhX6ETsgdHVygC4ElTvFDur0LsTW2bbCWqzhCdi9BnmrenVRIy+A5xe6hhhblD5D
 LgZtpFuLRWKrJB4aG+VZdbOF+1emKfewT2yg+5qcYaqyJi9OKJSIWuXBOnCgRRgCzCeJpuio
 5znz2HyfHBIP0rvzYNPY96O0VOmMii2yEF3Gh/PV52312YYRil2QC4u6bJQU6GxsjD/HJybz
 lBDOwU0EUd3BfwEQAPWBUtEHrLjpigUHDR+wIZYEjLnw3bqqddGD8itqy8uxuAYtJexS9ZFa
 reGOqjACCz21I8RKvH0zzOTRFC24qCszBkhSySwp1dgnE0DUPcIxR7WILzDXBbFE3rkxmg3c
 lfKdUuXPiMXlrvRZEs2WBQymwAWPabgtFrudU8IEcoELLL0uogo7seNZPLK4bqDJ654kbpTd
 XkDRPNQYXb71wXXiZ1miVEge73qjraQJE4iw+qBAAIvMa18ud4tVHMx1Ft0IYunsiVlAimVt
 +1t99WRrXYE/xhQb7yqVeNPasqBmNcz4MsRgbfNTg2+Ez1x+TtcpZ1mI2BK7/xjcoIiBaFQQ
 kmLXxx7EAdALh0UNH8rY/OSyE9XUSVvsM9n6W8HJIi8bnVG0KJmpW8t9GQGKszW+gIdx38ga
 v0msngFBm1dVgjtDjKS388oAOqrV5fseytWDEatU8+F0CtV+L5y6lnuKp5HMjOJH7LMNBBPQ
 94e7YzwIi0L5FCj9CIgP7kkyIz1h2vR7zHJ58VhWI0jqTqcydmTciI/AYocU2x+bt8RhQ5TO
 TkxrEPbzvHseXg0SjiPt7z4+3hxq5VOTNpSd1bpSWE/k73XMQYhI/Iy7nJEXfd5NmONQzniz
 yFmy1VAo6pFEfOLGTxLYS08hiI+cebyum9Xi5MT8A6ptQa+yCpNPABEBAAHCwWUEGAECAA8C
 GwwFAmTInDcFCRauJeEACgkQShnNohZ3RnDdfg//c4DahA87lalQLrcVKgv3MPZz4hsqlltl
 p70xX4QtiEQH5ElsFj/xH1yChfCmpfD0gv4jL2yCuz+1Hl4tzlHYSj3/N/CwAbYgmbvX9gn/
 9gPmR8f2YyzBIaLqAlYVXixyIpKj8vDt1+CTXw2QPAtDLkMkl21WWHTsiTiQgqWKsLyuva2h
 NeHA5CJT5EmCSsg7y0Wvo4nf8YGr7i3nlhnkjLckfqIOd3FFrpRk1Jp+MmTsF8uBwj+ftH6F
 o0jqFBACWorw26cWPvLgzGC3cjABGaxtcsoRjEuwk92tln1IoYsmxQw7wmxGTDC8KwCF9aWc
 nPVC3FL/Q0QJfmcpS4wm9TgyrOOyn5/sB2DHtR7G96CKJ25/oJeNCVjCwB5GbM5vwWdHo9Zl
 p3LlVThrVsuIWS936aJ3qAaUOYTifJD2+dzsfjMkVcyTc7ZdZcitFEkWbZwuLeBM+ivG8zI4
 nCFJamC2IAFikqfrL44H7zvL4jZJKYi5vxMBi0KKfzbTN/Bt1vQx24b+RomCUYGL3sUccRMO
 1dwZXSXF7IfrBaIEw/wB17WwrLJAcZDdpovzRoteFX4BiD615SYTfkNRyjN/nCv5ZvfXx86i
 z2IjxFGWTs/3+9I0Up5/7DKG3uFnRsxswBYK3ilVI36Cg1TzniDvpsdFC6MFX7eqTP1bxXKW 4K4=
In-Reply-To: <2024121243-perennial-coveting-b863@gregkh>

This is a multi-part message in MIME format.
--------------tn0XGAUH9758TAJ8z3vOiT6p
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 1:26 PM, Greg KH wrote:
> On Tue, Dec 10, 2024 at 12:05:00AM +0100, Michael Krause wrote:
>> On 12/3/24 3:45 PM, Salvatore Bonaccorso wrote:
>>> Paulo,
>>>
>>> On Tue, Dec 03, 2024 at 10:18:25AM -0300, Paulo Alcantara wrote:
>>>> Michael Krause <mk-debian@galax.is> writes:
>>>>
>>>>> On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
>>>>>> Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
>>>>>> in smb2_reconnect_server()") which seems in fact to solve the issue.
>>>>>>
>>>>>> Michael, can you please post your backport here for review from Paulo
>>>>>> and Steve?
>>>>>
>>>>> Of course, attached.
>>>>>
>>>>> Now I really hope I didn't screw it up :)
>>>>
>>>> LGTM.  Thanks Michael for the backport.
>>>
>>> Thanks a lot for the review. So to get it accepted it needs to be
>>> brough into the form which Greg can pick up. Michael can you do that
>>> and add your Signed-off line accordingly?
>> Happy to. Hope this is in the proper format:
> 
> It's corrupted somehow:
> 
> patching file fs/smb/client/connect.c
> patch: **** malformed patch at line 202:  		if (rc)
> 
> 
> Can you resend it or attach it?
> 
> thanks,
> 
> greg k-h

Ugh, how embarrassing. I'm sorry, I "fixed" some minor whitespace issue directly in the patch and apparently did something wrong.

I redid the white space fix before diffing again and attach and inline the new version. The chunks are a bit alternated to the earlier version now unfortunately. This one applies..






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
                  apply.]
Signed-off-by: Michael Krause <mk-debian@galax.is>
---
  fs/smb/client/connect.c | 80 ++++++++++++++++++-----------------------
  1 file changed, 35 insertions(+), 45 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 87ce71b39b77..20c50736456a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -259,7 +259,13 @@ cifs_mark_tcp_ses_conns_for_reconnect(st
  
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
@@ -1977,31 +1983,6 @@ out:
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
@@ -2035,35 +2016,44 @@ void cifs_put_smb_ses(struct cifs_ses *s
  {
  	unsigned int rc, xid;
  	unsigned int chan_count;
+	bool do_logoff;
+	struct cifs_tcon *tcon;
  	struct TCP_Server_Info *server = ses->server;
  
+	spin_lock(&cifs_tcp_ses_lock);
  	spin_lock(&ses->ses_lock);
-	if (ses->ses_status == SES_EXITING) {
+	cifs_dbg(FYI, "%s: id=0x%llx ses_count=%d ses_status=%u ipc=%s\n",
+		 __func__, ses->Suid, ses->ses_count, ses->ses_status,
+		 ses->tcon_ipc ? ses->tcon_ipc->tree_name : "none");
+	if (ses->ses_status == SES_EXITING || --ses->ses_count > 0) {
  		spin_unlock(&ses->ses_lock);
-		return;
-	}
-	spin_unlock(&ses->ses_lock);
-
-	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
-	cifs_dbg(FYI,
-		 "%s: ses ipc: %s\n", __func__, ses->tcon_ipc ? ses->tcon_ipc->tree_name : "NONE");
-
-	spin_lock(&cifs_tcp_ses_lock);
-	if (--ses->ses_count > 0) {
  		spin_unlock(&cifs_tcp_ses_lock);
  		return;
  	}
-	spin_unlock(&cifs_tcp_ses_lock);
-
  	/* ses_count can never go negative */
  	WARN_ON(ses->ses_count < 0);
  
-	if (ses->ses_status == SES_GOOD)
-		ses->ses_status = SES_EXITING;
-
-	cifs_free_ipc(ses);
+	spin_lock(&ses->chan_lock);
+	cifs_chan_clear_need_reconnect(ses, server);
+	spin_unlock(&ses->chan_lock);
+
+	do_logoff = ses->ses_status == SES_GOOD && server->ops->logoff;
+	ses->ses_status = SES_EXITING;
+	tcon = ses->tcon_ipc;
+	ses->tcon_ipc = NULL;
+ 	spin_unlock(&ses->ses_lock);
+	spin_unlock(&cifs_tcp_ses_lock);
  
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

--------------tn0XGAUH9758TAJ8z3vOiT6p
Content-Type: text/x-patch; charset=UTF-8;
 name="backport-6.1-smb-client-fix-UAF-in-smb2_reconnect_server.v2.patch"
Content-Disposition: attachment;
 filename*0="backport-6.1-smb-client-fix-UAF-in-smb2_reconnect_server.v2.";
 filename*1="patch"
Content-Transfer-Encoding: base64

RnJvbSA0MTFmYjYzOThmZTNjM2MwOGEwMDBkNzE3YmZmMTg5ZjA4ZDIwNDFjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsbyBBbGNhbnRhcmEgPHBjQG1hbmd1ZWJpdC5j
b20+CkRhdGU6IE1vbiwgMSBBcHIgMjAyNCAxNDoxMzoxMCAtMDMwMApTdWJqZWN0OiBbUEFU
Q0hdIHNtYjogY2xpZW50OiBmaXggVUFGIGluIHNtYjJfcmVjb25uZWN0X3NlcnZlcigpCgpj
b21taXQgMjRhOTc5OWFhOGVmZWNkMGViNTVhNzVlMzVmOWQ4ZTY0MDAwNjNhYSB1cHN0cmVh
bS4KClRoZSBVQUYgYnVnIGlzIGR1ZSB0byBzbWIyX3JlY29ubmVjdF9zZXJ2ZXIoKSBhY2Nl
c3NpbmcgYSBzZXNzaW9uIHRoYXQKaXMgYWxyZWFkeSBiZWluZyB0ZWFyZWQgZG93biBieSBh
bm90aGVyIHRocmVhZCB0aGF0IGlzIGV4ZWN1dGluZwpfX2NpZnNfcHV0X3NtYl9zZXMoKS4g
IFRoaXMgY2FuIGhhcHBlbiB3aGVuIChhKSB0aGUgY2xpZW50IGhhcwpjb25uZWN0aW9uIHRv
IHRoZSBzZXJ2ZXIgYnV0IG5vIHNlc3Npb24gb3IgKGIpIGFub3RoZXIgdGhyZWFkIGVuZHMg
dXAKc2V0dGluZyBAc2VzLT5zZXNfc3RhdHVzIGFnYWluIHRvIHNvbWV0aGluZyBkaWZmZXJl
bnQgdGhhbgpTRVNfRVhJVElORy4KClRvIGZpeCB0aGlzLCB3ZSBuZWVkIHRvIG1ha2Ugc3Vy
ZSB0byB1bmNvbmRpdGlvbmFsbHkgc2V0CkBzZXMtPnNlc19zdGF0dXMgdG8gU0VTX0VYSVRJ
TkcgYW5kIHByZXZlbnQgYW55IG90aGVyIHRocmVhZHMgZnJvbQpzZXR0aW5nIGEgbmV3IHN0
YXR1cyB3aGlsZSB3ZSdyZSBzdGlsbCB0ZWFyaW5nIGl0IGRvd24uCgpUaGUgZm9sbG93aW5n
IGNhbiBiZSByZXByb2R1Y2VkIGJ5IGFkZGluZyBzb21lIGRlbGF5IHRvIHJpZ2h0IGFmdGVy
CnRoZSBpcGMgaXMgZnJlZWQgaW4gX19jaWZzX3B1dF9zbWJfc2VzKCkgLSB3aGljaCB3aWxs
IGdpdmUKc21iMl9yZWNvbm5lY3Rfc2VydmVyKCkgd29ya2VyIGEgY2hhbmNlIHRvIHJ1biBh
bmQgdGhlbiBhY2Nlc3NpbmcKQHNlcy0+aXBjOgoKa2luaXQgLi4uCm1vdW50LmNpZnMgLy9z
cnYvc2hhcmUgL21udC8xIC1vIHNlYz1rcmI1LG5vaGFuZGxlY2FjaGUsZWNob19pbnRlcnZh
bD0xMApbZGlzY29ubmVjdCBzcnZdCmxzIC9tbnQvMSAmPi9kZXYvbnVsbApzbGVlcCAzMApr
ZGVzdHJveQpbcmVjb25uZWN0IHNydl0Kc2xlZXAgMTAKdW1vdW50IC9tbnQvMQouLi4KQ0lG
UzogVkZTOiBWZXJpZnkgdXNlciBoYXMgYSBrcmI1IHRpY2tldCBhbmQga2V5dXRpbHMgaXMg
aW5zdGFsbGVkCkNJRlM6IFZGUzogXFxzcnYgU2VuZCBlcnJvciBpbiBTZXNzU2V0dXAgPSAt
MTI2CkNJRlM6IFZGUzogVmVyaWZ5IHVzZXIgaGFzIGEga3JiNSB0aWNrZXQgYW5kIGtleXV0
aWxzIGlzIGluc3RhbGxlZApDSUZTOiBWRlM6IFxcc3J2IFNlbmQgZXJyb3IgaW4gU2Vzc1Nl
dHVwID0gLTEyNgpnZW5lcmFsIHByb3RlY3Rpb24gZmF1bHQsIHByb2JhYmx5IGZvciBub24t
Y2Fub25pY2FsIGFkZHJlc3MKMHg2YjZiNmI2YjZiNmI2YjZiOiAwMDAwIFsjMV0gUFJFRU1Q
VCBTTVAgTk9QVEkKQ1BVOiAzIFBJRDogNTAgQ29tbToga3dvcmtlci8zOjEgTm90IHRhaW50
ZWQgNi45LjAtcmMyICMxCkhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKFEzNSAr
IElDSDksIDIwMDkpLCBCSU9TIDEuMTYuMy0xLmZjMzkKMDQvMDEvMjAxNApXb3JrcXVldWU6
IGNpZnNpb2Qgc21iMl9yZWNvbm5lY3Rfc2VydmVyIFtjaWZzXQpSSVA6IDAwMTA6X19saXN0
X2RlbF9lbnRyeV92YWxpZF9vcl9yZXBvcnQrMHgzMy8weGYwCkNvZGU6IDRmIDA4IDQ4IDg1
IGQyIDc0IDQyIDQ4IDg1IGM5IDc0IDU5IDQ4IGI4IDAwIDAxIDAwIDAwIDAwIDAwIGFkCmRl
IDQ4IDM5IGMyIDc0IDYxIDQ4IGI4IDIyIDAxIDAwIDAwIDAwIDAwIDc0IDY5IDw0OD4gOGIg
MDEgNDggMzkgZjggNzUKN2IgNDggOGIgNzIgMDggNDggMzkgYzYgMGYgODUgODggMDAgMDAg
MDAgYjgKUlNQOiAwMDE4OmZmZmZjOTAwMDAxYmZkNzAgRUZMQUdTOiAwMDAxMGE4MwpSQVg6
IGRlYWQwMDAwMDAwMDAxMjIgUkJYOiBmZmZmODg4MTBkYTUzODM4IFJDWDogNmI2YjZiNmI2
YjZiNmI2YgpSRFg6IDZiNmI2YjZiNmI2YjZiNmIgUlNJOiBmZmZmZmZmZmMwMmY2ODc4IFJE
STogZmZmZjg4ODEwZGE1MzgwMApSQlA6IGZmZmY4ODgxMGRhNTM4MDAgUjA4OiAwMDAwMDAw
MDAwMDAwMDAxIFIwOTogMDAwMDAwMDAwMDAwMDAwMApSMTA6IDAwMDAwMDAwMDAwMDAwMDAg
UjExOiAwMDAwMDAwMDAwMDAwMDAxIFIxMjogZmZmZjg4ODEwYzA2NDAwMApSMTM6IDAwMDAw
MDAwMDAwMDAwMDEgUjE0OiBmZmZmODg4MTBjMDY0MDAwIFIxNTogZmZmZjg4ODEwMzljYzAw
MApGUzogMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODg4MTU3YzAwMDAwKDAwMDAp
CmtubEdTOjAwMDAwMDAwMDAwMDAwMDAKQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENS
MDogMDAwMDAwMDA4MDA1MDAzMwpDUjI6IDAwMDA3ZmUzNzI4YjEwMDAgQ1IzOiAwMDAwMDAw
MTBjYWE0MDAwIENSNDogMDAwMDAwMDAwMDc1MGVmMApQS1JVOiA1NTU1NTU1NApDYWxsIFRy
YWNlOgogPFRBU0s+CiA/IGRpZV9hZGRyKzB4MzYvMHg5MAogPyBleGNfZ2VuZXJhbF9wcm90
ZWN0aW9uKzB4MWMxLzB4M2YwCiA/IGFzbV9leGNfZ2VuZXJhbF9wcm90ZWN0aW9uKzB4MjYv
MHgzMAogPyBfX2xpc3RfZGVsX2VudHJ5X3ZhbGlkX29yX3JlcG9ydCsweDMzLzB4ZjAKIF9f
Y2lmc19wdXRfc21iX3NlcysweDFhZS8weDUwMCBbY2lmc10KIHNtYjJfcmVjb25uZWN0X3Nl
cnZlcisweDRlZC8weDcxMCBbY2lmc10KIHByb2Nlc3Nfb25lX3dvcmsrMHgyMDUvMHg2YjAK
IHdvcmtlcl90aHJlYWQrMHgxOTEvMHgzNjAKID8gX19wZnhfd29ya2VyX3RocmVhZCsweDEw
LzB4MTAKIGt0aHJlYWQrMHhlMi8weDExMAogPyBfX3BmeF9rdGhyZWFkKzB4MTAvMHgxMAog
cmV0X2Zyb21fZm9yaysweDM0LzB4NTAKID8gX19wZnhfa3RocmVhZCsweDEwLzB4MTAKIHJl
dF9mcm9tX2ZvcmtfYXNtKzB4MWEvMHgzMAogPC9UQVNLPgoKQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogUGF1bG8gQWxjYW50YXJhIChSZWQgSGF0KSA8cGNA
bWFuZ3VlYml0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgpbTWljaGFlbCBLcmF1c2U6IE5haXZlLCBtYW51YWwgbWVyZ2UgYmVj
YXVzZSB0aGUgM3JkIGh1bmsgd291bGQgbm90CiAgICAgICAgICAgICAgICAgYXBwbHkuXQpT
aWduZWQtb2ZmLWJ5OiBNaWNoYWVsIEtyYXVzZSA8bWstZGViaWFuQGdhbGF4LmlzPgotLS0K
IGZzL3NtYi9jbGllbnQvY29ubmVjdC5jIHwgODAgKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAzNSBpbnNlcnRpb25zKCspLCA0
NSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYyBi
L2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jCmluZGV4IDg3Y2U3MWIzOWI3Ny4uMjBjNTA3MzY0
NTZhIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYworKysgYi9mcy9zbWIv
Y2xpZW50L2Nvbm5lY3QuYwpAQCAtMjU5LDcgKzI1OSwxMyBAQCBjaWZzX21hcmtfdGNwX3Nl
c19jb25uc19mb3JfcmVjb25uZWN0KHN0CiAKIAlzcGluX2xvY2soJmNpZnNfdGNwX3Nlc19s
b2NrKTsKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoc2VzLCBuc2VzLCAmcHNlcnZlci0+
c21iX3Nlc19saXN0LCBzbWJfc2VzX2xpc3QpIHsKLQkJLyogY2hlY2sgaWYgaWZhY2UgaXMg
c3RpbGwgYWN0aXZlICovCisJCXNwaW5fbG9jaygmc2VzLT5zZXNfbG9jayk7CisJCWlmIChz
ZXMtPnNlc19zdGF0dXMgPT0gU0VTX0VYSVRJTkcpIHsKKwkJCXNwaW5fdW5sb2NrKCZzZXMt
PnNlc19sb2NrKTsKKwkJCWNvbnRpbnVlOworCQl9CisJCXNwaW5fdW5sb2NrKCZzZXMtPnNl
c19sb2NrKTsKKwogCQlzcGluX2xvY2soJnNlcy0+Y2hhbl9sb2NrKTsKIAkJaWYgKCFjaWZz
X2NoYW5faXNfaWZhY2VfYWN0aXZlKHNlcywgc2VydmVyKSkgewogCQkJc3Bpbl91bmxvY2so
JnNlcy0+Y2hhbl9sb2NrKTsKQEAgLTE5NzcsMzEgKzE5ODMsNiBAQCBvdXQ6CiAJcmV0dXJu
IHJjOwogfQogCi0vKioKLSAqIGNpZnNfZnJlZV9pcGMgLSBoZWxwZXIgdG8gcmVsZWFzZSB0
aGUgc2Vzc2lvbiBJUEMgdGNvbgotICogQHNlczogc21iIHNlc3Npb24gdG8gdW5tb3VudCB0
aGUgSVBDIGZyb20KLSAqCi0gKiBOZWVkcyB0byBiZSBjYWxsZWQgZXZlcnl0aW1lIGEgc2Vz
c2lvbiBpcyBkZXN0cm95ZWQuCi0gKgotICogT24gc2Vzc2lvbiBjbG9zZSwgdGhlIElQQyBp
cyBjbG9zZWQgYW5kIHRoZSBzZXJ2ZXIgbXVzdCByZWxlYXNlIGFsbCB0Y29ucyBvZiB0aGUg
c2Vzc2lvbi4KLSAqIE5vIG5lZWQgdG8gc2VuZCBhIHRyZWUgZGlzY29ubmVjdCBoZXJlLgot
ICoKLSAqIEJlc2lkZXMsIGl0IHdpbGwgbWFrZSB0aGUgc2VydmVyIHRvIG5vdCBjbG9zZSBk
dXJhYmxlIGFuZCByZXNpbGllbnQgZmlsZXMgb24gc2Vzc2lvbiBjbG9zZSwgYXMKLSAqIHNw
ZWNpZmllZCBpbiBNUy1TTUIyIDMuMy41LjYgUmVjZWl2aW5nIGFuIFNNQjIgTE9HT0ZGIFJl
cXVlc3QuCi0gKi8KLXN0YXRpYyBpbnQKLWNpZnNfZnJlZV9pcGMoc3RydWN0IGNpZnNfc2Vz
ICpzZXMpCi17Ci0Jc3RydWN0IGNpZnNfdGNvbiAqdGNvbiA9IHNlcy0+dGNvbl9pcGM7Ci0K
LQlpZiAodGNvbiA9PSBOVUxMKQotCQlyZXR1cm4gMDsKLQotCXRjb25JbmZvRnJlZSh0Y29u
KTsKLQlzZXMtPnRjb25faXBjID0gTlVMTDsKLQlyZXR1cm4gMDsKLX0KLQogc3RhdGljIHN0
cnVjdCBjaWZzX3NlcyAqCiBjaWZzX2ZpbmRfc21iX3NlcyhzdHJ1Y3QgVENQX1NlcnZlcl9J
bmZvICpzZXJ2ZXIsIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCkKIHsKQEAgLTIwMzUs
MzUgKzIwMTYsNDQgQEAgdm9pZCBjaWZzX3B1dF9zbWJfc2VzKHN0cnVjdCBjaWZzX3NlcyAq
cwogewogCXVuc2lnbmVkIGludCByYywgeGlkOwogCXVuc2lnbmVkIGludCBjaGFuX2NvdW50
OworCWJvb2wgZG9fbG9nb2ZmOworCXN0cnVjdCBjaWZzX3Rjb24gKnRjb247CiAJc3RydWN0
IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyID0gc2VzLT5zZXJ2ZXI7CiAKKwlzcGluX2xvY2so
JmNpZnNfdGNwX3Nlc19sb2NrKTsKIAlzcGluX2xvY2soJnNlcy0+c2VzX2xvY2spOwotCWlm
IChzZXMtPnNlc19zdGF0dXMgPT0gU0VTX0VYSVRJTkcpIHsKKwljaWZzX2RiZyhGWUksICIl
czogaWQ9MHglbGx4IHNlc19jb3VudD0lZCBzZXNfc3RhdHVzPSV1IGlwYz0lc1xuIiwKKwkJ
IF9fZnVuY19fLCBzZXMtPlN1aWQsIHNlcy0+c2VzX2NvdW50LCBzZXMtPnNlc19zdGF0dXMs
CisJCSBzZXMtPnRjb25faXBjID8gc2VzLT50Y29uX2lwYy0+dHJlZV9uYW1lIDogIm5vbmUi
KTsKKwlpZiAoc2VzLT5zZXNfc3RhdHVzID09IFNFU19FWElUSU5HIHx8IC0tc2VzLT5zZXNf
Y291bnQgPiAwKSB7CiAJCXNwaW5fdW5sb2NrKCZzZXMtPnNlc19sb2NrKTsKLQkJcmV0dXJu
OwotCX0KLQlzcGluX3VubG9jaygmc2VzLT5zZXNfbG9jayk7Ci0KLQljaWZzX2RiZyhGWUks
ICIlczogc2VzX2NvdW50PSVkXG4iLCBfX2Z1bmNfXywgc2VzLT5zZXNfY291bnQpOwotCWNp
ZnNfZGJnKEZZSSwKLQkJICIlczogc2VzIGlwYzogJXNcbiIsIF9fZnVuY19fLCBzZXMtPnRj
b25faXBjID8gc2VzLT50Y29uX2lwYy0+dHJlZV9uYW1lIDogIk5PTkUiKTsKLQotCXNwaW5f
bG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwotCWlmICgtLXNlcy0+c2VzX2NvdW50ID4gMCkg
ewogCQlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCQlyZXR1cm47CiAJfQot
CXNwaW5fdW5sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7Ci0KIAkvKiBzZXNfY291bnQgY2Fu
IG5ldmVyIGdvIG5lZ2F0aXZlICovCiAJV0FSTl9PTihzZXMtPnNlc19jb3VudCA8IDApOwog
Ci0JaWYgKHNlcy0+c2VzX3N0YXR1cyA9PSBTRVNfR09PRCkKLQkJc2VzLT5zZXNfc3RhdHVz
ID0gU0VTX0VYSVRJTkc7Ci0KLQljaWZzX2ZyZWVfaXBjKHNlcyk7CisJc3Bpbl9sb2NrKCZz
ZXMtPmNoYW5fbG9jayk7CisJY2lmc19jaGFuX2NsZWFyX25lZWRfcmVjb25uZWN0KHNlcywg
c2VydmVyKTsKKwlzcGluX3VubG9jaygmc2VzLT5jaGFuX2xvY2spOworCisJZG9fbG9nb2Zm
ID0gc2VzLT5zZXNfc3RhdHVzID09IFNFU19HT09EICYmIHNlcnZlci0+b3BzLT5sb2dvZmY7
CisJc2VzLT5zZXNfc3RhdHVzID0gU0VTX0VYSVRJTkc7CisJdGNvbiA9IHNlcy0+dGNvbl9p
cGM7CisJc2VzLT50Y29uX2lwYyA9IE5VTEw7CisgCXNwaW5fdW5sb2NrKCZzZXMtPnNlc19s
b2NrKTsKKwlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCi0JaWYgKHNlcy0+
c2VzX3N0YXR1cyA9PSBTRVNfRVhJVElORyAmJiBzZXJ2ZXItPm9wcy0+bG9nb2ZmKSB7CisJ
LyoKKwkgKiBPbiBzZXNzaW9uIGNsb3NlLCB0aGUgSVBDIGlzIGNsb3NlZCBhbmQgdGhlIHNl
cnZlciBtdXN0IHJlbGVhc2UgYWxsCisJICogdGNvbnMgb2YgdGhlIHNlc3Npb24uICBObyBu
ZWVkIHRvIHNlbmQgYSB0cmVlIGRpc2Nvbm5lY3QgaGVyZS4KKwkgKgorCSAqIEJlc2lkZXMs
IGl0IHdpbGwgbWFrZSB0aGUgc2VydmVyIHRvIG5vdCBjbG9zZSBkdXJhYmxlIGFuZCByZXNp
bGllbnQKKwkgKiBmaWxlcyBvbiBzZXNzaW9uIGNsb3NlLCBhcyBzcGVjaWZpZWQgaW4gTVMt
U01CMiAzLjMuNS42IFJlY2VpdmluZyBhbgorCSAqIFNNQjIgTE9HT0ZGIFJlcXVlc3QuCisJ
ICovCisJdGNvbkluZm9GcmVlKHRjb24pOworCWlmIChkb19sb2dvZmYpIHsKIAkJeGlkID0g
Z2V0X3hpZCgpOwogCQlyYyA9IHNlcnZlci0+b3BzLT5sb2dvZmYoeGlkLCBzZXMpOwogCQlp
ZiAocmMpCi0tIAoyLjQ1LjIKCg==

--------------tn0XGAUH9758TAJ8z3vOiT6p--
