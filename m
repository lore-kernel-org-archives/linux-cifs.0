From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] mtab: handle ENOSPC condition properly when altering
 mtab
Date: Tue, 12 Jul 2011 16:51:29 +0530
Message-ID: <4E1C2E39.1080009@suse.de>
References: <1310138300-6694-1-git-send-email-jlayton@samba.org>	<4E1BFE07.5060309@suse.de> <20110712065214.3ef1f906@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110712065214.3ef1f906-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/12/2011 04:22 PM, Jeff Layton wrote:
> On Tue, 12 Jul 2011 13:25:51 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> On 07/08/2011 08:48 PM, Jeff Layton wrote:
>>> It's possible that when mount.cifs goes to append the mtab that there
>>> won't be enough space to do so, and the mntent won't be appended to the
>>> file in its entirety.
>>>
>>> Add a my_endmntent routine that will fflush and then fsync the FILE if
>>> that succeeds. If either fails then it will truncate the file back to
>>> its provided size. It will then call endmntent unconditionally.
>>>
>>> Have add_mtab call fstat on the opened mtab file in order to get the
>>> size of the file before it has been appended. Assuming that that
>>> succeeds, use my_endmntent to ensure that the file is not corrupted
>>> before closing it. It's possible that we'll have a small race window
>>> where the mtab is incorrect, but it should be quickly corrected.
>>>
>>> This was reported some time ago as CVE-2011-1678:
>>>
>>>     http://openwall.com/lists/oss-security/2011/03/04/9
>>>
>>> ...and it seems to fix the reproducer that I was able to come up with.
>>>
>>> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>> ---
>>>  mount.cifs.c |   26 ++++++++++++++++++++++++--
>>>  mount.h      |    1 +
>>>  mtab.c       |   27 +++++++++++++++++++++++++++
>>>  3 files changed, 52 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mount.cifs.c b/mount.cifs.c
>>> index 9d7e107..2026329 100644
>>> --- a/mount.cifs.c
>>> +++ b/mount.cifs.c
>>> @@ -1428,10 +1428,11 @@ static int check_mtab(const char *progname, const char *devname,
>>>  static int
>>>  add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstype)
>>>  {
>>> -	int rc = 0;
>>> +	int rc = 0, tmprc, fd;
>>>  	uid_t uid;
>>>  	char *mount_user = NULL;
>>>  	struct mntent mountent;
>>> +	struct stat statbuf;
>>>  	FILE *pmntfile;
>>>  	sigset_t mask, oldmask;
>>>  
>>> @@ -1483,6 +1484,23 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
>>>  		goto add_mtab_exit;
>>>  	}
>>>  
>>> +	fd = fileno(pmntfile);
>>> +	if (fd < 0) {
>>> +		fprintf(stderr, "mntent does not appear to be valid\n");
>>> +		unlock_mtab();
>>> +		rc = EX_FILEIO;
>>> +		goto add_mtab_exit;
>>> +	}
>>> +
>>> +	rc = fstat(fd, &statbuf);
>>              ^^^ perhaps using fseek() + ftell() is little less
>> expensive as we just need the size?
>>
> 
> Is that really less expensive? That's two syscalls instead of just one.
> Also, this is not a particularly "hot" codepath. More modern distros
> are moving to symlinking /etc/mtab to /proc/mounts anyway. I consider
> the mtab handling to be "legacy" code to some degree. Worth fixing, but
> not worth expending a lot of effort on...

Hmm.. yes, as you say it is worth fixing without spending too much of
effort. Please ignore the above comment.

Infact, CERT recommends using fstat instead of fseek + ftell

https://www.securecoding.cert.org/confluence/display/seccode/FIO19-C.+Do+not+use+fseek%28%29+and+ftell%28%29+to+compute+the+size+of+a+file

> 
>> Also, now glibc has fixed addmntent() to do fflush() with:
>>   http://sourceware.org/git/?p=glibc.git;a=commitdiff;h=e1fb097f44
>>
>> Might be just sufficient to do a ftruncate() when addmntent() fails?
>>
> 
> Hmm...If addmntent fails will it ever leave the file in a half-written
> state? If so, then yes we probably need to ftruncate if that occurs too.

Yes, I think so. Though I have not tested it myself, I don't see why it
cannot leave half-written entries..

> FWIW, I'm not convinced though that fflush is enough here. That just
> flushes the userspace buffers to the kernel. There can be problems
> during writeback that can cause that to later fail, which is why I
> decided to make this also do an fsync.

Agreed.


-- 
Suresh Jayaraman
