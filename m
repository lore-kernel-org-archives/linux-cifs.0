From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: oops in fscache code when running cifs with -o fsc
Date: Tue, 14 Jun 2011 17:29:55 +0530
Message-ID: <4DF74D3B.40804@suse.de>
References: <20110607142922.0816bfae@tlielax.poochiereds.net> <4DF10351.10309@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DF10351.10309-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/09/2011 11:00 PM, Suresh Jayaraman wrote:
> On 06/07/2011 11:59 PM, Jeff Layton wrote:
>> While toying with the idea of backporting and enabling fsc support in
>> RHEL6, I did some testing of the fsc code in 2.6.39. I mounted a
>> filesystem with the following mount options "sec=krb5i,multiuser,fsc".
>> I then logged in as an unprivileged user and got a krb5 ticket and ran
>> the fsstress program from LTP on the filesystem:
>>
>>     $ fsstress -d /mnt/cifs/fsstress -n1000 -p8 -l0
>>
>> ...a few seconds later, the box crashed with the following oopses. This
>> is easily reproducible, and seems to crash within a few seconds of
>> kicking off the program:
> 
> While trying to reproduce this issue, I'm seeing a "Bad page state in
> process fsstress" error. This error is due to page flag "PG_private_2"
> still being set for the page when we try to evict the inode. FS-Cache
> uses PG_private2 to indicate that the page is known to the cache.
> Though cifs_invalidate_page tries to uncache the page (by calling
> cifs_fscache_invalidate_page) it does not try to cancel writes that
> have not started. I think that is the problem here.

Here's a patch that fixes the "Bad page state" errors due to missing
invalidation of mapped pages seen during my testing. I suspect this
patch will fix the oops seen by Jeff too. Though the problem manifests
itself in different ways, I think the root cause remains the same.

Jeff: Could you please try this patch and see whether it fixes the issue
seen by you?


From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: invalidate any mapped pages before turning cache off

When disabling inode cookie, we were returning the cookie and setting
cifsi->fscache to NULL without invalidating any previously mapped pages. This
resulted in "Bad page state" errors and manifested in other kind of errors
when running fsstress. This patch fixes it by invalidating mapped pages while
disabling the inode cookie.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/fscache.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index d368a47..d2c268a 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -94,6 +94,10 @@ static void cifs_fscache_disable_inode_cookie(struct inode *inode)
 	if (cifsi->fscache) {
 		cFYI(1, "CIFS disabling inode cookie (0x%p)",
 				cifsi->fscache);
+		/* invalidate any mapped pages that were read in before */
+		if (inode->i_mapping && inode->i_mapping->nrpages)
+			invalidate_inode_pages2(inode->i_mapping);
+
 		fscache_relinquish_cookie(cifsi->fscache, 1);
 		cifsi->fscache = NULL;
 	}


> Here is a stack trace captured when the problem was reproducible:
> 
> [  890.729306] BUG: Bad page state in process fsstress  pfn:13ba8
> [  890.743297] page:ffffea0000450cc0 count:0 mapcount:0 mapping:          (null) index:0x150
> [  890.758439] page flags: 0x2000000000100c(referenced|uptodate|private_2)
> [  890.782264] Pid: 4780, comm: fsstress Not tainted 3.0.0-rc1-12-default+ #6
> [  890.793971] Call Trace:
> [  890.804777]  [<ffffffff810e93f3>] ? dump_page+0x93/0xd0
> [  890.817221]  [<ffffffff810e94f9>] bad_page+0xc9/0x120
> [  890.835998]  [<ffffffff810e960d>] free_pages_prepare+0xbd/0x100
> [  890.889885]  [<ffffffff810eac04>] free_hot_cold_page+0x44/0x470
> [  890.924965]  [<ffffffff810eb075>] __pagevec_free+0x45/0xa0
> [  890.928862]  [<ffffffff810ee6fd>] release_pages+0x20d/0x2c0
> [  890.938960]  [<ffffffff810eef61>] __pagevec_release+0x21/0x30
> [  890.952214]  [<ffffffff810ef88b>] truncate_inode_pages_range+0x1eb/0x450
> [  890.963341]  [<ffffffff810efb00>] truncate_inode_pages+0x10/0x20
> [  890.977037]  [<ffffffffa0363bea>] cifs_evict_inode+0x1a/0x40 [cifs]
> [  891.000547]  [<ffffffff8114c2eb>] evict+0x7b/0x150
> [  891.017301]  [<ffffffff8114c4ea>] iput+0xda/0x1a0
> [  891.024691]  [<ffffffff81149188>] d_kill+0xf8/0x130
> [  891.036880]  [<ffffffff81149bc2>] dput+0xc2/0x180
> [  891.044544]  [<ffffffff8113593f>] fput+0x15f/0x210
> [  891.047528]  [<ffffffff81131d41>] filp_close+0x61/0x90
> [  891.059951]  [<ffffffff81057220>] put_files_struct+0x80/0xf0
> [  891.070590]  [<ffffffff81057336>] exit_files+0x46/0x60
> [  891.081010]  [<ffffffff81057822>] do_exit+0x1a2/0x8a0
> [  891.088572]  [<ffffffff8105479e>] ? vprintk+0x24e/0x430
> [  891.095035]  [<ffffffff810581c1>] do_group_exit+0x51/0xc0
> [  891.112728]  [<ffffffff810679d5>] get_signal_to_deliver+0x225/0x460
> [  891.117800]  [<ffffffff81002070>] do_signal+0x70/0x790
> [  891.130115]  [<ffffffffa0381eda>] ? cifs_put_link+0x1a/0x20 [cifs]
> [  891.140693]  [<ffffffff81001707>] ? __switch_to+0x157/0x2f0
> [  891.164680]  [<ffffffff8142a57b>] ? schedule+0x3bb/0x900
> [  891.176570]  [<ffffffff81002805>] do_notify_resume+0x55/0x70
> [  891.198634]  [<ffffffff81434920>] int_signal+0x12/0x17
> [  891.205534] Disabling lock debugging due to kernel taint

-- 
Suresh Jayaraman
