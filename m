From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 12/15] cifs: move close processing from cifs_close to
 cifsFileInfo_put
Date: Fri, 08 Oct 2010 15:04:47 +0530
Message-ID: <4CAEE5B7.3050805@suse.de>
References: <1286394857-32541-1-git-send-email-jlayton@redhat.com>	<1286394857-32541-13-git-send-email-jlayton@redhat.com>	<4CAD71A7.20808@suse.de> <20101007070726.0ef1b1a8@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101007070726.0ef1b1a8-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/07/2010 04:37 PM, Jeff Layton wrote:
> On Thu, 07 Oct 2010 12:37:19 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> On 10/07/2010 01:24 AM, Jeff Layton wrote:
>>> Now that it's feasible for a cifsFileInfo to outlive the filp under
>>> which it was created, move the close processing into cifsFileInfo_put.
>>>
>>> This means that the last user of the filehandle always does the actual
>>> on the wire close call. This also allows us to get rid of the closePend
>>> flag from cifsFileInfo. If we have an active reference to the file
>>> then it's never going to have a close pending.
>>>
>>> cifs_close is converted to simply put the filehandle.
>>>
>>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  fs/cifs/cifsglob.h |    1 -
>>>  fs/cifs/file.c     |  187 +++++++++++++++++-----------------------------------
>>>  fs/cifs/misc.c     |   10 ---
>>>  3 files changed, 60 insertions(+), 138 deletions(-)
>>>  
>>>  int cifs_open(struct inode *inode, struct file *file)
>>> @@ -542,79 +582,11 @@ reopen_error_exit:
>>>  
>>>  int cifs_close(struct inode *inode, struct file *file)
>>>  {
>>> -	int rc = 0;
>>> -	int xid, timeout;
>>> -	struct cifs_sb_info *cifs_sb;
>>> -	struct cifsTconInfo *pTcon;
>>> -	struct cifsFileInfo *pSMBFile = file->private_data;
>>> -
>>> -	xid = GetXid();
>>> -
>>> -	cifs_sb = CIFS_SB(inode->i_sb);
>>> -	pTcon = tlink_tcon(pSMBFile->tlink);
>>> -	if (pSMBFile) {
>>> -		struct cifsLockInfo *li, *tmp;
>>> -		write_lock(&cifs_file_list_lock);
>>> -		pSMBFile->closePend = true;
>>> -		if (pTcon) {
>>> -			/* no sense reconnecting to close a file that is
>>> -			   already closed */
>>> -			if (!pTcon->need_reconnect) {
>>> -				write_unlock(&cifs_file_list_lock);
>>> -				timeout = 2;
>>> -				while ((atomic_read(&pSMBFile->count) != 1)
>>
>> This portion of code which induces manual delay seems missing. While I'm
>> not sure about the practical significance of this code, explaining why
>> we do not need this in the change log would help?
>>
> 
> This is the part of the code that I was particularly keen to eliminate.
> 
> To my understanding the idea was that the code would set the closePend
> flag and then wait a "little while" until the count had gone to 0. The
> closePend flag would prevent the find_*_file interfaces from picking
> that filehandle, and the "little while" would help ensure that the
> current users of it would finish with it. Eventually though (in 2s) the
> code gives up and just destroys the cifsFileInfo anyway even though the
> refcount is still high.
> 
> Needless to say, that's not a particularly robust scheme. It's possible
> the refcount went high just before the server went offline but before
> closePend was set. 2s may not be enough to prevent a use-after-free.
> 
> It also had the problem that the actual users of the filehandle had to
> deal with the fact that the closePend flag could be set while they were
> using it. Then what do they do?
> 
> The patch I'm proposing moves this to a real refcounted scheme where
> the last user closes out the filehandle on the server. Far simpler and
> more certain not to cause these sorts of problems.

Sounds good and makes sense to me.


-- 
Suresh Jayaraman
