From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for
 large dirs
Date: Tue, 2 Aug 2011 12:00:08 -0400
Message-ID: <20110802120008.3e19d193@tlielax.poochiereds.net>
References: <CAPwCz79UntBiAs4X+XSj62xvkpK0CW6cqQqhyCU97r4u5SmJ_g@mail.gmail.com>
	<20110802064455.0777c0fd@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Seiffert <kaffeemonster-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110802064455.0777c0fd-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2 Aug 2011 06:44:55 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 2 Aug 2011 02:30:35 +0200
> Jan Seiffert <kaffeemonster-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:
> 
> > Please CC, as not subscibed.
> > 
> > Looks like something broke CIFS.
> > Kernel 3.0.0 works, master after the CIFS merge does not ATM.
> > 
> > Example cifs mount is:
> > $ mount
> > ...
> > //server/portage on /usr/portage type cifs (rw,mand)
> > 
> > Server is:
> > $ smbd --version
> > Version 3.4.12
> > 
> > Actual Output is:
> > $ ls -l /usr/portage/ | wc -l
> > ls: reading directory /usr/portage/: input/output error
> > 1
> > $ ls -l /usr/portage/distfiles | wc -l
> > 105
> > 
> > Expected Output:
> > $ ls -l /usr/portage/ | wc -l
> > 170
> > $ ls -l /usr/portage/distfiles/ | wc -l
> > 47470
> > 
> > /usr/portage contains a lot of directories, /usr/portage/distfiles
> > contains lots of files.
> > 
> > A bisect in fs/cifs gives:
> > $ git bisect bad
> > c4d3396b261473ded6f370edd1e79ba34e089d7e is the first bad commit
> > commit c4d3396b261473ded6f370edd1e79ba34e089d7e
> > Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Date:   Tue Jul 26 12:20:18 2011 -0400
> > 
> >     cifs: advertise the right receive buffer size to the server
> > 
> >     Currently, we mirror the same size back to the server that it sends us.
> >     That makes little sense. Instead we should be sending the server the
> >     maximum buffer size that we can handle -- CIFSMaxBufSize minus the
> >     4 byte RFC1001 header.
> > 
> >     Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >     Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > 
> > :040000 040000 7a5015e0b47ca27538c4387a3b38470c86a42bae
> > c802cfda7d618f1073e45ce98efe65ce03cd0e79 M      fs
> > 
> > $ git bisect log
> > git bisect start '--' 'fs/cifs/'
> > # bad: [5f66d2b58ca879e70740c82422354144845d6dd3] Merge
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
> > git bisect bad 5f66d2b58ca879e70740c82422354144845d6dd3
> > # good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
> > git bisect good 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
> > # good: [3ca30d40a91fb9b9871e61d5dea2c1a895906a15] CIFS: Fix oops
> > while mounting with prefixpath
> > git bisect good 3ca30d40a91fb9b9871e61d5dea2c1a895906a15
> > # bad: [1f1cff0be05f59d5939edf28ff5ca0c6fd0a8e1c] cifs: trivial: goto
> > out here is unnecessary
> > git bisect bad 1f1cff0be05f59d5939edf28ff5ca0c6fd0a8e1c
> > # good: [e010a5ef95b8b6a12b74b548578f7dcf93564347] [CIFS] Redundant
> > null check after dereference
> > git bisect good e010a5ef95b8b6a12b74b548578f7dcf93564347
> > # good: [1d87c28e680ce4ecb8c260d8ce070b8339d52abb] Merge
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
> > git bisect good 1d87c28e680ce4ecb8c260d8ce070b8339d52abb
> > # bad: [c4d3396b261473ded6f370edd1e79ba34e089d7e] cifs: advertise the
> > right receive buffer size to the server
> > git bisect bad c4d3396b261473ded6f370edd1e79ba34e089d7e
> > 
> > A git revert of c4d3396b261473ded6f370edd1e79ba34e089d7e seems to resolve it.
> > 
> > If more info is needed, please let me know.
> 
> Thanks for the bug report. According to the spec, I think I was a
> *little* off in the calculation but not by much. CIFSMaxBufSize doesn't
> include the size of the header, so the value we're sending is too small
> by 0x58 bytes. But, if anything though that should have led to the
> server sending smaller frames than we can handle, which should not
> cause this sort of problem.
> 
> I tried to reproduce this on my test setup, but couldn't...
> 
> Some questions...
> 
> 1) did anything pop up in dmesg when this error occurred?
> 
> 2) are you setting the CIFSMaxBufSize module parm to anything?
> 
> 3) would it be possible to get debugging output? Instructions on how to
> do that are here:
> 
> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging
> 
> Thanks,

Nevermind... I was able to reproduce it, and the following patch seems
to fix it for me. Jan, can you test this as well? If so, I'll
"officially" send it to Steve and we'll get this in ASAP.

Long term, it would be better clean up the way CIFSMaxBufSize is
handled to get rid of this source of confusion...

-----------------[snip]-------------------

cifs: fix MaxBufferSize advertisement in session setup

Commit c4d3396b2 failed to account for the fact that CIFSMaxBufSize does
not include the size of the header. This means that we're advertising a
size that's 0x58 bytes smaller than the client can handle.

It's also problematic in the case of a large FIND_FIRST request. That
request will specify its own MaxDataCount value, which can turn out to
be larger than the originally provided MaxBufferSize. This causes the
server to break up the response into multiple pieces when it shouldn't
and throws off the checks in check2ndT2.

Fix this by adding the amount of the header to the maxBufSize that we
advertise to the server.

Reported-by: Jan Seiffert <kaffeemonster-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/sess.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 243d587..c7d80e2 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -124,8 +124,9 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses, SESSION_SETUP_ANDX *pSMB)
 	/*	that we use in next few lines                               */
 	/* Note that header is initialized to zero in header_assemble */
 	pSMB->req.AndXCommand = 0xFF;
-	pSMB->req.MaxBufferSize = cpu_to_le16(min_t(u32, CIFSMaxBufSize - 4,
-						USHRT_MAX));
+	pSMB->req.MaxBufferSize = cpu_to_le16(min_t(u32,
+					CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4,
+					USHRT_MAX));
 	pSMB->req.MaxMpxCount = cpu_to_le16(ses->server->maxReq);
 	pSMB->req.VcNumber = get_next_vcnum(ses);
 
-- 
1.7.6
